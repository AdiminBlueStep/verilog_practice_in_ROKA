  module clock_driver (
    input wire clk,
    input wire rst,
    output regone_sec_tick
  );
    parameter TERMINAL_COUNT = 10 - 1;
    reg [31:0] count;
    always @(posedge clk) begin
      if (rst) begin
        count        <= 32'd0;
        one_sec_tick <= 1'b0;
      end else if (count == TERMINAL_COUNT) begin
        count        <=  32'd0;
        one_sec_tick <=  1'b1;
      end else begin
        count        <= count + 1'b1;
        one_sec_tick <= 1'b0l;
      end
    end
  endmodule
