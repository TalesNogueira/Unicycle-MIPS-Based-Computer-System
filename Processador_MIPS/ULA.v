module ULA (dado_1, dado_ULA, shamt, controle_ULA, resultado_ULA, zero);

	input [31:0]dado_1;					//Entrada do DADO 1
	input [31:0]dado_ULA;				//Entrada do DADO 2 ou IMEDIATO
	input [4:0]shamt;						//Entrada do Shamt
	input [3:0]controle_ULA;			//Entrada do CONTROLADOR
	output reg [31:0]resultado_ULA;	//Saida do resultado da ULA
	output reg zero;						//Flag zero
	
	initial
		begin
			zero = 0;
			resultado_ULA = 0;
		end
	
	always @(*)
	begin
		case(controle_ULA)
			4'b0001:		//Move o DADO_1, ou seja, R[d] <- R[s] - move
				begin
					resultado_ULA = dado_1;
					zero = 0;
				end
			
			4'b0010:		//Move o IMEDIATO, ou seja, R[t] <- IMD - movei
				begin
					resultado_ULA = dado_ULA;
					zero = 0;
				end
				
			4'b0100:		//Soma com sinais - add, addi, load, store
				begin
					resultado_ULA = $signed(dado_1) + $signed(dado_ULA);
					zero = 0;
				end
				
			4'b0101:		//Subtracao com sinais - sub, subi
				begin
					resultado_ULA = $signed(dado_1) - $signed(dado_ULA);
					zero = 0;
				end
				
			4'b0110:		//Multiplicacao com sinais - mult
				begin
					resultado_ULA = $signed(dado_1) * $signed(dado_ULA);
					zero = 0;
				end
				
			4'b0111:		//Divisao com sinais - div
				begin
					if(dado_ULA == 32'd0) resultado_ULA = 32'd0;	//Divisão por 0
					else resultado_ULA = $signed(dado_1) / $signed(dado_ULA);
					zero = 0;
				end
				
			4'b1000:		//AND entre os dados - and, andi
				begin
					resultado_ULA = (dado_1 && dado_ULA);
					zero = 0;
				end
				
			4'b1001:		//OR entre os dados - or, ori
				begin
					resultado_ULA = (dado_1 || dado_ULA);
					zero = 0;
				end
				
			4'b1010:		//NOT do DADO_1 - not
				begin
					resultado_ULA = !(dado_1);
					zero = 0;
				end
				
			4'b1011:		//XOR entre os dados - xor
				begin
					resultado_ULA = (dado_1 ^ dado_ULA);
					zero = 0;
				end
				
			4'b1100:		//Se DADO_1 for igual a DADO_ULA, 1, caso contrário, 0 - beq, set
				begin
					if($signed(dado_1) == $signed(dado_ULA)) begin
							resultado_ULA = 32'd1;
							zero = 1;
					end else begin
							resultado_ULA = 32'd0;
							zero = 0;
					end
				end
				
			4'b0011:		//Se DADO_1 for diferente a DADO_ULA, 1, caso contrário, 0 - bne
				begin
					if($signed(dado_1) != $signed(dado_ULA)) begin
							resultado_ULA = 32'd1;
							zero = 1;
					end else begin
							resultado_ULA = 32'd0;
							zero = 0;
					end
				end
				
			4'b1101:		//Se DADO_1 for menor que DADO_ULA, 1, caso contrário, 0 - slt
				begin
						if($signed(dado_1) < $signed(dado_ULA)) begin
								resultado_ULA = 32'd1;
								zero = 1;
						end else begin
								resultado_ULA = 32'd0;
								zero = 0;
						end
					end

			4'b1110:		//Desloca DADO_1 para esquerda em SHAMT bits - sll
				begin
					resultado_ULA = (dado_1 <<< shamt); 
					zero = 0;
				end
				
			4'b1111:		//Desloca DADO_1 para direita em SHAMT bits - srl
				begin
					resultado_ULA = (dado_1 >>> shamt);
					zero = 0;
				end
				
			default:
				begin
					resultado_ULA = 32'd0;
					zero = 0;
				end
		endcase
	end
endmodule 