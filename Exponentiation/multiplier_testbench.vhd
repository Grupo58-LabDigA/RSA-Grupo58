library IEEE;
use IEEE.numeric_bit.all;
use ieee.std_logic_1164.ALL;

 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

component Multiplier is
    port (
        a : in std_logic_vector(7 downto 0);
        b : in std_logic_vector( 7 downto 0);
        result : out std_logic_vector (15 downto 0)
    );
end component;


	signal i1: std_logic_vector(7 downto 0);
    signal i2: std_logic_vector(7 downto 0);
    signal r: std_logic_vector(15 downto 0);

begin
  -- Connect DUT
 	DUT: Multiplier port map (i1, i2, r);
  
  process
  begin
  
  	assert false report "Test start." severity note;
    
	i1 <= "00000011" ;
    i2 <= "00000010";
    
    
    
    wait for 2 ns;
    
    assert(r = "0000000000000110") report "Fail 0+0" severity error;
   

    -- Informa fim do teste
    assert (true) report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;