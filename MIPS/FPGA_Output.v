module FPGA_Output (input wire FLAG_output, input wire [31:0] FPGA_output, output reg [31:0] decimal, output reg negative);
    reg [31:0] abs_value;
    reg [63:0] shift_reg;
	 
	 integer i;
	 
    always @(*) begin
		 if (FLAG_output) begin
			  if (FPGA_output[31] == 1) begin
					abs_value = ~FPGA_output + 1;
					negative <= 1;
			  end else begin
					abs_value = FPGA_output;
					negative <= 0;
			  end

			  shift_reg = 64'd0;
			  shift_reg[31:0] = abs_value;

			  for (i = 0; i < 32; i = i + 1) begin
					if (shift_reg[35:32] >= 5) shift_reg[35:32] = shift_reg[35:32] + 3;
					if (shift_reg[39:36] >= 5) shift_reg[39:36] = shift_reg[39:36] + 3;
					if (shift_reg[43:40] >= 5) shift_reg[43:40] = shift_reg[43:40] + 3;
					if (shift_reg[47:44] >= 5) shift_reg[47:44] = shift_reg[47:44] + 3;
					if (shift_reg[51:48] >= 5) shift_reg[51:48] = shift_reg[51:48] + 3;
					if (shift_reg[55:52] >= 5) shift_reg[55:52] = shift_reg[55:52] + 3;
					if (shift_reg[59:56] >= 5) shift_reg[59:56] = shift_reg[59:56] + 3;
					if (shift_reg[63:60] >= 5) shift_reg[63:60] = shift_reg[63:60] + 3;

					shift_reg = shift_reg << 1;
			  end

			  decimal[31:28] <= shift_reg[63:60];
			  decimal[27:24] <= shift_reg[59:56];
			  decimal[23:20] <= shift_reg[55:52];
			  decimal[19:16] <= shift_reg[51:48];
			  decimal[15:12] <= shift_reg[47:44];
			  decimal[11:8]  <= shift_reg[43:40];
			  decimal[7:4]   <= shift_reg[39:36];
			  decimal[3:0]   <= shift_reg[35:32];
		 end else begin
			i = 0;
			decimal   <= 0;
			abs_value <= 0;
			negative  <= 0;
			shift_reg <= 0;
		 end
	 end
endmodule 