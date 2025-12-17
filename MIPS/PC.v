module PC (
	input clock, reset,
	input [31:0] PC_next,
	output reg [31:0] PC_current
);

	initial begin
		PC_current = 0;
	end

	always @(negedge clock or posedge reset) begin
		if (reset)
			PC_current <= 0;
		 else
			PC_current <= PC_next;
	end
endmodule
 