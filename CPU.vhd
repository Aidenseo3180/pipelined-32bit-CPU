library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
    Port(
        Reset           : in std_logic;
        Clock           : in std_logic;
        MemoryDataIn    : in std_logic_vector(31 downto 0); -- command
        MemoryAddress   : out std_logic_vector(31 downto 0);
        MemoryDataOut   : out std_logic_vector(31 downto 0); -- result
        MemWrite        : out std_logic -- MemWrite from CPU controller
    );
end CPU;

architecture Behavioral of CPU is

component CPU_control_unit
    Port(
        Done            : in std_logic;
        CLK         : in std_logic;
        RST         : in std_logic;
        Op          : in std_logic_vector(5 downto 0);
        Instruction : in std_logic_vector(5 downto 0);  -- 5 LSB that goes into ALU control
        zerobit     : in std_logic; --zero bit from ALU of datapath
        PCSource    : out std_logic_vector(1 downto 0);
        ALUSrcB     : out std_logic_vector(2 downto 0);    -- enable for B mux
        ALUSrcA     : out std_logic_vector(1 downto 0);    -- enable for A mux
        RegWrite    : out std_logic;
        RegDst      : out std_logic;
        PCWriteCond : out std_logic;
        PCWrite     : out std_logic;
        IorD        : out std_logic;
        MemWrite    : out std_logic;
        MemtoReg    : out std_logic_vector(2 downto 0);
        IRWrite     : out std_logic;
        ALUOpcode   : out std_logic_vector(3 downto 0);    -- opcode for ALU to add/sub/and/or/etc.
        AEn         : out std_logic;    -- for A register
        BEn         : out std_logic;    -- for B register
        ALUOutEn    : out std_logic;    -- for ALU out
        MemoryEn    : out std_logic;
        SHAMT_Selector    : out std_logic;
        multiplier_reset: out std_logic;
        
        mult_high_en : out std_logic;    -- enables called after multu is done
        mult_low_en : out std_logic
    );
end component;

component Datapath
    Port(
        SHAMT_Selector : in std_logic;
        PCEn     : in std_logic;
        PCSource    : in std_logic_vector(1 downto 0);
        ALUSrcB     : in std_logic_vector(2 downto 0);    -- enable for B mux
        ALUSrcA     : in std_logic_vector(1 downto 0);    -- enable for A mux
        RegWrite    : in std_logic;
        RegDst      : in std_logic;
        IorD        : in std_logic;
        MemtoReg    : in std_logic_vector(2 downto 0);
        IRWrite     : in std_logic;
        ALUOpcode   : in std_logic_vector(3 downto 0);    -- opcode for ALU to add/sub/etc.
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
        zerobit         : out std_logic; --zero bit from ALU of datapath
        --Instruction_lsb : out std_logic_vector(5 downto 0); -- goes into CPU controller
        
        done : out std_logic   --done signal from multipler, goes into control unit
    );
end component;

signal op_control_unit : std_logic_vector(5 downto 0);
--signal instruction_signal : std_logic_vector(5 downto 0);
signal PCSource_signal   : std_logic_vector(1 downto 0);
signal ALUSrcB_signal : std_logic_vector(2 downto 0);
signal ALUSrcA_signal : std_logic_vector(1 downto 0);
signal RegWrite_signal: std_logic;
signal RegDst_signal  : std_logic;
signal PCWriteCond_signal : std_logic;
signal PCWrite_signal : std_logic;
signal IorD_signal : std_logic;
signal MemWrite_signal : std_logic;
signal MemtoReg_signal : std_logic_vector(2 downto 0);
signal IRWrite_signal : std_logic;
signal ALUOpcode_signal : std_logic_vector(3 downto 0);
signal AEn_signal : std_logic;
signal BEn_signal : std_logic;
signal ALUOutEn_signal : std_logic;
signal MemoryEn_signal : std_logic;
signal zerobit_signal : std_logic;
signal SHAMT_Selector : std_logic; -- from data path to CPU controller

signal done_signal : std_logic;
signal multiplier_reset_signal : std_logic;

signal mult_high_en_signal : std_logic;
signal mult_low_en_signal : std_logic;

signal temp1 : std_logic;
signal temp2 : std_logic;

begin
temp1 <= PCWriteCond_signal and (not zerobit_signal);   -- reverse b/c zerobit is 0 when not equal
temp2 <= temp1 or PCWrite_signal;   -- for PCEnable
MemWrite <= MemWrite_signal;

C1: CPU_control_unit
    port map(
        Done => done_signal,
        CLK => Clock,
        RST => Reset,
        Op => op_control_unit,
        Instruction => MemoryDataIn(5 downto 0),
        zerobit => zerobit_signal,
        PCSource => PCSource_signal,
        ALUSrcB => ALUSrcB_signal,
        ALUSrcA => ALUSrcA_signal,
        RegWrite => RegWrite_signal,
        RegDst => RegDst_signal,
        PCWriteCond => PCWriteCond_signal,
        PCWrite => PCWrite_signal,
        IorD => IorD_signal,
        MemWrite => MemWrite_signal,
        MemtoReg => MemtoReg_signal,
        IRWrite => IRWrite_signal,
        ALUOpcode => ALUOpcode_signal,
        AEn => AEn_signal,
        BEn => BEn_signal,
        ALUOutEn  => ALUOutEn_signal,
        MemoryEn => MemoryEn_signal,
        SHAMT_Selector => SHAMT_Selector,
        multiplier_reset => multiplier_reset_signal,
        mult_high_en => mult_high_en_signal,
        mult_low_en => mult_low_en_signal
    );

C2: Datapath
    port map(
        SHAMT_Selector => SHAMT_Selector,
        PCEn => temp2,
        PCSource => PCSource_signal,
        ALUSrcB => ALUSrcB_signal,
        ALUSrcA => ALUSrcA_signal,
        RegWrite => RegWrite_signal,
        RegDst => RegDst_signal,
        IorD => IorD_signal,
        MemtoReg => MemtoReg_signal,
        IRWrite => IRWrite_signal,
        ALUOpcode => ALUOpcode_signal,
        AEn => AEn_signal,
        BEn => BEn_signal,
        ALUOutEn => ALUOutEn_signal,
        MemoryEn => MemoryEn_signal,
        
        mult_high_en => mult_high_en_signal,
        mult_low_en => mult_low_en_signal,
        
        CLK => Clock,
        RST => Reset,
        multiplier_reset => multiplier_reset_signal,
        MemoryDataIn => MemoryDataIn, -- from CPU memory
        MemoryAddress => MemoryAddress, -- from CPU memory
        MemoryDataOut => MemoryDataOut,
        -- MemWrite => MemWrite_signal,
        Opcode => op_control_unit,
        zerobit => zerobit_signal,
        --Instruction_lsb => instruction_signal,
        done => done_signal
    ); 

end Behavioral;

