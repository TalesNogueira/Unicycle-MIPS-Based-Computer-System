module Zero_Extender_26to32 (input wire [25:0] data_in, output reg [31:0] data_out);
	always @(*) begin
			data_out = {6'b000000, data_in};
	end
endmodule 