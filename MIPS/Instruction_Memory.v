module Instruction_Memory #(
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 11
)(
	input clock, reset, interrupt,
	input [DATA_WIDTH-1:0] PC,
	input [DATA_WIDTH-1:0] IM_offset,
	input FLAG_IMoffset,
	input [DATA_WIDTH-1:0] write_addr, write_data, 
	input write,
	output reg [DATA_WIDTH-1:0] instruction
);

	reg [DATA_WIDTH-1:0] instr_mem[2**ADDR_WIDTH-1:0];
	
	reg [DATA_WIDTH-1:0] OFFSET = {DATA_WIDTH{1'b0}};
	
	always @ (posedge clock or posedge reset) begin
		if (reset) begin
			OFFSET <= {DATA_WIDTH{1'b0}};
		end else if (interrupt) begin
			OFFSET <= {DATA_WIDTH{1'b0}};
		end else begin
			if (FLAG_IMoffset)
				OFFSET <= IM_offset;
				
			// Write
			if (write)
				instr_mem[write_addr] <= write_data;
		end
	end
	
	always @ (negedge clock) begin
		// Read 
		instruction <= instr_mem[PC + OFFSET];
	end
endmodule 