/* AUTHOR
* David Little
*/

module digit_to_char (
    input [3:0] digit,
    input blank_if_zero,
    output reg [7:0] char
  );

  always @* begin
    case (digit)
      4'd1: char = "1";
      4'd2: char = "2";
      4'd3: char = "3";
      4'd4: char = "4";
      4'd5: char = "5";
      4'd6: char = "6";
      4'd7: char = "7";
      4'd8: char = "8";
      4'd9: char = "9";
      4'd0: char = blank_if_zero ? " " : "0";
    endcase
  end
endmodule // digit_to_char


module byte_to_string (
    input [7:0] value,
    output [3*8-1:0] str
  );
  wire [3:0] ones, tens;
  wire [1:0] hundreds;
  wire tens_blank_if_zero = (hundreds == 2'd0);

  byte_to_BCD BBCD(
    value,
    ones, tens, hundreds
  );

  digit_to_char D_ONE(
    ones, 1'b0, // never blank!
    str[7:0]
  );

  digit_to_char D_TEN(
    tens, tens_blank_if_zero, // blank iff hundreds is
    str[15:8]
  );

  digit_to_char D_HUND(
    hundreds, 1'b1, // always blank
    str[23:16]
  );
endmodule // byte_to_string
