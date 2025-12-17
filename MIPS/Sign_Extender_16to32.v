module Sign_Extender_16to32 (
	input [15:0] data_in,
	output wire [31:0] data_out
);

	wire sign = data_in[15];
	wire [14:0] magnitude = data_in[14:0];
	wire [15:0] two_complement;
	
	assign two_complement = sign ? {sign, (~magnitude + 1'b1)} : {sign, magnitude};
	assign data_out = {{16{sign}}, two_complement};
endmodule
