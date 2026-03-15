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

  if (RENODX_TONE_MAP_TYPE != 0) {
    _9.xyz *= 0.5f; // Cut brightness in half like first LUT does
    SV_Target.xyz = CustomTonemap(_9.xyz, TEXCOORD);
    SV_Target.w = 1.0f;
    return SV_Target;
  }

  float _27;
  float _42;
  float _57;
  // if (!(_9.x <= 0.0f)) {
  //   if (_9.x < 3.0517578125e-05f) {
  //     _27 = ((log2((_9.x * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
  //   } else {
  //     _27 = ((log2(_9.x) * 0.05707760155200958f) + 0.5547950267791748f);
  //   }
  // } else {
  //   _27 = -0.35844698548316956f;
  // }
  // if (!(_9.y <= 0.0f)) {
  //   if (_9.y < 3.0517578125e-05f) {
  //     _42 = ((log2((_9.y * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
  //   } else {
  //     _42 = ((log2(_9.y) * 0.05707760155200958f) + 0.5547950267791748f);
  //   }
  // } else {
  //   _42 = -0.35844698548316956f;
  // }
  // if (!(_9.z <= 0.0f)) {
  //   if (_9.z < 3.0517578125e-05f) {
  //     _57 = ((log2((_9.z * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
  //   } else {
  //     _57 = ((log2(_9.z) * 0.05707760155200958f) + 0.5547950267791748f);
  //   }
  // } else {
  //   _57 = -0.35844698548316956f;
  // }

  _9.xyz *= 0.5f;  // Cut brightness in half like first LUT
  _9.xyz = PreTonemapSliders(_9.xyz);
  _9.xyz = PostTonemapSliders(_9.xyz);
  _9.xyz *= 2.f; // Restore brightness

  // Replace ACEScct encode with PQ encode
  float3 pq_encode = renodx::color::pq::EncodeSafe(float3(_9.x, _9.y, _9.z), 100.f);
  _27 = pq_encode.x;
  _42 = pq_encode.y;
  _57 = pq_encode.z;

  float4 _66 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_27 * 0.984375f) + 0.0078125f), ((_42 * 0.984375f) + 0.0078125f), ((_57 * 0.984375f) + 0.0078125f)), 0.0f);
  SV_Target.x = _66.x;
  SV_Target.y = _66.y;
  SV_Target.z = _66.z;
  SV_Target.w = 1.0f;
  return SV_Target;
}
