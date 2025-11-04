`timescale 1ns / 1ps

module tb_key_Filter;


reg clk;
reg rst;
reg key;
wire key_out;


key_Filter A (
    .clk(clk),
    .rst(rst),
    .key(key),
    .key_out(key_out)
);


// 模拟 1MHz 时钟
initial begin
    clk = 0;
    forever #500 clk = ~clk; // 每 500ns 翻转一次 -> 1us 周期
end


initial begin
    // 初始化
    rst = 1;
    key = 0;
    #2000;         // 等待 2us

    rst = 0;       // 释放复位
    #2000;

    // 模拟一次按键按下
    key = 1; #1000;
    key = 0; #500;
    key = 1; #500;
    key = 0; #500;
    key = 1; #500;   // 模拟按下时的抖动

   
    key = 1;
    #40000000;   

    // 模拟按键释放时的抖动
    key = 0; #1000;
    key = 1; #500;
    key = 0; #500;
    key = 1; #500;
    key = 0; #500;
    key = 0;
    #40000;

    // 结束仿真
    $stop;
end

endmodule
