/* AUTHOR
* Gary Spivey
* David Little
*/

module PRNG (
    output [1:0] random,
    output [5:0] next_random,
    input step, rerun, randomize, clk, reset
  );
  


  LFSR #(.FILL(16'hDEAD)) u1 (
    .random(random[0]),
    .next_random({next_random[4], next_random[2], next_random[0]}),
    .step(step), .rerun(rerun),
    .randomize(randomize),
    .clk(clk), .reset(reset)
  );

  LFSR #(.FILL(16'hBEEF)) u2 (
    .random(random[1]),
    .next_random({next_random[5], next_random[3], next_random[1]}),
    .step(step), .rerun(rerun),
    .randomize(randomize),
    .clk(clk), .reset(reset)
  );
endmodule
