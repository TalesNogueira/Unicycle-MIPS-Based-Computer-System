module PC (input wire [31:0] PC_next, input wire clk, output reg [31:0] PC_current);
	initial begin
		PC_current = 0;
	end
	
	always @(posedge clk) begin
				PC_current <= PC_next;
	end
endmodule 