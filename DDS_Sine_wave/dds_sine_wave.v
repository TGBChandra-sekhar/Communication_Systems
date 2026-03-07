`timescale 1ns / 1ps

module dds_sine_wave (
        clk,
        rst,
        fcw,
        sine_out
    );
    
    input clk;
    input rst;
    input [31:0]fcw;    // Frequency Control Word
    output reg signed [15:0]sine_out;
    
    reg [31:0] phase_acc;   // Phase Accumulator
    reg signed [15:0]sine_lut[0:255];
    
    wire [7:0]lut_addr;
    assign lut_addr = phase_acc[31:24];
    
    initial begin
        $readmemh("sine_lut.hex",sine_lut);
    end
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            sine_out  <= 16'sd0;
            phase_acc <= 32'd0;          
        end
        else begin
            phase_acc <= phase_acc + fcw;
            sine_out  <= sine_lut[lut_addr];
        end
    end
 endmodule
