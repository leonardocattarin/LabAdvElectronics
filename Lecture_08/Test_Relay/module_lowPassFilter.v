module Module_LowPassFilter	(	qzt_clk,
					clk_in,
					k,
					Vin,

					Vout);

input		qzt_clk;
input		clk_in;
input	[3:0]	k;
input signed	[19:0]	Vin;

output signed	[19:0]	Vout;

reg signed	[19:0]	Vout;
reg signed	[19:0]	Vin_old;
reg		clk_in_old;

// Insert below the necessary reg's and lines

always @(posedge qzt_clk) begin
	if(clk_in & !clk_in_old)begin
		Vin_old <= Vin;

		Vout <= Vin;

	end
	clk_in_old <= clk_in;
end


endmodule
