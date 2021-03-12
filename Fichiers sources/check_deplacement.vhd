----------------------------------------------------------------------------------
-- Company:
-- Engineer: Benjamin CHOLLET
--
-- Create Date: 03.03.2021 13:48:02
-- Design Name:
-- Module Name: check_deplacement - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity check_deplacement is
 Port (
     clk                        : in  std_logic;
     rst                        : in  std_logic;
     current_player             : in  std_logic;
     e_enable_d                 : in  std_logic;
     e_position_actuelle        : in  std_logic_vector(15 downto 0); -- adresse + donnée de la case actuelle
     e_position_souhaitee       : in  std_logic_vector(15 downto 0); -- adresse + donnée de la case souhaitée
     s_new_position_actuelle    : out std_logic_vector(15 downto 0);
     s_new_position_souhaitee   : out std_logic_vector(15 downto 0); -- adresse + donnée de la case souhaitée
     s_R_memoire                : out std_logic
             );
end check_deplacement;

architecture Behavioral of check_deplacement is

-- cureent_player
--    '0' -> blanc
--    '1' -> marron

-- case blanche X'0' -- case noire X'1'

-- pion marron X’2’ -- dame marron  X’3’
-- pion blanc  X’4’ -- dame blanche X’5’

-- sélection case noire X'7'

-- sélection pion marron X'8' -- sélection dame marron  X'9'
-- sélection pion blqnc  X'A' -- sélection dame blanche X'A'


signal addr_pos_a, addr_pos_s, data_pos_a, data_pos_s, result : std_logic_vector(7 downto 0);

begin

addr_pos_a <= e_position_actuelle  (15 downto 8);
addr_pos_s <= e_position_souhaitee (15 downto 8);
data_pos_a <= e_position_actuelle  (7 downto 0);
data_pos_s <= e_position_souhaitee (7 downto 0);
result     <= std_logic_vector(abs(signed(addr_pos_a) - signed(addr_pos_s)));

  process (clk, rst)

  if rst = '1' then
    s_new_position_actuelle  <= (others => '0');
    e_new_position_souhaitee <= (others => '0');
    s_R_memoire <= '0';

  elsif clk'event and clk = '1' then
    case data_pos_a is
      when x"02" =>
        if current_player = '1' and (result = x"09") or (result = x"0B") and data_pos_s = X"01" then
            s_new_position_actuelle(15 downto 8) <= addr_pos_a;
            s_new_position_actuelle(7 downto 0)  <= x"01";

            s_new_position_souhaitee(15 downto 8)<= data_pos_s;
            s_new_position_souhaitee(7 downto 0) <= x"08";
            s_R_memoire <= '1';
        end if;
      when x"03" =>
        if current_player = '1' and (result = x"09") or (result = x"0B") and data_pos_s = X"01" then
            s_new_position_actuelle(15 downto 8) <= addr_pos_a;
            s_new_position_actuelle(7 downto 0)  <= x"01";

            s_new_position_souhaitee(15 downto 8)<= data_pos_s;
            s_new_position_souhaitee(7 downto 0) <= x"09";
            s_R_memoire <= '1';
        end if;
      when x"04" =>
        if current_player = '0' and (result = x"09") or (result = x"0B") and data_pos_s = X"01" then
            s_new_position_actuelle(15 downto 8) <= addr_pos_a;
            s_new_position_actuelle(7 downto 0)  <= x"01";

            s_new_position_souhaitee(15 downto 8)<= data_pos_s;
            s_new_position_souhaitee(7 downto 0) <= x"0A";
            s_R_memoire <= '1';
        end if;
      when x"05" =>
        if current_player = '0' and (result = x"09") or (result = x"0B") and data_pos_s = X"01" then
            s_new_position_actuelle(15 downto 8) <= addr_pos_a;
            s_new_position_actuelle(7 downto 0)  <= x"01";

            s_new_position_souhaitee(15 downto 8)<= data_pos_s;
            e_new_ps_new_position_souhaiteeosition_souhaitee(7 downto 0) <= x"0B";
            s_R_memoire <= '1';
        end if;
      when others =>
      s_new_position_actuelle  <= e_position_actuelle;
      e_new_position_souhaitee <= s_new_position_souhaitee;
      s_R_memoire <= '0';
    end case;
  end if;
  end process;


end Behavioral;
