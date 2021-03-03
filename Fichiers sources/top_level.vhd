----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 14:31:39
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is

 Port (clk : in std_logic;
       rst : in std_logic;
       bp1 : in std_logic;
       bp2 : in std_logic;
       bp3 : in std_logic;
       VGA_hs : out std_logic;
       VGA_vs : out std_logic;
       VGA_red      : out std_logic_vector(3 downto 0);   -- red output
       VGA_green    : out std_logic_vector(3 downto 0);   -- green output
       VGA_blue     : out std_logic_vector(3 downto 0)   -- blue output

        );
end top_level;

architecture Behavioral of top_level is

component VGA_bitmap_160x100 is
   port(clk          : in  std_logic;
       reset        : in  std_logic;
       VGA_hs       : out std_logic;   -- horisontal vga syncr.
       VGA_vs       : out std_logic;   -- vertical vga syncr.
       VGA_red      : out std_logic_vector(3 downto 0);   -- red output
       VGA_green    : out std_logic_vector(3 downto 0);   -- green output
       VGA_blue     : out std_logic_vector(3 downto 0);   -- blue output
       ADDR         : in  std_logic_vector(13 downto 0);
       data_in      : in  std_logic_vector(2 downto 0);
       data_write   : in  std_logic;
       data_out     : out std_logic_vector(2 downto 0));

end component;

component select_color is  
  port (
    bp1 : in  std_logic;
    bp2 : in  std_logic;
    bp3 : in  std_logic;
    couleur   : out std_logic_vector(2 downto 0)
    );
end component;

component compteur is
  Port ( clk : in std_logic; 
         rst : in std_logic;
         valeur : out std_logic_vector (13 downto 0)
         );
end component;


signal data_write : std_logic;
signal ADDR : std_logic_vector(13 downto 0);
signal data_in : std_logic_vector(2 downto 0);
signal data_out : std_logic_vector(2 downto 0);
signal rst_not : std_logic;

begin

TOP : VGA_bitmap_160x100 
port map (clk => clk,
          reset => rst_not,
          VGA_hs       => VGA_hs,
          VGA_vs       => VGA_vs,
          VGA_red      => VGA_red,
          VGA_green    => VGA_green,
          VGA_blue     => VGA_blue,
          ADDR         => ADDR,
          data_in      => data_in,
          data_write   => data_write,
          data_out     => data_out
          );

CPT : compteur
port map (clk => clk,
          rst => rst_not,
          valeur => ADDR
          );
          
Sel_color : select_color
port map(bp1 => bp1,
         bp2 => bp2,
         bp3 =>bp3,
         couleur => data_in
         );
         
rst_not <= not(rst);
data_write <= '1';

end Behavioral;
