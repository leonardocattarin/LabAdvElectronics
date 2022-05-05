`define		defaultPeriod	30'b000000001001100010010110100000	//	25 10^6


module simpleCounter	(	CLK_50M,

				LED);

input		CLK_50M;

output	[7:0]	LED;

wire		w_clock_1_Hz;
wire		tmp_carry;


Module_FrequencyDivider		clock_1_Hz_generator	(	.clk_in(CLK_50M),
								.period(`defaultPeriod),

								.clk_out(w_clock_1_Hz));

Module_Counter_8_bit		counterLSB		(	.clk_in(w_clock_1_Hz),
								.limit(8'b00001010),

								.carry(tmp_carry),
								.out(LED));

Module_Counter_8_bit		counterMSB		(	.clk_in(tmp_carry),
								.limit(8'b00001010),

								.out(LED[7:4]));

endmodule
