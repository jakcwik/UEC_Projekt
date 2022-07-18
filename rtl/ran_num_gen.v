//960x704
module ran_num_gen(
    input             clk,
    input             rst,
    output reg [9:0] hor_data,
	output reg [9:0] ver_data
    );

   reg [9:0] hor_data_next;
   reg [8:0] ver_data_next;
   
   always@* begin
      hor_data_next = hor_data;
      repeat(10) begin
         hor_data_next = {(hor_data_next[9]^hor_data_next[1]), hor_data_next[9:1]};
      end
   end

   always@(posedge clk) begin
      if(rst)
         hor_data <= 10'b1111111111;
	  else if(hor_data_next>960)
		 hor_data <= 450;
      else
         hor_data <= hor_data_next;
   end
   
   always@* begin
      ver_data_next = ver_data;
      repeat(9) begin
         ver_data_next = {(ver_data_next[8]^ver_data_next[1]), ver_data_next[8:1]};
      end
   end

   always@(posedge clk) begin
      if(rst)
         ver_data <= 10'b0111111111;
      else
         ver_data <= ver_data_next + 96;
   end

endmodule