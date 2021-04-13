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
print("\nTCj: ",TCj)
# G2 跟 signature 
print("\nCj1:\t",Cj1)
print("\nTCi: ",TCi)

if (rtn1 == rtn2):
	print("\nsignature verified")
else:
	print("\nsignature not verified")

curve_order = 21888242871839275222246405745257275088548364400416034343698204186575808495617
num = 11559732032986387107991004021392285783925812861821192530917403151452391805634
print(hex(num))
print(hex(curve_order-num))

print("\n",int("0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47", 16))

21888242871839275222246405745257275088696311157297823662689037894645226208583