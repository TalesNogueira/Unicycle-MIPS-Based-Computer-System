module Entrada (entrada, controle_entrada, nova_entrada);
	
	input [31:0]entrada;					//Entrada do dado para input
	input controle_entrada;				//Entrada do CONTROLE de input
	output reg [31:0]nova_entrada;	//Saida do input
	
	always @(*)
		begin
			if(controle_entrada) nova_entrada = entrada;
			else nova_entrada = 0;
		end
	
endmodule 