/***************************/
/*** Module_Bipolar_Difference_14_bit_Combinatorial ***/
/***************************/

module	Module_Bipolar_Difference_14_bit_Combinatorial	(	
                                old_data,
                                new_data,

                                difference);

input old_data;
input new_data;

output difference;

wire  [13:0] old_data;
wire  [13:0] new_data;

wire  [13:0] difference;

assign difference = new_data - old_data;

endmodule