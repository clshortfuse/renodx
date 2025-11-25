#include "./lighting.hlsli"
// ---- Created with 3Dmigoto v1.4.1 on Wed Jul  2 01:36:17 2025
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[9];
}

cbuffer cb0 : register(b0) {
  float4 cb0[2];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    out float3 o0: SV_TARGET0,
    out float3 o1: SV_TARGET1) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t3.SampleLevel(s0_s, v2.xy, 0).x;
  r1.xyzw = t0.SampleLevel(s1_s, v2.xy, 0).xyzw;
  r1.xyzw = r1.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
  r0.y = dot(r1.xyz, r1.xyz);
  r0.y = rsqrt(r0.y);
  r0.yzw = r1.xyz * r0.yyy;
  r2.w = dot(cb0[1].xyz, r0.yzw);
  r1.x = saturate(r2.w);
  r1.y = cmp(r1.w < 0);
  r1.x = r1.y ? r2.w : r1.x;
  r1.y = abs(r1.x) * r0.x;
  r1.y = cmp(0 < r1.y);
  if (r1.y != 0) {
    r1.y = t2.SampleLevel(s3_s, v2.xy, 0).x;
    r1.yz = r1.yy * cb2[8].xy + cb2[8].zw;
    r1.y = r1.y / -r1.z;
    r3.xyz = v1.xyz * abs(r1.yyy);
    r1.y = dot(-r3.xyz, -r3.xyz);
    r1.y = rsqrt(r1.y);
    r4.xyz = -r3.xyz * r1.yyy;
    r2.z = saturate(dot(r0.yzw, r4.xyz));
    r4.xyz = cb0[0].xyz * r0.xxx;
    r5.xyzw = t1.SampleLevel(s2_s, v2.xy, 0).xyzw;
#if 0
    // Alternate specular shading: use Schlick Fresnel without the whitening ramp
    r0.x = r5.w * r5.w;
    r3.xyz = normalize(-r3.xyz * r1.yyy + cb0[1].xyz);
    r2.x = saturate(dot(r0.yzw, r3.xyz));
    r2.y = saturate(dot(cb0[1].xyz, r3.xyz));
    r2.xyzw = max(float4(0.00999999978, 0.00999999978, 0.00999999978, 0.00999999978), r2.xyzw);
    float3 specF0 = saturate(r5.xyz);
    float VoH = saturate(dot(cb0[1].xyz, r3.xyz));
    float fresnelTerm = pow(saturate(1.0 - VoH), 5.0);
    r0.yzw = specF0 + (float3(1.0, 1.0, 1.0) - specF0) * fresnelTerm;
    r1.y = cmp(-1 >= r1.w);
#else
    r0.x = r5.w * r5.w;
    r3.xyz = -r3.xyz * r1.yyy + cb0[1].xyz;
    r1.y = dot(r3.xyz, r3.xyz);
    r1.y = rsqrt(r1.y);
    r3.xyz = r3.xyz * r1.yyy;
    r2.x = dot(r0.yzw, r3.xyz);
    r2.y = dot(cb0[1].xyz, r3.xyz);
    r2.xyzw = max(float4(0.00999999978, 0.00999999978, 0.00999999978, 0.00999999978), r2.xyzw);
    r0.y = -8.65616989 * r2.y;
    r0.y = exp2(r0.y);
    r3.xyz = float3(1, 1, 1) + -r5.xyz;
    r0.yzw = saturate(r3.xyz * r0.yyy + r5.xyz);
    r1.y = cmp(-1 >= r1.w);
#endif
    r0.yzw = r1.yyy ? float3(0, 0, 0) : r0.yzw;
    r1.z = r0.x * 0.997500002 + 0.00249999994;
    r1.w = r1.z * r1.z;
    r2.x = r2.x * r2.x;
    r2.y = r1.z * r1.z + -1;
    r2.x = r2.x * r2.y + 1;
    r2.x = r2.x * r2.x;
    r2.x = 4 * r2.x;
    r3.xy = r1.zz * float2(0.797884583, -0.797884583) + float2(0, 1);
    r2.yz = r2.zw * r3.yy + r3.xx;
    r1.z = r2.y * r2.z;
    r1.z = r2.x * r1.z;
    r1.z = r1.w / r1.z;
    r2.xyz = r1.zzz * r0.yzw;
    r1.z = cmp(0 < r1.x);
    r0.yzw = r1.zzz ? r0.yzw : 0;
    r2.xyz = ApplyCustomClampSpecular(r2.xyz * r1.xxx);  // removing this saturate unclamps specular

    r1.z = saturate(r1.x * 0.5 + 0.5);
    r1.z = r1.z * r1.z;
    r1.w = sqrt(abs(r1.x));
    r1.w = r1.w + -abs(r1.x);
    r0.x = r0.x * r1.w + abs(r1.x);
    r0.x = r1.y ? r1.z : r0.x;
    r0.xyz = -r0.yzw * r0.xxx + r0.xxx;
    o0.xyz = r2.xyz * r4.xyz;
    o1.xyz = r0.xyz * r4.xyz;
  } else {
    o0.xyz = float3(0, 0, 0);
    o1.xyz = float3(0, 0, 0);
  }
  return;
}
