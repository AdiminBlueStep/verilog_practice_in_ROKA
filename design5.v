module counter_mod10 (
    input wire       clk,  // 입력: 클럭 신호
    input wire       rst,  // 입력: 리셋 신호
    output reg [3:0] q     // 출력: 4비트 카운트 값 (0~9)
);

    /* 동작 선언부 */
    // assign, always, initial, 하위 모듈 인스턴스 등 선언함
    always @(posedge clk) begin
        if (rst) begin                 // 리셋 스위치가 켜지면 0으로 초기화
            q <= 4'b0000;
        end else if (q == 4'd9) begin  // 카운트가 9에 도달하면 0으로 초기화
            q <= 4'b0000;
        end else begin                 // 그 외에는 1씩 증가
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
