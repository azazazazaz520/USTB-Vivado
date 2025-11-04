`timescale 1ns / 1ps

module tb_csadd32;

    // 输入信号
    reg [31:0] a;
    reg [31:0] b;
    reg cin;

    // 输出信号
    wire [31:0] s;
    wire cout;

    // 实例化被测模块
    csadd32 uut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );

    initial begin
        

        // 初始化信号
        a = 32'h00000000; 
        b = 32'h00000000; 
        cin = 0;
        #10;  // 等待10ns

        // 测试1：简单加法
        a = 32'h00000005;
        b = 32'h00000003;
        cin = 0;
        #10;

        // 测试2：带进位输入
        a = 32'h0000000A;
        b = 32'h0000000A;
        cin = 1;
        #10;

        // 测试3：较大数
        a = 32'h12345678;
        b = 32'h87654321;
        cin = 0;
        #10;

        // 测试4：进位溢出
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        cin = 0;
        #10;

       

        
        $finish;
    end

endmodule
