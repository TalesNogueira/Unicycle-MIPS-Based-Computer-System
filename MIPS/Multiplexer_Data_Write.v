module Multiplexer_Data_Write (data_ULA, data_memory, PC_current, data_input, MUX_write, data_write);
	input [31:0]data_ULA;
	input [31:0]data_memory;
	input [31:0]PC_current;
	input [31:0]data_input;
	
	input [1:0]MUX_write;
	
	output reg [31:0]data_write;
	
	always @(*)
		begin
			case(MUX_write)
				0:
					data_write = data_ULA;
				1:
					data_write = data_memory;
				2:
					data_write = PC_current + 1;
				3:
					data_write = data_input;
			endcase
		end
endmodule 