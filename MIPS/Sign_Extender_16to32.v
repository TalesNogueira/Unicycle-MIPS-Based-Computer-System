module Sign_Extender_16to32 (data_in, data_out);
	input wire [15:0] data_in;
	
	output reg [31:0] data_out;
	
	always @(*)
		begin
			data_out = {{16{data_in[15]}}, data_in};
		end
endmodule 