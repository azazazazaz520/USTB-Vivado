`timescale 1ns / 1ps

module ALU_tb;
    // 输入信号
    reg [7:0] alu_src1;
    reg [7:0] alu_src2;
    reg [11:0] alu_op;
    
    // 输出信号
    wire [7:0] alu_result;
    
    // 实例化ALU模块
    ALU uut (
        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .alu_op(alu_op),
        .alu_result(alu_result)
    );
    
    initial begin
        // 初始化信号
        alu_src1 = 8'b0;
        alu_src2 = 8'b0;
        alu_op = 12'b0;
        
        // 等待全局复位完成
        #100;
        
        $display("开始ALU仿真测试");
        $display("时间\t操作码\t操作数1\t操作数2\t结果");
        $display("------------------------------------------------");
        
        // 测试加法 12'h001
        alu_op = 12'h001;
        alu_src1 = 8'h25;
        alu_src2 = 8'h37;
        #10;
        $display("%0t\tADD\t%h\t%h\t%h", $time, alu_src1, alu_src2, alu_result);
        
        // 测试减法 12'h002
        alu_op = 12'h002;
        alu_src1 = 8'h50;
        alu_src2 = 8'h30;
        #10;
        $display("%0t\tSUB\t%h\t%h\t%h", $time, alu_src1, alu_src2, alu_result);
        
        // 测试与运算 12'h004
        alu_op = 12'h004;
        alu_src1 = 8'hF0;
        alu_src2 = 8'h0F;
        #10;
        $display("%0t\tAND\t%h\t%h\t%h", $time, alu_src1, alu_src2, alu_result);
        
        // 测试或运算 12'h008
        alu_op = 12'h008;
        alu_src1 = 8'hA0;
        alu_src2 = 8'h0A;
        #10;
        $display("%0t\tOR\t%h\t%h\t%h", $time, alu_src1, alu_src2, alu_result);
        
        // 测试左移 12'h010
        alu_op = 12'h010;
        alu_src1 = 8'b00001111;
        alu_src2 = 8'h02;  // 移位2位
        #10;
        $display("%0t\tSHL\t%b\t%b\t%b", $time, alu_src1, alu_src2[1:0], alu_result);
        
        // 测试算术右移 12'h020
        alu_op = 12'h020;
        alu_src1 = 8'b11110000;
        alu_src2 = 8'h01;  // 移位1位
        #10;
        $display("%0t\tASR\t%b\t%b\t%b", $time, alu_src1, alu_src2[1:0], alu_result);
        
        // 测试循环右移 12'h040
        alu_op = 12'h040;
        alu_src1 = 8'b10110011;
        alu_src2 = 8'h03;  // 移位3位
        #10;
        $display("%0t\tROR\t%b\t%b\t%b", $time, alu_src1, alu_src2[1:0], alu_result);
        
        // 测试有符号比较 12'h080
        alu_op = 12'h080;
        alu_src1 = 8'h80;  // -128
        alu_src2 = 8'h7F;  // 127
        #10;
        $display("%0t\tSLT\t%h(%0d)\t%h(%0d)\t%h", $time, 
                alu_src1, $signed(alu_src1), alu_src2, $signed(alu_src2), alu_result);
        
        // 测试无符号比较 12'h100
        alu_op = 12'h100;
        alu_src1 = 8'h80;  // 128
        alu_src2 = 8'h7F;  // 127
        #10;
        $display("%0t\tULT\t%h(%0d)\t%h(%0d)\t%h", $time, 
                alu_src1, alu_src1, alu_src2, alu_src2, alu_result);
        
        // 测试进位加法 12'h200
        alu_op = 12'h200;
        alu_src1 = 8'hFF;
        alu_src2 = 8'h01;
        #10;
        $display("%0t\tCARRY\t%h\t%h\t%h", $time, alu_src1, alu_src2, alu_result);
        
        // 测试异或运算 12'h400
        alu_op = 12'h400;
        alu_src1 = 8'hAA;
        alu_src2 = 8'h55;
        #10;
        $display("%0t\tXOR\t%h\t%h\t%h", $time, alu_src1, alu_src2, alu_result);
        
        // 测试半字节置换 12'h800
        alu_op = 12'h800;
        alu_src1 = 8'h12;
        alu_src2 = 8'h34;
        #10;
        $display("%0t\tNPERM\t%h\t%h\t%h", $time, alu_src1, alu_src2, alu_result);
        
        // 测试默认情况
        alu_op = 12'h000;
        alu_src1 = 8'hAA;
        alu_src2 = 8'hBB;
        #10;
        $display("%0t\tDEFAULT\t%h\t%h\t%h", $time, alu_src1, alu_src2, alu_result);
        $finish;
    end
    
endmodule
