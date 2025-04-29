module Saida (dado_1, controle_saida, saida);

	input [31:0]dado_1;		//Entrada do dado para output
	input controle_saida;	//Entrada do CONTROLE de output
	output reg [31:0]saida;	//Saida do output
	
	
	always @(*)
		begin
			if(controle_saida) saida = dado_1;
			else saida = 0;
		end
		
endmodule 