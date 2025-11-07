`timescale 1ns / 1ps
module reaction_timer(
    input clk,
    input rst,
    input button1,   //按钮1
    input button2,   //按钮2
    output reg [3:0] pos,
    output reg led, //led灯输出
    output reg [7:0] seg
    );
    //第一个按键的消抖,输出给测反应开始的信号button_start
    key_Filter kf1(
        .clk(clk),
        .rst(rst),
        .key(button1),
        .key_out(button_start)
    );
    
    key_Filter kf2(
        .clk(clk),
        .rst(rst),
        .key(button2),
        .key_out(button_end)
    );
    parameter IDLE = 1'b0;  //闲置      
    parameter TIMING = 2'b01;
    parameter FINISHED = 2'b10;
    parameter INVALID = 2'b11;
    
    parameter TIME_UNIT = 1000000; // 每 10 毫秒的计数值
    
    reg state,next_state;  //状态机的状态
    wire button_start;  //测反应开始的信号button_start
    wire button_end;  //测反应结束的信号button_end
    reg [31:0]counter; //计数器
    reg [15:0] tm;  //计时结果
    always@(posedge clk or posedge rst) begin
        if(rst)begin
            state = IDLE;
        end else begin
            state = next_state;
        end        
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst) begin
            led <= 1'b0;
            counter <= 0;
            tm <= 0;
        end else begin
            case(state)
                IDLE:begin
                    led <= 0;
                    counter <= 0;
                    if(button_start) tm <= 0;
                end
                TIMING:begin
                    led <= 1;
                    counter <= counter + 1;
                    if(counter == TIME_UNIT)begin
                        counter <= 0;
                        tm <= tm + 1;
                    end 
                end
                FINISHED: begin
                    led <= 0; // LED 熄灭
                    counter <= 0; // 停止计时
                end

                INVALID: begin
                    led <= 0;
                    tm <= 99;
                    counter <= 0;
                end     
            endcase
        end
    end
    
    always@(*) begin
        case(state)
            IDLE:begin
                if(button_start)begin
                    next_state = TIMING;
                end else begin
                    next_state = IDLE;
                end
            end
            
            TIMING: begin
                if(button_end)begin
                    if(tm > 10) begin
                        next_state = FINISHED;
                    end else begin
                        next_state = INVALID;
                    end
                end else begin
                    next_state = TIMING;
                end
            end
            FINISHED: begin
                next_state = FINISHED; // 等待重新开始
            end

            INVALID: begin
                next_state = INVALID;
            end
            
            default: next_state = IDLE;    
        endcase
    end
    
    // 分频实现数码管

    reg         disp_bit = 0;
    reg [18:0]  divclk_cnt = 0;
    reg         divclk = 0;
//分频
    always@(posedge clk) begin
        if(divclk_cnt == 16'd50000) begin
            divclk <= ~divclk;  //取反，实现分频1000hz
            divclk_cnt <= 0;
        end
        else
            divclk_cnt <= divclk_cnt + 1'b1;
    end

    reg [3:0] tme1, tme2;

    always @(posedge clk) begin
	   if(divclk) begin
            disp_bit <= ~disp_bit;
            tme1 <= tm % 10;
            tme2 <= tm / 10;
            if(disp_bit) begin    
                pos = 4'b0010;
                case(tme1)
                    4'b0000:seg = 8'b0011_1111;
                    4'b0001:seg = 8'b0000_0110;
                    4'b0010:seg = 8'b0101_1011;
                    4'b0011:seg = 8'b0100_1111;
                    4'b0100:seg = 8'b0110_0110;
                    4'b0101:seg = 8'b0110_1101;
                    4'b0110:seg = 8'b0111_1101;
                    4'b0111:seg = 8'b0000_0111;
                    4'b1000:seg = 8'b0111_1111;
                    4'b1001:seg = 8'b0110_1111;
                    default:seg = 8'b0000_0000;
                endcase
            end
            else begin
                pos = 4'b0001;
                case(tme2)
                    4'b0000:seg = 8'b0011_1111;
                    4'b0001:seg = 8'b0000_0110;
                    4'b0010:seg = 8'b0101_1011;
                    4'b0011:seg = 8'b0100_1111;
                    4'b0100:seg = 8'b0110_0110;
                    4'b0101:seg = 8'b0110_1101;
                    4'b0110:seg = 8'b0111_1101;
                    4'b0111:seg = 8'b0000_0111;
                    4'b1000:seg = 8'b0111_1111;
                    4'b1001:seg = 8'b0110_1111;
                    default:seg = 8'b0000_0000;
                endcase	
            end
        end
	end
    
endmodule
