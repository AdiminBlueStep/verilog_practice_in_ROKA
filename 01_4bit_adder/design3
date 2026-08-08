module d_flip_flop_4bit (
    input wire	     clk, // 1비트 스위치 전선 
    input wire	     rst, // 1비트 스위치 전선2
    input wire [3:0] d,   // 입력 데이터 4비트
    output reg [3:0] q    // 출력 및 저장 데이터 4비트
);	
    always @(posedge clk) begin // clk 상승 에지(0->1)일 때 실행
        if (rst) begin
            q <= 4'b0000;       // 리셋 버튼이 1이면 0000으로 비움
        end else begin
            q <= d;             // 리셋이 아니면 입력 d 값을 q에 저장
        end
    end

endmodule //



    //test bench
      module tb_d_flip_flop;
    reg        test_clk;
    reg        test_rst;
    reg  [3:0] test_d;
    wire [3:0] test_q;

    d_flip_flop_4bit u_dff (
        .clk(test_clk),
        .rst(test_rst),
        .d(test_d),
        .q(test_q)
    );

    always #5 test_clk = ~test_clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_d_flip_flop);

        test_clk = 0;
        test_rst = 1;
        test_d   = 4'd0;
        #10;

        test_rst = 0;

        test_d = 4'd7;  #12;
        test_d = 4'd12; #10;

        $finish;
    end
endmodule
      //시간에 따라 0 7 12로 바뀌어가는 플립플롭 회로
