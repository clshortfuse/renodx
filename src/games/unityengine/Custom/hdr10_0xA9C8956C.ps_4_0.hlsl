cbuffer HDRDisplayMappingCB : register(b0){
  float _NitsForPapaerWhite : packoffset(c0);
  uint _DisplayCurve : packoffset(c0.y);
}
SamplerState _Sampler0_s : register(s0);
Texture2D<float4> _MainTex : register(t0);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r1.xyzw = _MainTex.Sample(_Sampler0_s, v1.xy).xyzw;
  o0 = r1;
  return;
}