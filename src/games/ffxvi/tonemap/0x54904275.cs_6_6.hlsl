#include "../tonemap.hlsli"

// clang-format off
struct cCommon_Struct {
  float4 cCommon_Struct_000[3];
  int2 cCommon_Struct_048;
  float2 cCommon_Struct_056;
  int2 cCommon_Struct_064;
  float2 cCommon_Struct_072;
  int2 cCommon_Struct_080;
  float2 cCommon_Struct_088;
  float2 cCommon_Struct_096;
  float2 cCommon_Struct_104;
  float2 cCommon_Struct_112;
  float2 cCommon_Struct_120;
  float cCommon_Struct_128;
  float cCommon_Struct_132;
  float cCommon_Struct_136;
  int cCommon_Struct_140;
  int cCommon_Struct_144;
  int cCommon_Struct_148;
  float cCommon_Struct_152;
  float cCommon_Struct_156;
  float cCommon_Struct_160;
  float3 cCommon_Struct_164;
  float3 cCommon_Struct_176;
  float cCommon_Struct_188;
  float cCommon_Struct_192;
  float cCommon_Struct_196;
  int cCommon_Struct_200;
  float cCommon_Struct_204;
  float cCommon_Struct_208;
  float cCommon_Struct_212;
  float cCommon_Struct_216;
  float cCommon_Struct_220;
  float cCommon_Struct_224;
  int cCommon_Struct_228;
  int cCommon_Struct_232;
  float cCommon_Struct_236;
  float cCommon_Struct_240;
  float3 cCommon_Struct_244;
  struct CharaLight {
    float3 CharaLight_000;
    float CharaLight_012;
    float3 CharaLight_016;
    float CharaLight_028;
  } cCommon_Struct_256[4];
  float4 cCommon_Struct_384;
  float3 cCommon_Struct_400;
  float cCommon_Struct_412;
  float4 cCommon_Struct_416;
  float4 cCommon_Struct_432;
  float3 cCommon_Struct_448;
  float cCommon_Struct_460;
  float cCommon_Struct_464;
  int cCommon_Struct_468;
  int cCommon_Struct_472;
  int cCommon_Struct_476;
  int2 cCommon_Struct_480;
  int2 cCommon_Struct_488;
  float cCommon_Struct_496;
  float cCommon_Struct_500;
  float cCommon_Struct_504;
  int cCommon_Struct_508;
  int cCommon_Struct_512;
  int cCommon_Struct_516;
  int cCommon_Struct_520;
  float cCommon_Struct_524;
  struct TranslucentApproximateDepthParameter {
    int TranslucentApproximateDepthParameter_000;
    float TranslucentApproximateDepthParameter_004;
    int TranslucentApproximateDepthParameter_008;
    int TranslucentApproximateDepthParameter_012;
  } cCommon_Struct_528;
  int4 cCommon_Struct_544[1];
  float cCommon_Struct_560;
  int cCommon_Struct_564;
  float2 cCommon_Struct_568;
};
// clang-format on


Texture2D<float4> t0 : register(t0);

RWTexture2D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  cCommon_Struct cCommon_000 : packoffset(c000.x);
};

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float peak_ratio = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_000;
  AdjustPeak(peak_ratio);

  bool _13 = ((uint)cCommon_000.cCommon_Struct_064.x <= (uint)(uint)(SV_DispatchThreadID.x));
  bool _14 = ((uint)cCommon_000.cCommon_Struct_064.y <= (uint)(uint)(SV_DispatchThreadID.y));
  bool _15 = _13 || _14;
  if (!_15) {
    float _17 = float((uint)(SV_DispatchThreadID.y));
    float _18 = _17 + 0.5f;
    float _20 = float((uint)(SV_DispatchThreadID.x));
    float _21 = _20 + 0.5f;
    float _23 = cCommon_000.cCommon_Struct_088.x * _21;
    float4 _25 = t0.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
    float _30 = float((uint)SV_DispatchThreadID.x);
    float _31 = float((uint)SV_DispatchThreadID.y);
    float _34 = 1.0f / cConstant0_000.cConstant0_Struct_592.FilmGrainParameter_016;
    float _35 = _34 * _30;
    float _36 = _34 * _31;
    float _37 = ceil(_35);
    float _38 = ceil(_36);
    uint _39 = uint(_37);
    uint _40 = uint(_38);
    float _41 = float((uint)_39);
    float _42 = float((uint)_40);
    float _46 = cCommon_000.cCommon_Struct_088.x * _41;
    float _47 = _42 * cCommon_000.cCommon_Struct_088.y;
    float _51 = _46 + cConstant0_000.cConstant0_Struct_592.FilmGrainParameter_008.x;
    float _52 = _47 + cConstant0_000.cConstant0_Struct_592.FilmGrainParameter_008.y;
    float _53 = _52 * 543.3099975585938f;
    float _54 = _51 + _53;
    float _55 = sin(_54);
    float _56 = _55 * 493013.0f;
    float _57 = frac(_56);
    float _59 = cConstant0_000.cConstant0_Struct_592.FilmGrainParameter_000.x * _57;
    float _61 = _59 + cConstant0_000.cConstant0_Struct_592.FilmGrainParameter_000.y;
    float _62 = _61 * _25.x;
    float _63 = _61 * _25.y;
    float _64 = _61 * _25.z;
    float _68 = _23 * cCommon_000.cCommon_Struct_104.x;
    float _69 = cCommon_000.cCommon_Struct_088.y * 543.3099975585938f;
    float _70 = _69 * _18;
    float _71 = _70 * cCommon_000.cCommon_Struct_104.y;
    float _72 = _71 + _68;
    float _73 = sin(_72);
    float _74 = _73 * 493013.0f;
    float _75 = frac(_74);
    float _76 = _75 * 0.0009765625f;
    float _77 = _76 + -0.00048828125f;
    float _78 = _77 + _62;
    float _79 = _77 + _63;
    float _80 = _77 + _64;

    float3 untonemapped = float3(_78, _79, _80);

    float3 tonemapped = ApplyToneMap(untonemapped, peak_ratio);

    float _193 = tonemapped.r * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_052;
    float _194 = tonemapped.g * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_052;
    float _195 = tonemapped.b * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_052;
    float _196 = _193 * 0.6274039149284363f;
    float _197 = mad(0.3292830288410187f, _194, _196);
    float _198 = mad(0.04331306740641594f, _195, _197);
    float _199 = _193 * 0.06909728795289993f;
    float _200 = mad(0.9195404052734375f, _194, _199);
    float _201 = mad(0.011362315155565739f, _195, _200);
    float _202 = _193 * 0.016391439363360405f;
    float _203 = mad(0.08801330626010895f, _194, _202);
    float _204 = mad(0.8955952525138855f, _195, _203);

    float3 pq_color;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      // fake pq
      float _205 = _198 * 0.009999999776482582f;
      float _206 = _201 * 0.009999999776482582f;
      float _207 = _204 * 0.009999999776482582f;
      float _208 = abs(_205);
      float _209 = abs(_206);
      float _210 = abs(_207);
      float _211 = log2(_208);
      float _212 = log2(_209);
      float _213 = log2(_210);
      float _214 = _211 * 0.1593017578125f;
      float _215 = _212 * 0.1593017578125f;
      float _216 = _213 * 0.1593017578125f;
      float _217 = exp2(_214);
      float _218 = exp2(_215);
      float _219 = exp2(_216);
      float _220 = _217 * 2.05784010887146f;
      float _221 = _218 * 2.05784010887146f;
      float _222 = _219 * 2.05784010887146f;
      float _223 = _220 + -0.10128399729728699f;
      float _224 = _221 + -0.10128399729728699f;
      float _225 = _222 + -0.10128399729728699f;
      float _226 = _223 * _217;
      float _227 = _224 * _218;
      float _228 = _225 * _219;
      float _229 = _226 + 0.001028590020723641f;
      float _230 = _227 + 0.001028590020723641f;
      float _231 = _228 + 0.001028590020723641f;
      float _232 = _229 * _217;
      float _233 = _230 * _218;
      float _234 = _231 * _219;
      float _235 = _232 + 3.6197199904108857e-08f;
      float _236 = _233 + 3.6197199904108857e-08f;
      float _237 = _234 + 3.6197199904108857e-08f;
      float _238 = _217 + 0.7726690173149109f;
      float _239 = _218 + 0.7726690173149109f;
      float _240 = _219 + 0.7726690173149109f;
      float _241 = _238 * _217;
      float _242 = _239 * _218;
      float _243 = _240 * _219;
      float _244 = _241 + 0.13521400094032288f;
      float _245 = _242 + 0.13521400094032288f;
      float _246 = _243 + 0.13521400094032288f;
      float _247 = _244 * _217;
      float _248 = _245 * _218;
      float _249 = _246 * _219;
      float _250 = _247 + 0.04952450096607208f;
      float _251 = _248 + 0.04952450096607208f;
      float _252 = _249 + 0.04952450096607208f;
      float _253 = _235 / _250;
      float _254 = _236 / _251;
      float _255 = _237 / _252;
      float _256 = saturate(_253);
      float _257 = saturate(_254);
      float _258 = saturate(_255);
      pq_color = float3(_256, _257, _258);
    } else {
      float3 output_color = float3(_198, _201, _204);
      pq_color = renodx::color::pq::EncodeSafe(output_color, 100.f);
    }
    u0[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(pq_color, _25.w);
  }
}
