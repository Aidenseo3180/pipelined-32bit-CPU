library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Datapath is
    Port (
        SHAMT_Selector : in std_logic;
        PCEn        : in std_logic;
        PCSource    : in std_logic_vector(1 downto 0);
        ALUSrcB     : in std_logic_vector(2 downto 0);    -- enable for B mux
        ALUSrcA     : in std_logic_vector(1 downto 0);    -- enable for A mux
        RegWrite    : in std_logic;
        RegDst      : in std_logic;
        IorD        : in std_logic;
        MemtoReg    : in std_logic_vector(2 downto 0);
        IRWrite     : in std_logic;
        ALUOpcode   : in std_logic_vector(3 downto 0);    -- opcode for ALU to add/sub/etc. You get it from controller
        AEn         : in std_logic;    -- for A register
        BEn         : in std_logic;    -- for B register
        ALUOutEn    : in std_logic;    -- for ALU out
        MemoryEn    : in std_logic;    -- for memory data register, get from control unit
        
        mult_high_en : in std_logic;    -- enables called after multu is done
        mult_low_en : in std_logic;
        
        CLK             : in std_logic;
        RST             : in std_logic;
        multiplier_reset: in std_logic;
        MemoryDataIn    : in std_logic_vector(31 downto 0);     -- Data that goes into instruction register
        MemoryAddress   : out std_logic_vector(31 downto 0);    -- address from PC
        MemoryDataOut   : out std_logic_vector(31 downto 0);    -- Data that you get from ALUOut
        -- MemWrite        : out std_logic;                         -- memWrite that goes into CPU control unit
        Opcode          : out std_logic_vector(5 downto 0);
        zerobit         : out std_logic;    -- from ALU to CPU control unit
        --Instruction_lsb : out std_logic_vector(5 downto 0); -- goes into CPU controller
        
        done : out std_logic   --done signal from multipler, goes into control unit
    );
end Datapath;

architecture Behavioral of Datapath is

component register_template
    Port(
        inputValue  : in std_logic_vector(31 downto 0);
        CLK         : in std_logic;
        RST         : in std_logic;
        EN          : in std_logic;
        outputValue : out std_logic_vector(31 downto 0)
    );
end component;

component MUX_2input
   Generic(
        n : integer :=32
    );
    Port (
        dataIn_1    : in std_logic_vector(n-1 downto 0);
        dataIn_2    : in std_logic_vector(n-1 downto 0);
        selector    : in std_logic;
        dataOut     : out std_logic_vector(n-1 downto 0)
    );
end component;

component MUX_2input_2
    Generic(
        n : integer :=5
    );
    Port (
        dataIn_1    : in std_logic_vector(n-1 downto 0);
        dataIn_2    : in std_logic_vector(n-1 downto 0);
        selector    : in std_logic;
        dataOut     : out std_logic_vector(n-1 downto 0)
    );
end component;

component MUX_3input
     Generic(
        n : integer := 32
    );
    Port (
        dataIn_1    : in std_logic_vector(n-1 downto 0);
        dataIn_2    : in std_logic_vector(n-1 downto 0);
        dataIn_3    : in std_logic_vector(n-1 downto 0);
        selector    : in std_logic_vector(1 downto 0);
        dataOut     : out std_logic_vector(n-1 downto 0)
    );
 end component;
 
 component MUX_4input
    Generic(
        n : integer := 32
    );
    Port (
        dataIn_1    : in std_logic_vector(n-1 downto 0);
        dataIn_2    : in std_logic_vector(n-1 downto 0);
        dataIn_3    : in std_logic_vector(n-1 downto 0);
        dataIn_4    : in std_logic_vector(n-1 downto 0);
        selector    : in std_logic_vector(1 downto 0);
        dataOut     : out std_logic_vector(n-1 downto 0)
    );
end component;

component MUX_5input
    Generic(
        n : integer := 32
    );
    Port (
        dataIn_1    : in std_logic_vector(n-1 downto 0);
        dataIn_2    : in std_logic_vector(n-1 downto 0);
        dataIn_3    : in std_logic_vector(n-1 downto 0);
        dataIn_4    : in std_logic_vector(n-1 downto 0);
        dataIn_5    : in std_logic_vector(n-1 downto 0);
        selector    : in std_logic_vector(2 downto 0);
        dataOut     : out std_logic_vector(n-1 downto 0)
    );
end component;

component MUX_7input
    Generic(
        n : integer := 32
    );
    Port (
        dataIn_1    : in std_logic_vector(n-1 downto 0);
        dataIn_2    : in std_logic_vector(n-1 downto 0);
        dataIn_3    : in std_logic_vector(n-1 downto 0);
        dataIn_4    : in std_logic_vector(n-1 downto 0);
        dataIn_5    : in std_logic_vector(n-1 downto 0);
        dataIn_6    : in std_logic_vector(n-1 downto 0);
        dataIn_7    : in std_logic_vector(n-1 downto 0);
        selector    : in std_logic_vector(2 downto 0);
        dataOut     : out std_logic_vector(n-1 downto 0)
    );
end component;

component Instruction_Register
    Port (
        dataIn      : in std_logic_vector(31 downto 0);
        IRWrite     : in std_logic;
        CLK         : in std_logic;
        RST         : in std_logic;
        Inst_31_26  : out std_logic_vector(5 downto 0);
        Inst_25_21  : out std_logic_vector(4 downto 0);
        Inst_20_16  : out std_logic_vector(4 downto 0);
        Inst_15_0   : out std_logic_vector(15 downto 0)
    );
end component;

component register_file
    Port (
        readRegister1   : in std_logic_vector(4 downto 0);
        readRegister2   : in std_logic_vector(4 downto 0);
        writeRegister   : in std_logic_vector(4 downto 0);
        writeData       : in std_logic_vector(31 downto 0);
        CLK             : in std_logic;
        RST             : in std_logic;
        regWrite        : in std_logic; -- read signal you get from controller
        readData1       : out std_logic_vector(31 downto 0);
        readData2       : out std_logic_vector(31 downto 0)
    );
end component;

component ALU_MUX
    Port (
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(31 downto 0);
        SHAMT : in std_logic_vector(4 downto 0);
        ALUOp : in std_logic_vector(3 downto 0);
        Overflow : out std_logic;
        Zero : out std_logic;
        R : out std_logic_vector(31 downto 0)
    );
end component;

component Sign_extend
    Port (
        dataIn  : in std_logic_vector(15 downto 0);
        dataOut : out std_logic_vector(31 downto 0)
    );
end component;

component shift_left_2_32
    Port (
        dataIn : in std_logic_vector(31 downto 0);
        dataOut : out std_logic_vector(31 downto 0)
    );
end component;

component shift_left_2_25
    Port (
        dataIn : in std_logic_vector(25 downto 0);
        dataOut : out std_logic_vector(27 downto 0)
    );
end component;

component CLO
    Port(
        input: in std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0)
    );
end component;

component multiplier_top
    Generic(
        n : integer := 32
    );
    Port (
        A : in std_logic_vector(n-1 downto 0);
        B : in std_logic_vector(n-1 downto 0);
        clk : in std_logic;
        rst : in std_logic;
        R : out std_logic_vector(n*2-1 downto 0);   -- hold the product
        done : out std_logic    -- only 1 when done (get it from controller unit)
    );
end component;

signal inst_25_21 : std_logic_vector(4 downto 0);
signal inst_20_16 : std_logic_vector(4 downto 0);
signal inst_15_0 : std_logic_vector(15 downto 0);

signal read_data_1_signal : std_logic_vector(31 downto 0);
signal read_data_2_signal : std_logic_vector(31 downto 0);

signal A_output : std_logic_vector(31 downto 0);
signal B_output : std_logic_vector(31 downto 0);

signal ALUOut_output : std_logic_vector(31 downto 0);

signal memory_data_output : std_logic_vector(31 downto 0);

signal PC_output : std_logic_vector(31 downto 0);

signal sign_extended_output : std_logic_vector(31 downto 0);
signal shift_left_output1 : std_logic_vector(27 downto 0);
signal shift_left_output2 : std_logic_vector(31 downto 0);

signal ALU_MUX_output : std_logic_vector(31 downto 0);
signal overflowbit : std_logic;

signal muxOutput_1 : std_logic_vector(4 downto 0);
signal muxOutput_2 : std_logic_vector(31 downto 0);
signal muxOutput_3 : std_logic_vector(31 downto 0);
signal muxOutput_4 : std_logic_vector(31 downto 0);
signal muxOutput_5 : std_logic_vector(31 downto 0);

signal shift_left_input : std_logic_vector(25 downto 0);
signal final_mux_input : std_logic_vector(31 downto 0);
signal SHAMT_input : std_logic_vector(4 downto 0);

signal CLO_output : std_logic_vector(31 downto 0);

signal LUI_temp : std_logic_vector(31 downto 0);
signal LH_temp : std_logic_vector(31 downto 0);

signal multiplier_result : std_logic_vector(63 downto 0);
signal mult_high_result : std_logic_vector(31 downto 0);
signal mult_low_result : std_logic_vector(31 downto 0);


begin
shift_left_input <= inst_25_21 & inst_20_16 & inst_15_0;
final_mux_input <= PC_output(31 downto 28) & shift_left_output1;

--Instruction_lsb <= inst_15_0(5 downto 0);

LUI_temp <= ALUOut_output(15 downto 0) & "0000000000000000"; -- directly read from ALU out
LH_temp <= "0000000000000000" & memory_data_output(15 downto 0);

MemoryDataOut <= B_output;

A:register_template
    port map(
        inputValue => read_data_1_signal,
        CLK => CLK,
        RST => RST,
        EN => AEn,
        outputValue => A_output
    );
    
B:register_template
    port map(
        inputValue => read_data_2_signal,
        CLK => CLK,
        RST => RST,
        EN => BEn,
        outputValue => B_output
    );
    
ALUOUT:register_template
    port map(
        inputValue => ALU_MUX_output,
        CLK => CLK,
        RST => RST,
        EN => ALUOutEn,
        outputValue => ALUOut_output
    );
    
MemoryData:register_template
    port map(
        inputValue => MemoryDataIn,
        CLK => CLK,
        RST => RST,
        EN => MemoryEn,
        outputValue => memory_data_output
    );
    
PC:register_template
    port map(
        inputValue => muxOutput_5,
        CLK => CLK,
        RST => RST,
        EN => PCEn,
        outputValue => PC_output
    );
     
PCMux: MUX_2input
    port map(
        dataIn_1 => PC_output,
        dataIn_2 => ALUOut_output,
        selector => IorD,
        dataOut => MemoryAddress
    );
    
SL1:shift_left_2_25
    port map(
        dataIn => shift_left_input,
        dataOut => shift_left_output1
    );
    
SL2:shift_left_2_32
    port map(
        dataIn => sign_extended_output,
        dataOut => shift_left_output2
    );
    
SE:Sign_extend
    port map(
        dataIn => inst_15_0,
        dataOut => sign_extended_output
    );

IE:Instruction_Register
    port map(
        dataIn => MemoryDataIn,
        IRWrite => IRWrite,
        CLK => CLK,
        RST => RST,
        Inst_31_26 => Opcode,
        Inst_25_21 => inst_25_21,
        Inst_20_16 => inst_20_16,
        Inst_15_0  => inst_15_0
    );

WriteRegisterMux: MUX_2input_2  -- for register file with 5 bit input (write register mux)
    port map(
        dataIn_1 => inst_20_16,
        dataIn_2 => inst_15_0(15 downto 11),
        selector => RegDst,
        dataOut => muxOutput_1  -- writeRegister
    );

WriteDataMux: MUX_7input    -- Mux for writeData input of register file (write data mux)
    port map(
        dataIn_1 => ALUOut_output,
        dataIn_2 => memory_data_output,
        dataIn_3 => CLO_output,
        dataIn_4 => LUI_temp, -- LUI, 
        dataIn_5 => LH_temp, -- LH
        dataIn_6 => mult_high_result,    -- High 32 bits of multiplier result (for MFHI)
        dataIn_7 => mult_low_result,     -- Low 32 bits of multiplier result (for MFLO)
        selector => MemtoReg,
        dataOut => muxOutput_2  -- writeData
    );

ARegMux: MUX_3input -- A mux
    port map(
        dataIn_1 => PC_output,
        dataIn_2 => A_output,
        dataIn_3 => B_output,
        selector => ALUSrcA,
        dataOut => muxOutput_3  -- writeData
    );

BRegmux: MUX_5input -- B mux
    port map(
        dataIn_1 => B_output,
        dataIn_2 => X"00000004",
        dataIn_3 => sign_extended_output,
        dataIn_4 => shift_left_output2,
        dataIn_5 => A_output,
        selector => ALUSrcB,
        dataOut =>  muxOutput_4 -- writeData
    ); 

EndMux: MUX_4input -- mux at the end
    port map(
        dataIn_1 => ALU_MUX_output,
        dataIn_2 => ALUOut_output,
        dataIn_3 => final_mux_input,
        dataIn_4 => A_output,
        selector => PCSource,
        dataOut =>  muxOutput_5 -- writeData
    ); 
    
ALU1 : ALU_MUX
    port map(
        A => muxOutput_4,
        B => muxOutput_3,
        SHAMT => SHAMT_input,
        ALUOp => ALUOpcode,  -- ALU Op from ALU control (part of CPU control)
        Overflow => overflowbit,
        Zero => zerobit,
        R => ALU_MUX_output
    );
    
RegFile: register_file
    port map(
        readRegister1 => inst_25_21,
        readRegister2 => inst_20_16,
        writeRegister => muxOutput_1,
        writeData => muxOutput_2,
        CLK => CLK,
        RST => RST,
        regWrite => RegWrite,
        readData1 => read_data_1_signal,
        readData2 => read_data_2_signal
    );
    
SHAMT_SS : MUX_2input_2 -- choose which SHAMT to use for SLLs
    port map(
        dataIn_1 => A_output(4 downto 0),
        dataIn_2 => inst_15_0(10 downto 6),
        selector => SHAMT_Selector,
        dataOut => SHAMT_input
    );

CLO_1 : CLO
    port map(
        input => A_output,
        output => CLO_output
    );

multipllier: multiplier_top
    port map(
        A => A_output,
        B => B_output,
        clk => CLK,
        rst => multiplier_reset, -- separate reset multiplier to tell that multiplier needs to work (set high before use)
        R => multiplier_result,
        done => done
    );
    
mult_high: register_template
    port map(
        inputValue => multiplier_result(63 downto 32),  -- high 32 bits
        CLK => CLK,
        RST => RST,
        EN => mult_high_en,
        outputValue => mult_high_result
    );
    
mult_low: register_template
    port map(
        inputValue => multiplier_result(31 downto 0), -- low 32 bits
        CLK => CLK,
        RST => RST,
        EN => mult_low_en,
        outputValue => mult_low_result
    );

end Behavioral;
