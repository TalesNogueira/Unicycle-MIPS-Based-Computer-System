module PC (PC_next, halt, clk, PC_current);
	input wire [31:0] PC_next;
	input wire halt;
	input wire clk;
	
	output reg [31:0] PC_current;
	
	always @(negedge clk)
		begin
			if(!halt) 
				PC_current <= PC_next;
		end
endmodule 