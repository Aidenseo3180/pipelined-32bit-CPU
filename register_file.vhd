library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port (
        readRegister1   : in std_logic_vector(4 downto 0);
        readRegister2   : in std_logic_vector(4 downto 0);
        writeRegister   : in std_logic_vector(4 downto 0);
        writeData       : in std_logic_vector(31 downto 0);
        CLK             : in std_logic;
        RST             : in std_logic;
        regWrite        : in std_logic; -- read signal you get from controller
        readData1       : out std_logic_vector(31 downto 0);
        readData2       : out std_logic_vector(31 downto 0)
    );
end register_file;

architecture Behavioral of register_file is

-- creating array
type t_Memory is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg : t_Memory;

begin
    process(CLK, RST)    -- no RST because it's synchronous
    begin
        if (RST = '1') then
            reg <= (others => (others => '0'));
        elsif (CLK'event and CLK='1') then
            if (regWrite = '1') then    -- if regWrite is 1
                reg(to_integer(unsigned(writeRegister))) <= writeData;    -- write to register
            end if;
         end if;
     end process;
     readData1 <= reg(to_integer(unsigned(readRegister1)));  -- read register and update output
     readData2 <= reg(to_integer(unsigned(readRegister2)));
end Behavioral;
