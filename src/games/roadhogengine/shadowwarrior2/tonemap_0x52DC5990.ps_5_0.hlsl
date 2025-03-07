#include "../common.hlsl"

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
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[4].x * 2 + -1;
  r0.y = r0.x * cb4[2].x + cb4[2].y;
  r0.zw = cmp(r0.xx < cb4[0].xy);
  r1.xy = r0.xx * cb4[1].xz + cb4[1].yw;
  r0.x = r0.w ? r1.y : r0.y;
  r0.xz = r0.zz ? r1.xx : r0.xx;
  r1.x = cb1[4].y * -2 + 1;
  r1.yz = r1.xx * cb4[3].xz + cb4[3].yw;
  r2.xy = cmp(r1.xx < cb4[0].zw);
  r1.x = r1.x * cb4[2].z + cb4[2].w;
  r1.y = r2.y ? r1.y : r1.z;
  r0.yw = r2.xx ? r1.xx : r1.yy;
  r1.xy = cb0[17].xy * v0.xy;
  r0.xyzw = -r0.xyzw * cb0[18].xyxy + r1.xyxy;
  r2.xyzw = cmp(v0.xxyy < cb4[4].xyzw);
  r3.xyzw = r2.ywyw ? float4(1,1,1,1) : cb4[8].xxxx;
  r2.xyzw = r2.xzxz ? cb4[8].xxxx : r3.xyzw;
  r0.xyzw = r2.xyzw * r0.xyzw;
  r0.xyzw = cb1[4].zzww * r0.xyzw + r1.xyxy;
  r1.xyz = t2.SampleLevel(s6_s, r1.xy, 0).xyz;
  r0.x = t0.SampleLevel(s6_s, r0.xy, 0).y;
  r0.y = t0.SampleLevel(s6_s, r0.zw, 0).z;
  r2.xy = (int2)v0.xy;
  r2.zw = float2(0,0);
  r2.xyz = t0.Load(r2.xyz).xyz;
  r0.z = -r2.y + r0.x;
  r0.z = 0.0500000007 * abs(r0.z);
  r0.z = min(1, r0.z);
  r0.w = r2.y + -r0.x;
  r2.y = r0.z * r0.w + r0.x;
  r0.x = -r2.z + r0.y;
  r0.x = 0.0500000007 * abs(r0.x);
  r0.x = min(1, r0.x);
  r0.z = r2.z + -r0.y;
  r2.z = r0.x * r0.z + r0.y;
  r0.xy = v0.xy * cb0[17].xy + cb1[9].xy;
  r0.xyz = t1.SampleLevel(s6_s, r0.xy, 0).xyz;
  r0.xyz = r2.xyz * cb3[0].yyy + r0.xyz * injectedData.fxBloom;
  r0.xyz = r0.xyz + r1.xyz * injectedData.fxLens;
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
  r1.xy = v1.xy * float2(0.5,-0.5) + float2(0.5,0.5);
  r1.xy = cb0[18].zw * r1.xy;
  r1.zw = r1.xx * cb4[5].xz + cb4[5].yw;
  r2.xy = r1.xy * cb4[6].xz + cb4[6].yw;
  r3.xyzw = cmp(r1.xxyy < cb4[4].xyzw);
  r1.xy = r1.yy * cb4[7].xz + cb4[7].yw;
  r0.w = r3.w ? r1.x : r1.y;
  r1.y = r3.z ? r2.y : r0.w;
  r0.w = r3.y ? r1.w : r2.x;
  r1.x = r3.x ? r1.z : r0.w;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = saturate(r0.w * cb1[0].w + cb1[1].w);
  r1.x = r0.w * r0.w;
  r0.w = -r0.w * 2 + 3;
  r0.w = r1.x * r0.w;
  r0.w = min(1, r0.w);
  r1.xyz = float3(1,1,1) + -cb1[1].xyz;
  r1.xyz = lerp(1.f, r0.www, injectedData.fxVignette) * r1.xyz + cb1[1].xyz;
  r0.xyz = r1.xyz * r0.xyz;
  o0.rgb = applyUserTonemapACES(r0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb, true);
  o0.w = 1;
  return;
}