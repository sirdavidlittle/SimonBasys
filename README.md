# project SIMON
> An implementation of Milton-Bradley’s SIMON game in Verilog for Basys3 FPGA hardware.

---

## Game Configuration

Arrange the SIMON buttons as follows:
    - Green in the upper left
    - Red in the upper right
    - Yellow in the lower right
    - blue in the lower left)
  The LED’s for the buttons should always be on – either brightly (turned on all of the time) when selected,
  or dimly (a duty cycle less than 100%). You should set the period of this cycle so that the LED’s do
  not have a flashing effect. You should set the duty cycle so that the distinction between OFF and ON is clear.
  2. Print a message on the LCD welcoming the player to the Simon game,
  and inviting them to press a particular SIMON button to begin the game.
  Use that button press to randomize your LFSR and initiate the game sequence.

##  Playing the Game
  3. When the game begins, use the top line of the LCD for instructions to the user
  and the bottom line for an indication of the users score. The top line should indicate when
  SIMON is playing a sequence and when completed, instruct the user to repeat the
  sequence. The score is a 2 digit number representing the number of rounds performed
  successfully. When the user presses the button to begin the game, print this info and
  immediately move to the next step (playing the tones).
  4. Play a pseudorandom sequence with tones. The number of tones should
  increase by one with each successful round completed by the player. Each tone should be
  played for ¾ of a second with a ¼ second gap between tones.
  5. Prompt the player to repeat the sequence. When a player presses the button,
  play the appropriate tone and light the appropriate LED with its color.
  6. Compare the key pressed to the correct key in the sequence. If the key is
  correct, continue on to the next key for each key in the sequence.
  7. When the sequence has completed, sound a “success” tone, update the score
  and message, and repeat the sequence with an additional note. Continue this cycle until the
  player fails.
  8.  When the player fails, play a failure tone and print message. Wait a short amount
  of time, then prompt the user to play another game – looping back to step 2.


##  Cheat modes
  9. The center button to instruct Simon to repeat the tone sequence.
  This button should only work at the end of step 4. That is, after Simon has played the
  sequence, and before the player has started to attempt the sequence.
  10. Use a switch indicate Cheat mode. When in Cheat mode,
  show the next four values in the sequence on the hex displays.

---
