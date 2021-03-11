----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Benjamin CHOLLET
-- 
-- Create Date: 11.03.2021 14:35:00
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

entity compteur_0_99 is
 Port ( 
     clk             : in  std_logic;
     rst             : in  std_logic;
     e_ce            : in  std_logic;
     e_raz_cpt       : in  std_logic;
     e_check_capture : in  std_logic;
     s_cpt           : out std_logic_vector(7 downto 0)
             );
end compteur_0_99;

architecture Behavioral of compteur_0_99 is


begin

process(rst, clk) 
    variable cpt : integer range 0 to 99;
    begin
    if rst = '1' then
        cpt := 0;
    elsif clk'event and clk = '1' then 
        if e_ce = '1' and e_check_capture = '1' then
            if cpt = 99 then 
                cpt := 0;
            else  
                cpt := cpt + 1;
            end if;
        end if;
    end if;
    
s_cpt <= std_logic_vector(to_unsigned(cpt,8));

end process;

end Behavioral;
