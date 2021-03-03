library ieee;
use ieee.std_logic_1164.all;

entity select_color is
  
  port (
    bp1 : in  std_logic;
    bp2 : in  std_logic;
    bp3 : in  std_logic;
    couleur   : out std_logic_vector(2 downto 0)
    );

end entity select_color;

architecture behavioral of select_color is

begin  -- architecture RTL

          couleur <= "001" when (bp1 = '1' and bp2 ='0' and bp3 = '0') else -- bleu
                     "010" when (bp1 = '0' and bp2 ='1' and bp3 = '0') else -- vert
                     "100" when (bp1 = '0' and bp2 ='0' and bp3 = '1') else -- rouge
                     "110";                                                 -- jaune
end architecture behavioral;
