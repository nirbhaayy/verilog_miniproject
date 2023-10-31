module programmem(input [7:0] pgmaddr, output [7:0] pgmdata);
  reg [7:0] pmemory[255:0];
  assign pgmdata=pmemory[pgmaddr];

  initial
    begin
      pmemory[2]=8'hc0;
		pmemory[3]=8'd40;
		pmemory[4]=8'h20;
		pmemory[5]=8'h9f; // NOP
		pmemory[254]=8'h90; // Interrupt vector
		pmemory[255]=8'd40;
		pmemory[40]=8'hb0; //RTS
    end
endmodule

module usermem(input clk, input [7:0] uaddr, inout [7:0] udata, input rw);
  reg [7:0] umemory[255:0];
  assign udata=rw?8'bz:umemory[uaddr];
  always @(negedge clk) 
    if (rw==1) umemory[uaddr]<=udata;
  
  initial
   begin
     umemory[0]=8'h00;
     umemory[1]=8'h33;
     umemory[2]=8'hAA;
   end
endmodule

module cpu_tb;
        reg clk, reset, interrupt;
  wire [7:0] datamem_data, usermem_data, datamem_address, usermem_address, idata;
	wire rw;
  programmem pgm(datamem_address,idata);
  usermem umem(clk, usermem_address,usermem_data,rw);
  cpu dut0(clk, reset, interrupt, idata, usermem_data, 
                 datamem_address, usermem_address, rw);
        initial
        begin
          $display("NopCPU testbench. All waveforms will be dumped to the dump.vcd file.");
          $dumpfile("waves.vcd");
                $dumpvars(0, dut0);
                $monitor("Clock: %b Reset: %b \nAddress (Datamem): %h Address: (Usermem): %h)\n Data (Datamem): %h Data (Usermem): %h R/W: %b\n Time: %d\n",clk,reset,datamem_address,usermem_address,datamem_data,usermem_data,rw,$time);
		clk = 1'b0;
		reset = 1'b1;
		interrupt = 1'b0;
		repeat(4) #10 clk = !clk;
		reset = 1'b0;
        end
        always
                #1 clk = !clk;
	/* Comment this out to test interrupts: */
	/*always
	begin
		#25 interrupt = ~interrupt;
		#2 interrupt = ~interrupt;
	end*/
endmodule
