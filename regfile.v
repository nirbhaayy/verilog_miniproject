module regfile (input [1:0] readreg1, readreg2, writereg,
                input [7:0] data,
                input clk, clr, regwrite,
                output [7:0] read1, read2);
        reg [7:0] registerfile [3:0];
	integer i;
		
	always @(negedge clk) begin
			if(regwrite == 1)
				registerfile[writereg] <= data;
			if(clr == 1)
			begin
				for(i = 0; i <= 3; i = i + 1)
				begin
					registerfile[i] <= 8'b0;
				end
			end
	end
	
		assign read1 = registerfile[readreg1];
		assign read2 = registerfile[readreg2];
endmodule //regfile
