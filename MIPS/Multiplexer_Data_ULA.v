module Multiplexer_Data_ULA (data_tgt, imediate, MUX_ULA, data_tgtImd);
	input [31:0]data_tgt;
	input [31:0]imediate;
	
	input MUX_ULA;
	
	output reg [31:0]data_tgtImd;
	
	always @(*)
	begin
		case(MUX_ULA)
			0:
				data_tgtImd = data_tgt;
			1:
				data_tgtImd = imediate;
		endcase
	end
endmodule 