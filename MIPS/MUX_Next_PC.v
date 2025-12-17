module MUX_Next_PC (
	input [31:0] PC_current,
	input [31:0] immediate,
	input [31:0] address,
	input [31:0] data,
	input [31:0] PC_so,
	input	[2:0] MUX_PC,	
	output [31:0] PC_next
);
	
	assign PC_next = (MUX_PC == 0) ? (PC_current + 1) :
						  (MUX_PC == 1) ? immediate :
						  (MUX_PC == 2) ? address :
						  (MUX_PC == 3) ? data : PC_so;
endmodule 