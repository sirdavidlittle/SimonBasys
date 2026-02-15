/* AUTHOR
* David Little
*/

`ifndef GLOBALS_H
`define GLOBALS_H


// SIMON button moves
parameter GREEN = 2'd0,
          RED = 2'd1,
          YELLOW = 2'd2,
          BLUE = 2'd3;

// 100mhz clock cycles per time interval
parameter MICRO_SECOND = 100,
          MILLI_SECOND = MICRO_SECOND * 1000,
          SECOND = MILLI_SECOND * 1000;

// LCD
parameter LCD_WIDTH = 16;
parameter BLANK_LCD = "                ";


`endif // GLOBALS_H
