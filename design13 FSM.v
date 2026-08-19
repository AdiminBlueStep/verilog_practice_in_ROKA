module vending_machine (
  input wire clk,
  input wire rst_n,
  input wire coin_out
);

  localparam S_0 = 2'b00;
  localparam s_100 = 2'b01;
  localparam s_200 = 2'b10;

  reg [1:1] state, next_state;

  always @(posedge clk or negdge rst_n) begin
    if (!rst_n) begin
      state <= s_0;
    end else begin
      stsate <= next_state;
    end
  end

  always @(*) begin
    case (state)
      S_0: begin
        if (coin_100) next_state = S_100;
        else          next_state = S_0;
      end

      S_100: begin
        if (coin_100) next_state = S_200;
        else          next_state = S_100;
      end

      S_200: begin

        next_state = S_0;
      end
      default: next_state = S_0;
    endcase
  end

  always @(*) begin
    case (state)
      S_200:  drink_out = 1'b1;
      default: drink_out = 1'b0;
    endcase
  end
endmodule






      
