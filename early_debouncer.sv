`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2024 17:20:24
// Design Name: 
// Module Name: early_debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module early_debouncer(
    input logic sw, clk, reset,
    output logic db
    );
    
    logic ms10;
    counter_10ms(.*);
    
    typedef enum {one, wait1_10, wait1_20, zero} state_type;
    
    state_type current_state, next_state;
    
    always_comb begin
        case(current_state)
            zero: next_state = (sw) ? one : zero;
            one: next_state = (ms10) ? wait1_10 : one;
            wait1_10 : next_state = (ms10) ? wait1_20 : wait1_10;
            wait1_20: next_state = (sw) ? wait1_20 : zero;
            default: next_state = zero;
        endcase
    end
    
    always_ff @(posedge clk) begin
        if (reset) current_state <= zero;
        else current_state <= next_state;
    end
    
    assign db = (current_state == zero) ? 1'b0 : 1'b1; 
    
endmodule
