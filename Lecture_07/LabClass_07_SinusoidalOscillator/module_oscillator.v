module Module_Oscillator	(	clk_in,
					k,
					loadBoundaryCondition,
					boundaryCondition,

					wave);

input		clk_in;
input	[3:0]	k;
input		loadBoundaryCondition;
input	signed [16:0]	boundaryCondition;

// Insert below the necessary reg's and lines

output signed	[11:0]	wave;

reg signed	[11:0]	wave;
reg signed	[11:0]	wave_old;



always @(posedge clk_in) begin
	if (loadBoundaryCondition) begin
		wave <= boundaryCondition[16:5];
		wave_old <= boundaryCondition[16:5] - (boundaryCondition[16:5] >>> (k+1));
	end else begin 
		wave_old <= wave;
		wave <= (wave <<< 1) - (wave >>> k) - wave_old;
	end
	
end







// ...

endmodule
