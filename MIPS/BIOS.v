module BIOS #(
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 10
)(
	input clock,
	input [DATA_WIDTH-1:0] PC,
	output reg [DATA_WIDTH-1:0] instruction
);

	reg [DATA_WIDTH-1:0] bios[2**ADDR_WIDTH-1:0];

	initial begin
		$readmemb("biosfirmware.txt", bios);
	end

	always @ (negedge clock) begin
		instruction <= bios[PC];
	end
endmodule