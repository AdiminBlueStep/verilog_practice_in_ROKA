module top_digital_clock (
    input  wire clk,         // 50MHz 기본 클록
    input  wire rst,         // 리셋 버튼
    output wire [6:0] seg_sec_1,   // 초 일의 자리 FND
    output wire [6:0] seg_sec_10,  // 초 십의 자리 FND
    output wire [6:0] seg_min_1,   // 분 일의 자리 FND
    output wire [6:0] seg_min_10,  // 분 십의 자리 FND
    output wire [6:0] seg_hour_1,  // 시 일의 자리 FND
    output wire [6:0] seg_hour_10  // 시 십의 자리 FND
);

    // 내부 연결 전선(Wire)들
    wire tick_1hz;
    wire c_sec1, c_sec10;
    wire c_min1, c_min10;

    wire [3:0] w_sec_1,  w_sec_10;
    wire [3:0] w_min_1,  w_min_10;
    wire [3:0] w_hour_1, w_hour_10;

    // 1. 클록 분주기 (1초 펄스 생성)
    clk_divider u_clk_div (
        .clk(clk), .rst(rst), .tick_1hz(tick_1hz)
    );

    // 2. 초(Sec) 카운터
    counter_mod10 u_sec_1 (
        .clk(clk), .rst(rst), .en(tick_1hz), .q(w_sec_1), .carry(c_sec1)
    );
    counter_mod6 u_sec_10 (
        .clk(clk), .rst(rst), .en(c_sec1), .q(w_sec_10), .carry(c_sec10)
    );

    // 3. 분(Min) 카운터
    counter_mod10 u_min_1 (
        .clk(clk), .rst(rst), .en(c_sec10), .q(w_min_1), .carry(c_min1)
    );
    counter_mod6 u_min_10 (
        .clk(clk), .rst(rst), .en(c_min1), .q(w_min_10), .carry(c_min10)
    );

    // 4. 시(Hour) 카운터
    counter_mod24 u_hour (
        .clk(clk), .rst(rst), .en(c_min10), .hour_10(w_hour_10), .hour_1(w_hour_1)
    );

    // 5. 7-Segment 디코더 6개 연결
    fnd_decoder u_fnd_sec1  (.num(w_sec_1),   .seg(seg_sec_1));
    fnd_decoder u_fnd_sec10 (.num(w_sec_10),  .seg(seg_sec_10));
    fnd_decoder u_fnd_min1  (.num(w_min_1),   .seg(seg_min_1));
    fnd_decoder u_fnd_min10 (.num(w_min_10),  .seg(seg_min_10));
    fnd_decoder u_fnd_hour1 (.num(w_hour_1),  .seg(seg_hour_1));
    fnd_decoder u_fnd_hour10(.num(w_hour_10), .seg(seg_hour_10));

endmodule
