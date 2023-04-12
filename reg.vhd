library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg is
    GENERIC(
        n : integer := 64
    );
    PORT(
        CLK : in std_logic;
        D : in std_logic_vector(n-1 downto 0);
        EN : in std_logic;
        RST : in std_logic;
        Q : out std_logic_vector(n-1 downto 0)
    );
end reg;

architecture Behavioral of reg is

begin
    CLKD: process(CLK, RST)    
    begin
        if (RST = '1') then
            Q <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if (EN = '1') then
                Q <= D;
            end if;
        end if;
    end process CLKD;
end Behavioral;



