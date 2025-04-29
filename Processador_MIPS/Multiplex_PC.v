module Multiplex_PC (PC, imediato, endereco, dado_1, mux_PC, novo_PC);
	
	input [31:0]PC;				//Entrada do PC
	input [31:0]imediato;		//Entrada do IMEDIATO
	input [31:0]endereco;		//Entrada do ENDERECO
	input [31:0]dado_1;			//Entrada do DADO 1
	input	[1:0]mux_PC;			//Entrada do CONTROLADOR
	output reg [31:0]novo_PC;	//Saida do novo valor para PC
	
	always @(*)
	begin
		case(mux_PC)
			0:
				novo_PC = PC + 1;									//CASO 0: PC = PC + 1
			1:
				novo_PC = PC + 1 + $signed(imediato);		//CASO 1: PC = PC + 1 + IMEDIATO
			2:
				novo_PC = endereco;								//CASO 2: PC = ENDERECO
			3:
				novo_PC = dado_1;									//CASO 3: PC = R[s]
		endcase
	end	
endmodule 