# RISCV MYTH course

The “RISC-V based MYTH (Microprocessor for You in Thirty Hours)” workshop provides a structured introduction to RISC-V architecture, covering software-to-hardware concepts through hands-on labs. Participants begin with C programming, GCC compilation, and Spike simulation before progressing to number systems and assembly programming. The workshop delves into combinational and sequential logic, pipeline implementation, and microarchitecture of a single-cycle RISC-V CPU. Labs include instruction decoding, register file operations, ALU implementation, and control flow hazards. The final stages focus on load-store instructions, memory management, and CPU testbench development, offering comprehensive learning experience in microprocessor design and verification.

## What is RISV-V
RISC-V is an open-source instruction set architecture (ISA) that defines the basic operations a processor can perform. It's a "blueprint" for designing and building processors, offering a modular and extensible foundation for a wide range of applications, from embedded systems to high-performance computing.
# DAY 1
The day 1 of this course covered the introduction to the RISC-V ISA, GNU compiler, binary number systemms, unsigned 64-bit binary number system and signed 64-bit binary system.
## Binary number system 
The binary number system  contains only two number that are 0 and 1 and a bit is the digit of a binary number a group og 8 bits is called a byte and a group of 32 bits is called a word. Similarly a group of 64 bits is called a doubleword.
If a have a 2-bit binary umber the number of possible pattern for these two numbers are 00,01,10,11. Only these are the 4 combinations of a 2-binary number. The number of possiblities of minary number having `n` number of bits can be calculated by the following formula:
2^n suppose i have a 5-bit number the  number of possiblities is 2*2*2*2*2 = **32 possiblities**

![image](https://github.com/user-attachments/assets/885376eb-c80e-4624-866d-4d1fad0897bc)

### Unsigned numbers
In binary, an unsigned number is a representation of a non-negative integer, meaning it only represents positive whole numbers and zero. It doesn't have a sign bit to indicate positivity or negativity. Like 00000001 is a binary number equivalent to decimal number 1 
it does not have a sign bit to indicatw whether this number is positive or negative in its MSD (Most significant Bit).

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

This is the c code for adding numbers make a file named 1ton.c and paste this  in that file.

**Steps to run this**

1. Open the terminal and type
   
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


# Day 2
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


# Day 3

The day 3 of this course focused on basics of digital logic like logic gates, Multiplexers, Combinational logic, Sequential logic and pipe lined logic.

## logic gates

There are 3 main types of logic gates of which other more logic gates are made. These are AND, OR & NOT. The function of these gates are given below:

<img src="https://github.com/user-attachments/assets/eb13b413-24c2-4670-8a49-097678866577" alt="Example Image" width="500"/>

<img src="https://github.com/user-attachments/assets/62e7e319-83a3-4e75-b6ed-ffc409774c27" alt="Example Image" width="500"/>

<img src="https://graphicmaths.com/img/computer-science/logic/logic-gates/not-gate.png" alt="Example Image" width="500"/>






