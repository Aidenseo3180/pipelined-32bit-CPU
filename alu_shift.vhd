library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- ALUOp(1) =  0 : Shift left, 1 : Shift right
-- ALUOp(0) = 0 : logical shift, 1 : arthmetic shift
-- left shift only has logical shift ; right shift has both
entity alu_shift is
    Port (
        A : in std_logic_vector(31 downto 0);
        SHAMT : in std_logic_vector(4 downto 0);
        ALUOp : in std_logic_vector(1 downto 0);
        R : out std_logic_vector(31 downto 0)
    );
end alu_shift;

architecture Behavioral of alu_shift is

signal L_0, L_1, L_2, L_3, L_4 : std_logic_vector(31 downto 0);
signal R_0, R_1, R_2, R_3, R_4 : std_logic_vector(31 downto 0);
signal A_temp : std_logic_vector(31 downto 0);
signal t : std_logic;

begin

A_temp <= A;
t <= ALUOp(0) and A(31); -- check whehther logical or arthmetic, if arthemtic, t = 1

-- For shift left
with SHAMT(0) select
    L_0 <= A_temp(30 downto 0) & '0' when '1',
           A_temp when '0',
           A_temp when others;
           
with SHAMT(1) select
    L_1 <= L_0(29 downto 0) & "00" when '1',
           L_0 when '0',
           L_0 when others;

with SHAMT(2) select
    L_2 <= L_1(27 downto 0) & "0000" when '1',
           L_1 when '0',
           L_1 when others;

with SHAMT(3) select
    L_3 <= L_2(23 downto 0) & "00000000" when '1',
           L_2 when '0',
           L_2 when others;
           
with SHAMT(4) select
    L_4 <= L_3(15 downto 0) & "0000000000000000" when '1',
           L_3 when '0',
           L_3 when others;

-- For shift right
with SHAMT(0) select
    R_0 <= t & A_temp(31 downto 1) when '1',
           A_temp when '0',
           A_temp when others;
           
with SHAMT(1) select
    R_1 <= (t&t) & R_0(31 downto 2) when '1',
           R_0 when '0',
           R_0 when others;

with SHAMT(2) select
    R_2 <=  (t&t&t&t) & R_1(31 downto 4) when '1',
           R_1 when '0',
           R_1 when others;

with SHAMT(3) select
    R_3 <= (t&t&t&t&t&t&t&t) & R_2(31 downto 8) when '1',
           R_2 when '0',
           R_2 when others;
           
with SHAMT(4) select
    R_4 <= (t&t&t&t&t&t&t&t&t&t&t&t&t&t&t&t) & R_3(31 downto 16) when '1',
           R_3 when '0',
           R_3 when others;
          

-- Select which one to use
with ALUOp(1) select
    R <= L_4 when '0',
         R_4 when '1',
         R_4 when others;
         
end Behavioral;