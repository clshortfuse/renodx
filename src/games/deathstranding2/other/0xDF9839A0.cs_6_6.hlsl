#include "../common.hlsli"

RWTexture2D<float4> u0_space8 : register(u0, space8);

RWTexture2D<float4> u1_space8 : register(u1, space8);

// clang-format off
cbuffer cb0_space8 : register(b0, space8) {
  struct ShaderInstance_PerInstance_Constants {
    struct InUniform_Constant {
      float4 InUniform_Constant_000;
    } ShaderInstance_PerInstance_Constants_000;
  } ShaderInstance_PerInstance_000 : packoffset(c000.x);
};
// clang-format on

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float4 _12 = u0_space8.Load(int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y)));
  u1_space8[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_12.x, _12.y, _12.z, _12.w);
  float4 _19 = u0_space8.Load(int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y)));
  int _23 = int(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.w);
  float _37;
  float _49;
  float _61;
  float _129;
  float _130;
  float _131;
  [branch]
  if (_23 == 1) {
    do {
      if (_19.x < 0.040449999272823334f) {
        _37 = (_19.x * 0.07739938050508499f);
      } else {
        _37 = exp2(log2(abs((_19.x * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
      }
      do {
        if (_19.y < 0.040449999272823334f) {
          _49 = (_19.y * 0.07739938050508499f);
        } else {
          _49 = exp2(log2(abs((_19.y * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
        }
        do {
          if (_19.z < 0.040449999272823334f) {
            _61 = (_19.z * 0.07739938050508499f);
          } else {
            _61 = exp2(log2(abs((_19.z * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
          }
          float _62 = 1.0f / ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x;
          _129 = exp2(log2(abs(_37)) * _62);
          _130 = exp2(log2(abs(_49)) * _62);
          _131 = exp2(log2(abs(_61)) * _62);
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (_23 == 2) {
#if 1
      BT709FromPQ(
          _19.x, _19.y, _19.z,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.y,
          _129, _130, _131);
#else
      float _87 = exp2(log2(abs(_19.x)) * 0.012683313339948654f);
      float _88 = exp2(log2(abs(_19.y)) * 0.012683313339948654f);
      float _89 = exp2(log2(abs(_19.z)) * 0.012683313339948654f);
      float _102 = 1.0f / ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x;
      float _115 = 1.0f / ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.y;
      float _116 = _115 * exp2(log2(abs((_87 + -0.8359375f) / (18.8515625f - (_87 * 18.6875f)))) * _102);
      float _117 = _115 * exp2(log2(abs((_88 + -0.8359375f) / (18.8515625f - (_88 * 18.6875f)))) * _102);
      float _118 = _115 * exp2(log2(abs((_89 + -0.8359375f) / (18.8515625f - (_89 * 18.6875f)))) * _102);
      _129 = mad(-0.07284989953041077f, _118, mad(-0.5876410007476807f, _117, (_116 * 1.6604900360107422f)));
      _130 = mad(-0.008349419571459293f, _118, mad(1.1328999996185303f, _117, (_116 * -0.124549999833107f)));
      _131 = mad(1.1187299489974976f, _118, mad(-0.10057900100946426f, _117, (_116 * -0.018150800839066505f)));
#endif
    } else {
      _129 = _19.x;
      _130 = _19.y;
      _131 = _19.z;
    }
  }
  float4 _133 = u1_space8.Load(int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y)));
  u1_space8[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_129, _130, _131, _133.w);
}
