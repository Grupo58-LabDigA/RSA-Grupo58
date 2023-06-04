library ieee;
use ieee.numeric_bit.all;

entity exponentiation is
    generic (
      n : positive := 8
    );
    port (
        clock, enable : in bit;
        load_initials: in bit;
        E : in bit_vector(n-1 downto 0);
        B : in bit_vector(n-1 downto 0);
        Result : out bit_vector(2*n-1 downto 0) -- arrumar tamanho
    );
  end entity exponentiation;

  architecture Behavioral of exponentiation is

    component Multiplier is
      generic (
        n : positive := 8
      );
      port (
        A : in bit_vector(n-1 downto 0);
        B : in bit_vector(n-1 downto 0);
        Result : out bit_vector(2*n-1 downto 0)
      );
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

  component shiftReg is 
	generic (
        wordSize : natural := 8
    );
    port (
    	clock: in bit ;
        load_initial: in bit;
        initial: in bit_vector (wordSize - 1 downto 0);
        saida: out bit_vector (wordSize - 1 downto 0)
    );
  end component;


      signal fator1: bit_vector(n-1 downto 0);
      signal fator2: bit_vector(n-1 downto 0);
      signal produto: bit_vector(2*n-1 downto 0);

      signal um: bit_vector(n-1 downto 0);
      signal um_maior: bit_vector(2*n-1 downto 0);
      signal input_reg1: bit_vector(n-1 downto 0);
      signal input_reg2: bit_vector(n-1 downto 0);
      signal saida_desloc: bit_vector(n-1 downto 0);
      
      
		
      signal fator12: bit_vector(2*n-1 downto 0);
      signal fator22: bit_vector(2*n-1 downto 0);
      
      signal input_reg3: bit_vector(2*n-1 downto 0);
      
      signal produto2: bit_vector(4*n - 1 downto 0);
      
		
    begin

     input_reg1 <= B when load_initials = '1' else
        			produto(n-1 downto 0);
      reg1: reg generic map (n) port map (clock, '0', '1' ,input_reg1, fator1);            
               

      um(n-1 downto 1) <= (others => '0');
      um(0) <= '1';
      
      input_reg2 <= um when load_initials = '1' else 
                    produto(n-1 downto 0);

      reg2: reg generic map (n) port map (clock, '0', '1' ,input_reg2, fator2);

      mult1: Multiplier generic map (n) port map (fator1, fator2, produto);

      reg_desloc: shiftReg generic map(n) port map (clock, load_initials, E, saida_desloc);

      fator22 <= um_maior when saida_desloc(0) = '0' else
                  produto;

	  um_maior(2*n-1 downto 1) <= (others => '0');
      um_maior(0) <= '1';


      input_reg3 <= um_maior when load_initials = '1' else 
                    produto2(2*n - 1 downto 0);
                    
      reg3: reg generic map (2*n) port map (clock, '0', '1' ,input_reg3, fator12);

      mult2: Multiplier generic map (2*n) port map(fator12, fator22, produto2);

      Result <= produto2(2*n - 1 downto 0);
    end architecture Behavioral;