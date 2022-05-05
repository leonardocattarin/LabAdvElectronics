


/*******************************/
/*** Module_FrequencyDivider ***/
/*******************************/

module	Module_FrequencyDivider	(	clk_in,
					period,

					clk_out);

input		clk_in;
input	[29:0]	period;

output		clk_out;

reg		clk_out;

reg	[29:0]	counter;

always @(posedge clk_in) begin
	if (counter >= (period - 1)) begin
		counter <= 0;
		clk_out <= ~clk_out;
	end else
		counter <= counter + 1;
end

endmodule

/****************************/
/*** Module_Counter_8_bit ***/
/****************************/

module	Module_Counter_8_bit	(	clk_in,
					limit,

					out,
					carry);

input		clk_in;
input	[7:0]	limit;

output	[7:0]	out;
output		carry;

reg	[7:0]	out;
reg		carry;

always @(posedge clk_in) begin
	if (out >= (limit - 8'b00000001)) begin
		out <= 0;
		carry <= 1;
	end else if (out == 0) begin
		out <= 1;
		carry <= 0;
	end else
		out <= out + 1;
end

endmodule

/**************************************/
/*** Module_SynchroCounter_8_bit_SR ***/
/**************************************/

module	Module_SynchroCounter_8_bit_SR	(	qzt_clk,
						clk_in,
						reset,
						set,
						presetValue,
						limit,

						out,
						carry);

input		qzt_clk;
input		clk_in;
input		reset;
input		set;
input	[7:0]	presetValue;
input	[7:0]	limit;

output	[7:0]	out;
output		carry;

reg	[7:0]	out;
reg		carry;

reg		clk_in_old;


always @(posedge qzt_clk) begin
	if (reset) begin
		out <= 0;
		carry <= 0;
	end else if (set) begin
		out <= presetValue;
		carry <= 0;
	end else if (!clk_in_old & clk_in) begin
		if (out >= (limit - 8'b00000001)) begin
			out <= 0;
			carry <= 1;
		end else if (out == 0) begin
			out <= 1;
			carry <= 0;
		end else
			out <= out + 1;
	end

	clk_in_old <= clk_in;
end

endmodule

/*********************************************/
/*** Module_Multiplexer_2_input_8_bit_sync ***/
/*********************************************/

module	Module_Multiplexer_2_input_8_bit_sync	(	clk_in,
							address,
							input_0,
							input_1,

							mux_output);

input		clk_in;
input		address;
input	[7:0]	input_0;
input	[7:0]	input_1;

output	[7:0]	mux_output;

reg	[7:0]	mux_output;

always @(posedge clk_in) begin
	mux_output <= (address)? input_1 : input_0;
end

endmodule

/*********************************************/
/*** Module_Toggle_Flip_Flop_sync ***/
/*********************************************/

module	Module_Toggle_Flip_Flop_sync		(		qzt_clk,
							input_0,

							out);

input 		qzt_clk;
input		input_0;

output		out;

reg 		out;
reg 		input_old; //added to remove problem of half intensity


always @(posedge qzt_clk) begin
	out<= (input_0 & ~input_old)? ~out: out;
	input_old <= input_0;
end

endmodule


/*********************************************/
/*** Module_Monostable_Multivibrator_sync ***/
/*********************************************/

module	Module_Monostable_Multivibrator_sync	(	qzt_clk,
							input_0,
							period,

							out);

input 			qzt_clk;
input			input_0;
input [29:0]	period;

output			out;

reg 			out;
reg	[29:0]		counter = 0;
reg				count_flag = 0;



always @(posedge qzt_clk) begin
	if (count_flag) begin
		if (counter >= (period - 1)) begin
			counter <= 0;
			out <= 0;

			count_flag <= 0;
		end else
			counter <= counter + 1;

	end else if(input_0) begin
			count_flag <= 1;
			out <= 1;
			counter <= counter + 1;
		end

end



endmodule


/*********************************************/
/*** Module_Latch_8bit_sync ***/
/*********************************************/

module	Module_Latch_8bit_sync		(		qzt_clk,
							input_0,

							out);

input 			qzt_clk;
input	[7:0]	input_0;

output	[7:0]	out;

reg 	[7:0]	out;


always @(posedge qzt_clk) begin
	out<= input_0;
end

endmodule
