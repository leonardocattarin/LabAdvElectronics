/***************************/
/*** Simple signal delayer***/
/***************************/


module nyquist	(	CLK_50M,
				SW,
				ADC_OUT,

				DAC_CS,
				DAC_CLR,
				SPI_SCK,
				AMP_CS,
				SPI_MOSI,
				AD_CONV);

input		CLK_50M;
input		SW;
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
wire 	[13:0]	wb_Va_delayed;


buf(SPI_MOSI, ((AMP_CS & w_SPI_MOSI_DAC)|(!AMP_CS & w_SPI_MOSI_preAmp)));


Module_Counter_8_bit	SPI_SCK_generator	(	.clk_in(CLK_50M),
							.limit(((SW)? 30'd10 : 30'd4)),

							.carry(SPI_SCK));

ADC_Driver		ADC_Driver		(	.qzt_clk(CLK_50M), //master clock
							.SPI_SCK(SPI_SCK), //SPI clock
							.enable(1),//enable flag
							.ADC_OUT(ADC_OUT), //hardware wire from ADC
							.gainLabel(0),
							.waitTime({SW,4'b0000}), //some kind of delay

							.AD_CONV(AD_CONV),//connected to DAC
							.Va_Vb({wb_Va, wb_Vb}),//actual outputwirebuses, MS is A and LS is B
							.AMP_CS(AMP_CS), //spi stuff 
							.SPI_MOSI(w_SPI_MOSI_preAmp)); //spi stuff


DAC_Driver		DAC_Driver		(	.CLK_50M(CLK_50M),
							.SPI_SCK(SPI_SCK), //spi clock
							.Va({!wb_Va[13], wb_Va[12:2]}), //Va wirebus input
							.Vb({!wb_Va_delayed[13], wb_Va_delayed[12:2]}), //Vb wirebus input
							.startEnable(AD_CONV), 

							.SPI_MOSI(w_SPI_MOSI_DAC),
							.DAC_CS(DAC_CS),
							.DAC_CLR(DAC_CLR),
							.dacNumber(w_dacNumber));


/***************************/
/*** Latch to hold signal for a single sampling period***/
/***************************/

Module_Latch_14_bit		Data_Latch	(	!w_dacNumber,
					0,
					wb_Va,

					wb_Va_delayed);

endmodule