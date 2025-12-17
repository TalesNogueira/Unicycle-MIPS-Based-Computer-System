module Debouncer #(
	parameter N = 16	// Parameter N indicates the filter duration
)(
	input clk,
	input push_in,
	output reg falling_edge
);
	
   reg [N-1:0] counter = 0;
   reg btn_sync_A = 1, btn_sync_B = 1, btn_stable = 1;
	reg btn_prev = 1;

	always @(posedge clk) begin
		btn_sync_A <= push_in;
		btn_sync_B <= btn_sync_A;

		if (btn_sync_B != btn_stable) begin
			if (counter >= {N{1'b1}}) begin
				btn_stable <= btn_sync_B;
				counter <= 0;
			end else begin
				counter <= counter + 1'b1;
			end
		end else begin
			counter <= 0;
		end
		
		falling_edge <= (btn_prev == 1 && btn_stable == 0);
		
      btn_prev <= btn_stable;
	end
endmodule
