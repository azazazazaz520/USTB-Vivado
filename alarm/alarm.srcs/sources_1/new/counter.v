`timescale 1ns / 1ps
module counter(
    input  wire clk,
    input  wire rst,
    input  wire [2:0] speed_abs, // 速度档位 (0~4)
    input  wire [3:0] alarm_time, //外部输入的警报，作为倍数
    output wire clk_bps
);
    reg [26:0] cnt;
    reg [26:0] max_count;
    // 档位分频
    /*
    f(bps) = f(clk) / (max_count + 1)
    clk_bps = f(bps) / 2 
    */
    always @(*) begin
        case(speed_abs)
            3'd0: max_count = 27'd100_000_000; // 1Hz
            3'd1: max_count = 27'd80_000_000;  // 1.25Hz
            3'd2: max_count = 27'd60_000_000;  // 1.67Hz
            3'd3: max_count = 27'd40_000_000;  // 2.5Hz
            3'd4: max_count = 27'd20_000_000;  // 5Hz
            default: max_count = 32'd100_000_000;  //默认频率
        endcase
        max_count <= max_count >> alarm_time;
    end   
//cnt数数
    always @(posedge clk or posedge rst) begin
        if (rst)
            cnt <= 0;
        else if (cnt >= max_count)
            cnt <= 0;
        else
            cnt <= cnt + 1'b1;
    end

    assign clk_bps = (cnt == max_count);   //判断，每当数到max_count时，就输出一个脉冲，否则就输出0
endmodule