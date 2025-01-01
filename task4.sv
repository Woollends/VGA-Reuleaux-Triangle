module task4(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

    // instantiate and connect the VGA adapter and your module


    logic [9:0] VGA_R_10,VGA_G_10, VGA_B_10;
    logic VGA_BLANK, VGA_SYNC;
    logic  startf=0, startc=0, donef=0, donec=0; 
    logic [7:0] VGA_XF,VGA_XC,centre_x = 8'd80, radius = 8'd40;
    logic [6:0] VGA_YF,VGA_YC,centre_y = 7'd60;
    logic [2:0] VGA_COLOURF,VGA_COLOURC,inclrc = 3'b010,inclrf = 3'b000;
    logic VGA_PLOTF,VGA_PLOTC;

    assign VGA_R = VGA_R_10[9:2];
    assign VGA_G = VGA_G_10[9:2];
    assign VGA_B = VGA_B_10[9:2];

    always_ff @( posedge CLOCK_50 ) begin
        if (!KEY[2]) begin
            centre_x <= SW[7:0];    //use switches and key2 to set centre x
        end
        if (!KEY[1]) begin
            centre_y <= SW[6:0];    //switches and key1 centre y
        end
        if (!KEY[0] &&  SW[9]) begin    //press key 0 while sw9 high
            inclrf<=SW[2:0];            //sw2-0 for colour to fill screen
            inclrc<=SW[5:3];            //sw5-3 for colour of circle
        end
        else if (!KEY[0]) begin
            radius<=SW[7:0];            //key0 with sw9 down sue switches to set radius
        end
        if (!KEY[3])begin
            startf<=1; startc<=0; 
        end
        if(donef)begin
            startf<=0; startc<=1;
        end
        if (donec) begin
            startf<=0;startc<=0;
        end
    end

    always_comb begin
        if (startf) begin
            VGA_X = VGA_XF;
            VGA_Y = VGA_YF;
            VGA_COLOUR = VGA_COLOURF;
            VGA_PLOT = VGA_PLOTF;
        end
        else if (startc) begin
            VGA_X = VGA_XC;
            VGA_Y = VGA_YC;
            VGA_COLOUR = VGA_COLOURC;
            VGA_PLOT =VGA_PLOTC;
        end
        else begin
            VGA_X = 8'd0;
            VGA_Y = 7'd0;
            VGA_COLOUR = 3'd0;
            VGA_PLOT =1'b0;
        end
    end

    reuleaux reulx(.clk(CLOCK_50),.rst_n(KEY[3]), .colour(inclrc),
                .centre_x(centre_x),.centre_y(centre_y),.diameter(radius),
                .start(startc),.done(donec),
                .vga_x(VGA_XC),.vga_y(VGA_YC),
                .vga_colour(VGA_COLOURC),.vga_plot(VGA_PLOTC)
                );
    
    fillscreen fscreen(.clk(CLOCK_50),.rst_n(KEY[3]), .colour(inclrf),
                        .start(startf),.done(donef),
                        .vga_x(VGA_XF),.vga_y(VGA_YF),
                        .vga_colour(VGA_COLOURF),.vga_plot(VGA_PLOTF)
                        );

    vga_adapter#(.RESOLUTION("160x120")) vga_u0(.resetn(KEY[3]), .clock(CLOCK_50), .colour(VGA_COLOUR),
                                            .x(VGA_X), .y(VGA_Y), .plot(VGA_PLOT),
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10),
                                            .*);


endmodule: task4
