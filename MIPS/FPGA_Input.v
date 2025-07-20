module FPGA_Input (input wire FLAG_input,
						 input wire switch_15, input wire switch_14, input wire switch_13, input wire switch_12,
						 input wire switch_11, input wire switch_10, input wire switch_9, input wire switch_8, 
						 input wire switch_7, input wire switch_6, input wire switch_5, input wire switch_4,
						 input wire switch_3, input wire switch_2, input wire switch_1, input wire switch_0,
						 input wire push_input_confirm, input wire clk,
						 output reg [15:0] FPGA_input, output reg FPGA_input_confirm);		 	
	 
	reg [15:0] debounce_counter = 0;
   reg btn_sync_A = 1;
   reg btn_sync_B = 1;
   reg btn_stable = 1;
   reg btn_prev = 1;
	 
   wire btn_falling_edge;
	
	always @(posedge clk) begin
      btn_sync_A <= push_input_confirm;
      btn_sync_B <= btn_sync_A;
   end
	
	always @(posedge clk) begin
        if (btn_sync_B != btn_stable) begin
            debounce_counter <= debounce_counter + 1;
            if (debounce_counter >= 50000) begin
                btn_stable <= btn_sync_B;
                debounce_counter <= 0;
            end
        end else begin
            debounce_counter <= 0;
        end
    end
	
	assign btn_falling_edge = (btn_prev == 1 && btn_stable == 0);

   always @(posedge clk) begin
        btn_prev <= btn_stable;
   end
	
	always @(posedge clk) begin
		FPGA_input <= {
			 switch_15, switch_14, switch_13, switch_12,
			 switch_11, switch_10, switch_9,  switch_8,
			 switch_7,  switch_6,  switch_5,  switch_4,
			 switch_3,  switch_2,  switch_1,  switch_0
		};
		
		if (FLAG_input) begin
			if (btn_falling_edge) begin
            FPGA_input_confirm <= 1;
			end
		end else begin
			FPGA_input_confirm <= 0;
		end
	end 
endmodule 