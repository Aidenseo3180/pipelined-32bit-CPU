library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sign_extend is
    Port (
        dataIn  : in std_logic_vector(15 downto 0);
        dataOut : out std_logic_vector(31 downto 0)
    );
end Sign_extend;

architecture Behavioral of Sign_extend is

begin
    -- sign extend
    -- if negative, extend with all 1s
    -- if positive, extend with all 0s
    
    with dataIn(15) select
        dataOut(31 downto 16) <= (others=>'0') when '0',
                                 (others=>'1') when '1',
                                 (others=>'0') when others;
    
    dataOut(15 downto 0) <= dataIn;
end Behavioral;
