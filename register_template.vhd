library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_template is
    Port(
        inputValue  : in std_logic_vector(31 downto 0);
        CLK         : in std_logic;
        RST         : in std_logic;
        EN          : in std_logic;
        outputValue : out std_logic_vector(31 downto 0)
    );
end register_template;

architecture Behavioral of register_template is

begin
    process(CLK)
    begin
        if (RST = '1') then
            outputValue <= (others => '0');
        elsif (CLK'event and CLK='1') then
            if (EN = '1') then
                outputValue <= inputValue; -- when EN = 1, update value
            end if;
        end if;
     end process;
end Behavioral;
