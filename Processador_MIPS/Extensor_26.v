module Extensor_26 (endereco_tam26, endereco);

	input [25:0]endereco_tam26; //Entrada do ENDERECO de 26 bits
	output reg [31:0]endereco;	 //Saida de ENDERECO 32 bits
	
	always @(*)
	begin
		endereco = {6'b000000,endereco_tam26};
	end
endmodule 