library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_logic is
    PORT(
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(31 downto 0);
        Op : in std_logic_vector(1 downto 0);
        R : out std_logic_vector(31 downto 0)
    );
end alu_logic;

architecture Behavioral of alu_logic is
begin

WITH Op SELECT
    R <= (A and B) when "00",
         (A or B) when "01",
         (A xor B) when "10",
         (A nor B) when "11",
         A when others; -- some arbitary number to fill out others case. Will never get called

end Behavioral;
