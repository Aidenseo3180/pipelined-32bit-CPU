library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Instruction_Register is
    Port (
        dataIn      : in std_logic_vector(31 downto 0);
        IRWrite     : in std_logic;
        CLK         : in std_logic;
        RST         : in std_logic;
        Inst_31_26  : out std_logic_vector(5 downto 0);
        Inst_25_21  : out std_logic_vector(4 downto 0);
        Inst_20_16  : out std_logic_vector(4 downto 0);
        Inst_15_0   : out std_logic_vector(15 downto 0)
    );
end Instruction_Register;

architecture Behavioral of Instruction_Register is

signal temp : std_logic_vector(31 downto 0);

begin
process(CLK)
    begin
        if (RST = '1') then
            temp <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if (IRWrite = '1') then -- if IRWrite is 1 --> read from the memory
                temp(31 downto 26) <= dataIn(31 downto 26);
                temp(25 downto 21) <= dataIn(25 downto 21);
                temp(20 downto 16) <= dataIn(20 downto 16);
                temp(15 downto 0) <= dataIn(15 downto 0);
            end if;
        end if;
    end process;
    Inst_31_26 <= temp(31 downto 26);
    Inst_25_21 <= temp(25 downto 21);
    Inst_20_16 <= temp(20 downto 16);
    Inst_15_0 <= temp(15 downto 0);
end Behavioral;
