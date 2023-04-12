library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is
	generic (
		WIDTH : positive := 64
	);
	port (
		A     : in  std_logic_vector(WIDTH-1 downto 0);
		B     : in  std_logic_vector(WIDTH-1 downto 0);
		EN    : in  std_logic;
		S     : out std_logic_vector(WIDTH-1 downto 0)
	);
end entity;

architecture Behavioral of adder is
begin
    S <= std_logic_vector(unsigned(A) + unsigned(B)) when EN = '1' else A; -- else, stay the same (don't add)     
end architecture;
