module startStopLapReset_LCD	(	CLK_50M,
					SW,
					PUSH_BTN_SS, PUSH_BTN_LR,

					LED,
					LCD_DB,
					LCD_E, LCD_RS, LCD_RW);

input		CLK_50M;
input		SW;
input		PUSH_BTN_SS;
input		PUSH_BTN_LR;

output	[7:0]	LED;
output	[7:0]	LCD_DB;
output		LCD_E;
output		LCD_RS;
output		LCD_RW;


wire	[15:0]	wb_counter;
wire	[15:0]	wb_counter_toShow;

wire		w_startStop;
wire		w_lapFlag;
wire		w_reset;

buf(LCD_RW, 0);
buf(LCD_DB[3:0], 4'b1111);

LCD_Driver_forChrono	lcd_driver	(	.qzt_clk(CLK_50M),
						.fourDigitInput(wb_counter_toShow),
						.lapFlag(w_lapFlag),

						.lcd_flags({LCD_RS, LCD_E}),
						.lcd_data(LCD_DB[7:4]));

/****************************************/
/*** ... and hereafter what's left... ***/
/****************************************/

endmodule
