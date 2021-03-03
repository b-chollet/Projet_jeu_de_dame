----------------------------------------------------------------------------------
-- Company:
-- Engineer: Benjamin CHOLLET
--
-- Create Date: 24.02.2021 10:18:53
-- Design Name:
-- Module Name: regsitre - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registre is
  Port (
    clk        : in  std_logic;
    rst        : in  std_logic;
    ce         : in  std_logic;
    load_reg   : in  std_logic;
    entree     : in  std_logic_vector (6 downto 0);
    sortie     : out std_logic_vector (6 downto 0)
  );
end registre;

architecture Behavioral of registre is

begin

 sync : process (clk, rst) is

 begin

     if rst = '1' then -- remise ? z?ros
       sortie <= x"00";

     elsif clk'event and clk = '1' then
        if ce ='1' then
            if load_reg = '1' then
                sortie <= entree;
             end if;
        end if;
     end if;
 end process sync;

end Behavioral;
