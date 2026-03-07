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
