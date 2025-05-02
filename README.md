# RISCV MYTH course
The “RISC-V based MYTH (Microprocessor for You in Thirty Hours)” workshop provides a structured introduction to RISC-V architecture, covering software-to-hardware concepts through hands-on labs. Participants begin with C programming, GCC compilation, and Spike simulation before progressing to number systems and assembly programming. The workshop delves into combinational and sequential logic, pipeline implementation, and microarchitecture of a single-cycle RISC-V CPU. Labs include instruction decoding, register file operations, ALU implementation, and control flow hazards. The final stages focus on load-store instructions, memory management, and CPU testbench development, offering comprehensive learning experience in microprocessor design and verification.
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
**1. Sinmple c program for adding numbers between 1 to n**

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
   
Then you will see the output results


