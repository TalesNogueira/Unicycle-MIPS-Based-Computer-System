module Multiplexer_PC (input [31:0] PC_current, input [31:0] address, input [31:0] immediate, input	[1:0] MUX_PC, input [31:0] data, output reg [31:0] PC_next);
	always @(*) begin
		case(MUX_PC)
			0:
				PC_next = PC_current + 1;
			1:
				PC_next = immediate;
			2:
				PC_next = address;
			3:
				PC_next = data;
		endcase
	end	
endmodule 