module Register_Database #(
	parameter DATA_WIDTH = 32,
	parameter OFFSET = 127
)(
	input clock, reset, interrupt,
	input [DATA_WIDTH-1:0] PC_current,
		
	input [4:0] addr_src,		// R[s]
	input [4:0] addr_tgt,		// R[t]
	input [4:0] addr,
	
	input [DATA_WIDTH-1:0] data,
	input FLAG_register,
	input FLAG_start,
	
	output [DATA_WIDTH-1:0] data_src,		// Data from Register[Source or R[s]]
	output [DATA_WIDTH-1:0] data_tgt,		// Data from Register[Target or R[t]]
	
	output [DATA_WIDTH-1:0] data_so			// Data from Register[5] = $so
);	
	
	reg [DATA_WIDTH-1:0] registers[31:0];	// 32 Registers Database
	
	initial begin : INIT
		integer i;
		for (i = 0; i < 32; i = i + 1) begin
			if (i == 28) begin
				registers[i] <= 32;
			end else if (i == 29 || i == 30) begin
				registers[i] <= OFFSET;
			end else begin
				registers[i] <= {DATA_WIDTH{1'b0}};
			end
		end
	end
	
	always @(negedge clock or posedge reset) begin
		if (reset) begin
			integer i;
			for (i = 0; i < 32; i = i + 1) begin
				if (i == 28) begin
					registers[i] <= 32;
				end else if (i == 29 || i == 30) begin
					registers[i] <= OFFSET;
				end else begin
					registers[i] <= {DATA_WIDTH{1'b0}};
				end
			end
		end else if (interrupt) begin
			registers[26] <= PC_current;
		end else if (FLAG_start) begin
			registers[28] <= 32;
			registers[29] <= OFFSET;
			registers[30] <= OFFSET;
		end else if (FLAG_register && !(addr == 0)) begin
			registers[addr] <= data;
		end
	end

	assign data_src = registers[addr_src];
	assign data_tgt = registers[addr_tgt];
	assign data_so  = registers[5];
endmodule 