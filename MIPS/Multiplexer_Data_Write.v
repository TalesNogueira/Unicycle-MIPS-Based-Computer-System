module Multiplexer_Data_Write (input wire [31:0] data_ULA, input wire [31:0] data_memory, input wire [31:0] PC_current, input wire [31:0] data_input, input wire [1:0] MUX_write, output reg [31:0] data_write);
	always @(*) begin
		case(MUX_write)
			0:
				data_write <= data_ULA;
			1:
				data_write <= data_memory;
			2:
				data_write <= PC_current + 1;
			3:
				data_write <= data_input;
		endcase
	end
endmodule 