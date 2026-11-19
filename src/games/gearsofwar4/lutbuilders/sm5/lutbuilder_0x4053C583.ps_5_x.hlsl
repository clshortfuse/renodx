// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 10 12:23:03 2026
#include "../legacy.hlsl"
Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb0 : register(b0) {
  float4 cb0[43];
}

// 3Dmigoto declarations
#define cmp -

void main(
    linear noperspective float2 v0 : TEXCOORD0,
    float4 v1 : SV_POSITION0,
    uint v2 : SV_RenderTargetArrayIndex0,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7;
  uint4 bitmask, uiDest;
  float4 fDest;
  o0 = 0.f;

  r0.x = (uint)v2.x;
  r0.z = 0.0322580636 * r0.x;
  r0.xy = v0.xy;
  r0.xyz = float3(-0.434017599, -0.434017599, -0.434017599) + r0.xyz;
  r0.xyz = float3(14, 14, 14) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r0.w = 1.00055635 * cb0[37].x;
  r1.x = cmp(6996.10791 >= cb0[37].x);
  r1.yz = float2(4.60700006e+009, 2.0064e+009) / r0.ww;
  r1.yz = float2(2967800, 1901800) + -r1.yz;
  r1.yz = r1.yz / r0.ww;
  r1.yz = float2(99.1100006, 247.479996) + r1.yz;
  r1.yz = r1.yz / r0.ww;
  r1.yz = float2(0.244063005, 0.237039998) + r1.yz;
  r1.x = r1.x ? r1.y : r1.z;
  r0.w = r1.x * r1.x;
  r1.z = 2.86999989 * r1.x;
  r0.w = r0.w * -3 + r1.z;
  r1.y = -0.275000006 + r0.w;
  r2.xyz = cb0[37].xxx * float3(0.000154118257, 0.00084242021, 4.22806261e-005) + float3(0.860117733, 1, 0.317398727);
  r0.w = cb0[37].x * cb0[37].x;
  r2.xyz = r0.www * float3(1.28641219e-007, 7.08145137e-007, 4.20481676e-008) + r2.xyz;
  r2.x = r2.x / r2.y;
  r1.z = -cb0[37].x * 2.8974182e-005 + 1;
  r0.w = r0.w * 1.61456057e-007 + r1.z;
  r2.y = r2.z / r0.w;
  r1.zw = r2.xy + r2.xy;
  r0.w = 3 * r2.x;
  r1.z = -r2.y * 8 + r1.z;
  r1.z = 4 + r1.z;
  r3.x = r0.w / r1.z;
  r3.y = r1.w / r1.z;
  r0.w = cmp(cb0[37].x < 4000);
  r1.xy = r0.ww ? r3.xy : r1.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = rsqrt(r0.w);
  r1.zw = r2.xy * r0.ww;
  r0.w = cb0[37].y * -r1.w;
  r0.w = r0.w * 0.0500000007 + r2.x;
  r1.z = cb0[37].y * r1.z;
  r1.z = r1.z * 0.0500000007 + r2.y;
  r1.w = 3 * r0.w;
  r0.w = r0.w + r0.w;
  r0.w = -r1.z * 8 + r0.w;
  r0.w = 4 + r0.w;
  r1.z = r1.z + r1.z;
  r2.xy = r1.wz / r0.ww;
  r1.zw = r2.xy + -r3.xy;
  r1.xy = r1.xy + r1.zw;
  r0.w = max(1.00000001e-010, r1.y);
  r2.x = r1.x / r0.w;
  r1.x = 1 + -r1.x;
  r1.x = r1.x + -r1.y;
  r2.z = r1.x / r0.w;
  r2.y = 1;
  r0.w = dot(float3(0.895099998, 0.266400009, -0.161400005), r2.xyz);
  r1.x = dot(float3(-0.750199974, 1.71350002, 0.0366999991), r2.xyz);
  r1.y = dot(float3(0.0388999991, -0.0684999973, 1.02960002), r2.xyz);
  r0.w = 0.941379249 / r0.w;
  r1.xy = float2(1.04043639, 1.0897665) / r1.xy;
  r2.xyz = float3(0.895099998, 0.266400009, -0.161400005) * r0.www;
  r1.xzw = float3(-0.750199974, 1.71350002, 0.0366999991) * r1.xxx;
  r3.xyz = float3(0.0388999991, -0.0684999973, 1.02960002) * r1.yyy;
  r4.x = r2.x;
  r4.y = r1.x;
  r4.z = r3.x;
  r5.x = dot(float3(0.986992896, -0.1470543, 0.159962699), r4.xyz);
  r6.x = r2.y;
  r6.y = r1.z;
  r6.z = r3.y;
  r5.y = dot(float3(0.986992896, -0.1470543, 0.159962699), r6.xyz);
  r3.x = r2.z;
  r3.y = r1.w;
  r5.z = dot(float3(0.986992896, -0.1470543, 0.159962699), r3.xyz);
  r1.x = dot(float3(0.432305306, 0.518360317, 0.0492912009), r4.xyz);
  r1.y = dot(float3(0.432305306, 0.518360317, 0.0492912009), r6.xyz);
  r1.z = dot(float3(0.432305306, 0.518360317, 0.0492912009), r3.xyz);
  r2.x = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r4.xyz);
  r2.y = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r6.xyz);
  r2.z = dot(float3(-0.0085287001, 0.040042799, 0.968486726), r3.xyz);
  r3.x = dot(r5.xyz, float3(0.412456393, 0.212672904, 0.0193339009));
  r4.x = dot(r5.xyz, float3(0.357576102, 0.715152204, 0.119191997));
  r5.x = dot(r5.xyz, float3(0.180437505, 0.0721750036, 0.950304091));
  r3.y = dot(r1.xyz, float3(0.412456393, 0.212672904, 0.0193339009));
  r4.y = dot(r1.xyz, float3(0.357576102, 0.715152204, 0.119191997));
  r5.y = dot(r1.xyz, float3(0.180437505, 0.0721750036, 0.950304091));
  r3.z = dot(r2.xyz, float3(0.412456393, 0.212672904, 0.0193339009));
  r4.z = dot(r2.xyz, float3(0.357576102, 0.715152204, 0.119191997));
  r5.z = dot(r2.xyz, float3(0.180437505, 0.0721750036, 0.950304091));
  r1.x = dot(float3(3.2409699, -1.5373832, -0.498610765), r3.xyz);
  r1.y = dot(float3(3.2409699, -1.5373832, -0.498610765), r4.xyz);
  r1.z = dot(float3(3.2409699, -1.5373832, -0.498610765), r5.xyz);
  r2.x = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r3.xyz);
  r2.y = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r4.xyz);
  r2.z = dot(float3(-0.969243646, 1.8759675, 0.0415550582), r5.xyz);
  r3.x = dot(float3(0.0556300804, -0.203976959, 1.05697155), r3.xyz);
  r3.y = dot(float3(0.0556300804, -0.203976959, 1.05697155), r4.xyz);
  r3.z = dot(float3(0.0556300804, -0.203976959, 1.05697155), r5.xyz);
  r1.x = dot(r1.xyz, r0.xyz);
  r1.y = dot(r2.xyz, r0.xyz);
  r1.z = dot(r3.xyz, r0.xyz);
  r0.x = dot(r1.xyz, float3(0.300000012, 0.600000024, 0.100000001));
  r0.yzw = r1.xyz + -r0.xxx;
  r0.xyz = cb0[38].xyz * r0.yzw + r0.xxx;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[39].xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r1.xyz = float3(1, 1, 1) / cb0[40].xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * cb0[41].xyz + cb0[42].xyz;

  SetGearsUntonemappedBT709(r0.xyz);
  bool legacy_tonemapper = cb0[28].w == 0.f;
  float3 legacy_curve_input = 0.f;
  r0.w = cmp(cb0[28].w == 0.000000);
  if (r0.w != 0) {
    r1.x = dot(r0.xyz, cb0[21].xyz);
    r1.y = dot(r0.xyz, cb0[22].xyz);
    r1.z = dot(r0.xyz, cb0[23].xyz);
    r0.w = dot(r0.xyz, cb0[26].xyz);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    r2.xyz = cb0[28].xyz * r0.www + cb0[27].xyz;
    r1.xyz = r2.xyz * r1.xyz;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    legacy_curve_input = r1.xyz;
    r2.xyz = cb0[24].xxx + -r1.xyz;
    r2.xyz = max(float3(0, 0, 0), r2.xyz);
    r3.xyz = max(cb0[24].zzz, r1.xyz);
    r1.xyz = max(cb0[24].xxx, r1.xyz);
    r1.xyz = min(cb0[24].zzz, r1.xyz);
    r4.xyz = r3.xyz * cb0[25].xxx + cb0[25].yyy;
    r3.xyz = cb0[24].www + r3.xyz;
    r3.xyz = rcp(r3.xyz);
    r5.xyz = cb0[21].www * r2.xyz;
    r2.xyz = cb0[24].yyy + r2.xyz;
    r2.xyz = rcp(r2.xyz);
    r2.xyz = r5.xyz * r2.xyz + cb0[22].www;
    r1.xyz = r1.xyz * cb0[23].www + r2.xyz;
    r1.xyz = r4.xyz * r3.xyz + r1.xyz;
    r1.xyz = float3(-0.00200000009, -0.00200000009, -0.00200000009) + r1.xyz;
  } else {
    r0.w = dot(float3(0.439700812, 0.382978052, 0.1773348), r0.xyz);
    r2.y = dot(float3(0.0897923037, 0.813423157, 0.096761629), r0.xyz);
    r2.z = dot(float3(0.0175439864, 0.111544058, 0.870704114), r0.xyz);
    r0.x = min(r2.y, r0.w);
    r0.x = min(r0.x, r2.z);
    r0.y = max(r2.y, r0.w);
    r0.y = max(r0.y, r2.z);
    r0.xyz = max(float3(1.00000001e-010, 1.00000001e-010, 0.00999999978), r0.xyy);
    r0.x = r0.y + -r0.x;
    r0.x = r0.x / r0.z;
    r0.y = cmp(r0.w == r2.y);
    r0.z = cmp(r2.z == r2.y);
    r0.y = r0.z ? r0.y : 0;
    r0.z = r2.y + -r2.z;
    r0.z = 1.73205078 * r0.z;
    r1.w = r0.w * 2 + -r2.y;
    r1.w = r1.w + -r2.z;
    r2.w = min(abs(r1.w), abs(r0.z));
    r3.x = max(abs(r1.w), abs(r0.z));
    r3.x = 1 / r3.x;
    r2.w = r3.x * r2.w;
    r3.x = r2.w * r2.w;
    r3.y = r3.x * 0.0208350997 + -0.0851330012;
    r3.y = r3.x * r3.y + 0.180141002;
    r3.y = r3.x * r3.y + -0.330299497;
    r3.x = r3.x * r3.y + 0.999866009;
    r3.y = r3.x * r2.w;
    r3.z = cmp(abs(r1.w) < abs(r0.z));
    r3.y = r3.y * -2 + 1.57079637;
    r3.y = r3.z ? r3.y : 0;
    r2.w = r2.w * r3.x + r3.y;
    r3.x = cmp(r1.w < -r1.w);
    r3.x = r3.x ? -3.141593 : 0;
    r2.w = r3.x + r2.w;
    r3.x = min(r1.w, r0.z);
    r0.z = max(r1.w, r0.z);
    r1.w = cmp(r3.x < -r3.x);
    r0.z = cmp(r0.z >= -r0.z);
    r0.z = r0.z ? r1.w : 0;
    r0.z = r0.z ? -r2.w : r2.w;
    r0.z = 57.2957802 * r0.z;
    r0.y = r0.y ? 0 : r0.z;
    r0.z = cmp(r0.y < 0);
    r1.w = 360 + r0.y;
    r0.y = r0.z ? r1.w : r0.y;
    r0.y = max(0, r0.y);
    r0.y = min(360, r0.y);
    r0.z = cmp(180 < r0.y);
    r1.w = -360 + r0.y;
    r0.y = r0.z ? r1.w : r0.y;
    r0.y = 0.0148148146 * r0.y;
    r0.y = 1 + -abs(r0.y);
    r0.y = max(0, r0.y);
    r0.z = r0.y * -2 + 3;
    r0.y = r0.y * r0.y;
    r0.y = r0.z * r0.y;
    r0.y = r0.y * r0.y;
    r0.x = r0.y * r0.x;
    r0.y = 0.0299999993 + -r0.w;
    r0.x = r0.x * r0.y;
    r2.x = r0.x * 0.180000007 + r0.w;
    r0.x = dot(float3(1.45143926, -0.236510754, -0.214928567), r2.xyz);
    r0.y = dot(float3(-0.0765537769, 1.17622972, -0.0996759236), r2.xyz);
    r0.z = dot(float3(0.00831614807, -0.00603244966, 0.997716308), r2.xyz);
    r0.xyz = max(float3(0, 0, 0), r0.xyz);

    r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = r0.xyz * float3(0.959999979, 0.959999979, 0.959999979) + r0.www;
    r2.xy = float2(1, 0.180000007) + cb0[29].ww;
    r0.w = -cb0[29].y + r2.x;
    r1.w = 1 + cb0[30].x;
    r2.x = -cb0[29].z + r1.w;
    r2.z = cmp(0.800000012 < cb0[29].y);
    r3.xy = float2(0.819999993, 1) + -cb0[29].yy;
    r3.xy = r3.xy / cb0[29].xx;
    r2.w = -0.744727492 + r3.x;
    r2.y = r2.y / r0.w;
    r3.x = -1 + r2.y;
    r3.x = 1 + -r3.x;
    r2.y = r2.y / r3.x;
    r2.y = log2(r2.y);
    r2.y = 0.346573591 * r2.y;
    r3.x = r0.w / cb0[29].x;
    r2.y = -r2.y * r3.x + -0.744727492;
    r2.y = r2.z ? r2.w : r2.y;
    r2.z = r3.y + -r2.y;
    r2.w = cb0[29].z / cb0[29].x;
    r2.w = r2.w + -r2.z;
    r0.xyz = log2(r0.xyz);
    r3.xyz = float3(0.30103001, 0.30103001, 0.30103001) * r0.xyz;
    r4.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + r2.zzz;
    r4.xyz = cb0[29].xxx * r4.xyz;
    r2.z = r0.w + r0.w;
    r3.w = -2 * cb0[29].x;
    r0.w = r3.w / r0.w;
    r5.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r2.yyy;
    r6.xyz = r5.xyz * r0.www;
    r6.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r6.xyz;
    r6.xyz = exp2(r6.xyz);
    r6.xyz = float3(1, 1, 1) + r6.xyz;
    r6.xyz = r2.zzz / r6.xyz;
    r6.xyz = -cb0[29].www + r6.xyz;
    r0.w = r2.x + r2.x;
    r2.z = cb0[29].x + cb0[29].x;
    r2.x = r2.z / r2.x;
    r0.xyz = r0.xyz * float3(0.30103001, 0.30103001, 0.30103001) + -r2.www;
    r0.xyz = r2.xxx * r0.xyz;
    r0.xyz = float3(1.44269502, 1.44269502, 1.44269502) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = float3(1, 1, 1) + r0.xyz;
    r0.xyz = r0.www / r0.xyz;
    r0.xyz = r1.www + -r0.xyz;
    r7.xyz = cmp(r3.xyz < r2.yyy);
    r6.xyz = r7.xyz ? r6.xyz : r4.xyz;
    r3.xyz = cmp(r2.www < r3.xyz);
    r0.xyz = r3.xyz ? r0.xyz : r4.xyz;
    r0.w = r2.w + -r2.y;
    r3.xyz = saturate(r5.xyz / r0.www);
    r0.w = cmp(r2.w < r2.y);
    r2.xyz = float3(1, 1, 1) + -r3.xyz;
    r2.xyz = r0.www ? r2.xyz : r3.xyz;
    r3.xyz = -r2.xyz * float3(2, 2, 2) + float3(3, 3, 3);
    r2.xyz = r2.xyz * r2.xyz;
    r2.xyz = r2.xyz * r3.xyz;
    r0.xyz = r0.xyz + -r6.xyz;
    r0.xyz = r2.xyz * r0.xyz + r6.xyz;
    r0.w = dot(r0.xyz, float3(0.272228718, 0.674081743, 0.0536895171));
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = r0.xyz * float3(0.930000007, 0.930000007, 0.930000007) + r0.www;
    r2.x = dot(float3(1.70505154, -0.621790707, -0.0832583979), r0.xyz);
    r2.y = dot(float3(-0.130257145, 1.14080286, -0.0105485283), r0.xyz);
    r2.z = dot(float3(-0.0240032747, -0.128968775, 1.15297174), r0.xyz);
    r1.xyz = max(float3(0, 0, 0), r2.xyz);
  }

  // Keep the SDR curve for the grading LUT; carry its extended highlights
  // separately so the 16x16 LUT's required saturation cannot discard them.
  float3 neutral_legacy = saturate(r1.xyz);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    if (legacy_tonemapper) {
      SetGearsUntonemappedBT709(ExtendGearsLegacyShoulder(
          legacy_curve_input, r1.xyz, cb0[24].z, cb0[24].w,
          cb0[25].x, cb0[25].y));
    }
    SetTonemappedBT709(r1.xyz);
  }
  r1.xyz = saturate(r1.xyz);
  r0.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
  r2.xyz = cmp(r1.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
  r1.yzw = r0.xyz * float3(0.9375, 0.9375, 0.9375) + float3(0.03125, 0.03125, 0.03125);
  r0.w = r1.w * 16 + -0.5;
  r1.w = floor(r0.w);
  r0.w = -r1.w + r0.w;
  r1.y = r1.y + r1.w;
  r1.x = 0.0625 * r1.y;
  // 0x4053C583 is the same UE LUTBuilder family as 0x81222343, but it
  // blends TWO external 16x16 grading LUT strips. Preserve the original
  // coordinates so both textures are sampled identically.
  float2 renodx_lut_uv_a = r1.xz;
  float2 renodx_lut_uv_b = float2(0.0625, 0.0) + renodx_lut_uv_a;

  float3 renodx_lut0_a = t0.Sample(s0_s, renodx_lut_uv_a).xyz;
  float3 renodx_lut0_b = t0.Sample(s0_s, renodx_lut_uv_b).xyz;
  float3 renodx_lut1_a = t1.Sample(s1_s, renodx_lut_uv_a).xyz;
  float3 renodx_lut1_b = t1.Sample(s1_s, renodx_lut_uv_b).xyz;

  // Do not let a transient non-finite grading texture poison the FP16 3D LUT.
  bool renodx_lut_cell_invalid =
      any(isnan(renodx_lut0_a)) || any(isinf(renodx_lut0_a))
      || any(isnan(renodx_lut0_b)) || any(isinf(renodx_lut0_b))
      || any(isnan(renodx_lut1_a)) || any(isinf(renodx_lut1_a))
      || any(isnan(renodx_lut1_b)) || any(isinf(renodx_lut1_b));
  if (renodx_lut_cell_invalid) discard;

  float3 renodx_lut0 = lerp(renodx_lut0_a, renodx_lut0_b, r0.w);
  float3 renodx_lut1 = lerp(renodx_lut1_a, renodx_lut1_b, r0.w);

  // Exact vanilla weighting seen in the DXBC:
  //   base * cb0[31].x + LUT0 * cb0[32].x + LUT1 * cb0[33].x
  r0.xyz = cb0[31].xxx * r0.xyz
           + cb0[32].xxx * renodx_lut0
           + cb0[33].xxx * renodx_lut1;
  r0.xyz = max(float3(6.10351999e-005, 6.10351999e-005, 6.10351999e-005), r0.xyz);
  r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) < r0.xyz);
  r2.xyz = r0.xyz * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
  r2.xyz = log2(r2.xyz);
  r2.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r0.xyz;
  r0.xyz = r1.xyz ? r2.xyz : r0.xyz;
  r1.xyz = r0.xyz * r0.xyz;
  r0.xyz = cb0[19].yyy * r0.xyz;
  r0.xyz = cb0[19].xxx * r1.xyz + r0.xyz;
  r0.xyz = cb0[19].zzz + r0.xyz;
  r1.xyz = cb0[35].yzw * r0.xyz;
  r0.xyz = -r0.xyz * cb0[35].yzw + cb0[36].xyz;
  r0.xyz = cb0[36].www * r0.xyz + r1.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[20].yyy * r0.xyz;
  r1.xyz = exp2(r0.xyz);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    o0 = GenerateGearsLutOutput(r1.xyz, neutral_legacy, legacy_tonemapper, asuint(cb0[42].w));
    return;
  }
  if (cb0[42].w == 0) {
    r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r1.xyz;
    r3.xyz = cmp(r1.xyz >= float3(0.00313066994, 0.00313066994, 0.00313066994));
    r4.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r0.xyz;
    r4.xyz = exp2(r4.xyz);
    r4.xyz = r4.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r2.xyz = r3.xyz ? r4.xyz : r2.xyz;
  } else {
    r0.w = cmp(asint(cb0[42].w) == 1);
    r1.xyz = max(float3(6.10351999e-005, 6.10351999e-005, 6.10351999e-005), r1.xyz);
    r3.xyz = float3(4.5, 4.5, 4.5) * r1.xyz;
    r1.xyz = max(float3(0.0179999992, 0.0179999992, 0.0179999992), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.449999988, 0.449999988, 0.449999988) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.09899998, 1.09899998, 1.09899998) + float3(-0.0989999995, -0.0989999995, -0.0989999995);
    r1.xyz = min(r3.xyz, r1.xyz);
    r0.xyz = cb0[20].zzz * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r2.xyz = r0.www ? r1.xyz : r0.xyz;
  }
  o0.xyz = float3(0.952381015, 0.952381015, 0.952381015) * r2.xyz;
  return;
}
