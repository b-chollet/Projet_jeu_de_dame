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
  clk                   : in  std_logic;
  rst                   : in  std_logic;
  e_data                : in std_logic_vector(7 downto 0);  -- Donnée envoyée par la mémoire par l'adresse actuelle
  e_bp                  : in  std_logic_vector(4 downto 0); -- Bit croisant : droite, gauche, bas, haut  centre
  s_RW_mem              : out std_logic;                    -- Lecture/ecriture de la mémoire
  s_activation_memoire  : out std_logic;                    -- Activation de la R/W de la mémoire
  s_fin_acquisition     : out std_logic;
  s_data                : out std_logic_vector(7 downto 0); -- Donnée à envoyé à la mémoire
  s_adresse             : out std_logic_vector(7 downto 0)  -- Adresse à laquelle envoyé la donnée en mémoire
  );
end acquisition;

architecture Behavioral of acquisition is

-- Déclaration des états de la FSM
TYPE state IS (init,wait_push_b,load_mem,write_mem, calculate_new_addr);
SIGNAL next_state, current_state : state;

signal save_button           : std_logic_vector(4 downto 0);
signal save_addr, new_addr   : signed (7 downto 0);
signal cpt, etat_calculate   : std_logic;
signal activation_adresse   : std_logic;

begin

  FSM : process (clk, rst) is
      begin
        if rst = '1' then
            current_state     <= init;
            
        elsif clk'event and clk = '1' then
                current_state <= next_state;
        end if;
  end process FSM;


  process (clk, e_bp, cpt,e_data ) is
    begin
      case current_state is
        when init =>
          next_state <= wait_push_b;

        when wait_push_b =>
          if e_bp /= "00000" and e_bp'event then
            next_state <= load_mem;
          else
            next_state <= wait_push_b;
          end if;

        when load_mem =>
          if e_data'event then 
            next_state <= write_mem;
          else 
            next_state <= load_mem;
          end if;

        when write_mem =>
          if cpt = '1' then
            next_state <= wait_push_b;
          elsif cpt = '0' then
            next_state <= calculate_new_addr;
          else
            next_state <= write_mem;
          end if;

        when calculate_new_addr =>
            if activation_adresse ='1' then 
                next_state <= load_mem;
            else 
                next_state <= calculate_new_addr;
            end if;

        when others => null;
      end case;
  end process;

  etat_fsm : process(current_state,cpt,etat_calculate,new_addr,save_addr,activation_adresse)
    begin
      case current_state is
        when init =>
        -- On init tous les paramètres
          save_addr            <= x"63";
          save_button          <= (others => '0');
          s_RW_mem             <= '0';
          s_activation_memoire <= '0';
          cpt                  <= '0';
          s_data               <= "00000000";
          s_adresse            <= "00000000";
          s_fin_acquisition    <= '0';
          etat_calculate       <= '0';

        when wait_push_b =>
        -- On remet à zéros cpt, et on attend l'appuie sur un bouton
          if cpt ='1' then
            cpt               <= not(cpt);
            s_fin_acquisition <= '1';
          end if;
          s_activation_memoire <= '0'; -- A voir avec Adri
          s_RW_mem             <= '0';

        when load_mem =>
        -- On affecte l'adresse sauvegardée à la sortie pour pouvoir lire en mémoire, le bloc associé
        -- /!\ il faut attendre d'avoir reçu le "bloc" avant de passer à l'état suivant, voir ligne 78
          save_button          <= e_bp;
          s_adresse            <= std_logic_vector(save_addr);
          s_RW_mem             <= '0'; -- Norlamement, lecture
          s_activation_memoire <= '1'; -- A voir avec Adri
          s_fin_acquisition    <= '0';
          s_fin_acquisition    <= '1';

        when write_mem =>
        -- On écrit en mémoire le nouveau bloc
          -- Case blanche vierge    : X'00'
          -- Case noire vierge      : X'01'
          -- Pion marron            : X'02'
          -- Dame marron            : X'03'
          -- Pion blanc             : X'04'
          -- Dame blanche           : X'05'
          -- Sélection case blanche : X'06'
          -- Sélection case noire   : X'07'
          -- Sélection pion marron  : X'08'
          -- Sélection dame marron  : X'09'
          -- Sélection pion blanc   : X'0A'
          -- Sélection dame blanche : X'0B'
          case e_data is
            when X"00" =>
              s_data               <= X"06";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when X"01" =>
              s_data               <= X"07";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when X"02" =>
              s_data               <= X"08";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when X"03" =>
              s_data               <= X"09";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when X"04" =>
              s_data               <= X"0A";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when X"05" =>
              s_data               <= X"0B";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when X"06" =>
              s_data               <= X"00";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when X"07" =>
              s_data               <= X"01";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when X"08" =>
              s_data               <= X"02";
              s_RW_mem             <= '1'; -- Norlamement, lecture
            when X"09" =>
              s_data               <= X"03";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when X"0A" =>
              s_data               <= X"04";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when X"0B" =>
              s_data               <= X"05";
              s_RW_mem             <= '1'; -- Norlamement, écriture
            when others =>
              s_RW_mem             <= '0'; -- Norlamement, écriture
          end case ;

        when calculate_new_addr =>
            etat_calculate       <= '1';
            s_activation_memoire <= '0';
            s_RW_mem             <= '0';
            cpt                  <= '1';
            if activation_adresse = '1' then
                save_addr          <= new_addr;
                s_adresse          <= std_logic_vector(new_addr);
                etat_calculate     <= '0';
            end if;

        when others => null;
      end case;

  end process etat_fsm;


    process (rst, clk,etat_calculate)
    begin
        if rst ='1' then 
           new_addr           <= x"63";
           activation_adresse <= '0';

        elsif clk'event and clk ='1' then
            if etat_calculate ='1' then
             case save_button is
               when "00001"  =>
                   if (new_addr + 1 )mod 10 = 0 then
                       new_addr <= new_addr - 9;
                   else
                       new_addr <= new_addr + 1;
                   end if;
                   activation_adresse <= '1';
               when "00010"  =>
                   if new_addr  mod 10 = 0 then
                       new_addr <= new_addr + 9;
                   else
                       new_addr <= new_addr - 1;
                   end if;
                   activation_adresse <= '1';
               when "00100"  =>
                   if (89 < new_addr) and (new_addr < 100) then
                       new_addr <= new_addr - 90;
                   else
                       new_addr <= new_addr + 10;
                   end if;
                   activation_adresse <= '1';
               when "01000"  =>
                   if -1 < new_addr and new_addr < 10 then
                       new_addr <= new_addr + 90;
                   else
                       new_addr <= new_addr - 10;
                   end if;
                   activation_adresse <= '1';                  
               when others   =>
                 new_addr <= new_addr;
                 activation_adresse <= '1';
             end case;
             
             else 
                activation_adresse <= '0';

           end if; 
        end if;
    end process;

end Behavioral;
