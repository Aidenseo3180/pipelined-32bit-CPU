library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier_top is
    Generic(
        n : integer := 32
    );
    Port (
        A : in std_logic_vector(n-1 downto 0);
        B : in std_logic_vector(n-1 downto 0);
        clk : in std_logic;
        rst : in std_logic;
        R : out std_logic_vector(n*2-1 downto 0);   -- hold the product
        done : out std_logic    -- only 1 when done (get it from controller unit)
    );
end multiplier_top;

architecture Behavioral of multiplier_top is
component reg
    GENERIC(
        n : integer := 64
    );
    PORT(
        CLK : in std_logic;
        D : in std_logic_vector(n-1 downto 0);
        EN : in std_logic;
        RST : in std_logic;
        Q : out std_logic_vector(n-1 downto 0)
    );
end component;

component adder
    generic (
		WIDTH : positive := 64
	);
	port (
		A     : in  std_logic_vector(WIDTH-1 downto 0);
		B     : in  std_logic_vector(WIDTH-1 downto 0);
		EN    : in  std_logic;
		S     : out std_logic_vector(WIDTH-1 downto 0)
	);
end component;

component multiplicand
    GENERIC(
        n : integer := 64
    );
    PORT(
        CLK : in std_logic;
        D : in std_logic_vector(n-1 downto 0);
        RST : in std_logic;
        LOAD : in std_logic;
        EN : in std_logic;
        Q : out std_logic_vector(n-1 downto 0)
    );
end component;

component multiplier
    GENERIC(
        n : integer := 32
    );
    PORT(
        CLK : in std_logic;
        D : in std_logic_vector(n-1 downto 0);
        RST : in std_logic;
        LOAD : in std_logic;
        EN : in std_logic;
        Q : out std_logic_vector(n-1 downto 0)
    );
end component;

component mealy_4s
    port(
		clk               : in	std_logic;
		multiplier_lsb    : in std_logic;   -- input, multiplier first bit
		count_in          : in std_logic_vector(4 downto 0);
		reset	          : in	std_logic;
		add_en            : out std_logic;
		left_en           : out std_logic;  -- multiplicand
		right_en          : out std_logic; -- multiplier
		prod_en           : out std_logic;
		load_en           : out std_logic;
		count_en          : out std_logic;
		done              : out std_logic
	);
end component;

component counter_5bit
    port(
        CLK, RST, EN    : in std_logic;
        Q               : out std_logic_vector(4 downto 0)
    );
end component;

signal done_signal : std_logic;
signal multiplicand_vector : std_logic_vector(63 downto 0);

signal product_enable : std_logic;
signal adder_enable : std_logic;
signal multiplicand_enable : std_logic;
signal multiplier_enable : std_logic;
signal load_en : std_logic;
signal counter_en : std_logic;

signal multiplicand_result : std_logic_vector(63 downto 0);
signal multiplier_result : std_logic_vector(31 downto 0);
signal product_result : std_logic_vector(63 downto 0);
signal adder_sum : std_logic_vector(63 downto 0);

signal count_num : std_logic_vector(4 downto 0);

begin

multiplicand_vector(31 downto 0) <= A;
multiplicand_vector(63 downto 32) <= (others => '0');

C1: multiplicand
    port map(
        CLK => clk,
        RST => rst,
        D => multiplicand_vector,
        LOAD => load_en,
        EN => multiplicand_enable,
        Q => multiplicand_result
    );
    
C2: multiplier
    port map(
        CLK => clk,
        RST => rst,
        D => B,
        LOAD => load_en,
        EN => multiplier_enable,
        Q => multiplier_result
    );

C3: adder
    port map(
        A => product_result,
        B => multiplicand_result,
        EN => adder_enable,
        S => adder_sum
    );
    
C4: reg -- product
    port map(
        CLK => clk,
        RST => rst,
        D => adder_sum,
        EN => product_enable,
        Q => product_result
    );

C5: mealy_4s    -- control unit
    port map(
        multiplier_lsb => multiplier_result(0),
        CLK => clk,
        count_in => count_num,
        reset => rst,
        prod_en => product_enable,
        add_en => adder_enable,
        load_en => load_en,
        left_en => multiplicand_enable,
        right_en => multiplier_enable,
        count_en => counter_en,
        done => done_signal
    );
    
C6: counter_5bit
    port map(
        CLK => clk,
        RST => rst,
        EN => counter_en,
        Q => count_num
    );

X1: process(product_result)
    begin
        R <= product_result;
    end process;
X2: process(done_signal)
    begin
        done <= done_signal;
    end process;

end Behavioral;
