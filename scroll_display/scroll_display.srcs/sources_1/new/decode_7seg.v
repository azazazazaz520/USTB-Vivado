`timescale 1ns / 1ps
//七段数码管解码器
module decode_7seg(
    input [3:0] value,
    output reg [7:0] seg
    );
always@(value)begin  
    case(value)
        4'h0: seg = 8'b0011_1111; // 0
        4'h1: seg = 8'b0000_0110; // 1
        4'h2: seg = 8'b0101_1011; // 2
        4'h3: seg = 8'b0100_1111; // 3
        4'h4: seg = 8'b0110_0110; // 4
        4'h5: seg = 8'b0110_1101; // 5
        4'h6: seg = 8'b0111_1101; // 6
        4'h7: seg = 8'b0000_0111; // 7
        4'h8: seg = 8'b0111_1111; // 8
        4'h9: seg = 8'b0110_1111; // 9
        4'hA: seg = 8'b0011_1110; // U
        4'hB: seg = 8'b0111_1000; // T
        4'hC: seg = 8'b0110_1110; // Y
        default: seg = 8'b0000_0000;//默认为空
    endcase
    
end
endmodule
