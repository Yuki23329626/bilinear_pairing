pragma solidity 0.6.8;
pragma experimental ABIEncoderV2;

import "BN256G1.sol";
import "BN256G2.sol";

contract bn256test{
    
    // The prime q in the base field F_q for G1 and G2
    uint256 q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
    
    struct G1Point {
        uint256 x;
        uint256 y;
    }
    
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint256[2] x;
        uint256[2] y;
    }
    
    /// @return the generator of G1
    function get_P1() internal pure returns (G1Point memory) {
        return G1Point(1,2);
    }
    
    /// @return the generator of G2
    function get_P2() internal pure returns (G2Point memory) { // RE+IM
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
            10857046999023057135944570762232829481370756359578518086990519993285655852781],

            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
            8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
    }
    
    G1Point P1 = get_P1();
    G1Point NEG_P1 = g1negate(P1);
    G2Point P2 = get_P2();
    G2Point NEG_P2 = g2negate(P2);
    
    uint256 fsk1_oi = uint256(keccak256("fsk1_oi"));
    uint256 sk1_j = uint256(keccak256("sk1_j"));
    G1Point fpk1_oi = g1mul(fsk1_oi, P1);
    G1Point pk1_j = g1mul(sk1_j, P1);
    
    uint256 ri1 = 1;
    uint256 ri2 = 3;
    uint256 ri3 = 5;
    
    uint256 rj1 = 2;
    uint256 rj2 = 4;
    uint256 rj3 = 6;
    
    uint256 kw = uint256(keccak256("kw"));
    
    
    G2Point Ci1;// = g2mul(ri1, g2mul(ri2, P2));
    G1Point Ci2 = g1add(g1mul(ri1, g1mul(ri2, g1mul(kw, P1))), g1mul(ri3, P1));
    
    G2Point Cj1;// = g2mul(rj1, g2mul(rj2, P2));
    G1Point Cj2 = g1add(g1mul(rj1, g1mul(rj2, g1mul(kw, P1))), g1mul(rj3, P1));

    G1Point Tioj = g1add(g1mul(ri1, g1mul(ri2, g1mul(fsk1_oi, pk1_j))), g1mul(ri3, NEG_P1));
    G1Point Tjio = g1add(g1mul(rj1, g1mul(rj2, g1mul(sk1_j, fpk1_oi))), g1mul(rj3, NEG_P1));
    
    G1Point TCi = g1add(Ci2,Tioj);
    G1Point TCj = g1add(Cj2,Tjio);
    
    
    function test()public returns(bool)
    {
        // bool a = BN256G1.bn256CheckPairing([P1.x, P1.y, P2.x[0], P2.x[1], P2.y[0], P2.y[1], P1.x, P1.y, P2.x[0], P2.x[1], P2.y[0], P2.y[1]]);
        // bool b = BN256G2._isOnCurve(P2.x[1], P2.x[0], P2.y[1], P2.y[0]);
        return  pairing_check(TCj, Ci1, TCi, Cj1);
    }
    
    function setCi1(uint256 a,uint256 b,uint256 c,uint256 d)public
    {
        Ci1 = G2Point([a,b],[c,d]);//7273165102799931111715871471550377909735733521218303035754523677688038059653,2725019753478801796453339367788033689375851816420509565303521482350756874229,957874124722006818841961785324909313781880061366718538693995380805373202866,2512659008974376214222774206987427162027254181373325676825515531566330959255
    }
    
    function setCj1(uint256 a,uint256 b,uint256 c,uint256 d)public
    {
        Cj1 = G2Point([a,b],[c,d]);//1513450333913810775282357068930057790874607011341873340507105465411024430745,11166086885672626473267565287145132336823242144708474818695443831501089511977,20245151454212206884108313452940569906396451322269011731680309881579291004202,10576778712883087908382530888778326306865681986179249638025895353796469496812
    }
    
    function g2add(G2Point memory a, G2Point memory b)internal view returns(G2Point memory r)
    {
        (uint256 x_im, uint256 x_re, uint256 y_im, uint256 y_re) = BN256G2.ecTwistAdd(a.x[1], a.x[0], a.y[1], a.y[0], b.x[1], b.x[0], b.y[1], b.y[0]);
        return G2Point([x_re, x_im], [y_re, y_im]);
    }
    
    function g2mul(uint256 s, G2Point memory a)internal view returns(G2Point memory r)
    {
        (uint256 x_im, uint256 x_re, uint256 y_im, uint256 y_re) = BN256G2.ecTwistMul(s, a.x[1], a.x[0], a.y[1], a.y[0]);
        return G2Point([x_re, x_im], [y_re, y_im]);
    }
    
    function g1add(G1Point memory a, G1Point memory b)internal returns(G1Point memory r)
    {
        (uint256 x, uint256 y) = BN256G1.add([a.x, a.y, b.x, b.y]);
        return G1Point(x, y);
    }
    
    function g1mul(uint256 s, G1Point memory a)internal returns(G1Point memory r)
    {
        (uint256 x, uint256 y) = BN256G1.multiply([a.x, a.y, s]);
        return G1Point(x, y);
    }
    
    function g1negate(G1Point memory a) internal view returns(G1Point memory)
    {
        
        return G1Point(a.x, q-a.y);
    }
    
    function g2negate(G2Point memory a) internal view returns(G2Point memory)
    {
        
        return G2Point(
            [a.x[0], a.x[1]],
            [q - a.y[0], q - a.y[1]]);
    }
    
    function pairing_check(G1Point memory P, G2Point memory Q, G1Point memory R, G2Point memory S)internal returns(bool){
        P = g1negate(P);
        return BN256G1.bn256CheckPairing([P.x, P.y, Q.x[0], Q.x[1], Q.y[0], Q.y[1], R.x, R.y, S.x[0], S.x[1], S.y[0], S.y[1]]);
    }
    
}