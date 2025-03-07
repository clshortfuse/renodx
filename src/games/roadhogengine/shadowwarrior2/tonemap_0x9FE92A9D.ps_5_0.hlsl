#include "../common.hlsl"

Texture2D<uint4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
cbuffer cb1 : register(b1){
  float4 cb1[10];
}
cbuffer cb3 : register(b3){
  float4 cb3[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[19];
}
cbuffer cb4 : register(b4){
  float4 cb4[9];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[18].xy * v0.xy;
  r0.xy = cb0[18].zw * r0.xy;
  r0.zw = r0.xx * cb4[5].xz + cb4[5].yw;
  r1.xy = r0.xy * cb4[6].xz + cb4[6].yw;
  r2.xyzw = cmp(r0.xxyy < cb4[4].xyzw);
  r0.xy = r0.yy * cb4[7].xz + cb4[7].yw;
  r0.x = r2.w ? r0.x : r0.y;
  r0.x = r2.z ? r1.y : r0.x;
  r0.y = r2.y ? r0.w : r1.x;
  r0.y = r2.x ? r0.z : r0.y;
  r1.x = r0.y * 0.5 + 0.5;
  r1.y = r0.x * -0.5 + 0.5;
  r0.xyz = t3.SampleLevel(s6_s, r1.xy, 0).xyz;
  r0.xyz = float3(-1,-1,-1) + r0.xyz;
  r1.xyz = cb1[0].yyy * r0.xyz + float3(1,1,1);
  r0.xyz = cb1[0].xxx * r0.xyz + float3(1,1,1);
  r2.xy = v0.xy * cb0[17].xy + cb1[9].xy;
  r2.xyz = t1.SampleLevel(s6_s, r2.xy, 0).xyz;
  r0.xyz = r2.xyz * r0.xyz;
  r2.xyzw = cmp(v0.xxyy < cb4[4].xyzw);
  r3.xyzw = r2.ywyw ? float4(1,1,1,1) : cb4[8].xxxx;
  r2.xyzw = r2.xzxz ? cb4[8].xxxx : r3.xyzw;
  r0.w = cb1[4].x * 2 + -1;
  r1.w = r0.w * cb4[2].x + cb4[2].y;
  r3.xy = cmp(r0.ww < cb4[0].xy);
  r3.zw = r0.ww * cb4[1].xz + cb4[1].yw;
  r0.w = r3.y ? r3.w : r1.w;
  r3.xz = r3.xx ? r3.zz : r0.ww;
  r0.w = cb1[4].y * -2 + 1;
  r4.xy = r0.ww * cb4[3].xz + cb4[3].yw;
  r4.zw = cmp(r0.ww < cb4[0].zw);
  r0.w = r0.w * cb4[2].z + cb4[2].w;
  r1.w = r4.w ? r4.x : r4.y;
  r3.yw = r4.zz ? r0.ww : r1.ww;
  r4.xy = cb0[17].xy * v0.xy;
  r3.xyzw = -r3.xyzw * cb0[18].xyxy + r4.xyxy;
  r2.xyzw = r3.xyzw * r2.xyzw;
  r2.xyzw = cb1[4].zzww * r2.xyzw + r4.xyxy;
  r0.w = t0.SampleLevel(s6_s, r2.xy, 0).y;
  r1.w = t0.SampleLevel(s6_s, r2.zw, 0).z;
  r2.xy = (int2)v0.xy;
  r2.zw = float2(0,0);
  r3.xyz = t0.Load(r2.xyw).xyz;
  r2.x = t4.Load(r2.xyz).y;
  r2.x = (int)r2.x & 34;
  r2.y = -r3.y + r0.w;
  r2.y = 0.0500000007 * abs(r2.y);
  r2.y = min(1, r2.y);
  r2.z = r3.y + -r0.w;
  r5.y = r2.y * r2.z + r0.w;
  r0.w = -r3.z + r1.w;
  r0.w = 0.0500000007 * abs(r0.w);
  r0.w = min(1, r0.w);
  r2.y = r3.z + -r1.w;
  r5.z = r0.w * r2.y + r1.w;
  r5.x = r3.x;
  r0.xyz = r5.xyz * cb3[0].yyy + r0.xyz * injectedData.fxBloom;
  r2.yzw = t2.SampleLevel(s6_s, r4.xy, 0).xyz;
  r0.xyz = r2.yzw * r1.xyz * injectedData.fxLens + r0.xyz;
  if (injectedData.fxFilmGrainType == 0.f) {
  r0.w = r4.y * 599.778992 + r4.x;
  r0.w = cb1[2].x + r0.w;
  r0.w = sin(r0.w);
  r0.w = 959681 * r0.w;
  r0.w = frac(r0.w);
  r0.w = r0.w * cb1[2].y * injectedData.fxFilmGrain + cb1[2].z;
  r0.xyz = r0.xyz * r0.www;
  } else {
    r0.rgb = applyFilmGrain(r0.rgb, r4.xy);
  }
  r1.xyz = r0.xyz;
  r0.a = renodx::color::y::from::NTSC1953(r1.rgb);
  r1.xyz = cb1[3].xyz * r0.www;
  r0.xyz = r0.xyz * cb1[0].zzz + -r1.xyz;
  r0.xyz = cb1[3].www * r0.xyz + r1.xyz;
  r0.a = renodx::color::y::from::NTSC1953(r0.rgb);
  r0.w = saturate(cb1[7].w * r0.w);
  r1.xyz = -cb1[7].xyz + cb1[6].xyz;
  r1.xyz = r0.www * r1.xyz + cb1[7].xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = r2.xxx ? r3.xyz : r0.xyz;
  o0.rgb = applyUserTonemapACES(r0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb, true);
  o0.w = 1;
  return;
}