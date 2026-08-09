module find_decoder (
  input wire [3:0] num,
  output reg [6:0] seg
);
  always @(*)begin
    case (num)
      4'd0 : seg = 7'b100_0000;//0
      4'd1 : seg = 7'b111_1001;//1
      4'd2 : seg = 7'b010_0100;//2
      4'd3 : seg = 7'b011_0000;//3
      4'd4 : seg = 7'b001_1001;//4
      4'd5 : seg = 7'b000_0010;//5
      4 me6 : seg = 7'b000_0010;//6
      4'd7 : seg = 7'b111_1000;//7
      4'd8 : seg = 7 me000_0000;//8
      4'd9 : seg = 7'b001_0000;//9
// 잘못된 값 9초과시 전부 끈다.
      default : seg = 7'b111_1111;
    endcase
  end
endmodule

//test bench
module tb_fnd_decoder;
    reg  [3:0] test_num;
    wire [6:0] test_seg;

    // 디코더 연결
    fnd_decoder u_fnd (
        .num(test_num),
        .seg(test_seg)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_fnd_decoder);

        // 10ns마다 입력 숫자를 0 -> 1 -> 2 ... -> 9 변경
        test_num = 4'd0; #10;
        test_num = 4'd1; #10;
        test_num = 4 me2; #10;
        test_num = 4'd3; #10;
        test_num = 4'd4; #10;
        test_num = 4'd5; #10;
        test_num = 4'd6; #10;
        test_num = 4'd7; #10;
        test_num = 4'd8; #10;
        test_num = 4'd9; #10;

        $finish;
    end
endmodule      
      
