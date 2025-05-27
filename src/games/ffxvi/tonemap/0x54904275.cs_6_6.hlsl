#include "../common.hlsli"

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
// clang-format off
cbuffer cb1 : register(b1) {
  struct cConstant0_Struct {
    struct ChromaticAberrationParameter {
      float4 ChromaticAberrationParameter_000[3];
      float ChromaticAberrationParameter_048;
      int ChromaticAberrationParameter_052;
      int2 ChromaticAberrationParameter_056;
    } cConstant0_Struct_000;
    struct VignetteParameter {
      struct VignetteMechanicalParameter {
        float VignetteMechanicalParameter_000;
        float VignetteMechanicalParameter_004;
        int2 VignetteMechanicalParameter_008;
      } VignetteParameter_000;
      struct VignetteNaturalParameter {
        float VignetteNaturalParameter_000;
        float VignetteNaturalParameter_004;
        float VignetteNaturalParameter_008;
        int VignetteNaturalParameter_012;
      } VignetteParameter_016;
      float3 VignetteParameter_032;
      float VignetteParameter_044;
    } cConstant0_Struct_064;
    struct NightFilterParameter {
      float4 NightFilterParameter_000[30];
    } cConstant0_Struct_112;
    struct FilmGrainParameter {
      float2 FilmGrainParameter_000;
      float2 FilmGrainParameter_008;
      float FilmGrainParameter_016;
      int3 FilmGrainParameter_020;
    } cConstant0_Struct_592;
    struct ColorGradingLutParameter {
      int ColorGradingLutParameter_000;
      float ColorGradingLutParameter_004;
      int2 ColorGradingLutParameter_008;
    } cConstant0_Struct_624;
    struct ColorGradingRuntimeParameter {
      float4 ColorGradingRuntimeParameter_000;
      float4 ColorGradingRuntimeParameter_016;
      float4 ColorGradingRuntimeParameter_032;
      float4 ColorGradingRuntimeParameter_048;
      float4 ColorGradingRuntimeParameter_064;
    } cConstant0_Struct_640;
    struct ColorGradingRuntime2Parameter {
      float4 ColorGradingRuntime2Parameter_000;
      float4 ColorGradingRuntime2Parameter_016;
      float4 ColorGradingRuntime2Parameter_032;
    } cConstant0_Struct_720;
    struct ToneMappingParameter {
      struct TripleSectionToneMappingParams {
        float TripleSectionToneMappingParams_000;
        float TripleSectionToneMappingParams_004;
        float TripleSectionToneMappingParams_008;
        float TripleSectionToneMappingParams_012;
        float TripleSectionToneMappingParams_016;
        float TripleSectionToneMappingParams_020;
        int2 TripleSectionToneMappingParams_024;
        float4 TripleSectionToneMappingParams_032;
      } ToneMappingParameter_000;
      float ToneMappingParameter_048;
      float ToneMappingParameter_052;
      int2 ToneMappingParameter_056;
    } cConstant0_Struct_768;
    float cConstant0_Struct_832;
    int3 cConstant0_Struct_836;
  } cConstant0_000 : packoffset(c000.x);
};
// clang-format on
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

    float y_in;
    float3 untonemapped = ApplySliders(_78, _79, _80, y_in);

    float _83 = _78 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_048;
    float _84 = _79 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_048;
    float _85 = _80 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_048;
    float _97 = _83 - cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _98 = _84 - cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _99 = _85 - cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _100 = _97 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_004;
    float _101 = _98 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_004;
    float _102 = _99 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_004;
    float _103 = _100 + cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _104 = _101 + cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _105 = _102 + cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _106 = _83 / cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _107 = _84 / cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _108 = _85 / cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _109 = abs(_106);
    float _110 = abs(_107);
    float _111 = abs(_108);
    float _112 = log2(_109);
    float _113 = log2(_110);
    float _114 = log2(_111);
    float _115 = _112 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_016;
    float _116 = _113 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_016;
    float _117 = _114 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_016;
    float _118 = exp2(_115);
    float _119 = exp2(_116);
    float _120 = exp2(_117);
    float _121 = _118 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _122 = _119 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _123 = _120 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_008;
    float _124 = _121 + cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_020;
    float _125 = _122 + cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_020;
    float _126 = _123 + cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_020;
    float _127 = peak_ratio - cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.y;
    float _128 = -0.0f - cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.z;
    float _129 = _83 - cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.x;
    float _130 = _84 - cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.x;
    float _131 = _85 - cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.x;
    float _132 = _129 * _128;
    float _133 = _130 * _128;
    float _134 = _131 * _128;
    float _135 = _132 / peak_ratio;
    float _136 = _133 / peak_ratio;
    float _137 = _134 / peak_ratio;
    float _138 = _135 * 1.4426950216293335f;
    float _139 = _136 * 1.4426950216293335f;
    float _140 = _137 * 1.4426950216293335f;
    float _141 = exp2(_138);
    float _142 = exp2(_139);
    float _143 = exp2(_140);
    float _144 = _141 * _127;
    float _145 = _142 * _127;
    float _146 = _143 * _127;
    float _147 = peak_ratio - _144;
    float _148 = peak_ratio - _145;
    float _149 = peak_ratio - _146;
    float _150 = saturate(_106);
    float _151 = saturate(_107);
    float _152 = saturate(_108);
    float _153 = _150 * 2.0f;
    float _154 = _151 * 2.0f;
    float _155 = _152 * 2.0f;
    float _156 = 3.0f - _153;
    float _157 = 3.0f - _154;
    float _158 = 3.0f - _155;
    float _159 = _150 * _150;
    float _160 = _159 * _156;
    float _161 = _151 * _151;
    float _162 = _161 * _157;
    float _163 = _152 * _152;
    float _164 = _163 * _158;
    float _165 = 1.0f - _160;
    float _166 = 1.0f - _162;
    float _167 = 1.0f - _164;
    bool _168 = (_83 < cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.x);
    bool _169 = (_84 < cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.x);
    bool _170 = (_85 < cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_000.TripleSectionToneMappingParams_032.x);
    float _171 = select(_168, 0.0f, 1.0f);
    float _172 = select(_169, 0.0f, 1.0f);
    float _173 = select(_170, 0.0f, 1.0f);
    float _174 = _160 - _171;
    float _175 = _162 - _172;
    float _176 = _164 - _173;
    float _177 = _165 * _124;
    float _178 = _166 * _125;
    float _179 = _167 * _126;
    float _180 = _174 * _103;
    float _181 = _175 * _104;
    float _182 = _176 * _105;
    float _183 = _147 * _171;
    float _184 = _148 * _172;
    float _185 = _149 * _173;
    float _186 = _180 + _183;
    float _187 = _186 + _177;
    float _188 = _181 + _184;
    float _189 = _188 + _178;
    float _190 = _182 + _185;
    float _191 = _190 + _179;

    FinalizeToneMap(_187, _189, _191, untonemapped, y_in);

    float _193 = _187 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_052;
    float _194 = _189 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_052;
    float _195 = _191 * cConstant0_000.cConstant0_Struct_768.ToneMappingParameter_052;
    float _196 = _193 * 0.6274039149284363f;
    float _197 = mad(0.3292830288410187f, _194, _196);
    float _198 = mad(0.04331306740641594f, _195, _197);
    float _199 = _193 * 0.06909728795289993f;
    float _200 = mad(0.9195404052734375f, _194, _199);
    float _201 = mad(0.011362315155565739f, _195, _200);
    float _202 = _193 * 0.016391439363360405f;
    float _203 = mad(0.08801330626010895f, _194, _202);
    float _204 = mad(0.8955952525138855f, _195, _203);
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
    u0[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_256, _257, _258, _25.w);
  }
}
