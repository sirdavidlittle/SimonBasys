/* AUTHOR
* David Little
*/


`ifndef STATES_H_
`define STATES_H_


parameter START = 0,
          RANDOMIZE = 1,
          PREPARE_GAME = 2,
          LIGHT_GAME_MOVE = 3,
          DARK_GAME_MOVE = 4,
          PREPARE_PLAYER = 5,
          PLAYER_PRESS = 6,
          AWAIT_NOTHING_PRESSED = 7,
          CHECK_PLAYER_MOVE = 8,
          SUCCESS = 9,
          FAILURE = 10,
          NEXT_ROUND = 11,
          PRINT_FAILURE = 12,
          PRINT_SUCCESS = 13,
          PRINT_PREPARE_PLAYER = 14,
          PRINT_PREPARE_GAME = 15,
          WAIT_READY = 16,
          PRINT_READY = 17;

parameter STATE_BITS = 5;

`endif // STATES_H_
