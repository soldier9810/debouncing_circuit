`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2024 16:52:25
// Design Name: 
// Module Name: delayed_debouncer
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


module delayed_debouncer(
    input logic sw, clk, reset, //sw means switch
    output logic db // db is for debounced
    );
    logic ms10; // 10 millisecond count
    
    counter_10ms inst1(.*);
    
    typedef enum {zero, wait1_10, wait1_20, wait1_30, one, wait0_10, wait0_20, wait0_30} state_type;
    
    state_type current_state, next_state;
    
    always_comb begin
        case (current_state)
            zero: next_state = (sw==1'b0) ? zero : wait1_10;
            wait1_10: next_state = (sw) ? ((ms10) ? wait1_20 : wait1_10):zero;
            wait1_20: next_state = (sw) ? ((ms10) ? wait1_30 : wait1_20):zero;
            wait1_30: next_state = (sw) ? ((ms10) ? one : wait1_30):zero;
            one: next_state = (sw) ? one : wait0_10;
            wait0_10: next_state = (sw) ? one : ((ms10) ? wait0_20 : wait0_10);
            wait0_20: next_state = (sw) ? one : ((ms10) ? wait0_30 : wait0_20);
            wait0_30: next_state = (sw) ? one : ((ms10) ? zero : wait0_30);
            default: next_state = zero;
        endcase
    end
    
    always_ff @(posedge clk) begin
        if (reset) current_state <= zero;
        else current_state <= next_state;
    end
    
    assign db = (current_state == one | current_state == wait0_10 | current_state == wait0_20 | current_state == wait0_30)? 1'b1 : 1'b0;
endmodule
