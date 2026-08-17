//블로킹 = 연산자 주로 always @(*) 조합회로에서 사용.c언어처럼 코드가 한줄씩 순차적으로 실행
//논블로킹 <= 연산자 주로 always @(posedge clk) 순차회로에서 사용 .클록이 올라가는 순간 모든 구문이 동시에 병렬로 실행
always @(posedge clk) begin
  a = in;
  b = a;
end
//불가

always @(posedge clk) begin
  a <= in;
  b <= a;
end

assign out = (sel == 1'b1) ? in_a : in_b;

// 삼항 연산자(? :)
//if-else 문 대신 한줄로 간단한 mux 회로를 만들때 assign구문과 함께 사용
  assign out = (sel == 1'b1) ? in_a : in_b;
//localparam(모듈내부상수)
localparam STATE_IDLE  = 2'b00;
localparam STATE_RUN   = 2'b01;
localparam STATE_ALARM = 2'b10;
// generate 구문 (하드웨어 반복 생성)
//동일한 부품 모듈이나 회로 패턴을 4개 8개씩 반복 연결해야 할떄 for 문과 함께 사용해 하드웨어 복사 생성한다
genvar i;
generate
  for(i = 1; i < 6; i = i + 1) begin : gen_fnd
    fnd_decoder u_fnd (
      .num(w_num[i]),
      .seg(w_seg[i])
    );
  end
endgenerate

  
