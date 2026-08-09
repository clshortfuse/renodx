#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD3,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[0].x + cb0[5].y;
  r0.xy = cb0[9].xy * r0.xx;
  r0.zw = r0.xy >= -r0.xy ? float2(1,1) : float2(-1,-1);
  r0.xy = r0.xy * r0.zw;
  r0.xy = frac(r0.xy);
  r0.xy = r0.zw * r0.xy + w0.xy;
  r0.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r0.x = -0.5 + r0.x;
  r0.x = 0.2 * r0.x;
  r0.xy = r0.xx * cb0[9].zz + v0.xy;
  r0.z = asint(cb0[7].w);
  r1.xy = cb0[3].xy * r0.zz;
  r1.z = 0;
  r2.xyzw = r1.xzzy + r0.xyxy;
  r1.xyzw = -r1.xzzy + r0.xyxy;
  r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r0.x = -r0.w * v2.w + 1;
  r0.x = cb0[7].x * r0.x;
  r3.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, r2.zw).xyzw;
  r4.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, r1.zw).xyzw;
  r0.y = r4.w + r3.w;
  r0.y = r0.y + r2.w;
  r0.y = saturate(r0.y + r1.w);
  r0.y = step(0.05, r0.y);
  r0.x = r0.y * r0.x;
  r0.xyzw = cb0[6].xyzw * r0.xxxx;
  r1.x = cb0[7].y + cb0[7].y;
  r1.xyz = r1.xxx * r0.xyz;
  r1.w = cb0[5].x * r0.w;
  o0.xyzw = cb0[4].xyzw * r1.xyzw;
  o0.w = saturate(o0.w);
  if (injectedData.countOld == injectedData.countNew) {
    if(injectedData.rolloffUI == 1.f){
      o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
      o0.xyz = rolloff(o0.xyz, 0.85f, true);
      o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
    } else if(injectedData.rolloffUI == 2.f){
      o0.xyz = saturate(o0.xyz);
    }
  }
  return;
}