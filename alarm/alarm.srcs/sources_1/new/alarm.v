`timescale 1ns / 1ps

module alarm(
    input clk,
    input rst,
    input [3:0] sw_on_board,//板上开关，用于调节闪烁频率的倍数
    input key_to_active,//激活警报的按键
    output alarm_led,   //警报灯
    output [7:0]display,//数码管
    output ena      //数码管使能
    );
    wire [7:0] dis;
    key_Filter kf(    //实例化消抖模块
        .clk(clk),
        .rst(rst),
        .key(key_to_active),
        .key_out(key_active)
    );
    segMsg seg(     //数码管
        .alarm_time(alarm_time),
        .pos(ena),
        .seg(dis)
    );
    counter cter(  //分频器
        .clk(clk),
        .rst(rst),
        .speed_abs(speed_abs),
        .alarm_time(alarm_time),
        .clk_bps(clk_bps)
    );
    reg [3:0] alarm_time;//警报次数
    reg key_active_prev; //记录key_active前一个时钟周期的状态
    wire key_active;//储存消抖后的按键输入 
    reg sw;//切换led的点亮和熄灭
    reg led;//记录led的真实状态
    wire key_rising;//记录按键上升沿
    wire clk_bps;
    reg [2:0] speed_abs;//sw传给这个量作为调节速度的选项
    reg sw_prev; //记录led先前的状态
    reg start_state = 1'b0;//记录是否是板子运行的开始
    always @(posedge clk)
        key_active_prev <= key_active;
    
    assign key_rising = key_active & ~key_active_prev;  //只有当key_active为1且key_active_prev为0时才为高
   
   always @(posedge clk) begin
        if (key_rising) begin
            sw <= ~sw;             
        end
    end
   
   //计算speed_abs
   always @(posedge clk) begin
        case(sw_on_board)
        4'b0000:speed_abs = 3'd0;
        
        4'b0001:speed_abs = 3'd1;
        4'b0010:speed_abs = 3'd1;
        4'b0100:speed_abs = 3'd1;
        4'b1000:speed_abs = 3'd1;
        
        4'b0011:speed_abs = 3'd2;
        4'b0110:speed_abs = 3'd2;
        4'b1100:speed_abs = 3'd2;
        4'b1010:speed_abs = 3'd2;
        4'b0101:speed_abs = 3'd2;
        4'b1001:speed_abs = 3'd2;
        
        4'b1110:speed_abs = 3'd3;
        4'b0111:speed_abs = 3'd3;
        4'b1101:speed_abs = 3'd3;
        4'b1011:speed_abs = 3'd3;
        
        4'b1111:speed_abs = 3'd4;
        endcase
   end
   always @(posedge clk or posedge rst) begin
            if (rst) begin                
                if(!start_state)begin
                alarm_time <= 4'b0000;                
                end
                else begin 
                alarm_time <= 4'b0001;
                end
            end
            else begin
                start_state <= 1'b1;
                sw_prev <= sw;  // 保存上一次的LED状态
                if (sw & clk_bps) begin
                    led <= ~led;  // 闪烁翻转
                end
                else if (~sw) begin
                    led <= 1'b0;  // 关闭闪烁时直接熄灭
                end
        
                // 检测上升沿（sw从0变1时）
                if (~sw_prev & sw) begin
                    alarm_time <= alarm_time + 1;
                end
            end     
   end
   assign alarm_led = led;
   assign ena = 1'b1;
   assign display = dis;
endmodule
