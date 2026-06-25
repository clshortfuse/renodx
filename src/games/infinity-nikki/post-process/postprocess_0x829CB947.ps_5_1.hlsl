// ---- Created with 3Dmigoto v1.4.1 on Fri Apr 24 23:31:04 2026
#include "./postfx.hlsli"

Texture2D<float4> colorTexture : register(t7);

Texture2D<float4> lut4 : register(t6);

Texture2D<float4> lut3 : register(t5);

Texture2D<float4> lut2 : register(t4);

Texture2D<float4> lut1 : register(t3);

Texture2D<uint4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3) {
  float4 cb3[5];
}

cbuffer cb2 : register(b2) {
  float4 cb2[10];
}

cbuffer cb1 : register(b1) {
  float4 cb1[140];
}

cbuffer cb0 : register(b0) {
  float4 cb0[11];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = asuint(cb0[10].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.xy = cb0[10].zw * r0.xy;
  r0.zw = r0.xy * cb1[136].xy + cb1[135].xy;
  r0.xy = r0.xy * cb0[5].zw + cb0[5].xy;
  r1.xyz = colorTexture.Sample(s5_s, r0.xy).xyz;
  float3 unclamped = r1.xyz;

  r1.xyz = saturate(MaxChTonemapToOne(unclamped));

  r0.xy = cb1[139].zw * r0.zw;
  r0.z = t1.SampleLevel(s0_s, r0.xy, 0).x;
  r0.w = r0.z * cb1[66].z + -cb1[66].w;
  r0.z = r0.z * cb1[66].x + cb1[66].y;
  r0.w = 1 / r0.w;
  r0.z = r0.z + r0.w;
  r0.w = t0.SampleLevel(s0_s, r0.xy, 0).x;
  r0.xy = cb1[139].xy * r0.xy;
  r2.xy = (uint2)r0.xy;
  r0.x = r0.w * cb1[66].z + -cb1[66].w;
  r0.y = r0.w * cb1[66].x + cb1[66].y;
  r0.x = 1 / r0.x;
  r0.x = r0.y + r0.x;
  r0.x = r0.z + -r0.x;
  r0.y = -20 + r0.x;
  r0.x = cmp(r0.x >= 20);
  r0.x = r0.x ? 0 : 1;
  r0.y = cmp(9.99999975e-06 < abs(r0.y));
  r0.x = r0.y ? r0.x : 0;
  r2.zw = float2(0, 0);
  r0.y = t2.Load(r2.xyz).y;
  r0.y = (uint)r0.y;
  r0.y = min(1, r0.y);
  r0.x = r0.y * r0.x;
  r0.y = 63 * r1.z;
  r0.z = floor(r0.y);
  r0.w = 0.125 * r0.z;
  r2.y = floor(r0.w);
  r2.x = -r2.y * 8 + r0.z;
  r0.z = ceil(r0.y);
  r0.y = frac(r0.y);
  r0.w = 0.125 * r0.z;
  r2.w = floor(r0.w);
  r2.z = -r2.w * 8 + r0.z;
  r3.xyzw = r1.xyxy * float4(0.123046882, 0.123046882, 0.123046882, 0.123046882) + float4(0.0009765625, 0.0009765625, 0.0009765625, 0.0009765625);
  r2.xyzw = r2.xyzw * float4(0.125, 0.125, 0.125, 0.125) + r3.xyzw;

  // LUT4 Sampling
  r3.xyz = lut4.Sample(s4_s, r2.zw).xyz;
  r4.xyz = lut4.Sample(s4_s, r2.xy).xyz;
  r3.xyz = -r4.xyz + r3.xyz;
  r3.xyz = r0.yyy * r3.xyz + r4.xyz;
  r3.xyz = r3.xyz + -r1.xyz;
  r3.xyz = cb3[1].www * r3.xyz + r1.xyz;

  // LUT3 Sampling
  r4.xyz = lut3.Sample(s3_s, r2.zw).xyz;
  r5.xyz = lut3.Sample(s3_s, r2.xy).xyz;
  r4.xyz = -r5.xyz + r4.xyz;
  r4.xyz = r0.yyy * r4.xyz + r5.xyz;
  r4.xyz = r4.xyz + -r1.xyz;
  r4.xyz = cb3[1].www * r4.xyz + r1.xyz;

  r3.xyz = -r4.xyz + r3.xyz;
  r3.xyz = cb3[0].yyy * r3.xyz;
  r3.xyz = r3.xyz * float3(0.5, 0.5, 0.5) + r4.xyz;
  r4.xyz = float3(1, 1, 1) + -r3.xyz;
  r3.xyz = (cb3[2].xxx * r3.xyz);  // saturate
  r4.xyz = (cb3[2].www * r4.xyz);  // saturate
  r0.z = -cb3[3].x + cb3[2].y;
  r4.xyz = r4.xyz * r0.zzz + cb3[3].xxx;
  r0.z = cb3[2].y + -cb3[2].z;
  r5.xyz = r3.xyz * r0.zzz + cb3[2].zzz;
  r3.xyz = floor(r3.xyz);
  r4.xyz = -r5.xyz + r4.xyz;
  r3.xyz = (r3.xyz * r4.xyz + r5.xyz);  // saturate

  // LUT2 Sampling
  r4.xyz = lut2.Sample(s2_s, r2.zw).xyz;
  r5.xyz = lut2.Sample(s2_s, r2.xy).xyz;
  r4.xyz = -r5.xyz + r4.xyz;
  r4.xyz = r0.yyy * r4.xyz + r5.xyz;
  r4.xyz = r4.xyz + -r1.xyz;
  r4.xyz = cb3[0].xxx * r4.xyz + r1.xyz;

  // LUT1 Sampling
  r5.xyz = lut1.Sample(s1_s, r2.zw).xyz;
  r2.xyz = lut1.Sample(s1_s, r2.xy).xyz;
  r5.xyz = r5.xyz + -r2.xyz;
  r0.yzw = r0.yyy * r5.xyz + r2.xyz;
  r0.yzw = r0.yzw + -r1.xyz;
  r0.yzw = cb3[0].xxx * r0.yzw + r1.xyz;
  r2.xyz = r4.xyz + -r0.yzw;
  r2.xyz = cb3[0].yyy * r2.xyz;

  r0.yzw = r2.xyz * float3(0.5, 0.5, 0.5) + r0.yzw;
  r2.xyz = (cb3[0].zzz * r0.yzw);  // saturate
  r0.yzw = float3(1, 1, 1) + -r0.yzw;
  r0.yzw = (cb3[1].yyy * r0.yzw);  // saturate
  r4.xyz = floor(r2.xyz);
  r5.xy = -cb3[1].xz + cb3[0].ww;
  r0.yzw = r0.yzw * r5.yyy + cb3[1].zzz;
  r2.xyz = r2.xyz * r5.xxx + cb3[1].xxx;
  r0.yzw = -r2.xyz + r0.yzw;
  r0.yzw = (r4.xyz * r0.yzw + r2.xyz);  // saturate
  r2.xyz = r3.xyz + -r0.yzw;
  r0.xyz = r0.xxx * r2.xyz + r0.yzw;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = cb3[3].yyy * r0.xyz + r1.xyz;
  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r1.x = min(r0.y, r0.z);
  r1.x = min(r1.x, r0.x);
  r0.w = -r1.x + r0.w;
  r1.x = cmp(0 < cb2[9].x);
  r1.y = cmp(cb2[9].x < 0);
  r1.x = (int)-r1.x + (int)r1.y;
  r1.x = (int)r1.x;
  r0.w = -r0.w * r1.x + 1;
  r0.w = r0.w * cb2[9].x + 1;
  r0.w = max(0, r0.w);
  r1.x = dot(float3(0.212656006, 0.715157986, 0.0721860006), r0.xyz);
  r0.xyz = -r1.xxx + r0.xyz;
  r0.xyz = r0.www * r0.xyz + r1.xxx;
  r1.xyz = cb3[4].xyz + -r0.xyz;
  r0.xyz = cb3[3].zzz * r1.xyz + r0.xyz;
  // o0.xyz = max(float3(0, 0, 0), r0.xyz);
  o0.xyz = r0.xyz;
  o0.w = 1;

  o0.xyz = renodx::tonemap::UpgradeToneMap(
      unclamped,
      MaxChTonemapToOne(unclamped),
      MaxChTonemapToOne(o0.xyz),
      1.f);

  return;
}
