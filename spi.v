module spi (
  input clk, newd, rst,
  input [11:0] din,
  output reg sclk, cs, mosi
);

  // Define state type using a parameter
  typedef enum bit [1:0] {
    idle = 2'b00,
    enable = 2'b01,
    send = 2'b10,
    comp = 2'b11
  } state_type;

  // Define state as a reg with an initial value
  reg [1:0] state = idle;

  // Counters for sclk generation and data bits
  reg [3:0] countc = 4'b0000;
  reg [3:0] count = 4'b0000;

  // Generate sclk
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      countc <= 4'b0000;
      sclk <= 1'b0;
    end else begin
      if (countc < 4'b1010) // fclk / 20
        countc <= countc + 1;
      else begin
        countc <= 4'b0000;
        sclk <= ~sclk;
      end
    end
  end

  // State machine
  reg [11:0] temp;

  always @(posedge sclk or posedge rst) begin
    if (rst) begin
      cs <= 1'b1;
      mosi <= 1'b0;
    end else begin
      case (state)
        idle: begin
          if (newd) begin
            state <= send;
            temp <= din;
            cs <= 1'b0;
          end else begin
            state <= idle;
            temp <= 8'h00;
          end
        end

        send: begin
          if (count <= 11) begin
            mosi <= temp[count]; // Sending lsb first
            count <= count + 1;
          end else begin
            count <= 4'b0000;
            state <= idle;
            cs <= 1'b1;
            mosi <= 1'b0;
          end
        end

        default: state <= idle;
      endcase
    end
  end

endmodule
