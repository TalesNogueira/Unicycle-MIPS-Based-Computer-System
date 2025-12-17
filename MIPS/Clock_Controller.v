module Clock_Controller #(
	 parameter COUNTER_WIDTH = 18, // Approximately 1 second
	 parameter DEBOUNCER_WIDTH = 16,
	 parameter LCD_WIDTH
)(
	input switch_hold, push_confirm,
	input clk, reset, 
	input halt, lcd_done, interrupt,
	input FLAG_input, FLAG_output, FLAG_lcd,
	output reg clock, clock_status
);

	wire edge_confirm;

	Debouncer #(
		.N(DEBOUNCER_WIDTH)
	) debouncer_io (
		.clk(clk),
		.push_in(push_confirm),
		.falling_edge(edge_confirm)
	);
	
	wire edge_LCD;

	Debouncer #(
		.N(LCD_WIDTH-2)
	) debouncer_lcd (
		.clk(clk),
		.push_in(lcd_done),
		.falling_edge(edge_LCD)
	);
	
	reg [COUNTER_WIDTH-1:0] counter = 0;
	reg [31:0] jumps = 0;

	wire stop = halt 			||
					switch_hold ||
					FLAG_input 	||
					FLAG_output ||
					interrupt;
					
	initial begin
		clock = 0;
		clock_status = 0;
	end

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			clock <= 0;
			clock_status <= 0;
			counter <= 0;
			jumps <= 2;
		end else begin
			if ((FLAG_lcd) && (!jumps)) begin
				if (edge_LCD) begin
					jumps <= 2;
				end
				clock_status <= 1;
			end else if ((stop) && (!jumps)) begin
				if (edge_confirm) begin
					jumps <= 2;
				end
				clock_status <= 1;
			end else begin
				if (counter >= {COUNTER_WIDTH{1'b1}}) begin
					 counter <= 0;
					 clock <= ~clock;
					 clock_status <= ~clock_status;
					 if (jumps > 0)
						jumps <= jumps - 1;
				end else begin
					 counter <= counter + 1'b1;
				end
			end
		end
	end
endmodule 