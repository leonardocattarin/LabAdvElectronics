`define		100_Hz_Period	30'b000000000000111101000010010000	//	25 10^4 period, plug in frequency divider for 100Hz
`define		Period_Multivibrator	30'd10000000 // 10^7, delay time for multivibrator, 0.2 seconds

/*********************************************/
/*** Stopwatch with Start, Stop, Lap, Reset on 3 buttons (added also D-type flip-flop for auxiliarity) ***/
/*********************************************/

module startStopChrono_reset_lap	(	CLK_50M,
						SW,
						BTN_SOUTH,
						BTN_EAST,
						BTN_NORTH,

						LED);

input		CLK_50M; 	//base clock
input		SW; 		//switch
input		BTN_SOUTH;	// stop
input		BTN_EAST;	// lap
input		BTN_NORTH;	// reset

output	[7:0]	LED;	//output leds

wire 		w_north;	//wire from buttons antivibrators
wire 		w_south;	
wire 		w_east;		

wire 		w_Clk_100Hz ;	// wire 100Hz clock from frequency divider

wire 		w_toggle_south ;	//wire from south button toggle
wire 		w_toggle_east ;

wire 		w_carry_1; //carry for counting
wire 		w_carry_2;
wire 		w_carry_3;

wire [7:0]		w_output_0;	//actual output, needed for lap multiplexer 
wire [7:0]		w_output_1;

wire 	[7:0]	w_in_MUX_0; //8bit multiplexer inputs for counting visualization
wire	[7:0]	w_in_MUX_1;

/*********************************************/
/*** Multivibrators used as anti-bounce for buttons ***/
/*********************************************/
Module_Monostable_Multivibrator_sync	Multivibrator_South	(	.qzt_clk(CLK_50M),
							.input_0(BTN_SOUTH),
							.period(`Period_Multivibrator),

							.out(w_south));

Module_Monostable_Multivibrator_sync	Multivibrator_North	(	.qzt_clk(CLK_50M),
							.input_0(BTN_NORTH),
							.period(`Period_Multivibrator),

							.out(w_north));

Module_Monostable_Multivibrator_sync	Multivibrator_East	(	.qzt_clk(CLK_50M),
							.input_0(BTN_EAST),
							.period(`Period_Multivibrator),

							.out(w_east));



/*********************************************/
/*** toggle Flip-flop for south button (start/stop) and east (lap) ***/
/*********************************************/
Module_Toggle_Flip_Flop_sync	FlipFlop_South	(		CLK_50M,
							w_south,

							w_toggle_south);

Module_Toggle_Flip_Flop_sync	FlipFlop_East	(		CLK_50M,
							w_east,

							w_toggle_east);


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
						w_Clk_100Hz & w_toggle_south,
						w_north,
						0,
						0,
						8'b00001010,

						w_in_MUX_0[3:0],
						w_carry_1);

Module_SynchroCounter_8_bit_SR Synchro_Counter_MSB_decimals	(	CLK_50M,
						w_carry_1 & w_toggle_south,
						w_north,
						0,
						0,
						8'b00001010,

						w_in_MUX_0[7:4],
						w_carry_2);

Module_SynchroCounter_8_bit_SR Synchro_Counter_LSB_Units	(	CLK_50M,
						w_carry_2 & w_toggle_south,
						w_north,
						0,
						0,
						8'b00001010,

						w_in_MUX_1[3:0],
						w_carry_3);

Module_SynchroCounter_8_bit_SR Synchro_Counter_MSB_Units	(	CLK_50M,
						w_carry_3 & w_toggle_south,
						w_north,
						0,
						0,
						8'b00001010,

						w_in_MUX_1[7:4],
						carry);


/*********************************************/
/***  to store data while in lap, allowing to switch between led visualization ***/
/*********************************************/

Module_Latch_8bit_sync		Repeater_lap_0	(		CLK_50M & ~w_toggle_east,
							w_in_MUX_0,

							w_output_0);


Module_Latch_8bit_sync		Repeater_lap_1	(		CLK_50M & ~w_toggle_east,
							w_in_MUX_1,

							w_output_1);


/*********************************************/
/*** Multiplexer for LEDs  ***/
/*********************************************/
Module_Multiplexer_2_input_8_bit_sync 	Multiplexer_visulization	(	CLK_50M,
							SW,
							w_output_0,
							w_output_1,

							LED);



/****************************************/
/*** ... and hereafter what's left... ***/
/****************************************/

endmodule
