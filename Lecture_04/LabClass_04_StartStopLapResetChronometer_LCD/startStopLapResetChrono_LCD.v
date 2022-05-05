`define		100_Hz_Period	30'b000000000000111101000010010000	//	25 10^4 period, plug in frequency divider for 100Hz
`define		Period_Multivibrator	30'b10 // multiples of the 100 Hz clock period

//NOTE: 50e+6 Hz clock
module startStopLapReset_LCD	(	CLK_50M,
					PUSH_BTN_SS, PUSH_BTN_LR,

					LED,
					LCD_DB,
					LCD_E, LCD_RS, LCD_RW
					);

input		CLK_50M; //master clock

input		PUSH_BTN_SS; //buttons
input		PUSH_BTN_LR;

output	[7:0]	LED; //Leds

output	[7:0]	LCD_DB; //LCD data
output		LCD_E;
output		LCD_RS;
output		LCD_RW;


wire	[15:0]	wb_counter; //actual data from the counter and data shown in LCD screen
wire	[15:0]	wb_counter_toShow;

wire		w_startStop; //flags outputted from the States machine
wire		w_lapFlag;
wire		w_reset;

wire 		monostable_SS_output; //outputs from monostables
wire 		monostable_LR_output;

wire 		w_Clk_100Hz;

wire 		w_carry_1; //carry for counting
wire 		w_carry_2;
wire 		w_carry_3;


buf(LCD_RW, 0);
buf(LCD_DB[3:0], 4'b1111);

//set off central leds
buf(LED[5:3], 0);


//Assign most significant leds to flags
assign LED[7] = w_lapFlag;
assign LED[6] = w_startStop;


/*********************************************/
/*** LCD Driver Module ***/
/*********************************************/

LCD_Driver_forChrono	lcd_driver	(	.qzt_clk(CLK_50M),
						.fourDigitInput(wb_counter_toShow),
						.lapFlag(w_lapFlag),

						.lcd_flags({LCD_RS, LCD_E}),
						.lcd_data(LCD_DB[7:4]));


/*********************************************/
/*** States Machine  ***/
/*********************************************/
Module_Watch_State_Machine 	Machine_StopWatch_1	(	
					CLK_50M,
					monostable_LR_output,
					monostable_SS_output,

					LED[2:0],
					w_startStop,
					w_lapFlag,
					w_reset);


/*********************************************/
/*** Monostables for buttons  ***/
/*********************************************/
//NOTE: used 100 Hz clock as main clock to avoid bouncing effects.

Module_Monostable Monostable_SS	(	
					.clk_in(w_Clk_100Hz),
					.monostable_input(PUSH_BTN_SS),
					.N(`Period_Multivibrator),

					.monostable_output(monostable_SS_output));


Module_Monostable Monostable_LR	(	
					.clk_in(w_Clk_100Hz),
					.monostable_input(PUSH_BTN_LR),
					.N(`Period_Multivibrator),

					.monostable_output(monostable_LR_output));


/*********************************************/
/*** Frequency divider to obtain a 100Hz clock ***/
/*********************************************/
Module_FrequencyDivider	Frequency_Divider_100Hz(	CLK_50M,
					`100_Hz_Period,

					w_Clk_100Hz);


/*********************************************/
/*** Cascade counters for chronometer 		***/
/*********************************************/
Module_SynchroCounter_8_bit_SR Synchro_Counter_LSB_decimals	(	CLK_50M,
						w_Clk_100Hz & w_startStop,
						w_reset,
						0,
						0,
						8'b00001010,

						wb_counter[3:0],
						w_carry_1);

Module_SynchroCounter_8_bit_SR Synchro_Counter_MSB_decimals	(	CLK_50M,
						w_carry_1 & w_startStop,
						w_reset,
						0,
						0,
						8'b00001010,

						wb_counter[7:4],
						w_carry_2);

Module_SynchroCounter_8_bit_SR Synchro_Counter_LSB_Units	(	CLK_50M,
						w_carry_2 & w_startStop,
						w_reset,
						0,
						0,
						8'b00001010,

						wb_counter[11:8],
						w_carry_3);

Module_SynchroCounter_8_bit_SR Synchro_Counter_MSB_Units	(	CLK_50M,
						w_carry_3 & w_startStop,
						w_reset,
						0,
						0,
						8'b00001010,

						wb_counter[15:12],
						carry);

/****************************************/
/*** Latch for Keeping data while in lap mode ***/
/****************************************/

Module_Latch_16_bit Data_Latch	(	CLK_50M ,
					w_lapFlag,
					wb_counter,

					wb_counter_toShow);



/****************************************/
/*** ... and hereafter what's left... ***/
/****************************************/

endmodule
