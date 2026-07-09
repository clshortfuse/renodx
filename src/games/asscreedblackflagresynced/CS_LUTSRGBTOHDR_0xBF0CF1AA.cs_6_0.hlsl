#include "./common.hlsli"

struct ColorGradingGenerateSRGBToHDRLUT__Constants {
  float ColorGradingGenerateSRGBToHDRLUT__Constants_000;
  float ColorGradingGenerateSRGBToHDRLUT__Constants_004;
  float ColorGradingGenerateSRGBToHDRLUT__Constants_008;
};

RWTexture3D<float4> u0_space5 : register(u0, space5);

RWTexture3D<float4> u1_space5 : register(u1, space5);

cbuffer cb0_space5 : register(b0, space5) {
  ColorGradingGenerateSRGBToHDRLUT__Constants ColorGradingGenerateSRGBToHDRLUT_cbuffer_000 : packoffset(c000.x);
};

[numthreads(16, 16, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _13;
  float _14;
  float _15;
  float _37;
  float _38;
  float _39;
  float _48;
  float _49;
  float _50;
  float _71;
  float _76;
  float _89;
  float _102;
  float _111;
  float _116;
  float _129;
  float _142;
  // unpack lut input
  _13 = saturate(((float)((uint)SV_DispatchThreadID.x)) * 0.032258063554763794f);
  _14 = saturate(((float)((uint)SV_DispatchThreadID.y)) * 0.032258063554763794f);
  _15 = saturate(((float)((uint)SV_DispatchThreadID.z)) * 0.032258063554763794f);

#if RENODX_UI_GAMMA_CORRECTION
  _37 = renodx::color::gamma::Decode(_13);
  _38 = renodx::color::gamma::Decode(_14);
  _39 = renodx::color::gamma::Decode(_15);

  _48 = _37;
  _49 = _38;
  _50 = _39;
#else
  // sRGB -> linear
  _37 = select((_13 <= 0.040449999272823334f), (_13 * 0.07739938050508499f), exp2(log2((_13 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
  _38 = select((_14 <= 0.040449999272823334f), (_14 * 0.07739938050508499f), exp2(log2((_14 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));
  _39 = select((_15 <= 0.040449999272823334f), (_15 * 0.07739938050508499f), exp2(log2((_15 + 0.054999999701976776f) * 0.9478673338890076f) * 2.4000000953674316f));

  // contrast adjust
  _48 = (pow(_37, ColorGradingGenerateSRGBToHDRLUT_cbuffer_000.ColorGradingGenerateSRGBToHDRLUT__Constants_008));
  _49 = (pow(_38, ColorGradingGenerateSRGBToHDRLUT_cbuffer_000.ColorGradingGenerateSRGBToHDRLUT__Constants_008));
  _50 = (pow(_39, ColorGradingGenerateSRGBToHDRLUT_cbuffer_000.ColorGradingGenerateSRGBToHDRLUT__Constants_008));
#endif

#if 1
  _71 = RENODX_GRAPHICS_WHITE_NITS / 10000.f;
#else
  // paper white scalar
  _71 = ColorGradingGenerateSRGBToHDRLUT_cbuffer_000.ColorGradingGenerateSRGBToHDRLUT__Constants_004 * 9.999999747378752e-05f;
#endif

  // bt709 -> bt2020 + start of pq encode
  _76 = exp2(log2(abs(_71 * mad(_39, 0.04331304132938385f, mad(_38, 0.3292830288410187f, (_37 * 0.6274037957191467f))))) * 0.1593017578125f);
  _89 = exp2(log2(abs(_71 * mad(_39, 0.011362295597791672f, mad(_38, 0.9195405840873718f, (_37 * 0.06909731030464172f))))) * 0.1593017578125f);
  _102 = exp2(log2(abs(_71 * mad(_39, 0.8955951929092407f, mad(_38, 0.08801329135894775f, (_37 * 0.016391441226005554f))))) * 0.1593017578125f);

#if 1
  _111 = RENODX_GRAPHICS_WHITE_NITS / 10000.f;
#else
  // paper white scalar for contrast adjusted output
  _111 = ColorGradingGenerateSRGBToHDRLUT_cbuffer_000.ColorGradingGenerateSRGBToHDRLUT__Constants_000 * 9.999999747378752e-05f;
#endif

  // bt709 -> bt2020 + start of pq encode
  _116 = exp2(log2(abs(_111 * mad(_50, 0.04331304132938385f, mad(_49, 0.3292830288410187f, (_48 * 0.6274037957191467f))))) * 0.1593017578125f);
  _129 = exp2(log2(abs(_111 * mad(_50, 0.011362295597791672f, mad(_49, 0.9195405840873718f, (_48 * 0.06909731030464172f))))) * 0.1593017578125f);
  _142 = exp2(log2(abs(_111 * mad(_50, 0.8955951929092407f, mad(_49, 0.08801329135894775f, (_48 * 0.016391441226005554f))))) * 0.1593017578125f);

  // rest of pq encode + write to UAV
  u0_space5[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(exp2(log2(((_76 * 18.8515625f) + 0.8359375f) / ((_76 * 18.6875f) + 1.0f)) * 78.84375f), exp2(log2(((_89 * 18.8515625f) + 0.8359375f) / ((_89 * 18.6875f) + 1.0f)) * 78.84375f), exp2(log2(((_102 * 18.8515625f) + 0.8359375f) / ((_102 * 18.6875f) + 1.0f)) * 78.84375f), 1.0f);
  u1_space5[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(exp2(log2(((_116 * 18.8515625f) + 0.8359375f) / ((_116 * 18.6875f) + 1.0f)) * 78.84375f), exp2(log2(((_129 * 18.8515625f) + 0.8359375f) / ((_129 * 18.6875f) + 1.0f)) * 78.84375f), exp2(log2(((_142 * 18.8515625f) + 0.8359375f) / ((_142 * 18.6875f) + 1.0f)) * 78.84375f), 1.0f);
}
