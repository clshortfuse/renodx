#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[156];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, v0.xy).xyzw;
  r1.xyzw = t1.Sample(s2_s, v0.xy).xyzw;
  if (cb0[15].x < 1) {
    o0.w = r1.x > 0 ? 1.0 : 0;
    o0.xyz = r0.xyz;
    return;
  }
  r1.yz = v0.xy * float2(2,2) + float2(-1,-1);
  r2.xyz = cb0[153].xzw * r1.zzz;
  r1.yzw = cb0[152].xzw * r1.yyy + r2.xyz;
  r1.yzw = cb0[154].xzw * r1.xxx + r1.yzw;
  r1.yzw = cb0[155].xzw + r1.yzw;
  r1.yz = r1.yz / r1.ww;
  r1.yz = r1.yz * cb0[12].xy + cb0[12].zw;
  r2.xyzw = t2.Sample(s0_s, r1.yz).xyzw;
  r0.w = max(r2.x, r2.y);
  r1.y = 1 + -r2.z;
  r0.w = r1.y * r0.w;
  o0.w = (r1.x < 0.1) || (r1.x > 0.9) ? 0 : saturate(r0.w);
  r0.w = cb0[151].w * r2.y;
  r0.w = max(r2.x, r0.w);
  r0.w = r0.w * r1.y;
  r0.xyz = -cb0[151].xyz + r0.xyz;
  o0.xyz = r0.www * r0.xyz + cb0[151].xyz;
  o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  o0.xyz = PostToneMapScale(o0.xyz, true);
  return;
}