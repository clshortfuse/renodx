#include "./shared.h"

// Resource Bindings:
//
// Name                                 Type  Format         Dim      ID      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- ------- -------------- ------
// Sampler                           sampler      NA          NA      S0      s0,space8      1
// Texture                           texture  float4          2d      T0      t0,space8      1
// PerceptualTexture                 texture  float4          2d      T1      t1,space8      1
// ShaderInstance_PerInstance        cbuffer      NA          NA     CB0     cb0,space8      1
SamplerState Sampler : register(s0, space8);
Texture2D<float4> Texture : register(t0, space8);
Texture2D<float4> PerceptualTexture : register(t1, space8);

// Buffer Definitions:
struct InUniform_Constant {
  float4 mOETFSettings;      // Offset: 0
  float4 mKjpGammaSettings;  // Offset: 16
};

struct ShaderInstance_PerInstance_Constants {
  InUniform_Constant mInUniform_Constant;
};

cbuffer ShaderInstance_PerInstance : register(b0, space8) {
  ShaderInstance_PerInstance_Constants cShaderInstance_PerInstance_Constants;
};

// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_POSITION              0   xyzw        0      POS   float
// TEXCOORD                 0   xy          1     NONE   float   xy
struct PSInput {
  float4 position : SV_POSITION;  // Screen-space position       dcl_output o0.xyzw
  float2 texcoord : TEXCOORD0;    // Texture coordinates         dcl_input_ps linear v1.xy
};

void main(PSInput input, out float4 SV_TARGET: SV_TARGET) {
  float4 r0, r1, r2, r3, r4;

  r0.xyzw = Texture.Sample(Sampler, input.texcoord);                                                    // sample r0.xyzw, v1.xyxx, T0[0].xyzw, S0[0]
  r1.xyz = PerceptualTexture.Sample(Sampler, input.texcoord).xyz;                                       // sample r1.xyz, v1.xyxx, T1[1].xyzw, S0[0]
  r0 = saturate(r0);                                                                                    // mov_sat r0.xyzw, r0.xyzw
  r0.xyz = sqrt(r0.xyz);                                                                                // sqrt r0.xyz, r0.xyzx
  r0.xyz = pow(r0.xyz, cShaderInstance_PerInstance_Constants.mInUniform_Constant.mKjpGammaSettings.x);  // r0.xyz = exp(log(r0.xyz) * CB0[0][1].x);

  // Perform an AND operation between r0 and r2 to mask the results
  r2.xyz = (float3(0.0, 0.0, 0.0) < r0.xyz) ? 1.0f : 0.0f;  // lt r2.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r0.xyzx
  r0.xyz *= r2.xyz;                                         // and r0.xyz, r0.xyzx, r2.xyzx
  // uint mask previously r1.w in asm
  uint mask = uint(cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.w);  // ftoi r1.w, CB0[0][0].w
  r2.xy = (mask == uint2(1, 2)) ? float2(1.0, 1.0) : float2(0.0, 0.0);                          // ieq r2.xy, r1.wwww, l(1, 2, 0, 0)

  if (r2.x != 0) {  // Handle OETF processing for mask 1/2 case
    r3.xyz = (r1.xyz < float3(0.040450, 0.040450, 0.040450)) ? float3(1.0, 1.0, 1.0) : float3(0.0, 0.0, 0.0);
    r2.zw = r1.xy * float2(0.077399, 0.077399);                                            // mul r2.zw, r1.xxxy, l(0.000000, 0.000000, 0.077399, 0.077399)
    r4.xy = r1.xy * float2(0.947867, 0.947867) + float2(0.052133, 0.052133);               // mad r4.xy, r1.xyxx, l(0.947867, 0.947867, 0.000000, 0.000000), l(0.052133, 0.052133, 0.000000, 0.000000)
    r4.xy = pow(r4.xy, 2.4);                                                               // r4.xy = exp(log(r4.xy) * 2.4);
    r2.zw = (r3.x != 0) ? r2.zw : r4.xy;                                                   // movc r2.zw, r3.xxxy, r2.zzzw, r4.xxxy
    r3.z = r1.z * 0.077399;                                                                // mul r3.x, r1.z, l(0.077399)
    r3.y = r1.z * 0.947867 + 0.052133;                                                     // mad r3.y, r1.z, l(0.947867), l(0.052133)
    r3.y = pow(r3.y, 2.4);                                                                 // r3.y = exp(log(r3.y) * 2.4);
    r3.x = (r3.z != 0) ? r3.x : r3.y;                                                      // movc r3.x, r3.z, r3.x, r3.y
    r3.y = 1 / cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.x;  // div r3.y, l(1.000000, 1.000000, 1.000000, 1.000000), CB0[0][0].x
    // r4.xy = log(r2.zw);    // log r4.xy, r2.zwzz
    // r4.z = log(r3.x);    // log r4.z, r3.x
    // r3.xyz = r3.y * r4.xyz;    // mul r3.xyz, r3.yyyy, r4.xyzx
    // r1.xyz = exp(r3.xyz);   // exp r1.xyz, r3.xyzx
    r1.xyz = pow(float3(r2.zw, r3.x), r3.y);
  } else {
    uint maskAlt = 2;                                                                            // ieq r1.w, r1.w, l(2)
    if (mask == maskAlt) {                                                                       // if_nz r1.w
      r3.xyz = pow(r1.xyz, 0.012683);                                                            // r3.xyz = exp(log(r1.xyz) * 0.012683));
      r4.xyz = r3.xyz - 0.835938;                                                                // add r4.xyz, r3.xyzx, l(-0.835938, -0.835938, -0.835938, 0.000000)
      r3.xyz = -r3.xyz * 18.687500 + 18.851563;                                                  // mad r3.xyz, -r3.xyzx, l(18.687500, 18.687500, 18.687500, 0.000000), l(18.851563, 18.851563, 18.851563, 0.000000)
      r3.xyz = r4.xyz / r3.xyz;                                                                  // div r3.xyz, r4.xyzx, r3.xyzx
      r3.xyz = max(0, r3.xyz);                                                                   // max r3.xyz, r3.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
      r2.zw = 1.0 / cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.xy;  // div r2.zw, l(1.000000, 1.000000, 1.000000, 1.000000), CB0[0][0].xxxy
      r3.xyz = pow(r3.xyz, r2.z);                                                                // r3.xyz = exp(log(r3.xyz) * r2.z);
      r3.xyz *= r2.w;                                                                            // mul r3.xyz, r2.wwww, r3.xyzx
      r1.x = dot(float3(1.660490, -0.587641, -0.072850), r3.xyz);                                // dp3 r1.x, l(1.660490, -0.587641, -0.072850, 0.000000), r3.xyzx
      r1.y = dot(float3(-0.124550, 1.132900, -0.008349), r3.xyz);                                // dp3 r1.y, l(-0.124550, 1.132900, -0.008349, 0.000000), r3.xyzx
      r1.z = dot(float3(-0.018151, -0.100579, 1.118730), r3.xyz);                                // dp3 r1.z, l(-0.018151, -0.100579, 1.118730, 0.000000), r3.xyzx
    }
  }

  r0.w = 1 - r0.w;                                                                                       // add r0.w, -r0.w, l(1.000000)
  r1.xyz *= r0.w;                                                                                        // mul r1.xyz, r0.wwww, r1.xyzx
  r0.xyz = r0.xyz * r0.xyz + r1.xyz;                                                                     // mad r0.xyz, r0.xyzx, r0.xyzx, r1.xyzx
  r0.w = (cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.z > 0.0) ? 1.0 : 0.0;  // lt r0.w, l(0.000000), CB0[0][0].z
  r0.w = (r0.w != 0.0 && r2.y != 0.0) ? 1.0 : 0.0;                                                       // and r0.w, r0.w, r2.y

  if (r0.w != 0) {
    r1.xyz = (r0.xyz < float3(0.009300, 0.009300, 0.009300)) ? float3(1.0, 1.0, 1.0) : float3(0.0, 0.0, 0.0);  // lt r1.xyz, r0.xyzx, l(0.009300, 0.009300, 0.009300, 0.000000)

    // double check swizzle here
    r3.xyzw = float4(r0.xyzx * float4(0.333333, 0.333333, 0.333333, 4.30667));  // mul r3.xyzw, r0.xyzx, l(0.333333, 0.333333, 0.333333, 4.306667)

    r3.xyz = pow(r3.xyz, 1 / 2.4);           // exp(log(r3.xyz) * (1 / 2.4));
    r3.xyz = r3.xyz * 1.055000 - 0.055000;   // mad r3.xyz, r3.xyzx, l(1.055000, 1.055000, 1.055000, 0.000000), l(-0.055000, -0.055000, -0.055000, 0.000000)
    r0.w = (r1.x != 0) ? r3.w : r3.x;        // movc r0.w, r1.x, r3.w, r3.x
    r1.xw = r0.yz * 4.306667;                // mul r1.xw, r0.yyyz, l(4.306667, 0.000000, 0.000000, 4.306667)
    r1.xy = (r1.yz != 0.0) ? r1.xw : r3.yz;  // movc r1.xy, r1.yzyy, r1.xwxx, r3.yzyy
    // log r3.x, r0.w
    // log r3.yz, r1.xxyx
    // mul r1.xyz, r3.xyzx, l(2.200000, 2.200000, 2.200000, 0.000000)
    // exp r1.xyz, r1.xyzx

    r1.xyz = pow(float3(r0.w, r1.xy), 2.2);  // r1.xyz = exp(log(float3(r0.w, r1.xy) * 2.2));

    r1.xyz *= 3.0;                               // mul r1.xyz, r1.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
    r3.xyz = (r0.xyz >= 0.0) ? 1.0 : 0.0;        // ge r3.xyz, r0.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
    r4.xyz = (r0.xyz < 3.0) ? 1.0 : 0.0;         // lt r4.xyz, r0.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
    r3.xyz = r3.xyz * r4.xyz;                    // and r3.xyz, r3.xyzx, r4.xyzx
    r0.xyz = (r3.xyz != 0.0) ? r1.xyz : r0.xyz;  // movc r0.xyz, r3.xyzx, r1.xyzx, r0.xyzx
  }
  if (r2.x != 0) {
    // this code saves log(r0.xyz) in r1.xyz and reuses it

    // log r1.xyz, r0.xyzx
    // mul r1.xyz, r1.xyzx, CB0[0][0].xxxx
    // exp r2.xzw, r1.xxyz
    r2.xzw = pow(r0.xyz, cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.x);  // r2.xzw = exp(log(r0.xyz) * CB0[0][0].x);
    r3.xyz = (r2.xzw < 0.003100) ? 1.0 : 0.0;                                                         // lt r3.xyz, r2.xzwx, l(0.003100, 0.003100, 0.003100, 0.000000)
    r2.xzw = r2.xzw * 12.920000;                                                                      // mul r2.xzw, r2.xxzw, l(12.920000, 0.000000, 12.920000, 12.920000)

    // mul r1.xyz, r1.xyzx, l(0.416667, 0.416667, 0.416667, 0.000000)
    // exp r1.xyz, r1.xyzx
    r1.xyz = pow(r0.xyz, 1.0 / 2.4);  // exp(log(r0.xyz) * (1 / 2.4));

    r1.xyz = r1.xyz * 1.055 - 0.055;             // mad r1.xyz, r1.xyzx, l(1.055000, 1.055000, 1.055000, 0.000000), l(-0.055000, -0.055000, -0.055000, 0.000000)
    r0.xyz = (r3.xyz != 0.0) ? r1.xyz : r0.xyz;  // movc r0.xyz, r3.xyzx, r1.xyzx, r0.xyzx
  } else {
    if (r2.y != 0) {
      r0.xyz = renodx::color::correct::GammaSafe(r0.xyz);  // linearize with 2.2
      r1.xyz = renodx::color::bt2020::from::BT709(r0.xyz);
      // dev attempt at fixing gamma mismatch, weird stretching with paper white and gamma
      // r1.xyz = r1.xyz * cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.y;  // mul r1.xyz, r1.xyzx, CB0[0][0].yyyy
      // r1.xyz = pow(r1.xyz, cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.x);    // r1.xyz = exp(log(r1.xyz) * CB0[0][0].x);
      r1.xyz *= RENODX_GRAPHICS_WHITE_NITS;  // game sets UI Brightness to 300 nits
      r0.xyz = renodx::color::pq::from::BT2020((r1.xyz) / 10000.f);
    }
  }
  SV_TARGET.xyzw = float4(r0.xyz, 1.0);
  return;
}
