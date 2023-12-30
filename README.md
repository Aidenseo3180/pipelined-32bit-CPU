# pipelined-32bit-CPU
## About  

| CPU Datapath                        | Vivado Module Datapath              |
| ----------------------------------- | ----------------------------------- |
| ![cpu_diagram](https://github.com/Aidenseo3180/pipelined-32bit-CPU/assets/66958352/ea016db5-b184-4da9-94eb-c00ae96e7b55) | ![image_cp (1)](https://github.com/Aidenseo3180/pipelined-32bit-CPU/assets/66958352/0a561836-3ace-45c8-8d4c-1999c5dc8e99) |  

This is an implementation of a Pipelined 32bit CPU using VHDL hardware language in Vivado 2018.3  
You must manually map out the block diagram to connect components by following the Vivado Module Datapath Image attached above.  

It is capable of running 21 MIPS assembly commands including JR, JUMP, LW, SW, etc.  
The reliability of the implementation has been tested using MARS program to generate assmebly codes, and tcl/vhd files to automate test cases.  
