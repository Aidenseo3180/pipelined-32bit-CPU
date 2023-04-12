library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ALUOp : 10 = SLT, 11 = SLTU
entity alu_comp is
    Port (
        A_31 : in std_logic;
        B_31 : in std_logic;
        S_31 : in std_logic;    -- sum
        CO : in std_logic;  -- carry out
        ALUOp : in std_logic_vector(1 downto 0);
        R : out std_logic_vector(31 downto 0)
    );
end alu_comp;

architecture Behavioral of alu_comp is

signal slt_r : std_logic_vector(31 downto 0);
signal sltu_r : std_logic_vector(31 downto 0);
signal temp : std_logic_vector(2 downto 0);

begin
-- for SLT
temp <= A_31 & B_31 & S_31;

with temp select
    slt_r <= X"00000000" when "000" | "110" | "010" | "011",
              X"00000001" when "001" | "111" | "100" | "101",
              X"00000000" when others; --some arbitary others

-- for SLTU, only CO (Carry Out) matters
with CO select
    sltu_r <= X"00000000" when '1',
             X"00000001" when '0',
             X"00000000" when others; --some arbitary others

-- at the end, depending on ALUOp, choose which result to go with
with ALUOp select
    R <= sltu_r when "11",
         slt_r when "10",
         X"00000000" when others; --some arbitary others

end Behavioral;
