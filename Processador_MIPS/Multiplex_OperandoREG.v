module Multiplex_OperandoREG (endereco_2, endereco_3, mux_REGISTRADOR, endereco_escrita);

	input [4:0]endereco_2;					//Entrada do ENDERECO por R[t]
	input [4:0]endereco_3;					//Entrada do ENDERECO por R[d]
	input [1:0]mux_REGISTRADOR;			//Entrada do CONTROLADOR
	output reg [4:0]endereco_escrita;	//Saida do ENDERECO de escrita
	
	always @(*)
	begin
		case(mux_REGISTRADOR)
			0:
				endereco_escrita = 0;
			1:
				endereco_escrita = endereco_2;
			2:
				endereco_escrita = endereco_3;
		endcase
	end
endmodule 