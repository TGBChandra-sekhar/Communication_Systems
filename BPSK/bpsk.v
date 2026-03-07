 module bpsk (
       clk,
       rst,
       bpsk_out
    );
    
    input clk;
    input rst;
    output reg signed [15:0] bpsk_out;
    
    wire signed [15:0]sine_in;
    wire binary_in;
    
    sine_wave uut1 (
            .clk        (clk     ),
            .rst        (rst     ),
            .fcw        (32'd429496730),
            .sine_out   (sine_in)
    );
    
    binary_data uut2 (
           .clk         (clk       ),
           .rst         (rst       ),
           .binary_out  (binary_in)
    );
    
    always@(posedge clk or posedge rst) begin
        if(rst)begin
            bpsk_out <= 16'sd0;
        end
        else begin
            if(binary_in) begin
                bpsk_out <= ~sine_in + 1'd1;
            end
            else begin
                bpsk_out <= sine_in;
            end  
        end
    end
        
 endmodule
