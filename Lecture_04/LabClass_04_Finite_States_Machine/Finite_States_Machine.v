`define		100_Hz_Period	30'b000000000000111101000010010000	//	25 10^4 period, plug in frequency divider for 100Hz


/*********************************************/
/*** 5 States machine Watch  ***/
/*********************************************/

module Test_Finite_States_Machine	(	CLK_50M,
						BTN_SOUTH,
						BTN_EAST,

						LED);

input		CLK_50M; 	//base clock
input		BTN_SOUTH;	// stop
input		BTN_EAST;	// lap

output	[7:0]	LED;	//output leds
	

//wires for buttons
wire 		monostable_SS_output;
wire 		monostable_LR_output;

wire 		w_Clk_100Hz;

//flags wires for leds
wire 		run_flag;
wire 		lap_flag;
wire 		reset_fast_flag;

buf(LED[4:3], 5'b00000);

assign LED[6] = run_flag;
assign LED[7] = lap_flag;
assign LED[5] = reset_fast_flag;

/*********************************************/
/*** 5 States machine  ***/
/*********************************************/

Module_Watch_State_Machine 	Machine_StopWatch_1	(	CLK_50M,
					monostable_LR_output,
					monostable_SS_output,

					LED[2:0],
					run_flag,
					lap_flag,
					reset_fast_flag);

/*********************************************/
/*** Monostables for Buttons based on 100Hz clock, uses two periods so 0.02 seconds  ***/
/*********************************************/

Module_Monostable Monostable_SS	(	.clk_in(w_Clk_100Hz),
					.monostable_input(BTN_SOUTH),
					.N(28'b0000010),

					.monostable_output(monostable_SS_output));


Module_Monostable Monostable_LR	(	.clk_in(w_Clk_100Hz),
					.monostable_input(BTN_EAST),
					.N(28'b0000010),

					.monostable_output(monostable_LR_output));

/*********************************************/
/*** Frequency Divider to get 100 Hz clock  ***/
/*********************************************/

Module_FrequencyDivider	Frequency_Divider_100Hz(	CLK_50M,
					`100_Hz_Period,

					w_Clk_100Hz);


/****************************************/
/*** ... and hereafter what's left... ***/
/****************************************/

endmodule
