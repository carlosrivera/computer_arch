library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test3 is
  port(clk50_in  : in std_logic;
       red_out   : out std_logic;
       green_out : out std_logic;
       blue_out  : out std_logic;
       hs_out    : out std_logic;
       vs_out    : out std_logic;
      key_0    : in std_logic;
      key_1    : in std_logic;
      key_2    : in std_logic;
      key_3    : in std_logic);
end test3;

architecture Behavioral of test3 is

signal clk25               : std_logic;
signal horizontal_counter  : std_logic_vector (9 downto 0);
signal vertical_counter    : std_logic_vector (9 downto 0);

signal paddle_x      : std_logic_vector (9 downto 0);
signal ball_pos_x     : std_logic_vector (9 downto 0);
signal ball_pos_y     : std_logic_vector (9 downto 0);
signal ball_dir_x     : std_logic_vector (9 downto 0);
signal ball_dir_y     : std_logic_vector (9 downto 0);

signal reset    : std_logic;
begin


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

  if (horizontal_counter >= "0010010000" ) -- 144
   and (horizontal_counter < "1100010000" ) -- 784
   and (vertical_counter >= "0000100111" ) -- 39
   and (vertical_counter < "1000000111" ) then -- 519 
    
    if (paddle_x <= horizontal_counter + CONV_STD_LOGIC_VECTOR(44,10)) and
                  (paddle_x + CONV_STD_LOGIC_VECTOR(44,10) >= horizontal_counter) and
                  (CONV_STD_LOGIC_VECTOR(484,10) <= vertical_counter + CONV_STD_LOGIC_VECTOR(8,10)) and
                  (CONV_STD_LOGIC_VECTOR(484,10) + CONV_STD_LOGIC_VECTOR(8,10) >= vertical_counter ) then
    
      red_out <= '0';
      green_out <= '1';
      blue_out <= '1';
      
     elsif ('0' & ball_pos_x <= horizontal_counter + CONV_STD_LOGIC_VECTOR(8,10)) and
        (ball_pos_x + CONV_STD_LOGIC_VECTOR(8,10) >= '0' & horizontal_counter) and
        ('0' & ball_pos_y <= vertical_counter + CONV_STD_LOGIC_VECTOR(8,10)) and
        (ball_pos_y + CONV_STD_LOGIC_VECTOR(8,10) >= '0' & vertical_counter ) then
     
      red_out <= '1';
      green_out <= '1';
      blue_out <= '0';
      
     elsif (horizontal_counter < "0010011010" ) or -- 154
      (horizontal_counter >= "1100000110" ) or -- 774
      (vertical_counter < "0000110001" ) then -- 49
    
      red_out <= '1';
      green_out <= '1';
      blue_out <= '1';
    
     else
      red_out <= '0';
      green_out <= '0';
      blue_out <= '1';
    end if;
   else
    red_out <= '0';
    green_out <= '0';
    blue_out <= '0';
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
  end if;
  
  if (vertical_counter="1000001001") then   --521   
  
   vertical_counter <= "0000000000";
   
   if (key_1 = '1') then
    if  ('0' & ball_pos_y) >= CONV_STD_LOGIC_VECTOR(476,10) and
     ('0' & ball_pos_y) <= CONV_STD_LOGIC_VECTOR(486,10) and
     (ball_pos_x >= paddle_x - CONV_STD_LOGIC_VECTOR(44,10)) and
     (ball_pos_x <= paddle_x + CONV_STD_LOGIC_VECTOR(44,10)) then
      ball_dir_y <= not CONV_STD_LOGIC_VECTOR(4,10);
     elsif ball_pos_y <= CONV_STD_LOGIC_VECTOR(64,10) then
      ball_dir_y <= CONV_STD_LOGIC_VECTOR(4,10);
    end if;
    
    if ('0' & ball_pos_x) >= CONV_STD_LOGIC_VECTOR(774,10) - CONV_STD_LOGIC_VECTOR(8,10) then
      ball_dir_x <= not CONV_STD_LOGIC_VECTOR(4,10);
     elsif ball_pos_x <= CONV_STD_LOGIC_VECTOR(170,10) then
      ball_dir_x <= CONV_STD_LOGIC_VECTOR(4,10);
    end if;
    
    -- Compute next ball Y position
    ball_pos_y <= ball_pos_y + ball_dir_y;
    ball_pos_x <= ball_pos_x + ball_dir_x;
    
    if (key_2 = '0') then
     reset <= '1';
    end if;
    
    if (key_0 = '0') then
     paddle_x <= paddle_x + CONV_STD_LOGIC_VECTOR(4,10);
    end if;
    
    if (key_3 = '0') then
     paddle_x <= paddle_x + not CONV_STD_LOGIC_VECTOR(4,10);
    end if;
    
    if (paddle_x <= CONV_STD_LOGIC_VECTOR(178,10)) then
      paddle_x <= CONV_STD_LOGIC_VECTOR(179,10);
     elsif ('0' & paddle_x) >= CONV_STD_LOGIC_VECTOR(730,10) then
      paddle_x <= CONV_STD_LOGIC_VECTOR(729,10);
    end if;
   end if;
  end if;
 end if;
end process;

end Behavioral;