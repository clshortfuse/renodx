#include "../common.hlsl"

Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if (asint(cb0[5].y) != 0) {
    r1.xy = -cb0[3].xy + v1.xy;
    r1.xy = float2(4.8,2.7) * r1.xy;
    r1.x = dot(r1.xy, r1.xy);
    r1.x = sqrt(r1.x);
    r1.x = -cb0[3].z + r1.x;
    r1.x = saturate(r1.x / cb0[3].w);
    r1.x = log2(r1.x);
    r1.x = cb0[4].x * r1.x;
    r1.x = exp2(r1.x);
    r2.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
    r3.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
    r4.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
    r5.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
    r6.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
    r1.y = 5 * r1.x;
    r7.xyzw = r2.xyzw + -r0.xyzw;
    r7.xyzw = r1.yyyy * r7.xyzw + r0.xyzw;
    r8.xyzw = float4(-0.2,-0.4,-0.6,-0.8) + r1.xxxx;
    r8.xyzw = float4(5,5,5,5) * r8.xyzw;
    r9.xyzw = r3.xyzw + -r2.xyzw;
    r2.xyzw = r8.xxxx * r9.xyzw + r2.xyzw;
    r9.xyzw = r4.xyzw + -r3.xyzw;
    r3.xyzw = r8.yyyy * r9.xyzw + r3.xyzw;
    r9.xyzw = r5.xyzw + -r4.xyzw;
    r4.xyzw = r8.zzzz * r9.xyzw + r4.xyzw;
    r6.xyzw = r6.xyzw + -r5.xyzw;
    r5.xyzw = r8.wwww * r6.xyzw + r5.xyzw;
    r4.xyzw = (0.8 >= r1.x) ? r4.xyzw : r5.xyzw;
    r3.xyzw = (0.6 >= r1.x) ? r3.xyzw : r4.xyzw;
    r2.xyzw = (0.4 >= r1.x) ? r2.xyzw : r3.xyzw;
    r0.xyzw = (0.2 >= r1.x) ? r7.xyzw : r2.xyzw;
  }
  if (asint(cb0[5].x) != 0) {
    r1.xy = cb1[6].xy * v1.xy;
    r1.xy = r1.xy / cb0[6].zw;
    r2.xyzw = float4(0.5,0.5, 1.0 / 3.0, 1.0 / 3.0) * r1.xyxy;
    r2.xy = (540 >= cb1[6].y) ? r2.xy : r2.zw;
    r1.xy = (360 >= cb1[6].y) ? r1.xy : r2.xy;
    r1.xyzw = t6.Sample(s6_s, r1.xy).xyzw;
    r1.xyz = cb0[4].zzz + r1.xyz;
    r1.xyz = r1.xyz * cb0[4].yyy + r0.xyz;
    r1.w = asint(cb0[4].w);
    r1.xyz = r1.xyz * r1.www;
    r1.xyz = trunc(r1.xyz);
    r0.xyz = r1.xyz / r1.www;
  }
  r0.xyz = r0.xyz * r0.www;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  }
  o0.xyzw = r0.xyzw;
  return;
}