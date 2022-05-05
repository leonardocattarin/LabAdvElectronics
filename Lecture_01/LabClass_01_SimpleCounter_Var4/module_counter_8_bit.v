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
		out = limit - 8'b00000001;
		carry = 1;

	end else if (out == limit - 8'b00000001) begin
		carry = 0;
		out = out - 1;
	end else
		out = out - 1;
end

endmodule
