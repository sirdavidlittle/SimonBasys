/* AUTHOR
* David Little
*/

module seven_seg (
    output [7:0] seven_seg_n,
    input [3:0] digit
  );
  reg [6:0] raw_seven_seg;
  assign seven_seg_n = {1'b1, ~raw_seven_seg};

  always @* begin
    case (digit)
      4'h0:  raw_seven_seg = 7'b0111111;
      4'h1:  raw_seven_seg = 7'b0000110;
      4'h2:  raw_seven_seg = 7'b1011011;
      4'h3:  raw_seven_seg = 7'b1001111;
      4'h4:  raw_seven_seg = 7'b1100110;
      4'h5:  raw_seven_seg = 7'b1101101;
      4'h6:  raw_seven_seg = 7'b1111101;
      4'h7:  raw_seven_seg = 7'b0000111;
      4'h8:  raw_seven_seg = 7'b1111111;
      4'h9:  raw_seven_seg = 7'b1101111;
      4'hA:  raw_seven_seg = 7'b1110111;
      4'hB:  raw_seven_seg = 7'b1111100;
      4'hC:  raw_seven_seg = 7'b0111001;
      4'hD:  raw_seven_seg = 7'b1011110;
      4'hE:  raw_seven_seg = 7'b1111001;
      4'hF:  raw_seven_seg = 7'b1110001;
    endcase
  end
endmodule
