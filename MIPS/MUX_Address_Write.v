module MUX_Address_Write (
	input [4:0] addr_tgt,
	input [4:0] addr_dst,
	input [1:0] MUX_register,
	output [4:0] addr_write
);

	assign addr_write = (MUX_register == 0) ? addr_dst :
							  (MUX_register == 1) ? addr_tgt :
							  (MUX_register == 2) ? 5'd31 : 5'd0;
endmodule 