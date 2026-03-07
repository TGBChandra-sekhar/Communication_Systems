`timescale 1ns / 1ps

module binary_data(
        clk,
        rst,
        binary_out
    );
    
    input clk;
    input rst;
    output reg binary_out;
    
    reg [9:0]register;
    
    wire feed_back;
    assign feed_back  = register[0]^register[7];
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            register   <= 10'h3ff;
            binary_out <= 1'b0;
        end
        else begin
            binary_out <= register[0];
            register   <= {feed_back,register[9:1]};
            
        end
    end
 endmodule
