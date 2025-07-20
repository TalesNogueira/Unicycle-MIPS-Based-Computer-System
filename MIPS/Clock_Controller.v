module Clock_Controller (input wire clk_50, input wire switch_hold, input wire push_manual_clock, input wire FLAG_input, input wire FPGA_input_confirm, input wire halt, output reg clock, output reg clock_status);
	reg [26:0] counter = 0;
	
	reg [15:0] debounce_counter = 0;
	reg button_sync_A = 1;
   reg button_sync_B = 1;
   reg button_stable = 1;
   reg button_prev = 1;
	
	wire button_falling_edge;
	
	initial begin
		counter = 0;
		clock_status = 0;
	end
	
	always @(posedge clk_50) begin
        button_sync_A <= push_manual_clock;
        button_sync_B <= button_sync_A;
   end
	 
	always @(posedge clk_50) begin
		if (button_sync_B != button_stable) begin
			debounce_counter <= debounce_counter + 1;
			
			if (debounce_counter >= 50000) begin // ≈1 ms
				button_stable <= button_sync_B;
				debounce_counter <= 0;
			end
		end else begin
			debounce_counter <= 0;
		end
   end
	
	assign button_falling_edge = (button_prev == 1 && button_stable == 0);
	
	always @(posedge clk_50) begin
        button_prev <= button_stable;
   end

	always @(posedge clk_50) begin
		if (halt) begin
			clock_status <= 1;
		end else begin
			if (FLAG_input && !FPGA_input_confirm) begin
				clock_status <= 1;
			end else begin
				if (switch_hold == 1) begin
					counter <= 0;
					if (button_falling_edge) begin
						 clock <= 1;
						 clock_status <= 1;
					end else begin
						 clock <= 0;
						 clock_status <= 0;
					end
				end else begin
					if (counter >= 3000000 - 1) begin
						 counter <= 0;
						 clock <= ~clock;
						 clock_status <= ~clock_status;
					end else begin
						 counter <= counter + 1;
					end
				end
			end
		end
	end
endmodule 