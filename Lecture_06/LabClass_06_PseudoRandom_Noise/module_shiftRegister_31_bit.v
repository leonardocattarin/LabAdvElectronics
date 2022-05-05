module	Module_shiftRegister_31_bit	(	qzt_clk,
                    clk_in,

					input_serial,

					out);

input qzt_clk;
input clk_in;
input input_serial;

output [30:0] out;

reg [30:0] out;
reg clk_in_old;

always @(posedge qzt_clk) begin
    if(clk_in & !clk_in_old)begin
        
            out[30:1] <= out[29:0];
            out[0] <= input_serial;

    end

clk_in_old <= clk_in;
end




endmodule