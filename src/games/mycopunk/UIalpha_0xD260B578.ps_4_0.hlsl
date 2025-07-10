Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[133];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.y = 1 + -v1.y;
  r0.y = (cb0[132].x > 0) ? r0.y : v1.y;
  r0.x = v1.x;
  r0.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r1.x = min(cb0[132].y, cb0[132].z);
  r1.x = r1.x * 0.3 + 0.7;
  o0.xyzw = r1.xxxx * r0.xyzw;
  o0.w = saturate(o0.w);
  return;
}