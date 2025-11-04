module mod4_counter (
    input wire clk,      // 时钟信号
    input wire rst,      // 复位信号
    output reg [1:0] count  // 2位计数器输出
);

// 同步逻辑
always @(posedge clk) begin
    if (rst) begin
        // 复位时计数器归零
        count <= 2'b00;
    end else begin
        // 每周期加1，模4计数
        count <= (count + 1) % 4;
    end
end

endmodule