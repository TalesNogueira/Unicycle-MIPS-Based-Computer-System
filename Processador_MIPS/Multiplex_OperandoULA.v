module Multiplex_OperandoULA (dado_2, imediato, mux_ULA, dado_ULA);

	input [31:0]dado_2;				//Entrada do DADO 2
	input [31:0]imediato;			//Entrada do IMEDIATO
	input mux_ULA;						//Entrada do CONTROLADOR
	output reg [31:0]dado_ULA;		//Saida do DADO ULA
	
	always @(*)
	begin
		case(mux_ULA)
			0:
				dado_ULA = dado_2;
			1:
				dado_ULA = imediato;
		endcase
	end
endmodule 