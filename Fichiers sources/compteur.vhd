------------------------------------------------
------------------------------------------------
-- Fichier permettant de compter de 0 à 15. On peut incrementer ou decrementer suivant
-- le sens donne en entree. 
------------------------------------------------
------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity compteur is
  Port ( clk : in std_logic; 
         rst : in std_logic;
         valeur : out std_logic_vector (13 downto 0)
         );
end compteur;

architecture Behavioral of compteur is

    signal compteur  : unsigned ( 13 downto 0);

begin

    process (clk, rst)
        begin    
            if rst = '1' then
                compteur <= (others => '0');
                
            elsif clk'event and clk = '1' then
                if compteur = x"3E7F" then
                    compteur <= (others => '0');
                else
                compteur <= compteur + 1;
                end if;
            end if;
        valeur <= std_logic_vector(compteur);
        end process;
end Behavioral;
