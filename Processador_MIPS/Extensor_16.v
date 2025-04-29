module Extensor_16 (imediato_tam16, imediato);

	input [15:0]imediato_tam16; //Entrada do IMEDIATO com tamanho de 16 bits
	output reg [31:0]imediato;  //Saida de IMEDIATO de 32 bits
	
	always @(*)
	begin
		if(imediato_tam16[15]) begin
			imediato = {16'b1111111111111111,imediato_tam16};
		end else begin
			imediato = {16'b0000000000000000,imediato_tam16};
		end
	end
endmodule 