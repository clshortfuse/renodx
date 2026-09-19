#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v3.xy + v1.xy;
  r0.xy = cb0[3].zw * r0.xy;
  //r0.xy = (int2)r0.xy;
  int4 temp;
  temp.xy = asint(r0.xy);
  //r0.z = (int)cb0[8].w;
  temp.z = asint(cb0[8].w);
  //r0.yz = (uint2)r0.zy << int2(16,8);
  temp.yz = int2(temp.z, temp.y) << int2(16,8);
  //r0.y = (int)r0.z + (int)r0.y;
  temp.y = temp.z + temp.y;
  //r0.x = (int)r0.x + (int)r0.y;
  temp.x = temp.x + temp.y;
  //r0.y = (uint)r0.x << 13;
  temp.y = temp.x << 13;
  //r0.y = (int)r0.x ^ (int)r0.y;
  temp.y = temp.x ^ temp.y;
  //r0.xz = (int2)r0.xx + int2(57,113);
  temp.xz = temp.xx + int2(57,113);
  //r0.w = (int)r0.y * (int)r0.y;
  temp.w = temp.y * temp.y;
  //r0.w = mad((int)r0.w, 0x00003d73, 0x000c0ae5);
  temp.w = mad(temp.w, 15731u, 789221u);
  //r0.y = mad((int)r0.y, (int)r0.w, 0x5208dd0d);
  temp.y = mad(temp.y, temp.w, 1376312589u);
  //r0.y = (int)r0.y & 0x7fffffff;
  temp.y = temp.y & 2147483647u;
  //r0.y = (int)r0.y;
  //r1.x = 4.65661287e-010 * r0.y;
  r1.x = 4.65661287e-010 * temp.y;
  //r0.yw = (uint2)r0.xz << int2(13,13);
  temp.yw = temp.xz << int2(13, 13);
  //r0.xy = (int2)r0.xz ^ (int2)r0.yw;
  temp.xy = temp.xz ^ temp.yw;
  //r0.zw = (int2)r0.xy * (int2)r0.xy;
  temp.zw = temp.xy * temp.xy;
  // r0.zw = mad((int2)r0.zw, int2(0x3d73,0x3d73), int2(0xc0ae5,0xc0ae5));
  temp.zw = mad(temp.zw, 15731u, 789221u);
  //r0.xy = mad((int2)r0.xy, (int2)r0.zw, int2(0x5208dd0d,0x5208dd0d));
  temp.xy = mad(temp.xy, temp.zw, 1376312589u);
  //r0.xy = (int2)r0.xy & int2(0x7fffffff,0x7fffffff);
  temp.xy = temp.xy & 2147483647u;
  //r0.xy = (int2)r0.xy;
  //r1.yz = float2(4.65661287e-010,4.65661287e-010) * r0.xy;
  r1.yz = float2(4.65661287e-010, 4.65661287e-010) * temp.xy;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if (injectedData.toneMapType == 0.f) {
    r1.xyz = saturate(r1.xyz);
  }
  if (injectedData.fxFilmGrainType == 0.f) {
  r0.w = dot(saturate(r1.xyz), float3(0.219999999,0.707000017,0.0710000023));
  r0.w = -cb0[8].x + r0.w;
  r2.xy = saturate(cb0[8].yz * r0.ww);
  r0.w = dot(cb0[6].zy, r2.xy);
  r0.w = max(0, r0.w);
  r0.w = cb0[6].x + r0.w;
  r2.xyz = cb0[4].xyz * r0.www;
  r0.xyz = saturate(r2.xyz * r0.xyz + float3(0.5,0.5,0.5));
  r2.xyz = float3(1,1,1) + -r0.xyz;
  r3.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r3.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r2.xyz = -r3.xyz * r2.xyz + float3(1,1,1);
  r3.xyz = r1.xyz + r1.xyz;
  r0.xyz = r3.xyz * r0.xyz;
  r0.xyz = r1.xyz >= float3(0.5,0.5,0.5) ? float3(0,0,0) : r0.xyz;
  r1.xyz = r1.xyz >= float3(0.5,0.5,0.5) ? float3(1,1,1) : 0;
  r0.xyz = r1.xyz * r2.xyz + r0.xyz;
  } else {
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r0.xyz = applyFilmGrain(r0.xyz, v1);
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  }
  o0.xyz = r0.xyz;
  o0.w = saturate(r1.w);
  return;
}