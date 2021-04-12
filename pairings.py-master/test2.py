import bn256
    
msg="hello".encode('utf-8')

# Get public key and random private key
priv,pub = bn256.g2_random()

print("Message:\t",msg)
print("\n======================")
print("Private key:\t",priv)
print("Public key:\t",pub)


# Get signature
pt = bn256.g1_hash_to_point(msg)

assert pt.is_on_curve()
sig=bn256.g1_compress(pt.scalar_mul(priv))

print("\n======================")
print("\nPoint for message (Pt):\t",pt)
print("Signature (p x Pt): ",sig)


# Verify signature

unsig = bn256.g1_uncompress(sig)

assert type(pub) == bn256.curve_twist
assert type(unsig) == bn256.curve_point

msg_pt = bn256.g1_hash_to_point(msg)

assert msg_pt.is_on_curve()

# print("\n======================")
# # public key 跟 h0(meg)
# print("\npub(priv*p2):\t",pub)
# print("msg_pt(h0(msg)*p1): ",msg_pt)
# # G2 跟 signature 
# print("\nbn256.twist_G(p2):\t",bn256.twist_G)
# print("unsig(priv*h0(msg)*p1): ",unsig)

fsk1_oi = 1
sk1_j = 2
fpk1_oi = bn256.g1_scalar_base_mult(fsk1_oi)
pk1_j = bn256.g1_scalar_base_mult(sk1_j)

ri1 = 3
ri2 = 4
ri3 = 5

rj1 = 6
rj2 = 7
rj3 = 8

kw = "section".encode("utf-8")

Ci1 = bn256.twist_G.scalar_mul(ri1).scalar_mul(ri2)
Ci2 = bn256.g1_add(bn256.g1_hash_to_point(kw).scalar_mul(ri1).scalar_mul(ri2), bn256.g1_scalar_base_mult(ri3))

Cj1 = bn256.twist_G.scalar_mul(rj1).scalar_mul(rj2)
Cj2 = bn256.g1_add(bn256.g1_hash_to_point(kw).scalar_mul(rj1).scalar_mul(rj2), bn256.g1_scalar_base_mult(rj3))

Tioj = bn256.g1_scalar_base_mult(ri1*ri2*fsk1_oi*sk1_j - ri3)
Tjio = bn256.g1_scalar_base_mult(rj1*rj2*sk1_j*fsk1_oi - rj3)

TCi = bn256.g1_add(Ci2,Tioj)
TCj = bn256.g1_add(Cj2,Tjio)

rtn1 = bn256.optimal_ate(Ci1, TCj)
rtn2 = bn256.optimal_ate(Cj1, TCi)

print("\n======================")
# public key 跟 h0(meg)
print("\nCi1:\t",Ci1)
print("TCj: ",TCj)
# G2 跟 signature 
print("\nCj1:\t",Cj1)
print("TCi: ",TCi)

if (rtn1 == rtn2):
	print("verified")
else:
	print("not verified")

print(hex(11559732032986387107991004021392285783925812861821192530917403151452391805634))
print(hex(10857046999023057135944570762232829481370756359578518086990519993285655852781))
print(hex(4082367875863433681332203403145435568316851327593401208105741076214120093531))
print(hex(8495653923123431417604973247489272438418190587263600148770280649306958101930))