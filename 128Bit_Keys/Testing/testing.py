import rsa

#Receiver
(pubkey, privkey) = rsa.newkeys(128)
public_N = privkey.n
private_d = privkey.d

#print(privkey)

#Sender 

message = "ola colega".encode('ascii')
print(message)
message = int.from_bytes(message)
#print(message.hex())

public_N = pubkey.n
public_e = pubkey.e
encrypted = pow(message ,public_e,public_N)


#Receiver
decrypted = pow(encrypted,private_d,public_N)


print(decrypted == message)