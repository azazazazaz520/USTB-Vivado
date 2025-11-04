`timescale 1ns / 1ps
module lock_tb();

    reg clk;
    reg rst;
    reg in;
    wire unlock;

    // 实例化被测模块
    lock uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .unlock(unlock)
    );

    // 产生时钟信号（10ns周期）
    initial clk = 0;
    always #5 clk = ~clk;

    // 任务：输入一位数据
    task input_bit;
        input bit_val;
        begin
            in = bit_val;
            @(posedge clk);  // 等待一个时钟周期
        end
    endtask

    // 任务：输入一个4位数字（高位先输入）
    task input_digit;
        input [3:0] num;
        integer i;
        begin
            for (i = 3; i >= 0; i = i - 1)
                input_bit(num[i]);
        end
    endtask

    // 任务：输入结束符"#"
    task input_end;
        begin
            input_digit(4'b1111); 
        end
    endtask

    initial begin
        // 初始化
        rst = 1;
        in = 0;
        @(posedge clk);
        rst = 0;

        // ================================
        // 测试1：正确密码输入（4475）
        // ================================
        $display("Test 1");
        input_digit(4'd4);
        input_digit(4'd4);
        input_digit(4'd7);
        input_digit(4'd5);
        input_end();  // 输入结束符 #
        @(posedge clk);
        if (unlock)
            $display("successfully unlock", $time);
        else
            $display("Wrong pwd");

        
        // 测试2：错误密码输入（0002）
        
        $display("Test 2");
        input_digit(4'd0);
        input_digit(4'd0);
        input_digit(4'd0);
        input_digit(4'd2);
        input_end();
        @(posedge clk);
        if (unlock)
            $display("successfully unlock", $time);
        else
            $display("Wrong pwd");

        
        // 测试3：输入少于4位后结束
        
        $display("=== Test 3: Short input (only 3 digits) ===");
        input_digit(4'd1);
        input_digit(4'd2);
        input_digit(4'd3);
        input_end();
        @(posedge clk);
        if (unlock)
            $display("successfully unlock", $time);
        else
            $display("Wrong pwd");

        
        // 测试4：复位功能
        
        $display("=== Test 4: Reset check ===");
        rst = 1; @(posedge clk); rst = 0;
        input_digit(4'd0);
        input_digit(4'd0);
        input_digit(4'd0);
        input_digit(4'd1);
        input_end();
        @(posedge clk);
        if (unlock)
            $display("PASS: Unlock after reset success");
        else
            $display("FAIL: Unlock failed after reset!");

        
        #20;
        $finish;
    end

endmodule
