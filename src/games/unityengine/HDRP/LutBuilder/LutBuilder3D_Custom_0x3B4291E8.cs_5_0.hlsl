#include "../../tonemap.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
RWTexture3D<float4> u0 : register(u0);
cbuffer cb0 : register(b0){
  float4 cb0[25];
}

#define cmp -

float setCustomParam(float3 curve, float4 toeA, float4 toeB, float4 midA, float4 midB, float4 shoulderA, float4 shoulderB) {
  if (curve.x == 0.64547497 && curve.y == 0.32273749 && curve.z == 0.35785133) return 1;      // Hardspace Shipbreaker
  else if (curve.x == 0.25 && curve.y == 0.0 && curve.z == 0.2499975) return 6;  // REKA
return 0;
}

float3 applyUserTonemapCustom(float3 untonemapped, float3 vanilla, float midGray, float param) {
  if (param == 0) { return vanilla;}
  float3 outputColor;
  float defaultClip = 4.f;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType >= 2.f ? 3.f : injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.saturation = injectedData.colorGradeSaturation;
  if (param == 1) { defaultClip = 3.f;}
  else if(param == 7){
    defaultClip = 1.5f;
  }
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(untonemapped, vanilla, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType - 2.f;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? defaultClip : injectedData.colorGradeClip;
  if (injectedData.toneMapType == 0.f) {
    outputColor = saturate(vanilla);
  } else {
    outputColor = untonemapped;
  }
return renodx::tonemap::config::Apply(outputColor, config);
}

[numthreads(4, 4, 4)]
void main(uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  r0.w = cmp(0 < cb0[17].x);
  if (cb0[17].x > 0) {
    r1.xyz = r0.xyz * cb0[0].yyy;
    r1.xyz = lutShaper(r1.xyz, true);
    float3 preCG = r1.xyz;
    r2.x = dot(float3(0.390405,0.549941,0.00892632), r1.xyz);
    r2.y = dot(float3(0.0708416,0.963172,0.00135775), r1.xyz);
    r2.z = dot(float3(0.0231082,0.128021,0.936245), r1.xyz);
    r1.xyz = cb0[2].xyz * r2.xyz;
    r2.x = dot(float3(2.85847,-1.62879,-0.0248910), r1.xyz);
    r2.y = dot(float3(-0.210182,1.15820,0.000324281), r1.xyz);
    r2.z = dot(float3(-0.0418120,-0.118169,1.06867), r1.xyz);
    r1.xyz = renodx::color::arri::logc::c1000::Encode(r2.xyz, false);
    r1.xyz = float3(-0.4135884, -0.4135884, -0.4135884) + r1.xyz;
    r1.xyz = r1.xyz * cb0[7].zzz + float3(0.4135884, 0.4135884, 0.4135884);
    r1.xyz = renodx::color::arri::logc::c1000::Decode(r1.xyz, false);
    r1.xyz = cb0[3].xyz * r1.xyz;
    bool isWCG = r1.x < 0.0 || r1.y < 0.0 || r1.z < 0.0;
    if(injectedData.toneMapType != 0.f){
      r1.xyz = isWCG ? renodx::color::bt2020::from::BT709(r1.xyz) : r1.xyz;
    }
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r1.xyz = pow(r1.xyz, 1.f / 2.2f);
    r2.xyz = min(float3(1,1,1), r1.xyz);
    r0.w = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r0.w = saturate(cb0[15].w + r0.w);
    r1.w = 1 + -r0.w;
    r2.xyz = float3(-0.5,-0.5,-0.5) + cb0[15].xyz;
    r2.xyz = r1.www * r2.xyz + float3(0.5,0.5,0.5);
    r3.xyz = float3(-0.5,-0.5,-0.5) + cb0[16].xyz;
    r3.xyz = r0.www * r3.xyz + float3(0.5,0.5,0.5);
    r4.xyz = r1.xyz + r1.xyz;
    r5.xyz = r1.xyz * r1.xyz;
    r6.xyz = -r2.xyz * float3(2,2,2) + float3(1,1,1);
    r5.xyz = r6.xyz * r5.xyz;
    r5.xyz = r4.xyz * r2.xyz + r5.xyz;
    r1.xyz = sqrt(r1.xyz);
    r6.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r7.xyz = float3(1,1,1) + -r2.xyz;
    r4.xyz = r7.xyz * r4.xyz;
    r1.xyz = r1.xyz * r6.xyz + r4.xyz;
    r4.xyz = step(0.5, r2.xyz);
    r2.xyz = 1.0 - r4.xyz;
    r2.xyz = r2.xyz * r5.xyz;
    r1.xyz = r1.xyz * r4.xyz + r2.xyz;
    r2.xyz = r1.xyz + r1.xyz;
    r4.xyz = r1.xyz * r1.xyz;
    r5.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
    r4.xyz = r5.xyz * r4.xyz;
    r4.xyz = r2.xyz * r3.xyz + r4.xyz;
    r1.xyz = sqrt(r1.xyz);
    r5.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r6.xyz = float3(1,1,1) + -r3.xyz;
    r2.xyz = r6.xyz * r2.xyz;
    r1.xyz = r1.xyz * r5.xyz + r2.xyz;
    r3.xyz = step(0.5, r3.xyz);
    r2.xyz = 1.0 - r3.xyz;
    r2.xyz = r2.xyz * r4.xyz;
    r1.xyz = r1.xyz * r3.xyz + r2.xyz;
    r1.xyz = pow(abs(r1.xyz), 2.2f);
    if(injectedData.toneMapType != 0.f){
      r1.xyz = isWCG ? renodx::color::bt709::from::BT2020(r1.xyz) : r1.xyz;
    }
    r2.x = dot(r1.xyz, cb0[4].xyz);
    r2.y = dot(r1.xyz, cb0[5].xyz);
    r2.z = dot(r1.xyz, cb0[6].xyz);
    r0.w = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r1.xy = cb0[14].yw + -cb0[14].xz;
    r1.zw = -cb0[14].xz + r0.ww;
    r1.xy = float2(1,1) / r1.xy;
    r1.xy = saturate(r1.zw * r1.xy);
    r1.zw = r1.xy * float2(-2,-2) + float2(3,3);
    r1.xy = r1.xy * r1.xy;
    r0.w = r1.w * r1.y;
    r1.x = -r1.z * r1.x + 1;
    r1.z = 1 + -r1.x;
    r1.y = -r1.w * r1.y + r1.z;
    r3.xyz = cb0[11].xyz * r2.xyz;
    r4.xyz = cb0[12].xyz * r2.xyz;
    r1.yzw = r4.xyz * r1.yyy;
    r1.xyz = r3.xyz * r1.xxx + r1.yzw;
    r2.xyz = cb0[13].xyz * r2.xyz;
    r1.xyz = r2.xyz * r0.www + r1.xyz;
    float3 preLGG = r1.xyz;
    r1.xyz = r1.xyz * cb0[10].xyz + cb0[8].xyz;
    r3.xyz = sign(r1.xyz) * pow(abs(r1.xyz), cb0[9].xyz);
    r3.xyz = liftGammaGainScaling(r3.xyz, preLGG, cb0[8].xyz, cb0[9].xyz, cb0[10].xyz);
    isWCG = r3.x < 0.0 || r3.y < 0.0 || r3.z < 0.0;
    if(injectedData.toneMapType != 0.f){
      r3.xyz = isWCG ? renodx::color::bt2020::from::BT709(r3.xyz) : r3.xyz;
    }
    r0.w = step(r3.z, r3.y);
    r4.xy = r3.zy;
    r4.zw = float2(-1.0, 2.0 / 3.0);
    r1.xy = r3.yz + -r4.xy;
    r1.zw = float2(1,-1);
    r1.xyzw = r0.wwww * r1.xyzw + r4.xyzw;
    r0.w = step(r1.x, r3.x);
    r2.xyz = r1.xyw;
    r2.w = r3.x;
    r1.xyw = r2.wyx;
    r1.xyzw = r1.xyzw + -r2.xyzw;
    r1.xyzw = r0.wwww * r1.xyzw + r2.xyzw;
    r0.w = min(r1.w, r1.y);
    r0.w = r1.x + -r0.w;
    r1.y = r1.w + -r1.y;
    r1.w = r0.w * 6.0 + 0.0001;
    r1.y = r1.y / r1.w;
    r1.y = r1.z + r1.y;
    r2.x = abs(r1.y);
    r1.y = 0.0001 + r1.x;
    r2.z = r0.w / r1.y;
    r2.yw = float2(0,0);
    r0.w = t5.SampleLevel(s0_s, r2.xy, 0).x;
    r0.w = saturate(r0.w);
    r0.w = r0.w + r0.w;
    r1.y = t6.SampleLevel(s0_s, r2.zw, 0).x;
    r1.y = saturate(r1.y);
    r0.w = dot(r1.yy, r0.ww);
    r3.x = dot(r3.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r3.yw = float2(0,0);
    r1.y = t7.SampleLevel(s0_s, r3.xy, 0).x;
    r1.y = saturate(r1.y);
    r0.w = r1.y * r0.w;
    r3.z = cb0[7].x + r2.x;
    r1.y = t4.SampleLevel(s0_s, r3.zw, 0).x;
    r1.y = saturate(r1.y);
    r1.y = r1.y + r3.z;
    r1.yzw = float3(-0.5,0.5,-1.5) + r1.yyy;
    float value = r1.y;
    r1.y = (value > 1) ? r1.w : r1.y;
    r1.y = (value < 0) ? r1.z : r1.y;
    r1.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r1.yyy;
    r1.yzw = frac(r1.yzw);
    r1.yzw = r1.yzw * float3(6,6,6) + float3(-3,-3,-3);
    r1.yzw = saturate(float3(-1,-1,-1) + abs(r1.yzw));
    r1.yzw = float3(-1,-1,-1) + r1.yzw;
    r1.yzw = r2.zzz * r1.yzw + float3(1,1,1);
    r2.xyz = r1.xxx * r1.yzw;
    r2.x = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r0.w = dot(cb0[7].yy, r0.ww);
    r1.xyz = r1.xxx * r1.yzw + -r2.xxx;
    r1.xyz = r0.www * r1.xyz + r2.xxx;
    r0.w = max(r1.x, r1.y);
    r0.w = max(r0.w, r1.z);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    r1.xyz = r1.xyz * r0.www + float3(0.00390625,0.00390625,0.00390625);
    r1.w = 0;
    r2.x = t0.SampleLevel(s0_s, r1.xw, 0).x;
    r2.x = saturate(r2.x);
    r2.y = t0.SampleLevel(s0_s, r1.yw, 0).x;
    r2.y = saturate(r2.y);
    r2.z = t0.SampleLevel(s0_s, r1.zw, 0).x;
    r2.z = saturate(r2.z);
    r1.xyz = float3(0.00390625,0.00390625,0.00390625) + r2.xyz;
    r1.w = 0;
    r2.x = t1.SampleLevel(s0_s, r1.xw, 0).x;
    r2.x = saturate(r2.x);
    r2.y = t2.SampleLevel(s0_s, r1.yw, 0).x;
    r2.y = saturate(r2.y);
    r2.z = t3.SampleLevel(s0_s, r1.zw, 0).x;
    r2.z = saturate(r2.z);
    r0.w = max(r2.x, r2.y);
    r0.w = max(r0.w, r2.z);
    r0.w = 1 + -r0.w;
    r0.w = rcp(r0.w);
    r1.xyz = r2.xyz * r0.www;
    if(injectedData.toneMapType != 0.f){
      r1.xyz = isWCG ? renodx::color::bt709::from::BT2020(r1.xyz) : r1.xyz;
    }
    r1.xyz = lerp(preCG, r1.xyz, injectedData.colorGradeInternalLUTStrength);
  } else {
    r0.xyz = r0.xyz * cb0[0].yyy;
    r1.xyz = lutShaper(r0.xyz, true);
  }
  float3 untonemapped = r1.xyz;
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r1.xyz = cb0[18].xxx * r0.xyz;
  r2.xyzw = cmp(r1.xxyy < cb0[18].yzyz);
  r3.xyzw = r2.yyyy ? cb0[21].xyzw : cb0[23].xyzw;
  r4.xyzw = r2.yyww ? cb0[22].xyxy : cb0[24].xyxy;
  r3.xyzw = r2.xxxx ? cb0[19].xyzw : r3.xyzw;
  r4.xyzw = r2.xxzz ? cb0[20].xyxy : r4.xyzw;
  r0.x = r0.x * cb0[18].x + -r3.x;
  r0.x = r0.x * r3.z;
  r0.w = cmp(0 < r0.x);
  r0.x = log2(r0.x);
  r0.x = r4.y * r0.x;
  r0.x = r0.x * 0.693147182 + r4.x;
  r0.x = 1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.w ? r0.x : 0;
  r3.x = r0.x * r3.w + r3.y;
  r5.xyzw = r2.wwww ? cb0[21].xyzw : cb0[23].xyzw;
  r2.xyzw = r2.zzzz ? cb0[19].xyzw : r5.xyzw;
  r0.x = r0.y * cb0[18].x + -r2.x;
  r0.x = r0.x * r2.z;
  r0.y = cmp(0 < r0.x);
  r0.x = log2(r0.x);
  r0.x = r4.w * r0.x;
  r0.x = r0.x * 0.693147182 + r4.z;
  r0.x = 1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.y ? r0.x : 0;
  r3.y = r0.x * r2.w + r2.y;
  r0.xy = cmp(r1.zz < cb0[18].yz);
  r1.xyzw = r0.yyyy ? cb0[21].xyzw : cb0[23].xyzw;
  r0.yw = r0.yy ? cb0[22].xy : cb0[24].xy;
  r1.xyzw = r0.xxxx ? cb0[19].xyzw : r1.xyzw;
  r0.xy = r0.xx ? cb0[20].xy : r0.yw;
  r0.z = r0.z * cb0[18].x + -r1.x;
  r0.z = r0.z * r1.z;
  r0.w = cmp(0 < r0.z);
  r0.z = log2(r0.z);
  r0.y = r0.y * r0.z;
  r0.x = r0.y * 0.693147182 + r0.x;
  r0.x = 1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.w ? r0.x : 0;
  r3.z = r0.x * r1.w + r1.y;
  float3 vanilla = r3.xyz;
  r0.xyz = 0.18f;
  r1.xyz = cb0[18].xxx * r0.xyz;
  r2.xyzw = cmp(r1.xxyy < cb0[18].yzyz);
  r3.xyzw = r2.yyyy ? cb0[21].xyzw : cb0[23].xyzw;
  r4.xyzw = r2.yyww ? cb0[22].xyxy : cb0[24].xyxy;
  r3.xyzw = r2.xxxx ? cb0[19].xyzw : r3.xyzw;
  r4.xyzw = r2.xxzz ? cb0[20].xyxy : r4.xyzw;
  r0.x = r0.x * cb0[18].x + -r3.x;
  r0.x = r0.x * r3.z;
  r0.w = cmp(0 < r0.x);
  r0.x = log2(r0.x);
  r0.x = r4.y * r0.x;
  r0.x = r0.x * 0.693147182 + r4.x;
  r0.x = 1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.w ? r0.x : 0;
  r3.x = r0.x * r3.w + r3.y;
  float midGray = r3.x;
  float customParam = setCustomParam(cb0[18].xyz, cb0[19], cb0[20], cb0[21], cb0[22], cb0[23], cb0[24]);
  r0.xyz = applyUserTonemapCustom(untonemapped, vanilla, midGray, customParam);
  r0.w = 1;
  u0[vThreadID] = r0;
  return;
}