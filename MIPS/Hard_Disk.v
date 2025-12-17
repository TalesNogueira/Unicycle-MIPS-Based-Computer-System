module Hard_Disk #(
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 13
)(
	input clock,
	input [DATA_WIDTH-1:0] addr, data, 
	input write,
	output [DATA_WIDTH-1:0] data_HD
);

	reg [DATA_WIDTH-1:0] hd[2**ADDR_WIDTH-1:0];
	
	reg [DATA_WIDTH-1:0] addr_save;
	
	initial begin : INIT
		$readmemb("localdisk.txt", hd);
	end

	always @ (posedge clock) begin
		if (write)
			hd[addr] <= data;
			
		addr_save <= addr;
	end
	
	assign data_HD = hd[addr_save];
endmodule