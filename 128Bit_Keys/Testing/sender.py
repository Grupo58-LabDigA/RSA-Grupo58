public_N = int(0xc606855ebb5577efe2c3494fb4923b3b)
public_e = int(0x10001)

message = "ola colega".encode('ascii')
message = int.from_bytes(message)
#print(message.hex())

encrypted = pow(message ,public_e,public_N)
print("Encrypted message:", hex(encrypted))
