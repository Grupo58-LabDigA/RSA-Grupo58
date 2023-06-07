----------------------------------------------------------------------
----																					----
---- Modular Multiplier						 									----
---- RSA Public Key Cryptography IP Core 									----
---- 																					----
---- This file is part of the BasicRSA project 							----
---- http://www.opencores.org/			 									----
---- 																					----
---- To Do: 																		----
---- - Speed and efficiency improvements									----
---- - Possible revisions for good engineering/coding practices	----
---- 																					----
---- Author(s): 																	----
---- - Steven R. McQueen, srmcqueen@opencores.org 						----
---- 																					----
----------------------------------------------------------------------
---- 																					----
---- Copyright (C) 2003 Steven R. McQueen       						----
---- 																					----
---- This source file may be used and distributed without 			----
---- restriction provided that this copyright statement is not 	----
---- removed from the file and that any derivative work contains 	----
---- the original copyright notice and the associated disclaimer. ----
---- 																					----
---- This source file is free software; you can redistribute it 	----
---- and/or modify it under the terms of the GNU Lesser General 	----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.1 of the License, or (at your option) any 	----
---- later version. 																----
---- 																					----
---- This source is distributed in the hope that it will be 		----
---- useful, but WITHOUT ANY WARRANTY; without even the implied 	----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 		----
---- PURPOSE. See the GNU Lesser General Public License for more 	----
---- details. 																		----
---- 																					----
---- You should have received a copy of the GNU Lesser General 	----
---- Public License along with this source; if not, download it 	----
---- from http://www.opencores.org/lgpl.shtml 							----
---- 																					----
----------------------------------------------------------------------
--
-- CVS Revision History
--
-- $Log: not supported by cvs2svn $
--
 
-- This module implements the modular multiplier for the RSA Public Key Cypher. It expects 
-- to receive a multiplicand on th MPAND bus, a multiplier on the MPLIER bus, and a modulus
-- on the MODULUS bus. The multiplier and multiplicand must have a value less than the modulus.
--
-- A Shift-and-Add algorithm is used in this module. For each bit of the multiplier, the
-- multiplicand value is shifted. For each '1' bit of the multiplier, the shifted multiplicand
-- value is added	to the product. To ensure that the product is always expressed as a remainder
-- two subtractions are performed on the product, P2 = P1-modulus, and P3 = P1-(2*modulus).
-- The high-order bits of these results are used to determine whether P sould be copied from
-- P1, P2, or P3. 
--
-- The operation ends when all '1' bits in the multiplier have been used.
--
-- Comments, questions and suggestions may be directed to the author at srmcqueen@mcqueentech.com.
 
 
library IEEE;
use IEEE.numeric_bit.all;
 
--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity modmult is
	Generic (MPWID: integer := 32);
    Port ( mpand : in bit_vector(MPWID-1 downto 0);
           mplier : in bit_vector(MPWID-1 downto 0);
           modulus : in bit_vector(MPWID-1 downto 0);
           product : out bit_vector(MPWID-1 downto 0);
           clk : in bit;
			  ds : in bit;
			  reset : in bit;
			  ready : out bit);
end modmult;
 
architecture modmult1 of modmult is
 
signal mpreg: bit_vector(MPWID-1 downto 0);
signal mcreg, mcreg1, mcreg2: bit_vector(MPWID+1 downto 0);
signal modreg1, modreg2: bit_vector(MPWID+1 downto 0);
signal prodreg, prodreg1, prodreg2, prodreg3, prodreg4: bit_vector(MPWID+1 downto 0);
 
--signal count: integer;
signal modstate: bit_vector(1 downto 0);
signal first: bit;
 
begin
 
	-- final result...
	product <= prodreg4(MPWID-1 downto 0);
 
	-- add shifted value if place bit is '1', copy original if place bit is '0'
	with mpreg(0) select
		prodreg1 <= bit_vector(unsigned(prodreg) + unsigned(mcreg)) when '1',
						prodreg when others;
 
	-- subtract modulus and subtract modulus * 2.
	prodreg2 <= bit_vector(unsigned(prodreg1) - unsigned(modreg1));
	prodreg3 <= bit_vector(unsigned(prodreg1) - unsigned(modreg2));
 
	-- negative results mean that we subtracted too much...
	modstate <= prodreg3(mpwid+1) & prodreg2(mpwid+1);
 
	-- select the correct modular result and copy it....
	with modstate select
		prodreg4 <= prodreg1 when "11",
						prodreg2 when "10",
						prodreg3 when others;
 
	-- meanwhile, subtract the modulus from the shifted multiplicand...
	mcreg1 <= bit_vector(unsigned(mcreg) - unsigned(modreg1));
 
	-- select the correct modular value and copy it.
	with mcreg1(MPWID) select
		mcreg2 <= mcreg when '1',
					 mcreg1 when others;
 
	ready <= first;
 
	combine: process (clk, first, ds, mpreg, reset) is
 
	begin
 
		if reset = '1' then
			first <= '1';
		elsif rising_edge(clk) then
			if first = '1' then
			-- First time through, set up registers to start multiplication procedure
			-- Input values are sampled only once
				if ds = '1' then
					mpreg <= mplier;
					mcreg <= "00" & mpand;
					modreg1 <= "00" & modulus;
					modreg2 <= '0' & modulus & '0';
					prodreg <= (others => '0');
					first <= '0';
				end if;
			else
			-- when all bits have been shifted out of the multiplicand, operation is over
			-- Note: this leads to at least one waste cycle per multiplication
				if (unsigned(mpreg) = 0) then
					first <= '1';
				else
				-- shift the multiplicand left one bit
					mcreg <= mcreg2(MPWID downto 0) & '0';
				-- shift the multiplier right one bit
					mpreg <= '0' & mpreg(MPWID-1 downto 1);
				-- copy intermediate product
					prodreg <= prodreg4;
				end if;
			end if;
		end if;
 
	end process combine;
 
end modmult1;

library IEEE;
use ieee.numeric_bit.all;

entity reg is 
	generic (
        wordSize : natural := 8
    );
    port (
    	clock: in bit ;
        reset: in bit;
        load: in bit;
        d: in bit_vector (wordSize - 1 downto 0);
        q: out bit_vector (wordSize - 1 downto 0)
    );
    
end reg;

architecture reg_arch of reg is 
   
begin 
	process (clock, reset) 
  	begin
      if reset = '1' then 
      	q <= (others => '0');
      elsif clock = '1' and clock'event and load = '1' then 
      	q <= d;
        
      end if;
  end process;
  
end reg_arch;

library ieee;
use ieee.numeric_bit.all;

entity Adder is
    generic (
        n : positive := 8
      );
    port (
        a : in bit_vector(n-1 downto 0);
        b : in bit_vector(n-1 downto 0);
        result : out bit_vector (n - 1 downto 0)
    );
end entity Adder;

architecture Behavioral of Adder is
	 signal input_1: unsigned(n-1 downto 0);
    signal input_2: unsigned(n-1 downto 0);
    signal result1: unsigned(n-1 downto 0);

	begin
    input_1 <= unsigned(a);
    input_2 <= unsigned(b);
    result1 <= input_1+input_2;
    result <= bit_vector(result1);
end architecture;

library ieee;
use ieee.numeric_bit.all;

entity ModularExponentiation is
    generic (
        n : positive := 8
      );
    port (
    	clk: in bit;
        reset: in bit;
        b : in bit_vector(n-1 downto 0);
        e : in bit_vector(n-1 downto 0);
        m : in bit_vector(n-1 downto 0);
        result : out bit_vector (n-1 downto 0);
        done : out bit

    );
end entity ModularExponentiation;

architecture Behavioral of ModularExponentiation is
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

    component reg is 
      generic (
        wordSize : natural := 8
    );
    port (
    	  clock: in bit ;
        reset: in bit;
        load: in bit;
        d: in bit_vector (wordSize - 1 downto 0);
        q: out bit_vector (wordSize - 1 downto 0)
    );
      
    end component;

    component Adder is
        generic (
            n : positive := 8
          );
        port (
            a : in bit_vector(n-1 downto 0);
            b : in bit_vector(n-1 downto 0);
            result : out bit_vector (n - 1 downto 0)
        );
    end component;

    signal input_elinha, elinha, soma, input_c, c, produto, um: bit_vector (n-1 downto 0);
    signal pronto_para_multiplicar, start_mult, load_elinha, not_clk: bit;

    type state_type is (inicial, aumenta_elinha, multiplicando, atualiza_c,terminou);
    signal c_state, next_state: state_type;

	begin

    next_state <= 
                inicial when (reset = '1') else
                aumenta_elinha when ((c_state = inicial and reset = '0') or 
                					(c_state = atualiza_c and elinha /= e)) else
                multiplicando when ((c_state = multiplicando and pronto_para_multiplicar = '0') or 
                					c_state = aumenta_elinha) else
                atualiza_c when (c_state = multiplicando and pronto_para_multiplicar = '1') else
                terminou when (c_state = atualiza_c and (elinha = e));
    
    input_elinha <= (others => '0') when c_state = inicial else
                	soma when c_state = aumenta_elinha else 
                    elinha;
	
    
    input_c <= um when c_state = inicial else
                produto when c_state = atualiza_c else 
                c;

    start_mult <= '1' when (c_state = multiplicando) else
                  '0';

    done <= '1' when (c_state = terminou) else
            '0';

	not_clk <= not clk;
    fsm: process(not_clk)
    begin
        if rising_edge(not_clk) then
        c_state <= next_state;
        end if;
    end process;
    
    um(n-1 downto 1) <= (others => '0');
    um(0) <= '1';
    adder1: Adder generic map(n) port map (elinha, um , soma);
    
    reg_elinha: reg generic map (n) port map (clk, '0', '1', input_elinha, elinha);

    reg_c: reg generic map (n) port map (clk, '0', '1', input_c, c);
    
    
    multiplier: modmult generic map(n) port map (c, b, m , produto, clk, start_mult, reset, pronto_para_multiplicar);

	result <= c;

end architecture;