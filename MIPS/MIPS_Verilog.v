module MIPS_Verilog #(
	parameter WORD_SIZE = 32,
	parameter DEBOUNCER_WIDTH = 16,
	parameter CLOCK_WIDTH = 4,
	parameter LCD_WIDTH = 12,
	parameter STOPPER = 0				// For didatic reasons, stops the processor between switch context
)(
	input clk_50,
	
	input switch_hold,
	input [15:0] switches,
	
	input push_reset,
	input push_confirm,
	
	output wire led_clock,
	output wire led_hold,
	output wire led_bios,
	output wire led_io,
	output wire led_negative,
	output wire led_interrupt,
	
	output wire [6:0] hex_7,
	output wire [6:0] hex_6,
	output wire [6:0] hex_5,
	output wire [6:0] hex_4,
	output wire [6:0] hex_3,
	output wire [6:0] hex_2,
	output wire [6:0] hex_1,
	output wire [6:0] hex_0,
	
	output wire lcd_ON,
	output wire lcd_BLON,
	output wire lcd_RW,
	output wire lcd_EN,
	output wire lcd_RS,
	output wire [7:0] lcd_DATA
);

// Wires

	wire edge_reset;
	
	wire clock, clock_status;
	
	wire [WORD_SIZE-1:0] pc_next, pc_so, pc_current;
	
	wire [WORD_SIZE-1:0] BIOS_instruction, IMEM_instruction, instruction;

	wire [4:0] opcode_ula;
	wire mux_ula;
	wire [1:0] mux_register;
	wire [2:0] mux_pc, mux_write;
	wire flag_zero, flag_biosim, flag_hd, flag_instr, flag_memory, flag_register, flag_start, flag_IMoffset, flag_DMoffset, flag_input, flag_output, flag_lcd,  flag_timer, blank, halt, finish;

	wire [WORD_SIZE-1:0] r_src, r_tgt,	imediate, address, r_tgtImd, r_so;
	wire [WORD_SIZE-1:0] data_ula, data_memory, data_hd;
	
	wire [WORD_SIZE-1:0] regdb_data_write;
	wire [4:0] regdb_addr_write;

	wire biosim;
	
	wire [WORD_SIZE-1:0] io_input, io_output;
	wire io_confirm, negative;
	
	wire lcd;
	
	wire interrupt, stop;

// Assigns
	
	assign stop = interrupt && STOPPER;
	
	assign led_clock     = clock_status;
	assign led_hold	   = switch_hold;
	assign led_bios	   = biosim;
	assign led_io        = flag_input | flag_output;
	assign led_negative  = negative;
	assign led_interrupt = interrupt;
	
// Modules

	Debouncer #(
		.N(DEBOUNCER_WIDTH)
	) debouncer_reset (
		.clk(clk_50),
		.push_in(push_reset),
		.falling_edge(edge_reset)
	);

	Clock_Controller #(
		.COUNTER_WIDTH(CLOCK_WIDTH),
		.DEBOUNCER_WIDTH(DEBOUNCER_WIDTH),
		.LCD_WIDTH(LCD_WIDTH)
	) cc (
		.clk(clk_50),
		.reset(edge_reset),
		.halt(halt),
		.lcd_done(lcd),
		.interrupt(stop),
		.switch_hold(switch_hold),
		.push_confirm(push_confirm),
		.FLAG_input(flag_input),
		.FLAG_output(flag_output),
		.FLAG_lcd(flag_lcd),
		.clock(clock),
		.clock_status(clock_status)
	);
	
	PC pc (
		.clock(clock),
		.reset(edge_reset),
		.PC_next(pc_next),
		.PC_current(pc_current)
	);
	
	BIOS bios (
		.clock(clock),
		.PC(pc_next),
		.instruction(BIOS_instruction)
	);
	
	Timer timer (
		.clock(clock),
		.reset(edge_reset),
		.quantum(r_src),
		.FLAG_timer(flag_timer),
		.halt(halt),
		.finish(finish),
		.FLAG_input(flag_input),
		.FLAG_output(flag_output),
		.FLAG_IMoffset(flag_IMoffset),
		.interrupt(interrupt)
	);
	
	Instruction_Memory #(
		.DATA_WIDTH(WORD_SIZE)
	) instr_mem (
		.clock(clock),
		.reset(edge_reset),
		.interrupt(interrupt),
		.PC(pc_next),
		.IM_offset(r_tgt),
		.FLAG_IMoffset(flag_IMoffset),
		.write_addr(r_src),
		.write_data(data_hd),
		.write(flag_instr),
		.instruction(IMEM_instruction)
	);
	
	MUX_BIOSIM mux_biosim (
		.clock(clock),
		.reset(edge_reset),
		.BIOS_instruction(BIOS_instruction),
		.IM_instruction(IMEM_instruction),
		.FLAG_biosim(flag_biosim),
		.instruction(instruction),
		.biosim_status(biosim)
	);

	
	UC uc (
		.instruction(instruction),
		.zero(flag_zero),
		.interrupt(interrupt),
		.opcode_ULA(opcode_ula),
		.MUX_ULA(mux_ula),
		.MUX_PC(mux_pc),
		.MUX_write(mux_write),
		.MUX_register(mux_register),
		.FLAG_biosim(flag_biosim),
		.FLAG_hd(flag_hd),
		.FLAG_instr(flag_instr),
		.FLAG_memory(flag_memory),
		.FLAG_register(flag_register),
		.FLAG_start(flag_start),
		.FLAG_IMoffset(flag_IMoffset),
		.FLAG_DMoffset(flag_DMoffset),
		.FLAG_input(flag_input),
		.FLAG_output(flag_output),
		.FLAG_lcd(flag_lcd),
		.FLAG_timer(flag_timer),
		.halt(halt),
		.finish(finish)
	);

	MUX_Address_Write mux_addr_write (
		.addr_tgt(instruction[20:16]),
		.addr_dst(instruction[15:11]),
		.MUX_register(mux_register),
		.addr_write(regdb_addr_write)
	);
	
	Register_Database #(
		.DATA_WIDTH(WORD_SIZE)
	) reg_db (
		.clock(clock),
		.reset(edge_reset),
		.interrupt(interrupt),
		.PC_current(pc_current),
		.addr_src(instruction[25:21]),
		.addr_tgt(instruction[20:16]),
		.addr(regdb_addr_write),
		.data(regdb_data_write),
		.FLAG_register(flag_register),
		.FLAG_start(flag_start),
		.data_src(r_src),
		.data_tgt(r_tgt),
		.data_so(r_so)
	);
	
	Zero_Extender_26to32 zero_extender_address (
		.data_in(instruction[25:0]),
		.data_out(address)
	);
	
	MUX_Next_PC mux_next_pc (
		.PC_current(pc_current),
		.immediate(imediate),
		.address(address),
		.data(r_src),
		.PC_so(r_so),
		.MUX_PC(mux_pc),
		.PC_next(pc_next)
	);
	
	Sign_Extender_16to32 signed_extender_imediate (
		.data_in(instruction[15:0]),
		.data_out(imediate)
	);
	
	MUX_Data_ULA mux_data_ula (
		.data_tgt(r_tgt),
		.imediate(imediate),
		.MUX_ULA(mux_ula),
		.data_tgtImd(r_tgtImd)
	);
	
	ULA ula (
		.data_src(r_src),
		.data_tgtImd(r_tgtImd),
		.shamt(instruction[10:6]),
		.opcode_ULA(opcode_ula),
		.data_ULA(data_ula),
		.zero(flag_zero)
	);
	
	Data_Memory #(
		.DATA_WIDTH(WORD_SIZE)
	) data_mem (
		.clock(clock),
		.reset(edge_reset),
		.addr(data_ula),     
		.data(r_tgt),
		.DM_offset(r_src),
		.FLAG_DMoffset(flag_DMoffset),
		.write(flag_memory),
		.data_memory(data_memory)
	);
	
	Hard_Disk #(
		.DATA_WIDTH(WORD_SIZE)
	) hd (
		.clock(clock),
		.addr(data_ula),
		.data(r_src),
		.write(flag_hd),
		.data_HD(data_hd)
	);
	
	MUX_Data_Write mux_data_write (
		.data_ULA(data_ula),
		.data_MEM(data_memory),
		.data_IO(io_input),
		.data_HD(data_hd),
		.PC_current(pc_current),
		.MUX_write(mux_write),
		.data_write(regdb_data_write)
	);

	IO io	(
		.switches(switches),
		.data_src(r_src),
		.clk(clk_50),
		.FLAG_input(flag_input),
		.FLAG_output(flag_output),
		.IO_input(io_input),
		.IO_output(io_output),
		.negative(negative)
	);
	
	Seven_Segments_Display s7_display (
		.IO_output(io_output),
		.negative(negative),
		.PC_current(pc_current),
		.FLAG_input(flag_input),
		.FLAG_output(flag_output),
		.display_7(hex_7),
		.display_6(hex_6),
		.display_5(hex_5),
		.display_4(hex_4),
		.display_3(hex_3),
		.display_2(hex_2),
		.display_1(hex_1),
		.display_0(hex_0)
	);
	
	LCD #(
		.LCD_WIDTH(LCD_WIDTH)
	) lcd_display (
		.clk(clk_50),
		.reset(edge_reset),
		.line(r_tgt[0]),
		.char(r_src[7:0]),
		.FLAG_lcd(flag_lcd),
		.LCD_ON(lcd_ON),
		.LCD_BLON(lcd_BLON),
		.LCD_RW(lcd_RW),
		.LCD_EN(lcd_EN),
		.LCD_RS(lcd_RS),
		.LCD_DATA(lcd_DATA),
		.done(lcd)
	);
endmodule