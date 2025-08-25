#include "./shared.h"

// Resource Bindings:
//
// Name                                 Type  Format         Dim      ID      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- ------- -------------- ------
// Sampler                           sampler      NA          NA      S0      s0,space8      1
// LinearTexture                     texture  float4          2d      T0      t0,space8      1
// PerceptualTexture                 texture  float4          2d      T1      t1,space8      1
// ShaderInstance_PerInstance        cbuffer      NA          NA     CB0     cb0,space8      1
SamplerState Sampler : register(s0, space8);
Texture2D<float4> LinearTexture : register(t0, space8);
Texture2D<float4> PerceptualTexture : register(t1, space8);

// Buffer Definitions:
//
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
//
//
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

// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_TARGET                0   xyzw        0   TARGET   float   xyzw
//
void main(PSInput input, out float4 SV_TARGET: SV_TARGET) {
  // ps_5_1
  // dcl_globalFlags refactoringAllowed
  // dcl_constantbuffer cb0[0], immediateIndexed
  // dcl_sampler s000.xyzw, mode_default
  // dcl_resource_texture2d (float,float,float,float) t000.xyzw
  // dcl_resource_texture2d (float,float,float,float) t111.xyzw
  // dcl_input_ps linear v1.xy
  // dcl_output o0.xyzw
  // dcl_temps 5
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Sample textures
  r0 = LinearTexture.Sample(Sampler, input.texcoord);      // sample r0.xyzw, v1.xyxx, t00.xyzw, s00
  r1 = PerceptualTexture.Sample(Sampler, input.texcoord);  // sample r1.xyzw, v1.xyxx, t11.xyzw, s00
  r0.xyz = sqrt(r0.xyz);                                   // sqrt r0.xyz, r0.xyzx

  // Conditional operations based on the comparison of r0.xyz
  r2.xyz = (r0.xyz > float3(0.0, 0.0, 0.0)) ? float3(1.0, 1.0, 1.0) : float3(0.0, 0.0, 0.0);            // lt r2.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r0.xyzx
  r0.xyz = pow(r0.xyz, cShaderInstance_PerInstance_Constants.mInUniform_Constant.mKjpGammaSettings.x);  // r0.xyz = exp(log(r0.xyz) * cb0[0][1].x);

  r0.xyz *= r2.xyz;  // and r0.xyz, r0.xyzx, r2.xyzx
  // Convert constant buffer value to integer
  uint mask = uint(cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.w);  // ftoi r2.x, cb0[0][0].w
  // Compare the mask value with 1 and 2
  r2.yz = (mask == uint2(1, 2)) ? float2(1.0, 1.0) : float2(0.0, 0.0);  // ieq r2.yz, r2.xxxx, l(0, 1, 2, 0)
  // Branch based on the comparison result
  if (r2.y != 0) {                                                                                             // if_nz r2.y
    r3.xyz = (r1.xyz < float3(0.040450, 0.040450, 0.040450)) ? float3(1.0, 1.0, 1.0) : float3(0.0, 0.0, 0.0);  // lt r3.xyz, r1.xyzx, l(0.040450, 0.040450, 0.040450, 0.000000)
    r4.xy = r1.xy * float2(0.077399, 0.077399);                                                                // mul r4.xy, r1.xyxx, l(0.0773993805, 0.0773993805, 0.000000, 0.000000)
    r4.zw = r1.xy * float2(0.947867, 0.947867) + float2(0.052133, 0.052133);                                   // mad r4.zw, r1.xxxy, l(0.000000, 0.000000, 0.947867274, 0.947867274), l(0.000000, 0.000000, 0.0521326996, 0.0521326996)

    // log r4.zw, r4.zzzw
    // mul r4.zw, r4.zzzw, l(0.000000, 0.000000, 2.400000, 2.400000)
    // exp r4.zw, r4.zzzw
    r4.zw = pow(r4.zw, 2.4);

    r3.xy = (r3.x != 0) ? r4.xy : r4.zw;  // movc r3.xy, r3.xyxx, r4.xyxx, r4.zwzz
    r2.w = r1.z * 0.077399;               // mul r2.w, r1.z, l(0.0773993805)
    r3.w = r1.z * 0.947867 + 0.052133;    // mad r3.w, r1.z, l(0.947867274), l(0.0521326996)
    // log r3.w, r3.w
    // mul r3.w, r3.w, l(2.400000)
    // exp r3.w, r3.w
    r3.w = pow(r3.w, 2.4);

    r2.w = (r3.z != 0) ? r2.w : r3.w;                                                        // movc r2.w, r3.z, r2.w, r3.w
    r3.z = 1.0 / cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.x;  // div r3.z, l(1.000000, 1.000000, 1.000000, 1.000000), cb0[0][0].x
    // log r4.xy, r3.xyxx
    // log r4.z, r2.w
    // r3.xyz = r4.xyz * r3.z;    // mul r3.xyz, r3.zzzz, r4.xyzx
    // exp r1.xyz, r3.xyzx
    r1.xyz = pow(float3(r3.xy, r2.w), r3.z);
  } else {
    uint maskAlt = 2;       // ieq r2.x, r2.x, l(2)
    if (mask == maskAlt) {  // if_nz r2.x
      // log r3.xyz, r1.xyzx
      // mul r3.xyz, r3.xyzx, l(0.0126833133, 0.0126833133, 0.0126833133, 0.000000)
      // exp r3.xyz, r3.xyzx
      r3.xyz = pow(r1.xyz, 0.0126833133);

      r4.xyz = r3.xyz - 0.835938;                                                                             // add r4.xyz, r3.xyzx, l(-0.835937500, -0.835937500, -0.835937500, 0.000000)
      r3.xyz = -r3.xyz * 18.6875 + 18.851563;                                                                 // mad r3.xyz, -r3.xyzx, l(18.687500, 18.687500, 18.687500, 0.000000), l(18.851563, 18.851563, 18.851563, 0.000000)
      r3.xyz = r4.xyz / r3.xyz;                                                                               // div r3.xyz, r4.xyzx, r3.xyzx
      r3.xyz = max(0, r3.xyz);                                                                                // max r3.xyz, r3.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
      r2.xw = float2(1.0, 1.0) / cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.xy;  // div r2.xw, l(1.000000, 1.000000, 1.000000, 1.000000), cb0[0][0].xxxy

      // log r3.xyz, r3.xyzx
      // mul r3.xyz, r2.xxxx, r3.xyzx
      // exp r3.xyz, r3.xyzx
      r3.xyz = pow(r3.xyz, r2.x);  // exp(log(r3.xyz) * r2.x);

      r3.xyz *= r2.w;                                                   // mul r3.xyz, r2.wwww, r3.xyzx
      r1.x = dot(float3(1.660490, -0.587641, -0.0728498995), r3.xyz);   // dp3 r1.x, l(1.660490, -0.587641, -0.0728498995, 0.000000), r3.xyzx
      r1.y = dot(float3(-0.124550, 1.132900, -0.00834941957), r3.xyz);  // dp3 r1.y, l(-0.124550, 1.132900, -0.00834941957, 0.000000), r3.xyzx
      r1.z = dot(float3(-0.0181508008, -0.100579, 1.118730), r3.xyz);   // dp3 r1.z, l(-0.0181508008, -0.100579, 1.118730, 0.000000), r3.xyzx
    }
  }
  r0.w = 1.0 - r0.w;                  // add r0.w, -r0.w, l(1.000000)
  r3.xyz = r0.www * r1.xyz;           // mul r3.xyz, r0.wwww, r1.xyzx
  r1.xyz = r0.xyz * r0.xyz + r3.xyz;  // mad r1.xyz, r0.xyzx, r0.xyzx, r3.xyzx

  r0.x = (cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.z > 0.0) ? 1.0 : 0.0;  // lt r0.x, l(0.000000), cb0[0][0].z
  r0.x = (r0.x != 0.0 && r2.z != 0.0) ? 1.0 : 0.0;                                                       // and r0.x, r0.x, r2.z

  if (r0.x != 0) {                                                                                             // if_nz r0.x
    r0.xyz = (r1.xyz < float3(0.009300, 0.009300, 0.009300)) ? float3(1.0, 1.0, 1.0) : float3(0.0, 0.0, 0.0);  // lt r0.xyz, r1.xyzx, l(0.009300, 0.009300, 0.009300, 0.000000)

    // double check swizzle here
    r3.xyzw = r1.xyzx * float4(0.333333343, 0.333333343, 0.333333343, 4.306667);  // mul r3.xyzw, r1.xyzx, l(0.333333343, 0.333333343, 0.333333343, 4.306667)

    // log r3.xyz, r3.xyzx
    // mul r3.xyz, r3.xyzx, l(0.416666657, 0.416666657, 0.416666657, 0.000000)
    // exp r3.xyz, r3.xyzx
    r3.xyz = pow(r3.xyz, 1 / 2.4);

    r3.xyz = r3.xyz * 1.055 - 0.055;             // mad r3.xyz, r3.xyzx, l(1.055000, 1.055000, 1.055000, 0.000000), l(-0.055000, -0.055000, -0.055000, 0.000000)
    r0.x = (r0.x != 0) ? r3.w : r3.x;            // movc r0.x, r0.x, r3.w, r3.x
    r2.xw = r1.yz * float2(4.306667, 4.306667);  // mul r2.xw, r1.yyyz, l(4.306667, 0.000000, 0.000000, 4.306667)

    // check if this is right
    r0.yz = (r0.yz != 0.0) ? r2.xw : r3.yz;  // movc r0.yz, r0.yyzy, r2.xxwx, r3.yyzy

    // r3.x = log(r0.x);    // log r3.x, r0.x
    // r3.yz = log(r0.yz);    // log r3.yz, r0.yyzy
    // r0.xyz = r3.xyz * 2.2;   // mul r0.xyz, r3.xyzx, l(2.200000, 2.200000, 2.200000, 0.000000)
    // r0.xyz = exp(r0.xyz);    // exp r0.xyz, r0.xyzx
    r0.xyz = pow(r0.xyz, 2.2);

    r0.xyz *= 3.0;  // mul r0.xyz, r0.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)

    r3.xyz = (r1.xyz >= float3(0.0, 0.0, 0.0)) ? float3(1.0, 1.0, 1.0) : float3(0.0, 0.0, 0.0);  // ge r3.xyz, r1.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)

    r4.xyz = (r1.xyz < float3(3.0, 3.0, 3.0)) ? float3(1.0, 1.0, 1.0) : float3(0.0, 0.0, 0.0);  // lt r4.xyz, r1.xyzx, l(3.000000, 3.000000, 3.000000, 0.000000)
    r3.xyz = r3.xyz * r4.xyz;                                                                   // and r3.xyz, r3.xyzx, r4.xyzx

    r1.xyz = (r3.xyz != 0.0) ? r0.xyz : r1.xyz;  // movc r1.xyz, r3.xyzx, r0.xyzx, r1.xyzx
  }
  if (r2.y != 0) {  // if_nz r2.y

    // this code saves log(r1.xyz) in r0.xyz and reuses it

    // log r0.xyz, r1.xyzx
    // mul r0.xyz, r0.xyzx, cb0[0][0].xxxx
    // exp r2.xyw, r0.xyxz
    r2.xyz = pow(r2.xyz, cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.x);
    r3.xyz = (r2.xyw < float3(0.003100, 0.003100, 0.003100)) ? float3(1.0, 1.0, 1.0) : float3(0.0, 0.0, 0.0);  //         lt r3.xyz, r2.xywx, l(0.003100, 0.003100, 0.003100, 0.000000)
    r2.xyw *= 12.92;                                                                                           // mul r2.xyw, r2.xyxw, l(12.920000, 12.920000, 0.000000, 12.920000)
    // mul r0.xyz, r0.xyzx, l(0.416666657, 0.416666657, 0.416666657, 0.000000)
    // exp r0.xyz, r0.xyzx
    r0.xyz = pow(r0.xyz, 1.0 / 2.4);
    r0.xyz = r0.xyz * 1.055 - 0.055;  // mad r0.xyz, r0.xyzx, l(1.055000, 1.055000, 1.055000, 0.000000), l(-0.055000, -0.055000, -0.055000, 0.000000)

    r1.xyz = (r3.xyz != 0.0) ? r2.xyw : r0.xyz;  // movc r1.xyz, r3.xyzx, r2.xywx, r0.xyzx
  } else {
    if (r2.z != 0) {                                       // if_nz r2.z
      r1.xyz = renodx::color::correct::GammaSafe(r1.xyz);  // linearize with 2.2
      r0.xyz = renodx::color::bt2020::from::BT709(r1.xyz);
      // dev attempt at fixing gamma mismatch, weird stretching with paper white and gamma in bt.2020 space
      // r0.xyz *= cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.y;    // mul r0.xyz, r0.xyzx, cb0[0][0].yyyy
      // r0.xyz = pow(r0.xyz, cShaderInstance_PerInstance_Constants.mInUniform_Constant.mOETFSettings.x);
      r1.xyz = renodx::color::pq::from::BT2020((r0.xyz * RENODX_GRAPHICS_WHITE_NITS) / 10000.f);
    }
  }
  SV_TARGET.xyzw = r1.xyzw;
  return;
}
