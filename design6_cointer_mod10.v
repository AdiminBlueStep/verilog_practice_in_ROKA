// 십진 카운터 (Mod-10 Counter) Design
module counter_mod10 (
    input wire       clk,
    input wire       rst,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 4'b0000;
        end else if (q == 4'd9) begin
            q <= 4'b0000;
        end else begin
            q <= q + 1'b1;
        end
    end

endmodule

//test bench
module tb_counter_mod10;
    reg        test_clk;
    reg        test_rst;
    wire [3:0] test_q;

    // 수정된 십진 카운터 모듈 연결
    counter_mod10 u_counter (
        .clk(test_clk),
        .rst(test_rst),
        .q(test_q)
    );

    // 5ns마다 클럭 반전 (10ns 주기의 클럭)
    always #5 test_clk = ~test_clk;

    initial begin
        // EPWave 파형 저장 설정
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_counter_mod10);

        // 초기 신호 설정
        test_clk = 0;
        test_rst = 1; // 시작 시 리셋 활성화 (q를 0으로 만듦)
        #10;

        test_rst = 0; // 10ns 시점에 리셋 해제 (0~9 카운트 시작!)

        #160; // 0~9 카운트가 두 바퀴 정도 돌 때까지 관찰

        $finish;
    end
endmodule





//결과 0초부터 10초까지 리셋시키다 10초지점에서 리셋 풀리면 15초부터 q = 1 25초는 q = 2 이런식으로 10초주기로 9까지 늘다가 결국 9에서 0으로 초기화 리셋당함
