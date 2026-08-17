//1 7세그먼트 디코더 모듈
module fnd_decoder (
  input wire [3:0] bcd,
  output reg [6:0] seg 
);
  always @(*) begin//조합논리회로
    case (bcd)
      4'd0 : seg = 7'b100_0000;
      4'd1 : seg = 7'b111_1001;
      4'd2 : seg = 7'b010_0100;
      4'd3 : seg = 7'b011_0000;
      4'd4 : seg = 7'b001_1001;
      4'd5 : seg = 7'b010_0010;
      4'd6 : seg = 7'b000_0010;
      4'd7 : seg = 7'b111_1000;
      4'd8 : seg = 7'b000_0000;
      4'd9 : seg = 7'b001_0000;
       default : seg = 7'b111_1111;
    endcase
  end
endmodule

//2. 1HZ 클록 분주기 모듈
module clk_devider #(
  parameter INPUT_PREQ = 50_000_000 //위 회로의 기본 클록은 1초에 50mhz이기 때문에 50mhz
)(
  input wire clk,
  input wire rst_n,
  output reg clk_1hz
);
  localparam COUNT_MAX = (INPUT_FREQ / 2) - 1;
    reg [25:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count   <= 26'd0;
            clk_1hz <= 1'b0;
        end else if (count == COUNT_MAX) begin
            count   <= 26'd0;
            clk_1hz <= ~clk_1hz;
        end else begin
            count   <= count + 1'b1;
        end
    end
endmodule

// 3. 디지털 시계 Top 모듈
module digital_clock_top #(
    parameter INPUT_FREQ = 50_000_000
)(
    input  wire clk,
    input  wire rst_n,
    output wire [6:0] seg_h2, seg_h1,
    output wire [6:0] seg_m2, seg_m1,
    output wire [6:0] seg_s2, seg_s1
);

    wire clk_1hz;
  // 1Hz 클록 분주기 인스턴스화
    clk_divider #(.INPUT_FREQ(INPUT_FREQ)) u_clk_div (
        .clk(clk),
        .rst_n(rst_n),
        .clk_1hz(clk_1hz)
    );
  // BCD 카운터 레지스터 (시, 분, 초 각각 1의 자리 / 10의 자리)
    reg [3:0] s1, s2; // s1: 0~9, s2: 0~5
    reg [3:0] m1, m2; // m1: 0~9, m2: 0~5
    reg [3:0] h1, h2; // h1, h2: 00~23

  // 시계 카운터 제어로직 (순차 논리회로)
  always @(posedge clk_1hz or negedge rst_n) begin
        if (!rst_n) begin
            s1 <= 4'd0; s2 <= 4'd0;
            m1 <= 4'd0; m2 <= 4'd0;
            h1 <= 4'd0; h2 <= 4'd0;
          end else begin
            // 23:59:59 도달 시 00:00:00 리셋
            if (h2 == 4'd2 && h1 == 4'd3 && m2 == 4'd5 && m1 == 4'd9 && s2 == 4'd5 && s1 == 4'd9) begin
                s1 <= 4'd0; s2 <= 4'd0;
                m1 <= 4'd0; m2 <= 4'd0;
                h1 <= 4'd0; h2 <= 4'd0;
            end else if (s1 == 4'd9) begin
                s1 <= 4'd0;
                if (s2 == 4'd5) begin
                    s2 <= 4'd0;
                    if (m1 == 4'd9) begin
                        m1 <= 4'd0;
                        if (m2 == 4'd5) begin
                            m2 <= 4'd0;
                            if (h1 == 4'd9) begin
                                h1 <= 4'd0;
                                h2 <= h2 + 1'b1;
                            end else begin
                                h1 <= h1 + 1'b1;
                            end
                        end else begin
                            m2 <= m2 + 1'b1;
                        end
                    end else begin
                        m1 <= m1 + 1'b1;
                    end
                end else begin
                    s2 <= s2 + 1'b1;
                end
            end else begin
                s1 <= s1 + 1'b1;
            end
        end
    end
  //generate 구문을 활용한 6개 7세그먼트 디코더 자동연결 
  wire [3:0] bcd_digits [0:5];
  wire [6:0] seg_outputs [0:5];

  assign bcd_digits[0] = s1;
  assign bcd_digits[1] = s2;
  assign bcd_digits[2] = m1;
  assign bcd_digits[3] = m2;
  assign bcd_digits[4] = h1;
  assign bcd_digits[5] = h2;

  assign seg_s1 = seg_outputs[0];
  assign seg_s2 = seg_outputs[1];
  assign seg_m1 = seg_outputs[2];
  assign seg_m2 = seg_outputs[3];
  assign seg_h1 = seg_outputs[4];
  assign seg_h2 = seg_outputs[5];

  genvar i;
  generate
    for (i = 0; i < 6; i = i + 1) begin : gen_fnd_decoder
      fnd_decoder u_fnd_dec ( 
        .bcd(bcd_digits[i]),
        .seg(seg_outputs[i]
            );
        end
    endgenerate
endmodule
        
