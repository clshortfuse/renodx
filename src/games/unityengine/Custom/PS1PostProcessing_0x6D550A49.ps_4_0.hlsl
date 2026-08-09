#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 x0[16];
  x0[0].x = -4;
  x0[1].x = 0;
  x0[2].x = -3;
  x0[3].x = 1;
  x0[4].x = 2;
  x0[5].x = -2;
  x0[6].x = 3;
  x0[7].x = -1;
  x0[8].x = -3;
  x0[9].x = 1;
  x0[10].x = -4;
  x0[11].x = 0;
  x0[12].x = 3;
  x0[13].x = -1;
  x0[14].x = 2;
  x0[15].x = -2;
  r0.x = cb0[5].w / cb0[5].z;
  r0.y = v0.y * r0.x;
  r0.x = v0.x;
  r0.xy = cb0[5].zz * r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.x = (uint)r0.x << 2;
  r0.xy = (int2)r0.xy & int2(12,3);
  r0.x = (int)r0.y + (int)r0.x;
  r0.x = x0[r0.x+0].x;
  r0.x = (int)r0.x;
  r1.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r0.y = cb1[7].x * r1.x + cb1[7].y;
  r0.y = 1 / r0.y;
  r0.y = floor(r0.y);
  r0.y = 1 + -r0.y;
  r0.y = cb0[4].y * r0.y;
  r0.y = cb0[3].w * r0.y;
  r0.x = r0.y * r0.x;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  o0.w = r1.w;
  r0.x = 33.3333359 * r0.x;
  r0.yzw = fastSrgbEncodeSafe(r1.xyz);
  r1.xyz = float3(3,3,3) + -r0.yzw;
  r0.yzw = -r1.xyz * cb0[4].www + r0.yzw;
  r1.xyz = float3(1,1,1) + -r0.yzw;
  r1.xyz = float3(0.25,0.25,0.25) * r1.xyz;
  r1.xyz = cb0[5].xxx * r1.xyz;
  r2.xyz = fastSrgbDecodeSafe(r1.xyz);
  r1.yzw = -r2.xyz + r0.yzw;
  r0.y = 0.5 + -r1.y;
  r0.y = 0.1 * r0.y;
  r0.y = cb0[5].x * r0.y;
  r0.z = r0.y * 0.305306017 + 0.682171106;
  r0.z = r0.y * r0.z + 0.0125228781;
  r1.x = r0.y * r0.z + r1.y;
  r0.xyz = r1.xzw * float3(255,255,255) + r0.xxx;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(255,255,255), r0.xyz);
  }
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) * r0.xyz;
  r0.xyz = cb0[3].xxx * r0.xyz;
  r0.xyz = floor(r0.xyz);
  r0.xyz = r0.xyz / cb0[3].xxx;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r0.xyz = fastSrgbDecodeSafe(r0.xyz);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}