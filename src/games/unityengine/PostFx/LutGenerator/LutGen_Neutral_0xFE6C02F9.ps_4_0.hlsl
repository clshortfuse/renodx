#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[18];
}

float3 vanillaNeutral(float3 color) {
float a = cb0[15].x;
float b = cb0[15].y;
float c = cb0[15].z;
float d = cb0[15].w;
float e = cb0[16].x;
float f = cb0[16].y;
float w1 = cb0[16].z;
float w2 = cb0[16].w;

float scale = 1.0 / renodx::tonemap::ApplyCurve(w1, a, b, c, d, e, f);
return renodx::tonemap::ApplyCurve(max(0.f, color) * scale, a, b, c, d, e, f) * scale / w2;
}

float setNeutralParam(float4 params0, float4 params1) {
  /*if (0.2, 0.33211, 0.19684, 0.2341, 0.02, 0.30, 3.25, 1.00)*/ return 1;      // Pathfinder Kingmaker
//return 0;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yz = -cb0[17].yz + v1.xy;
  r1.x = cb0[17].x * r0.y;
  r0.x = frac(r1.x);
  r1.x = r0.x / cb0[17].x;
  r0.w = -r1.x + r0.y;
  r0.xyz = r0.xzw * cb0[17].www;
  r0.xyz = lutShaper(r0.xyz, true);
  float3 preCG = r0.xyz;
  r1.x = dot(float3(0.439700991,0.382977992,0.177334994), r0.xyz);
  r1.y = dot(float3(0.0897922963,0.813422978,0.0967615992), r0.xyz);
  r1.z = dot(float3(0.0175439995,0.111543998,0.870703995), r0.xyz);
  r0.xyz = acesccEncode(r1.xyz);
  r0.xyz = r0.xyz * cb0[10].xyz + cb0[8].xyz;
  r1.xyz = log2(r0.xyz);
  r1.xyz = cb0[9].xyz * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r0.xyz = (r0.xyz > (0.0).xxx) ? r1.xyz : r0.xyz;
  r0.w = step(r0.z, r0.y);
  r1.xy = r0.zy;
  r2.xy = -r1.xy + r0.yz;
  r1.zw = float2(-1.0, 2.0 / 3.0);
  r2.zw = float2(1,-1);
  r1.xyzw = r0.wwww * r2.xywz + r1.xywz;
  r0.w = step(r1.x, r0.x);
  r2.z = r1.w;
  r1.w = r0.x;
  r2.xyw = r1.wyx;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r1.xyzw = r0.wwww * r2.xyzw + r1.xyzw;
  r0.w = min(r1.w, r1.y);
  r0.w = r1.x + -r0.w;
  r2.x = r0.w * 6.0 + 0.0001;
  r1.y = r1.w + -r1.y;
  r1.y = r1.y / r2.x;
  r1.y = r1.z + r1.y;
  r1.x = 0.0001 + r1.x;
  r2.z = r0.w / r1.x;
  r2.x = abs(r1.y);
  r2.yw = float2(0.25,0.25);
  r1.xyzw = t0.Sample(s0_s, r2.xy).yxzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).zxyw;
  r2.x = saturate(r2.x);
  r0.w = r2.x + r2.x;
  r1.x = saturate(r1.x);
  r1.x = r1.x + r1.x;
  r0.w = r1.x * r0.w;
  r1.x = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.xyz = -r1.xxx + r0.xyz;
  r1.yw = float2(0.25,0.25);
  r2.xyzw = t0.Sample(s0_s, r1.xy).wxyz;
  r2.x = saturate(r2.x);
  r1.y = r2.x + r2.x;
  r0.w = r1.y * r0.w;
  r0.w = cb0[11].x * r0.w;
  r0.xyz = r0.www * r0.xyz + r1.xxx;
  r0.xyz = float3(-0.4135884,-0.4135884,-0.4135884) + r0.xyz;
  r0.xyz = r0.xyz * cb0[11].yyy + float3(0.4135884,0.4135884,0.4135884);
  r2.xyz = acescc::Decode(r0.xyz);
  r0.x = dot(float3(1.45143926,-0.236510754,-0.214928567), r2.xyz);
  r0.y = dot(float3(-0.0765537769,1.17622972,-0.0996759236), r2.xyz);
  r0.z = dot(float3(0.00831614807,-0.00603244966,0.997716308), r2.xyz);
  r2.x = dot(float3(0.390404999,0.549941003,0.00892631989), r0.xyz);
  r2.y = dot(float3(0.070841603,0.963172019,0.00135775004), r0.xyz);
  r2.z = dot(float3(0.0231081992,0.128021002,0.936245024), r0.xyz);
  r0.xyz = cb0[4].xyz * r2.xyz;
  r2.x = dot(float3(2.85846996,-1.62879002,-0.0248910002), r0.xyz);
  r2.y = dot(float3(-0.210181996,1.15820003,0.000324280991), r0.xyz);
  r2.z = dot(float3(-0.0418119989,-0.118169002,1.06867003), r0.xyz);
  r0.xyz = float3(1,1,1) + -cb0[5].xyz;
  r0.xyz = cb0[7].xyz * r0.xyz;
  r3.xyz = cb0[7].xyz * cb0[5].xyz;
  r0.xyz = r2.xyz * r0.xyz + r3.xyz;
  r2.xyz = log2(r0.xyz);
  r2.xyz = cb0[6].xyz * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r0.xyw = (r0.yzx > (0.0).xxx) ? r2.yzx : r0.yzx;
  r1.x = step(r0.y, r0.x);
  r2.xy = r0.yx;
  r3.xy = -r2.xy + r0.xy;
  r2.zw = float2(-1.0, 2.0 / 3.0);
  r3.zw = float2(1,-1);
  r2.xyzw = r1.xxxx * r3.xyzw + r2.xyzw;
  r1.x = step(r2.x, r0.w);
  r0.xyz = r2.xyw;
  r2.xyw = r0.wyx;
  r2.xyzw = r2.xyzw + -r0.xyzw;
  r0.xyzw = r1.xxxx * r2.xyzw + r0.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r1.y = r1.x * 6.0 + 0.0001;
  r0.y = r0.w + -r0.y;
  r0.y = r0.y / r1.y;
  r0.y = r0.z + r0.y;
  r1.z = cb0[10].w + abs(r0.y);
  r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r2.x = saturate(r2.x);
  r0.y = -0.5 + r2.x;
  r0.y = r1.z + r0.y;
  r1.yz = float2(1,-1) + r0.yy;
  r0.z = (r0.y > 1) ? r1.z : r0.y;
  r0.y = (r0.y < 0) ? r1.y : r0.z;
  r0.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r0.yyy;
  r0.yzw = frac(r0.yzw);
  r0.yzw = r0.yzw * float3(6,6,6) + float3(-3,-3,-3);
  r0.yzw = saturate(float3(-1,-1,-1) + abs(r0.yzw));
  r0.yzw = float3(-1,-1,-1) + r0.yzw;
  r1.y = 0.0001 + r0.x;
  r1.x = r1.x / r1.y;
  r0.yzw = r1.xxx * r0.yzw + float3(1,1,1);
  r0.xyz = r0.xxx * r0.yzw;
  r1.x = dot(r0.xyz, cb0[12].xyz);
  r1.y = dot(r0.xyz, cb0[13].xyz);
  r1.z = dot(r0.xyz, cb0[14].xyz);
  r0.x = dot(float3(1.70504999,-0.621789992,-0.0832599998), r1.xyz);
  r0.y = dot(float3(-0.130260006,1.1408,-0.0105499998), r1.xyz);
  r0.z = dot(float3(-0.0240000002,-0.128969997,1.15296996), r1.xyz);
  r0.xyz = lerp(preCG, r0.xyz, injectedData.colorGradeInternalLUTStrength);
  float midGray = vanillaNeutral(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaNeutral(r0.xyz);
  float neutralParam = setNeutralParam(cb0[15], cb0[16]);
  float defaultClip = 4.f;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = neutralParam == 0.f ? 0.f : (injectedData.toneMapType >= 2.f ? 3.f : injectedData.toneMapType);
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  if (neutralParam == 1.f) {
    defaultClip = 1.7f;
    config.reno_drt_contrast = 1.05f;
  }
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType - 2.f;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? defaultClip : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(hueCorrectionColor);
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  float3 hdrColor = r0.xyz;
  float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(hdrColor);
  float3 curvesInput = injectedData.toneMapType <= 1.f ? hdrColor : sdrColor;
  r0.xyz = curvesInput;
  bool isWCG = r0.x < 0.0 || r0.y < 0.0 || r0.z < 0.0;
  if(injectedData.toneMapType != 0.f){
    r0.xyz = isWCG ? renodx::color::bt2020::from::BT709(r0.xyz) : r0.xyz;
  }
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r0.xyz;
  r0.w = 0.75;
  r1.xyzw = t0.Sample(s0_s, r0.xw).wxyz;
  r1.x = saturate(r1.x);
  r2.xyzw = t0.Sample(s0_s, r0.yw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r1.z = saturate(r0.w);
  r1.y = saturate(r2.w);
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r1.xyz;
  r0.w = 0.75;
  r1.xyzw = t0.Sample(s0_s, r0.xw).xyzw;
  o0.x = saturate(r1.x);
  r1.xyzw = t0.Sample(s0_s, r0.yw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  o0.z = saturate(r0.z);
  o0.y = saturate(r1.y);
  if (injectedData.toneMapType != 0.f) {
    o0.xyz = isWCG ? renodx::color::bt709::from::BT2020(o0.xyz) : o0.xyz;
    o0.xyz = renodx::tonemap::UpgradeToneMap(hdrColor, min(1.f, curvesInput), o0.xyz, injectedData.colorGradeInternalLUTStrength);
  } else {
    o0.xyz = lerp(curvesInput, o0.xyz, injectedData.colorGradeInternalLUTStrength);
  }
  o0.w = 1;
  return;
}