module Seven_Segments_Display (
	input [31:0] IO_output,
	input negative,
	input [31:0] PC_current,
	
	input FLAG_input,
	input FLAG_output,
	
	output reg [6:0] display_7,
	output reg [6:0] display_6,
	output reg [6:0] display_5,
	output reg [6:0] display_4,
	output reg [6:0] display_3,
	output reg [6:0] display_2,
	output reg [6:0] display_1,
	output reg [6:0] display_0
);
	
	wire [31:0] bcd_output;

	DoubleDabble32 dd32_output (
		.bin_in(IO_output),
		.bcd_out(bcd_output)
	);

	wire [31:0] bcd_pc;
	
	DoubleDabble32 dd32_pc (
		.bin_in(PC_current),
		.bcd_out(bcd_pc)
	);

	function [6:0] segment_decoder;
		input [3:0] value;		  
		case (value)
			4'd0: segment_decoder = 7'b1000000;
			4'd1: segment_decoder = 7'b1111001;
			4'd2: segment_decoder = 7'b0100100;
			4'd3: segment_decoder = 7'b0110000;
			4'd4: segment_decoder = 7'b0011001;
			4'd5: segment_decoder = 7'b0010010;
			4'd6: segment_decoder = 7'b0000010;
			4'd7: segment_decoder = 7'b1111000;
			4'd8: segment_decoder = 7'b0000000;
			4'd9: segment_decoder = 7'b0010000;
			default:
				segment_decoder = 7'b1111111;
		endcase
	endfunction
	
	always @(*) begin
		if (FLAG_input || FLAG_output) begin
			display_7 <= negative ? 7'b0111111 : segment_decoder(bcd_output[31:28]);
			display_6 <= segment_decoder(bcd_output[27:24]);
			display_5 <= segment_decoder(bcd_output[23:20]);
			display_4 <= segment_decoder(bcd_output[19:16]);
			display_3 <= segment_decoder(bcd_output[15:12]);
			display_2 <= segment_decoder(bcd_output[11:8]);
			display_1 <= segment_decoder(bcd_output[7:4]);
			display_0 <= segment_decoder(bcd_output[3:0]);
		end else begin
			display_7 <= segment_decoder(bcd_pc[15:12]);
			display_6 <= segment_decoder(bcd_pc[11:8]);
			display_5 <= segment_decoder(bcd_pc[7:4]);
			display_4 <= segment_decoder(bcd_pc[3:0]);
			
			display_3 <= 7'b0111111;
			display_2 <= 7'b0111111;
			display_1 <= 7'b0111111;
			display_0 <= 7'b0111111;
		end
	end
endmodule 