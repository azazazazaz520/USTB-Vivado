`timescale 1ns / 1ps
module lock(
    input clk,
    input rst,
    input in,           // 每周期输入一位二进制数据
    output reg unlock   // 输出解锁信号
);
    
    parameter [15:0] STU_PWD = {4'd4, 4'd4, 4'd7, 4'd5};

    reg [3:0] bit_cnt;       // 记录当前已输入的位数
    reg [3:0] digit;         // 当前拼成的4位数字
    reg [15:0] input_num;    // 存储输入的4个数字（共16位）
    reg [2:0] num_cnt;       // 当前已存入的数字个数
    reg input_done;          // 输入结束标志
    reg [1:0] state;         // 状态机

    localparam IDLE = 2'b00,
               INPUT = 2'b01,
               CHECK = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_cnt <= 0;
            digit <= 0;
            num_cnt <= 0;
            input_num <= 0;
            unlock <= 0;
            input_done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    unlock <= 0;
                    if (!rst) begin
                        bit_cnt <= 0;
                        digit <= 0;
                        num_cnt <= 0;
                        input_num <= 0;
                        input_done <= 0;
                        state <= INPUT;
                    end
                end

                INPUT: begin
                    // 每个周期移入一位
                    digit <= {digit[2:0], in};
                    bit_cnt <= bit_cnt + 1;

                    // 每四位组成一个数字
                    if (bit_cnt == 3) begin
                        // 4位组合完毕
                        if (digit <= 9) begin
                            // 合法数字
                            input_num <= {input_num[11:0], digit};
                            num_cnt <= num_cnt + 1;
                        end else begin
                            // 非法，视为结束符
                            input_done <= 1;
                        end
                        bit_cnt <= 0;
                        digit <= 0;
                    end

                    // 输入结束或输入满4个数字
                    if (input_done || num_cnt == 4) begin
                        state <= CHECK;
                    end
                end

                CHECK: begin
                    // 比较输入与学号后四位
                    if (num_cnt == 4 && input_num == STU_PWD)
                        unlock <= 1;
                    else
                        unlock <= 0;
                    state <= IDLE; // 下一周期自动复位
                end
            endcase
        end
    end
endmodule
