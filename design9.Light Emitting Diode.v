module led_pwm (
  input wire clk,
  input wire [7:0] duty,
  output reg  led_out
);
  reg [7:0] pwm_cnt;
