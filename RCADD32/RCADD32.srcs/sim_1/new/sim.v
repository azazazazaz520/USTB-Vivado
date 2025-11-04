`timescale 1ns / 1ps

module tb_rcadd32;

    // 输入信号
    reg [31:0] a;
    reg [31:0] b;
    reg cin;

    // 输出信号
    wire [31:0] s;
    wire cout;

    // 实例化被测模块
    rcadd32 uut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );

    initial begin
        // 监控输出变化
        $monitor("Time=%0t | a=%h | b=%h | cin=%b | sum=%h | cout=%b", 
                 $time, a, b, cin, s, cout);

        // 初始化
        a = 32'h00000000; 
        b = 32'h00000000; 
        cin = 0;
        #10;

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

        // 测试4：全1 + 1，测试溢出
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        cin = 0;
        #10;

        // 测试5：随机值
        a = 32'hA5A5A5A5;
        b = 32'h5A5A5A5A;
        cin = 1;
        #10;

        $finish;
    end

endmodule
