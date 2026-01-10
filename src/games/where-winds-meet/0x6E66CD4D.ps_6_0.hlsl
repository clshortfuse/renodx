// Edge-adaptive RCAS-like sharpening stage working on linear color input.
Texture2D<float4> SourceLinear0 : register(t1);

cbuffer Batch : register(b0) {
  float3 cMaskColor : packoffset(c000.x);
  float cLocalRate : packoffset(c000.w);
  float2 cBlurCenterUV : packoffset(c001.x);
  float cGrayPercent : packoffset(c001.z);
  float cOldMoviePercent : packoffset(c001.w);
  float cGradingRate : packoffset(c002.x);
  float cBlurPercent : packoffset(c002.y);
  float cBlurIntensity : packoffset(c002.z);
  float cDiyLocalBlurPercent : packoffset(c002.w);
  float4 UVTransform : packoffset(c003.x);
  float4 cPlayerScreenRect : packoffset(c004.x);
  float4 cDiyLocalBlurParam : packoffset(c005.x);
  float4 cDiySickBlurParam : packoffset(c006.x);
  float3 cDiySickBlurColor : packoffset(c007.x);
  float cDiySickBlurPercent : packoffset(c007.w);
  float3 cVignettingColor : packoffset(c008.x);
  float cVignettingIntensity : packoffset(c008.w);
  float4 cScreenCrackUV : packoffset(c009.x);
  float4 cScreenCrackTime : packoffset(c010.x);
  float4 cDiyExposureEffectParam : packoffset(c011.x);
  float cScreenCrackSaturationScale : packoffset(c012.x);
  float cDiyExposureEffectPercent : packoffset(c012.y);
  float cSharpening : packoffset(c012.z);
  float cIsMainViewport : packoffset(c012.w);
  float cDiyDistortionIntensity : packoffset(c013.x);
  float cScreenCrackLuminanceScale : packoffset(c013.y);
  float cScreenCrackOffsetScale : packoffset(c013.z);
  float cVignettingPercent : packoffset(c013.w);
  float4 cInputRTSize : packoffset(c014.x);
  float cBrightnessAdjVal : packoffset(c015.x);
  float cHDRHUDBrightness : packoffset(c015.y);
  float cRCASDenoiseRate : packoffset(c015.z);
  float cColorLookupTableSize : packoffset(c015.w);
  float cOutputColorSpace : packoffset(c016.x);
  float cDiyUVShiftPercent : packoffset(c016.y);
  float4 cDiyUVShiftParam : packoffset(c017.x);
  float4 fsrCon0 : packoffset(c018.x);
  float4 fsrCon1 : packoffset(c019.x);
  float4 fsrCon2 : packoffset(c020.x);
  float4 fsrCon3 : packoffset(c021.x);
  float4 cGrayParam : packoffset(c022.x);
  int cDebugFlag : packoffset(c023.x);
};

SamplerState SourceLinear0_Sampler : register(s1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  // Sample center tap and 4-neighborhood texels.
  float4 _13 = SourceLinear0.Sample(SourceLinear0_Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _19 = SourceLinear0.Sample(SourceLinear0_Sampler, float2(TEXCOORD.x, (TEXCOORD.y - cInputRTSize.w)));
  float4 _24 = SourceLinear0.Sample(SourceLinear0_Sampler, float2((TEXCOORD.x - cInputRTSize.z), TEXCOORD.y));
  float4 _29 = SourceLinear0.Sample(SourceLinear0_Sampler, float2((cInputRTSize.z + TEXCOORD.x), TEXCOORD.y));
  float4 _34 = SourceLinear0.Sample(SourceLinear0_Sampler, float2(TEXCOORD.x, (cInputRTSize.w + TEXCOORD.y)));
  // Cheap luma approximation used for edge activity.
  float _40 = ((_13.z + _13.x) * 0.5f) + _13.y;
  float _43 = ((_19.z + _19.x) * 0.5f) + _19.y;
  float _46 = ((_24.z + _24.x) * 0.5f) + _24.y;
  float _49 = ((_29.z + _29.x) * 0.5f) + _29.y;
  float _52 = ((_34.z + _34.x) * 0.5f) + _34.y;
  // Neighborhood min/max per channel for contrast limiting.
  float _79 = min(min(_19.x, min(_24.x, _29.x)), _34.x);
  float _80 = min(min(_19.y, min(_24.y, _29.y)), _34.y);
  float _81 = min(min(_19.z, min(_24.z, _29.z)), _34.z);
  float _88 = max(max(_19.x, max(_24.x, _29.x)), _34.x);
  float _89 = max(max(_19.y, max(_24.y, _29.y)), _34.y);
  float _90 = max(max(_19.z, max(_24.z, _29.z)), _34.z);
  // Compute adaptive sharpening strength with activity/contrast gating.
  float _123 = ((1.0f - (saturate((1.0f / (max(max(_40, max(_43, _46)), max(_49, _52)) - min(min(_40, min(_43, _46)), min(_49, _52)))) * abs(((((_46 + _43) + _49) + _52) * 0.25f) - _40)) * 0.5f)) * cSharpening) * max(-0.1875f, min(max(max((-0.0f - (_79 * (0.25f / _88))), ((1.0f / ((_79 * 4.0f) + -4.0f)) * (1.0f - _88))), max(max((-0.0f - (_80 * (0.25f / _89))), ((1.0f / ((_80 * 4.0f) + -4.0f)) * (1.0f - _89))), max((-0.0f - (_81 * (0.25f / _90))), ((1.0f / ((_81 * 4.0f) + -4.0f)) * (1.0f - _90))))), 0.0f));
  float _141 = 1.0f / ((_123 * 4.0f) + 1.0f);
  // Blend sharpened neighborhood back into the center texel with clamp.
  float _145 = max((((_123 * (((_24.x + _19.x) + _29.x) + _34.x)) + _13.x) * _141), 0.0f);
  float _146 = max((((_123 * (((_24.y + _19.y) + _29.y) + _34.y)) + _13.y) * _141), 0.0f);
  float _147 = max((((_123 * (((_24.z + _19.z) + _29.z) + _34.z)) + _13.z) * _141), 0.0f);
  // RCAS denoise crossfade gate.
  float _150 = saturate(abs(_13.w) * cRCASDenoiseRate);
  SV_Target.x = ((_150 * (_13.x - _145)) + _145);
  SV_Target.y = ((_150 * (_13.y - _146)) + _146);
  SV_Target.z = ((_150 * (_13.z - _147)) + _147);
  // Preserve alpha but clamp when main viewport is off.
  SV_Target.w = saturate(cIsMainViewport + _13.w);
  return SV_Target;
}
