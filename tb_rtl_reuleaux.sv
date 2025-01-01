`timescale 1ns/1ps

module tb_rtl_reuleaux();
logic clk;
logic rst_n;
logic [2:0] colour;
logic [7:0] centre_x;
logic [6:0] centre_y;
logic [7:0] diameter;
logic start;
logic done;
logic [7:0] vga_x;
logic [6:0] vga_y;
logic [2:0] vga_colour;
logic vga_plot;


reuleaux dut (
        .clk(clk),
        .rst_n(rst_n),
        .colour(colour),
        .centre_x(centre_x),
        .centre_y(centre_y),
        .diameter(diameter),
        .start(start),
        .done(done),
        .vga_x(vga_x),
        .vga_y(vga_y),
        .vga_colour(vga_colour),
        .vga_plot(vga_plot)
    );


always begin
        #2 clk = ~clk; 
    end

initial begin
    clk=1'b0;
    rst_n=1'b0;
    start=1'b0;
    colour=3'b010;
    centre_x=8'd80;
    centre_y=7'd60;
    diameter=8'd20;
    #200;
    rst_n=1'b1;
    colour=3'b010;
    centre_x=8'd80;
    centre_y=7'd60;
    diameter=8'd40;
    #10;
    start=1'b1;
    #2;
    #10000;
    start=1'b0;
    wait(done);               // Wait until the 'done' signal is asserted

    colour=3'b010;
    centre_x=8'b11111111;
    centre_y=7'b1111111;
    diameter=8'b11111111;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

     colour=3'b010;
    centre_x=8'd0;
    centre_y=7'd0;
    diameter=8'b11111111;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

     colour=3'b010;
    centre_x=8'b11111111;
    centre_y=7'd0;
    diameter=8'b11111111;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

     colour=3'b010;
    centre_x=8'd0;
    centre_y=7'b1111111;
    diameter=8'b11111111;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

    colour=3'b010;
    centre_x=8'b11111111;
    centre_y=7'b1111111;
    diameter=8'd40;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

     colour=3'b010;
    centre_x=8'd0;
    centre_y=7'd0;
    diameter=8'd40;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

     colour=3'b010;
    centre_x=8'b11111111;
    centre_y=7'd0;
    diameter=8'd40;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

     colour=3'b010;
    centre_x=8'd0;
    centre_y=7'b1111111;
    diameter=8'd40;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

    colour=3'b010;
    centre_x=8'b11111111;
    centre_y=7'b1111111;
    diameter=8'd0;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

     colour=3'b010;
    centre_x=8'd0;
    centre_y=7'd0;
    diameter=8'd0;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

     colour=3'b010;
    centre_x=8'b11111111;
    centre_y=7'd0;
    diameter=8'd0;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);

     colour=3'b010;
    centre_x=8'd0;
    centre_y=7'b1111111;
    diameter=8'd0;
    #10;
    start=1'b1;
    #2;
    #2;
    #10000;
    start=1'b0;
    wait(done);


        // Display the final output state
        $display("Reuleaux Triangle Drawing Completed");
        $display("VGA X: %d, VGA Y: %d", vga_x, vga_y);
        $display("VGA Colour: %b, VGA Plot: %b", vga_colour, vga_plot);

        // Stop the simulation
        $stop;
end
// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.

endmodule: tb_rtl_reuleaux
