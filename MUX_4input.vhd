library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_4input is
    Generic(
        n : integer := 32
    );
    Port (
        dataIn_1    : in std_logic_vector(n-1 downto 0);
        dataIn_2    : in std_logic_vector(n-1 downto 0);
        dataIn_3    : in std_logic_vector(n-1 downto 0);
        dataIn_4    : in std_logic_vector(n-1 downto 0);
        selector    : in std_logic_vector(1 downto 0);
        dataOut     : out std_logic_vector(n-1 downto 0)
    );
end MUX_4input;

architecture Behavioral of MUX_4input is

begin
    with selector select
        dataOut <= dataIn_1 when "00",
                   dataIn_2 when "01",
                   dataIn_3 when "10",
                   dataIn_4 when "11",
                   dataIn_4 when others;
end Behavioral;
