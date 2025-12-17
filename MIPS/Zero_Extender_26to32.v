module Zero_Extender_26to32 (
	input [25:0] data_in,
	output wire [31:0] data_out
);

	assign data_out = {6'b0, data_in};
endmodule
