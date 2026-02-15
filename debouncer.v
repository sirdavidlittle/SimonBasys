/* AUTHOR
* Gary Spivey
* David Little
*/

`include "globals.vh"

module debouncer (
    input button, clk, reset,
    output hold, pressed, released
  );

  localparam SAMPLE_TIME = MILLI_SECOND * 20;

  reg button_sampled, button_debounced, button_debounced_d;

  // is being pressed currently
  assign hold = button_debounced;
  // was not pressed but now is pressed
  assign pressed = button_debounced & ~button_debounced_d;
  // inverted wave of presseed
  assign released = ~button_debounced & button_debounced_d;


  reg [20:0] timer;

  // button sampling
  always @(posedge clk) begin
    button_debounced_d <= button_debounced;
    if (timer == 0) begin
      button_sampled <= button;
      if (button == button_sampled)
        button_debounced <= button;
    end
  end

  // countdown timer with reset
  always @(posedge clk) begin
    if (reset)
      timer <= SAMPLE_TIME;
    else begin
      timer <= timer - 1;
      if (timer == 0)
        timer <= SAMPLE_TIME;
     end
  end
endmodule // debouncer
