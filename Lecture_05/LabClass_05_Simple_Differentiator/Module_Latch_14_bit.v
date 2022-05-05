/***************************/
/*** Module_Latch_14_bit ***/
/***************************/

module	Module_Latch_14_bit	(	clk_in,
					holdFlag,
					twoByteInput,

					twoByteOuput);

input		clk_in;
input		holdFlag;
input	[13:0]	twoByteInput;

output	[13:0]	twoByteOuput;

reg	[13:0]	twoByteOuput;


always @(posedge clk_in) begin
	if (!holdFlag) twoByteOuput <= twoByteInput;
end

endmodule
