// EMF warp (ps_2_0): the game's ps_1_1 0x2E3398C1 (t0 * c0) without ps_1_x's clamps. After EMF's
// image, the game copies the screen to an 8-bit texture and draws it back through a grid that warps
// it; with EMF HDR on, the add-on gives that draw a 16-bit copy and this shader, so what went past
// white survives. A ps_2_0 runs with the game's vs_1_1 (0x25CABA86).

sampler2D screen : register(s0);
float4 tint : register(c0);

float4 main(float2 texcoord : TEXCOORD0) : COLOR {
  return tex2D(screen, texcoord) * tint;
}
