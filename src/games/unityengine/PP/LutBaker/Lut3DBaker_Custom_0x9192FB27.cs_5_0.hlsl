#include "../../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
RWTexture3D<float4> u0 : register(u0);
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

#define cmp -

float3 rolloffUI(float3 color) {
  if (injectedData.toneMapType <= 1.f) { return color;}
  float y_max = max(injectedData.toneMapPeakNits * (injectedData.toneMapGameNits / injectedData.toneMapUINits),
injectedData.toneMapPeakNits / injectedData.toneMapUINits);
  float old_y = renodx::color::y::from::BT709(color);
  if (injectedData.toneMapGammaCorrection != 0.f) {
    y_max = renodx::color::correct::Gamma(y_max, true, injectedData.toneMapGammaCorrection == 1.f ? 2.2f : 2.4f);
  }
  float new_y = renodx::tonemap::ExponentialRollOff(old_y, y_max * 0.85f, y_max); 
float3 output = color * renodx::math::DivideSafe(new_y, old_y);
return output;
}

float setCustomParam(float3 curve, float4 toeA, float4 toeB, float4 midA, float4 midB, float4 shoulderA, float4 shoulderB) {
  [branch]
  if (curve.x == 0.70710677 && curve.y == 0.07694652 && curve.z == 0.70710045 && toeB.x == 0.34657335
  && toeB.y == 0.99999994 && midA.x == -5.268356e-09 && midB.x == 0.34657356) return 26;  // Wasteland 3
  else if (curve.x == 1.0 && curve.y == 0.108818814 && curve.z == 0.99999106) return 1;  // Itorah
  else if(curve.x == 0.7696709 && curve.y == 0.38483545 && curve.z == 0.6661098) return 2;  // Inertial Drift
  else if (curve.x == 0.7765442 && curve.y == 0.3882721 && curve.z == 0.66594106) return 3;  // Inertial Drift
  else if (curve.x == 0.52485836 && curve.y == 0.0 && curve.z == 5.255711e-6) return 4;  // Inertial Drift
  else if (curve.x == 0.69737184 && curve.y == 0.34868592 && curve.z == 0.3486894) return 5;  // Inertial Drift
  else if (curve.x == 0.70710677 && curve.y == 0.07694652 && curve.z == 0.70710045) return 7;  // 7DtD
  else if (curve.x == 0.69816864 && curve.y == 0.12898403 && curve.z == 0.521716) return 8;  // W40k Battlesector
  else if (curve.x == 0.763895 && curve.y == 0.15825893 && curve.z == 0.49324957) return 9;  // W40k Battlesector
  else if (curve.x == 0.70231074 && curve.y == 0.046776883 && curve.z == 0.47463337) return 10;  // W40k Battlesector
  else if (curve.x == 0.2582086 && curve.y == 0.050894577 && curve.z == 0.10830754) return 11;  // W40k Battlesector
  else if (curve.x == 0.70710677 && curve.y == 0.07694652 && curve.z == 0.39076635) return 12;  // W40k Battlesector
  else if (curve.x == 0.55726373 && curve.y == 0.050477523 && curve.z == 0.52639794) return 13;  // W40k Battlesector
  else if (curve.x == 0.5087426 && curve.y == 0.2543713 && curve.z == 0.5388242) return 14;  // W40k Battlesector
  else if (curve.x == 0.70508313 && curve.y == 0.013373618 && curve.z == 0.66001964) return 15;  // W40k Battlesector
  else if (curve.x == 0.70119435 && curve.y == 0.12118134 && curve.z == 0.41419184) return 16;  // W40k Battlesector
  else if (curve.x == 0.6568992 && curve.y == 0.24484229 && curve.z == 0.48540676) return 17;  // W40k Battlesector
  else if (curve.x == 0.70055485 && curve.y == 0.0538708 && curve.z == 0.42579436) return 18;  // W40k Battlesector
  else if (curve.x == 0.70710677 && curve.y == 0.16849656 && curve.z == 0.4738886) return 19;  // W40k Battlesector
  else if (curve.x == 0.8702959 && curve.y == 0.00036573678 && curve.z == 0.17441027) return 20;  // Lost Words
  else if (curve.x == 0.65919137 && curve.y == 0.002079608 && curve.z == 0.26526538) return 21;  // Lost Words
  else if (curve.x == 0.7070702 && curve.y == 6.466942e-05 && curve.z == 0.14147611) return 22;  // Lost Words
  else if (curve.x == 0.70584714 && curve.y == 0.0022267967 && curve.z == 0.14330713) return 23;  // Lost Words
  else if (curve.x == 0.70663595 && curve.y == 0.0033293886 && curve.z == 0.6369046) return 24;  // Lost Words
  else if (curve.x == 0.7562381 && curve.y == 0.0035630942 && curve.z == 0.6074134) return 25;  // Lost Words
  else if (curve.x == 0.44751256 && curve.y == 0.011456045 && curve.z == 0.011460411) return 27;  // Wasteland 3
  else if (curve.x == 0.7570993 && curve.y == 0.005007309 && curve.z == 0.6074821) return 28;  // Lost Words
  else if (curve.x == 0.7570993 && curve.y == 0.0050073103 && curve.z == 0.6074821) return 28;  // Lost Words
  else if (curve.x == 0.75749606 && curve.y == 0.0023897379 && curve.z == 0.15350658) return 29;  // Lost Words
  else if (curve.x == 0.6594794 && curve.y == 0.0020805164 && curve.z == 0.2652065) return 29;  // Lost Words
  else if (curve.x == 0.8702959 && curve.y == 0.00036573692 && curve.z == 0.17441027) return 20;  // Lost Words
  else if (curve.x == 0.75711614 && curve.y == 0.0023885393 && curve.z == 0.4558127) return 28;  // Lost Words
  else if (curve.x == 0.75619686 && curve.y == 0.01096152 && curve.z == 0.45941812) return 25;  // Lost Words
  else if (curve.x == 0.3501852 && curve.y == 0.03810674 && curve.z == 0.29539084) return 30;  // UFO ROBOT GRENDIZER
  else if (curve.x == 0.5 && curve.y == 0.054409407 && curve.z == 0.05441387) return 31;  // NRFTW
else return 0;
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
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  [branch]
  if (param == 2) {
    defaultClip = 1.f;
    config.reno_drt_contrast = 1.08f;
  } else if (param == 3) {
    defaultClip = 1.f;
    config.reno_drt_contrast = 1.06f;
  } else if (param == 4) {
    defaultClip = 1.4f;
    config.reno_drt_contrast = 1.04f;
  } else if (param == 5) {
    defaultClip = 1.2f;
    //config.reno_drt_contrast = 1.04f;
  } else if(param == 7 || param == 12){
    defaultClip = 1.5f;
  } else if(param == 8){
    defaultClip = 4.5f;
    config.reno_drt_contrast = 1.16f;
  } else if(param == 9){
    defaultClip = 5.f;
    config.reno_drt_contrast = 1.06f;
  } else if(param == 10){
    defaultClip = 12.f;
    config.reno_drt_shadows = 0.95f;
    config.reno_drt_contrast = 1.13f;
  } else if(param == 11){
    defaultClip = 7.f;
    config.reno_drt_contrast = 1.2f;
  } else if(param == 13){
    defaultClip = 4.f;
    config.reno_drt_contrast = 1.16f;
  } else if(param == 14){
    defaultClip = 10.f;
    config.reno_drt_contrast = 1.6f;
  } else if(param == 15){
    defaultClip = 8.f;
    config.reno_drt_shadows = 0.97f;
    config.reno_drt_contrast = 1.14f;
  } else if(param == 16){
    defaultClip = 4.f;
    config.reno_drt_contrast = 1.1f;
  } else if(param == 17){
    defaultClip = 4.5f;
    config.reno_drt_contrast = 1.46f;
  } else if(param == 18){
    defaultClip = 10.f;
    config.reno_drt_shadows = 0.99f;
    config.reno_drt_contrast = 1.3f;
  } else if(param == 19){
    defaultClip = 3.f;
    config.reno_drt_contrast = 1.12f;
  } else if(param == 20){
    defaultClip = 5.f;
    config.reno_drt_contrast = 1.04f;
  } else if(param == 21){
    config.reno_drt_contrast = 1.02f;
    config.reno_drt_flare = 0.086f * pow(injectedData.colorGradeFlare, 3.f);
  } else if(param == 23){
    config.reno_drt_contrast = 1.08f;
    config.reno_drt_flare = 0.039f * pow(injectedData.colorGradeFlare, 2.f);
  } else if(param == 24){
    defaultClip = 2.f;
    config.reno_drt_contrast = 1.03f;
    config.reno_drt_flare = 0.039f * pow(injectedData.colorGradeFlare, 2.f);
  } else if(param == 25){
    config.reno_drt_contrast = 1.06f;
    config.reno_drt_flare = 0.0452f * pow(injectedData.colorGradeFlare, 2.f);
  } else if(param == 27){
    config.reno_drt_contrast = 1.05f;
  } else if(param == 28){
    config.reno_drt_shadows = 1.04f;
    config.reno_drt_contrast = 1.05f;
    config.reno_drt_flare = 0.0452f * pow(injectedData.colorGradeFlare, 2.f);
  } else if(param == 29){
    config.reno_drt_contrast = 1.02f;
  } else if(param == 30){
    config.reno_drt_contrast = 1.2f;
    config.reno_drt_flare = 0.14f * injectedData.colorGradeFlare;
  }
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
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
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (float(vThreadID.x) < cb0[0].x && float(vThreadID.y) < cb0[0].x && float(vThreadID.z) < cb0[0].x) {
    r0.xyz = float3(vThreadID) * cb0[0].yyy;
    float3 preCG;
    if (injectedData.colorGradeInternalLUTShaper == 0.f) {
      preCG = arriDecode(r0.xyz);
      r0.xyz = r0.xyz + float3(-0.4135884,-0.4135884,-0.4135884);
      r0.xyz = r0.xyz * cb0[3].zzz + float3(0.4135884,0.4135884,0.4135884);
      r0.xyz = arriDecode(r0.xyz);
    } else {
      r0.xyz = lutShaper(r0.xyz, true);
      preCG = r0.xyz;
      r0.rgb = renodx::color::arri::logc::c1000::Encode(r0.xyz, true);
      r0.xyz = r0.xyz + float3(-0.4135884,-0.4135884,-0.4135884);
      r0.xyz = r0.xyz * cb0[3].zzz + float3(0.4135884,0.4135884,0.4135884);
      r0.xyz = renodx::color::arri::logc::c1000::Decode(r0.xyz, true);
    }
    r1.x = dot(float3(0.390405,0.549941,0.00892632), r0.xyz);
    r1.y = dot(float3(0.0708416,0.963172,0.00135775), r0.xyz);
    r1.z = dot(float3(0.0231082,0.128021,0.936245), r0.xyz);
    r0.xyz = cb0[1].xyz * r1.xyz;
    r1.x = dot(float3(2.858470,-1.628790,-0.024891), r0.xyz);
    r1.y = dot(float3(-0.210182,1.158200,0.000324281), r0.xyz);
    r1.z = dot(float3(-0.041812,-0.118169,1.068670), r0.xyz);
    r0.xyz = cb0[2].xyz * r1.xyz;
    r1.x = dot(r0.xyz, cb0[4].xyz);
    r1.y = dot(r0.xyz, cb0[5].xyz);
    r1.z = dot(r0.xyz, cb0[6].xyz);
    float3 preLGG = r1.xyz;
    r0.xyz = r1.xyz * cb0[9].xyz + cb0[7].xyz;
    r1.xyz = saturate(r0.xyz * renodx::math::FLT_MAX + float3(0.5,0.5,0.5));
    r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r0.xyz = log2(abs(r0.xyz));
    r0.xyz = cb0[8].xyz * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = r1.xyz * r0.xyz;
    r0.xyz = liftGammaGainScaling(r0.xyz, preLGG, cb0[7].xyz, cb0[8].xyz, cb0[9].xyz);
    bool isWCG = r0.x < 0.0 || r0.y < 0.0 || r0.z < 0.0;
    if(injectedData.toneMapType != 0.f){
      r0.xyz = isWCG ? renodx::color::bt2020::from::BT709(r0.xyz) : r0.xyz;
    }
    r0.xyz = max(float3(0,0,0), r0.xyz);
    r0.w = step(r0.z, r0.y);
    r1.xy = r0.zy;
    r1.zw = float2(-1.0, 2.0 / 3.0);
    r2.xy = -r1.xy + r0.yz;
    r2.zw = float2(1,-1);
    r1.xyzw = r0.wwww * r2.xyzw + r1.xyzw;
    r0.w = step(r1.x, r0.x);
    r2.xyz = r1.xyw;
    r2.w = r0.x;
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
    r2.yw = float2(0.25,0.25);
    r0.w = t0.SampleLevel(s0_s, r2.xy, 0).y;
    r0.w = saturate(r0.w);
    r0.w = r0.w + r0.w;
    r1.y = t0.SampleLevel(s0_s, r2.zw, 0).z;
    r1.y = saturate(r1.y);
    r0.w = dot(r1.yy, r0.ww);
    r3.x = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r3.yw = float2(0.25,0.25);
    r0.x = t0.SampleLevel(s0_s, r3.xy, 0).w;
    r0.x = saturate(r0.x);
    r0.x = r0.x * r0.w;
    r3.z = cb0[3].x + r2.x;
    r0.y = t0.SampleLevel(s0_s, r3.zw, 0).x;
    r0.y = saturate(r0.y);
    r0.y = r0.y + r3.z;
    r0.yzw = float3(-0.5,0.5,-1.5) + r0.yyy;
    float value = r0.y;
    r0.y = (value > 1) ? r0.w : r0.y;
    r0.y = (value < 0) ? r0.z : r0.y;
    r0.yzw = float3(1.0, 2.0 / 3.0, 1.0 / 3.0) + r0.yyy;
    r0.yzw = frac(r0.yzw);
    r0.yzw = r0.yzw * float3(6,6,6) + float3(-3,-3,-3);
    r0.yzw = saturate(float3(-1,-1,-1) + abs(r0.yzw));
    r0.yzw = float3(-1,-1,-1) + r0.yzw;
    r0.yzw = r2.zzz * r0.yzw + float3(1,1,1);
    r1.yzw = r1.xxx * r0.yzw;
    r0.x = dot(cb0[3].yy, r0.xx);
    r1.y = dot(r1.yzw, float3(0.212672904,0.715152204,0.0721750036));
    r0.yzw = r1.xxx * r0.yzw + -r1.yyy;
    r0.xyz = r0.xxx * r0.yzw + r1.yyy;
    float customParam = setCustomParam(cb0[10].xyz, cb0[11], cb0[12], cb0[13], cb0[14], cb0[15], cb0[16]);
    if(injectedData.toneMapType != 0.f){
      r0.xyz = isWCG ? renodx::color::bt709::from::BT2020(r0.xyz) : r0.xyz;
    }
    r0.xyz = lerp(preCG, r0.xyz, injectedData.colorGradeInternalLUTStrength);
    float3 untonemapped = r0.xyz;
    r0.xyz = max(float3(0,0,0), r0.xyz);
    r1.xyz = cb0[10].xxx * r0.xyz;
    r2.xyzw = cmp(r1.xxyy < cb0[10].yzyz);
    r3.xyzw = r2.yyyy ? cb0[13].xyzw : cb0[15].xyzw;
    r4.xyzw = r2.yyww ? cb0[14].xyxy : cb0[16].xyxy;
    r3.xyzw = r2.xxxx ? cb0[11].xyzw : r3.xyzw;
    r4.xyzw = r2.xxzz ? cb0[12].xyxy : r4.xyzw;
    r0.x = r0.x * cb0[10].x + -r3.x;
    r0.x = r0.x * r3.z;
    r0.w = cmp(0 < r0.x);
    r0.x = log2(r0.x);
    r0.x = r4.y * r0.x;
    r0.x = r0.x * 0.693147182 + r4.x;
    r0.x = 1.44269502 * r0.x;
    r0.x = exp2(r0.x);
    r0.x = r0.w ? r0.x : 0;
    r3.x = r0.x * r3.w + r3.y;
    r5.xyzw = r2.wwww ? cb0[13].xyzw : cb0[15].xyzw;
    r2.xyzw = r2.zzzz ? cb0[11].xyzw : r5.xyzw;
    r0.x = r0.y * cb0[10].x + -r2.x;
    r0.x = r0.x * r2.z;
    r0.y = cmp(0 < r0.x);
    r0.x = log2(r0.x);
    r0.x = r4.w * r0.x;
    r0.x = r0.x * 0.693147182 + r4.z;
    r0.x = 1.44269502 * r0.x;
    r0.x = exp2(r0.x);
    r0.x = r0.y ? r0.x : 0;
    r3.y = r0.x * r2.w + r2.y;
    r0.xy = cmp(r1.zz < cb0[10].yz);
    r1.xyzw = r0.yyyy ? cb0[13].xyzw : cb0[15].xyzw;
    r0.yw = r0.yy ? cb0[14].xy : cb0[16].xy;
    r1.xyzw = r0.xxxx ? cb0[11].xyzw : r1.xyzw;
    r0.xy = r0.xx ? cb0[12].xy : r0.yw;
    r0.z = r0.z * cb0[10].x + -r1.x;
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
    r1.xyz = cb0[10].xxx * r0.xyz;
    r2.xyzw = cmp(r1.xxyy < cb0[10].yzyz);
    r3.xyzw = r2.yyyy ? cb0[13].xyzw : cb0[15].xyzw;
    r4.xyzw = r2.yyww ? cb0[14].xyxy : cb0[16].xyxy;
    r3.xyzw = r2.xxxx ? cb0[11].xyzw : r3.xyzw;
    r4.xyzw = r2.xxzz ? cb0[12].xyxy : r4.xyzw;
    r0.x = r0.x * cb0[10].x + -r3.x;
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
    if(customParam == 26){
      r0.xyz = rolloffUI(untonemapped);
    } else {
    r0.xyz = applyUserTonemapCustom(untonemapped, vanilla, midGray, customParam);
    }
    r0.w = 1;
    u0[vThreadID] = r0;
  }
  return;
}