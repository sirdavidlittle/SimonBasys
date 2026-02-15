/* AUTHOR
* David Little
*/


`include "globals.vh"


module simon_RGB (
    output [2:0] led0, led1, led2, led3,
    input [1:0] select,
    input enable, clk, strobe
  );

  reg green_button, red_button, yellow_button, blue_button;
  assign led0 = {1'b0, green_button, 1'b0};   // Green BGR
  assign led1 = {2'b00, red_button};   // red BGR 
  assign led2 = {1'b0, yellow_button, yellow_button};  // yellow BGR
  assign led3 = {blue_button, 2'b00}; // Blue BGR 

  reg [18:0] timer;
  reg pulse;

  // 4MS on, 1MS off timer
  always @(posedge clk) begin
    pulse <= 0;
    if (timer == 0)
      timer <= MILLI_SECOND * 5;
    else if (timer < MILLI_SECOND)
      pulse <= 1;
    timer <= timer - 1;
  end

  always @* begin
    if (strobe) begin
      green_button = 1'b1;
      red_button = 1'b1;
      yellow_button = 1'b1;
      blue_button = 1'b1;
    end else begin
      green_button = pulse;
      red_button = pulse;
      yellow_button = pulse;
      blue_button = pulse;
      if (enable)
        case (select)
          GREEN: green_button = 1'b1;
          RED: red_button = 1'b1;
          YELLOW: yellow_button = 1'b1;
          BLUE: blue_button = 1'b1;
        endcase
    end
  end

endmodule // simon_RGB_ctrl
