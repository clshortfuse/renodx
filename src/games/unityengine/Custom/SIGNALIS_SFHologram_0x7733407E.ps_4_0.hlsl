Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float3 v3 : TEXCOORD2,
  float3 v4 : NORMAL0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = saturate(dot(v3.xyz, v4.xyz));
  r0.x = 1 + -r0.x;
  r0.y = log2(r0.x);
  r0.y = cb0[5].x * r0.y;
  r0.y = exp2(r0.y);
  r0.yzw = cb0[4].xyz * r0.yyy;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.yzw = r1.xyz * cb0[3].xyz + r0.yzw;
  r1.x = cb0[6].x * r1.w;
  r0.x = r1.x * r0.x;
  o0.xyz = cb0[5].www * r0.yzw;
  r0.yz = cb1[0].xy * cb0[7].yy;
  r1.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  o0.w = r1.x * r0.x;
  // Hologram opacity is unbounded (cb0[6].x scales it). UNORM targets clamped it before blending; float targets let
  // 1-alpha go negative and subtract the background. Restore the original opacity and keep the RGB glow.
  o0.w = saturate(o0.w);
  return;
}
