module IO (
	input [15:0] switches,
	input [31:0] data_src,
	
	input clk,
	input FLAG_input,
	input FLAG_output,
	
	output reg signed [31:0] IO_input,
	output reg [31:0] IO_output,
	output reg negative
);
	
	wire [31:0] extended_switches;
	
	Sign_Extender_16to32 sign_extender_inst (
		.data_in(switches),
		.data_out(extended_switches)
	);

	always @(posedge clk) begin
		if (FLAG_input) begin
			IO_input <= extended_switches;
			IO_output <= switches[15] ? (~extended_switches + 1'b1) : extended_switches;
			negative <= switches[15];
		end else if (FLAG_output) begin
			IO_output <= data_src[31] ? (~data_src + 1'b1) : data_src;
			negative <= data_src[31];
		end
	end
endmodule