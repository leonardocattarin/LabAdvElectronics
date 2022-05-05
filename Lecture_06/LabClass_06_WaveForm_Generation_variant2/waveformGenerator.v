/***************************/
/*** Sawtooth generator with variable slope/frequency ***/
/*** Implemented by variable step in counter ***/
/***************************/
module waveformGenerator	(	CLK_50M,

			SPI_SCK, SPI_MOSI, DAC_CS, DAC_CLR,
			SW_SIGN, SW_SLOPE
			);

input		CLK_50M;
input	[2:0]	SW_SLOPE;

input 		SW_SIGN;

output		SPI_SCK;
output		SPI_MOSI;
output		DAC_CS;
output		DAC_CLR;

wire		w_clock;
wire 		w_carryclock;

wire	[11:0]	wb_Va;
wire	[11:0]	wb_Vb;


/***************************/
/*** Counter to create SPI clock ***/
/***************************/

Module_Counter_8_bit		SPI_SCK_generator	(	.clk_in(CLK_50M),
								.limit(30'd4),		// 4x20 ns = 80 ns <===> 50/4 MHz = 12.5 MHz

								.carry(SPI_SCK));


/***************************/
/*** DAC Driver ***/
/***************************/

DAC_Driver			DAC_Driver		(	.CLK_50M(CLK_50M),
								.Va((SW_SIGN)? wb_Va : wb_Vb),.Vb(wb_Vb),
								.startEnable(1),

								.SPI_SCK(SPI_SCK),
								.SPI_MOSI(SPI_MOSI),
								.DAC_CS(DAC_CS),
								.DAC_CLR(DAC_CLR),
								.dacNumber(w_clock));

assign wb_Vb = ~wb_Va;

/***************************/
/*** Custom Counter for different switch-driven frequencies ***/
/***************************/
Module_SynchroCounter_12_bit_SR_custom_add Counter_saw_LSB	(	.qzt_clk(CLK_50M),
						.clk_in(w_clock),
						
						.limit(12'b0),
						.step(SW_SLOPE),

						.out(wb_Va),
						.carry(w_carryclock)
						);



endmodule
