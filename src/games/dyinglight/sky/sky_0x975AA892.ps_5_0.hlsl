#include "./sky.hlsli"
// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 02:45:18 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    out float4 o0: SV_TARGET0,
    out float4 o1: SV_TARGET1) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v1.xyz, v1.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v1.xyz * r0.xxx;

  float3 offset;
  if (CUSTOM_IMPROVED_SUN == 0.f) {
    offset = float3(0.0, 0.0, 0.0);
  } else {
    offset = float3(0.0, SUN_SHIFT_Y, SUN_SHIFT_X);
  }

  float3 sun_dir = normalize(cb0[0].xyz + offset);

  r0.x = dot(r0.xyz, sun_dir);

  // r0.x = dot(r0.xyz, cb0[0].xyz);
  r0.z = saturate(r0.x);

  float threshold;
  float sun_brightness;
  if (CUSTOM_IMPROVED_SUN == 0.f) {
    threshold = ORIGINAL_THRESHOLD;
    sun_brightness = 1.f;
    r0.x = cmp(threshold < r0.x);  // SUN_THRESHOLD originally 0.999985337
    r0.x = r0.x ? cb0[0].w * sun_brightness : 0;
  } else {
    threshold = SUN_THRESHOLD;
    sun_brightness = SUN_BRIGHTNESS_BOOST;
    float sunMask = smoothstep(threshold - SUN_SOFTNESS, threshold, r0.x);
    r0.x = sunMask * cb0[0].w * sun_brightness;
  }

  r0.w = cb0[5].w * r0.z + cb0[6].x;
  r0.z = r0.z * r0.z;
  r0.z = r0.z * 0.238732412 + 0.238732412;
  r0.w = sqrt(r0.w);
  r1.x = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r1.xyz = cb0[5].xyz / r0.www;
  r1.xyz = cb0[4].xyz * r0.zzz + r1.xyz;
  r0.z = 12742000 * r0.y;
  r0.zw = r0.zz * r0.zz + float2(2.34537435e+11, 1.17247558e+11);
  r0.zw = sqrt(r0.zw);
  r0.yz = -r0.yy * float2(12742000, 12742000) + r0.zw;
  r0.y = 0.5 * r0.y;
  r0.z = r0.z * 0.5 + -r0.y;
  r2.xyzw = t0.Sample(s0_s, v2.xy).xyzw;  // clouds
  r3.xyzw = cb0[1].xyzw * r2.xyzw;
  r2.xyzw = -r2.wwww * cb0[1].wwww + float4(1, 1, 1, 1);
  r0.y = r3.w * r0.z + r0.y;
  r3.xyz = r3.xyz * r3.www;
  r0.yzw = cb0[3].xyz * r0.yyy;
  r0.yzw = exp2(r0.yzw);
  r1.xyz = -r1.xyz * r0.yzw + r1.xyz;
  r0.yzw = saturate(r3.xyz * cb0[2].xyz + r0.yzw);
  r0.yzw = r3.xyz * r0.yzw + r1.xyz;
  r1.x = r2.w * r2.w;
  o1.xyzw = r2.xyzw;
  r0.x = r1.x * r0.x;
  r0.xyz = r0.yzw * r0.xxx + r0.yzw;
  o0.xyz = cb0[2].www * r0.xyz;
  o0.w = 0;

  o0.rgb = ApplyBoostSky(o0.rgb);

  // o0.rgb *= 10.f;

  return;
}
