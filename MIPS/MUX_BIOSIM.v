module MUX_BIOSIM (
	input clock, reset,
	input [31:0] BIOS_instruction,
	input [31:0] IM_instruction,
	input FLAG_biosim,
	output [31:0] instruction,
	output biosim_status
);
	
	reg biosim;
	
	initial begin
		biosim = 0;
	end

	always @(negedge clock or posedge reset) begin
		if (reset)
			biosim <= 0;
		else if (FLAG_biosim)
			biosim <= !biosim;
	end

		assign instruction = (biosim) ? IM_instruction : BIOS_instruction ;
		assign biosim_status = !biosim; 
endmodule 