library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_MUX is
    Port (
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(31 downto 0);
        SHAMT : in std_logic_vector(4 downto 0);
        ALUOp : in std_logic_vector(3 downto 0);
        Overflow : out std_logic;
        Zero : out std_logic;
        R : out std_logic_vector(31 downto 0)
    );
end ALU_MUX;

architecture Behavioral of ALU_MUX is

component alu_logic
    port(
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(31 downto 0);
        Op : in std_logic_vector(1 downto 0);
        R : out std_logic_vector(31 downto 0)
    );
end component;

component Arith_Unit
    GENERIC (
        n       : positive := 32);
    PORT( 
        A       : IN     std_logic_vector (n-1 DOWNTO 0);
        B       : IN     std_logic_vector (n-1 DOWNTO 0);
        C_op    : IN     std_logic_vector (1 DOWNTO 0);
        CO      : OUT    std_logic;
        OFL     : OUT    std_logic;
        S       : OUT    std_logic_vector (n-1 DOWNTO 0);
        Z       : OUT    std_logic
    );
end component;

component alu_comp
    port(
        A_31 : in std_logic;
        B_31 : in std_logic;
        S_31 : in std_logic;    -- sum
        CO : in std_logic;  -- carry out
        ALUOp : in std_logic_vector(1 downto 0);
        R : out std_logic_vector(31 downto 0)
    );
end component;

component alu_shift
    port(
        A : in std_logic_vector(31 downto 0);
        SHAMT : in std_logic_vector(4 downto 0);
        ALUOp : in std_logic_vector(1 downto 0);
        R : out std_logic_vector(31 downto 0)
    );
end component;

signal LogicalR : std_logic_vector(31 downto 0);
signal ArithR : std_logic_vector(31 downto 0);
signal CompR : std_logic_vector(31 downto 0);
signal ShiftR : std_logic_vector(31 downto 0);
signal Carryout_signal : std_logic;

begin

V1 : alu_logic
    port map(
        A => A,
        B => B,
        Op => ALUOp(1 downto 0),
        R => LogicalR
    );

V2 : Arith_Unit
    port map(
        A => A,
        B => B,
        C_op => ALUOp(1 downto 0),
        CO => Carryout_signal,
        OFL => Overflow,
        S => ArithR,
        Z => Zero
    );
    
V3 : alu_comp
    port map(
        A_31 => A(31),
        B_31 => B(31),
        S_31 => ArithR(31),
        CO => Carryout_signal,
        ALUOp => ALUOp(1 downto 0),
        R => CompR
    );
    
V4 : alu_shift
    port map(
        A => A,
        SHAMT => SHAMT,
        ALUOp => ALUOp(1 downto 0),
        R => ShiftR
    );

-- ALU Mux at the end
with ALUOp(3 downto 2) select
    R <= LogicalR when "00",
         ArithR when "01",
         CompR when "10",
         ShiftR when "11",
         ShiftR when others; -- arbitary case for others  

end Behavioral;
