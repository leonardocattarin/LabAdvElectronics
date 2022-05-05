/***************************/
/*** Advanced differentiator, V8 switch changes bedween delay and differentiator mode***/
/***************************/

module nyquist	(	CLK_50M,
				SW_FREQ,
				SW_DIFF,
				ADC_OUT,

				DAC_CS,
				DAC_CLR,
				SPI_SCK,
				AMP_CS,
				SPI_MOSI,
				AD_CONV);

input		CLK_50M;
input		SW_FREQ;
input		SW_DIFF;
input		ADC_OUT;

output		DAC_CS;
output		DAC_CLR;
output		SPI_SCK;
output		SPI_MOSI;
output		AMP_CS;
output		AD_CONV;

wire		w_SPI_MOSI_preAmp;
wire		w_SPI_MOSI_DAC;
wire		w_dacNumber;

//ADC output wirebuses
wire	[13:0]	wb_Va;
wire	[13:0]	wb_Vb;

//delayed ADC outputs, number stands for number of delay periods
wire 	[13:0]	wb_Va_d1;
wire 	[13:0]	wb_Va_d2;

wire 	[13:0]	wb_Va_difference;


buf(SPI_MOSI, ((AMP_CS & w_SPI_MOSI_DAC)|(!AMP_CS & w_SPI_MOSI_preAmp)));


/***************************/
/*** Counter for SPI clock and ADC/DAC drivers ***/
/***************************/

Module_Counter_8_bit	SPI_SCK_generator	(	.clk_in(CLK_50M),
							.limit(((SW_FREQ)? 30'd10 : 30'd4)),

							.carry(SPI_SCK));

ADC_Driver		ADC_Driver		(	.qzt_clk(CLK_50M), 
							.SPI_SCK(SPI_SCK), 
							.enable(1),
							.ADC_OUT(ADC_OUT), 
							.gainLabel(0),
							.waitTime({SW_FREQ,4'b0000}), 

							.AD_CONV(AD_CONV),
							.Va_Vb({wb_Va, wb_Vb}),
							.AMP_CS(AMP_CS), 
							.SPI_MOSI(w_SPI_MOSI_preAmp)); 

//NOTE: SW_DIFF (V8) switches delay/differentiate mode
DAC_Driver		DAC_Driver		(	.CLK_50M(CLK_50M),
							.SPI_SCK(SPI_SCK), 
							.Va({!wb_Va[13], wb_Va[12:2]}), 
							.Vb((SW_DIFF)? {!wb_Va_d1[13], wb_Va_d1[12:2]} : {!wb_Va_difference[13], wb_Va_difference[12:2]}), //Vb wirebus input
							.startEnable(AD_CONV), 

							.SPI_MOSI(w_SPI_MOSI_DAC),
							.DAC_CS(DAC_CS),
							.DAC_CLR(DAC_CLR),
							.dacNumber(w_dacNumber));


/***************************/
/*** Latch to hold from precedent times, (t-1) and (t-2). ***/
/***************************/

Module_Latch_14_bit		Data_Latch_D1	(	!w_dacNumber,
					0,
					wb_Va,

					wb_Va_d1);

Module_Latch_14_bit		Data_Latch_D2	(	!w_dacNumber,
					0,
					wb_Va_d1,

					wb_Va_d2);


/***************************/
/*** Combinatorial module to perform differentiation in 14 bit bipolar (2's complement) ***/
/***************************/

Module_Bipolar_Advanced_Difference_14_bit_Combinatorial Difference_Module	(
								.data_2(wb_Va_d2),
                                .data_1(wb_Va_d1),
                                .data_0(wb_Va),

                                .difference(wb_Va_difference));

endmodule