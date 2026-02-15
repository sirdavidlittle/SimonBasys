/* AUTHOR
* David Little
*/


/*** Required Basys Components & Pins: ***

* 100mhz System Clock
  - for everything!
      clk

* Buttons
  - for reseting the game
    btnC

* Switches
  - for enabling cheat mode and master reset
    sw[1:0]

* LEDS

* LCD display
  - for display score and game instructions.
    lcd_data[7:0]
    lcd_regsel
    lcd_read

* Simon Buttons
  - For displaying and inputing moves in SIMON.
    simon_buttons_n[3:0]
    simon_led(1-4)[2:0]

* Simple Tone Speaker
  - For button sound effects.
    speaker

* Seven-Segement Display
  - for displaying the next four moves in Cheat Mode.
    seg_n[7:0]
    an_n[3:0]
*/

`include "globals.vh"
`include "states.vh"
`include "chrono.vh"

module top (
    // Clock
    input clk,
    // Buttons
    input btnC,
    // LEDs
    output [15:0] led,
    // Switches
    input [2:0] sw,
    // LCD
    output lcd_regsel,
    inout [7:0] lcd_data,
    output lcd_enable,
    // Simon Buttons
    input [3:0] simon_buttons_n,
    output [2:0] simon_led0, simon_led1, simon_led2, simon_led3,
    // Speaker
    output speaker,
    // Seven Segement Display
    output [7:0] seg_n,
    output [3:0] an_n
  );

  wire cheat_mode = sw[0];
  wire master_reset = sw[1];
  wire debug_mode = sw[2];
  wire [3:0] simon_button_hold, simon_button_released, simon_button_pressed;
  wire [3:0] simon_buttons = ~simon_buttons_n;

  wire no_button_hold = (simon_button_hold == 0);

  wire repeat_sequence;

  debouncer DR (
    .button(btnC),
    .pressed(repeat_sequence),
    .clk(clk)
  );


  genvar gi;

  generate
    for (gi = 0; gi < 4; gi = gi + 1) begin
      debouncer DRS (
        .clk(clk),
        .reset(master_reset),
        .button(simon_buttons[gi]),
        .released(simon_button_released[gi]),
        .pressed(simon_button_pressed[gi]),
        .hold(simon_button_hold[gi])
      );
    end
  endgenerate

  // first simon pressed in AWAIT_PLAYER_PRESS state


  wire released, captured;
  wire [1:0] captured_simon;
  reg capture_release_reset, sync_capture_release_reset;

  simon_capture SC (
    .clk(clk),
    .reset(sync_capture_release_reset),
    .pressed(simon_button_pressed),
    .released(simon_button_released),
    .released_signal(released),
    .captured_signal(captured),
    .button(captured_simon)
  );

  // Simon Notes
  reg light_and_sound_enable, success, failure;
  reg [1:0] activated_simon;

  // simon light up button
  simon_RGB RGB (
    .led0(simon_led0), .led1(simon_led1),
    .led2(simon_led2), .led3(simon_led3),
    .clk(clk),
    .select(activated_simon),
    .enable(light_and_sound_enable),
    .strobe(failure)
  );

  // Tone Generator
  simon_tone_generator SG (
    .speaker(speaker),
    .enable(light_and_sound_enable),
    .clk(clk),
    .success(success), .failure(failure),
    .tone_select(activated_simon)
  );

  wire print_available;
  reg [8*LCD_WIDTH-1:0] topline, bottomline;
  reg print;

  lcd_string LCD (
   // ignore: lcd_read
    .lcd_regsel(lcd_regsel),
    .lcd_data(lcd_data),
    .available(print_available),
    .lcd_enable(lcd_enable),

    .print(print),
    .topline(topline),
    .bottomline(bottomline),
    .reset(master_reset),
    .clk(clk)
  );


  reg timer_reset;
  reg [26:0] timer_interval, timer;

  always @ (posedge clk) begin
    if (timer_reset)
      timer <= timer_interval;
    else if (timer > 0)
      timer <= timer - 1;
  end

  wire [1:0] lfsr_simon;
  wire [5:0] next_random;
  reg lfsr_randomize, lfsr_rerun, lfsr_step;

  PRNG RNG (
    .random(lfsr_simon),
    .clk(clk), .reset(master_reset),
    .step(lfsr_step),
    .next_random(next_random),
    .rerun(lfsr_rerun),
    .randomize(lfsr_randomize)
  );

  // saves up to 255 simon moves
  // world record is 100!
  reg [7:0] sequence_index, sequence_length, max_score;


  reg [3:0] A, B, C, D;

  always @* begin
    D = 0;
    C = 0;
    B = 0;
    A = 0;
    if (cheat_mode) begin
      D = {1'b0,next_random[5:4]};
      C = {1'b0,next_random[3:2]};
      B = {1'b0,next_random[1:0]};
      A = {1'b0,lfsr_simon};
    end else if (debug_mode) begin
      D = sequence_index[7:4];
      C = sequence_index[3:0];
      B = sequence_length[7:4];
      A = sequence_length[3:0];
    end
  end

  seg_ctrl SEGC (
    .seg_n(seg_n),
    .an_n(an_n),
    .clk(clk),
    .D(D), .C(C), .B(B), .A(A)
  );


  wire [8*3-1:0] current_score_str, max_score_str;

  byte_to_string BS0 (
    .value(sequence_length),
    .str(current_score_str)
  );

  byte_to_string BS1 (
    .value(max_score),
    .str(max_score_str)
  );

  wire [8*LCD_WIDTH-1:0] score_message = {"  Score: ", current_score_str, "    "};

  reg [STATE_BITS-1:0] current_state, next_state;

  // State Changer
  always @ (posedge clk) begin
    if (master_reset)
      current_state <= START;
    else
      current_state <= next_state;
  end

  reg reset_index, step_index;
  reg reset_length, step_length;

  always @ (posedge clk) begin
    sync_capture_release_reset <= capture_release_reset;
    if (reset_index)
      sequence_index <= 0;
    else if (step_index)
      sequence_index <= sequence_index + 1;

    if (reset_length)
      sequence_length <= 0;
    else if (step_length)
      sequence_length <= sequence_length + 1;

    if (sequence_length > max_score)
      max_score <= sequence_length;
  end


  initial begin
    max_score = 0;
    sequence_length = 0;
    current_state = START;
  end

  wire timer_over = (timer == 0);


  wire [15:0] debug_buffer = {
    current_state,        // 0 - 4
    simon_button_pressed, // 5 - 8
    captured,             // 9
    released,             // 10
    lfsr_randomize,       // 11
    success,              // 12
    failure,              // 13
    activated_simon       // 14 - 15
  };


  assign led = debug_mode ? debug_buffer : 0;


  // State Logic
  always @ (*) begin
    next_state = current_state;
    // LCD
    topline = BLANK_LCD;
    bottomline = BLANK_LCD;
    print = 0;
    // Delay Timer
    timer_interval = 0;
    timer_reset = 0;
    // Lights and Tones
    success = 0;
    failure = 0;
    light_and_sound_enable = 0;
    activated_simon = 0;
    // Capturing SIMON Inputs
    capture_release_reset = 1;
    // PRNG control
    lfsr_rerun = 0;
    lfsr_step = 0;
    lfsr_randomize = 0;
    // simon move counters
    step_length = 0;
    step_index = 0;
    reset_length = 0;
    reset_index = 0;


    case (current_state)
      START: begin
        reset_index = 1;
        reset_length = 1;
        if (print_available) begin
          print = 1;
          topline    =  "Welcome 2 Simon!";
          bottomline =  {"hit RED | HI:", max_score_str};
          next_state = RANDOMIZE;
        end
      end

      RANDOMIZE: begin
        lfsr_randomize = 1;
        if (simon_button_released[RED]) begin
          next_state = PRINT_READY;
        end
      end

      PRINT_READY: begin
        if (print_available) begin
            print = 1;
            topline = " Are you ready? ";
            timer_interval = ROUND_DELAY;
            next_state = WAIT_READY;
            timer_reset = 1;
        end
      end

      WAIT_READY: begin
        if (timer_over)
            next_state = NEXT_ROUND;
      end


      NEXT_ROUND: begin
        step_length = 1;
        next_state = PRINT_PREPARE_GAME;
      end

      PRINT_PREPARE_GAME: begin
        if (print_available) begin
          print = 1;
          topline = " Pay Attention! ";
          bottomline = score_message;
          next_state = PREPARE_GAME;
        end
      end

      PREPARE_GAME: begin
        timer_interval = RECITE_MOVES_DELAY;
        timer_reset = 1;
        next_state = LIGHT_GAME_MOVE;
        reset_index = 1;
        lfsr_rerun = 1;
      end

      LIGHT_GAME_MOVE: begin
        light_and_sound_enable = 1;
        activated_simon = lfsr_simon;
        if (timer_over) begin
          lfsr_step = 1;
          step_index = 1;
          next_state = DARK_GAME_MOVE;
          timer_interval = GAME_MOVE_LIGHT_DELAY;
          timer_reset = 1;
        end
      end

      DARK_GAME_MOVE: begin
        if (timer_over) begin
          if (sequence_index == sequence_length) begin
            next_state = PRINT_PREPARE_PLAYER;
          end else begin
            timer_reset = 1;
            next_state = LIGHT_GAME_MOVE;
            timer_interval = GAME_MOVE_DARK_DELAY;
          end
        end
      end

      PRINT_PREPARE_PLAYER: begin
        if (print_available) begin
          print = 1;
          topline = "Recite the moves";
          bottomline = score_message;
          next_state = PREPARE_PLAYER;
          timer_interval = PLAYER_DO_MOVES_DELAY;
          timer_reset = 1;
        end
      end

      PREPARE_PLAYER: begin
        if (timer_over) begin
           lfsr_rerun = 1;
           reset_index = 1;
           next_state = PLAYER_PRESS;
        end
      end

      PLAYER_PRESS: begin
        capture_release_reset = 0;
        if (repeat_sequence) begin
          next_state = PRINT_PREPARE_GAME;
        end else begin
          if (captured) begin
            light_and_sound_enable = 1;
            activated_simon = captured_simon;
          end
          if (released) begin
            next_state = CHECK_PLAYER_MOVE;
            step_index = 1;
          end
        end
      end

      AWAIT_NOTHING_PRESSED: begin
        if (no_button_hold)
          next_state = PLAYER_PRESS;
      end

      CHECK_PLAYER_MOVE: begin
        if (captured_simon == lfsr_simon) // correct move
          if (sequence_index == sequence_length) // sequence completed!
            next_state = PRINT_SUCCESS;
          else begin // keep going
            lfsr_step = 1;
            next_state = AWAIT_NOTHING_PRESSED;
        end else // bad move
          next_state = PRINT_FAILURE;
      end

      PRINT_SUCCESS: begin
        if (print_available) begin
          print = 1;
          topline =    " Round Complete!";
          bottomline = score_message;
          next_state = SUCCESS;
          timer_interval = SUCCESS_DELAY;
          timer_reset = 1;
        end
      end

      SUCCESS: begin
        success = 1;
        if (timer_over) begin
          next_state = PRINT_READY;
        end
      end

      PRINT_FAILURE: begin
        if (print_available) begin
          print = 1;
          topline =    "   You Failed   ";
          bottomline = "Better luck next";
          next_state = FAILURE;
          timer_interval = FAILURE_DELAY;
          timer_reset = 1;
        end
      end

      FAILURE: begin
        failure = 1;
        if (timer_over)
          next_state = START;
      end
    endcase
  end
endmodule // top
