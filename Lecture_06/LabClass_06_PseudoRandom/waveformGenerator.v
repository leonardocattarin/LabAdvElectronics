`define		Period_1_Hz	30'd25000000
/*** remember frequency divider period is actually semiperiod ***/

module waveformGenerator	(	CLK_50M,

			SPI_SCK, SPI_MOSI, DAC_CS, DAC_CLR,
			SW,
			BTN_SOUTH,

			LED
			);

input		CLK_50M;

input 		SW;
input		BTN_SOUTH;

output		SPI_SCK;
output		SPI_MOSI;
output		DAC_CS;
output		DAC_CLR;

output 	[7:0]	LED;

wire		w_clock;
wire 		w_carryclock;

wire	[11:0]	wb_Va;
wire	[11:0]	wb_Vb;

wire    w_1Hz_clk;
wire 	[30:0]	wb_shift_out;


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



Module_shiftRegister_31_bit ShiftRegister (	.qzt_clk(CLK_50M),
                    .clk_in(w_1Hz_clk),
					.input_serial((SW)? (wb_shift_out[30] ^ wb_shift_out[27]) : BTN_SOUTH),

					.out(wb_shift_out));

assign LED = {wb_shift_out[5], wb_shift_out[23], wb_shift_out[16], wb_shift_out[3], wb_shift_out[0], wb_shift_out[11], wb_shift_out[24], wb_shift_out[30]};


Module_FrequencyDivider Clock_1Hz	(	.clk_in(CLK_50M),
					.period(`Period_1_Hz),

					.clk_out(w_1Hz_clk));




endmodule
