#include "./tonemap.hlsli"

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[16];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float3 v0: TEXCOORD1,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v0.xy).xyzw;
  r0.xyzw = cb2[2].xxxx * r0.xyzw;
  r1.x = 64500 * cb2[2].x;
  r0.xyzw = max(float4(0, 0, 0, 0), r0.xyzw);
  r0.xyzw = min(r0.xyzw, r1.xxxx);
  if (cb2[8].z != 0) {
    r1.x = 1.39999998;
  } else {
    r1.x = 0;
  }
  r1.x = cb2[8].x + r1.x;
  r1.y = 8 * v0.z;
  r1.y = log2(r1.y);
  r1.x = r1.y + -r1.x;
  r1.x = -3 + r1.x;
  r1.y = cb2[7].w + cb2[7].w;
  r1.x = cb2[8].y * r1.x;
  r1.x = exp2(r1.x);
  r1.x = 1 + r1.x;
  r1.x = log2(r1.x);
  r1.x = r1.x * 0.30103001 + r1.y;
  r1.x = r1.y / r1.x;
  r1.x = log2(r1.x);
  r1.x = cb2[7].w * r1.x;
  r1.x = exp2(r1.x);
  r1.x = cb2[7].z * 1.02999997 + -r1.x;
  r1.x = r1.x / v0.z;
  r1.x = log2(r1.x);
  r1.x = -cb2[7].y + r1.x;
  r1.x = exp2(r1.x);
  r1.xyz = r1.xxx * r0.xyz;
  r1.xyz = cb2[6].yyy * r1.xyz;  // r1.xyz = cb2[6].yyy * r1.xyz;

  r1.rgb = ApplyPreLUTToneMapAndGammaEncode(r1.rgb);

  // Gamma Adjust
  r1.rgb = renodx::math::SignPow((r1.rgb), cb2[9].z * 2.2f);

  r1.rgb = ApplyLUT(r1.rgb, t0, s0_s, cb2[0].x, cb2[11].x);

  r1.xyz = (r1.xyz * cb2[10].yyy + cb2[9].yyy);
  r1.w = renodx::color::yf::from::BT709(r1.xyz);  //  r1.w = dot(r1.xyz, float3(0.308600008, 0.609399974, 0.0820000023));
  r1.xyz = r1.xyz + -r1.www;
  r1.xyz = cb2[10].zzz * r1.xyz + r1.www;

  r1.rgb = ApplyPostLUTToneMap(r1.rgb);

  r0.xyz = cb2[10].xxx * r1.xyz;
  // r0 = clamp(r0, 0, 64500);
  if (cb2[15].y != 0) {
    r0.xyz = float3(0, 0, 0);
  }
  o0.xyzw = r0.xyzw;

  // o0.rgb = GameScaleAndGrain(o0.rgb, v0.xy);

  return;
}
