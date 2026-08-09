module counter_mod60 (
  input wire       clk,
  input wire       rst,
  output reg [3:0] sec_10,
  output reg [3:0] sec_1
);
  /* 동작 선언부 */
  // assign, always, initial, 하위 모듈 인스턴스 등 선언함
  always @(posedge clk)begin
    if (rst) begin//리셋되면 0으로 만들어
      sec_1 <= 4'd0;
    end else if (sec_1 == 4'd9) begin//출력 sec_1 이 9를 넘으면 0으로 만들어
      sec_1 <= 4'd0;
    end else begin
      sec_1 <= sec_1 + 1'b1;//그전 까진 1씩 스위치가 posedge 할때마다 계속 더해줘
    end
end
  always @(posedge clk) begin
    if (rst) begin
      sec_10 <= 4'd0;// 리셋되면 sec_10은 0
    end else if (sec_1 == 4'd9) begin 
      if (sec_10 == 4'd5) begin// sec_10이 5면 초기화시켜
        sec_10 <= 4'd0;
      end else begin
        sec_10 <= sec_10 +1'b1;//그전까진 더해줘
      end
    end
  end
        
endmodule


//test_bench
module tb_counter_mod60;
    reg        test_clk;
    reg        test_rst;
    wire [3:0] test_sec_10;
    wire [3:0] test_sec_1;

    counter_mod60 u_counter (
        .clk(test_clk),
        .rst(test_rst),
        .sec_10(test_sec_10),
        .sec_1(test_sec_1)
    );

    always #5 test_clk = ~test_clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_counter_mod60);

        test_clk = 0;
        test_rst = 1;
        #10;

        test_rst = 0;

        #700;

        $finish;
    end
endmodule
