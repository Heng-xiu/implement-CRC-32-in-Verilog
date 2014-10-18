//模組 CRC-16-test 
//模組功能:該模組是 crc16 校驗碼串列編碼電路, 
//該編碼電路可將串列輸入的資料進行編碼 
module CRC_16_serial_test; 
reg clk; 
reg rst; 
reg load; 
reg d_finish; 
reg crc_in; 
wire crc_out;//線網型資料,1bit 
parameter clk_period = 40; //clk 週期為 40ns 
initial //初始化相關阜值
begin 
 #clk_period clk = 1; 
 #clk_period rst = 1; 
 #clk_period rst = 0; 
 #clk_period crc_in = 1; //輸入待編碼資料
 #clk_period load = 1; 
 #clk_period load = 0; 
 #clk_period d_finish = 0; 
 #(80*clk_period) d_finish = 1; 
 #clk_period d_finish = 0; 
end 
always #(clk_period/2) clk = ~clk; //每 20ns 換電位
always #(2*clk_period) crc_in = ~crc_in;//每 80ns 更換待編碼字輸入電位 

//調用串列編碼模組
CRC_16_serial 
u1(.clk(clk), .rst(rst), .load(load), .d_finish(d_finish), .crc_in(crc_in), .crc_out(crc_out)); 

endmodule 
