`define		defaultPeriod	30'b000001011111010111100001000000	//	25 10^6
`define		Period_100_Hz	30'd250000


/****************************************/
/*** Simple Synchronous Chronometer, now with counter locked to master sync ***/
/****************************************/

module simpleChronometer	(	CLK_50M,
					SW,

					LED);

input		CLK_50M;
input		SW;

output	[7:0]	LED;

wire 		w_CLK_100_Hz;

wire		w_tmp_carry_0;
wire		w_tmp_carry_1;
wire		w_tmp_carry_2;

wire	[7:0]	w_in_MUX_0;
wire	[7:0]	w_in_MUX_1;

/****************************************/
/*** Frequency divider to get a 100Hz clock ***/
/****************************************/



Module_FrequencyDivider 	freq_divider_100		(
								.clk_in(CLK_50M),
								.period(`Period_100_Hz),

								.clk_out(w_CLK_100_Hz));


/****************************************/
/*** Cascade counters for counting ***/
/****************************************/

Module_Counter_8_bit_sync		counterLSB_decimals		(	.qzt_clk(CLK_50M),
								.clk_in(w_CLK_100_Hz),
								.limit(8'b00001010),
								.reset(0),

								.carry(w_tmp_carry_0),
								.out(w_in_MUX_0[3:0]));
								
								
Module_Counter_8_bit_sync		counterMSB_decimals		(	.qzt_clk(CLK_50M),
								.clk_in(w_tmp_carry_0),
								.limit(8'b00001010),
								.reset(0),

								.carry(w_tmp_carry_1),
								.out(w_in_MUX_0[7:4]));


Module_Counter_8_bit_sync		counterLSB_units		(	.qzt_clk(CLK_50M),
								.clk_in(w_tmp_carry_1),
								.limit(8'b00001010),
								.reset(0),
								
								.carry(w_tmp_carry_2),
								.out(w_in_MUX_1[3:0]));


Module_Counter_8_bit_sync		counterMSB_units		(	.qzt_clk(CLK_50M),
								.clk_in(w_tmp_carry_2),
								.limit(8'b00001010),
								.reset(0),

								.carry(),
								.out(w_in_MUX_1[7:4]));


/****************************************/
/*** Multiplexer to change visualization of the BCD numbers ***/
/****************************************/

//Synchronous multiplexer version

Module_Multiplexer_2_input_8_bit_sync  		multiplexer_1_sync	(	
								.clk_in(w_CLK_100_Hz),
								.address(SW),
								.input_0(w_in_MUX_0),
								.input_1(w_in_MUX_1),

								.mux_output(LED));

//Combinatorial multiplexer version

/*Module_Multiplexer_2_input_8_bit_comb  multiplexer_1_comb	(
								.address(SW),
								.input_0(w_in_MUX_0),
								.input_1(w_in_MUX_1),

								.mux_output(LED));	
								
*/

/****************************************/
/*** ... and hereafter what's left... ***/
/****************************************/

endmodule
