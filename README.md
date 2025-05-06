# RISC-V Based MYTH course

The “RISC-V based MYTH (Microprocessor for You in Thirty Hours)” workshop provides a structured introduction to RISC-V architecture, covering software-to-hardware concepts through hands-on labs. Participants begin with C programming, GCC compilation, and Spike simulation before progressing to number systems and assembly programming. The workshop delves into combinational and sequential logic, pipeline implementation, and microarchitecture of a single-cycle RISC-V CPU. Labs include instruction decoding, register file operations, ALU implementation, and control flow hazards. The final stages focus on load-store instructions, memory management, and CPU testbench development, offering comprehensive learning experience in microprocessor design and verification.

<!-- Card example -->
<div align="center">
  <a href="https://www.vlsisystemdesign.com/riscv-based-myth/" target="_blank">
    <img src="https://www.vlsisystemdesign.com/wp-content/uploads/2025/01/1RISC-V%20based-2048x1024.png?text=Special+Offer+%24Price" alt="Clickable Card" style="border-radius:10px; width:70%; max-width600px;" />
  </a>
  <p><strong>Price: $25</strong></p>
</div>

## What is RISC-V
RISC-V is an open-source instruction set architecture (ISA) that defines the basic operations a processor can perform. It's a "blueprint" for designing and building processors, offering a modular and extensible foundation for a wide range of applications, from embedded systems to high-performance computing.

> [!NOTE]
> Before moving on, you should have to know that all the tools like Linux, Spike, GNU compiler etc. are given separately to the student by the facilator after buying this course.

# Summary of this workshop
<details>
  <summary>Day 1: Introduction to RISC-V ISA and GNU compiler toolchain</summary>

  


The day 1 of this course covered the introduction to the RISC-V ISA, GNU compiler, binary number systemms, unsigned 64-bit binary number system and signed 64-bit binary system.
## Binary number system 
The binary number system  contains only two numbers that are 0 and 1 and a bit is the digit of a binary number a group og 8 bits is called a byte and a group of 32 bits is called a word. Similarly a group of 64 bits is called a doubleword.
If i a have a 2-bit binary number the number of possible pattern for these two numbers are 00,01,10,11. Only these are the 4 combinations of a 2-bit binary number. The number of possiblities of binary number having `n` number of bits can be calculated by the following formula:
2^n suppose i have a 5-bit number the  number of possiblities is 2 * 2 * 2 * 2 * 2 = **32 possiblities**

![image](https://github.com/user-attachments/assets/885376eb-c80e-4624-866d-4d1fad0897bc)

### Unsigned numbers
In binary, an unsigned number is a representation of a non-negative integer, meaning it only represents positive whole numbers and zero. It doesn't have a sign bit to indicate positivity or negativity. Like 00000001 is a binary number equivalent to decimal number 1 
it does not have a sign bit to indicate whether this number is positive or negative in its MSD (Most significant Bit).

![image](https://github.com/user-attachments/assets/cfd8c53a-9025-4738-a92a-11264b30dd97)

### Signed numbers
In the binary system, a signed number representation uses the most significant bit (MSB) to indicate the sign of the number. If the MSB is 0, the number is positive; if it's 1, the number is negative. Like 10000010 is a 8-bit number  the MSB of this number is `1`
so the number will be in negative the rest of the number detemines the original value of the number which is 0.
<img src="https://github.com/user-attachments/assets/c70ff96d-93f4-4c5e-81d7-34335760ef2f" alt="Example Image" width="700"/>

## Labs for Day 1  
**1. Simple c program for adding numbers between 1 to n**

    #include <stdio.h>

    int main() {
    int i, sum = 0, n = 5;
    for (i=1; i <= n; ++i) {
    sum += i; }
    printf("Sum of numbers from 1 to %d is %d\n", n, sum);
    return 0;

    }

This is the c code for adding numbers, make a file named 1ton.c and paste this  in that file.

**Steps to run this**

1. Open the linux terminal and type
   
        gcc 1ton.c

3. And then type
  
        ./a.out
   
Then you will see the following output results

![image](https://github.com/user-attachments/assets/31b4a2ff-7d0a-46f8-b8c0-e601cfa2a2a8)

**2. Simulation of the same 1ton program but with Spike**

Run the following steps in terminal:

1. Open the terminal and type

        riscv64-unknown-elf-gcc -Ofast -mabi=lp64 -march=rv64i -o 1ton.o 1ton.c        


2. Then type

        spike pk 1ton.o
        

Then you should see the same result as:

![image](https://github.com/user-attachments/assets/8e469627-92ab-4e73-9670-6e5e4ab942c8)

</details>

******************************************************************************************************************************************************

<details>
  <summary>Day 2: Introduction to ABI and basic verification flow</summary>
	
The day2 focuses on ABI (Application Binary Interface) and the 32 registers present in the RISC V micrprocessor

## What is ABI
An Application Binary Interface (ABI) is a standard that defines the interface between compiled applications and the operating system, or between different binary modules. ABIs define the rules that compilers and assemblers must follow when generating binary code, ensuring that different code modules can be linked together and executed seamlessly.

### Why there are only 32 registers in RISC-V architecture

Let’s look at an example load doubleword instruction below, which loads data into x8 register from memory, whose base address is present in register x23 and offset is ‘16’. The way a computer sees this instruction is through a 32-bit binary pattern.

![image](https://github.com/user-attachments/assets/10ff3f1e-280b-4c0d-ad70-dafc0aa67590)

Focus on ‘rs2’ and ‘rs1’. They have 5 bits. Practically, to keep design simple, all registers in a RISC-V architecture is represented by 5-bit binary pattern. Now the calculation is easy. 5-bits to represent registers, which means total number of registers is 2^5 = 32 registers


## Labs for Day 2
**1. simulating the 1 to n adder but using ABI**

Run the following steps in the terminal:
1. Open the terminal and make a file names 1to9_custom.c
2. and type this in it
   
        #include <stdio.h>

        extern int load(int x, int y); 

        int main() {
	        int result = 0;
       	        int count = 2;
    	        result = load(0x0, count+1);
    	        printf("Sum of number from 1 to %d is %d\n", count, result); 
        }


3. Also make another file named load.S. And type this in it

        .section .text
        .global load
        .type load, @function

        load:
	        add 	a4, a0, zero //Initialize sum register a4 with 0x0
	        add 	a2, a0, a1   // store count of 10 in register a2. Register a1 is loaded with 0xa (decimal 10) from main program
	        add	a3, a0, zero // initialize intermediate sum register a3 by 0
        loop:	add 	a4, a3, a4   // Incremental addition
	        addi 	a3, a3, 1    // Increment intermediate register by 1	
	        blt 	a3, a2, loop // If a3 is less than a2, branch to label named <loop>
	        add	a0, a4, zero // Store final result to register a0 so that it can be read by main program
	        ret

4. Then open the terminal and type this after going to the folder in which you have made the two files.

        riscv64-unknown-elf-gcc -Ofast -mabi=lp64 -march=rv64i -o 1to9_custom.o 1to9_custom.c load.S

5. Then type

        spike pk 1to9_custom.o

Then you will see the following results after this:

![image](https://github.com/user-attachments/assets/43e37975-ee6d-4f8e-8bd2-844452451f75)

</details>

******************************************************************************************************************************************************

<details>
  <summary>Day 3: Digital Logic with TL-Verilog and Makerchip</summary>

The day 3 of this course focused on basics of digital logic like logic gates, Multiplexers, Combinational logic, Sequential logic, pipe lined logic and Validity.

## Logic gates

There are 3 main types of logic gates of which other more logic gates are made. These are AND, OR & NOT. The function of these gates are given below:

<img src="https://github.com/user-attachments/assets/eb13b413-24c2-4670-8a49-097678866577" alt="Example Image" width="400"/>

<img src="https://github.com/user-attachments/assets/62e7e319-83a3-4e75-b6ed-ffc409774c27" alt="Example Image" width="400"/>

<img src="https://graphicmaths.com/img/computer-science/logic/logic-gates/not-gate.png" alt="Example Image" width="400"/>


Logic gate is a fundamental building block in digital circuits, acting as a simple electronic switch or circuit that operates on binary inputs (0 or 1) to produce a binary output based on a specific logical rule. These gates implement Boolean algebra and are crucial for creating more complex digital systems like computers and other electronic devices. From these we can make more gates such as NAND,NOR,XOR and XNOR etc.

## Combinational Circuits
A combinational logic circuit is a type of digital circuit where the output at any given moment depends on the current combination of its inputs. It lacks memory, meaning the output is not influenced by the past states of the inputs. These circuits are built using logic gates like AND, OR, NOT, NAND, and NOR. 

![image](https://github.com/user-attachments/assets/58f304fc-3d8b-43f8-b22d-f287eea2537b)


## Sequential Logic

A sequential logic circuit is a digital circuit whose output depends not only on the present input but also on the past inputs and the internal state of the circuit. It incorporates memory elements, like flip-flops or latches, to store the previous state, allowing the circuit to "remember" past inputs. This contrasts with combinational logic, where the output is solely determined by the current inputs. 

![image](https://github.com/user-attachments/assets/7f393eba-f645-4cef-9997-cb261b33dae3)


## Storage elements: Flip-Flops

In digital electronics, a flip-flop is a fundamental memory circuit that can store a single bit of information (0 or 1) and can be toggled between these two states. It's like a basic switch that can be flipped on or off, retaining that state until an external signal (like a clock pulse) triggers a change. Flip-flops are bistable devices, meaning they have two stable states. They can hold a specific binary value (0 or 1) until a control signal causes them to change. 

![image](https://github.com/user-attachments/assets/606244fa-ffa0-409b-834a-b9b039a1312b)

## Pipelined logic
Pipelined logic, or pipelining, is a technique in computer architecture and digital circuit design that increases throughput by dividing a task into multiple stages and executing them in parallel.

![Screenshot (135)](https://github.com/user-attachments/assets/be938e22-7e5f-4689-aae0-85b0225f2ea8)

## Validity

Validity is the device meets the needs and requirements of its intended users and the intended use environment. In a chip there are maximum things that are not useful and sit idle in the chip, but the power still goes in them, which is a wastage of electricity. Validity fixes this problem by eliminating the non-useful gates.

## Labs for Day 3

**1. Combinational calculator**

1. Go to [Makerchip](makerchip.com) and click on launch makerchip IDE.
2. Go to editor and place the below TL-Verilog in place of //...

				$sum[31:0] = $val1[31:0] + $val2[31:0];
		   		$diff[31:0] = $val1[31:0] - $val2[31:0];
		   		$prod[31:0] = $val1[31:0] * $val2[31:0];
		   		$quot[31:0] = $val1[31:0] / $val2[31:0];
		​		$out[31:0] = $op[0] ? $sum : $op[1] ? $diff : $op[2] ? $prod : $qout ;

3. Then click on 'compile'.


![Screenshot (134)](https://github.com/user-attachments/assets/aa980a8c-4d33-465f-b675-a92030378a72)


**2. Sequential calculator**

1. Go to [Makerchip](makerchip.com) and click on launch makerchip IDE.
2. Go to editor and place the below TL-Verilog in place of //...

				$sum[31:0] = $val1[31:0] + $val2[31:0];
		   		$diff[31:0] = $val1[31:0] - $val2[31:0];
		   		$prod[31:0] = $val1[31:0] * $val2[31:0];
		   		$quot[31:0] = $val1[31:0] / $val2[31:0];
		​		$out[31:0] = $op[0] ? $sum : $op[1] ? $diff : $op[2] ? $prod : $qout ;
				$out[31:0] = $val1[31:0]

3. Then click on 'compile'.

![Screenshot (136)](https://github.com/user-attachments/assets/d09f530e-6450-4567-936f-2c601c9b9ae4)

**3. Fibonacci Sequence**

The Fibonacci Sequence is a sequence of whole numbers starting with two 1s, where each subsequent value in the sequence is the sum of the previous two values.

1. Go to [Makerchip](makerchip.com) and click on launch makerchip IDE.
2. Go to editor and place the below TL-Verilog in place of //...

			$val[15:0] = $reset ? 1 : >>1$val + >>2$val;

3. Then click on 'compile'.

![Screenshot (138)](https://github.com/user-attachments/assets/e78b2a90-f684-4cf0-89a4-3a34da80f901)

**4. Pythagorean Theorem Pipeline**

1. Go to [Makerchip](makerchip.com) and click on launch makerchip IDE.
2. Go to editor and place the below TL-Verilog in place of //...

			 |calc
     			 @0
      			   $valid = & $rand_valid[1:0];  // Valid with 1/4 probability
                                      			 // (& over two random bits).
   
  			 // DUT (Design Under Test)
   			|calc
      			?$valid
        			 // Pythagoras's Theorem
        			 @1
            			$aa_sq[7:0] = $aa[3:0] ** 2;
           			 $bb_sq[7:0] = $bb[3:0] ** 2;
        			 @2
            			$cc_sq[8:0] = $aa_sq + $bb_sq;
        			 @3
            			$cc[4:0] = sqrt($cc_sq);
	    
3. Then click on 'compile'.

![Screenshot (137)](https://github.com/user-attachments/assets/2b9fbb2d-fe3f-4922-be3b-f32eb2ad1404)

**4. Final claculator with vaidity and memory**

1. Go to [Makerchip](makerchip.com) and click on launch makerchip IDE.
2. Go to editor and place the below TL-Verilog in place of //...

		|calc
    		  @0
      		   $reset = *reset;
     		 @1
         		$valid[0:0] = $reset ? '0 : >>1$valid + 1;
         		$valid_or_reset = $valid || $reset;
         		$val2[31:0] = $rand2;
        		 $val1[31:0] = >>2$out;
         
     		 ?$valid_or_reset
         		@1
            		$sum[31:0] = $val2[31:0] + $val1[31:0];
            		$diff[31:0] = $val2[31:0] - $val1[31:0];
   			 $prod[31:0] = $val2[31:0] * $val1[31:0];
            		$div[31:0] = $val2[31:0] / $val1[31:0];

      		@2
      		?$valid_or_reset
         		@2
           		 $out[31:0] = $reset ? '0:
                  		    $op[2:0] == 0 ? $sum :
                   		   $op[2:0] == 1 ? $diff :
                      		$op[2:0] == 2 ? $prod :
                      		$op[2:0] == 3 ? $div :
                      		$op[2:0] == 4 ? >>2$mem : >>2$out;
            		$mem[31:0] = $reset ? '0:
                      		$op[2:0] == 5 ? $val1:
                      		>>2$mem;
	    
3. Then click on 'compile'.

![Screenshot (139)](https://github.com/Ahtesham18112011/RISCV_MYTH/blob/7cfbfd9ad77dc7acaffa36883aa0f4d69d39f837/LICENSE)

</details>

******************************************************************************************************************************************************

<details>
  <summary>Day 4: Basic RISC-V CPU microarchitecture</summary>
	
  This day focuses on the basic single cycled RISC-V CPU microarchitecture.
  ## Basic structure of RISC-V CPU microarchitecture
  ![Screenshot (149)](https://github.com/user-attachments/assets/ce7e4e24-1d8a-408d-9f78-ab4e322cfd9c)

#### PC MUX
In RISC-V, the PC MUX (Program Counter Multiplexer) is a circuit that selects the next instruction to be executed based on various factors, including the type of instruction.

#### Rd Imem
In RISC-V architecture, IMEM Rd refers to the Read operation from the Instruction Memory (IMEM). This operation fetches the instruction from memory, given an address provided by the Program Counter (PC), and sends it to the processor.

#### Decoder
In RISC-V, the decoder is a crucial component that translates binary instruction codes into the control signals needed for the processor to execute the instruction.

#### Read/Write register
These are the register in RISC-V for read and write memory. Their are 32 registers like this in a RISC-V microachitecture.

#### ALU 
ALU stands for Arithmetic Logic Unit, a fundamental component of a computer's central processing unit (CPU). It's responsible for performing arithmetic operations (like addition, subtraction, multiplication, division) and logical operations (like AND, OR, NOT, XOR) on binary data.

## Labs for day 4

**1. Fetch and Decode**
1. Go to [Makerchip](makerchip.com) and click on launch makerchip IDE.
2. Go to editor and place the below TL-Verilog in place of //...

 		  |cpu
     		 @0
       		  $reset = *reset;
       		  $pc[31:0] = >>1$reset ? '0 :  (>>1$pc + 32'd4);
         
     		 @1
     		    $imem_rd_en = ! $reset;
    		     $imem_rd_addr[M4_IMEM_INDEX_CNT - 1:0] = $pc[M4_IMEM_INDEX_CNT + 1:2];
         
         
         $instr[31:0] = $imem_rd_data[31:0];
         
         $is_i_instr = $instr[6:2] ==? 5'b0000x ||
                       $instr[6:2] ==? 5'b001x0 ||
                       $instr[6:2] ==? 5'b11001 ||
                       $instr[6:2] ==? 5'b00100;
         
         $is_r_instr = $instr[6:2] ==? 5'b01011 ||
                       $instr[6:2] ==? 5'b011x0 ||
                       $instr[6:2] ==? 5'b10100;
         
         $is_s_instr = $instr[6:2] ==? 5'b0100x;
         
         $is_b_instr = $instr[6:2] ==? 5'b11000;
         
         $is_j_instr = $instr[6:2] ==? 5'b11011;
         
         $is_u_instr = $instr[6:2] ==? 5'b0x101;
         
         $imm[31:0] = $is_i_instr ? { {21{$instr[31]}}, $instr[30:20] } :
                      $is_s_instr ? { {21{$instr[31]}}, $instr[30:25], $instr[11:7] } :
                      $is_b_instr ? { {20{$instr[31]}}, $instr[7], $instr[31:25], $instr[11:8], 1'b0 } :
                      $is_u_instr ? { $instr[31:12] , 12'b0 } : 
                      $is_j_instr ? { {12{$instr[31]}}, $instr[19:12], $instr[20], $instr[30:21], 1'b0 } :
                      32'b0 ;
         
         
         $rs1[4:0] = $instr[19:15];
         $rs2[4:0] = $instr[24:20];
         $rd[4:0] = $instr[11:7];
         $funct7[6:0] = $instr[31:25];
         $funct3[2:0] = $instr[14:12];
         $opcode[6:0] = $instr[6:0];
         
         
         
         $rs1_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr  ;
         ?$rs1_valid
            $rs1[4:0] = $instr[19:15];
         
         
         $rs2_valid = $is_r_instr || $is_s_instr || $is_b_instr ;
         ?$rs2_valid
            $rs2[4:0] = $instr[24:20];
         
         
         $rd_valid = $is_r_instr || $is_i_instr || $is_u_instr || $is_j_instr;
         ?$rd_valid
            $rd[4:0] = $instr[11:7];
         
         $funct7_valid = $is_r_instr ;
         ?$funct7_valid
            $funct7[6:0] = $instr[31:25];
         
         $funct3_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
         ?$funct3_valid
            $funct3[2:0] = $instr[14:12];
         
         $opcode_valid = $is_i_instr ||  $is_r_instr || $is_s_instr || $is_b_instr || $is_j_instr || $is_u_instr;
         ?$opcode_valid
            $opcode[6:0] = $instr[6:0];
         
         
         $dec_bits[10:0] = { $funct7[5], $funct3, $opcode };
         
         
         $is_add = $dec_bits ==? 11'b0_000_0110011;
         $is_addi = $dec_bits ==? 11'bx_000_0010011;
         $is_beq = $dec_bits ==? 11'bx_000_1100011;
         $is_bne = $dec_bits ==? 11'bx_001_1100011;
         $is_blt = $dec_bits ==? 11'bx_100_1100011;
         $is_bge = $dec_bits ==? 11'bx_101_1100011;
         $is_bltu = $dec_bits ==? 11'bx_110_1100011;
         $is_bgeu = $dec_bits ==? 11'bx_111_1100011;


	    
4. Then click on 'compile'.

![Screenshot (150)](https://github.com/user-attachments/assets/46f3d917-7555-44a8-99c7-a53ce138d093)

This TL-Verilog is used for making a basic RISC-V CPU architecture but till the decoder.

**2. Simple RISC-V based CPU which performs addition of number 1 to 9**

1. Go to [Makerchip](makerchip.com) and click on launch makerchip IDE.
2. Go to editor and place the below TL-Verilog in place of //...

			


		|cpu
     		 @0
        		 $reset = *reset;
         
        		 $pc[31:0] = (>>1$reset) ? 32'd0 : (>>1$pc + 32'd4);
         
        
     			 @1
   		
         		$imem_rd_addr[M4_IMEM_INDEX_CNT - 1:0] = $pc[M4_IMEM_INDEX_CNT + 1:2];
         
         		$imem_rd_en = !$reset;
         
        		 $instr[31:0] = $imem_rd_data[31:0];
         
         
         
         		$is_i_instr = $instr[6:2] ==? 5'b0000x ||
                       $instr[6:2] ==? 5'b001x0 ||
                       $instr[6:2] ==? 5'b11001 ||
                       $instr[6:2] ==? 5'b00100;
         
   		  $is_r_instr = $instr[6:2] ==? 5'b01011 ||
                       $instr[6:2] ==? 5'b011x0 ||
                       $instr[6:2] ==? 5'b10100;
         
        		 $is_s_instr = $instr[6:2] ==? 5'b0100x;
         
        		 $is_b_instr = $instr[6:2] ==? 5'b11000;
         
        		 $is_j_instr = $instr[6:2] ==? 5'b11011;
         
      		   $is_u_instr = $instr[6:2] ==? 5'b0x101;
         
         
         		$imm[31:0] = $is_i_instr ? { {21{$instr[31]}}, $instr[30:20] } :
                      $is_s_instr ? { {21{$instr[31]}}, $instr[30:25], $instr[11:7] } :
                      $is_b_instr ? { {20{$instr[31]}}, $instr[7], $instr[31:25], $instr[11:8], 1'b0 } :
                      $is_u_instr ? { $instr[31:12] , 12'b0 } : 
                      $is_j_instr ? { {12{$instr[31]}}, $instr[19:12], $instr[20], $instr[30:21], 1'b0 } :
                      32'b0 ;
         
         
   
        $rs1_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr  ;
         ?$rs1_valid
            $rs1[4:0] = $instr[19:15];
         
         
         $rs2_valid = $is_r_instr || $is_s_instr || $is_b_instr ;
         ?$rs2_valid
            $rs2[4:0] = $instr[24:20];
         
         
         $rd_valid = $is_r_instr || $is_i_instr || $is_u_instr || $is_j_instr;
         ?$rd_valid
            $rd[4:0] = $instr[11:7];
         
         $funct7_valid = $is_r_instr ;
         ?$funct7_valid
            $funct7[6:0] = $instr[31:25];
         
         $funct3_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
         ?$funct3_valid
            $funct3[2:0] = $instr[14:12];
         
         $opcode_valid = $is_i_instr ||  $is_r_instr || $is_s_instr || $is_b_instr || $is_j_instr || $is_u_instr;
         ?$opcode_valid
            $opcode[6:0] = $instr[6:0];

         
        
         
         
         
         $dec_bits[10:0] = { $funct7[5], $funct3, $opcode };
         
         
         $is_add = $dec_bits == 11'b0_000_0110011;
         $is_addi = $dec_bits ==? 11'bx_000_0010011;
         
         
         $is_beq = $dec_bits ==? 11'bx_000_1100011;
         $is_bne = $dec_bits ==? 11'bx_001_1100011;
         $is_blt = $dec_bits ==? 11'bx_100_1100011;
         $is_bge = $dec_bits ==? 11'bx_101_1100011;
         $is_bltu = $dec_bits ==? 11'bx_110_1100011;
         $is_bgeu = $dec_bits ==? 11'bx_111_1100011;
         
         //read register file 
         
         
         
         $rf_wr_en = $rd_valid;
         $rf_wr_index[4:0] = $rd;
         
         
         $rf_rd_en1 = $rs1_valid;
         $rf_rd_index1[4:0] = $rs1;
         $rf_rd_en2 = $rs2_valid;
         $rf_rd_index2[4:0] = $rs2;
         
         
         $src1_value[31:0] = $rf_rd_data1;
         $src2_value[31:0] = $rf_rd_data2;
         
         //ALU 
         
         $result[31:0] = $is_addi ? ($src1_value + $imm) :
                         $is_add ? ($src1_value + $src2_value) :
                         32'bx;
         
         
         
         $taken_br = (! $is_b_instr) ? 1'b0 :
                      $is_beq ? ($src1_value == $src2_value) :
                      $is_bne ? ($src1_value != $src2_value) :
                      $is_blt ? ( ($src1_value < $src2_value) ^ ($src1_value[31] != $src2_value[31]) ) :
                      $is_bge ? ( ($src1_value >= $src2_value) ^ ($src1_value[31] != $src2_value[31]) ) :
                      $is_bltu ? ($src1_value < $src2_value) :
                      $is_bgeu ? ($src1_value >= $src2_value) :
                      1'b0;
         
         
         $br_tgt_pc[31:0] = $pc + $imm;

3. Then click on 'compile'


![Screenshot (151)](https://github.com/user-attachments/assets/f9707702-e856-4041-b3a6-95cc12ad3505)


## Visualisation Video



https://github.com/user-attachments/assets/f43f9e7d-f6ca-478c-8c7f-6f747643a2b1

</details>

******************************************************************************************************************************************************


## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

