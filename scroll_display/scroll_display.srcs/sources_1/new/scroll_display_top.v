`timescale 1ns / 1ps
module scroll_display_top(
    input clk,
    input rst,
    output reg [7:0] seg,
    output reg [3:0] pos     // 选择显示哪个数码管
    );
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;
    wire [7:0] seg4;//用于存储解码器模块传过来的7位输出
    //实例化七段数码管解码器4个
    decode_7seg seg_1(.value(char_map[51:48]),.seg(seg1));
    decode_7seg seg_2(.value(char_map[47:44]),.seg(seg2));
    decode_7seg seg_3(.value(char_map[43:40]),.seg(seg3));
    decode_7seg seg_4(.value(char_map[39:36]),.seg(seg4));
    
    reg [51:0] char_map = 52'b1100_1100_1011_1010_0010_0000_0010_0100_0100_0010_0100_0111_0101;   //YYTU202442475
                                                                                                  //CCBA16进制对应
    reg [31:0] scroll_cnt;   //计数
    parameter scroll_delay = 33333333;     //3Hz的滚动频率
    wire [3:0] new_char = char_map[51:48];                                                                                          
    //显示滚动控制                                                                                              
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            scroll_cnt <= 0;
            char_map <= 52'b1100_1100_1011_1010_0010_0000_0010_0100_0100_0010_0100_0111_0101;
        end else if(scroll_cnt < scroll_delay) begin
            scroll_cnt <= scroll_cnt + 1;
        end else begin
            scroll_cnt <= 0;
            char_map <= {char_map[48:0], new_char};    //实现滚动
        end
    end
    
    //刷新间隔
    reg [1:0] scan_pos;//选择数码管
    reg [31:0] scan_cnt;  //计数
    parameter scan_delay = 694444;  //144Hz的刷新间隔  （100MHz / 144）
    always@(posedge clk) begin
        if(rst)begin
            scan_pos <= 2'b00;
            scan_cnt <= 0; 
        end else if(scan_cnt < scan_delay) begin
            scan_cnt <= scan_cnt + 1;
        end else begin
            scan_cnt <= 0;
            scan_pos <= scan_pos + 1;
        end
    end
    always @(*) begin
        case (scan_pos)
            2'b00: begin
                    pos = 4'b1000;
                    seg = seg1;
                end
                2'b01: begin
                    pos = 4'b0100;
                    seg = seg2;
                end
                2'b10: begin
                    pos = 4'b0010;
                    seg = seg3;
                end
                2'b11: begin
                    pos = 4'b0001;
                    seg = seg4;
                end    
        endcase        
    end
endmodule
