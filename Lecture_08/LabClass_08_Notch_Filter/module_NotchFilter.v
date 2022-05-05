module Module_NotchFilter	(	qzt_clk,
					clk_in,
					k,
					Vin,
					reset,

					Vout);

input		qzt_clk;
input		clk_in;
input 		reset;
input	[3:0]	k;
input signed	[19:0]	Vin;

output signed	[19:0]	Vout;

reg signed	[19:0]	Vout;
reg signed	[19:0]	Vin_old_1;
reg signed	[19:0]	Vin_old_2;

reg signed	[19:0]	Vout_old_2;
reg		clk_in_old;

// Insert below the necessary reg's and lines

always @(posedge qzt_clk) begin
	if(clk_in & !clk_in_old)begin
		Vin_old_1 <= Vin;
		Vin_old_2 <= Vin_old_1;

		
		Vout_old_2 <= Vout;

		//if c^2 = 1-2^(-k)	
		Vout <= Vin + Vin_old_2 - (Vin>>>(k+1)) - (Vin_old_2>>>(k+1)) - Vout_old_2 + (Vout_old_2>>>k);

		//alternative design, if c = 1-2^(-k)	
		//Vout <= Vin +Vin_old_2 + Vin>>(2*k+1) + Vin_old_2>>(2*k+1) -Vin>>k -Vin_old_2>>k -Vout_old_2 -Vout_old_2>>(2*k) + Vout_old_2>>(k-1);
	end
	if (reset)begin
		Vin_old_1 <= 0;
		Vin_old_2 <= 0;

		Vout_old_2 <= 0;
	end

	clk_in_old <= clk_in;
end


endmodule
