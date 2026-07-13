module UART_RX #(
	parameter CLKS_PER_BIT = 5208    // 5208 = 50000000/9600 (Hz/baud)
)(
	input  clk, reset,
	input  rx,

	output reg [31:0] data_UART      // Palavra de 32 bits montada (frequencia)
);

	reg rx_meta, rx_sync;

	localparam S_IDLE  = 2'd0;
	localparam S_START = 2'd1;
	localparam S_DATA  = 2'd2;
	localparam S_STOP  = 2'd3;

	reg [1:0]  state = S_IDLE;
	reg [12:0] clk_count = 0;			// Conta ciclos dentro de um bit (CLKS_PER_BIT)
	reg [2:0]  bit_index = 0;
	reg [7:0]  rx_byte;					// Byte que esta sendo recebido bit a bit

	// --- Montagem do frame [0xAA][b3][b2][b1][b0] ---
	localparam HEADER = 8'hAA;
	reg        collecting = 0;			// 0: esperando header ; 1: coletando os 4 bytes
	reg [1:0]  byte_count = 0;			// Qual dos 4 bytes estamos coletando (0..3)
	reg [31:0] acc = 0;					// Acumula os bytes ate a palavra ficar completa

	initial begin
		data_UART = 32'd0;
		rx_byte   = 8'd0;
	end

	always @(posedge clk) begin
		rx_meta <= rx;
		rx_sync <= rx_meta;
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state      <= S_IDLE;
			clk_count  <= 0;
			bit_index  <= 0;
			rx_byte    <= 8'd0;
			data_UART  <= 32'd0;
			collecting <= 0;
			byte_count <= 0;
			acc        <= 0;
		end else begin
			case (state)
				// Espera a linha cair (start bit = 0). Em repouso a UART fica em 1.
				S_IDLE: begin
					clk_count <= 0;
					bit_index <= 0;
					if (rx_sync == 1'b0)
						state <= S_START;
				end

				// Confirma o start bit no meio dele (evita ruido/glitch).
				S_START: begin
					if (clk_count == (CLKS_PER_BIT-1)/2) begin
						if (rx_sync == 1'b0) begin
							clk_count <= 0;      // Alinha o "meio de bit" para os dados
							state     <= S_DATA;
						end else begin
							state <= S_IDLE;     // Foi glitch, aborta
						end
					end else begin
						clk_count <= clk_count + 1'b1;
					end
				end

				// Amostra 8 bits de dados, LSB primeiro, sempre no meio do bit.
				S_DATA: begin
					if (clk_count < CLKS_PER_BIT-1) begin
						clk_count <= clk_count + 1'b1;
					end else begin
						clk_count        <= 0;
						rx_byte[bit_index] <= rx_sync;
						if (bit_index < 7) begin
							bit_index <= bit_index + 1'b1;
						end else begin
							bit_index <= 0;
							state     <= S_STOP;
						end
					end
				end

				// Byte completo: aqui entra a montagem do frame de 32 bits.
				S_STOP: begin
					if (clk_count < CLKS_PER_BIT-1) begin
						clk_count <= clk_count + 1'b1;
					end else begin
						clk_count <= 0;
						state     <= S_IDLE;

						if (!collecting) begin
							// Ainda esperando o header: so avanca se o byte for 0xAA.
							if (rx_byte == HEADER) begin
								collecting <= 1;
								byte_count <= 0;
							end
						end else begin
							// Coletando os 4 bytes (big-endian: primeiro = mais significativo).
							if (byte_count == 2'd3) begin
								// 4o byte (LSB): fecha a palavra (ultimo valor latcheado).
								data_UART  <= {acc[23:0], rx_byte};
								collecting <= 0;
							end else begin
								// Desliza o byte para dentro do acumulador.
								acc        <= {acc[23:0], rx_byte};
								byte_count <= byte_count + 1'b1;
							end
						end
					end
				end

				default: state <= S_IDLE;
			endcase
		end
	end
endmodule
