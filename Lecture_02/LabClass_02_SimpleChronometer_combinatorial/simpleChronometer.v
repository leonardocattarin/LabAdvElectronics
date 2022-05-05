`define		defaultPeriod	30'b000001011111010111100001000000	//	25 10^6
`define		Period_100_Hz	30'd250000


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



Module_FrequencyDivider 	freq_divider_100		(
								.clk_in(CLK_50M),
								.period(`Period_100_Hz),

								.clk_out(w_CLK_100_Hz));


//	Begin cascade counters

Module_Counter_8_bit		counterLSB_decimals		(	
								.clk_in(w_CLK_100_Hz),
								.limit(8'b00001010),

								.carry(w_tmp_carry_0),
								.out(w_in_MUX_0[3:0]));

Module_Counter_8_bit		counterMSB_decimals		(	
								.clk_in(w_tmp_carry_0),
								.limit(8'b00001010),

								.carry(w_tmp_carry_1),
								.out(w_in_MUX_0[7:4]));


Module_Counter_8_bit		counterLSB_units		(	
								.clk_in(w_tmp_carry_1),
								.limit(8'b00001010),

								.carry(w_tmp_carry_2),
								.out(w_in_MUX_1[3:0]));


Module_Counter_8_bit		counterMSB_units		(	
								.clk_in(w_tmp_carry_2),
								.limit(8'b00001010),

								.carry(),
								.out(w_in_MUX_1[7:4]));


// Multiplexer




Module_Multiplexer_2_input_8_bit_comb  multiplexer_1	(
								.address(SW),
								.input_0(w_in_MUX_0),
								.input_1(w_in_MUX_1),

								.mux_output(LED));	
								

/****************************************/
/*** ... and hereafter what's left... ***/
/****************************************/

endmodule
