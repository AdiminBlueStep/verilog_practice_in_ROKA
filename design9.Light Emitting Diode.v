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

