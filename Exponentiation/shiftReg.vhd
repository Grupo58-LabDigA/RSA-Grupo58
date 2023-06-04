library IEEE;
use IEEE.std_logic_1164.all;

entity shiftReg is 
	generic (
        wordSize : natural := 8
    );
    port (
    	clock: in std_logic ;
        load_initial: in std_logic;
        initial: in std_logic_vector (wordSize - 1 downto 0);
        q: out std_logic_vector (wordSize - 1 downto 0)
    );
    
end shiftReg;

architecture shiftReg_arch of shiftReg is 

begin 
	process (clock, reset) 
  	begin
      if load_initial = '1' then 
      	q <= initial;
      elsif clock = '1' and clock'event then 
      	q <= "0" & q(wordSize - 1 downto 1);
      end if;
  end process;
  
end shiftReg_arch;