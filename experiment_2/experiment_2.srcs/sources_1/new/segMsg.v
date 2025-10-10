//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/23 08:48:44
// Design Name: 
// Module Name: segMsg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module segMsg(
    input key1 ,
    input key2 ,
    input key3 ,
    input key4 ,
    output reg [ 3: 0] pos ,
    output reg [ 7: 0] seg,
    output key

    );
    wire [ 3: 0] data = {key4 , key3 , key2 , key1 };
    assign key = 1'b1;

    always@ ( data ) begin
        pos = 4'b0001;
        case ( data )
        4'b0000 : seg = 8'b0011_1111;
        4'b0001 : seg = 8'b0000_0110;
        4'b0010 : seg = 8'b0101_1011;
        4'b0011 : seg = 8'b0100_1111;
        4'b0100 : seg = 8'b0110_0110;
        4'b0101 : seg = 8'b0110_1101;
        4'b0110 : seg = 8'b0111_1101;
        4'b0111 : seg = 8'b0000_0111;
        4'b1000 : seg = 8'b0111_1111;
        4'b1001 : seg = 8'b0110_1111;
        default:seg = 8'b0000_1000;
    endcase
    end
endmodule
