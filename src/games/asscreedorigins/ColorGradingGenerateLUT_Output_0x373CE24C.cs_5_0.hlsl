#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sun Mar 23 12:28:12 2025

// clang-format off
cbuffer ColorGradingGenerateLUT_cbuffer : register(b6)
{
  struct
  {
    uint UseRec2020;
    float WhiteScale;
    float MaxNitsHDRTV;

    struct
    {
      float3 WhitePointScale;
      float Exposure;
      float Contrast;
      float Saturation;
      float Highlights;
      float Shadows;
      float Whites;
      float Blacks;
      float Shoulder;
      float Toe;
      float4 HueAdjustments[10];
      float SplitBalance;
      float SplitWidth;
      float HueHighlights;
      float SaturationHighlights;
      float HueShadows;
      float SaturationShadows;
    } Parameters;
  } ColorGradingGenerateLUT_constants: packoffset(c0);
  // clang-format on
}

SamplerState ColorGradingGenerateLUT_lutSampler_s : register(s13);
Texture3D<float4> ColorGradingGenerateLUT_Aces2OutputLUT : register(t99);
RWTexture3D<float4> ColorGradingGenerateLUT_Output : register(u1);

// 3Dmigoto declarations
#define cmp -
#define DISPATCH_BLOCK

[numthreads(16, 16, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  const float4 icb[] = { { -0.153700, 0, 0, 0 },
                         { 0.013500, 0, 0, 0 },
                         { 0.131200, 0, 0, 0 },
                         { 0.209290, 0, 0, 0 },
                         { 0.285800, 0, 0, 0 },
                         { 0.513000, 0, 0, 0 },
                         { 0.668800, 0, 0, 0 },
                         { 0.746000, 0, 0, 0 },
                         { 0.846300, 0, 0, 0 },
                         { 1.013500, 0, 0, 0 } };
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture3d (float,float,float,float) u1
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 16, 16, 1
  r0.xyz = (uint3)vThreadID.xyz;
  r0.xyz = r0.xyz * float3(0.548387051, 0.548387051, 0.548387051) + float3(-8.97393131, -8.97393131, -8.97393131);
  r0.xyz = exp2(r0.xyz);
  r1.x = dot(r0.xyz, float3(0.613097012, 0.339522988, 0.0473795012));
  r1.y = dot(r0.xyz, float3(0.0701937005, 0.916354001, 0.0134524005));
  r1.z = dot(r0.xyz, float3(0.0206156, 0.109569997, 0.869814992));
  r0.xyz = ColorGradingGenerateLUT_constants.Parameters.WhitePointScale.xyz * r1.xyz;
  r0.xyz = ColorGradingGenerateLUT_constants.Parameters.Exposure * r0.xyz;

#if 1  // Lowering exposure to get SDR and HDR to roughly match, too inconsistent
  if (ColorGradingGenerateLUT_constants.UseRec2020 != 0) r0.rgb /= 2.5f;  // Match SDR Exposure
#endif

  r0.w = cmp(r0.y < r0.z);
  r1.xy = r0.zy;
  r1.zw = float2(-1, 0.666666687);
  r2.xy = r1.yx;
  r2.zw = float2(0, -0.333333343);
  r1.xyzw = r0.wwww ? r1.xyzw : r2.xyzw;
  r0.w = cmp(r0.x < r1.x);
  r2.xyz = r1.xyw;
  r2.w = r0.x;
  r1.xyw = r2.wyx;
  r1.xyzw = r0.wwww ? r2.xyzw : r1.xyzw;
  r0.w = min(r1.w, r1.y);
  r0.w = r1.x + -r0.w;
  r0.x = dot(r0.xyz, float3(0.333333343, 0.333333343, 0.333333343));
  r0.y = r1.w + -r1.y;
  r0.z = r0.w * 6 + 1.00000001e-10;
  r0.y = r0.y / r0.z;
  r0.y = r1.z + r0.y;
  r0.z = 1.00000001e-10 + r1.x;
  r0.z = r0.w / r0.z;
  r0.x = log2(r0.x);
  r0.x = r0.x * 0.0588235296 + 0.0278782845;
  r0.x = r0.x * ColorGradingGenerateLUT_constants.Parameters.Contrast + 0.5;
  r0.x = max(0, r0.x);
  r0.w = -0.5 + r0.x;
  r0.w = abs(r0.w) * abs(r0.w);
  r0.w = -r0.w * 4 + 1;
  r0.w = max(0, r0.w);
  r1.x = r0.x * ColorGradingGenerateLUT_constants.Parameters.Shoulder + -r0.x;
  r0.x = r0.w * r1.x + r0.x;
  r0.w = saturate(1 + -r0.x);
  r1.x = log2(abs(r0.x));
  r1.x = ColorGradingGenerateLUT_constants.Parameters.Toe * r1.x;
  r1.x = exp2(r1.x);
  r0.w = r0.w * r0.w;
  r1.x = r1.x + -r0.x;
  r0.x = r0.w * r1.x + r0.x;
  r0.w = -0.850000024 + r0.x;
  r0.w = r0.w * r0.w;
  r0.w = -12.499999 * r0.w;
  r0.w = exp2(r0.w);
  r1.xy = cmp(float2(0, 0) < ColorGradingGenerateLUT_constants.Parameters.Highlights);
  r1.z = log2(abs(r0.x));
  r1.z = 0.125 * r1.z;
  r1.z = exp2(r1.z);
  r1.w = abs(r0.x) * abs(r0.x);
  r1.w = r1.w * abs(r0.x);
  r1.x = r1.x ? r1.z : r1.w;
  r0.w = abs(ColorGradingGenerateLUT_constants.Parameters.Highlights) * r0.w;
  r1.x = r1.x + -r0.x;
  r0.x = r0.w * r1.x + r0.x;
  r0.w = -0.100000001 + r0.x;
  r0.w = r0.w * r0.w;
  r0.w = -49.9999962 * r0.w;
  r0.w = exp2(r0.w);
  r1.x = rsqrt(abs(r0.x));
  r1.x = 1 / r1.x;
  r1.z = abs(r0.x) * abs(r0.x);
  r1.z = r1.z * r1.z;
  r1.z = r1.z * r1.z;
  r1.x = r1.y ? r1.x : r1.z;
  r0.w = abs(ColorGradingGenerateLUT_constants.Parameters.Shadows) * r0.w;
  r1.x = r1.x + -r0.x;
  r0.x = r0.w * r1.x + r0.x;
  r0.w = -1 + r0.x;
  r0.w = r0.w * r0.w;
  r0.w = -19.53125 * r0.w;
  r0.w = exp2(r0.w);
  r1.xy = cmp(float2(0, 0) < ColorGradingGenerateLUT_constants.Parameters.Whites);
  r1.z = log2(abs(r0.x));
  r1.z = 0.00390625 * r1.z;
  r1.z = exp2(r1.z);
  r1.w = abs(r0.x) * abs(r0.x);
  r1.w = r1.w * abs(r0.x);
  r1.x = r1.x ? r1.z : r1.w;
  r0.w = abs(ColorGradingGenerateLUT_constants.Parameters.Whites) * r0.w;
  r1.x = r1.x + -r0.x;
  r0.x = r0.w * r1.x + r0.x;
  r0.w = r0.x * r0.x;
  r0.w = -49.9999962 * r0.w;
  r0.w = exp2(r0.w);
  r1.x = log2(abs(r0.x));
  r1.xz = float2(0.600000024, 32) * r1.xx;
  r1.xz = exp2(r1.xz);
  r1.x = r1.y ? r1.x : r1.z;
  r0.w = abs(ColorGradingGenerateLUT_constants.Parameters.Blacks) * r0.w;
  r1.x = r1.x + -r0.x;
  r0.x = r0.w * r1.x + r0.x;
  r0.z = saturate(ColorGradingGenerateLUT_constants.Parameters.Saturation * r0.z);
  r0.w = 0;
  r1.xyzw = float4(0, 0, 0, 0);
  while (true) {
    r2.x = cmp((int)r1.w >= 10);
    if (r2.x != 0) break;
    r2.x = icb[r1.w + 0].x + -abs(r0.y);
    r2.x = r2.x * r2.x;
    r2.x = -128 * r2.x;
    r2.x = exp2(r2.x);
    r1.xyz = ColorGradingGenerateLUT_constants.Parameters.HueAdjustments[r1.w].xyz * r2.xxx + r1.xyz;
    r0.w = r2.x + r0.w;
    r1.w = (int)r1.w + 1;
  }
  r0.w = 1 / r0.w;
  r1.w = sqrt(r0.z);
  r1.xyz = r1.xyz * r0.www + float3(-0, -1, -1);
  r1.xyz = r1.www * r1.xyz + float3(0, 1, 1);
  r0.y = r1.x + abs(r0.y);
  r0.y = frac(r0.y);
  r0.z = saturate(r1.y * r0.z);
  r0.x = saturate(r1.z * r0.x);
  r0.w = r0.x * 17 + -8.97393131;
  r0.w = exp2(r0.w);
  r1.xyz = float3(1, 0.666666687, 0.333333343) + r0.yyy;
  r1.xyz = frac(r1.xyz);
  r1.xyz = r1.xyz * float3(6, 6, 6) + float3(-3, -3, -3);
  r1.xyz = saturate(float3(-1, -1, -1) + abs(r1.xyz));
  r1.xyz = float3(-1, -1, -1) + r1.xyz;
  r1.xyz = r0.zzz * r1.xyz + float3(1, 1, 1);
  r0.y = dot(r1.xyz, float3(0.333333343, 0.333333343, 0.333333343));
  r1.xyz = r1.xyz * r0.www;
  r0.y = rcp(r0.y);
  r1.xyz = r1.xyz * r0.yyy;
  r2.xyz = ColorGradingGenerateLUT_constants.Parameters.HueHighlights + float3(1, 0.666666687, 0.333333343);
  r2.xyz = frac(r2.xyz);
  r2.xyz = r2.xyz * float3(6, 6, 6) + float3(-3, -3, -3);
  r2.xyz = saturate(float3(-1, -1, -1) + abs(r2.xyz));
  r0.y = dot(r2.xyz, float3(0.333333343, 0.333333343, 0.333333343));
  r2.xyz = r2.xyz * r0.www;
  r3.xyz = ColorGradingGenerateLUT_constants.Parameters.HueShadows + float3(1, 0.666666687, 0.333333343);
  r3.xyz = frac(r3.xyz);
  r3.xyz = r3.xyz * float3(6, 6, 6) + float3(-3, -3, -3);
  r3.xyz = saturate(float3(-1, -1, -1) + abs(r3.xyz));
  r0.z = dot(r3.xyz, float3(0.333333343, 0.333333343, 0.333333343));
  r3.xyz = r3.xyz * r0.www;
  r0.yz = rcp(r0.yz);
  r0.w = ColorGradingGenerateLUT_constants.Parameters.SaturationHighlights * 0.75;
  r2.xyz = r2.xyz * r0.yyy + -r1.xyz;
  r2.xyz = r0.www * r2.xyz + r1.xyz;
  r0.y = ColorGradingGenerateLUT_constants.Parameters.SaturationShadows * 0.75;
  r3.xyz = r3.xyz * r0.zzz + -r1.xyz;
  r0.yzw = r0.yyy * r3.xyz + r1.xyz;
  r0.x = -ColorGradingGenerateLUT_constants.Parameters.SplitBalance + r0.x;
  r0.x = saturate(r0.x * ColorGradingGenerateLUT_constants.Parameters.SplitWidth + 0.5);
  r1.x = r0.x * r0.x;
  r0.x = -r0.x * 2 + 3;
  r0.x = r1.x * r0.x;
  r1.xyz = r2.xyz + -r0.yzw;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;

#if 1
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0588235296, 0.0588235296, 0.0588235296) + float3(0.527878284, 0.527878284, 0.527878284));
  r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  r0.xyz = ColorGradingGenerateLUT_Aces2OutputLUT.SampleLevel(ColorGradingGenerateLUT_lutSampler_s, r0.xyz, 0).xyz;
#else  // tonemap per frame
  r0.rgb = ApplyToneMapEncodePQ(r0.rgb, ColorGradingGenerateLUT_constants.MaxNitsHDRTV, ColorGradingGenerateLUT_constants.WhiteScale);
#endif
  r0.w = 1;
  // No code for instruction (needs manual fix):
  ColorGradingGenerateLUT_Output[vThreadID] = r0;  // store_uav_typed u1.xyzw, vThreadID.xyzz, r0.xyzw
  return;
}
