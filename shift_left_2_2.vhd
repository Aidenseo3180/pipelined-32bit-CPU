library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_left_2_32 is
    Port (
        dataIn : in std_logic_vector(31 downto 0);
        dataOut : out std_logic_vector(31 downto 0)
    );
end shift_left_2_32;

architecture Behavioral of shift_left_2_32 is

begin
    dataOut <= dataIn(29 downto 0) & "00";
end Behavioral;
