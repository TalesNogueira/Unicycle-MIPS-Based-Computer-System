// Quartus Prime Verilog Template
// Single Port ROM

module Memoria_Instrucao
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, 
	output reg [(DATA_WIDTH-1):0] q
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
		
		//FIBONACCI:
		
		rom[0] <= 32'b000011_00000_00101_0000000000000101;		//movei
		rom[1] <= 32'b000011_00000_00001_0000000000000001;		//movei
		rom[2] <= 32'b000011_00000_00010_0000000000000001;		//movei
		rom[3] <= 32'b000000_00001_00010_00011_00000_000100;	//add
		rom[4] <= 32'b000000_00010_00000_00001_00000_000011;	//move
		rom[5] <= 32'b000000_00011_00000_00010_00000_000011;	//move
		rom[6] <= 32'b000000_00001_00000_00000_00000_000010;	//out
		rom[7] <= 32'b000000_00010_00000_00000_00000_000010;	//out
		rom[8] <= 32'b000010_00000_00011_0000000000000010;		//store
		rom[9] <= 32'b000001_00000_00100_0000000000000010;		//load
		rom[10] <= 32'b000000_00100_00000_00000_00000_000010;	//out
		rom[11] <= 32'b000000_00101_00000_00000_00000_000010;	//out
		rom[12] <= 32'b001101_00100_00101_1111111111110110;	//bne
		rom[13] <= 32'b010000_00000000000000000000001101;		//jump
	end

	always @ (posedge clk)
	begin
		q <= rom[addr];
	end

endmodule
