module DoubleDabble32 (
	input [31:0] bin_in,
	output reg [31:0] bcd_out
);

	integer i;
	reg [31:0] abs_value;
	reg [63:0] shift_reg;
	
	always @(*) begin
		if (bin_in[31]) begin
			abs_value = ~bin_in + 1;
		end else begin
			abs_value = bin_in;
		end

		shift_reg = 0;
		shift_reg[31:0] = abs_value;

		for (i = 0; i < 32; i = i + 1) begin
			if (shift_reg[35:32] >= 5) shift_reg[35:32] = shift_reg[35:32] + 4'd3;
			if (shift_reg[39:36] >= 5) shift_reg[39:36] = shift_reg[39:36] + 4'd3;
			if (shift_reg[43:40] >= 5) shift_reg[43:40] = shift_reg[43:40] + 4'd3;
			if (shift_reg[47:44] >= 5) shift_reg[47:44] = shift_reg[47:44] + 4'd3;
			if (shift_reg[51:48] >= 5) shift_reg[51:48] = shift_reg[51:48] + 4'd3;
			if (shift_reg[55:52] >= 5) shift_reg[55:52] = shift_reg[55:52] + 4'd3;
			if (shift_reg[59:56] >= 5) shift_reg[59:56] = shift_reg[59:56] + 4'd3;
			if (shift_reg[63:60] >= 5) shift_reg[63:60] = shift_reg[63:60] + 4'd3;

			shift_reg = shift_reg << 1;
		end

		bcd_out[31:28] = shift_reg[63:60];
		bcd_out[27:24] = shift_reg[59:56];
		bcd_out[23:20] = shift_reg[55:52];
		bcd_out[19:16] = shift_reg[51:48];
		bcd_out[15:12] = shift_reg[47:44];
		bcd_out[11:8]  = shift_reg[43:40];
		bcd_out[7:4]   = shift_reg[39:36];
		bcd_out[3:0]   = shift_reg[35:32];
	end
endmodule