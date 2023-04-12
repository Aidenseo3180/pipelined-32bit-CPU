library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity counter_5bit is
    Port (
        CLK, RST, EN    : in std_logic;
        Q               : out std_logic_vector(4 downto 0)
    );
end counter_5bit;

architecture Behavioral of counter_5bit is
    signal count : std_logic_vector(4 downto 0);
begin
    process(CLK, RST)
        begin
            if RST = '1'then
                count <= "00000";
            elsif (CLK'event and CLK = '1') then
                if (EN = '1' and count < "11111") then
                    count <= count + 1;
                end if;
            end if;
        end process;
    Q <= count;
end Behavioral;
