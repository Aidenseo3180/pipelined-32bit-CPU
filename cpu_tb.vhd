library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_tb is
    Port(
        reset : in std_logic;
        clk : in std_logic
    );
end cpu_tb;

architecture Behavioral of cpu_tb is

component CPU
    Port(
        Reset           : in std_logic;
        Clock           : in std_logic;
        MemoryDataIn    : in std_logic_vector(31 downto 0); -- command
        MemoryAddress   : out std_logic_vector(31 downto 0);
        MemoryDataOut   : out std_logic_vector(31 downto 0); -- result
        MemWrite        : out std_logic -- MemWrite from CPU controller
    );
end component;

component CPU_memory
    Port(
        Clk      : IN     std_logic;
        MemWrite : IN     std_logic;
        addr     : IN     std_logic_vector (31 DOWNTO 0);
        dataIn   : IN     std_logic_vector (31 DOWNTO 0);
        dataOut  : OUT    std_logic_vector (31 DOWNTO 0)
    );
end component;

signal data_in_signal : std_logic_vector(31 downto 0);
signal address_signal : std_logic_vector(31 downto 0);
signal data_out_signal : std_logic_vector(31 downto 0);
signal MemWrite_signal : std_logic;

begin

U_0 : CPU
    port map(
        Reset => reset,
        Clock => clk,
        MemoryDataIn => data_in_signal,
        MemoryAddress => address_signal,
        MemoryDataOut => data_out_signal,
        MemWrite => MemWrite_signal
    );

U_1: CPU_memory
    port map(
        CLK => clk,
        dataIn => data_out_signal,
        addr => address_signal,
        dataOut => data_in_signal,
        MemWrite => MemWrite_signal
    );

end Behavioral;

