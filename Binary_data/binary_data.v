`timescale 1ns / 1ps

module binary_data(
        clk,
        rst,
        binary_out
    );
     
    input clk;
    input rst;
    output reg binary_out;

    wire clk_1p023; // 1.023 MHz
    reg [9:0]register;
    
    wire feed_back;
    assign feed_back  = register[0]^register[7];
    
    clk_div_40 uut3 (
        .clk        (clk      ),        
        .rst        (rst      ),
        .clk_1p023  (clk_1p023) 
    );
        
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            register   <= 10'h3ff;
            binary_out <= 1'b0;
        end
        else begin
                if(clk_1p023) begin  // enable 1.023 MHz
                binary_out <= register[0];
                register   <= {feed_back,register[9:1]};
            end
        end
    end
endmodule

module clk_div_40 (
            clk,        
            rst,
            clk_1p023   
        );

    input  wire clk;       // 40.92 MHz
    input  wire rst;
    output reg  clk_1p023; // 1.023 MHz

    reg [5:0] count;  // count => 0 - 39 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count      <= 6'd0;
            clk_1p023  <= 1'b0;
        end
        else begin
            if (count  == 6'd39) begin
                count  <= 6'd0;          
            end
            else begin
                count  <= count + 6'd1;  
            end
            clk_1p023  <= (count == 6'd0); 
        end
    end
endmodule
 
