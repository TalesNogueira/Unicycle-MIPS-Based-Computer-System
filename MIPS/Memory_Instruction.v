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
	reg [31:0] rom[49:0];

	initial
	begin
		//$readmemb("software.txt", rom);
		
		//TIPOS DE INSTRUCOES:
		//rom[0] <= 32'b000000_00000_00000_00000_00000_000000; //Tipo R
		//rom[0] <= 32'b000000_00000_00000_0000000000000000; 	 //Tipo I
		//rom[0] <= 32'b000000_00000000000000000000000000; 	 //Tipo J
	end

	always @ (posedge clk)
	begin
		instruction <= rom[addr];
	end

endmodule 