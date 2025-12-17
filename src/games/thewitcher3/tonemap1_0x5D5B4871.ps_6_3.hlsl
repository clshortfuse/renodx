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
  float _39 = _35.x * _34;
  float _40 = _35.y * _34;
  float _41 = _35.z * _34;

  float3 untonemapped = float3(_39, _40, _41);
  //untonemapped = PreTonemapSliders(untonemapped);

  // float3 tonemapped_bt709_ch = Uncharted2Tonemap1(untonemapped);
  // float y_in = renodx::color::y::from::BT709(untonemapped);
  // float y_out = Uncharted2Tonemap1(y_in);
  // float3 tonemapped_bt709_lum = renodx::color::correct::Luminance(untonemapped, y_in, y_out);

  // float out_mid_gray = Uncharted2Tonemap1(0.18f);

  float max_value = Uncharted2Tonemap1(100.f);

  // float3 hdr_color = CustomUpgradeToneMap(untonemapped, tonemapped_bt709_ch, tonemapped_bt709_lum, out_mid_gray);

  // SV_Target.rgb = hdr_color;
  float3 tonemapped_bt709_ch = Uncharted2Extended1(untonemapped);
  float y_in = renodx::color::y::from::BT709(untonemapped);
  float y_out = Uncharted2Extended1(y_in).x;
  float3 tonemapped_bt709_lum = renodx::color::correct::Luminance(untonemapped, y_in, y_out);
  float out_mid_gray = Uncharted2Extended1(0.18f).x;

  SV_Target.rgb = CustomUpgradeToneMap(untonemapped, tonemapped_bt709_ch, tonemapped_bt709_lum, out_mid_gray, max_value);
  if (CUSTOM_SCENE_GRADE_HUE_CORRECTION > 0.f && RENODX_TONE_MAP_TYPE > 1) {
    float3 tonemapped_bt709_sdr = Uncharted2Tonemap1(untonemapped);
    //if (CUSTOM_SCENE_GRADE_HUE_CORRECTION_BIAS == 1.f) {
      // SV_Target.rgb = renodx::color::correct::Hue(SV_Target.rgb, lerp(tonemapped_bt709_sdr, SV_Target.rgb, saturate(exp2(1.f - renodx::math::Max(tonemapped_bt709_ch)))), CUSTOM_SCENE_GRADE_HUE_CORRECTION, CUSTOM_SCENE_HUE_METHOD);
      SV_Target.rgb = renodx::color::correct::Hue(SV_Target.rgb, lerp(SV_Target.rgb, tonemapped_bt709_sdr, saturate(renodx::math::Max(tonemapped_bt709_ch))), CUSTOM_SCENE_GRADE_HUE_CORRECTION, CUSTOM_SCENE_HUE_METHOD);
    //}
    // else {
    //   SV_Target.rgb = renodx::color::correct::Hue(SV_Target.rgb, tonemapped_bt709_sdr, CUSTOM_SCENE_GRADE_HUE_CORRECTION, CUSTOM_SCENE_HUE_METHOD);
    // }
  }
  SV_Target.w = 1;

  // float _42;
  // float _43;
  // float _44;
  // float _45;
  // float _52;
  // float _62;
  // float _69;
  // float _79;
  // float _88;

  // _42 = _39 * CustomPixelConsts_112.x;
  // _43 = _40 * CustomPixelConsts_112.x;
  // _44 = _41 * CustomPixelConsts_112.x;
  // _45 = CustomPixelConsts_112.z * CustomPixelConsts_112.y;
  // _52 = CustomPixelConsts_128.x * CustomPixelConsts_128.y;
  // _62 = CustomPixelConsts_128.x * CustomPixelConsts_128.z;
  // _69 = CustomPixelConsts_128.y / CustomPixelConsts_128.z;
  // _79 = CustomPixelConsts_112.x * 11.199999809265137f;
  // _88 = max(0.0f, (((((_79 + _45) * 11.199999809265137f) + _52) / (((_79 + CustomPixelConsts_112.y) * 11.199999809265137f) + _62)) - _69));
  // SV_Target.x = ((max(0.0f, (((((_42 + _45) * _39) + _52) / (((_42 + CustomPixelConsts_112.y) * _39) + _62)) - _69)) * CustomPixelConsts_256.y) / _88);
  // SV_Target.y = ((max(0.0f, (((((_43 + _45) * _40) + _52) / (((_43 + CustomPixelConsts_112.y) * _40) + _62)) - _69)) * CustomPixelConsts_256.y) / _88);
  // SV_Target.z = ((max(0.0f, (((((_44 + _45) * _41) + _52) / (((_44 + CustomPixelConsts_112.y) * _41) + _62)) - _69)) * CustomPixelConsts_256.y) / _88);
  // SV_Target.w = 1.0f;

  // float3 tonemapped_bt709 = SV_Target.rgb;

  // // get midgray

  // _41 = 0.18;
  // _44 = _41 * CustomPixelConsts_112.x;
  // _45 = CustomPixelConsts_112.z * CustomPixelConsts_112.y;
  // _52 = CustomPixelConsts_128.x * CustomPixelConsts_128.y;
  // _62 = CustomPixelConsts_128.x * CustomPixelConsts_128.z;
  // _69 = CustomPixelConsts_128.y / CustomPixelConsts_128.z;
  // _79 = CustomPixelConsts_112.x * 11.199999809265137f;
  // _88 = max(0.0f, (((((_79 + _45) * 11.199999809265137f) + _52) / (((_79 + CustomPixelConsts_112.y) * 11.199999809265137f) + _62)) - _69));
  // float out_mid_gray = ((max(0.0f, (((((_44 + _45) * _41) + _52) / (((_44 + CustomPixelConsts_112.y) * _41) + _62)) - _69)) * CustomPixelConsts_256.y) / _88);

  return SV_Target;
}
