module Timer (
	input clock, reset,
	input [31:0] quantum,
	input FLAG_timer,
	input halt,
	input finish,
	input FLAG_input,
	input FLAG_output,
	input FLAG_IMoffset,
	output reg interrupt
);

	reg [31:0] max_timer = 0;
	reg [31:0] timer = 0;
	
	reg status = 0;
	
	wire skip = halt ||
				FLAG_input ||
				FLAG_output ||
				FLAG_IMoffset;
				
	initial begin
		interrupt = 0;
	end

	always @(negedge clock or posedge reset) begin
		if (reset) begin
			max_timer <= 0;
			timer 	 <= 0;
			status 	 <= 0;
			interrupt <= 1'b0;
		end else begin
			if (FLAG_timer) begin
				max_timer <= quantum;
				timer 	 <= 0;
				status 	 <= 1;
				interrupt <= 1'b0;
			end else if (interrupt) begin
				max_timer <= 0;
				timer 	 <= 0;
				interrupt <= 1'b0;
				status 	 <= 0;
			end else if ((max_timer != 0 && timer >= max_timer && !skip) || finish) begin
				timer 	 <= 0;
				if (status) interrupt <= 1'b1;
			end else begin
				timer <= timer + 1'b1;
			end
		end
	end
endmodule 