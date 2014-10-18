//模組的宣告,CRC_16_serial 
//模組功能:該模組是 crc-16 校驗碼的編碼電路,該電路採用串列線性移位暫存器
module CRC_16_serial(clk,rst,load,d_finish,crc_in,crc_out); 
input clk; //輸入信號
input rst; //重設信號
input load; //開始編碼信號
input d_finish; //編碼結束信號
input crc_in; //待編碼字輸入
output crc_out; //編碼後碼字輸出
reg crc_out; //碼字輸出暫存器,1bit 
reg [15:0] crc_reg; //線性移位暫存器,16bit 
reg [1:0] state; //狀態暫存器,2bit 
reg [4:0] count; //計數暫存器,5bit 
parameter idle = 2'b00; //等待狀態
parameter compute = 2'b01;//計算狀態
parameter finish = 2'b10; //計算結束狀態
always@(posedge clk) //在每次 clk 為正緣觸發時執行
begin //可看成 c 語言裡的上括弧,end 則可看成下括弧
case(state) //以 state 來選擇 case 
 idle:begin //是等待狀態
 if(load) //load 信號有效進入 compute 狀態
 state <= compute; 
 else 
 state <= idle; 
 end 
 compute:begin //d_finish 信號有效進入 finish 狀態
 if(d_finish) 
 state <= finish; 
 else 
 state <= compute; 
 end 
 finish:begin //判斷是否 16 個暫存器中的資料都完全輸出
 if(count==16) 
 state <= idle; 
 else 
 count <= count+1; 
 end 
endcase 
end 
always@(posedge clk or negedge rst)//每當 clk 正緣觸發或是 rst 負緣觸發就執行
 if(rst) 
 begin 
 crc_reg[15:0] <= 16'b0000_0000_0000_0000;//暫存器預裝初值
 count <= 5'b0_0000; 
 state <= idle; 
 end 
 else 
 case(state) 
 idle:begin 
 crc_reg[15:0] <= 16'b0000_0000_0000_0000; 
 end 
 compute:begin 
 //產生多項式 x^16+x^15+x^2+1 
 crc_reg[0] <= crc_reg[15] ^ crc_in; 
 crc_reg[1] <= crc_reg[0]; 
 crc_reg[2] <= crc_reg[1] ^ crc_reg[15] ^ crc_in; 
 crc_reg[14:3] <= crc_reg[13:2]; 
 crc_reg[15] <= crc_reg[14] ^ crc_reg[15] ^ crc_in; 
 crc_out <= crc_in; //輸入作為輸出
 end 
 finish:begin 
 crc_out <= crc_reg[15]; //暫存器 15 作為輸出
 crc_reg[15:0] <= {crc_reg[14:0],1'b0}; //移位
 end 
 endcase 
endmodule
