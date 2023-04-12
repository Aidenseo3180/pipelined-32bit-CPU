library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU_control_unit is
    Port(
        Done            : in std_logic; -- done signal from multiplier (datapath)
        CLK             : in std_logic;
        RST             : in std_logic;
        Op              : in std_logic_vector(5 downto 0);
        Instruction     : in std_logic_vector(5 downto 0);  -- 6 LSB, used for r-type when Op = 000000
        zerobit         : in std_logic; --zero bit from ALU of datapath
        PCSource        : out std_logic_vector(1 downto 0);
        ALUSrcB         : out std_logic_vector(2 downto 0);    -- enable for B mux
        ALUSrcA         : out std_logic_vector(1 downto 0);    -- enable for A mux
        RegWrite        : out std_logic;
        RegDst          : out std_logic;
        PCWriteCond     : out std_logic;
        PCWrite         : out std_logic;
        IorD            : out std_logic;
        MemWrite        : out std_logic;
        MemtoReg        : out std_logic_vector(2 downto 0);
        IRWrite         : out std_logic;
        ALUOpcode       : out std_logic_vector(3 downto 0);    -- opcode for ALU to add/sub/and/or/etc.
        AEn             : out std_logic;    -- for A register
        BEn             : out std_logic;    -- for B register
        ALUOutEn        : out std_logic;    -- for ALU out
        MemoryEn        : out std_logic;    -- for memory data register
        SHAMT_Selector  : out std_logic;     -- SHAMT mux selector
        multiplier_reset: out std_logic;     -- reset signal for multiplier specifically    
        
        mult_high_en : out std_logic;    -- enables called after multu is done
        mult_low_en : out std_logic
    );
end CPU_control_unit;

architecture Behavioral of CPU_control_unit is

type state_type is (s0, s1, s2, s3, s4);
signal present_state, next_state : state_type;

begin

    process(CLK, RST)
    begin
		if RST = '1' then   -- reset all the signals
            present_state <= s0;     -- go back to beginning state
        elsif (CLK'event and CLK ='1') then
            present_state <= next_state;
        end if;
    end process; 
       
    process (CLK, present_state)
    	begin
    		case present_state is
    			when s0=>   -- reset state
				    next_state <= s1;
				    -- counter <= 0;
				when s1=>			    
                    next_state <= s2;
                    -- Jump statement (can be done in 2 cycles)
                    if (Op = "000010") then
                        next_state <= s0;
                    
                    -- MFHI and MFLO
                    elsif (Op = "000000" and (instruction = "010000" or instruction = "010010")) then
                        next_state <= s0;
                        
                    end if;
                    
			    when s2 => 
			        -- I-type instructions
                    if (Op="001000" or Op="001101" or Op="001010") then
                        next_state <= s3;
                    
                    -- R-type instruction & JR (has Op = 000000) & multu
                    elsif (Op = "000000") then
                        next_state <= s3;
                        
                        if (Instruction = "001000") then
                            next_state <= s0;
                            
                        elsif (instruction = "011001") then
                            next_state <= s2;   -- if multu, stay in s2
                            
                            if (Done = '1') then -- if multiplication is done, move to next state
                                next_state <= s3;
                                
                            end if;
                        end if;
                    
                    -- J-type instruction
                    elsif (Op = "000101") then
                        next_state <= s0;
                    
                    -- LW, SW, LUI, LH
                    elsif (Op = "100011" or Op = "101011" or Op = "001111" or Op = "100001") then
                        next_state <= s3;
                    
                    -- CLO
                    elsif (Op = "011100") then
                        next_state <= s0;
                    
                    else
                        next_state <= s0;
                    end if;
                when s3 =>
                    -- I-type instruction
                    if (Op="001000" or Op="001101" or Op="001010") then
                        next_state <= s0;

                    -- r-type instruction & multu
                    elsif (Op = "000000") then
                        next_state <= s0;
                        
                    -- LW, LH
                    elsif (Op = "100011" or Op = "100001") then
                        next_state <= s4;
                    
                    -- LUI
                    elsif (Op = "001111") then
                        next_state <= s0;
                    
                    -- SW
                    elsif (Op = "101011") then
                        next_state <= s0;
                        
                    end if;
                    
                when s4 =>
                    next_state <= s0;
			end case;
	end process;
	
    -- *****************************************
    -- determine output based on state and input
    -- *****************************************
    process (present_state, Op)
    begin
        RegDst <= '0';
        PCWrite <= '0';
        PCWriteCond <= '0';
        IorD <= '0';    -- for mux
        MemWrite <= '0';
        IRWrite <= '0';
        RegWrite <= '0';
        SHAMT_Selector <= '0';
        ALUOpcode <= "0000";
        ALUSrcB <= "000";
        ALUSrcA <= "00";
        multiplier_reset <= '0';
        ALUOutEn <= '0';
        MemoryEn <= '0'; -- enable memory
        AEn <= '0';
        BEn <= '0';
        mult_high_en <= '0'; -- update mult high low registers
        mult_low_en <= '0';
        PCSource <= "00";
        MemtoReg <= "000";
          
    	case present_state is
    	    -- ####################
    	    -- ##### STATE S0 #####
    	    -- ####################
            when s0=>   -- instruction fetch. Same for all Opcodes
                IRWrite <= '1';  -- instruction register reads from memory
                -- for PC+4
                ALUSrcA <= "00"; -- address from PC
                ALUSrcB <= "001"; -- 4
                ALUOpcode <= "0100";   -- ALU opcode to tell ALU. Arithmetic (01) Signed ADD (00) to add 4 to address
                PCSource <= "00";        -- mux at the end that selects PC+4
                -- now value goes back to PC, so load
                PCWrite <= '1';
                PCWriteCond <= '1';
            
            -- ####################
    	    -- ##### STATE S1 #####
    	    -- ####################
            when s1=>   -- instruction decode                
                if (Op="001000" or Op="001101" or Op="001010") then -- I-type instructions
                    AEn <= '1'; -- enable A register
                   ALUSrcA <= "01";-- for A MUX
                   ALuSrcB <= "010";   -- for B MUX

                    RegWrite <= '0';
                    if (Op="001000") then   -- ADDI -- maybe these are for s2??
                        ALUOpcode <= "0100";    -- signed ADD
                    elsif (Op = "001101") then  -- ORI
                        ALUOpcode <= "0001";    -- OR
                    elsif (Op = "001010") then   -- SLTI
                        ALUOpcode <= "1010"; -- SLT
                    end if;

                -- r-type insturction + M instructions
                elsif (Op = "000000") then
                    AEn <= '1'; -- enable A register
                    BEn <= '1';
                    
                    -- ADDU
                    if (instruction = "100001") then
                        ALUOpcode <= "0101";
                    -- AMD
                    elsif (instruction = "100100") then
                        ALUOpcode <= "0000";
                    -- SUB
                    elsif (instruction = "100010") then
                        ALUOpcode <= "0110";
                        -- use mux to switch A and B to perform A - B
                        ALUSrcB <= "100";
                        ALUSrcA <= "10";
                    -- SRA
                    elsif (instruction = "000011") then
                        SHAMT_Selector <= '1';
                        ALUOpcode <= "1111";
                    -- SLLV
                    elsif (instruction = "000100") then
                        -- use rs to shift rt
                        SHAMT_Selector <= '0';  -- A output (4 downto 0) , 5 LSB
                        ALUOpcode <= "1100";
                    -- SLL
                    elsif (instruction = "000000") then
                        SHAMT_Selector <= '1';  -- inst 10 ~ 6
                        ALUOpcode <= "1100";
                    -- JR (Jump Register)
                    elsif (instruction = "001000") then
                        AEn <= '1';
                    -- MULTU
                    elsif (instruction = "011001") then
                       multiplier_reset <= '1'; -- reset multiplier
                    -- MFHI
                    elsif (instruction = "010000") then
                        AEn <= '0';
                        BEn <= '0';
                        RegWrite <= '1';
                        MemtoReg <= "101";
                        RegDst <= '1';
                    -- MFLO
                    elsif (instruction = "010010") then
                        AEn <= '0';
                        BEn <= '0';
                        RegWrite <= '1';
                        MemtoReg <= "110";
                        RegDst <= '1';

                    end if;
                                      
                -- J instruction
                elsif (Op = "000101" or Op = "000010") then
                    -- BNE
                    if (Op = "000101") then
                        AEn <= '1'; -- load to A and B
                        BEn <= '1';
                        RegWrite <= '1';
                        SHAMT_Selector <= '0';
                        ALUOpcode <= "0101";    -- add for new PC
                        ALUOutEn <= '1';
                        ALUSrcB <= "011";   -- use shifted offset
                    
                    -- Jump
                    elsif (Op = "000010") then
                        PCSource <= "10";
                        PCWrite <= '1';
                    end if;
                
                -- LW, SW, LUI, LH
                elsif (Op = "100011" or Op = "101011" or Op = "001111" or Op = "100001") then
                    AEn <= '1';
                    
                    if (Op = "101011") then
                        BEn <= '1'; 
                    end if;
                
                -- CLO
                elsif (Op = "011100") then
                    if (instruction = "100001") then
                        RegDst <= '1';
                        MemtoReg <= "010";
                        AEn <= '1';
                    end if;
                
                end if;
                
            -- ####################
    	    -- ##### STATE S2 #####
    	    -- ####################
            when s2=>
                
                -- I-type, execute stage
                if (Op="001000" or Op="001101" or Op="001010") then
                   --ALUSrcA <= "01";-- for A MUX
                   --ALuSrcB <= "010";   -- for B MUX
                   ALUOutEn <= '1';    -- enable ALUOut
                   
                   if (Op="001000") then   -- ADDI -- maybe these are for s2??
                        ALUOpcode <= "0100";    -- signed ADD
                    elsif (Op = "001101") then  -- ORI
                        ALUOpcode <= "0001";    -- logic OR
                    elsif (Op = "001010") then   -- SLTI
                        ALUOpcode <= "1010"; -- Comparator SLT (signed)
                    end if;
               
                elsif (Op="000000") then
                    ALUSrcA <= "01";-- for A MUX
                    ALuSrcB <= "000";   -- for B MUX
                    ALUOutEn <= '1';    -- enable ALUOut
                    
                    -- ADDU
                    if (instruction = "100001") then
                        ALUOpcode <= "0101";
                    -- AMD
                    elsif (instruction = "100100") then
                        ALUOpcode <= "0000";
                    -- SUB
                    elsif (instruction = "100010") then
                        ALUOpcode <= "0110"; -- signed SUB
                        ALUSrcA <= "10";    -- select B output
                        ALuSrcB <= "100";   -- select A output
                    -- SRA
                    elsif (instruction = "000011") then
                        SHAMT_Selector <= '1';
                        ALUOpcode <= "1111";
                    -- SLLV
                    elsif (instruction = "000100") then
                        SHAMT_Selector <= '0';
                        ALUOpcode <= "1100";
                    -- SLL
                    elsif (instruction = "000000") then
                        SHAMT_Selector <= '1';
                        ALUOpcode <= "1100";
                    -- JR (Jump Register)
                    elsif (instruction = "001000") then
                        PCSource <= "11";
                        PCWrite <= '1';
                        
                    -- MULTU (stay here until multiplication is done)
                    elsif (instruction = "011001") then
                        ALUSrcA <= "00";
                        ALUOutEn <= '0';
                        RegWrite <= '0';
                    end if;
                    
                -- J instruction
                -- BNE
                elsif (Op = "000101") then
                    
                    ALUOpcode <= "0111";    -- subtract to get zero bit
                    ALUSrcB <= "100"; -- B mux choose A b/c it's sub
                    ALUSrcA <= "10"; -- A mux choose B b/c it's add
                    PCSource <= "01";
                    PCWriteCond <= '1';
                
                -- LW, SW, LUI, LH
                elsif (Op = "100011" or Op = "101011" or Op = "001111" or Op = "100001") then

                    ALUOpcode <= "0100";    -- ADD
                    ALUOutEn <= '1';
                    ALUSrcB <= "010";   -- 2
                    ALUSrcA <= "01";    -- 1

                    if (Op = "101011") then
                        BEn <= '1';
                    end if;
                
                --CLO
                elsif (Op = "011100") then
                    if (instruction = "100001") then
                        -- set rest to 0
                        RegDst <= '1';
                        MemtoReg <= "010";
                        RegWrite <= '1';
                        
                    end if;

                end if;
            
            -- ####################
    	    -- ##### STATE S3 #####
    	    -- ####################
            when s3=>
                -- For I-type, completion stage, write back to register file
                if (Op="001000" or Op="001101" or Op="001010" or Op="000000") then

                   RegWrite <= '1'; -- write to register file  (enable register file) 
                   
                   if (Op="000000") then
                        RegDst <= '1';   -- set mux to 1 (to write to 3rd register)
                        if (instruction = "011001") then
                            mult_high_en <= '1'; -- update mult high low registers
                            mult_low_en <= '1';
                            RegWrite <= '0'; 
                        end if;
                   else
                        RegDst <= '0';
                   end if;
                        
                -- LW, LUI, LH
                elsif (Op = "100011" or Op = "001111" or Op = "100001") then
                    
                    IorD <= '1';    -- for mux
                    MemtoReg <= "000";
                    MemoryEn <= '1'; -- enable memory
                    
                    if (Op = "001111") then
                        MemtoReg <= "011";
                        RegWrite <= '1';
                        MemoryEn <= '0';
                        IorD <= '0';
                    end if;
                
                -- SW
                elsif (Op = "101011") then
                   
                    IorD <= '1';    -- for mux
                    MemWrite <= '1'; -- write to memory
                    
                end if;
            
            -- ####################
    	    -- ##### STATE S4 #####
    	    -- ####################
            when s4=>
                -- LW, LUI, LH
                if (Op = "100011" or Op = "100001") then
                    
                    MemoryEn <= '1'; -- enable memory
                    RegWrite <= '1';
                    
                    if (Op = "100011") then -- LW
                        MemtoReg <= "001";
                    elsif (Op = "100001") then  -- LH
                        MemtoReg <= "100";
                    end if;
                
                end if;
            end case;
    end process;
end Behavioral;
