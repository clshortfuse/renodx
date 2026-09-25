#include "../../common.hlsli"

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
  int4 temp;
  temp.xy = asint(r0.xy);
  temp.z = asint(cb0[8].w);
  temp.yz = int2(temp.z, temp.y) << int2(16,8);
  temp.y = temp.z + temp.y;
  temp.x = temp.x + temp.y;
  temp.y = temp.x << 13;
  temp.y = temp.x ^ temp.y;
  temp.xz = temp.xx + int2(57,113);
  temp.w = temp.y * temp.y;
  temp.w = mad(temp.w, 15731u, 789221u);
  temp.y = mad(temp.y, temp.w, 1376312589u);
  temp.y = temp.y & 2147483647u;
  r1.x = 4.65661287e-010 * temp.y;
  temp.yw = temp.xz << int2(13, 13);
  temp.xy = temp.xz ^ temp.yw;
  temp.zw = temp.xy * temp.xy;
  temp.zw = mad(temp.zw, 15731u, 789221u);
  temp.xy = mad(temp.xy, temp.zw, 1376312589u);
  temp.xy = temp.xy & 2147483647u;
  r1.yz = float2(4.65661287e-010, 4.65661287e-010) * temp.xy;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r1.xyz = saturate(r1.xyz);
  }
  if (CUSTOM_FILM_GRAIN_TYPE == 0.f) {
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
    r0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(r1.xyz) : r1.xyz;
    r0.xyz = applyFilmGrain(r0.xyz, v1);
    r0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = PostToneMapScale(r0.xyz, CUSTOM_GAMMA_SPACE != 0.f);
  }
  o0.xyz = r0.xyz;
  o0.w = saturate(r1.w);
  return;
}