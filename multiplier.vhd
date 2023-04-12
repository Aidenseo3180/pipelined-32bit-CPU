library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- shift right
entity multiplier is
    GENERIC(
        n : integer := 32
    );
    PORT(
        CLK : in std_logic;
        D : in std_logic_vector(n-1 downto 0);
        RST : in std_logic;
        LOAD : in std_logic;
        EN : in std_logic;
        Q : out std_logic_vector(n-1 downto 0)
    );
end multiplier;

architecture Behavioral of multiplier is

signal temp : std_logic_vector(n-1 downto 0);

begin

P2: process(CLK)    
    begin
        if (RST = '1') then
            temp <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if (EN = '1') then
                if (LOAD = '0') then -- stays the same
                    temp <= D;
                elsif (LOAD = '1') then
                    temp <= '0' & temp(n-1 downto 1);    -- shift left by 1
                end if;
             end if;
        end if;
    end process P2;
    Q <= temp;
end Behavioral;
