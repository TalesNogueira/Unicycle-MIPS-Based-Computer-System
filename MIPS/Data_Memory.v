module Data_Memory #(
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 12
)(
	input clock, reset,
	input [DATA_WIDTH-1:0] addr, data,
	input [DATA_WIDTH-1:0] DM_offset,
	input FLAG_DMoffset,
	input write, 
	output [DATA_WIDTH-1:0] data_memory
);

	reg [DATA_WIDTH-1:0] data_mem[2**ADDR_WIDTH-1:0];
	
	reg [DATA_WIDTH-1:0] addr_save;
	
	reg [DATA_WIDTH-1:0] OFFSET = {DATA_WIDTH{1'b0}};
	
	initial begin : INIT
		integer i;
		for(i = 0; i < (1 << ADDR_WIDTH); i = i + 1)
			data_mem[i] = {DATA_WIDTH{1'b0}};
	end 
	
	always @ (posedge clock or posedge reset) begin
		if (reset) begin
			OFFSET <= {DATA_WIDTH{1'b0}};
		end else begin
			if (FLAG_DMoffset)
				OFFSET <= DM_offset;
				
			if (write)
				data_mem[addr+OFFSET] <= data;
			
			addr_save <= addr + OFFSET;
		end
	end

	assign data_memory = data_mem[addr_save];
endmodule

