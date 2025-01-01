module reuleaux(input logic clk, input logic rst_n, input logic [2:0] colour,
                input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] diameter,
                input logic start, output logic done,
                output logic [7:0] vga_x, output logic [6:0] vga_y,
                output logic [2:0] vga_colour, output logic vga_plot);
     // draw the Reuleaux triangle
 /*    assign c_x = centre_x;
assign c_y = centre_y;
assign c_x1 = c_x + diameter/2;
assign c_y1 = c_y + diameter * $sqrt(3)/6;
assign c_x2 = c_x - diameter/2;
assign c_y2 = c_y + diameter * $sqrt(3)/6;
assign c_x3 = c_x;
assign c_y3 = c_y - diameter * $sqrt(3)/3;
*/

logic start_1; //start signals
logic start_2;
logic start_3;

logic [2:0] colour_latch; //latches to lock numbers while drawing
logic [7:0] centre_x_latch, diameter_latch;
logic [6:0] centre_y_latch;
//internal signals for fixed point rounding
logic [23:0] c_x, c_y, c_x1, c_y1, c_x2, c_y2, c_x3, c_y3, sqrt_6, sqrt_3, diameter_cal, lowest,right,left;

logic done_1; //outputs signals for circle 1
logic [7:0] vga_x_1;
logic [6:0] vga_y_1;
logic [2:0] vga_colour_1;
logic vga_plot_1;

logic done_2; //outputs signals for circle 2
logic [7:0] vga_x_2;
logic [6:0] vga_y_2;
logic [2:0] vga_colour_2;
logic vga_plot_2;


logic [7:0] vga_x_3; //outputs signals for circle 3
logic [6:0] vga_y_3;
logic [2:0] vga_colour_3;
logic vga_plot_3;

logic [11:0] temp_c_x1, temp_c_y1, temp_c_x2, temp_c_y2, temp_c_x3, temp_c_y3; // test varible for waveform
logic [11:0] temp_lowest, temp_right, temp_left; 

circle circle_1 ( //dut for drawing the first circle
    .clk(clk),
    .rst_n(rst_n),
    .colour(colour),
    .centre_x(c_x1[23:12]),
    .centre_y(c_y1[23:12]),
    .radius(diameter),
    .x_min(0),
    .start(start_1),
    .y_max(c_y1[23:12]+1'b1),
    .y_min(0),
    .x_max(c_x3[23:12]),
    .done(done_1),
    .vga_x(vga_x_1),
    .vga_y(vga_y_1),
    .vga_colour(vga_colour_1),
    .vga_plot(vga_plot_1)
);

circle circle_2 ( //dut for drawing the second circle
    .clk(clk),
    .rst_n(rst_n),
    .colour(colour),
    .centre_x(c_x2[23:12]),
    .centre_y(c_y2[23:12]),
    .radius(diameter),
    .x_min(c_x3[23:12]-1'b1),
    .start(start_2),
    .y_max(c_y2[23:12]+1'b1),
    .y_min(0),
    .x_max(160),
    .done(done_2),
    .vga_x(vga_x_2),
    .vga_y(vga_y_2),
    .vga_colour(vga_colour_2),
    .vga_plot(vga_plot_2)
);

circle circle_3 ( //dut the drwaing the third circle
    .clk(clk),
    .rst_n(rst_n),
    .colour(colour),
    .centre_x(c_x3[23:12]),
    .centre_y(c_y3[23:12]),
    .radius(diameter),
    .x_min(0),
    .start(start_3),
    .y_max(100),
    .y_min(c_y1[23:12]),
    .x_max(160),
    .done(done),
    .vga_x(vga_x_3),
    .vga_y(vga_y_3),
    .vga_colour(vga_colour_3),
    .vga_plot(vga_plot_3)
);


enum {starter, drawcirc1, drawcirc2, drawcirc3} state; //defining states for the state machine

always_ff @(posedge clk) begin //alwyas_ff block for the statemachine
    if (~rst_n) begin //reset to reset all varibles 
        vga_x <= 8'd0;
        vga_y <= 7'd0;
        colour_latch <= colour;
        vga_plot <= 1'd0;
        state <= starter;
        start_1<=1'b0;
        start_2<=1'b0;
        start_3<=1'b0;
    end else begin
        case (state) //case statments
            starter: begin
                if (!start) begin  //start state to set up latches
                    vga_colour <= colour_latch;
                    centre_x_latch <= centre_x;
                    centre_y_latch <= centre_y;
                    diameter_latch <= diameter;   
                end else begin
                    state <= drawcirc1; //transtion to next states
                    start_1 <= 1'b1;
                end
            end

            drawcirc1: begin
                if (done_1) begin //checking to see if cirlce one is complete, transtion to circle 2
                    state <= drawcirc2;
                    start_1 <= 1'b0;
                    start_2 <= 1'b1;
                end else begin //settting output signals to circle 1
                    vga_x <= vga_x_1;
                    vga_y <= vga_y_1;
                    vga_plot <= vga_plot_1;
                    vga_colour <= vga_colour_1;
                end
            end

            drawcirc2: begin
                if (done_2) begin //checking to see if circle two is complete, transtion to circle 3
                    state <= drawcirc3;
                    start_2 <= 1'b0;
                    start_3 <= 1'b1;
                end else begin //setting output signals to cirlce 2
                    vga_x <= vga_x_2;
                    vga_y <= vga_y_2;
                    vga_plot <= vga_plot_2;
                    vga_colour <= vga_colour_2;
                end
            end

            drawcirc3: begin
                if (done) begin //checking to see if circle three is complete, transtion to start state
                    state <= starter;
                    start_3 <= 1'b0;
                end else begin //setting output signals to cirlce 3
                    vga_x <= vga_x_3;
                    vga_y <= vga_y_3;
                    vga_plot <= vga_plot_3;
                    vga_colour <= vga_colour_3;
                end
            end

            default: begin
                state <= starter; //default state back to start
            end
        endcase
    end
end




always_comb begin //combination logic to decide the rounding

     if(diameter_latch % 2 == 0) begin //logic to decide the diameter rounding
          diameter_cal = {diameter_latch, 12'b0};
     end else begin
          diameter_cal = {diameter_latch+1'd1, 12'b0};
     end
          sqrt_6 = {13'b0, 11'd1188}; //setting up the decimal that will be multipled  
          sqrt_3 = {12'b0, 12'd2370};
          

          c_x = {centre_x_latch, 12'b0}; //latch to hold c_x, and c_y
          c_y = {centre_y_latch, 12'b0};

          c_x1 = c_x + (diameter_cal >> 1)+12'b100000000000; //logic for the fixed point rounding
          c_y1 = c_y + (diameter_latch * sqrt_6)+12'b100000000000;
          c_x2 = c_x - (diameter_cal >> 1)+12'b100000000000;
          c_y2 = c_y + (diameter_latch * sqrt_6)+12'b100000000000;
          c_x3 = c_x;
          c_y3 = c_y - (diameter_latch * sqrt_3)+12'b100000000000;
          lowest = c_y - diameter_latch +12'b100000000000;
          right = c_x + diameter_latch +12'b100000000000;
          left = c_x - diameter_latch +12'b100000000000;

    temp_c_x1 = c_x1[23:12]; //temp varibles for the waveform
    temp_c_y1 = c_y1[23:12];
    temp_c_x2 = c_x2[23:12];
    temp_c_y2 = c_y2[23:12];
    temp_c_x3 = c_x3[23:12];
    temp_c_y3 = c_y3[23:12];
    temp_lowest = lowest[23:12];
    temp_right = right[23:12];
    temp_left = left[23:12];



               // draw the Reuleaux triangle
 /*    assign c_x = centre_x;
assign c_y = centre_y;
assign c_x1 = c_x + diameter/2;
assign c_y1 = c_y + diameter * $sqrt(3)/6;
assign c_x2 = c_x - diameter/2;
assign c_y2 = c_y + diameter * $sqrt(3)/6;
assign c_x3 = c_x;
assign c_y3 = c_y - diameter * $sqrt(3)/3;
*/
          
end
endmodule

