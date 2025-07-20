module Multiplexer_Address_Write (input [4:0] addr_tgt, input [4:0] addr_dst, input [1:0] MUX_register, output reg [4:0] addr_write);
	always @(*) begin
		case(MUX_register)
			0:
				addr_write = addr_dst;	// rd
			1:
				addr_write = addr_tgt;	// rt
			2:
				addr_write = 31; 		// PC Register
			default:
				addr_write = 0;
		endcase
	end
endmodule 