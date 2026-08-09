#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.xyzw = t0.Sample(s3_s, r0.xy).xyzw;
  r0.x = cb1[7].z * r0.x + cb1[7].w;
  r0.x = 1 / r0.x;
  r0.x = -v1.z + r0.x;
  r0.x = saturate(cb0[9].x * r0.x);
  r0.x = -cb0[6].w + r0.x;
  r0.y = cb0[7].x + -cb0[6].w;
  r0.y = 1 / r0.y;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.xy = cb0[6].xz * r0.xx;
  r1.xyzw = t1.Sample(s2_s, v2.xy).xyzw;
  r0.zw = r1.xy * r0.xx;
  r1.xy = r1.xy * r0.xx + v2.xy;
  r1.xyzw = t3.Sample(s1_s, r1.xy).xyzw;
  r1.xyzw = r1.xyzw * r0.yyyy;
  if(injectedData.toneMapType == 0.f){
    r1.xyzw = saturate(r1.xyzw);
  }
  r0.xy = r0.zw * cb0[6].xx + v1.xy;
  r0.xyzw = t2.Sample(s0_s, r0.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r2.xyz = float3(1,1,1) + -r0.xyz;
  r3.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r3.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r2.xyz = -r3.xyz * r2.xyz + float3(1,1,1);
  } else {
    r2.xyz = r1.xyz + (r0.xyz / (1 + r1.xyz));
  }
  r3.xyz = r1.xyz + r1.xyz;
  r3.xyz = r1.xyz >= (0.5).xxx ? float3(0,0,0) : r3.xyz;
  r4.xyz = r1.xyz >= (0.5).xxx ? float3(1,1,1) : 0;
  r0.xyz = r3.xyz * r0.xyz;
  r0.xyz = r4.xyz * r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  o0.xyz = cb0[6].zzz * r0.xyz + r1.xyz;
  o0.w = r1.w;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}