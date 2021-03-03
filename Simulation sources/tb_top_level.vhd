
library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (clk       : in std_logic;
              rst       : in std_logic;
              bp1       : in std_logic;
              bp2       : in std_logic;
              bp3       : in std_logic;
              VGA_hs    : out std_logic;
              VGA_vs    : out std_logic;
              VGA_red   : out std_logic_vector (3 downto 0);
              VGA_green : out std_logic_vector (3 downto 0);
              VGA_blue  : out std_logic_vector (3 downto 0));
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal bp1       : std_logic;
    signal bp2       : std_logic;
    signal bp3       : std_logic;
    signal VGA_hs    : std_logic;
    signal VGA_vs    : std_logic;
    signal VGA_red   : std_logic_vector (3 downto 0);
    signal VGA_green : std_logic_vector (3 downto 0);
    signal VGA_blue  : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top_level
    port map (clk       => clk,
              rst       => rst,
              bp1       => bp1,
              bp2       => bp2,
              bp3       => bp3,
              VGA_hs    => VGA_hs,
              VGA_vs    => VGA_vs,
              VGA_red   => VGA_red,
              VGA_green => VGA_green,
              VGA_blue  => VGA_blue);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        bp1 <= '1';
        bp2 <= '0';
        bp3 <= '0';

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '0';
        wait for 100 ns;
        rst <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 10000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;