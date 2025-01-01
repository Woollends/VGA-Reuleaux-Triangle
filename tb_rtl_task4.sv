`timescale 1ps/1ps

module tb_rtl_task4();

 // Parameters for the clock
    reg CLOCK_50;
    reg [3:0] KEY; // 4 keys as inputs
    reg [9:0] SW;  // 10 switches as inputs
    wire [9:0] LEDR; // 10 LEDs as outputs
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // 7-segment displays
    wire [7:0] VGA_R, VGA_G, VGA_B; // VGA color outputs
    wire VGA_HS, VGA_VS, VGA_CLK; // VGA synchronization signals
    wire [7:0] VGA_X; // VGA X-coordinate
    wire [6:0] VGA_Y; // VGA Y-coordinate
    wire [2:0] VGA_COLOUR; // VGA color
    wire VGA_PLOT; // VGA plot signal

    // Instantiate the module
    task4 dut (
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_CLK(VGA_CLK),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOUR(VGA_COLOUR),
        .VGA_PLOT(VGA_PLOT)
    );


always begin
        #1 CLOCK_50= ~CLOCK_50; 
    end

initial begin
    CLOCK_50=1'b0;
    KEY=4'b1;
    #4;
   

    SW = 8'd30;
    #4;
    KEY[2]=1'b0;
    #4;
    KEY[2]=1'b1;
    #4;
    KEY[1]=1'b0;
    #4;
    KEY[1]=1'b1;
    #4;
    KEY[0]=1'b0;
    #4;
    KEY[0]=1'b1;

    KEY[3]=4'b0;    //applies reset
    #10;

    SW[9]=1'b1;
    #4;
    KEY[0]=1'b0;
    #4;
    KEY[0]=1'b1;

    KEY[3] = 1'b1; //reset off, start state machine

    #10000000;

    $stop;
end

// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.

endmodule: tb_rtl_task4
