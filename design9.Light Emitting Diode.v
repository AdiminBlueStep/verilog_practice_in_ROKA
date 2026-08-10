module led_pwm (
  input wire clk, // 고속클럭
  input wire [7:0] duty, // 밝기단계 
  output reg  led_out // 외부LED 연결 핀
);
  reg [7:0] pwm_cnt; // 0부터 255까지 반복하서 세는 8비트 카운터
  always @(posedge clk) begin
    //1. 클럭이 뛸때마다 카운터를 1씩 증가 (255뒤엔 1로 넘어감)
    pwm_cnt <= pwm_cnt + 1'b1;
// 2 카운터 값이 DUTY 지정값보다 작을 때만 LED 를 켬
    if (pwm_cnt < duty)
      led_out <= 1'b1;
    else 
      led_out <= 1'b0;
  end
endmodule


//test bench
module tb_led_pwm;
    reg        test_clk;
    reg  [7:0] test_duty;
    wire       test_led_out;

    // DUT(Device Under Test) 연결
    led_pwm u_led_pwm (
        .clk(test_clk),
        .duty(test_duty),
        .led_out(test_led_out)
    );

    // 5ns마다 클럭 반전 (10ns 주기 클럭)
    always #5 test_clk = ~test_clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_led_pwm);

        test_clk = 0;

        // [구간 1] Duty = 0 (0% 밝기 - 완전히 꺼짐)
        test_duty = 8'd0;
        #3000;

        // [구간 2] Duty = 64 (25% 밝기 - 주기 중 25%만 ON)
        test_duty = 8'd64;
        #3000;

        // [구간 3] Duty = 128 (50% 밝기 - 주기 중 절반 ON)
        test_duty = 8'd128;
        #3000;

        // [구간 4] Duty = 255 (100% 밝기 - 사실상 계속 ON)
        test_duty = 8'd255;
        #3000;

        $finish;
    end
endmodule

