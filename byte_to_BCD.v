/* AUTHOR
* Richard E. Haskell
* (Reformated by David Little)
*/

module base_10_digit (
    input [3:0] in,
    output reg [3:0] out
  );
    always @* begin
      case (in)
        4'b0000: out = 4'b0000;
        4'b0001: out = 4'b0001;
        4'b0010: out = 4'b0010;
        4'b0011: out = 4'b0011;
        4'b0100: out = 4'b0100;
        4'b0101: out = 4'b1000;
        4'b0110: out = 4'b1001;
        4'b0111: out = 4'b1010;
        4'b1000: out = 4'b1011;
        4'b1001: out = 4'b1100;
        default: out = 4'b0000;
      endcase
    end
endmodule // base_10_digit

module byte_to_BCD (
    input [7:0] value, // byte
    output [3:0] ones, tens, // 0 - 9
    output [1:0] hundreds // 0 - 2, since max is 255
  );
  wire [3:0] c1,c2,c3,c4,c5,c6,c7;
  wire [3:0] d1,d2,d3,d4,d5,d6,d7;

  assign d1 = {1'b0,    value[7:5]};
  assign d2 = {c1[2:0], value[4]};
  assign d3 = {c2[2:0], value[3]};
  assign d4 = {c3[2:0], value[2]};
  assign d5 = {c4[2:0], value[1]};
  assign d6 = {1'b0,c1[3],c2[3],c3[3]};
  assign d7 = {c6[2:0],c4[3]};

  base_10_digit m1 (d1,c1);
  base_10_digit m2 (d2,c2);
  base_10_digit m3 (d3,c3);
  base_10_digit m4 (d4,c4);
  base_10_digit m5 (d5,c5);
  base_10_digit m6 (d6,c6);
  base_10_digit m7 (d7,c7);

  assign ones = {c5[2:0],value[0]};
  assign tens = {c7[2:0],c5[3]};
  assign hundreds = {c6[3],c7[3]};
endmodule // byte_to_BCD
