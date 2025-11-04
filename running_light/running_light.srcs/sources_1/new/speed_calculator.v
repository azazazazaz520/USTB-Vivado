`timescale 1ns / 1ps
module speed_calculator(
    input  [7:0] sw,         // 8个拨码输入
    output reg dir,          // 方向：0=右移，1=左移
    output reg [2:0] speed_abs // 速度绝对值(0到4)
);
    // 计算高电平数
    function [3:0] count_ones;
        input [7:0] data;
        integer i;
        begin
            count_ones = 0;
            for(i = 0; i < 8; i = i + 1)
                if(data[i]) count_ones = count_ones + 1;
        end
    endfunction

    wire [3:0] high_count = count_ones(sw);    //计数高电平拨码的数量

    
    always @(*) begin
        if (high_count >= 4) begin
            dir = 1'b0; // 右移
            speed_abs = (high_count - 4);
        end else begin
            dir = 1'b1; // 左移
            speed_abs = (4 - high_count);
        end
    end
endmodule
