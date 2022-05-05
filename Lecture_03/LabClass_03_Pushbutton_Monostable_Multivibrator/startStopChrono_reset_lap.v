`define		100_Hz_Period	30'b000000000000111101000010010000	//	25 10^4
`define		Period_Multivibrator	30'd10000000 // 10^7, delay time for multivibrator, 0.2 seconds

/*********************************************/
/*** Toggle pushbutton to switch on/off a led without bouncing effect (with monostable multivibrator!) ***/
/*********************************************/


module startStopChrono_reset_lap	(	CLK_50M,
						//SW,
						BTN_SOUTH,
						//BTN_EAST,
						//BTN_NORTH,

						LED);

input		CLK_50M;
//input	[1:0]	SW;
input		BTN_SOUTH;	// stop
//input		BTN_EAST;	// lap
//input		BTN_NORTH;	// reset

output		LED;

wire 		w_1;

/*********************************************/
/*** Multivibrator produces a pulse which is input to the toggle flip-flop ***/
/*********************************************/


Module_Monostable_Multivibrator_sync	Multivibrator1	(	.qzt_clk(CLK_50M),
							.input_0(BTN_SOUTH),
							.period(`Period_Multivibrator),

							.out(w_1));


Module_Toggle_Flip_Flop_sync	FlipFlop1	(		CLK_50M,
							w_1,

							LED);



/****************************************/
/*** ... and hereafter what's left... ***/
/****************************************/

endmodule
