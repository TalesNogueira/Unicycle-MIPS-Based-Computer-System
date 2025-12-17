module Clock_Divisor #(
    parameter COUNTER_WIDTH = 20
)(
    input  clk_in,
    output reg clk_out
);

	reg [COUNTER_WIDTH-1:0] count;

	always @(posedge clk_in) begin
		if (count >= {COUNTER_WIDTH{1'b1}}) begin
			count   <= 0;
			clk_out <= ~clk_out;
		end else begin
			count <= count + 1'b1;
		end
	end
endmodule