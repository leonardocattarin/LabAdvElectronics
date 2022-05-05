/*****************************/
/*** Custom counter module ***/
/*** Increases only after the specified number of clock ticks STEP ***/
/*** Inverts counting direction when reaches limit_up or limit_down ***/
/*** NOTE: stops before reaching limit_up but for limit_down stops when it reaches it ***/
/*****************************/

module	Module_SynchroCounter_12_bit_SR_custom_add	(	qzt_clk,
						clk_in,
						reset,
						set,
						presetValue,
						limit_up,
						limit_down,
						step,

						out,
						carry);

input		qzt_clk;
input		clk_in;
input		set;
input		reset;
input	[11:0]	presetValue;
input	[11:0]	limit_up;
input	[11:0]	limit_down;
input 	[2:0]   step;

output	[11:0]	out;
output		carry;

reg	[11:0]	out;
reg		carry;

reg		clk_in_old;
reg [2:0]	counter = 0;
reg 	direction = 1;


always @(posedge qzt_clk) begin
	if (reset) begin
		out = 0;
		carry = 0;
	end else if (set) begin
		out = presetValue;
		carry = 0;
	end else if (!clk_in_old & clk_in) begin
		if (carry)begin
			carry = 0;
		end

		if (counter == step) begin
			if (out >= (limit_up - 12'b00000001)) begin
				out = out - 1;
				direction = !direction;
				carry = 1;
			end else if (out <= limit_down) begin
				out = out + 1;
				direction = !direction;
				carry = 1;
			end else if (direction) begin
				out = out + 1;
			end else begin
				out = out - 1;
			end
			counter = 0;
		end else begin
			counter = counter +1;
		end
	end

	clk_in_old = clk_in;
end

endmodule
