/* AUTHOR
* David Little
*/


`include "globals.vh"


module simon_tone_generator (
    output reg speaker,
    input enable, clk, success, failure,
    input [1:0] tone_select
  );

  localparam A4 = 227272,
             B4 = 202478,
             D4 = 170262,
             E4 = 151686,
             F4S = 135136,
             A5 = 113636;

  reg [20:0] timer, tone;

  wire sound = enable | success | failure;


  always @* begin
    if (success)
      tone = A5;
    else if (failure)
      tone = F4S;
    else
      case (tone_select)
        GREEN: tone = A4;
        RED: tone = B4;
        BLUE: tone = D4;
        YELLOW: tone = E4;
      endcase
  end

  always @(posedge clk) begin
    speaker <= 0;
    if (sound) begin
      if (timer == 0)
        timer <= tone;
      else
        timer <= timer - 1;
      if (timer < (tone / 2))
        speaker <= 1;
    end
  end

endmodule // simon_tone_generator
