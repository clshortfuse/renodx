#include "../common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  /*r1.xyz = log2(abs(r0.yxz));
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.yxz);
  r3.xyz = float3(12.9232101,12.9232101,12.9232101) * r0.yxz;
  r1.xyz = r2.xyz ? r3.xyz : r1.xyz;*/
  r1.xyz = renodx::color::srgb::EncodeSafe(r0.yxz);
  r1.z = 16 * r1.z;
  r2.yz = r1.xy * float2(0.9375,0.05859375) + float2(0.03125,0.001953125);
  r1.x = floor(r1.z);
  r2.x = r1.x * 0.0625 + r2.z;
  r1.xyzw = t2.Sample(s4_s, r2.xy).xyzw;
  r1.x = renodx::color::srgb::Decode(abs(r1.x));
  r1.y = r1.x / cb0[0].x;
  r1.y = 1 + -r1.y;
  r1.y = r1.y * r1.y;
  r1.y = r1.y * r1.y + 0.001;
  r1.y = min(1, r1.y);
  r1.y = 1 + -r1.y;
  r1.y = r1.y / cb0[2].z;
  r1.y = floor(r1.y);
  r1.y = cb0[2].z * r1.y;
  r1.zw = v0.xy * cb0[1].xy + cb0[1].zw;
  r3.yz = frac(r1.zw);
  r3.x = r3.y * cb0[2].z + r1.y;
  r3.xyzw = t3.Sample(s1_s, r3.xz).xyzw;
  r1.y = cb0[0].x * r3.x;
  /*r1.x = cmp(r1.y >= r1.x);
  r1.x = r1.x ? 1.000000 : 0;*/
  r1.x = step(r1.x, r1.y);
  r3.xyzw = t4.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s2_s, r2.xy).xyzw;
  /*r1.yzw = float3(0.0549999997,0.0549999997,0.0549999997) + r3.xyz;
  r1.yzw = float3(0.947867334,0.947867334,0.947867334) * r1.yzw;
  r1.yzw = log2(abs(r1.yzw));
  r1.yzw = float3(2.4000001,2.4000001,2.4000001) * r1.yzw;
  r1.yzw = exp2(r1.yzw);
  r4.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r3.xyz;
  r5.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r3.xyz);
  r3.xyz = r5.xyz ? r4.xyz : r1.yzw;*/
  r3.xyz = renodx::color::srgb::DecodeSafe(r3.xyz);
  /*r1.yzw = float3(0.0549999997,0.0549999997,0.0549999997) + r2.xyz;
  r1.yzw = float3(0.947867334,0.947867334,0.947867334) * r1.yzw;
  r1.yzw = log2(abs(r1.yzw));
  r1.yzw = float3(2.4000001,2.4000001,2.4000001) * r1.yzw;
  r1.yzw = exp2(r1.yzw);
  r4.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r2.xyz;
  r5.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r2.xyz);
  r2.xyz = r5.xyz ? r4.xyz : r1.yzw;*/
  r2.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
  r3.xyzw = r3.xyzw + -r2.xyzw;
  r1.xyzw = r1.xxxx * r3.xyzw + r2.xyzw;
  r1.w = r1.w * r0.w;
  r1.xyzw = r1.xyzw + -r0.xyzw;
  r0.xyzw = cb0[0].yyyy * r1.xyzw + r0.xyzw;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}