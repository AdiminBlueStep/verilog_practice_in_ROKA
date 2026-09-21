//01. Module (모듈)
module concept_01_module (
    input  wire clk,
    input  wire rst_n,
    input  wire in_data,
    output reg  out_data
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) out_data <= 1'b0;
        else        out_data <= in_data;
    end
endmodule

//02. Wire (와이어)
module concept_02_wire (
    input  wire a,
    input  wire b,
    output wire w_out
);
    // wire는 스스로 값을 저장할 수 없으며 assign 구문으로 연결합니다.
    assign w_out = a & b;
endmodule


//03. Reg (레지스터)
module concept_03_reg (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // always 블록 내에서 값을 할당받으므로 q는 reg로 선언됩니다.
    always @(posedge clk) begin
        q <= d;
    end
endmodule
//04. Assign (어사인)
module concept_04_assign (
    input  wire [3:0] in_a,
    input  wire [3:0] in_b,
    output wire [3:0] out_sum
);
    assign out_sum = in_a + in_b;
endmodule
//05. Parameter / Localparam (파라미터)
module concept_05_parameter #(
    parameter DATA_WIDTH = 8  // 외부에서 오버라이딩 가능
)(
    input  wire [DATA_WIDTH-1:0] in_data,
    output wire [DATA_WIDTH-1:0] out_data
);
    localparam MAX_COUNT = 100; // 모듈 내부 전용 상수로 오버라이딩 불가

    assign out_data = in_data;
endmodule
//2. 논리 회로 & 대입 연산 (Logic & Assignment)
//06. Combinational Logic (조합 논리)
module concept_06_combinational (
    input  wire [1:0] sel,
    input  wire [3:0] in0, in1, in2, in3,
    output reg  [3:0] mux_out
);
    always @(*) begin
        case (sel)
            2'b00: mux_out = in0;
            2'b01: mux_out = in1;
            2'b10: mux_out = in2;
            2'b11: mux_out = in3;
            default: mux_out = 4'b0000;
        endcase
    end

//  07. Sequential Logic (순차 논리)
  module concept_07_sequential (
    input  wire       clk,
    input  wire       rst_n,
    output reg  [3:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count <= 4'd0;
        else        count <= count + 1'b1;
    end
endmodule
//08. Blocking Assignment (=)
  module concept_08_blocking (
    input  wire a, b, c,
    output reg  out
);
    reg temp;
    always @(*) begin
        temp = a & b; // temp가 즉시 결정됨
        out  = temp | c;
    end
endmodule

//09. Non-blocking Assignment (<=)

  module concept_09_non_blocking (
    input  wire clk,
    input  wire in_data,
    output reg  q1, q2
);
    always @(posedge clk) begin
        q1 <= in_data; // clk 상승 에지 시점에 병렬로 동시 수행
        q2 <= q1;      // 이전 clk의 q1 값이 q2로 넘어감 (Shift 동작)
    end
endmodule

//10. Sensitivity List (감지 목록)

  module concept_10_sensitivity (
    input  wire a, b,
    input  wire clk, rst_n,
    output reg  out_comb, out_seq
);
    // @(*) : 모든 입력 변수를 감지하여 조합 논리 구성
    always @(*) begin
        out_comb = a ^ b;
    end

    // @(posedge clk or negedge rst_n) : 지정한 에지만 감지하여 순차 논리 구성
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) out_seq <= 1'b0;
        else        out_seq <= a;
    end
endmodule

  //11. D Flip-Flop (D 플립플롭)

  module concept_11_d_flip_flop (
    input  wire clk,
    input  wire rst_n,
    input  wire d,
    output reg  q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q <= 1'b0;
        else        q <= d;
    end
endmodule


  //12. Edge Detector (엣지 검출기)
  module concept_12_edge_detector (
    input  wire clk,
    input  wire rst_n,
    input  wire in_signal,
    output wire pos_edge_pulse
);
    reg in_d1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) in_d1 <= 1'b0;
        else        in_d1 <= in_signal;
    end

    // 현재 신호는 1이고, 1클록 전 신호는 0일 때 1발 발생
    assign pos_edge_pulse = in_signal & ~in_d1;
endmodule

  //13. Debouncer (디바운서)
  module concept_13_debouncer (
    input  wire clk,        // 50MHz
    input  wire rst_n,
    input  wire btn_in,
    output reg  btn_out
);
    localparam CNT_10MS = 500_000;
    reg [18:0] count;
    reg        btn_sync;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_sync <= 1'b0;
            count    <= 19'd0;
            btn_out  <= 1'b0;
        end else begin
            btn_sync <= btn_in;
            if (btn_sync != btn_out) begin
                if (count >= CNT_10MS - 1) begin
                    count   <= 19'd0;
                    btn_out <= btn_sync;
                end else begin
                    count <= count + 1'b1;
                end
            end else begin
                count <= 19'd0;
            end
        end
    end
endmodule

//  14. 2-FF Synchronizer (동기화기)

  module concept_14_synchronizer (
    input  wire clk,
    input  wire rst_n,
    input  wire async_in,
    output reg  sync_out
);
    reg ff1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ff1      <= 1'b0;
            sync_out <= 1'b0;
        end else begin
            ff1      <= async_in; // 1차 필터링
            sync_out <= ff1;      // 2차 필터링 후 클록에 동기화
        end
    end
endmodule
  //15. Clock Divider / Prescaler (클록 분기기)
  module concept_15_clock_divider (
    input  wire clk,         // 50MHz
    input  wire rst_n,
    output reg  clk_1hz_tick
);
    localparam CNT_1SEC = 50_000_000;
    reg [25:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count        <= 26'd0;
            clk_1hz_tick <= 1'b0;
        end else begin
            if (count >= CNT_1SEC - 1) begin
                count        <= 26'd0;
                clk_1hz_tick <= 1'b1;
            end else begin
                count        <= count + 1'b1;
                clk_1hz_tick <= 1'b0;
            end
        end
    end
endmodule

  //16. Shift Register (시프트 레지스터)
  module concept_16_shift_register (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       serial_in,
    output reg  [3:0] shift_reg
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0000;
        end else begin
            // 최상위 비트를 내보내고 아래로 밀어넣음
            shift_reg <= {shift_reg[2:0], serial_in};
        end
    end
endmodule

  //17. Multiplexer / Mux (멀티플렉서)
  module concept_17_mux (
    input  wire       sel,
    input  wire [7:0] in_a,
    input  wire [7:0] in_b,
    output wire [7:0] mux_out
);
    assign mux_out = (sel) ? in_b : in_a;
endmodule
  //18. Tri-state Buffer (3상 버퍼)
  module concept_18_tristate_buffer (
    input  wire       oe,      // Output Enable
    input  wire [7:0] in_data,
    output wire [7:0] bus_data
);
    assign bus_data = (oe) ? in_data : 8'bzzzz_zzzz;
endmodule
  //19. FSM (Finite State Machine, 유한 상태 머신)
  module concept_19_fsm (
    input  wire clk,
    input  wire rst_n,
    input  wire start_trigger,
    output reg  active_signal
);
    localparam S_IDLE   = 1'b0;
    localparam S_ACTIVE = 1'b1;

    reg current_state, next_state;

    // Block 1: State Register (순차 논리)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= S_IDLE;
        else        current_state <= next_state;
    end

    // Block 2: Next State Logic (조합 논리)
    always @(*) begin
        case (current_state)
            S_IDLE:   next_state = (start_trigger) ? S_ACTIVE : S_IDLE;
            S_ACTIVE: next_state = S_IDLE;
            default:  next_state = S_IDLE;
        endcase
    end

    // Block 3: Output Logic (조합 논리)
    always @(*) begin
        active_signal = (current_state == S_ACTIVE);
    end
endmodule
  //20. State Register (상태 레지스터)
  module concept_20_state_register (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] next_st,
    output reg  [1:0] current_st
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_st <= 2'b00; // 초기 상태
        else        current_st <= next_st;
    end
endmodule
  //21. Next State Logic (다음 상태 로직)
  module concept_21_next_state_logic (
    input  wire [1:0] current_st,
    input  wire       event_flag,
    output reg  [1:0] next_st
);
    always @(*) begin
        case (current_st)
            2'b00: next_st = (event_flag) ? 2'b01 : 2'b00;
            2'b01: next_st = 2'b10;
            2'b10: next_st = 2'b00;
            default: next_st = 2'b00;
        endcase
    end
endmodule
  //22. Output Logic (출력 로직)
  module concept_22_output_logic (
    input  wire [1:0] current_st,
    output reg        tx_enable,
    output reg        rx_enable
);
    always @(*) begin
        tx_enable = 1'b0;
        rx_enable = 1'b0;
        case (current_st)
            2'b01: tx_enable = 1'b1;
            2'b10: rx_enable = 1'b1;
            default: ;
        endcase
    end
endmodule
  //23. Latch (래치 / 의도치 않은 래치)
  module concept_23_latch (
    input  wire       sel,
    input  wire [3:0] in_data,
    output reg  [3:0] bad_out,  // Latch 생성 (위험)
    output reg  [3:0] good_out  // 정상 조합 논리
);
    // [WRONG] else 조건이 없어 기존 값을 유지하려는 Latch가 합성됨
    always @(*) begin
        if (sel) bad_out = in_data;
    end

    // [CORRECT] 모든 조건(else)을 명시하여 Latch를 방지함
    always @(*) begin
        if (sel) good_out = in_data;
        else     good_out = 4'b0000;
    end
endmodule
