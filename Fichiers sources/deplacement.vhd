----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Benjamin CHOLLET
-- 
-- Create Date: 17.03.2021 14:25:26
-- Design Name: 
-- Module Name: deplacement - Behavioral
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

entity deplacement is
 Port ( 
    clk                 : in  std_logic;
    rst                 : in  std_logic;
    current_player      : in  std_logic;  -- '0' -> blanc, sinon noir
    enable              : in  std_logic;  -- activation du bloc par la FSM principale
    e_pos_actuelle      : in  std_logic_vector(15 downto 0);
    e_pos_souhaitee     : in  std_logic_vector(15 downto 0);
    s_new_pos_actuelle  : out std_logic_vector(15 downto 0);
    e_new_pos_souhaitee : out std_logic_vector(15 downto 0)
 );
end deplacement;

architecture Behavioral of deplacement is

-- Déclaration des états de la FSM
TYPE state IS (init,wait_enable,calculate_pos, write_mem);
SIGNAL next_state, current_state : state;

-- 8 premiers bits : correspond à l'addrese A
-- 8 derniers bits : données contenue à l'adresse A
signal addr_a, addr_s, data_a, data_s, new_data_a, new_data_s : std_logic_vector (7 downto 0);
signal bloc_a, bloc_s                                         : std_logic_vector (7 downto 0);
signal result                                                 : signed(7 downto 0);
signal calculate, recopie_bloc                                : std_logic;

begin
addr_a <= e_pos_actuelle (15 downto 8);
addr_s <= e_pos_souhaitee(15 downto 8);
data_a <= e_pos_actuelle (7 downto 0);
data_s <= e_pos_souhaitee(7 downto 0);

-- Calcul de la distance entre les deux cases 
result <= abs(signed(addr_a) - signed(addr_s));

   FSM : process (clk, rst) is
   begin
      if rst = '1' then
         current_state     <= init; 
      elsif clk'event and clk = '1' then
         current_state <= next_state;
      end if;
  end process FSM;

    process(clk, enable, result)
    begin 
        case current_state is
            when init =>
              next_state <= wait_enable;
                
            when wait_enable =>
                if enable ='1' then 
                  next_state <= calculate_pos;
                else 
                  next_state <= wait_enable;
                end if;
                
            when calculate_pos =>
                next_state <= write_mem;
              
            when write_mem =>
               if enable = '0' then 
                    next_state <= wait_enable;
               else 
                    next_state <= write_mem;
               end if;
               
            when others => null;
        end case;
    end process;
    
   etat_fsm : process(current_state,enable)
   begin
        case current_state is
            when init =>
                -- Assignation de l'adresse aux deux signaux de sorties
                s_new_pos_actuelle (15 downto 8) <= addr_a;
                e_new_pos_souhaitee(15 downto 8) <= addr_s; 
                s_new_pos_actuelle (7 downto 0)  <= (others=> '0');
                e_new_pos_souhaitee (7 downto 0) <= (others=> '0');
                calculate                        <= '0';
                recopie_bloc                     <= '0';
                
             when wait_enable =>
                s_new_pos_actuelle (15 downto 8) <= addr_a;
                e_new_pos_souhaitee(15 downto 8) <= addr_s; 
                s_new_pos_actuelle (7 downto 0)  <= (others=> '0');
                e_new_pos_souhaitee (7 downto 0) <= (others=> '0');
                calculate                        <= '0';
                recopie_bloc                     <= '0';

                
            when others => null;
        end case;
   end process;

    process (clk,rst, 
end Behavioral;
