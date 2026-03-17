#include "./common.hlsl"

Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

// #define LUT_EXTENSION_SAMPLE(color) SampleSDRLUT((color), TrilinearClamp, SrcLUT)
// #include "./lut_extension.hlsl"
// #undef LUT_EXTENSION_SAMPLE

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _27;
  float _42;
  float _57;

#if 1

    const float mid_gray_ap1 = 0.18f;  // double mid_gray since the first LUT halves brightness, finding the real mid gray value for the second LUT
    const float mid_gray_bt709 = renodx::color::bt709::from::AP1(float3(mid_gray_ap1, mid_gray_ap1, mid_gray_ap1)).x;
    const float mid_gray_pq = renodx::color::pq::Encode(mid_gray_ap1, 100.f).x;
    float out_mid_gray_pq = SrcLUT.SampleLevel(TrilinearClamp, ((mid_gray_pq * 0.984375f) + 0.0078125f), 0.0f).x;
    float out_mid_gray = renodx::color::bt709::from::BT2020(renodx::color::pq::Decode(out_mid_gray_pq, 100.f)).x;

    float4 ungraded_ap1 = _9;
    float3 ungraded_bt709 = renodx::color::bt709::from::AP1(ungraded_ap1.xyz);
    ungraded_bt709 = PreTonemapSliders(ungraded_bt709, out_mid_gray);
    ungraded_bt709 = PostTonemapSliders(ungraded_bt709);
    ungraded_ap1.xyz = renodx::color::ap1::from::BT709(ungraded_bt709);

    // Replace ACEScct encode with PQ encode
    float3 pq_encode = renodx::color::pq::EncodeSafe(ungraded_ap1.xyz, 100.f);

    float4 graded_bt2020_pq_ch = SrcLUT.SampleLevel(TrilinearClamp, float3(((pq_encode.x * 0.984375f) + 0.0078125f), ((pq_encode.y * 0.984375f) + 0.0078125f), ((pq_encode.z * 0.984375f) + 0.0078125f)), 0.0f);
    float3 graded_bt709_ch = renodx::color::bt709::from::BT2020(renodx::color::pq::DecodeSafe(graded_bt2020_pq_ch.xyz, 100.f));

    // float lumin_in = LuminosityFromAP1(ungraded_ap1.xyz);
    // float lumin_in_pq = renodx::color::pq::Encode(lumin_in, 100.f);
    // float lumin_out_bt2020_pq = SrcLUT.SampleLevel(TrilinearClamp, ((lumin_in_pq * 0.984375f) + 0.0078125f), 0.0f).x;
    // float lumin_out = renodx::color::ap1::from::BT2020(renodx::color::pq::Decode(lumin_out_bt2020_pq, 100.f)).x;
    // float3 graded_ap1_lumin = renodx::color::correct::Luminance(ungraded_ap1.xyz, lumin_in, lumin_out);
    // float3 graded_bt709_lumin = renodx::color::bt709::from::AP1(graded_ap1_lumin);

    float lumin_ungraded = LuminosityFromBT709(ungraded_bt709.xyz);
    float lumin_graded_bt709_ch = LuminosityFromBT709(graded_bt709_ch);
    float3 graded_bt709_lumin = renodx::color::correct::Luminance(ungraded_bt709.xyz, lumin_ungraded, lumin_graded_bt709_ch);

    float3 graded_bt709 = renodx::color::correct::Chrominance(graded_bt709_lumin, graded_bt709_ch, 1.f - SCENE_GRADE_SATURATION_CORRECTION, SCENE_GRADE_BLOWOUT_RESTORATION, 1);

    float3 ungraded_bt709_scaled = ungraded_bt709 * (out_mid_gray / mid_gray_bt709);
    //float3 ungraded_bt709_scaled = ungraded_bt709 * 0.66f;

    SV_Target.xyz = CustomTonemap(ungraded_bt709_scaled, graded_bt709, out_mid_gray, TEXCOORD);
    SV_Target.w = 1.0f;
    return SV_Target;
#else
  if (!(_9.x <= 0.0f)) {
    if (_9.x < 3.0517578125e-05f) {
      _27 = ((log2((_9.x * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _27 = ((log2(_9.x) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _27 = -0.35844698548316956f;
  }
  if (!(_9.y <= 0.0f)) {
    if (_9.y < 3.0517578125e-05f) {
      _42 = ((log2((_9.y * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _42 = ((log2(_9.y) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _42 = -0.35844698548316956f;
  }
  if (!(_9.z <= 0.0f)) {
    if (_9.z < 3.0517578125e-05f) {
      _57 = ((log2((_9.z * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _57 = ((log2(_9.z) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _57 = -0.35844698548316956f;
  }
  float4 _66 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_27 * 0.984375f) + 0.0078125f), ((_42 * 0.984375f) + 0.0078125f), ((_57 * 0.984375f) + 0.0078125f)), 0.0f);
  SV_Target.x = _66.x;
  SV_Target.y = _66.y;
  SV_Target.z = _66.z;
  SV_Target.w = 1.0f;
  return SV_Target;
  #endif
}
