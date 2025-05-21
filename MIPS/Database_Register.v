module Database_Register (addr_src, addr_tgt, addr_write, data_write, clk, FLAG_register, data_src, data_tgt);
	input [4:0]addr_src;		// R[s]
	input [4:0]addr_tgt;		// R[t]
	
	input [4:0]addr_write;	// Address to be written
	input [31:0]data_write;	// Data to be written
	
	input FLAG_register;					// Flag to write into register or not
	
	input clk;
	
	output signed [31:0]data_src;		// Data from Register[Source]
	output signed [31:0]data_tgt;		// Data from Register[Target]
	
	reg [31:0]register[31:0];			// Register Database (32x32)
	
	initial register[32'd0] = 0;
	
	always @(posedge clk)
	begin
		if(FLAG_register) register[addr_write] = data_write;
	end
	
	assign data_src = register[addr_src];
	assign data_tgt = register[addr_tgt];
endmodule 