module MUX_Data_ULA (
	input [31:0] data_tgt,
	input [31:0] imediate,
	input MUX_ULA,
	output [31:0] data_tgtImd
);
	
	assign data_tgtImd = (MUX_ULA == 0) ? data_tgt : imediate;
endmodule 