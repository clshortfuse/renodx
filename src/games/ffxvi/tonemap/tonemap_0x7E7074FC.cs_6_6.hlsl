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

Texture3D<float4> t1 : register(t1);

RWTexture2D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  cCommon_Struct cCommon_000 : packoffset(c000.x);
};



SamplerState s0 : register(s0);

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {

  float peak_ratio = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_000;
  AdjustPeak(peak_ratio);

  bool _15 = ((uint)cCommon_000.cCommon_Struct_064.x <= (uint)(uint)(SV_DispatchThreadID.x));
  bool _16 = ((uint)cCommon_000.cCommon_Struct_064.y <= (uint)(uint)(SV_DispatchThreadID.y));
  bool _17 = _15 || _16;
  if (!_17) {
    float _19 = float((uint)(SV_DispatchThreadID.y));
    float _20 = _19 + 0.5f;
    float _22 = float((uint)(SV_DispatchThreadID.x));
    float _23 = _22 + 0.5f;
    float _25 = cCommon_000.cCommon_Struct_088.x * _23;
    float4 _27 = t0.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
    float _32 = float((uint)SV_DispatchThreadID.x);
    float _33 = float((uint)SV_DispatchThreadID.y);
    float _36 = 1.0f / cConstant0_000.cConstant0_Struct_592.FilmGrainParameter_016;
    float _37 = _36 * _32;
    float _38 = _36 * _33;
    float _39 = ceil(_37);
    float _40 = ceil(_38);
    uint _41 = uint(_39);
    uint _42 = uint(_40);
    float _43 = float((uint)_41);
    float _44 = float((uint)_42);
    float _48 = cCommon_000.cCommon_Struct_088.x * _43;
    float _49 = _44 * cCommon_000.cCommon_Struct_088.y;
    float _53 = _48 + cConstant0_000.cConstant0_Struct_592.FilmGrainParameter_008.x;
    float _54 = _49 + cConstant0_000.cConstant0_Struct_592.FilmGrainParameter_008.y;
    float _55 = _54 * 543.3099975585938f;
    float _56 = _53 + _55;
    float _57 = sin(_56);
    float _58 = _57 * 493013.0f;
    float _59 = frac(_58);
    float _61 = cConstant0_000.cConstant0_Struct_592.FilmGrainParameter_000.x * _59;
    float _63 = _61 + cConstant0_000.cConstant0_Struct_592.FilmGrainParameter_000.y;
    float _64 = _27.x * 0.009999999776482582f;
    float _65 = _64 * _63;
    float _66 = _27.y * 0.009999999776482582f;
    float _67 = _66 * _63;
    float _68 = _27.z * 0.009999999776482582f;
    float _69 = _68 * _63;
    float _70 = abs(_65);
    float _71 = abs(_67);
    float _72 = abs(_69);
    float _73 = log2(_70);
    float _74 = log2(_71);
    float _75 = log2(_72);
    float _76 = _73 * 0.1593017578125f;
    float _77 = _74 * 0.1593017578125f;
    float _78 = _75 * 0.1593017578125f;
    float _79 = exp2(_76);
    float _80 = exp2(_77);
    float _81 = exp2(_78);
    float _82 = _79 * 2.05784010887146f;
    float _83 = _80 * 2.05784010887146f;
    float _84 = _81 * 2.05784010887146f;
    float _85 = _82 + -0.10128399729728699f;
    float _86 = _83 + -0.10128399729728699f;
    float _87 = _84 + -0.10128399729728699f;
    float _88 = _85 * _79;
    float _89 = _86 * _80;
    float _90 = _87 * _81;
    float _91 = _88 + 0.001028590020723641f;
    float _92 = _89 + 0.001028590020723641f;
    float _93 = _90 + 0.001028590020723641f;
    float _94 = _91 * _79;
    float _95 = _92 * _80;
    float _96 = _93 * _81;
    float _97 = _94 + 3.6197199904108857e-08f;
    float _98 = _95 + 3.6197199904108857e-08f;
    float _99 = _96 + 3.6197199904108857e-08f;
    float _100 = _79 + 0.7726690173149109f;
    float _101 = _80 + 0.7726690173149109f;
    float _102 = _81 + 0.7726690173149109f;
    float _103 = _100 * _79;
    float _104 = _101 * _80;
    float _105 = _102 * _81;
    float _106 = _103 + 0.13521400094032288f;
    float _107 = _104 + 0.13521400094032288f;
    float _108 = _105 + 0.13521400094032288f;
    float _109 = _106 * _79;
    float _110 = _107 * _80;
    float _111 = _108 * _81;
    float _112 = _109 + 0.04952450096607208f;
    float _113 = _110 + 0.04952450096607208f;
    float _114 = _111 + 0.04952450096607208f;
    float _115 = _97 / _112;
    float _116 = _98 / _113;
    float _117 = _99 / _114;
    float _120 = float((uint)(int)(cConstant0_000.cConstant0_Struct_624.ColorGradingLutParameter_000));
    float _121 = 1.0f / _120;
    uint _122 = (int)(cConstant0_000.cConstant0_Struct_624.ColorGradingLutParameter_000) + -1u;
    float _123 = float((uint)_122);
    float _124 = _123 * _121;
    float _125 = _121 * 0.5f;
    float _126 = _124 * _115;
    float _127 = _124 * _116;
    float _128 = _124 * _117;
    float _129 = _126 + _125;
    float _130 = _127 + _125;
    float _131 = _128 + _125;
    float4 _134 = t1.SampleLevel(s0, float3(_129, _130, _131), 0.0f);

    
    float _140 = _134.x - _115;
    float _141 = _134.y - _116;
    float _142 = _134.z - _117;
    // lut strength
    float _143 = RENODX_COLOR_GRADE_STRENGTH * cConstant0_000.cConstant0_Struct_624.ColorGradingLutParameter_004 * _140;
    float _144 = RENODX_COLOR_GRADE_STRENGTH * cConstant0_000.cConstant0_Struct_624.ColorGradingLutParameter_004 * _141;
    float _145 = RENODX_COLOR_GRADE_STRENGTH * cConstant0_000.cConstant0_Struct_624.ColorGradingLutParameter_004 * _142;

    float _146 = _143 + _115;
    float _147 = _144 + _116;
    float _148 = _145 + _117;
    float _149 = abs(_146);
    float _150 = abs(_147);
    float _151 = abs(_148);
    float _152 = log2(_149);
    float _153 = log2(_150);
    float _154 = log2(_151);
    float _155 = _152 * 0.012683313339948654f;
    float _156 = _153 * 0.012683313339948654f;
    float _157 = _154 * 0.012683313339948654f;
    float _158 = exp2(_155);
    float _159 = exp2(_156);
    float _160 = exp2(_157);
    float _161 = _158 * 18.6875f;
    float _162 = _159 * 18.6875f;
    float _163 = _160 * 18.6875f;
    float _164 = 18.8515625f - _161;
    float _165 = 18.8515625f - _162;
    float _166 = 18.8515625f - _163;
    float _167 = _158 + -0.8359375f;
    float _168 = _159 + -0.8359375f;
    float _169 = _160 + -0.8359375f;
    float _170 = max(_167, 0.0f);
    float _171 = max(_168, 0.0f);
    float _172 = max(_169, 0.0f);
    float _173 = _170 / _164;
    float _174 = _171 / _165;
    float _175 = _172 / _166;
    float _176 = abs(_173);
    float _177 = abs(_174);
    float _178 = abs(_175);
    float _179 = log2(_176);
    float _180 = log2(_177);
    float _181 = log2(_178);
    float _182 = _179 * 6.277394771575928f;
    float _183 = _180 * 6.277394771575928f;
    float _184 = _181 * 6.277394771575928f;
    float _185 = exp2(_182);
    float _186 = exp2(_183);
    float _187 = exp2(_184);
    float _188 = _185 * 100.0f;
    float _189 = _186 * 100.0f;
    float _190 = _187 * 100.0f;
    float _194 = _25 * cCommon_000.cCommon_Struct_104.x;
    float _195 = cCommon_000.cCommon_Struct_088.y * 543.3099975585938f;
    float _196 = _195 * _20;
    float _197 = _196 * cCommon_000.cCommon_Struct_104.y;
    float _198 = _197 + _194;
    float _199 = sin(_198);
    float _200 = _199 * 493013.0f;
    float _201 = frac(_200);
    float _202 = _201 * 0.0009765625f;
    float _203 = _202 + -0.00048828125f;
    float _204 = _203 + _188;
    float _205 = _203 + _189;
    float _206 = _203 + _190;

    float3 untonemapped = float3(_204, _205, _206);
    float3 tonemapped = ApplyToneMap(untonemapped, peak_ratio);

    float paper_white = cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_052;

    float _319 = tonemapped.r * paper_white;
    float _320 = tonemapped.g * paper_white;
    float _321 = tonemapped.b * paper_white;

    // BT.709 -> BT.2020
    float _322 = _319 * 0.6274039149284363f;
    float _323 = mad(0.3292830288410187f, _320, _322);
    float _324 = mad(0.04331306740641594f, _321, _323);
    float _325 = _319 * 0.06909728795289993f;
    float _326 = mad(0.9195404052734375f, _320, _325);
    float _327 = mad(0.011362315155565739f, _321, _326);
    float _328 = _319 * 0.016391439363360405f;
    float _329 = mad(0.08801330626010895f, _320, _328);
    float _330 = mad(0.8955952525138855f, _321, _329);

    // float _331 = _324 * 0.009999999776482582f;
    // float _332 = _327 * 0.009999999776482582f;
    // float _333 = _330 * 0.009999999776482582f;
    // float _334 = abs(_331);
    // float _335 = abs(_332);
    // float _336 = abs(_333);
    // float _337 = log2(_334);
    // float _338 = log2(_335);
    // float _339 = log2(_336);
    // float _340 = _337 * 0.1593017578125f;
    // float _341 = _338 * 0.1593017578125f;
    // float _342 = _339 * 0.1593017578125f;
    // float _343 = exp2(_340);
    // float _344 = exp2(_341);
    // float _345 = exp2(_342);
    // float _346 = _343 * 2.05784010887146f;
    // float _347 = _344 * 2.05784010887146f;
    // float _348 = _345 * 2.05784010887146f;
    // float _349 = _346 + -0.10128399729728699f;
    // float _350 = _347 + -0.10128399729728699f;
    // float _351 = _348 + -0.10128399729728699f;
    // float _352 = _349 * _343;
    // float _353 = _350 * _344;
    // float _354 = _351 * _345;
    // float _355 = _352 + 0.001028590020723641f;
    // float _356 = _353 + 0.001028590020723641f;
    // float _357 = _354 + 0.001028590020723641f;
    // float _358 = _355 * _343;
    // float _359 = _356 * _344;
    // float _360 = _357 * _345;
    // float _361 = _358 + 3.6197199904108857e-08f;
    // float _362 = _359 + 3.6197199904108857e-08f;
    // float _363 = _360 + 3.6197199904108857e-08f;
    // float _364 = _343 + 0.7726690173149109f;
    // float _365 = _344 + 0.7726690173149109f;
    // float _366 = _345 + 0.7726690173149109f;
    // float _367 = _364 * _343;
    // float _368 = _365 * _344;
    // float _369 = _366 * _345;
    // float _370 = _367 + 0.13521400094032288f;
    // float _371 = _368 + 0.13521400094032288f;
    // float _372 = _369 + 0.13521400094032288f;
    // float _373 = _370 * _343;
    // float _374 = _371 * _344;
    // float _375 = _372 * _345;
    // float _376 = _373 + 0.04952450096607208f;
    // float _377 = _374 + 0.04952450096607208f;
    // float _378 = _375 + 0.04952450096607208f;
    // float _379 = _361 / _376;
    // float _380 = _362 / _377;
    // float _381 = _363 / _378;
    // float _382 = saturate(_379);
    // float _383 = saturate(_380);
    // float _384 = saturate(_381);

    float3 output_color = float3(_324, _327, _330);

    float3 pq_color = renodx::color::pq::EncodeSafe(output_color, 100.f);
    u0[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(pq_color, _27.w);
  }
}
