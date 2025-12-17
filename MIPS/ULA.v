module ULA (
	input [31:0] data_src,
	input [31:0] data_tgtImd,
	
	input [4:0] shamt,
	input [4:0] opcode_ULA,
	
	output reg [31:0] data_ULA,
	output reg zero
);

	initial begin
			data_ULA = 0;
			zero = 0;
	end
	
	always @(*) begin
		case(opcode_ULA)
			/* move */
			5'b00010:
				begin
					data_ULA = $signed(data_src);
					zero = 0;
				end
			
			/* movei, storeHD, HDtoIM */
			5'b00011:
				begin
					data_ULA = $signed(data_tgtImd);
					zero = 0;
				end

			/* load, store, add, addi, loadHD */
			5'b00100:
				begin
					data_ULA = $signed(data_src) + $signed(data_tgtImd);
					zero = 0;
				end
			
			/* sub, subi  */
			5'b00101:
				begin
					data_ULA = $signed(data_src) - $signed(data_tgtImd);
					zero = 0;
				end
			
			/* mul, muli  */
			5'b00110:
				begin
					data_ULA = $signed(data_src) * $signed(data_tgtImd);
					zero = 0;
				end
				
			/* div, divi */
			5'b00111:
				begin
					// Division by zero
					if(data_tgtImd == 32'd0) data_ULA = 32'd0;
					else data_ULA = $signed(data_src) / $signed(data_tgtImd);
					zero = 0;
				end
			
			/* and, andi */
			5'b01000:
				begin
					data_ULA = (data_src & data_tgtImd);
					zero = 0;
				end
			
			/* or, ori */
			5'b01001:		
				begin
					data_ULA = (data_src | data_tgtImd);
					zero = 0;
				end
			
			/* not */
			5'b01010:
				begin
					data_ULA = !(data_src);
					zero = 0;
				end
				
			/* xor */
			5'b01011:
				begin
					data_ULA = (data_src ^ data_tgtImd);
					zero = 0;
				end
				
			/* sll */
			5'b01100:
				begin
					data_ULA = (data_src <<< shamt); 
					zero = 0;
				end
			
			/* srl */
			5'b01101:
				begin
					data_ULA = (data_src >>> shamt);
					zero = 0;
				end
				
			/* lui */
			5'b01110:
				begin
					data_ULA = (data_tgtImd <<< 16);
					zero = 0;
				end
				
			/* set, seti, beq */
			5'b10000:
				begin
					if($signed(data_src) == $signed(data_tgtImd))begin
							data_ULA = 32'd1;
							zero = 1;
					end else begin
							data_ULA = 32'd0;
							zero = 0;
					end
				end
			
			/* sdt, sdti, bne */
			5'b10001:
				begin
					if($signed(data_src) != $signed(data_tgtImd)) begin
							data_ULA = 32'd1;
							zero = 1;
					end else begin
							data_ULA = 32'd0;
							zero = 0;
					end
				end
			
			/* sgt, sgti */
			5'b10010:
				begin
						if($signed(data_src) > $signed(data_tgtImd)) begin
								data_ULA = 32'd1;
								zero = 1;
						end else begin
								data_ULA = 32'd0;
								zero = 0;
						end
					end
			
			/* slt, slti */
			5'b10011:
				begin
						if($signed(data_src) < $signed(data_tgtImd)) begin
								data_ULA = 32'd1;
								zero = 1;
						end else begin
								data_ULA = 32'd0;
								zero = 0;
						end
					end
				
			/* segt, segti */
			5'b10100:
				begin
						if($signed(data_src) >= $signed(data_tgtImd)) begin
								data_ULA = 32'd1;
								zero = 1;
						end else begin
								data_ULA = 32'd0;
								zero = 0;
						end
					end
			
			/* selt, selti */
			5'b10101:
				begin
						if($signed(data_src) <= $signed(data_tgtImd)) begin
								data_ULA = 32'd1;
								zero = 1;
						end else begin
								data_ULA = 32'd0;
								zero = 0;
						end
					end
					
			/* blank */
			default:
				begin
					data_ULA = 32'd0;
					zero = 0;
				end
		endcase
	end
endmodule 