// Quartus Prime Verilog Template
// Single Port RAM with single read/write address 

module Memory_Data
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32)
(
	input [(ADDR_WIDTH-1):0] addr,
	input [(DATA_WIDTH-1):0] data,
	input we, clk,
	output [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [31:0] ram[999:0];

	// Variable to hold the registered read address
	reg [31:0] addr_reg;
	
	initial begin
		integer i;
		for (i = 0; i < 1000; i = i + 1) begin
			ram[i] = 32'd0;
		end
	end
	
	always @ (negedge clk)
	begin
		// Write
		if (we)
			ram[addr] <= data;

		addr_reg <= addr;
	end

	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign q = ram[addr_reg];
endmodule 