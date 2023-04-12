library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- shift left
entity multiplicand is
    GENERIC(
        n : integer := 64
    );
    PORT(
        CLK : in std_logic;
        D : in std_logic_vector(n-1 downto 0);
        RST : in std_logic;
        LOAD : in std_logic;
        EN : in std_logic;
        Q : out std_logic_vector(n-1 downto 0)
    );
end multiplicand;

architecture Behavioral of multiplicand is

signal temp : std_logic_vector(n-1 downto 0);

begin

P1: process(CLK)
    begin
        if (RST = '1') then
            temp <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if (EN = '1') then
                if (LOAD = '0') then
                    temp <= D;
                elsif (LOAD = '1') then
                    temp <= temp(n-2 downto 0) & '0';
                end if;
            end if;
        end if;
    end process P1;
    Q <= temp;
end Behavioral;
