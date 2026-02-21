#include "./tonemapper.hlsl"

Texture2D<float4> pImage : register(t0);

Texture2D<float4> pBloom : register(t1);

Texture2D<float4> pAdaptedLum : register(t2);

// cbuffer $Globals : register(b0) {
//   float pMinToneMapMult : packoffset(c000.x);
//   float pMaxToneMapMult : packoffset(c000.y);
//   float pMiddleGray : packoffset(c000.z);
//   float pBloomScale : packoffset(c000.w);
//   float4 pToneMapValues1 : packoffset(c001.x);
//   float4 pToneMapValues2 : packoffset(c002.x);
// };

SamplerState pImageS : register(s0);

SamplerState pBloomS : register(s1);

SamplerState pAdaptedLumS : register(s2);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _10 = pBloom.Sample(pBloomS, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _14 = pImage.Sample(pImageS, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _18 = pAdaptedLum.Sample(pAdaptedLumS, float2(0.5f, 0.5f));
  float _27 = min(max((pMiddleGray / (_18.x + 0.0010000000474974513f)), pMinToneMapMult), pMaxToneMapMult);
  float _41 = ((pBloomScale * _10.x) + (_27 * _14.x));
  float _42 = ((pBloomScale * _10.y) + (_27 * _14.y));
  float _43 = ((pBloomScale * _10.z) + (_27 * _14.z));

  float3 tonemapped = CustomTonemap1(float3(_41, _42, _43));

  SV_Target.rgb = tonemapped;
  SV_Target.w = renodx::color::y::from::BT709(tonemapped);
  return SV_Target;
}

// float4 main(
//     noperspective float4 SV_Position: SV_Position,
//     linear float2 TEXCOORD: TEXCOORD
// ) : SV_Target {
//   float4 SV_Target;
//   float4 _10 = pBloom.Sample(pBloomS, float2(TEXCOORD.x, TEXCOORD.y));
//   float4 _14 = pImage.Sample(pImageS, float2(TEXCOORD.x, TEXCOORD.y));
//   float4 _18 = pAdaptedLum.Sample(pAdaptedLumS, float2(0.5f, 0.5f));
//   float _27 = min(max((pMiddleGray / (_18.x + 0.0010000000474974513f)), pMinToneMapMult), pMaxToneMapMult);
//   float _41 = min(max(((pBloomScale * _10.x) + (_27 * _14.x)), 0.0f), 10.0f);
//   float _42 = min(max(((pBloomScale * _10.y) + (_27 * _14.y)), 0.0f), 10.0f);
//   float _43 = min(max(((pBloomScale * _10.z) + (_27 * _14.z)), 0.0f), 10.0f);
//   float _44 = _41 * 0.30000001192092896f;
//   float _45 = _42 * 0.30000001192092896f;
//   float _46 = _43 * 0.30000001192092896f;
//   float _85 = pToneMapValues2.w * saturate(exp2(log2((((_41 * 0.753000020980835f) + 0.029999999329447746f) * _44) / ((((_41 * 0.7290000319480896f) + 0.5899999737739563f) * _44) + 0.14000000059604645f)) * 0.6666666865348816f));
//   float _86 = pToneMapValues2.w * saturate(exp2(log2((((_42 * 0.753000020980835f) + 0.029999999329447746f) * _45) / ((((_42 * 0.7290000319480896f) + 0.5899999737739563f) * _45) + 0.14000000059604645f)) * 0.6666666865348816f));
//   float _87 = pToneMapValues2.w * saturate(exp2(log2((((_43 * 0.753000020980835f) + 0.029999999329447746f) * _46) / ((((_43 * 0.7290000319480896f) + 0.5899999737739563f) * _46) + 0.14000000059604645f)) * 0.6666666865348816f));
//   SV_Target.x = _85;
//   SV_Target.y = _86;
//   SV_Target.z = _87;
//   SV_Target.w = dot(float3(_85, _86, _87), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
//   return SV_Target;
// }