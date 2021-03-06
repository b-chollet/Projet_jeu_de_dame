-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 2.3.2021 14:21:32 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_compteur is
end tb_compteur;

architecture tb of tb_compteur is

    component compteur
        port (clk    : in std_logic;
              rst    : in std_logic;
              valeur : out std_logic_vector (13 downto 0));
    end component;

    signal clk    : std_logic;
    signal rst    : std_logic;
    signal valeur : std_logic_vector (13 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : compteur
    port map (clk    => clk,
              rst    => rst,
              valeur => valeur);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 1000000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_compteur of tb_compteur is
    for tb
    end for;
end cfg_tb_compteur;