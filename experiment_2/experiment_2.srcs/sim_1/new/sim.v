`timescale 1ns/1ps //时间单位和时间精度
module segMsg_tb();// 模块
    reg key1 , key2 , key3 , key4 ;
    wire [ 3: 0] pos;
    wire [ 7: 0] seg;
    initial begin
    key1 = 1 'b0 ; key2 = 1 'b0 ; key3 = 1 'b0 ; key4 = 1 'b0 ;
    #100;
    key1 = 1'b0;key2 = 1'b0;key3 = 1'b1;key4 = 1'b0;
    #100;
    forever #20 {key4 , key3 , key2 , key1} = {$random} % 4'b1111 ;
    end
    initial begin
        #10000;
        $finish;
    end
    segMsg DUT( key1 , key2 , key3 , key4 , pos , seg ); 
endmodule
