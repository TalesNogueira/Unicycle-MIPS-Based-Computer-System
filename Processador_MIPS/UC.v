module UC (instrucao, zero, controle_entrada, controle_saida, controle_ULA, controle_memoriaDADOS, controle_REGISTRADOR, mux_PC, mux_ULA, mux_REGISTRADOR, mux_ESCRITA);

	input [31:0]instrucao;					//Entrada da INSTRUCAO
	input zero;									//Entrada da flag ZERO
	output reg controle_entrada;			//Saida do CONTROLADOR do input
	output reg controle_saida;				//Saida do CONTROLADOR do output
	output reg [3:0]controle_ULA;			//Saida do CONTROLADOR da ULA
	output reg controle_memoriaDADOS;	//Saida do CONTROLADOR da memoria de dados
	output reg controle_REGISTRADOR;		//Saida do CONTROLADOR do banco de registradores
	output reg [1:0]mux_PC;					//Saida do CONTROLADOR do mult do PC
	output reg mux_ULA;						//Saida do CONTROLADOR do mult da ULA
	output reg [1:0]mux_REGISTRADOR;		//Saida do CONTROLADOR do mult do endereco de escrita
	output reg [1:0]mux_ESCRITA;			//Saida do CONTROLADOR do mult do dado de escrita

	initial begin
		controle_entrada = 0;
		controle_saida = 0;
		controle_ULA = 0;
		controle_memoriaDADOS = 0;
		controle_REGISTRADOR = 0;
		mux_PC = 0;
		mux_ULA = 0;
		mux_REGISTRADOR = 0;
		mux_ESCRITA = 0;
	end
	
	always @(instrucao)
	begin
		if(instrucao[31:26]==6'b000000 && instrucao[5:0]==6'b000001) controle_entrada = 1'b1;
		else controle_entrada = 1'b0;	//Define se há ou nao input
		
		if(instrucao[31:26]==6'b000000 && instrucao[5:0]==6'b000010) controle_saida = 1'b1;
		else controle_saida = 1'b0;	//Define se há ou nao output
	end
	
	always @(*)
	case(instrucao[31:26])
	6'b000000:							//Especifico do Tipo R, o "real" OPCODE está na FUNCT logo abaixo
		case(instrucao[5:0])	
		6'b000001:				//Comando: in
			begin
				controle_ULA = 0;					//Codigo da ULA: R[d] toma INPUT
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 2;					//INPUT para escrever no banco de registradores
			end
		6'b000010:				//Comando: out
			begin
				controle_ULA = 0;					//Codigo da ULA: OUTPUT toma R[s]
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 0;		//NAO escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 0;				//Sem endereco para escrever, ou seja, "registrador[0]" ou "R[0]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b000011:				//Comando: move
			begin
				controle_ULA = 4'b0001;			//Codigo da ULA: Mover Registrador
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b000100:				//Comando: add
			begin
				controle_ULA = 4'b0100;			//Codigo da ULA: Soma
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b000101:				//Comando: sub
			begin
				controle_ULA = 4'b0101;			//Codigo da ULA: Subtracao
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b000110:				//Comando: mult
			begin
				controle_ULA = 4'b0110;			//Codigo da ULA: Multiplicacao
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b000111:				//Comando: div
			begin
				controle_ULA = 4'b0111;			//Codigo da ULA: Divisao
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b001000:				//Comando: and
			begin
				controle_ULA = 4'b1000;			//Codigo da ULA: AND
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b001001:				//Comando: or
			begin
				controle_ULA = 4'b1001;			//Codigo da ULA: OR
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b001010:				//Comando: not
			begin
				controle_ULA = 4'b1010;			//Codigo da ULA: NOT
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b001011:				//Comando: xor
			begin
				controle_ULA = 4'b1011;			//Codigo da ULA: XOR
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b001100:				//Comando: set (Igual que)
			begin
				controle_ULA = 4'b1100;			//Codigo da ULA: DADO 1 == DADO 2
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b001101:				//Comando: slt (Menor que)
			begin
				controle_ULA = 4'b1101;			//Codigo da ULA: DADO 1 < DADO 2
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b001110:				//Comando: sll (Desloca para esquerda)
			begin
				controle_ULA = 4'b1110;			//Codigo da ULA: Desloca DADO 1 p/ esquerda em SHAMT bits
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b001111:				//Comando: srl (Desloca para direita)
			begin
				controle_ULA = 4'b1111;			//Codigo da ULA: Desloca DADO 1 p/ direita em SHAMT bits
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 2;				//Utilizando ENDERECO 3 para escrever, ou seja, "registrador[endereco_3]" ou "R[d]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		6'b010000:				//Comando: jr (Jump to REGISTRADOR)
			begin
				controle_ULA = 0;					//Codigo da ULA: Default
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 0;		//NAO escrevendo no banco de registrador
				mux_PC = 3;							//SIM salta, PC toma DADO existente em "registrador[endereco_leitura1]" ou "R[s]"
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 0;				//Sem endereco para escrever, ou seja, "registrador[0]" ou "R[0]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		default:					//Blank - Normalmente comeco do código, nao realiza nenhuma funcao
			begin
				controle_ULA = 0;					//Codigo da ULA: Default
				controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
				controle_REGISTRADOR = 0;		//NAO escrevendo no banco de registrador
				mux_PC = 0;							//NAO salta, PC toma PC + 1
				mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
				mux_REGISTRADOR = 0;				//Sem endereco para escrever, ou seja, "registrador[0]" ou "R[0]"
				mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			end
		endcase
	6'b000001:							//Comando: load
		begin
			controle_ULA = 4'b0100;			//Codigo da ULA: Soma
			controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
			controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
			mux_PC = 0;							//NAO salta, PC toma PC + 1
			mux_ULA = 1;						//DADO_ULA toma IMEDIATO na ULA
			mux_REGISTRADOR = 1;				//Utilizando ENDERECO 2 para escrever, ou seja, "registrador[endereco_2]" ou "R[t]"
			mux_ESCRITA = 1;					//Dado da Memoria para escrever no banco de registradores
		end
	6'b000010:							//Comando: store
		begin
			controle_ULA = 4'b0100;			//Codigo da ULA: Soma
			controle_memoriaDADOS = 1;		//SIM escrevendo na memoria de dados
			controle_REGISTRADOR = 0;		//NAO escrevendo no banco de registrador
			mux_PC = 0;							//NAO salta, PC toma PC + 1
			mux_ULA = 1;						//DADO_ULA toma IMEDIATO na ULA
			mux_REGISTRADOR = 0;				//Sem endereco para escrever, ou seja, "registrador[0]" ou "R[0]"
			mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
		end
	6'b000011:							//Comando: movei
		begin
			controle_ULA = 4'b0010;			//Codigo da ULA: Mover IMEDIATO
			controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
			controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
			mux_PC = 0;							//NAO salta, PC toma PC + 1
			mux_ULA = 1;						//DADO_ULA toma IMEDIATO na ULA
			mux_REGISTRADOR = 1;				//Utilizando ENDERECO 2 para escrever, ou seja, "registrador[endereco_2]" ou "R[t]"
			mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
		end
	6'b000100:							//Comando: addi
		begin
			controle_ULA = 4'b0100;			//Codigo da ULA: Soma
			controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
			controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
			mux_PC = 0;							//NAO salta, PC toma PC + 1
			mux_ULA = 1;						//DADO_ULA toma IMEDIATO na ULA
			mux_REGISTRADOR = 1;				//Utilizando ENDERECO 2 para escrever, ou seja, "registrador[endereco_2]" ou "R[t]"
			mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
		end
	6'b000101:							//Comando: subi
		begin
			controle_ULA = 4'b0101;			//Codigo da ULA: Subtracao
			controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
			controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
			mux_PC = 0;							//NAO salta, PC toma PC + 1
			mux_ULA = 1;						//DADO_ULA toma IMEDIATO na ULA
			mux_REGISTRADOR = 1;				//Utilizando ENDERECO 2 para escrever, ou seja, "registrador[endereco_2]" ou "R[t]"
			mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
		end
	6'b001000:							//Comando: andi
		begin
			controle_ULA = 4'b1000;			//Codigo da ULA: AND
			controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
			controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
			mux_PC = 0;							//NAO salta, PC toma PC + 1
			mux_ULA = 1;						//DADO_ULA toma IMEDIATO na ULA
			mux_REGISTRADOR = 1;				//Utilizando ENDERECO 2 para escrever, ou seja, "registrador[endereco_2]" ou "R[t]"
			mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
		end
	6'b001001:							//Comando: ori
		begin
			controle_ULA = 4'b1001;			//Codigo da ULA: OR
			controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
			controle_REGISTRADOR = 1;		//SIM escrevendo no banco de registrador
			mux_PC = 0;							//NAO salta, PC toma PC + 1
			mux_ULA = 1;						//DADO_ULA toma IMEDIATO na ULA
			mux_REGISTRADOR = 1;				//Utilizando ENDERECO 2 para escrever, ou seja, "registrador[endereco_2]" ou "R[t]"
			mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
		end	
	6'b001100:							//Comando: beq
		begin
			controle_ULA = 4'b1100;			//Codigo da ULA: DADO 1 == DADO 2, PC toma PC + 1 + IMD
			controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
			controle_REGISTRADOR = 0;		//NAO escrevendo no banco de registrador
			mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
			mux_REGISTRADOR = 0;				//Sem endereco para escrever, ou seja, "registrador[0]" ou "R[0]"
			mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			if(zero)				mux_PC = 1;		//SIM salta, PC toma PC + 1
			else if(!zero)	 	mux_PC = 0;		//NAO salta, PC toma PC + 1 + IMEDIATO
		end
	6'b001101:							//Comando: bne
		begin
			controle_ULA = 4'b0011;			//Codigo da ULA: DADO 1 != DADO 2, PC toma PC + 1 + IMD
			controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
			controle_REGISTRADOR = 0;		//NAO escrevendo no banco de registrador
			mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
			mux_REGISTRADOR = 0;				//Sem endereco para escrever, ou seja, "registrador[0]" ou "R[0]"
			mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
			if(zero)				mux_PC = 1;		//SIM salta, PC toma PC + 1
			else if(!zero)	 	mux_PC = 0;		//NAO salta, PC toma PC + 1 + IMEDIATO
		end
	6'b010000:							//Comando: j (Jump to ENDERECO)
		begin
			controle_ULA = 0;					//Codigo da ULA: Default
			controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
			controle_REGISTRADOR = 0;		//NAO escrevendo no banco de registrador
			mux_PC = 2;							//SIM salta, PC toma o IMEDIATO dado por ENDERECO
			mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
			mux_REGISTRADOR = 0;				//Sem endereco para escrever, ou seja, "registrador[0]" ou "R[0]"
			mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
		end
	default:								//Blank - Normalmente comeco do código, nao realiza nenhuma funcao
		begin
			controle_ULA = 0;					//Codigo da ULA: Default
			controle_memoriaDADOS = 0;		//NAO escrevendo na memoria de dados
			controle_REGISTRADOR = 0;		//NAO escrevendo no banco de registrador
			mux_PC = 0;							//NAO salta, PC toma PC + 1
			mux_ULA = 0;						//DADO_ULA toma DADO 2 na ULA
			mux_REGISTRADOR = 0;				//Sem endereco para escrever, ou seja, "registrador[0]" ou "R[0]"
			mux_ESCRITA = 0;					//Resultado da ULA para escrever no banco de registradores
		end
	endcase		
endmodule 