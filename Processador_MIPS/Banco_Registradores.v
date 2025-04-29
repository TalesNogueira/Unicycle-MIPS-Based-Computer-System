module Banco_Registradores (endereco_1, endereco_2, endereco_escrita, dado_escrita, clock, controle_REGISTRADOR, dado_1, dado_2);
	
	input [4:0]endereco_1;			//Entrada do ENDERECO do registrador 1 (R[s])
	input [4:0]endereco_2;			//Entrada do ENDERECO do registrador 2 (R[t])
	input [4:0]endereco_escrita;	//Entrada do ENDERECO do registrador (R[t]/R[d])
	input [31:0]dado_escrita;		//Entrada do DADO a ser escrito
	input clock;						//Entrada do CLOCK
	input controle_REGISTRADOR;	//Entrada do CONTROLADOR
	output signed [31:0]dado_1;	//Saida do DADO 1 a ser utilizado
	output signed [31:0]dado_2;	//Saida do DADO 2 a ser utilizado
	
	reg [31:0]registrador[31:0];	//Banco de 32x32 Registradores (REGISTRADOR)
	
	initial registrador[32'd0] = 0;
	
	always @(posedge clock)
	begin
		if(controle_REGISTRADOR) registrador[endereco_escrita] = dado_escrita;
	end
	
	assign dado_1 = registrador[endereco_1];
	assign dado_2 = registrador[endereco_2];
endmodule 