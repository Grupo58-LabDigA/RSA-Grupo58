public_N = int(0xae69e757382013da213a32f3a0e986c1)
public_e = int(0x10001)

message = "ola colega".encode('ascii')
message = int.from_bytes(message)
#print(message.hex())

encrypted = pow(message ,public_e,public_N)
print("Encrypted message:", hex(encrypted))

print(hex(message))
