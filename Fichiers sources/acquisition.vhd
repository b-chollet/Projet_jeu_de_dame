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
  s_data                : out std_logic_vector(7 downto 0); -- Donnée à envoyé à la mémoire
  s_adresse             : out std_logic_vector(7 downto 0)  -- Adresse à laquelle envoyé la donnée en mémoire
  );
end acquisition;

architecture Behavioral of acquisition is

-- Déclaration des états de la FSM
TYPE state IS (init,wait_push_b,load_mem,write_mem, calculate_new_addr);
SIGNAL next_state, current_state : state;

signal save_button                     : std_logic_vector(4 downto 0);
signal save_addr, new_addr             : unsigned (7 downto 0);

signal cpt                             : std_logic;

begin

  FSM : process (clk, rst) is
      begin
        if rst = '1' then
            current_state <= init;
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
          if e_bp /= "00000" then
            next_state <= load_mem;
          else
            next_state <= wait_push_b;
          end if;

        when load_mem =>
          next_state <= write_mem;

        when write_mem =>
          if cpt = '1' then
            next_state <= wait_push_b;
          else
            next_state <= write_mem;
          end if;

          if e_data'event then
            next_state <= calculate_new_addr;
          else
            next_state <= write_mem;
          end if;

        when calculate_new_addr =>
            next_state <= calculate_new_addr;

        when others => null;
      end case;
  end process;

  etat_fsm : process(current_state)
    begin
      case current_state is
        when init =>
        -- On init tous les paramètres
          save_addr   <= "99";
          new_addr    <= "99";
          save_button <= (others => '0');
          cpt         <= '0';

        when wait_push_b =>
        -- On remet à zéros cpt, et on attend l'appuie sur un bouton
          cpt         <= '0';


        when load_mem =>
        -- On affecte l'adresse sauvegardée à la sortie pour pouvoir lire en mémoire, le bloc associé
        -- /!\ il faut attendre d'avoir reçu le "bloc" avant de passer à l'état suivant, voir ligne 78
          save_button          <= e_bp;
          s_adresse            <= save_addr;
          s_RW_mem             <= '0'; -- Norlamement, lecture
          s_activation_memoire <= '1'; -- A voir avec Adri

        when write_mem =>
        -- On écrit en mémoire le nouveau bloc
          -- Case blanche vierge    : X'0'
          -- Case noire vierge      : X'1'
          -- Pion marron            : X'2'
          -- Dame marron            : X’3’
          -- Pion blanc             : X’4’
          -- Dame blanche           : X’5’
          -- Sélection case blanche : X'6'
          -- Sélection case marron  : X'7'
          -- Sélection pion marron  : X'8'
          -- Sélection dame marron  : X'9'
          -- Sélection pion blanc   : X'A'
          -- Sélection dame blanche : X'B'
          case save_button is
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
          case save_button is
            when "00001"  =>
                if (signed(new_addr) + 1) mod 10 = 0 then
                    signed(new_addr) := signed(new_addr) - 9;
                else
                    signed(new_addr) := signed(new_addr) + 1;
                end if;
                s_adresse <= std_logic_vector(new_addr);
            when "00010"  =>
                if signed(new_addr)  mod 10 = 0 then
                    signed(new_addr) := signed(new_addr) + 9;
                else
                    signed(new_addr) := signed(new_addr) - 1;
                end if;
                s_adresse <= std_logic_vector(new_addr);
            when "00100"  =>
                if (89 < signed(new_addr)) and (signed(new_addr) < 100) then
                    signed(new_addr) := signed(new_addr) - 90;
                else
                    signed(new_addr) := signed(new_addr) + 10;
                end if;
                s_adresse <= std_logic_vector(new_addr);
            when "01000"  =>
                if (-1 < signed(new_addr)) and (signed(new_addr) < 10) then
                    signed(new_addr) := signed(new_addr) + 90;
                else
                    signed(new_addr) := signed(new_addr) - 10;
                end if;
                s_adresse <= std_logic_vector(new_addr);
            when others   =>
              s_adresse <= std_logic_vector(new_addr);
          end case;

          s_activation_memoire <= '0';
          save_addr            <= new_addr;
          cpt                  <= '1';

        when others => null;
      end case;

  end process etat_fsm;

end Behavioral;






process (rst, clk)

variable addr : integer range 0 to 99;

begin
    if rst = '1' then
      s_adresse <= x"00";
      s_data    <= x"00";
      addr := 99; -- A définir la case par défaut

    elsif clk'event and clk ='1' then
        case e_bp IS
            when "00001"  =>
                if (addr + 1) mod 10 = 0 then
                    addr := addr - 9;
                else
                    addr := addr + 1;
                end if;
                s_adresse <= std_logic_vector(to_unsigned(addr,8));
            when "00010"  =>
                if addr  mod 10 = 0 then
                    addr := addr + 9;
                else
                    addr := addr - 1;
                end if;
                s_adresse <= std_logic_vector(to_unsigned(addr,8));
            when "00100"  =>
                if (89 < addr) and (addr < 100) then
                    addr := addr - 90;
                else
                    addr := addr + 10;
                end if;
                s_adresse <= std_logic_vector(to_unsigned(addr+10,8));
            when "01000"  =>
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
