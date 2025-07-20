// Quartus Prime Verilog Template
// Single Port ROM

module Memory_Instruction
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk,
 
	output reg [(DATA_WIDTH-1):0] instruction
);

	// Declare the ROM variable
	reg [31:0] rom[299:0];

	initial
	begin
		$readmemb("instructions.mem", rom);
	end

	always @ (posedge clk)
	begin
		instruction <= rom[addr];
	end

endmodule 