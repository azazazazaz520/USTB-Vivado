`timescale 1ns / 1ps
module adder_tb () ;
    reg [ 1 : 0 ] A;
    reg [ 1 : 0 ] B;
    reg Cin ;
    wire [ 1 : 0 ] Sum;
    wire Cout;
    TwoBitAdder DUT(
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),  
        .Cout(Cout)
    );
    initial begin
        // ²âÊÔÓÃÀý1£º01 + 01 + 0 = [0]10
        A = 2 'b01; B = 2 'b01; Cin = 1 'b0;
        $display ( "Test 1: A=%b , B=%b , Cin=%b->Cout=%b , Sum=%b" , A, B, Cin , Cout ,Sum);
        #10
        A = 2 'b11; B = 2 'b11; Cin = 1 'b0;
        #10
        A = 2 'b11 ; B = 2 'b01 ; Cin = 1 'b1;
        #10
        A = 2 'b00 ; B = 2 'b00 ; Cin = 1 'b1;
        #10
        $finish;
    end  
endmodule
