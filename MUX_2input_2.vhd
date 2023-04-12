library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_2input_2 is
    Generic(
        n : integer :=5
    );
    Port (
        dataIn_1    : in std_logic_vector(n-1 downto 0);
        dataIn_2    : in std_logic_vector(n-1 downto 0);
        selector    : in std_logic;
        dataOut     : out std_logic_vector(n-1 downto 0)
    );
end MUX_2input_2;

architecture Behavioral of MUX_2input_2 is

signal data_temp : std_logic_vector(n-1 downto 0);

begin
    with selector select
        dataOut <= dataIn_1 when '0',
                   dataIn_2 when '1',
                   dataIn_2 when others;
end Behavioral;