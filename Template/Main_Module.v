module Main_Module	(	CLK_50M, 
				SW, 
				ADC_OUT, 

				DAC_CS, 
				DAC_CLR, 
				SPI_SCK, 
				AMP_CS, 
				SPI_MOSI, 
				AD_CONV); 

//main clock, 50 MHz
input		CLK_50M;

//switches and Output of hardware ADC to soft module
input		SW;
input		ADC_OUT;

output		DAC_CS; //output from dac module (?)
output		DAC_CLR; //output from dac module (?)
output		SPI_SCK; // SPI serial clock, used by both modules
output		SPI_MOSI; //spi master output slave input, obtained from both modules
output		AMP_CS; //output from ADC
output		AD_CONV; //output from ADC (?)


wire		w_SPI_MOSI_preAmp;
wire		w_SPI_MOSI_DAC;
wire		w_dacNumber; //use its negation as sampling clock

//Digitalized signals from ADC
wire	[13:0]	wb_Va;
wire	[13:0]	wb_Vb;

// ADC/DAC
buf(SPI_MOSI, ((AMP_CS & w_SPI_MOSI_DAC)|(!AMP_CS & w_SPI_MOSI_preAmp)));

//LCD Screen
buf(LCD_RW, 0);
buf(LCD_DB[3:0], 4'b1111);


/***************************/
/*** LCD Screen Driver ***/
/***************************/
LCD_Driver	lcd_driver	(	.qzt_clk(CLK_50M), //clock
						.fourDigitInput(wb_counter_toShow), //input digits
						.lapFlag(w_lapFlag), //Flag for blinking

						.lcd_flags({LCD_RS, LCD_E}),
						.lcd_data(LCD_DB[7:4]));



/***************************/
/*** SPI Clock Generator ***/
/***************************/
// limit 30'd4 => f_SPI = 50e+6/4 = 12.5e+6 Hz => 183822.550 Hz
// limit 30'd10 => f_SPI = 50e+6/10 = 5+6 Hz => 49999.689 Hz
// explore more to understand 

Module_Counter_8_bit	SPI_SCK_generator	(	.clk_in(CLK_50M),
							.limit(((SW)? 30'd10 : 30'd4)), //Regulates Sampling Frequency

							.carry(SPI_SCK));



/***************************/
/*** ADC Driver Module ***/
/***************************/

ADC_Driver		ADC_Driver		(	.qzt_clk(CLK_50M), //Master Clock
							.SPI_SCK(SPI_SCK), //SPI Clock
							.enable(1), //Enable pin
							.ADC_OUT(ADC_OUT), //Input signal from Hardware ADC
							.gainLabel(0), // (?)
							.waitTime({SW,4'b0000}), //Sets Delay (0 or 4'd8 = 4'b10000)

							.AD_CONV(AD_CONV),
							.Va_Vb({wb_Va, wb_Vb}), //Digitalized signals
							.AMP_CS(AMP_CS),
							.SPI_MOSI(w_SPI_MOSI_preAmp));


/***************************/
/*** DAC Driver Module ***/
/***************************/
DAC_Driver		DAC_Driver		(	.CLK_50M(CLK_50M),
							.SPI_SCK(SPI_SCK),
							.Va({!wb_Va[13], wb_Va[12:2]}), //DAC Inputa A
							.Vb({!wb_Vb[13], wb_Vb[12:2]}), //DAC Inputa B
							.startEnable(AD_CONV),

							.SPI_MOSI(w_SPI_MOSI_DAC),
							.DAC_CS(DAC_CS),
							.DAC_CLR(DAC_CLR),
							.dacNumber(w_dacNumber));

							

endmodule
