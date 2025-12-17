module MUX_Data_Write (
	input [31:0] data_ULA,
	input [31:0] data_MEM,	
	input [31:0] data_IO,
	input [31:0] data_HD,
	input [31:0] PC_current,
	input [2:0] MUX_write,
	output [31:0] data_write
);

	assign data_write = (MUX_write == 2'd0) ? data_ULA :
							  (MUX_write == 2'd1) ? data_MEM :
							  (MUX_write == 2'd2) ? (PC_current + 1) :
							  (MUX_write == 2'd3) ? data_IO : data_HD;
endmodule 