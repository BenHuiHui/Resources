--------------------------------------------------------------------------------
-- Copyright (c) 1995-2003 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 10.1.01
--  \   \         Application : ISE
--  /   /         Filename : simple_count_tbw.vhw
-- /___/   /\     Timestamp : Sun May 25 21:38:41 2008
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: simple_count_tbw
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY simple_count_tbw IS
END simple_count_tbw;

ARCHITECTURE testbench_arch OF simple_count_tbw IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT simple_count
        PORT (
            clock : In std_logic;
            enable : In std_logic;
            led : Out std_logic_vector (3 DownTo 0)
        );
    END COMPONENT;

    SIGNAL clock : std_logic := '0';
    SIGNAL enable : std_logic := '0';
    SIGNAL led : std_logic_vector (3 DownTo 0) := "0000";

    constant PERIOD : time := 62 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 0 ns;

    BEGIN
        UUT : simple_count
        PORT MAP (
            clock => clock,
            enable => enable,
            led => led
        );

        PROCESS    -- clock process for clock
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                clock <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                clock <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

        PROCESS
            BEGIN
                -- -------------  Current Time:  207ns
                WAIT FOR 207 ns;
                enable <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  393ns
                WAIT FOR 186 ns;
                enable <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  1757ns
                WAIT FOR 1364 ns;
                enable <= '1';
                -- -------------------------------------
                WAIT FOR 305 ns;

            END PROCESS;

    END testbench_arch;

