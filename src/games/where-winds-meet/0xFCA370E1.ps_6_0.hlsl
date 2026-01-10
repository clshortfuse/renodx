// HUD presentation shader: blends base scene color with authored UI map and outputs in target color space.
Texture2D<float4> SourceLinear0 : register(t1);

Texture2D<float4> tUIMap : register(t9);

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

SamplerState sUIMapSampler : register(s9);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  // Sample linear scene (usually post-tonemap) used for background reference.
  float4 _8 = SourceLinear0.Sample(SourceLinear0_Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  // Convert scene color from gamma-ish encoding to linear via inverse sRGB-ish curve.
  float _37 = sqrt((((_8.x * 2.509999990463257f) + 0.029999999329447746f) * _8.x) / ((((_8.x * 2.430000066757202f) + 0.5899999737739563f) * _8.x) + 0.14000000059604645f));
  float _38 = sqrt((((_8.y * 2.509999990463257f) + 0.029999999329447746f) * _8.y) / ((((_8.y * 2.430000066757202f) + 0.5899999737739563f) * _8.y) + 0.14000000059604645f));
  float _39 = sqrt((((_8.z * 2.509999990463257f) + 0.029999999329447746f) * _8.z) / ((((_8.z * 2.430000066757202f) + 0.5899999737739563f) * _8.z) + 0.14000000059604645f));
  float _40 = _37 * _37;
  float _41 = _38 * _38;
  float _42 = _39 * _39;
  // Approximate inverse tone-mapping / EOTF back to scene-referred (these constants mirror ACES fitting).
  float _70 = ((((0.1750040054321289f - (_40 * 0.07434900104999542f)) * _40) + 0.07694999873638153f) * _40) / (((0.6652340292930603f - (_40 * 0.6861609816551208f)) * _40) + 0.04553300142288208f);
  float _71 = ((((0.1750040054321289f - (_41 * 0.07434900104999542f)) * _41) + 0.07694999873638153f) * _41) / (((0.6652340292930603f - (_41 * 0.6861609816551208f)) * _41) + 0.04553300142288208f);
  float _72 = ((((0.1750040054321289f - (_42 * 0.07434900104999542f)) * _42) + 0.07694999873638153f) * _42) / (((0.6652340292930603f - (_42 * 0.6861609816551208f)) * _42) + 0.04553300142288208f);
  // Build HDR blend once so it can be routed to any target color space.
  float _158;
  float _159;
  float _160;
  float3 _sceneLinear = float3(_70, _71, _72);
  float _84 = max(cHDRHUDBrightness, 0.0f) * 203.0f;
  float4 _85 = tUIMap.Sample(sUIMapSampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _102 = 1.0f - _85.w;
  float3 _uiLinear = pow(_85.xyz, 2.4000000953674316f);
  float3 _hudLinear = (_uiLinear * _84) + ((_sceneLinear * 172.0f) * _102);
  if (cOutputColorSpace > 0.5f) {
    // Output already in HDR-linear space (e.g., Rec.2020 scRGB), so just multiply by matrix.
    float3 _hdrScaled = _hudLinear * 0.012500000186264515f;
    _158 = dot(float3(1.6605099439620972f, -0.587710976600647f, -0.07280059903860092f), _hdrScaled);
    _159 = dot(float3(-0.12456099689006805f, 1.1329599618911743f, -0.008399110287427902f), _hdrScaled);
    _160 = dot(float3(-0.018167700618505478f, -0.1005610004067421f, 1.1187299489974976f), _hdrScaled);
  } else {
    // Otherwise encode to PQ (ST.2084). The log/exp chain maps values into HDR10 range (no explicit clamp beyond PQ domain).
    float _127 = exp2(log2(_hudLinear.x * 9.999999747378752e-05f) * 0.1593017578125f);
    float _128 = exp2(log2(_hudLinear.y * 9.999999747378752e-05f) * 0.1593017578125f);
    float _129 = exp2(log2(_hudLinear.z * 9.999999747378752e-05f) * 0.1593017578125f);
    _158 = exp2(log2((1.0f / ((_127 * 18.6875f) + 1.0f)) * ((_127 * 18.8515625f) + 0.8359375f)) * 78.84375f);
    _159 = exp2(log2((1.0f / ((_128 * 18.6875f) + 1.0f)) * ((_128 * 18.8515625f) + 0.8359375f)) * 78.84375f);
    _160 = exp2(log2((1.0f / ((_129 * 18.6875f) + 1.0f)) * ((_129 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  }
  SV_Target.x = _158;
  SV_Target.y = _159;
  SV_Target.z = _160;
  // Maintain original alpha but clamp if not main viewport.
  SV_Target.w = saturate(cIsMainViewport + _8.w);
  return SV_Target;
}
