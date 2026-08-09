#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.xy = r0.xy + r0.xy;
  r0.z = 1 + cb0[5].x;
  r0.xy = r0.xy / r0.zz;
  r0.xy = float2(1.1,1.1) * r0.xy;
  r0.z = abs(r0.y) / cb0[4].z;
  r0.w = r0.z * r0.z;
  r0.z = r0.z * r0.w + 1;
  r1.x = r0.x * r0.z;
  r0.x = abs(r1.x) / cb0[4].w;
  r0.z = r0.x * r0.x;
  r0.x = r0.x * r0.z + 1;
  r1.y = r0.y * r0.x;
  r0.xy = r1.xy * float2(0.5,0.5) + float2(0.5,0.5);
  if (r0.x < 0 || r0.y < 0 || r0.x > 1 || r0.y > 1) {
    o0.xyzw = float4(0,0,0,1);
    return;
  } else {
    r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
    if(injectedData.countOld < injectedData.countNew){
      r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
      r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
    }
    if (cb0[3].z == 0) {
      r0.zw = v1.xy / cb0[3].xy;
      r0.zw = float2(1.0 / 6.0, 0.25) * r0.zw;
      r0.zw = (r0.zw >= -r0.zw) ? frac(abs(r0.zw)) : -frac(abs(r0.zw));
      r0.zw = float2(6,4) * r0.zw;
      r0.zw = floor(r0.zw);
      r2.xyz = (r0.z < 3.f) ? (r0.w < 3.f ? 1.0 : 0) : (r0.w == 1.0 ? 0 : 1);
    } else {
      if (asint(cb0[3].z) == 1) {
        r0.zw = v1.xy / cb0[3].xy;
        r0.zw = float2(1.0 / 6.0, 1.0 / 6.0) * r0.zw;
        r0.zw = (r0.zw >= -r0.zw) ? frac(abs(r0.zw)) : -frac(abs(r0.zw));
        r0.zw = float2(6,6) * r0.zw;
        r0.zw = floor(r0.zw);
        r2.xyz = (r0.z < 3) ? (r0.w == 0 || r0.w == 5 ? 0 : 1) : (r0.w == 2 || r0.w == 3 ? 0 : 1);
      } else {
        if (asint(cb0[3].z) == 2) {
          r3.xyz = v1.xyy / cb0[3].xyy;
          r3.xyz = float3(1.0 / 6.0, 0.2, 0.2) * r3.xyz;
          r3.xyz = (r3.xyz >= -r3.xzz) ? frac(abs(r3.xzz)) : -frac(abs(r3.xzz));
          r3.xyz = float3(6,5,5) * r3.xyz;
          r3.xyz = floor(r3.xyz);
          r2.xyz = (r3.x < 3) ? (r3.y < 3 ? 1.0 : 0) : (r3.z < 2 ? 0 : 1);
        } else {
          if (asint(cb0[3].z) == 3) {
            r0.z = v1.y / cb0[3].y;
            r0.z = 0.25 * r0.z;
            r0.z = (r0.z >= -r0.z) ? frac(abs(r0.z)) : -frac(abs(r0.z));
            r0.z = 4 * r0.z;
            r0.z = floor(r0.z);
            r2.xyz = (r0.z < 1) ? float3(0,0,0) : float3(1,1,1);
          } else {
            r0.w = v1.y / cb0[3].y;
            r3.xy = float2(0.25, 0.2) * r0.ww;
            r3.xy = (r3.xy >= -r3.xy) ? frac(abs(r3.xy)) : -frac(abs(r3.xy));
            r3.xy = float2(4,5) * r3.xy;
            r3.xy = floor(r3.xy);
            r2.xyz = asint(cb0[3].z) == 4 ? (r3.x < 2 ? 0 : 1) : (r3.y < 2 ? 1.0 : 0);
          }
        }
      }
    }
    r2.xyz = r2.xyz * r1.xyz;
    r0.z = 1 + -cb0[3].w;
    r0.w = r1.w * r0.z + cb0[3].w;
    r1.xyz = r1.xyz * r1.www;
    r1.xyz = r1.xyz * r0.zzz;
    r1.xyz = r2.xyz * cb0[3].www + r1.xyz;
    r1.xyz = r1.xyz / r0.www;
    r0.xy = float2(0.5,0.5) + -r0.xy;
    r0.x = dot(r0.xy, r0.xy);
    r0.x = sqrt(r0.x);
    r0.x = -r0.x * 1.41421294 + 1;
    r0.yz = float2(1,1) + -cb0[4].yx;
    r0.x = saturate(r0.x / r0.y);
    r0.xyw = r1.xyz * r0.xxx;
    r2.x = r1.w * r0.z + cb0[4].x;
    r1.xyz = r1.xyz * r1.www;
    r1.xyz = r1.xyz * r0.zzz;
    r0.xyz = r0.xyw * cb0[4].xxx + r1.xyz;
    o0.xyz = r0.xyz / r2.xxx;
    o0.w = r1.w;
    if (injectedData.countOld <= injectedData.countNew) {
      o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
      o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
    }
    return;
  }
  return;
}