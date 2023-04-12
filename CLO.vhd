library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CLO is
    Port ( 
        input : in STD_LOGIC_VECTOR(31 DOWNTO 0);
        output : out STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end CLO;

architecture Behavioral of CLO is
begin
    output <=   x"00000000" when std_match(input, "0-------------------------------") else 
                x"00000001" when std_match(input, "10------------------------------") else 
                x"00000002" when std_match(input, "110-----------------------------") else 
                x"00000003" when std_match(input, "1110----------------------------") else 
                x"00000004" when std_match(input, "11110---------------------------") else 
                x"00000005" when std_match(input, "111110--------------------------") else 
                x"00000006" when std_match(input, "1111110-------------------------") else 
                x"00000007" when std_match(input, "11111110------------------------") else 
                x"00000008" when std_match(input, "111111110-----------------------") else 
                x"00000009" when std_match(input, "1111111110----------------------") else 
                x"0000000A" when std_match(input, "11111111110---------------------") else 
                x"0000000B" when std_match(input, "111111111110--------------------") else 
                x"0000000C" when std_match(input, "1111111111110-------------------") else 
                x"0000000D" when std_match(input, "11111111111110------------------") else 
                x"0000000E" when std_match(input, "111111111111110-----------------") else 
                x"0000000F" when std_match(input, "1111111111111110----------------") else 
                x"00000010" when std_match(input, "11111111111111110---------------") else 
                x"00000011" when std_match(input, "111111111111111110--------------") else 
                x"00000012" when std_match(input, "1111111111111111110-------------") else 
                x"00000013" when std_match(input, "11111111111111111110------------") else 
                x"00000014" when std_match(input, "111111111111111111110-----------") else 
                x"00000015" when std_match(input, "1111111111111111111110----------") else 
                x"00000016" when std_match(input, "11111111111111111111110---------") else 
                x"00000017" when std_match(input, "111111111111111111111110--------") else 
                x"00000018" when std_match(input, "1111111111111111111111110-------") else 
                x"00000019" when std_match(input, "11111111111111111111111110------") else 
                x"0000001a" when std_match(input, "111111111111111111111111110-----") else 
                x"0000001b" when std_match(input, "1111111111111111111111111110----") else 
                x"0000001c" when std_match(input, "11111111111111111111111111110---") else 
                x"0000001d" when std_match(input, "111111111111111111111111111110--") else 
                x"0000001e" when std_match(input, "1111111111111111111111111111110-") else 
                x"0000001f" when std_match(input, "11111111111111111111111111111110") else 
                x"00000020" when std_match(input, "11111111111111111111111111111111") else
                (others => '0');
end Behavioral;
