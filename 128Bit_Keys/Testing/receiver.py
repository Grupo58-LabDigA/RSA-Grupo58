#This code must be run by whoever will receive the message
import rsa

#Receiver
(pubkey, privkey) = rsa.newkeys(128)
public_N = pubkey.n
public_e = pubkey.e

print("Publicar esses dois valores")
print("public N: ", hex(public_N))
print("public e: ", hex(public_e))

private_d = privkey.d
print("Colocar esses dois valores na FPGA")
print("public N: ", hex(public_N))
print("private d: ", hex(private_d))

hex_string = input("Digite o numero calculado pela FPGA \n")

hex_pairs = [hex_string[i:i+2] for i in range(0, len(hex_string), 2)]

# Convert each pair of characters to ASCII and join them into a new string
readable_string = ''.join(chr(int(pair, 16)) for pair in hex_pairs)

print(readable_string)


