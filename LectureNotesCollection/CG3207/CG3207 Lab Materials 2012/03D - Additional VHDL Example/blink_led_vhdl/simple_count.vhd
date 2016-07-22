----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:16:19 05/25/2008 
-- Design Name: 
-- Module Name:    simple_count - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simple_count is
    Port ( clock : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (3 downto 0));
end simple_count;

architecture Behavioral of simple_count is

signal count: std_logic_vector (25 downto 0) := "00000000000000000000000000";

begin
process (clock) 
begin
   if clock='1' and clock'event then
      if enable='0' then
         count <= count + 1;
      end if;
   end if;
end process;
 
leds <= count(25 downto 22);
						
end Behavioral;

