library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

-- this package consists of constants to replace binary vectors
-- to aid in easy comprehensibility of the code.

package constants is
    constant ALU_OPC_NONE   : std_logic_vector (3 downto 0) := "0000";
    constant ALU_OPC_ADD    : std_logic_vector (3 downto 0) := "0001";
    constant ALU_OPC_SUB    : std_logic_vector (3 downto 0) := "0010";
    constant ALU_OPC_DEC    : std_logic_vector (3 downto 0) := "0011";
    constant ALU_OPC_ADC    : std_logic_vector (3 downto 0) := "0100";
    constant ALU_OPC_INC    : std_logic_vector (3 downto 0) := "0101";
    constant ALU_OPC_NOT    : std_logic_vector (3 downto 0) := "0110";
    constant ALU_OPC_AND    : std_logic_vector (3 downto 0) := "0111";
    constant ALU_OPC_XOR    : std_logic_vector (3 downto 0) := "1000";
    constant ALU_OPC_OR     : std_logic_vector (3 downto 0) := "1001";
    constant ALU_OPC_NEG    : std_logic_vector (3 downto 0) := "1010";
    constant ALU_OPC_SBB    : std_logic_vector (3 downto 0) := "1011";
 
    constant xE0  : std_logic_vector (7 downto 0) := "11100000";    -- ACC
    constant xF0    : std_logic_vector (7 downto 0) := "11110000";  -- B
    constant x83  : std_logic_vector (7 downto 0) := "10000011";    -- DPH
    constant x82  : std_logic_vector (7 downto 0) := "10000010";    -- DPL
    constant xA8   : std_logic_vector (7 downto 0) := "10101000";   -- IE
    constant xB8   : std_logic_vector (7 downto 0) := "10111000";   -- IP
    constant x80   : std_logic_vector (7 downto 0) := "10000000";   -- P0
    constant x90   : std_logic_vector (7 downto 0) := "10010000";   -- P1
    constant xA0   : std_logic_vector (7 downto 0) := "10100000";   -- P2
    constant xB0   : std_logic_vector (7 downto 0) := "10110000";   -- P3
    constant x87 : std_logic_vector (7 downto 0) := "10000111";     -- PCON
    constant xD0  : std_logic_vector (7 downto 0) := "11010000";    -- PSW
    constant x99 : std_logic_vector (7 downto 0) := "10011001";     -- SBUF
    constant x98 : std_logic_vector (7 downto 0) := "10011000";     -- SCON
    constant x8C  : std_logic_vector (7 downto 0) := "10001100";    -- TH0
    constant x8D  : std_logic_vector (7 downto 0) := "10001101";    -- TH1
    constant x81   : std_logic_vector (7 downto 0) := "10000001";   -- SP
    constant x88 : std_logic_vector (7 downto 0) := "10001000";     -- TCON
    constant x8A  : std_logic_vector (7 downto 0) := "10001010";    -- TL0
    constant x8B  : std_logic_vector (7 downto 0) := "10001011";    -- TL1
    constant x89 : std_logic_vector (7 downto 0) := "10001001";     -- TMOD
    		   
    constant BYTE	    : std_logic := '0';
    constant WORD	    : std_logic := '1';
         
--    ...and any other constants  you wish to define

end constants;

