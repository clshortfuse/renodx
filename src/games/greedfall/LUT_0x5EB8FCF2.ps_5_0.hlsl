#include "./common.hlsl"

Texture3D<float4> t4 : register(t4);
Texture3D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[12];
}
cbuffer cb0 : register(b0){
  float4 cb0[85];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 x0[9];
  x0[0].x = -0.707106769;
  x0[1].x = -1;
  x0[2].x = -0.707106769;
  x0[3].x = -1;
  x0[4].x = 6.82842731;
  x0[5].x = -1;
  x0[6].x = -0.707106769;
  x0[7].x = -1;
  x0[8].x = -0.707106769;
  t0.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
  r0.xy = uiDest.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(1,1) / r0.xy;
  r1.x = t1.SampleLevel(s1_s, v1.xy, 0).x;
  r1.y = cmp(cb0[7].w == 1.000000);
  r1.z = r1.x * cb0[52].w + -cb0[52].y;
  r1.x = r1.x * cb0[52].w + cb0[52].x;
  r1.x = -cb0[52].z / r1.x;
  r2.z = r1.y ? r1.z : r1.x;
  r1.xz = v1.xy * float2(2,2) + float2(-1,-1);
  r1.w = cb1[11].y * r1.z;
  r3.x = cb1[11].x * r1.x;
  r3.y = -1 * r1.w;
  r2.xy = r3.xy * -r2.zz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = sqrt(r1.w);
  r2.xy = -cb1[4].xz + r1.ww;
  r2.xy = saturate(r2.xy / cb1[4].yw);
  r1.w = 1 + -r2.x;
  r1.w = r1.w + -r2.y;
  r2.x = cmp(r1.w >= 0);
  r2.x = r2.x ? cb1[3].x : cb1[3].y;
  r2.x = 0.146446601 * r2.x;
  r2.yzw = float3(0,0,0);
  r3.x = -1;
  while (true) {
    r3.y = cmp(1 < (int)r3.x);
    if (r3.y != 0) break;
    r3.y = mad((int)r3.x, 3, 3);
    r3.z = cmp((int)r3.x == 0);
    r4.y = (int)r3.x;
    r5.xyz = r2.yzw;
    r3.w = -1;
    while (true) {
      r4.z = cmp(1 < (int)r3.w);
      if (r4.z != 0) break;
      r4.x = (int)r3.w;
      r4.xz = r0.zw * r4.xy + v1.xy;
      r4.xzw = t0.SampleLevel(s0_s, r4.xz, 0).xyz;
      r5.w = (int)r3.w + 1;
      r6.x = (int)r3.y + (int)r5.w;
      r6.x = x0[r6.x+0].x;
      r6.x = r6.x * r2.x;
      r6.y = r6.x * r1.w;
      r6.z = cmp((int)r3.w == 0);
      r6.z = r3.z ? r6.z : 0;
      r6.x = r6.x * r1.w + 1;
      r6.x = r6.z ? r6.x : r6.y;
      r5.xyz = r6.xxx * r4.xzw + r5.xyz;
      r3.w = r5.w;
    }
    r2.yzw = r5.xyz;
    r3.x = (int)r3.x + 1;

  }
  r0.z = cmp(0 < cb1[10].y);
  if (r0.z != 0) {
    r3.xyz = t2.Sample(s1_s, v1.xy).xyz;
    r0.z = t1.SampleLevel(s2_s, v1.xy, 0).x;
    r0.w = r0.z * cb0[52].w + -cb0[52].y;
    r0.z = r0.z * cb0[52].w + cb0[52].x;
    r0.z = -cb0[52].z / r0.z;
    r0.z = r1.y ? r0.w : r0.z;
    r0.w = saturate(cb1[9].x * -r0.z);
    r0.w = 1 + -r0.w;
    r1.y = -cb1[9].y + -r0.z;
    r1.y = saturate(cb1[9].z * r1.y);
    r0.w = max(r1.y, r0.w);
    r0.z = cmp(cb1[9].w < -r0.z);
    r0.z = r0.z ? cb1[10].x : r0.w;
    r0.z = cb1[10].y * r0.z;
    r3.xyz = r3.xyz + -r2.yzw;
    r2.yzw = r0.zzz * r3.xyz + r2.yzw;
  }
    float3 linearColor = renodx::color::gamma::DecodeSafe(r2.gba, 2.2f);
		float midGray = renodx::color::y::from::BT709(vanillaTonemap(float3(0.18f,0.18f,0.18f)));
		float3 hueCorrectionColor = vanillaTonemap(linearColor);
    float3 hdrColor;
    float3 sdrColor;
    float3 lutInput;
    float3 lutOutput;
    float3 outputColor;
  	renodx::tonemap::Config config = renodx::tonemap::config::Create();
			config.type = min(3, injectedData.toneMapType);
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
      config.reno_drt_shadows = 0.95f;
      config.reno_drt_contrast = 1.45f;
      config.reno_drt_dechroma = injectedData.colorGradeDechroma;
      config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
			config.hue_correction_type = injectedData.toneMapPerChannel != 0.f
      ? renodx::tonemap::config::hue_correction_type::INPUT
      : renodx::tonemap::config::hue_correction_type::CUSTOM;
			config.hue_correction_strength = injectedData.toneMapPerChannel != 0.f
      ? (1.f - injectedData.toneMapHueCorrection)
      : injectedData.toneMapHueCorrection;
			config.hue_correction_color = lerp(linearColor, hueCorrectionColor, injectedData.toneMapHueShift);
			config.reno_drt_hue_correction_method = (uint)injectedData.toneMapHueProcessor;
			config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
      config.reno_drt_working_color_space = (uint)injectedData.toneMapPerChannel;
			config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0;
			config.reno_drt_blowout = injectedData.colorGradeBlowout;
      config.reno_drt_white_clip = injectedData.colorGradeClip;
			if(config.type == 0.f){
		outputColor = saturate(hueCorrectionColor);
		} else {
    outputColor = linearColor;
    }
      if(injectedData.colorGradeLUTStrength == 0.f || config.type == 1.f){
    r2.rgb = renodx::tonemap::config::Apply(outputColor, config);
    } else {
    renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(outputColor, config);
      hdrColor = tone_maps.color_hdr;
      sdrColor = tone_maps.color_sdr;
      lutInput = sdrColor;
    r2.gba = lutInput;
      float previous_lut_config_strength;
  r0.z = cmp(1 < cb1[2].x);
  if (r0.z != 0) {
    r2.yzw = saturate(r2.yzw);
    t3.GetDimensions(fDest.x, fDest.y, fDest.z);
    r3.xyz = fDest.xyz;
    renodx::lut::Config lut_config1 = renodx::lut::config::Create();
    lut_config1.lut_sampler = s3_s;
    lut_config1.strength = injectedData.colorGradeLUTStrength;
    lut_config1.scaling = 0.f,
    lut_config1.type_input = renodx::lut::config::type::GAMMA_2_2;
    lut_config1.type_output = renodx::lut::config::type::GAMMA_2_2;
    lut_config1.precompute = r3.rgb;
    lut_config1.tetrahedral = injectedData.colorGradeLUTSampling != 0.f;
    r4.xyz = float3(-1,-1,-1) + r3.xyz;
    r4.xyz = r4.xyz * r2.yzw + float3(0.5,0.5,0.5);
    r3.xyz = r4.xyz / r3.xyz;
    r3.xyz = t3.Sample(s3_s, r3.xyz).xyz;
    t4.GetDimensions(fDest.x, fDest.y, fDest.z);
    r4.xyz = fDest.xyz;
    renodx::lut::Config lut_config2 = renodx::lut::config::Create();
    lut_config2.lut_sampler = s3_s;
    lut_config2.strength = injectedData.colorGradeLUTStrength;
    lut_config2.scaling = 0.f,
    lut_config2.type_input = renodx::lut::config::type::GAMMA_2_2;
    lut_config2.type_output = renodx::lut::config::type::GAMMA_2_2;
    lut_config2.precompute = r4.rgb;
    lut_config2.tetrahedral = injectedData.colorGradeLUTSampling != 0.f;
    r5.xyz = float3(-1,-1,-1) + r4.xyz;
    r5.xyz = r5.xyz * r2.yzw + float3(0.5,0.5,0.5);
    r4.xyz = r5.xyz / r4.xyz;
    r4.xyz = t4.Sample(s3_s, r4.xyz).xyz;
    r4.xyz = r4.xyz + -r3.xyz;
    r2.yzw = cb1[2].yyy * r4.xyz + r3.xyz;
      previous_lut_config_strength = lut_config1.strength;
      lut_config1.strength = 1.f;
      lut_config2.strength = 1.f;
      float3 lutColor1 = renodx::lut::Sample(t3, lut_config1, lutInput);
      float3 lutColor2 = renodx::lut::Sample(t4, lut_config2, lutInput);
      r2.gba = lerp(renodx::color::gamma::EncodeSafe(lutColor1), renodx::color::gamma::EncodeSafe(lutColor2), cb1[2].y);
  } else {
    r0.z = cmp(0 < cb1[2].x);
    if (r0.z != 0) {
      r2.yzw = saturate(r2.yzw);
      t3.GetDimensions(fDest.x, fDest.y, fDest.z);
      r3.xyz = fDest.xyz;
      renodx::lut::Config lut_config = renodx::lut::config::Create();
      lut_config.lut_sampler = s3_s;
      lut_config.strength = injectedData.colorGradeLUTStrength;
      lut_config.scaling = 0.f,
      lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
      lut_config.type_output = renodx::lut::config::type::GAMMA_2_2;
      lut_config.precompute = r3.rgb;
      lut_config.tetrahedral = injectedData.colorGradeLUTSampling != 0.f;
      r4.xyz = float3(-1,-1,-1) + r3.xyz;
      r4.xyz = r4.xyz * r2.yzw + float3(0.5,0.5,0.5);
      r3.xyz = r4.xyz / r3.xyz;
      r2.yzw = t3.Sample(s3_s, r3.xyz).xyz;
      previous_lut_config_strength = lut_config.strength;
      lut_config.strength = 1.f;
      r2.gba = renodx::lut::Sample(t3, lut_config, lutInput);
      r2.gba = renodx::color::gamma::EncodeSafe(r2.gba);
    }
  }
  // extra color grading, maybe.
  r0.z = cmp(0 < cb1[0].x);
  r0.w = dot(r2.ywz, float3(0.707099974,0.707099974,0.701699972));
  r3.xyz = float3(0.707099974,0.701699972,0.707099974) * r0.www;
  r4.xyz = cb1[1].xyz * r3.zyz + -r2.yzw;
  r4.xyz = cb1[1].www * r4.xyz + r2.yzw;
  r4.xyz = -r0.www * float3(0.707099974,0.701699972,0.707099974) + r4.xyz;
  r3.xyz = cb1[0].zzz * r3.xyz;
  r3.xyz = cb1[0].yyy * r4.xyz + r3.xyz;
  r3.xyz = float3(-0.730000019,-0.730000019,-0.730000019) + r3.xyz;
  r3.xyz = saturate(r3.xyz * cb1[0].www + float3(0.730000019,0.730000019,0.730000019));
  r2.xyz = r0.zzz ? r3.xyz : r2.yzw;
  lutOutput = renodx::color::gamma::DecodeSafe(r2.rgb);
  if (config.type == 0.f) {
    r2.rgb = lerp(lutInput, lutOutput, previous_lut_config_strength);
  } else if (injectedData.upgradePerChannel == 1.f) {
    r2.rgb = UpgradeToneMapPerChannel(hdrColor, sdrColor, lutOutput, previous_lut_config_strength);
  } else {
    r2.rgb = UpgradeToneMapByLuminance(hdrColor, sdrColor, lutOutput, previous_lut_config_strength);
  }
    }
    linearColor = r2.rgb;
  r2.rgb = renodx::color::gamma::EncodeSafe(r2.rgb);
  // vignette
  r0.zw = float2(-0.5,-0.5) + v1.xy;
  r0.z = dot(r0.zw, r0.zw) * min(1, injectedData.fxVignette);
  r0.z = log2(r0.z);
  r0.z = cb1[7].y * r0.z;
  r0.z = exp2(r0.z);
  r0.z = saturate(cb1[7].x * r0.z * max(1, injectedData.fxVignette)) ;
  r3.xyz = cb1[8].xyz + -r2.xyz;
  r2.xyz = r0.zzz * r3.xyz + r2.xyz;
  // film grain
      if(injectedData.fxFilmGrainType == 0.f){
  r0.z = 1.42499995 + cb0[84].x;
  r0.w = r0.x / r0.y;
  r1.x = r1.x * r0.w;
  sincos(r0.z, r3.x, r4.x);
  r0.z = r3.x * r1.z;
  r0.z = r1.x * r4.x + -r0.z;
  r1.x = r3.x * r1.x;
  r1.x = r1.z * r4.x + r1.x;
  r0.z = r0.z / r0.w;
  r3.x = r0.z * 0.5 + 0.5;
  r3.y = r1.x * 0.5 + 0.5;
  r0.xy = r0.xy / cb1[5].yy;
  r0.xy = r3.xy * r0.xy;
  r0.zw = floor(r0.xy);
  r1.xy = r0.zw * float2(0.00390625,0.00390625) + float2(0.001953125,0.001953125);
  r0.xy = frac(r0.xy);
  r1.z = 0.00999999978 * cb0[84].x;
  r1.xy = cb0[84].xx * float2(0.00999999978,0.00999999978) + r1.xy;
  r1.x = dot(r1.xy, float2(12.9898005,78.2330017));
  r1.x = sin(r1.x);
  r1.x = 59717.2891 * r1.x;
  r1.x = frac(r1.x);
  r3.x = r1.x * 2 + r1.z;
  r3.yz = float2(0.001953125,-1);
  r3.w = 0.00999999978 * cb0[84].x;
  r1.xy = r3.xy + r3.zw;
  r1.x = dot(r1.xy, float2(12.9898005,78.2330017));
  r1.x = sin(r1.x);
  r1.xy = float2(43758.5469,53184.1367) * r1.xx;
  r1.xy = frac(r1.xy);
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r1.xy = r1.xy * float2(4,4) + float2(-1,-1);
  r1.x = dot(r1.xy, r0.xy);
  r0.zw = r0.zw * float2(0.00390625,0.00390625) + r1.zz;
  r4.xyzw = float4(0.001953125,0.005859375,0.005859375,0.001953125) + r0.zwzw;
  r1.w = dot(r4.xy, float2(12.9898005,78.2330017));
  r1.w = sin(r1.w);
  r1.w = 59717.2891 * r1.w;
  r1.w = frac(r1.w);
  r5.x = r1.w * 2 + r1.z;
  r5.yw = float2(0.001953125,0.001953125);
  r3.xy = r5.xy + r3.zw;
  r1.w = dot(r3.xy, float2(12.9898005,78.2330017));
  r1.w = sin(r1.w);
  r3.xy = float2(43758.5469,53184.1367) * r1.ww;
  r3.xy = frac(r3.xy);
  r3.xy = r3.xy * float2(2,2) + float2(-1,-1);
  r3.xy = r3.xy * float2(4,4) + float2(-1,-1);
  r6.xyzw = float4(-0,-1,-1,-0) + r0.xyxy;
  r1.y = dot(r3.xy, r6.xy);
  r1.w = dot(r4.zw, float2(12.9898005,78.2330017));
  r1.w = sin(r1.w);
  r1.w = 59717.2891 * r1.w;
  r1.w = frac(r1.w);
  r5.z = r1.w * 2 + r1.z;
  r3.xy = r5.zw + r3.zw;
  r1.w = dot(r3.xy, float2(12.9898005,78.2330017));
  r1.w = sin(r1.w);
  r3.xy = float2(43758.5469,53184.1367) * r1.ww;
  r3.xy = frac(r3.xy);
  r3.xy = r3.xy * float2(2,2) + float2(-1,-1);
  r3.xy = r3.xy * float2(4,4) + float2(-1,-1);
  r3.x = dot(r3.xy, r6.zw);
  r0.zw = float2(0.005859375,0.005859375) + r0.zw;
  r0.z = dot(r0.zw, float2(12.9898005,78.2330017));
  r0.z = sin(r0.z);
  r0.z = 59717.2891 * r0.z;
  r0.z = frac(r0.z);
  r4.x = r0.z * 2 + r1.z;
  r4.y = 0.001953125;
  r0.zw = r4.xy + r3.zw;
  r0.z = dot(r0.zw, float2(12.9898005,78.2330017));
  r0.z = sin(r0.z);
  r0.zw = float2(43758.5469,53184.1367) * r0.zz;
  r0.zw = frac(r0.zw);
  r0.zw = r0.zw * float2(2,2) + float2(-1,-1);
  r0.zw = r0.zw * float2(4,4) + float2(-1,-1);
  r1.zw = float2(-1,-1) + r0.xy;
  r3.y = dot(r0.zw, r1.zw);
  r0.zw = r0.xy * r0.xy;
  r0.zw = r0.zw * r0.xy;
  r1.zw = r0.xy * float2(6,6) + float2(-15,-15);
  r0.xy = r0.xy * r1.zw + float2(10,10);
  r0.xy = r0.zw * r0.xy;
  r0.zw = r3.xy + -r1.xy;
  r0.xz = r0.xx * r0.zw + r1.xy;
  r0.z = r0.z + -r0.x;
  r0.x = r0.y * r0.z + r0.x;
    r0.b = dot(r2.xyz, float3(0.298999995,0.587000012,0.114));
  r0.z = cb1[5].z * r0.y;
  r0.y = cb1[5].z * r0.y + -0.200000003;
  r0.y = saturate(-5 * r0.y);
  r0.w = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.w * r0.y + r0.z;
  r0.y = r0.y * r0.y;
  r0.y = r0.y * r0.y;
  r0.x = r0.y * -r0.x + r0.x;
  o0.xyz = r0.xxx * cb1[5].xxx * injectedData.fxFilmGrain + r2.xyz;
  o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb);
  } else {
    r2.rgb = renodx::color::gamma::DecodeSafe(r2.rgb);
    o0.rgb = applyFilmGrain(r2.rgb, v1);
  }
  o0.w = 1;
    o0.rgb = PostToneMapScale(o0.rgb);
  return;
}