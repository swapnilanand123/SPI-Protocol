

module spi_tb;

  reg clk;
  reg rst;
  reg newd;
  reg [11:0] din;
  wire sclk;
  wire cs;
  wire mosi;

  // Instantiate the SPI module
  spi uut (
    .clk(clk),
    .rst(rst),
    .newd(newd),
    .din(din),
    .sclk(sclk),
    .cs(cs),
    .mosi(mosi)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  initial begin
    // Initialize signals
    clk = 0;
    rst = 0;
    newd = 0;
    din = 12'h000;

    // Apply reset
    rst = 1;
    #10 rst = 0;

    // Test case 1: Sending data
    newd = 1;
    din = 12'hABC; // Sample data to be sent
    #100 newd = 0;

    // Add more test cases as needed

    // Simulation termination
    #100 $finish;
  end

  // Monitor state transitions
  always @(posedge clk) begin
    $display("State: %h, SCLK: %b, CS: %b, MOSI: %b", uut.state, sclk, cs, mosi);
  end
  
   initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end

endmodule
