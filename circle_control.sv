
module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic [11:0] centre_x, input logic [11:0] centre_y, input logic [7:0] radius, input logic [11:0] x_min, 
              input logic start, input logic [11:0] y_max, input logic [11:0] y_min, input logic [11:0] x_max, 
              output logic done, output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);
     
     logic [7:0] offset_x,offset_y; //initializing varibles for the circle
     logic signed [11:0] crit;
     logic [2:0] octant;
     logic readvals=1'b0;

     logic signed [7:0] offset_x_sign, offset_y_sign; //signed vairbles to check states

     assign offset_x_sign = offset_x; //assign statments to give the if statment values
     assign offset_y_sign = offset_y;

     always_ff @( posedge clk ) begin

          if (!rst_n) begin //reset values to 0
               vga_x<=8'd0;
               vga_y<=7'd0;
               offset_x<=8'd0;
               offset_y<=8'd0;
               crit<=12'd0;
               vga_plot<=1'd0;
               done<=1'd0;
               vga_colour<=3'd0;
               readvals<=1'b0;
               octant<=3'd0;
          end

          else if (!start) begin //default values for start signal
               vga_x<=8'd0;
               vga_y<=7'd0;
               offset_x<=8'd0;
               offset_y<=8'd0;
               crit<=12'd0;
               vga_plot<=1'd0;
               done<=1'd0;
               vga_colour<=3'd0;
               readvals<=1'b0;
               octant<=3'd0;
          end
          else if (!readvals) begin//read the values given to the circut
               offset_y <= 0;
               offset_x <= radius;
               crit <= 1 - radius;
               vga_colour<= colour;
               readvals<=1'b1;
          end
          else if (offset_y <= offset_x) begin //state transition logic to deicde whcih octant gets drawn into

               if (octant == 3'd0 && 
               centre_x + offset_x >= 0 && centre_x + offset_x < 160 && 
               centre_y + offset_y >= 0 && centre_y + offset_y < 120 &&
               centre_x + offset_x_sign < x_max && centre_x + offset_x_sign > x_min &&
               centre_y + offset_y_sign < y_max && centre_y + offset_y_sign > y_min ) begin
                    vga_x <= centre_x + offset_x;
                    vga_y <= centre_y + offset_y;
                    octant <= 3'd1;
                    vga_plot <= 1'b1;
               end
               else if (octant <= 3'd1 && 
               centre_x + offset_y >= 0 && centre_x + offset_y < 160 && 
               centre_y + offset_x >= 0 && centre_y + offset_x < 120 &&
               centre_x + offset_y_sign < x_max && centre_x + offset_y_sign > x_min &&
               centre_y + offset_x_sign < y_max && centre_y + offset_x_sign > y_min) begin
                    vga_x <= centre_x + offset_y;
                    vga_y <= centre_y + offset_x;
                    octant <= 3'd2;
                    vga_plot <= 1'b1;
               end
               else if (octant <= 3'd2 && 
               centre_x - offset_y >= 0 && centre_x - offset_y < 160 && 
               centre_y + offset_x >= 0 && centre_y + offset_x < 120 &&
               centre_x - offset_y_sign < x_max && centre_x - offset_y_sign > x_min &&
               centre_y + offset_x_sign < y_max && centre_y + offset_x_sign > y_min) begin
                    vga_x <= centre_x - offset_y;
                    vga_y <= centre_y + offset_x;
                    octant <= 3'd3;
                    vga_plot <= 1'b1;
               end
               else if (octant <= 3'd3 && 
               centre_x - offset_x >= 0 && centre_x - offset_x < 160 && 
               centre_y + offset_y >= 0 && centre_y + offset_y < 120 &&
               centre_x - offset_x_sign < x_max && centre_x - offset_x_sign > x_min &&
               centre_y + offset_y_sign < y_max && centre_y + offset_y_sign > y_min) begin
                    vga_x <= centre_x - offset_x;
                    vga_y <= centre_y + offset_y;
                    octant <= 3'd4;
                    vga_plot <= 1'b1;
               end
               else if (octant <= 3'd4 && 
               centre_x - offset_x >= 0 && centre_x - offset_x < 160 && 
               centre_y - offset_y >= 0 && centre_y - offset_y < 120 &&
               centre_x - offset_x_sign < x_max && centre_x - offset_x_sign > x_min &&
               centre_y - offset_y_sign < y_max && centre_y - offset_y_sign > y_min) begin
                    vga_x <= centre_x - offset_x;
                    vga_y <= centre_y - offset_y;
                    octant <= 3'd5;
                    vga_plot <= 1'b1;
               end
               else if (octant <= 3'd5 && 
               centre_x - offset_y >= 0 && centre_x - offset_y < 160 && 
               centre_y - offset_x >= 0 && centre_y - offset_x < 120 &&
               centre_x - offset_y_sign < x_max && centre_x - offset_y_sign > x_min &&
               centre_y - offset_x_sign < y_max && centre_y - offset_x_sign > y_min) begin
                    vga_x <= centre_x - offset_y;
                    vga_y <= centre_y - offset_x;
                    octant <= 3'd6;
                    vga_plot <= 1'b1;
               end
               else if (octant <= 3'd6 && 
               centre_x + offset_y >= 0 && centre_x + offset_y < 160 && 
               centre_y - offset_x >= 0 && centre_y - offset_x < 120 &&
               centre_x + offset_y_sign < x_max && centre_x + offset_y_sign > x_min &&
               centre_y - offset_x_sign < y_max && centre_y - offset_x_sign > y_min) begin
                    vga_x <= centre_x + offset_y;
                    vga_y <= centre_y - offset_x;
                    octant <= 3'd7;
                    vga_plot <= 1'b1;
               end
               else if (octant <= 3'd7 && 
               centre_x + offset_x >= 0 && centre_x + offset_x < 160 && 
               centre_y - offset_y >= 0 && centre_y - offset_y <  120 &&
               centre_x + offset_x_sign < x_max && centre_x + offset_x_sign > x_min &&
               centre_y - offset_y_sign < y_max && centre_y - offset_y_sign > y_min) begin
                    vga_x <= centre_x + offset_x;
                    vga_y <= centre_y - offset_y;
                    octant <= 3'd0;
                    vga_plot <= 1'b1;
                    offset_y<=offset_y+1;
                    if (crit<=0) begin //computes the crit values for the cirlce
                         crit<=crit+(2*offset_y)+1;
                    end 
                    else begin
                         offset_x<=offset_x-1;
                         crit<=crit+(2*(offset_y-offset_x))+1;
                    end
               end
               else begin
                    octant <= 3'd0;
                    vga_plot <= 1'b0;
                    offset_y<=offset_y+1;
                    if (crit<=0) begin
                         crit<=crit+(2*offset_y)+1;
                    end 
                    else begin
                         offset_x<=offset_x-1;
                         crit<=crit+(2*(offset_y-offset_x))+1;
                    end
               end 
               
          end else begin
               done<=1'b1;
               vga_x<=8'd0;
               vga_y<=7'd0;
               vga_plot<=1'b0;
               vga_colour<=3'd0;
          end
     end
endmodule
