module	Module_SynchroCounter_12_bit_SR_custom_add	(	qzt_clk,
						clk_in,
						reset,
						set,
						presetValue,
						limit,
						step,

						out,
						carry);

input		qzt_clk;
input		clk_in;
input		set;
input		reset;
input	[11:0]	presetValue;
input	[11:0]	limit;
input 	[2:0]   step;

output	[11:0]	out;
output		carry;

reg	[11:0]	out;
reg		carry;

reg		clk_in_old;


always @(posedge qzt_clk) begin
	if (reset) begin
		out = 0;
		carry = 0;
	end else if (set) begin
		out = presetValue;
		carry = 0;
	end else if (!clk_in_old & clk_in) begin
		if (out >= (limit - 12'b00000001)) begin
			out = 0;
			carry = 1;
		end else if (out == 0) begin
			out = 1;
			carry = 0;
		end else
			out = out + step;
	end

	clk_in_old = clk_in;
end

endmodule
