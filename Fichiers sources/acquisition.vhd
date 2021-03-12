----------------------------------------------------------------------------------
-- Company:
-- Engineer: Benjamin CHOLLET
--
-- Create Date: 11.03.2021 14:59:39
-- Design Name:
-- Module Name: acquisition - Behavioral
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

entity acquisition is
  Port (
  clk          : in  std_logic;
  rst          : in  std_logic;
  e_bp         : in  std_logic_vector(4 downto 0); -- bit croisant : droite, gauche, bas, haut  centre
  s_adresse    : out std_logic_vector(7 downto 0)
  );
end acquisition;

architecture Behavioral of acquisition is

begin

process (rst, clk)

variable addr : integer range 0 to 99;

begin
    if rst = '1' then
      s_adresse <= x"00";
      addr := 99; --A définir la case par défaut

    elsif clk'event and clk ='1' then
        case e_bp IS
            when "10001"  =>
                if (addr + 1) mod 10 = 0 then
                    addr := addr - 9;
                else
                    addr := addr + 1;
                end if;
                s_adresse <= std_logic_vector(to_unsigned(addr,8));
            when "10010"  =>
                if addr  mod 10 = 0 then
                    addr := addr + 9;
                else
                    addr := addr - 1;
                end if;
                s_adresse <= std_logic_vector(to_unsigned(addr,8));
            when "10100"  =>
                if (89 < addr) and (addr < 100) then
                    addr := addr - 90;
                else
                    addr := addr + 10;
                end if;
                s_adresse <= std_logic_vector(to_unsigned(addr+10,8));
            when "11000"  =>
                if (-1 < addr) and (addr < 10) then
                    addr := addr + 90;
                else
                    addr := addr - 10;
                end if;
                s_adresse <= std_logic_vector(to_unsigned(addr,8));
            when others   =>
              s_adresse <= std_logic_vector(to_unsigned(addr,8));
        end case;
    end if;
end process;

end Behavioral;
