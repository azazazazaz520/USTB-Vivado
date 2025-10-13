`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/10 20:02:05
// Design Name: 
// Module Name: TwoBitAdder
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
module HalfAdder (
    input wire A,
    input wire B,
    output wire Sum,
    output wire Carry
);
    assign Sum = A^B;
    assign Carry = A & B;
endmodule
module FullAdder (
    input wire A,
    input wire B,
    input wire Cin ,
    output wire Sum,
    output wire Cout
   );
   wire sum_ha1 , carry_ha1 , carry_ha2 ;
    HalfAdder HA1(
        .A (A ) ,
        .B (B ) ,
        .Sum (sum_ha1 ) ,
        . Carry ( carry_ha1 )
);
    HalfAdder HA2(
        .A (sum_ha1 ) ,
        .B ( Cin ) ,
        .Sum (Sum ) ,
        . Carry ( carry_ha2 )
       );
       assign Cout = carry_ha1 | carry_ha2;
endmodule

module TwoBitAdder(
    input wire [ 1 : 0 ] A,
    input wire [ 1 : 0 ] B,
    input wire Cin ,
    output wire [ 1 : 0 ] Sum,
    output wire Cout
    );
    wire carry_internal;
    FullAdder FA1(
        .A(A[0]),
        .B(B[0]),
        .Cin(Cin),
        .Sum(Sum[0]),
        .Cout(carry_internal)
    );
    FullAdder FA2(
        .A(A[1]),
        .B(B[1]),
        .Cin(carry_internal),
        .Sum(Sum[1]),
        .Cout(Cout)
    );
endmodule
