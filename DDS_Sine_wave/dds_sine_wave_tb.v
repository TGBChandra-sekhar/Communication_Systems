`timescale 1ns / 1ps

module dds_sine_wave_tb();
    reg clk;
    reg rst;
    reg [31:0]fcw;
    wire signed [15:0]sine_out;
    
    dds_sine_wave uut (
        .clk        (clk     ),
        .rst        (rst     ),
        .fcw        (fcw     ),
        .sine_out   (sine_out)
    );
    
    always #12.21896 clk = ~clk; //40.92MHz 
    
    initial begin
        clk = 1;
        rst = 1;
        fcw = 0;
        #24.4379; // 1-cycle
        rst = 0;
        fcw = 32'd429496730; 
    end
endmodule
