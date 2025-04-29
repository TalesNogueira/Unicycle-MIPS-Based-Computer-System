module Multiplex_OperandoESCRITA (resultado_ULA, memoria_dados, dado_entrada, mux_ESCRITA, dado_escrita);

	input [31:0]resultado_ULA;			//Entrada do DADO do resultado da ULA
	input [31:0]memoria_dados;			//Entrada do DADO da memoria de dados
	input [31:0]dado_entrada;			//Entrada do DADO do input
	input [1:0]mux_ESCRITA;				//Entrada do CONTROLADOR
	output reg [31:0]dado_escrita;	//Saida do DADO que sera escrito
	
	always @(*)
		begin
			case(mux_ESCRITA)
				0:
					dado_escrita = resultado_ULA;
				1:
					dado_escrita = memoria_dados;
				2:
					dado_escrita = dado_entrada;
			endcase
		end
endmodule 