#include "./common.hlsl"
#include "./uncharted2.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float4 _8 = t1.Load(int3(0, 0, 0));
  float _25 = CustomPixelConsts_256.x * 11.199999809265137f;
  float _34 = CustomPixelConsts_256.x / (exp2(log2(max(min(max(_8.x, CustomPixelConsts_064.y), CustomPixelConsts_064.z), 9.999999747378752e-05f) / _25) * CustomPixelConsts_256.z) * _25);
  float4 _35 = t0.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));

  // Define variables at the start
  float _39, _40, _41, _42, _43, _44, _45, _52, _62, _69, _79, _88, _89, _90, _91;
  float _107, _116, _117, _118, _119, _120, _121, _122, _123, _130, _140, _147, _157, _166;

  // Set variable values
  _39 = _35.x * _34;
  _40 = _35.y * _34;
  _41 = _35.z * _34;

  float3 untonemapped_1 = float3(_39, _40, _41);
  //untonemapped_1 = PreTonemapSliders(untonemapped_1);

  float3 tonemapped_bt709_ch_1 = Uncharted2Extended1(untonemapped_1);
  float y_in_1 = renodx::color::y::from::BT709(untonemapped_1);
  float y_out_1 = Uncharted2Extended1(y_in_1).x;
  float3 tonemapped_bt709_lum_1 = renodx::color::correct::Luminance(untonemapped_1, y_in_1, y_out_1);

  float out_mid_gray_1 = Uncharted2Extended1(0.18).x;
  float max_value_1 = Uncharted2Tonemap1(100.f).x;

  _107 = CustomPixelConsts_272.x * 11.199999809265137f;
  _116 = CustomPixelConsts_272.x / (exp2(log2(max(min(max(_8.x, CustomPixelConsts_144.y), CustomPixelConsts_144.z), 9.999999747378752e-05f) / _107) * CustomPixelConsts_272.z) * _107);
  _117 = _35.x * _116;
  _118 = _35.y * _116;
  _119 = _35.z * _116;

  float3 untonemapped_2 = float3(_117, _118, _119);
  //untonemapped_2 = PreTonemapSliders(untonemapped_2);

  float3 tonemapped_bt709_ch_2 = Uncharted2Extended2(untonemapped_2);
  float y_in_2 = renodx::color::y::from::BT709(untonemapped_2);
  float y_out_2 = Uncharted2Extended2(y_in_2).x;
  float3 tonemapped_bt709_lum_2 = renodx::color::correct::Luminance(untonemapped_2, y_in_2, y_out_2);

  float out_mid_gray_2 = Uncharted2Extended2(0.18).x;
  float max_value_2 = Uncharted2Tonemap2(100.f).x;

  float3 untonemapped = lerp(untonemapped_1, untonemapped_2, CustomPixelConsts_208.x);
  float3 tonemapped_bt709_ch = lerp(tonemapped_bt709_ch_1, tonemapped_bt709_ch_2, CustomPixelConsts_208.x);
  float3 tonemapped_bt709_lum = lerp(tonemapped_bt709_lum_1, tonemapped_bt709_lum_2, CustomPixelConsts_208.x);
  float out_mid_gray = lerp(out_mid_gray_1, out_mid_gray_2, CustomPixelConsts_208.x);
  float max_value = lerp(max_value_1, max_value_2, CustomPixelConsts_208.x);

  SV_Target.rgb = CustomUpgradeToneMap(untonemapped, tonemapped_bt709_ch, tonemapped_bt709_lum, out_mid_gray, max_value);
  if (CUSTOM_SCENE_GRADE_HUE_CORRECTION > 0.f && RENODX_TONE_MAP_TYPE > 1) {
    float3 tonemapped_bt709_sdr_1 = Uncharted2Tonemap1(untonemapped_1);
    float3 tonemapped_bt709_sdr_2 = Uncharted2Tonemap2(untonemapped_2);
    float3 tonemapped_bt709_sdr = lerp(tonemapped_bt709_sdr_1, tonemapped_bt709_sdr_2, CustomPixelConsts_208.x);
    //if (CUSTOM_SCENE_GRADE_HUE_CORRECTION_BIAS == 1.f) {
      // SV_Target.rgb = renodx::color::correct::Hue(SV_Target.rgb, lerp(tonemapped_bt709_sdr, SV_Target.rgb, saturate(exp2(1.f - renodx::math::Max(tonemapped_bt709_sdr)))), CUSTOM_SCENE_GRADE_HUE_CORRECTION, CUSTOM_SCENE_HUE_METHOD);
      SV_Target.rgb = renodx::color::correct::Hue(SV_Target.rgb, lerp(SV_Target.rgb, tonemapped_bt709_sdr, saturate(renodx::math::Max(tonemapped_bt709_ch))), CUSTOM_SCENE_GRADE_HUE_CORRECTION, CUSTOM_SCENE_HUE_METHOD);
    // }
    // else {
    //   SV_Target.rgb = renodx::color::correct::Hue(SV_Target.rgb, tonemapped_bt709_sdr, CUSTOM_SCENE_GRADE_HUE_CORRECTION, CUSTOM_SCENE_HUE_METHOD);
    // }
  }
  SV_Target.w = 1.0f;
  
  // _39 = untonemapped_1.x;
  // _40 = untonemapped_1.y;
  // _41 = untonemapped_1.z;

  // _42 = _39 * CustomPixelConsts_112.x;
  // _43 = _40 * CustomPixelConsts_112.x;
  // _44 = _41 * CustomPixelConsts_112.x;
  // _45 = CustomPixelConsts_112.z * CustomPixelConsts_112.y;
  // _52 = CustomPixelConsts_128.x * CustomPixelConsts_128.y;
  // _62 = CustomPixelConsts_128.x * CustomPixelConsts_128.z;
  // _69 = CustomPixelConsts_128.y / CustomPixelConsts_128.z;
  // _79 = CustomPixelConsts_112.x * 11.199999809265137f;
  // _88 = max(0.0f, (((((_79 + _45) * 11.199999809265137f) + _52) / (((_79 + CustomPixelConsts_112.y) * 11.199999809265137f) + _62)) - _69));
  // _89 = (max(0.0f, (((((_42 + _45) * _39) + _52) / (((_42 + CustomPixelConsts_112.y) * _39) + _62)) - _69)) * CustomPixelConsts_256.y) / _88;
  // _90 = (max(0.0f, (((((_43 + _45) * _40) + _52) / (((_43 + CustomPixelConsts_112.y) * _40) + _62)) - _69)) * CustomPixelConsts_256.y) / _88;
  // _91 = (max(0.0f, (((((_44 + _45) * _41) + _52) / (((_44 + CustomPixelConsts_112.y) * _41) + _62)) - _69)) * CustomPixelConsts_256.y) / _88;

  // float3 tonemapped_bt709_1 = float3(_89, _90, _91);




  // _117 = untonemapped_2.x;
  // _118 = untonemapped_2.y;
  // _119 = untonemapped_2.z;

  // _120 = _117 * CustomPixelConsts_176.x;
  // _121 = _118 * CustomPixelConsts_176.x;
  // _122 = _119 * CustomPixelConsts_176.x;
  // _123 = CustomPixelConsts_176.z * CustomPixelConsts_176.y;
  // _130 = CustomPixelConsts_192.x * CustomPixelConsts_192.y;
  // _140 = CustomPixelConsts_192.x * CustomPixelConsts_192.z;
  // _147 = CustomPixelConsts_192.y / CustomPixelConsts_192.z;
  // _157 = CustomPixelConsts_176.x * 11.199999809265137f;
  // _166 = max(0.0f, (((((_157 + _123) * 11.199999809265137f) + _130) / (((_157 + CustomPixelConsts_176.y) * 11.199999809265137f) + _140)) - _147));
  // SV_Target.x = (max(0.0f, (((((_120 + _123) * _117) + _130) / (((_120 + CustomPixelConsts_176.y) * _117) + _140)) - _147)) * CustomPixelConsts_272.y) / _166;
  // SV_Target.y = (max(0.0f, (((((_121 + _123) * _118) + _130) / (((_121 + CustomPixelConsts_176.y) * _118) + _140)) - _147)) * CustomPixelConsts_272.y) / _166;
  // SV_Target.z = (max(0.0f, (((((_122 + _123) * _119) + _130) / (((_122 + CustomPixelConsts_176.y) * _119) + _140)) - _147)) * CustomPixelConsts_272.y) / _166;
  // //SV_Target.z = ((CustomPixelConsts_208.x * (((max(0.0f, (((((_122 + _123) * _119) + _130) / (((_122 + CustomPixelConsts_176.y) * _119) + _140)) - _147)) * CustomPixelConsts_272.y) / _166) - _91)) + _91);
  // SV_Target.w = 1.0f;
  
  return SV_Target;
}
