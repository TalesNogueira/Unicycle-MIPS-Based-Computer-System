module LCD #(
	 parameter LCD_WIDTH = 20
)(
	input clk, reset,
	
	input line,
	input [7:0] char,
	input FLAG_lcd,
	
	output LCD_ON,		// Startup	  (Always 1)
	output LCD_BLON,	// Backlight  (Always 0)
	output LCD_RW,		// Write/Read (Always 0)
	
	output reg LCD_EN,			// LCD Clock
	output reg LCD_RS,			// Command/Character
	output reg [7:0] LCD_DATA,	// Command/Character Data
	
	output reg done
);

	wire clock;

	Clock_Divisor #(
		.COUNTER_WIDTH(LCD_WIDTH)
	)  CD (
		.clk_in(clk),
		.clk_out(clock)
	);

	assign LCD_ON 	 = 1'b1;
	assign LCD_BLON = 1'b0;
	assign LCD_RW 	 = 1'b0;
	
	reg busy;
	reg [3:0] state;
	reg [3:0] last_state;

	localparam S_start   = 4'd0;
	localparam S_setup   = 4'd1;
	localparam S_clear   = 4'd2;
	localparam S_entry   = 4'd3;
	localparam S_idle    = 4'd4;
	localparam S_setLine = 4'd5;
	localparam S_write 	= 4'd6;
	localparam S_EN_high = 4'd7;
	localparam S_EN_low  = 4'd8;
	

	reg line_save;
	reg [7:0] char_save;
	
	reg [4:0] char_counter;
	
	initial begin
		LCD_EN   	 = 0;
		LCD_RS   	 = 0;
		LCD_DATA 	 = 8'h00;
		state    	 = S_start;
		last_state 	 = S_start;
		char_counter = 0;
		busy 			 = 1;
		done			 = 0;
	end
	
	always @(posedge clock or posedge reset) begin
		if (reset) begin
			LCD_EN       <= 0;
			LCD_RS       <= 0;
			LCD_DATA     <= 8'h00;
			state 	    <= S_start;
			last_state 	 <= S_start;
			char_counter <= 0;
			busy         <= 1;
			done         <= 0;
		end else begin
			case (state)
				S_start: begin
					LCD_EN     <= 1;
					LCD_RS     <= 0;
					LCD_DATA   <= 8'h38;   // Function Set
					last_state <= S_start;
					state      <= S_EN_high;
					busy       <= 1;
				end
				
				S_setup: begin
					LCD_EN     <= 1;
					LCD_RS     <= 0;
					LCD_DATA   <= 8'h0C;   	// Display ON, Cursor OFF, Blink OFF
					last_state <= S_setup;
					state      <= S_EN_high;
					busy       <= 1;
				end
				
				S_clear: begin
					LCD_EN     <= 1;
					LCD_RS     <= 0;
					LCD_DATA   <= 8'h01;   	// Clear Display and set write in char 0 line 0
					last_state <= S_clear;
					state      <= S_EN_high;
					busy       <= 1;
					char_counter <= 0;
				end
				
				S_entry: begin
					LCD_EN     <= 1;
					LCD_RS     <= 0;
					LCD_DATA   <= 8'h06;   // Entry Mode Set
					last_state <= S_entry;
					state      <= S_EN_high;
					busy       <= 1;
				end

				S_idle: begin
					done <= 0;
					
					if (FLAG_lcd && !busy) begin
						line_save <= line;
						char_save <= char;
						if (char_counter == 0)
							state <= S_setLine;
						else
							state <= S_write;
					end
					
					busy <= 0;
				end
				
				S_setLine: begin
					LCD_EN     <= 1;
					LCD_RS     <= 0;
					LCD_DATA   <= line_save ? 8'hC0 : 8'h80; // Line Choice
					last_state <= S_setLine;
					state      <= S_EN_high;
					busy	 	  <= 1;
				end
				
				S_write: begin
					LCD_EN     <= 1;
					LCD_RS     <= 1;
					LCD_DATA   <= char_save;
					last_state <= S_write;
					state      <= S_EN_high;
					busy	 	  <= 1;
				end
				
				S_EN_high: begin
					LCD_EN <= 0;
					state  <= S_EN_low;
					busy   <= 1;
				end
			
				S_EN_low: begin
					busy <= 1;
					
					case (last_state)
						S_start:		state <= S_setup;
						S_setup:		state <= S_clear;
						S_clear:		state <= S_entry;
						S_entry:		state <= S_idle; 
						
						S_setLine: 	state <= S_write;
						S_write:	begin
							if (char_counter >= 15)
								char_counter <= 0;
							else
								char_counter <= char_counter + 1'b1;
							state <= S_idle;
							done <= 1;
						end
						
						default: state <= S_idle;
					endcase
				end
			
				default: state <= S_idle;
			endcase
		end
	end
endmodule