library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_left_2_25 is
    Port (
        dataIn : in std_logic_vector(25 downto 0);
        dataOut : out std_logic_vector(27 downto 0)
    );
end shift_left_2_25;

architecture Behavioral of shift_left_2_25 is

begin
    dataOut <= dataIn(25 downto 0) & "00";
end Behavioral;
