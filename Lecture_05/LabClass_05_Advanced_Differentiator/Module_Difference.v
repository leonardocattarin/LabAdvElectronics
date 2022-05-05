/***************************/
/*** Module_Bipolar_Difference_14_bit_Combinatorial ***/
/***************************/

module	Module_Bipolar_Advanced_Difference_14_bit_Combinatorial	(	
                                data_2,
                                data_1,
                                data_0,

                                difference);

input signed data_2;
input signed data_1;
input signed data_0;

output signed difference;

wire  signed [13:0] data_2;
wire  signed [13:0] data_1;
wire  signed [13:0] data_0;

wire  signed [13:0] difference;

assign difference = (3*data_0-4*data_1+data_2)>>>1 ;

endmodule