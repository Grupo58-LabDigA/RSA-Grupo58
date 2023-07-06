# Circuito de desencriptação RSA
Esse é repositório de desenvolvimento do projeto final da disciplina de Laboratório Digital A, ministrada na Escola Politécnica.

O circuito foi testado seguindo os passos abaixo.
  1. Instalar o programa de desenvolvimento Intel Quartus Prime.
  2. Criar um projeto e incluir todos os arquivos .vhd desse repositório.
  3. Instalar o software TeraTerm no computador e configurar uma transmissão serial com Baud Rate de 115200, 8 bits e 1 bit de parada.
  4. Conectar um conversor FT232RL em uma porta USB do computador.
  5. Conectar com jumpers os terminais GND, Rx e Tx do conversor nos terminais GPIO da FPGA.
  6. Associar os sinais do componente Top.
  6.1 o serial_in tem que ser conectado no mesmo pino que o Tx do conversor.
  6.2 serial_out no mesmo pino do Rx do conversor.
  6.3 os sinais transmission_finished, start_transmission_to_pc têm que ser cada um conectado em um push button da FPGA.
  7. Executar o arquivo receiver.py da pasta 128Bit_Keys com Python3 e seguir as instruções na tela do terminal
  8. Adicionar os parâmetros da chave privada no componente Top
  9.  Sintetizar o circuito e enviá-lo para uma placa DE0-CV.
  10. Executar o arquivo sender.py em outra janela do terminal.
  11. Digitar a mensagem encriptada no terminal do TeraTerm.
  12. Pressionar o botão do transmission_finished.
  13. Pressionar o botão do start_transmission_to_pc.
  14. Copiar a o valor calculado pela FPGA para o terminal do programa receiver.py para trsnaformá-la em uma formato legível.

  
