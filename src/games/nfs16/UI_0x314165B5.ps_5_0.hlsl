SamplerState mainTextureSampler_s : register(s0);
Texture2D<float4> mainTexture : register(t0);

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = mainTexture.Sample(mainTextureSampler_s, v1.xy).xyzw;
  o0.xyzw = v2.xyzw * r0.xyzw;
  o0 = saturate(o0);
  return;
}