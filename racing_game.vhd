library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test3 is
  port(clk50_in  : in std_logic;
	   E		 :	in std_logic; -- entrada de datos del serial	
	   serial_in : in std_logic;
       red_out   : out std_logic_vector (3 downto 0);
       green_out : out std_logic_vector (3 downto 0);
       blue_out  : out std_logic_vector (3 downto 0);
       hs_out    : out std_logic;
       vs_out    : out std_logic;
	   key_0	 : in std_logic;
	   key_1	 : in std_logic;
	   key_2	 : in std_logic;
	   key_3	 : in std_logic);
end test3;

architecture Behavioral of test3 is

component uart_rs232
	Port (
	

		parallel_out: out std_logic_vector(7 downto 0);
		clk,serial_in: in std_logic

				
		);
end component;


signal clk25              	: std_logic;
signal horizontal_counter 	: std_logic_vector (9 downto 0);
signal vertical_counter   	: std_logic_vector (9 downto 0);


signal sky   				: std_logic_vector (3 downto 0);
signal sky_count   			: std_logic_vector (3 downto 0);
signal offset   			: std_logic_vector (9 downto 0);
signal offset_int			: integer range 0 to 1024;
signal asdf      			: std_logic_vector (7 downto 0);
	
signal player				: std_logic_vector (9 downto 0);

signal reset				: std_logic;
signal current_bit          : integer range 0 to 9;

signal white_lineA			: std_logic_vector (9 downto 0);
signal white_lineB			: std_logic_vector (9 downto 0);
signal white_lineC			: std_logic_vector (9 downto 0);
signal white_lineD			: std_logic_vector (9 downto 0);

signal white_lineE			: std_logic_vector (9 downto 0);
signal white_lineF			: std_logic_vector (9 downto 0);
signal white_lineG			: std_logic_vector (9 downto 0);
signal white_lineH			: std_logic_vector (9 downto 0);
signal white_lineI			: std_logic_vector (9 downto 0);
signal white_lineJ			: std_logic_vector (9 downto 0);
signal white_lineK			: std_logic_vector (9 downto 0);
signal white_lineL			: std_logic_vector (9 downto 0);


signal white_objectAs		: std_logic_vector (9 downto 0);
signal white_objectAe		: std_logic_vector (9 downto 0);
signal white_objectBs		: std_logic_vector (9 downto 0);
signal white_objectBe		: std_logic_vector (9 downto 0);

signal white_objectCs		: std_logic_vector (9 downto 0);
signal white_objectCe		: std_logic_vector (9 downto 0);
signal white_objectDs		: std_logic_vector (9 downto 0);
signal white_objectDe		: std_logic_vector (9 downto 0);

signal gameover				: std_logic := '0';
begin
u1: uart_rs232 port map (parallel_out => asdf, clk => clk50_in, serial_in => serial_in);

-- generate a 25Mhz clock
clock:
process (clk50_in)
begin
	if clk50_in'event and clk50_in='1' then
		if (clk25 = '0') then
			clk25 <= '1';
		else
			clk25 <= '0';
		end if;
	end if;
end process;

draw:
process (clk25) 
begin

	
	if clk25'event and clk25 = '1' then 

		if (horizontal_counter >= "0010010000") -- 144
			and (horizontal_counter < "1100010000") -- 784
			and (vertical_counter >= "0000100111") -- 39
			and (vertical_counter < "1000000111") then -- 519 
				
				if (vertical_counter <= CONV_STD_LOGIC_VECTOR(260,10)) then --draws the sky
						if gameover = '1' then
							red_out <= sky;
							green_out <= CONV_STD_LOGIC_VECTOR(0,4);
							blue_out <= CONV_STD_LOGIC_VECTOR(0,4);
						else
							red_out <= CONV_STD_LOGIC_VECTOR(0,4);
							green_out <= CONV_STD_LOGIC_VECTOR(0,4);
							blue_out <= sky;
						end if;
					else 
						offset <= (vertical_counter - CONV_STD_LOGIC_VECTOR(240,10)) ;
						offset_int <= CONV_INTEGER(offset);
						
						if (horizontal_counter + offset > CONV_STD_LOGIC_VECTOR(464,10) - player and
							horizontal_counter < CONV_STD_LOGIC_VECTOR(464,10) - player + offset) then
								if (horizontal_counter + (offset_int / 10) > CONV_STD_LOGIC_VECTOR(464,10) - player and
									horizontal_counter < CONV_STD_LOGIC_VECTOR(464,10) - player + (offset_int / 10)) 
									then
										
										
											
											if (vertical_counter > white_lineA and vertical_counter < white_lineB) or 
												  (vertical_counter > white_lineC and vertical_counter < white_lineD) or
												  (vertical_counter > white_lineE and vertical_counter < white_lineF) or 
												  (vertical_counter > white_lineG and vertical_counter < white_lineH) or 
												  (vertical_counter > white_lineK and vertical_counter < white_lineL) 
												then
												red_out <= CONV_STD_LOGIC_VECTOR(15,4);
												green_out <= CONV_STD_LOGIC_VECTOR(15,4);
												blue_out <= CONV_STD_LOGIC_VECTOR(15,4);
											
										end if;
									elsif (vertical_counter < (white_objectAe + (offset_int / 20)) and vertical_counter > white_objectAs and
											horizontal_counter < CONV_STD_LOGIC_VECTOR(464,10) - player) then
											
												red_out <= CONV_STD_LOGIC_VECTOR(1,4);
												green_out <= CONV_STD_LOGIC_VECTOR(1,4);
												blue_out <= CONV_STD_LOGIC_VECTOR(1,4);
									elsif (vertical_counter < (white_objectBe + (offset_int / 20)) and vertical_counter > white_objectBs and
											horizontal_counter < CONV_STD_LOGIC_VECTOR(464,10) - player) then
											
												red_out <= CONV_STD_LOGIC_VECTOR(1,4);
												green_out <= CONV_STD_LOGIC_VECTOR(1,4);
												blue_out <= CONV_STD_LOGIC_VECTOR(1,4);
												
									elsif (vertical_counter < (white_objectCe + (offset_int / 20)) and vertical_counter > white_objectCs and
											horizontal_counter > CONV_STD_LOGIC_VECTOR(464,10) - player) then
											
												red_out <= CONV_STD_LOGIC_VECTOR(1,4);
												green_out <= CONV_STD_LOGIC_VECTOR(5,4);
												blue_out <= CONV_STD_LOGIC_VECTOR(1,4);
									elsif (vertical_counter < (white_objectDe + (offset_int / 20)) and vertical_counter > white_objectDs and
											horizontal_counter > CONV_STD_LOGIC_VECTOR(464,10) - player) then
											
												red_out <= CONV_STD_LOGIC_VECTOR(1,4);
												green_out <= CONV_STD_LOGIC_VECTOR(5,4);
												blue_out <= CONV_STD_LOGIC_VECTOR(5,4);
									else
										
												red_out <= CONV_STD_LOGIC_VECTOR(7,4);
												green_out <= CONV_STD_LOGIC_VECTOR(7,4);
												blue_out <= CONV_STD_LOGIC_VECTOR(7,4);
										
								end if;
							else
								red_out <= CONV_STD_LOGIC_VECTOR(0,4);
								green_out <= CONV_STD_LOGIC_VECTOR(15,4);
								blue_out <= CONV_STD_LOGIC_VECTOR(0,4);
						end if;
						
						if  (horizontal_counter < CONV_STD_LOGIC_VECTOR(540,10)) and
							(horizontal_counter > CONV_STD_LOGIC_VECTOR(380,10)) and
							(vertical_counter < CONV_STD_LOGIC_VECTOR(485,10)) and
						    (vertical_counter > CONV_STD_LOGIC_VECTOR(450,10)) then 
						
														red_out <= CONV_STD_LOGIC_VECTOR(15,4);
														green_out <= CONV_STD_LOGIC_VECTOR(0,4);
														blue_out <= CONV_STD_LOGIC_VECTOR(0,4);
							elsif (horizontal_counter < CONV_STD_LOGIC_VECTOR(420,10)) and
							  (horizontal_counter > CONV_STD_LOGIC_VECTOR(390,10)) and
							(vertical_counter < CONV_STD_LOGIC_VECTOR(505,10)) and
						    (vertical_counter > CONV_STD_LOGIC_VECTOR(485,10)) then 
								red_out <= CONV_STD_LOGIC_VECTOR(0,4);
								green_out <= CONV_STD_LOGIC_VECTOR(0,4);
								blue_out <= CONV_STD_LOGIC_VECTOR(0,4);
							elsif (horizontal_counter < CONV_STD_LOGIC_VECTOR(530,10)) and
							  (horizontal_counter > CONV_STD_LOGIC_VECTOR(500,10)) and
							(vertical_counter < CONV_STD_LOGIC_VECTOR(505,10)) and
						    (vertical_counter > CONV_STD_LOGIC_VECTOR(485,10)) then 
								red_out <= CONV_STD_LOGIC_VECTOR(0,4);
								green_out <= CONV_STD_LOGIC_VECTOR(0,4);
								blue_out <= CONV_STD_LOGIC_VECTOR(0,4);	
						end if;
						
						
				end if;
			else
				red_out <= CONV_STD_LOGIC_VECTOR(0,4);
				green_out <= CONV_STD_LOGIC_VECTOR(0,4);
				blue_out <= CONV_STD_LOGIC_VECTOR(0,4);
		end if;
	
		if (horizontal_counter > "0000000000" ) and (horizontal_counter < "0001100001" ) then -- 96+1
				hs_out <= '0';
			else
				hs_out <= '1';
		end if;

		if (vertical_counter > "0000000000" ) and (vertical_counter < "0000000011" ) then -- 2+1
				vs_out <= '0';
			else
				vs_out <= '1';
		end if;

		horizontal_counter <= horizontal_counter+"0000000001"; 
		
		if (horizontal_counter="1100100000") then --800
			vertical_counter <= vertical_counter+"0000000001";
			horizontal_counter <= "0000000000";
			
			if (vertical_counter >= "0000100111") then
				sky_count <= sky_count + "0001";
				
				if (sky_count = "1111") then
					sky <= sky + "0001";
				end if;
			end if;
			
		end if;
		
		if (vertical_counter="1000001001") then		 --521   
		
			vertical_counter <= "0000000000";
			sky <= "0000";
			sky_count <= "0000";
			if (key_1 = '1') then

			white_lineA <= white_lineA + CONV_STD_LOGIC_VECTOR(1,10);
			white_lineB <= white_lineA + CONV_STD_LOGIC_VECTOR(150,10);
			white_lineC <= white_lineB + CONV_STD_LOGIC_VECTOR(30,10);
			white_lineD <= white_lineC + CONV_STD_LOGIC_VECTOR(150,10);
			
			white_lineE <= white_lineD + CONV_STD_LOGIC_VECTOR(30,10);
			white_lineF <= white_lineE + CONV_STD_LOGIC_VECTOR(150,10);
			white_lineG <= white_lineF + CONV_STD_LOGIC_VECTOR(30,10);
			white_lineH <= white_lineG + CONV_STD_LOGIC_VECTOR(150,10);
			white_lineI <= white_lineH + CONV_STD_LOGIC_VECTOR(30,10);
			white_lineJ <= white_lineI + CONV_STD_LOGIC_VECTOR(150,10);
			white_lineK <= white_lineJ + CONV_STD_LOGIC_VECTOR(30,10);
			white_lineL <= white_lineK + CONV_STD_LOGIC_VECTOR(150,10);
				
			white_objectAs <= white_objectAs + CONV_STD_LOGIC_VECTOR(1,10);
			white_objectAe <= white_objectAs + CONV_STD_LOGIC_VECTOR(20,10);
			white_objectBs <= white_objectAe + CONV_STD_LOGIC_VECTOR(500,10);
			white_objectBe <= white_objectBs + CONV_STD_LOGIC_VECTOR(20,10);
			
			white_objectCs <= white_objectAs + CONV_STD_LOGIC_VECTOR(250,10);
			white_objectCe <= white_objectCs + CONV_STD_LOGIC_VECTOR(20,10);
			white_objectDs <= white_objectCe + CONV_STD_LOGIC_VECTOR(500,10);
			white_objectDe <= white_objectDs + CONV_STD_LOGIC_VECTOR(20,10);
			
			if (white_objectAs < CONV_STD_LOGIC_VECTOR(485,10) and white_objectAe > CONV_STD_LOGIC_VECTOR(450,10) and
			    380 < CONV_STD_LOGIC_VECTOR(464,10) - player) then
				gameover <= '1';
			end if;
			
			if (white_objectBs < CONV_STD_LOGIC_VECTOR(485,10) and white_objectBe > CONV_STD_LOGIC_VECTOR(450,10) and
			    380 < CONV_STD_LOGIC_VECTOR(464,10) - player) then
				gameover <= '1';
			end if;
			
			if (white_objectCs < CONV_STD_LOGIC_VECTOR(485,10) and white_objectCe > CONV_STD_LOGIC_VECTOR(450,10) and
			    540 > CONV_STD_LOGIC_VECTOR(464,10) - player) then
				gameover <= '1';
			end if;
			
			if (white_objectDs < CONV_STD_LOGIC_VECTOR(485,10) and white_objectDe > CONV_STD_LOGIC_VECTOR(450,10) and
			    540 > CONV_STD_LOGIC_VECTOR(464,10) - player) then
				gameover <= '1';
			end if;
				if (key_2 = '0') then
					reset <= '1';
					gameover <= '0';
					player <= CONV_STD_LOGIC_VECTOR(0,10);
				end if;
				
				if (key_0 = '0') then
					--if player < CONV_STD_LOGIC_VECTOR(75,10) then
						player <= player + CONV_STD_LOGIC_VECTOR(1,10);
					--else 
						--player <= CONV_STD_LOGIC_VECTOR(74,10);
					--end if;
				
				
				elsif (key_3 = '0') then
					--if player > CONV_STD_LOGIC_VECTOR(-75,10) then
						player <= player - CONV_STD_LOGIC_VECTOR(1,10);
					--else
						--player <= CONV_STD_LOGIC_VECTOR(-74,10);
					--end if;
				end if;

				
			end if;
		end if;
		
		
				if (asdf = "01000000") then
					if player < CONV_STD_LOGIC_VECTOR(75,10) then
						player <= player + CONV_STD_LOGIC_VECTOR(1,10);
					else 
						player <= CONV_STD_LOGIC_VECTOR(74,10);
					end if;
				
				
				elsif (asdf = "00100000") then
					if player > CONV_STD_LOGIC_VECTOR(-75,10) then
						player <= player - CONV_STD_LOGIC_VECTOR(1,10);
					else
						player <= CONV_STD_LOGIC_VECTOR(-74,10);
					end if;
				end if;
				
		--if (current_bit > 0 and current_bit < 9) then
			--asdf(current_bit) <= serial_in;
		--end if;
		--current_bit <= current_bit + 1;
		--if (current_bit = 9) then
			
			
			
			
			--current_bit <= 0;
		--end if;
		
				
				
	end if;
end process;

end Behavioral;