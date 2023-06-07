library IEEE;
use IEEE.numeric_bit.all;
--use IEEE.bit_1164.all; 


 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

component modmult is
	Generic (MPWID: integer := 32);
    Port ( mpand : in bit_vector(MPWID-1 downto 0);
           mplier : in bit_vector(MPWID-1 downto 0);
           modulus : in bit_vector(MPWID-1 downto 0);
           product : out bit_vector(MPWID-1 downto 0);
           clk : in bit;
			  ds : in bit;
			  reset : in bit;
			  ready : out bit);
end component;


	signal mpand_in, mplier_in, modulus_in, product_out: bit_vector (15 downto 0);
    signal ds_in, reset_in, ready_out: bit;

    
-- DUT component


constant clockPeriod : time := 2 ns; -- clock period
signal keep_simulating: bit := '0'; -- interrompe simulação 
signal clk_in: bit; -- se construção alternativa do clock

begin
	clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  -- Connect DUT
  DUT: modmult generic map(16)
           port map(mpand_in, mplier_in, modulus_in, product_out, clk_in, ds_in, reset_in, ready_out);
  
  process
  begin
  
  	assert false report "Test start." severity note;
    keep_simulating <= '1';
    ds_in <= '0';
    
    mpand_in <= "0000000000000100";
    mplier_in <= "0000000111100100";
    modulus_in <= "0000000111110001";
    
    reset_in <= '1';
    
    wait for 2 ns;
    --ds_in <= '0';
    reset_in <= '0';
   
   
    wait for 1 ns;
    
    ds_in <= '1';
    
    wait until ready_out = '1';
    
    
    
    wait for 10 ns;
    

    assert(false) report "Fail 0+0" severity error;
    
	keep_simulating <= '0';
    
    -- Informa fim do teste
    assert false report "Test done." severity note;
    wait; -- Interrompe execução
 
  end process;
end tb;