module UC (
	input [31:0]instruction,
	input zero,
	input interrupt,
	
	output reg [4:0]opcode_ULA,
	
	output reg MUX_ULA,
	output reg [2:0]MUX_PC,
	output reg [2:0]MUX_write,
	output reg [1:0]MUX_register,

	output reg FLAG_biosim,
	output reg FLAG_hd,
	output reg FLAG_instr,
	output reg FLAG_memory,
	output reg FLAG_register,
	output reg FLAG_start,
	output reg FLAG_IMoffset,
	output reg FLAG_DMoffset,
	output reg FLAG_input, FLAG_output,
	output reg FLAG_lcd,
	output reg FLAG_timer,
	output reg halt,
	output reg finish
);
	
	
	initial begin
		opcode_ULA = 0;
		
		MUX_PC = 0;				/*	MUX_PC
										0: PC + 1
										1: PC + 1 + IMD
										2: address
										3: data 	(R[rs])
										4: PC_so (R[so])
									*/
		MUX_ULA = 0;			/*	MUX_ULA
										0: R[rt]
										1: IMD
									*/
		MUX_register = 0;		/*	MUX_register
										0: R[rd]
										1: R[rt]
										2: R[31] (PC Register)
									*/
		MUX_write = 0;			/*	MUX_write
										0: ULA
										1: memory
										2: PC_current
										3: input
										4: data_HD
									*/
		
		// FLAG'S --------------------------------------------------------------------------------------------
		FLAG_biosim = 0;		/*	FLAG_biosim
										1: Change from BIOS to IM, and viceversa
									*/
		FLAG_hd = 0;			/*	FLAG_hd
										1: Write into HD
									*/
		FLAG_instr = 0;		/*	FLAG_instr
										1: Write into Instruction Memory
									*/
		FLAG_memory = 0;		/*	FLAG_memory
										1: Write into Data Memory
									*/
		FLAG_register = 0;	/*	FLAG_register
										1: Write into Register DB
									*/
		FLAG_start = 0;		/*	FLAG_start
										1: Reset offset registers values ($gp, $sp, $fp)
									*/
		FLAG_IMoffset   = 0;	/*	FLAG_IMoffset
										1: Write into IM_OFFSET <- R[rt]
									*/
		FLAG_DMoffset   = 0;	/*	FLAG_DMoffset
										1: Write into DM_OFFSET <- R[rt]
									*/
		FLAG_input = 0;		/*	FLAG_input
										1: Get input and send it to R[rd]
									*/
		FLAG_output = 0;		/*	FLAG_output
										1: Get output from R[rs] and send it to 7 Segments Display
									*/
		FLAG_lcd = 0;			/*	FLAG_lcd
										1: Get data from R[rs]/R[rt] send it to LCD Display
									*/
		FLAG_timer = 0;		/*	FLAG_timer
										1: Get data from R[rs] and set Timer (RoundRobin)
									*/
		halt = 0;
		finish = 0;
	end
	
	always @(*) begin
		opcode_ULA = 0;

		FLAG_biosim = 0;
		FLAG_hd = 0;
		FLAG_instr = 0;
		FLAG_memory = 0;
		FLAG_register = 0;
		FLAG_start = 0;
		FLAG_IMoffset = 0;
		FLAG_DMoffset = 0;
		FLAG_input = 0;
		FLAG_output = 0;
		FLAG_lcd = 0;
		FLAG_timer = 0;
		
		MUX_PC = 0;			// 0: PC + 1
		MUX_ULA = 0;		// 0: R[rt]
		MUX_register = 0;	// 0: R[rd]
		MUX_write = 0;		// 0: ULA
		
		halt = 0;
		finish = 0;
		
		if (interrupt) begin
			MUX_PC = 4;			// 4: PC_so (R[so])
		end else if(instruction[31:0] == 32'b00000000000000000000000000000000) begin
			// blank
		end else begin
			case(instruction[31:26])
			// R-Type --------------------------------------------------------------------------------------------
			6'b000000:
				case(instruction[5:0])
				// in		[ R[rd] - input ]
				6'b000001:
					begin
						FLAG_register = 1;		//	1: Write into Register DB
						MUX_write = 3'd3;			//	3: input
						
						FLAG_input = 1;			// 1: Get input and send it to R[rd]
					end
				
				// out	[ output - R[rs] ]
				6'b000010:
					begin
						FLAG_output = 1;			// 1: Get output from R[rs] and send it to output
					end
					
				// move 	[ R[rd] - R[rs] ]
				6'b000011:	
					begin
						opcode_ULA = 5'b00010;	/* move, HDtoIM */
						FLAG_register = 1;		//	1: Write into Register DB
					end


				// add 	[ R[rd] - R[rs] + R[rt] ]
				6'b000100:
					begin
						opcode_ULA = 5'b00100;	/* load, store, add, addi */
						FLAG_register = 1;		//	1: Write into Register DB
					end
					
				// sub	[ R[rd] - R[rs] - R[rt] ]
				6'b000101:
					begin
						opcode_ULA = 5'b00101;	/* sub, subi  */
						FLAG_register = 1;		//	1: Write into Register DB
					end
					
				// mul	[ R[rd] - R[rs] * R[rt] ]
				6'b000110:	
					begin
						opcode_ULA = 5'b00110;	/* mul, muli  */
						FLAG_register = 1;		//	1: Write into Register DB
					end
					
				// div	[ R[rd] - R[rs] / R[rt] ]
				6'b000111:	
					begin
						opcode_ULA = 5'b00111;	/* div, divi */
						FLAG_register = 1;		//	1: Write into Register DB
					end
					
				// and	[ R[rd] - R[rs] & R[rt] ]
				6'b001000:	
					begin
						opcode_ULA = 5'b01000;	/* and, andi */
						FLAG_register = 1;		//	1: Write into Register DB
					end
					
				// or		[ R[rd] - R[rs] | R[rt] ]
				6'b001001:	
					begin
						opcode_ULA = 5'b01001;	/* or, ori */
						FLAG_register = 1;		//	1: Write into Register DB
					end
					
				// not	[ R[rd] - ! R[rs] ]
				6'b001010:	
					begin
						opcode_ULA = 5'b01010;	/* not */
						FLAG_register = 1;		//	1: Write into Register DB
					end
					
				// xor	[ R[rd] - R[rs] ^ R[rt] ]
				6'b001011:
					begin
						opcode_ULA = 5'b01011;	/* xor */
						FLAG_register = 1;		//	1: Write into Register DB
					end
					

				// sll	[ R[rd] - R[rs] << shamt ]
				6'b001100:
					begin
						opcode_ULA = 5'b01100;	/* sll */
						FLAG_register = 1;		//	1: Write into Register DB
					end
					
				// srl 	[ R[rd] - R[rs] >> shamt ]
				6'b001101:
					begin
						opcode_ULA = 5'b01101;	/* srl */
						FLAG_register = 1;		//	1: Write into Register DB
					end

				// set	[ R[rd] - R[rs] = R[rt] ]
				6'b010000:	
					begin
						opcode_ULA = 5'b10000;	/* set, seti, beq */
						FLAG_register = 1;		//	1: Write into Register DB
					end
				
				// sdt	[ R[rd] - R[rs] != R[rt] ]
				6'b010001:
					begin
						opcode_ULA = 5'b10001;	/* sdt, sdti, bne */
						FLAG_register = 1;		//	1: Write into Register DB
					end
				
				// sgt	[ R[rd] - R[rs] > R[rt] ]
				6'b010010:
					begin
						opcode_ULA = 5'b10010;	/* sgt, sgti */
						FLAG_register = 1;		//	1: Write into Register DB
					end
				
				// slt	[ R[rd] - R[rs] < R[rt] ]
				6'b010011:	
					begin
						opcode_ULA = 5'b10011;	/* slt, slti */
						FLAG_register = 1;		//	1: Write into Register DB
					end
				
				// segt	[ R[rd] - R[rs] >= R[rt] ]
				6'b010100:
					begin
						opcode_ULA = 5'b10100;	/* segt, segti */
						FLAG_register = 1;		//	1: Write into Register DB
					end
				
				// selt	[ R[rd] - R[rs] <= R[rt] ]
				6'b010101:
					begin
						opcode_ULA = 5'b10101;	/* selt, selti */
						FLAG_register = 1;		//	1: Write into Register DB
					end
					
				// loadHD [ R[rd] <- HD[R[rs] + R[rt] ]
				6'b010110:
					begin
						opcode_ULA = 5'b00100;	/* load, store, add, addi, loadHD */
						FLAG_register = 1;		//	1: Write into Register DB
						MUX_write = 3'd4;			// 4: HD
					end
				
				// storeHD	[ HD[only R[rt]] <- R[rs] ]
				6'b010111:	
					begin
						opcode_ULA = 5'b00011;	/* movei, storeHD, HDtoIM */
						FLAG_hd = 1;				// 1: Write into HD
					end
					
				// HDtoIM	[ IM[R[rs] ] <- HD[only R[rt]] ]
				6'b011000:	
					begin
						opcode_ULA = 5'b00011;	/* movei, storeHD, HDtoIM */
						FLAG_instr = 1;			// 1: Write into Instruction Memory
					end
					
				// setTimer	[ TIMER <- R[rs] ]
				6'b011001:	
					begin
						FLAG_timer = 1;
					end
				
				// jr [ PC <- R[rs] ]
				6'b100000:	
					begin
						MUX_PC = 3;		// 3: data (R[rs])
					end
					
				// jimset [ PC <- R[rs], OFFSET <- R[rt] ]
				6'b100001:	
					begin
						MUX_PC = 3;		// 3: data (R[rs])
						FLAG_IMoffset = 1;
						
						if (instruction[20:16] == 5'b00000)
							finish = 1;
					end
					
				// dmset	[ DM_OFFSET ] <- R[rs] ]
				6'b100010:	
					begin
						FLAG_DMoffset = 1;
					end
					
				// writeLCD [ LCD[x][rt] <- R[rs] ]
				6'b111111:	
					begin
						FLAG_lcd = 1;
					end
				
				// blank
				default:
					begin
					end
				endcase
				
			// I-Type --------------------------------------------------------------------------------------------
			// load [ R[rt] <- M[R[rs] + IMD ]
			6'b000001:
				begin
					opcode_ULA = 5'b00100;	/* load, store, add, addi */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
					
					MUX_write = 3'd1;			// 1: memory
				end
				
			// store	[ M[R[rs] + IMD ] <- R[rt] ]
			6'b000010:	
				begin
					opcode_ULA = 5'b00100;	/* load, store, add, addi */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_memory = 1;			// 1: Write into Data Memory
				end
				
			// movei	[ R[rt] - IMD ]
			6'b000011:	
				begin
					opcode_ULA = 5'b00011;	/* movei, storeHD */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]

				end
				
			// addi	[ R[rt] - R[rs] + IMD ]
			6'b000100:	
				begin
					opcode_ULA = 5'b00100;	/* load, store, add, addi*/
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end
				
			// subi	[ R[rt] - R[rs] - IMD ]
			6'b000101:	
				begin
					opcode_ULA = 5'b00101;	/* sub, subi  */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]

				end
			
			// muli	[ R[rt] - R[rs] * IMD ]
			6'b000110:
				begin
					opcode_ULA = 5'b00110;	/* mul, muli  */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end
			
			// divi	[ R[rt] - R[rs] / IMD ]
			6'b000111:
				begin
					opcode_ULA = 5'b00111;	/* div, divi */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end
			
			// andi	[ R[rt] - R[rs] & IMD ]
			6'b001000:
				begin
					opcode_ULA = 5'b01000;	/* and, andi */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end
				
			// ori	[ R[rt] - R[rs] | IMD ]
			6'b001001:	
				begin
					opcode_ULA = 5'b01001;	/* or, ori */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end

			// beq	[ if R[rt] == R[rs], PC - PC + 1 + IMD ]
			6'b001100:
				begin
					opcode_ULA = 5'b10000;	/* set, seti, beq */
					
					if(zero)			MUX_PC = 1;	// 1: PC + 1 + IMD
					else if(!zero)	MUX_PC = 0;	// 0: PC + 1
				end
				
			// bne	[ if R[rt] != R[rs], PC - PC + 1 + IMD ]
			6'b001101:
				begin
					opcode_ULA = 5'b10001;	/* sdt, sdti, bne */

					if(zero)			MUX_PC = 1;	// 1: PC + 1 + IMD
					else if(!zero)	MUX_PC = 0;	// 0: PC + 1
				end
			
			// lui	[ R[rt] - IMD  16 ]
			6'b001110:
				begin
					opcode_ULA = 5'b01110;	/* lui */
					MUX_ULA = 1;				// 1: IMD
				end

			// seti	[ R[rt] - R[rs] == IMD ]
			6'b010000:
				begin
					opcode_ULA = 5'b10000;	/* set, seti, beq */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end
				
			// sdti	[ R[rt] - R[rs] != IMD ]
			6'b010001:
				begin
					opcode_ULA = 5'b10001;	/* sdt, sdti, bne */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end	

			// sgti	[ R[rt] - R[rs] > IMD ]
			6'b010010:
				begin
					opcode_ULA = 5'b10010;	/* sgt, sgti */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end
			
			// slti	[ R[rt] - R[rs] < IMD ]
			6'b010011:
				begin
					opcode_ULA = 5'b10011;	/* slt, slti */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end
			
			// segti	[ R[rt] - R[rs] >= IMD ]
			6'b010100:
				begin
					opcode_ULA = 5'b10100;	/* segt, segti */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end
			
			// selti	[ R[rt] - R[rs] <= IMD ]
			6'b010101:
				begin
					opcode_ULA = 5'b10101;	/* selt, selti */
					MUX_ULA = 1;				// 1: IMD
					
					FLAG_register = 1;		//	1: Write into Register DB
					MUX_register = 1;			// 1: R[rt]
				end
				
			// pcbkp	[ [R[rt] <- PC + 1 ]
			6'b011111:	
				begin
					FLAG_register = 1;	//	1: Write into Register DB
					MUX_register = 1;		// 1: R[rt]
					MUX_write = 3'd2; 	// 2: PC_current + 1
				end
				
			// J-Type --------------------------------------------------------------------------------------------
			// j		[ PC <- address ]
			6'b100000:
				begin
					MUX_PC = 2;		// 2: address
				end
			
			// jal	[ R[31] <- PC + 1, PC - address ]
			6'b100001:
				begin
					MUX_PC = 2;		// 2: address
		
					FLAG_register = 1;	//	1: Write into Register DB
					MUX_register = 2;		// 2: R[31] (PC Register)
					MUX_write = 3'd2; 	// 2: PC_current + 1
				end
				
			// biosim	[ PC ← address (normally zero), BIOSIM ← 1 ]
			6'b100011:
				begin
					MUX_PC = 2;		// 2: address
					FLAG_biosim = 1;
					FLAG_start = 1;
				end
				
			// halt	[ Stops PC ]
			6'b111111:
				begin
					halt = 1;
				end
			
			// blank
			default:
				begin
				end
			endcase
		end
	end		
endmodule 