`timescale 1ns / 1ps

module binary_data_tb();
    reg clk;
    reg rst;
    wire binary_out;
    
    binary_data uut (
        .clk          (clk     ),
        .rst          (rst     ),
        .binary_out   (binary_out)
    );
    
    always #5 clk = ~clk;  //100Mhz
    
    initial begin
        clk = 1;
        rst = 1;
        #10; // 1-cycle
        rst = 0;
    end
endmodule
