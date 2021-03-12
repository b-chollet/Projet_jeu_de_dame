----------------------------------------------------------------------------------
-- Company:
-- Engineer: Benjamin CHOLLET
--
-- Create Date: 12.03.2021 08:22:39
-- Design Name:
-- Module Name: mux_addr - Behavioral
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

entity mux_addr is
  Port (
  sel_mux                   : in  std_logic_vector(2 downto 0);
  e_addr_acquisition        : in  std_logic_vector(7 downto 0);
  e_addr_compteur           : in  std_logic_vector(7 downto 0);
  e_addr_check_deplacement  : in  std_logic_vector(7 downto 0);
  e_addr_check_capture      : in  std_logic_vector(7 downto 0);
  s_adresse                 : out std_logic_vector(7 downto 0)
  );
end mux_addr;

architecture Behavioral of mux_addr is

begin

    process (sel_mux)
      case sel_mux IS
          when "00"  =>  s_adresse <= e_addr_acquisition;
          when "01"  =>  s_adresse <= e_addr_compteur;
          when "10"  =>  s_adresse <= e_addr_check_deplacement;
          when "11"  =>  s_adresse <= e_addr_check_capture;
          when others => s_adresse <= e_addr_acquisition;
      end case;
    end prorcess;
end Behavioral;
