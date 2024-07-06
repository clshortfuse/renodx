Texture2D<float4> _8 : register(t0, space0);
SamplerState _11 : register(s0, space0);

float4 main(noperspective float2 TEXCOORD : TEXCOORD0, float4 gl_FragCoord : SV_Position) : SV_Target0 {
  return _8.Sample(_11, float2(TEXCOORD.x, TEXCOORD.y));
}
