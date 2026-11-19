#include "../../common.hlsl"

Texture2D<float4> Material_Texture2D_0 : register(t0);

cbuffer $Globals : register(b0) {
  float4 GammaAndAlphaValues : packoffset(c000.x);
  float4 CustomEffectParams : packoffset(c001.x);
  float4 DrawFlags : packoffset(c002.x);
};

cbuffer UniformBufferConstants_MaterialCollection0 : register(b1) {
  float4 MaterialCollection0_Vectors[28] : packoffset(c000.x);
};

cbuffer UniformBufferConstants_Material : register(b2) {
  float4 Material_PreshaderBuffer[3] : packoffset(c000.x);
  uint BindlessResource_Material_Texture2D_0 : packoffset(c003.x);
  uint PrePadding_Material_52 : packoffset(c003.y);
  uint BindlessSampler_Material_Texture2D_0Sampler : packoffset(c003.z);
  uint PrePadding_Material_60 : packoffset(c003.w);
  uint BindlessSampler_Material_Wrap_WorldGroupSettings : packoffset(c004.x);
  uint PrePadding_Material_68 : packoffset(c004.y);
  uint BindlessSampler_Material_Clamp_WorldGroupSettings : packoffset(c004.z);
};

SamplerState Material_Texture2D_0Sampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 COLOR: COLOR,
    linear float4 COLOR_1: COLOR1,
    linear float4 ORIGINAL_POSITION: ORIGINAL_POSITION,
    linear float2 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1) : SV_Target {
  float4 SV_Target;
  float4 _21 = Material_Texture2D_0.Sample(Material_Texture2D_0Sampler, float2((TEXCOORD_1.z * TEXCOORD_1.x), (TEXCOORD_1.w * TEXCOORD_1.y)));  // srgb
  float3 linearColor = renodx::draw::InvertIntermediatePass(_21.rgb);
  _21.rgb = renodx::color::srgb::Encode(linearColor);
  float _26 = max(6.103519990574569e-05f, _21.x);
  float _27 = max(6.103519990574569e-05f, _21.y);
  float _28 = max(6.103519990574569e-05f, _21.z);
  float _50 = select((_26 > 0.040449999272823334f), exp2(log2((_26 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_26 * 0.07739938050508499f));
  float _51 = select((_27 > 0.040449999272823334f), exp2(log2((_27 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_27 * 0.07739938050508499f));
  float _52 = select((_28 > 0.040449999272823334f), exp2(log2((_28 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_28 * 0.07739938050508499f));
  float _61 = (pow(_21.x, 0.012683313339948654f));
  float _62 = (pow(_21.y, 0.012683313339948654f));
  float _63 = (pow(_21.z, 0.012683313339948654f));

  float enablePQMaterial = MaterialCollection0_Vectors[1].y; // 0/1 in sdr/hdr
  float scale = MaterialCollection0_Vectors[0].x;  // 270

  float _91 = (exp2(log2(max(0.0f, (_61 + -0.8359375f)) / (18.8515625f - (_61 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / scale;
  float _92 = (exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / scale;
  float _93 = (exp2(log2(max(0.0f, (_63 + -0.8359375f)) / (18.8515625f - (_63 * 18.6875f))) * 6.277394771575928f) * 10000.0f) / scale;
  float _96 = mad(-0.07284992933273315f, _93, mad(-0.5876411199569702f, _92, (_91 * 1.6604909896850586f)));
  float _99 = mad(-0.008349422365427017f, _93, mad(1.1328998804092407f, _92, (_91 * -0.12455052137374878f)));
  float _102 = mad(1.118729829788208f, _93, mad(-0.10057888925075531f, _92, (_91 * -0.018150757998228073f)));

  _96 = linearColor.r;
  _99 = linearColor.g;
  _102 = linearColor.b;

  float _113;
  float _124;
  float _135;
  float _226;
  float _227;
  float _228;
  float _270;
  float _281;
  float _292;
  float _293;
  float _294;
  if (_96 < 0.0031306699384003878f) {
    _113 = (_96 * 12.920000076293945f);
  } else {
    _113 = (((pow(_96, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_99 < 0.0031306699384003878f) {
    _124 = (_99 * 12.920000076293945f);
  } else {
    _124 = (((pow(_99, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_102 < 0.0031306699384003878f) {
    _135 = (_102 * 12.920000076293945f);
  } else {
    _135 = (((pow(_102, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _136 = max(6.103519990574569e-05f, _113);
  float _137 = max(6.103519990574569e-05f, _124);
  float _138 = max(6.103519990574569e-05f, _135);
  // MaterialCollection0_Vectors[1].y is 0
  float _171 = ((enablePQMaterial) * (select((_136 > 0.040449999272823334f), exp2(log2((_136 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_136 * 0.07739938050508499f)) - _50)) + _50;
  float _172 = ((enablePQMaterial) * (select((_137 > 0.040449999272823334f), exp2(log2((_137 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_137 * 0.07739938050508499f)) - _51)) + _51;
  float _173 = ((enablePQMaterial) * (select((_138 > 0.040449999272823334f), exp2(log2((_138 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_138 * 0.07739938050508499f)) - _52)) + _52;

  float _188 = dot(float3(_21.x, _21.y, _21.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
  _188 = renodx::color::y::from::NTSC1953(_21.rgb);

  _188 = renodx::color::y::from::BT709(linearColor);

  float _200 = max(((((Material_PreshaderBuffer[1].y) - _171) * (Material_PreshaderBuffer[1].x)) + _171), 0.0f) * COLOR.x;
  float _201 = max(((((Material_PreshaderBuffer[1].z) - _172) * (Material_PreshaderBuffer[1].x)) + _172), 0.0f) * COLOR.y;
  float _202 = max(((((Material_PreshaderBuffer[1].w) - _173) * (Material_PreshaderBuffer[1].x)) + _173), 0.0f) * COLOR.z;

  renodx::draw::Config config = renodx::draw::BuildConfig();
  float3 output = float3(_200, _201, _202);
  output *= RENODX_DIFFUSE_WHITE_NITS / 80.f;
  _200 = output.r;
  _201 = output.g;
  _202 = output.b;

  float limit = 0.029999999329447746f;
  float _203 = saturate(select((abs(_188 + -limit) > 9.999999747378752e-06f), select((_188 >= limit), 1.0f, 0.0f), 1.0f) + _21.w) * COLOR.w;

  [branch]
  if (!(GammaAndAlphaValues.w == 1.0f)) {
    _226 = saturate((GammaAndAlphaValues.w * (_200 + -0.25f)) + 0.25f);
    _227 = saturate((GammaAndAlphaValues.w * (_201 + -0.25f)) + 0.25f);
    _228 = saturate((GammaAndAlphaValues.w * (_202 + -0.25f)) + 0.25f);
  } else {
    _226 = _200;
    _227 = _201;
    _228 = _202;
  }
  [branch]
  if (!(GammaAndAlphaValues.y == 1.0f)) {
    float _235 = min(max(CustomEffectParams.x, -5.0f), 5.0f);
    bool _237 = (_235 < 0.0f);
    int _238 = (int)(uint)((bool)(_235 > 0.0f));
    float _250 = GammaAndAlphaValues.x + (dot(float2(-0.2199999988079071f, -0.03999999910593033f), float2((1.0f - float((int)(_238 - ((int)(uint)(_237))))), float((int)((int((bool)_237) + 1) + _238)))) * _235);
    float _257 = exp2(_250 * log2(_226));
    float _258 = (pow(_227, _250));
    float _259 = (pow(_228, _250));
    do {
      if (_257 < 0.0031306699384003878f) {
        _270 = (_257 * 12.920000076293945f);
      } else {
        _270 = (((pow(_257, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      do {
        if (_258 < 0.0031306699384003878f) {
          _281 = (_258 * 12.920000076293945f);
        } else {
          _281 = (((pow(_258, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        if (_259 < 0.0031306699384003878f) {
          _292 = _270;
          _293 = _281;
          _294 = (_259 * 12.920000076293945f);
        } else {
          _292 = _270;
          _293 = _281;
          _294 = (((pow(_259, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
      } while (false);
    } while (false);
  } else {
    _292 = _226;
    _293 = _227;
    _294 = _228;
  }
  SV_Target.x = _292;
  SV_Target.y = _293;
  SV_Target.z = _294;
  SV_Target.w = select((!(DrawFlags.x == 0.0f)), (_203 * 0.44999998807907104f), _203);
  return SV_Target;
}
