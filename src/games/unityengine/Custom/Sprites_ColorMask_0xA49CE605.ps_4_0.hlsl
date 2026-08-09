Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.w = -r0.y * v1.y + 1;
  r0.xyz = v1.xyz * r0.xyz;
  r0.w = max(1, r0.w);
  r1.x = rsqrt(r0.y);
  r1.x = 1 / r1.x;
  r1.w = cb0[3].y > r0.y ? r1.x : r0.w;
  r1.xyz = r1.www * r0.xyz;
  o0.xyzw = v1.wwww * r1.xyzw;
  o0 = max(0.f, o0);
  return;
}