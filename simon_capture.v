/* AUTHOR
* David Little
*/

`include "globals.vh"

module simon_capture (
    output reg released_signal, captured_signal,
    output reg [1:0] button,
    input reset, clk,
    input [3:0] pressed, released
  );
  // NOTE: button holds the last capture even after reset!

  wire any_button_pressed = (pressed != 0);

  always @(posedge clk) begin
    if (reset) begin
      captured_signal <= 0;
      released_signal <= 0;
    end else begin
      if (captured_signal) begin
        if (released[button]) begin
          released_signal <= 1;
        end
      end else if (any_button_pressed) begin
        captured_signal <= 1;
        if (pressed[GREEN])
          button <= GREEN;
        else if (pressed[RED])
          button <= RED;
        else if (pressed[YELLOW])
          button <= YELLOW;
        else // BLUE
          button <= BLUE;
      end
    end
  end

endmodule // simon_capture
