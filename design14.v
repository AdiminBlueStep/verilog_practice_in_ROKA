if (enable == 1'b) begin //조건연산자
  data = 10;
  adress = 16'hDEAD;
  wr_enable - 1'b1;
end dlse begin
  data = 32'b0;
  wr_enable = 1'b0;
  address = address + 1;
end

case (adress)
  0 : $display(
