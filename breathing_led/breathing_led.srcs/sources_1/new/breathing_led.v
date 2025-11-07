`timescale 1ns / 1ps
module breathing_led(
    input clk,
    input rst,
    input [3:0] sw,
    output wire led1,
    output wire led2,
    output wire led3,
    output wire led4
    );
    reg [31:0] cnt;    //计时器
    reg [31:0] pwm_cnt;//PWM计数器
    reg [16:0] brightness;  // 当前亮度值
    reg direction;//方向,1表示亮度增加，0表示亮度减小
    
    
    
    parameter CNT_MAX = 10000000;    //100ms
    parameter BRIGHTNESS_MAX = 10000;    //最大亮度
    parameter BRIGHTNESS_STEP = BRIGHTNESS_MAX / 25;    //每次亮度变化4%
    //pwm控制
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            pwm_cnt <= 0;
        end else begin
            if(pwm_cnt < BRIGHTNESS_MAX) begin
                pwm_cnt <= pwm_cnt + 1;
            end else begin
                pwm_cnt <= 0;
            end
        end
        
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst) begin
            cnt <= 0;    //计时归零
            brightness <= 0;  //初始亮度为0
            direction <= 1;//初始亮度方向为变亮
        end else begin
            if(cnt < CNT_MAX) begin
                cnt <= cnt + 1;
            end else begin
                cnt <= 0;
                if(direction) begin
                    if(brightness + BRIGHTNESS_STEP >= BRIGHTNESS_MAX)begin
                        brightness <= BRIGHTNESS_MAX;
                        direction <= 0; // 达到最大亮度，开始减少
                    end else begin
                        brightness <= brightness + BRIGHTNESS_STEP;
                    end
                end else begin
                    if(brightness <= BRIGHTNESS_STEP) begin
                            brightness <= 0;
                            direction <= 1;   //达到最小亮度，开始增大
                        end else begin
                            brightness <= brightness - BRIGHTNESS_STEP;
                        end                    
                    end
                end
            end
        end
    assign led1 = sw[0] ? ((pwm_cnt < brightness) ? 1 : 0) : 0;
    assign led2 = sw[1] ? ((pwm_cnt < brightness) ? 1 : 0) : 0;
    assign led3 = sw[2] ? ((pwm_cnt < brightness) ? 1 : 0) : 0;
    assign led4 = sw[3] ? ((pwm_cnt < brightness) ? 1 : 0) : 0;
endmodule
