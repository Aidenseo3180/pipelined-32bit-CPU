library ieee;
use ieee.std_logic_1164.all;

entity mealy_4s is  -- controller
	port(
		clk               : in std_logic;
		multiplier_lsb    : in std_logic;   -- input, multiplier first bit
		reset             : in std_logic;
		count_in          : in std_logic_vector(4 downto 0);
		add_en            : out std_logic;
		left_en           : out std_logic;  -- multiplicand
		right_en          : out std_logic;  -- multiplier
		prod_en           : out std_logic;
		load_en           : out std_logic;
		count_en          : out std_logic;
		done              : out std_logic
	);
end entity;

architecture rtl of mealy_4s is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2);
	
	-- Register to hold the current state
	signal present_state, next_state : state_type;
	
	-- signal counter : integer;

begin

	process (clk, reset)
	begin
		if reset = '1' then   -- reset all the signals
            present_state <= s0;     -- go back to beginning state
        elsif (clk'event and clk='1') then
            present_state <= next_state;
        end if;
    end process; 
       
    process (clk, present_state, reset)
		begin
			case present_state is
				when s0=>   -- reset state
				    next_state <= s1;
				    -- counter <= 0;
				when s1=>
                    if (count_in = "11111") then
                        next_state <= s2;
                    else
                        next_state <= s1;
                    end if;
					
			    when s2 =>   -- output state
			        next_state <= s2;    -- stay in s2 state
			end case;
	end process;
	
	-- determine output based on state and input
	process (present_state, multiplier_lsb)
	begin
		case present_state is
			when s0=>    -- reset/ load state
			    add_en <= '0';
			    count_en <= '0';
				load_en <= '0'; -- Q = D. Simply load values
				left_en <= '1'; -- these doesn't matter. reset = 1 so everything goes to 0
				right_en <= '1';
				prod_en <= '0'; -- enable to update product register
				done <= '0';
			when s1=>    -- shift / add
			    if (multiplier_lsb = '1') then  -- enable adder to carry out add
				    add_en <= '1';
				else
				    add_en <= '0';
				end if;
			    load_en <= '1';  --enable load to allow shifters to shift numbers
			    prod_en <= '1';
		        left_en <= '1';
		        count_en <= '1';
		        right_en <= '1';
		        done <= '0';
			when s2=>    -- output to user, done
			    done <= '1';
			    add_en <= '0';
			    load_en <= '0';
			    left_en <= '0';
			    right_en <= '0';
			    count_en <= '0';
			    prod_en <= '0';

		end case;
	end process;
	
end rtl;
