library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_5input is
    Generic(
        n : integer := 32
    );
    Port (
        dataIn_1    : in std_logic_vector(n-1 downto 0);
        dataIn_2    : in std_logic_vector(n-1 downto 0);
        dataIn_3    : in std_logic_vector(n-1 downto 0);
        dataIn_4    : in std_logic_vector(n-1 downto 0);
        dataIn_5    : in std_logic_vector(n-1 downto 0);
        selector    : in std_logic_vector(2 downto 0);
        dataOut     : out std_logic_vector(n-1 downto 0)
    );
end MUX_5input;

architecture Behavioral of MUX_5input is

begin
    with selector select
        dataOut <= dataIn_1 when "000",
                   dataIn_2 when "001",
                   dataIn_3 when "010",
                   dataIn_4 when "011",
                   dataIn_5 when "100",
                   dataIn_5 when others;
end Behavioral;