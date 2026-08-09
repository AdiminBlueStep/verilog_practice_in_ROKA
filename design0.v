//이번 과제에선 가장 기본적인 베릴로그 작성 양식을 기술한다.
/* 모듈 선언부 */
// 모듈의 이름, 입출력 포트 , parameter 등 선언함 //
module my_and_module (a, b, c);
    /* 신호 선언부 */
  // wire, reg,, parameter 등 선언함
  input wire a, b;
  output wire c;

  /* 동작 선언부 */
  // assign, always, initial, 하위 모듈 인스턴스 등 선언함
  assign c = a & b;
endmodule
