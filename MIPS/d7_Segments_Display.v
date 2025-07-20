module d7_Segments_Display (
    input wire clk,
    input wire FLAG_output,
	 input wire [31:0] PC_current,
    input wire [31:0] decimal,
    output reg [6:0] d7_7,
    output reg [6:0] d7_6,
    output reg [6:0] d7_5,
    output reg [6:0] d7_4,
    output reg [6:0] d7_3,
    output reg [6:0] d7_2,
    output reg [6:0] d7_1,
    output reg [6:0] d7_0);

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
            default: segment_decoder = 7'b1111111;
        endcase
    endfunction

    function [3:0] get_digit;
        input [31:0] value;
        input [2:0] index;
        integer i;
        reg [31:0] temp;
        begin
            temp = value;
            for (i = 0; i < index; i = i + 1)
                temp = temp / 10;
            get_digit = temp % 10;
        end
    endfunction

	 reg [6:0] d7_save_3 = 7'b0111111;
	 reg [6:0] d7_save_2 = 7'b0111111;
	 reg [6:0] d7_save_1 = 7'b0111111;
	 reg [6:0] d7_save_0 = 7'b0111111;
	
	initial begin
		d7_7 = 7'b1000000;
		d7_6 = 7'b1000000;
		d7_5 = 7'b0111111;
		d7_4 = 7'b0111111;
		d7_3 = 7'b0111111;
		d7_2 = 7'b0111111;
		d7_1 = 7'b0111111;
		d7_0 = 7'b0111111;
	end
	
	always @(negedge clk) begin
		if(FLAG_output) begin
			d7_7 = segment_decoder(decimal[31:28]);
			d7_6 = segment_decoder(decimal[27:24]);
			d7_5 = segment_decoder(decimal[23:20]);
			d7_4 = segment_decoder(decimal[19:16]);
			d7_3 = segment_decoder(decimal[15:12]);
			d7_2 = segment_decoder(decimal[11:8]);
			d7_1 = segment_decoder(decimal[7:4]);
			d7_0 = segment_decoder(decimal[3:0]);
			
			d7_save_3 = d7_3;
			d7_save_2 = d7_2;
			d7_save_1 = d7_1;
			d7_save_0 = d7_0;
		end else begin
			d7_7 = segment_decoder(get_digit(PC_current, 1));
			d7_6 = segment_decoder(get_digit(PC_current, 0));  
			d7_5 = 7'b0111111;
			d7_4 = 7'b0111111;
			d7_3 = d7_save_3;
			d7_2 = d7_save_2;
			d7_1 = d7_save_1;
			d7_0 = d7_save_0;
		end
	end
endmodule 