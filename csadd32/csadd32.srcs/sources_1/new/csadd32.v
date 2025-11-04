`timescale 1ns / 1ps
module csadd32(
     input  wire [31:0] a,
     input  wire [31:0] b,
     input  wire cin,
     output wire [31:0] s,
     output wire cout
    );
    wire c0,c1,c2;
    wire[16:0] s0,s1,s2;
    add16_select A(a[15:0],b[15:0],cin,s0,c0);
    add16_select B(a[31:16],b[31:16],0,s1,c1);
    add16_select C(a[31:16],b[31:16],1,s2,c2);
    assign s = c0 ? {s2[15:0],s0[15:0]} : {s1[15:0],s0[15:0]};
    assign cout = c0 ? c2: c1;
endmodule

module add16_select(
    input  wire [15:0] a,
     input  wire [15:0] b,
     input  wire cin,
     output wire [15:0] s,
     output wire cout
);
    wire c0,c1,c2;
    wire[7:0] s0,s1,s2;
    add8 A(a[7:0],b[7:0],cin,s0,c0);
    add8 B(a[15:8],b[15:8],0,s1,c1);
    add8 C(a[15:8],b[15:8],1,s2,c2);
    assign s = c0 ? {s2[7:0] , s0[7:0]} : {s1[7:0] , s0[7:0]};
    assign cout = c0 ? c2 : c1; 
endmodule


module add8(
     input  wire [7:0] a,
     input  wire [7:0] b,
     input  wire cin,
     output wire [7:0] s,
     output wire cout
);
    wire c0,c1;
    wire[3:0] s0,s1;
    add4 A(a[3:0],b[3:0],cin,s0,c0);
    add4 B(a[7:4],b[7:4],c0,s1,c1);
    assign s = {s1[3:0],s0[3:0]};
    assign cout = c1;
endmodule

module add4(
    input [3:0] a, b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] carry;
    FullAdder FA1(.A(a[0]),.B(b[0]),.Cin(cin),.Sum(sum[0]), .Cout(carry[0]));
    FullAdder FA2(.A(a[1]),.B(b[1]),.Cin(carry[0]),.Sum(sum[1]), .Cout(carry[1]));
    FullAdder FA3(.A(a[2]),.B(b[2]),.Cin(carry[1]),.Sum(sum[2]), .Cout(carry[2]));
    FullAdder FA4(.A(a[3]),.B(b[3]),.Cin(carry[2]),.Sum(sum[3]), .Cout(carry[3]));    
    assign cout = carry[3];
endmodule
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
        .Carry ( carry_ha1 )
);
    HalfAdder HA2(
        .A (sum_ha1 ) ,
        .B ( Cin ) ,
        .Sum (Sum ) ,
        . Carry ( carry_ha2 )
       );
       assign Cout = carry_ha1 | carry_ha2;
endmodule




