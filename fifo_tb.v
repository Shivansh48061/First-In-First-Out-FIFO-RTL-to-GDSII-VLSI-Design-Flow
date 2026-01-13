module fifo_tb();
localparam data_width=8;
localparam data_length=16;
reg clk;
reg rst_n;
reg wr_en;
reg rd_en;
reg[data_width-1:0] din;
wire[data_width-1:0]dout;
wire empty;
wire full;
fifo #(.data_width(data_width),.data_length(data_length)) dut(.clk(clk),.rst_n(rst_n),.wr_en(wr_en),.rd_en(rd_en),.din(din),.dout(dout),.empty(empty),.full(full));
initial
begin
clk=0;
forever #5 clk=~clk;
end
integer i;
initial
begin
rst_n=0;
wr_en=0;
rd_en=0;
din=0;
#20;
rst_n=1;
#10;
$display("Writing to FIFO");
for(i=0;i<10;i=i+1)
begin
@(posedge clk);
if(!full)
begin
wr_en<=1;
din<=i;
$display($time,"ns:WRITE din=%0d,full=%b,empty=%b",din,full,empty);
end 
else
begin
wr_en<=0;
$display($time,"ns:fifo full cannot write");
end
end
@(posedge clk);
wr_en<=0;
din<=0;
#20;
$display("reading from FIFO");
for(i=1;i<10;i=i+1)
begin
@(posedge clk);
if(!empty)
begin
rd_en<=1;
$display($time,"ns:READ dout=%0d,full=%b,empty=%b",dout,full,empty);
end
else
begin
rd_en<=0;
$display($time,"ns:fifo is empty cannot read it!");
end
end
@(posedge clk);
rd_en<=0;
#50;
$display("simulation ends");
$stop;
end
endmodule

