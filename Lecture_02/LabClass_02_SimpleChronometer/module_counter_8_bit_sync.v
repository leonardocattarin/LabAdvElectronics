module	Module_Counter_8_bit_sync	(	qzt_clk,
						clk_in,
						limit,
						reset,

						out,
						carry);

input		qzt_clk;
input		clk_in;
input		reset;	
input	[7:0]	limit;

output	[7:0]	out;
output		carry;

reg	[7:0]	out;
reg		carry;
reg		clk_old = 0;

always @(posedge qzt_clk) begin
	if (reset)begin
		out = 8'b00000000;
		carry = 0;
	end else
	if (clk_in & !clk_old) begin
		clk_old <=clk_in;
		
		if (out >= (limit - 8'b00000001)) begin
		out = 0;
		carry = 1;
		end else if (out == 0) begin
		out = 1;
		carry = 0;
		end else
		out = out + 1;
	end 
	else if(!clk_in & clk_old)	
			clk_old <=clk_in;
			
end

endmodule
