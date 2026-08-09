// Code your design here
module  counter_4bit (
  input wire	clk,
  input wire	rst,
  output reg[3:0] q
);
  always @(posedge clk)begin
    if (rst) begin
      q<= 4'b0000;
    end else begin
      q <= q +1'b1;
    end
  end
endmodule
//test bench
module tb_counter_4bit;
    reg        test_clk;
    reg        test_rst;
    wire [3:0] test_q;

    // 카운터 모듈 연결
    counter_4bit u_counter (
        .clk(test_clk),
        .rst(test_rst),
        .q(test_q)
    );

    // 5ns마다 클럭 반전 (10ns 주기의 클럭 생성)
    always #5 test_clk = ~test_clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_counter_4bit);

        test_clk = 0;
        test_rst = 1; // 처음엔 리셋을 켜서 출력을 0으로 정돈
        #10;

        test_rst = 0; // 10ns 지점에서 리셋 해제! (이제 숫자가 올라감)

        #160; // 16번 넘게 클럭이 뛸 수 있도록 160ns 동안 대기

        $finish;
    end
endmodule

//결과 해설 0-10초까진 rst가 켜져있음으로 출력q는 0고정10초에서 리셋을 품으로 인해서 상승앳지가 발생하는 15초부터 
// 숫자가 올라감 그후 15까지 올라왔다가 4비트는 15까지만 저장할수있기에 15까지 작동후 다시 리셋 작용
