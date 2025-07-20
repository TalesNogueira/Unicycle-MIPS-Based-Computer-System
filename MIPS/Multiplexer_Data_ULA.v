module Multiplexer_Data_ULA (input wire [31:0] data_tgt, input wire [31:0] imediate, input wire MUX_ULA, output reg [31:0] data_tgtImd);
	always @(*) begin
		case(MUX_ULA)
			0:
				data_tgtImd = data_tgt;
			1:
				data_tgtImd = imediate;
		endcase
	end
endmodule 