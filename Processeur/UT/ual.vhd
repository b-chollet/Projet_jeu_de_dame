----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2021 13:48:02
-- Design Name: 
-- Module Name: ual - Behavioral
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

entity ual is
 Port ( 
     clk                        : in  std_logic;
     rst                        : in  std_logic;
     ce                         : in  std_logic;
     code_op                    : in  std_logic_vector(1 downto 0);
     current_player             : in  std_logic;
     addr_pos_actuelle          : in  std_logic_vector(7 downto 0);
     addr_pos_souhaitee         : in  std_logic_vector(7 downto 0);
     men_data_pos_actuelle      : in  std_logic_vector(6 downto 0);
     men_data_pos_souhaitee     : in  std_logic_vector(6 downto 0);
     men_new_data_pos_actuelle  : out std_logic_vector(6 downto 0);
     men_new_data_pos_souhaitee : out std_logic_vector(6 downto 0)
             );
end ual;

architecture Behavioral of ual is

signal pos_actuelle,pos_souhaitee, result_b_9, result_b_11, result_n_9, result_n_11 : signed(7 downto 0);

begin
    
 pos_actuelle  <= signed(addr_pos_actuelle);
 pos_souhaitee <= signed(addr_pos_souhaitee);
 result_b_9    <= pos_actuelle-9;
 result_b_11   <= pos_actuelle-11;
 result_n_9    <= pos_actuelle+9;
 result_n_11   <= pos_actuelle+11;

 ual : process (clk, rst) is
 
   begin
   
    if rst = '1' then -- remise à zéros
      men_new_data_pos_actuelle  <= "0000000";
      men_new_data_pos_souhaitee <= "0000000";
      
    elsif clk'event and clk = '1' then
       if ce ='1' then
           if code_op = "10" and current_player = '0' and result_b_9 = pos_souhaitee and men_data_pos_souhaitee = "0000000"  then
                men_new_data_pos_actuelle <= men_data_pos_souhaitee;
                men_new_data_pos_souhaitee<= men_data_pos_actuelle;
           elsif code_op = "10" and current_player = '0' and result_b_11 = pos_souhaitee and men_data_pos_souhaitee = "0000000" then
                men_new_data_pos_actuelle <= men_data_pos_souhaitee;
                men_new_data_pos_souhaitee<= men_data_pos_actuelle;
           elsif code_op = "10" and current_player = '1' and result_n_9 = pos_souhaitee and men_data_pos_souhaitee = "0000000" then
                men_new_data_pos_actuelle <= men_data_pos_souhaitee;
                men_new_data_pos_souhaitee<= men_data_pos_actuelle;
           elsif code_op = "10" and current_player = '1' and result_n_11 = pos_souhaitee and men_data_pos_souhaitee = "0000000" then
                men_new_data_pos_actuelle <= men_data_pos_souhaitee;
                men_new_data_pos_souhaitee<= men_data_pos_actuelle;
            end if;
       end if;
    end if;
   end process ual ;



end Behavioral;
