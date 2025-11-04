`timescale 1ns / 1ps
module key_Filter(
    input clk,
    input rst,
    input wire key,
    output wire key_out
    );
    parameter integer CNT_MAX = 2000000; //延长时间20ms
    reg [31:0] cnt = 0; //增加初始化
    reg key_state = 0; //增加初始化
    always@(posedge clk or posedge rst)begin
        if(rst)begin
        cnt <= 16'b0000_0000_0000_0000;
        key_state <= 1'b0;
        end
        else if(key == 1'b1) begin
                cnt <= cnt + 1'b1;
                if(cnt >= CNT_MAX) begin
                    key_state <= key;  
                    cnt <= 16'd0;
                end
            end
            else begin
                cnt <= 0;
                key_state <= 1'b0;
            end
    end
    assign key_out = key_state;
endmodule