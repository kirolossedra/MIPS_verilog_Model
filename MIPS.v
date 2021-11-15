module registerfile(Read1,Read2,WriteReg, 
WriteData, RegWrite, Data1,Data2,Clock);
input [4:0] Read1,Read2,WriteReg; 
input [31:0] WriteData;
input RegWrite, Clock;
output[31:0] Data1, Data2;
reg[ 31:0] RF [31:0];
assign Data1 = RF[Read1];
assign Data2 = RF[Read2];
always @(posedge Clock)
if(RegWrite) RF[WriteReg] = WriteData;
endmodule





module CPU (clock,tree);
input clock;
reg[31:0] PC, Regs[0:31], IMemory[0:1023],DMemory[0:1023], IR,ALUOut;
wire [4:0] rs, rt;
output tree;
reg tree;


wire [31:0] Ain, Bin;
wire [5:0] op;
assign rs = IR[25:21];
assign rt = IR[20:16];
assign rd = IR[15:11];
assign shift = IR[10:6];

assign op = IR[31:26];
registerfile rf(rs,rt,rd,ALUout,1,Ain,Bin,clock); 

initial begin
PC = 0;
end
always @ (posedge clock)
begin
IR <= IMemory[PC>>2];
   
PC <= PC + 4; 




case( IR[31:26] )  // Check for Format 0 For R format
0: 
case (IR[5:0])
0  : ALUOut <= Ain<<shift; 
2 :  ALUOut <= Ain >> shift;
32 : ALUOut <= Ain + Bin; 
37 : ALUOut <= Ain | Bin; 
34 : ALUOut <= Ain - Bin;
38 : ALUOut <= Ain ^ Bin;
36 : ALUOut <= Ain & Bin;
39 : ALUOut <= ~(Ain |Bin);



endcase 
8 :  ALUOut <= Bin+ IR[15:0];
12 : ALUOut <= Bin&IR[15:0];
13 : ALUOut <= Bin | IR[15:0];
14 :  ALUOut <= Bin ^ IR[15:0];	
35 : IR[20:16] <= DMemory [ IR[25:21] +  IR[15:0] ];
43 : DMemory [ IR[25:21] +  IR[15:0] ] <= IR[20:16];
endcase


end
endmodule
module clock_Gen(clock);
    //i/o
    output reg clock;
    
    
    initial clock = 0;  //1)
    always #5 clock = ~clock; //2)

endmodule

module CPU_tb;
wire clock;

clock_Gen c1(clock);

CPU obj(clock);



endmodule

