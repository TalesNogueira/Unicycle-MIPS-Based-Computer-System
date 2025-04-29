module PC (novo_PC, clock, PC);

	input [31:0]novo_PC;	//Entrada do novo valor para PC
	input clock;			//Entrada do CLOCK
	output reg [31:0]PC;	//Saida do PC
	
	always @(negedge clock)
		begin
			PC <= novo_PC;		//PC = novo_PC
		end
endmodule 