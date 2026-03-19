#include "../common.hlsli"

Texture2D<float4> t0_space8 : register(t0, space8);

Texture2D<float4> t1_space8 : register(t1, space8);

Texture2D<float4> t2_space8 : register(t2, space8);

RWTexture2D<float4> u0_space8 : register(u0, space8);

// clang-format off
cbuffer cb0_space8 : register(b0, space8) {
  struct ShaderInstance_PerInstance_Constants {
    struct InUniform_Constant {
      float4 InUniform_Constant_000;
      float4 InUniform_Constant_016;
      float4 InUniform_Constant_032;
      float4 InUniform_Constant_048;
      float4 InUniform_Constant_064;
      float2 InUniform_Constant_080;
    } ShaderInstance_PerInstance_Constants_000;
  } ShaderInstance_PerInstance_000 : packoffset(c000.x);
};
// clang-format on

SamplerState s0_space8 : register(s0, space8);

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  uint _37 = ((int)((((uint)((uint)(SV_GroupID.x) << 3)) & 56) | ((uint)(SV_GroupID.x) & -64))) + SV_GroupThreadID.x;
  uint _38 = ((int)(((uint)((uint)(SV_GroupID.y) << 6)) | ((uint)(SV_GroupID.x) & 56))) + SV_GroupThreadID.y;
  float _43 = (float((uint)_37) + 0.5f) / ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.x;
  float _44 = (float((uint)_38) + 0.5f) / ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.y;
  float4 _47 = t0_space8.SampleLevel(s0_space8, float2(_43, _44), 0.0f);
  float4 _59 = t1_space8.SampleLevel(s0_space8, float2(((_43 * (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.z - ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.x)) + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.x), ((_44 * (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.w - ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.y)) + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.y)), 0.0f);
  int _64 = int(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_016.w);
  float _78;
  float _90;
  float _102;
  float _170;
  float _171;
  float _172;
  float _206;
  float _218;
  float _284;
  float _285;
  float _286;
  [branch]
  if (_64 == 1) {
    do {
      if (_59.x < 0.040449999272823334f) {
        _78 = (_59.x * 0.07739938050508499f);
      } else {
        _78 = exp2(log2(abs((_59.x * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
      }
      do {
        if (_59.y < 0.040449999272823334f) {
          _90 = (_59.y * 0.07739938050508499f);
        } else {
          _90 = exp2(log2(abs((_59.y * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
        }
        do {
          if (_59.z < 0.040449999272823334f) {
            _102 = (_59.z * 0.07739938050508499f);
          } else {
            _102 = exp2(log2(abs((_59.z * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
          }
          float _103 = 1.0f / ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_016.x;
          _170 = exp2(log2(abs(_78)) * _103);
          _171 = exp2(log2(abs(_90)) * _103);
          _172 = exp2(log2(abs(_102)) * _103);
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (_64 == 2) {
#if 1
      BT709FromPQ(
          _59.x, _59.y, _59.z,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_016.x,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_016.y,
          _170, _171, _172);
#else
      float _128 = exp2(log2(abs(_59.x)) * 0.012683313339948654f);
      float _129 = exp2(log2(abs(_59.y)) * 0.012683313339948654f);
      float _130 = exp2(log2(abs(_59.z)) * 0.012683313339948654f);
      float _143 = 1.0f / ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_016.x;
      float _156 = 1.0f / ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_016.y;
      float _157 = _156 * exp2(log2(abs((_128 + -0.8359375f) / (18.8515625f - (_128 * 18.6875f)))) * _143);
      float _158 = _156 * exp2(log2(abs((_129 + -0.8359375f) / (18.8515625f - (_129 * 18.6875f)))) * _143);
      float _159 = _156 * exp2(log2(abs((_130 + -0.8359375f) / (18.8515625f - (_130 * 18.6875f)))) * _143);
      _170 = mad(-0.07284989953041077f, _159, mad(-0.5876410007476807f, _158, (_157 * 1.6604900360107422f)));
      _171 = mad(-0.008349419571459293f, _159, mad(1.1328999996185303f, _158, (_157 * -0.124549999833107f)));
      _172 = mad(1.1187299489974976f, _159, mad(-0.10057900100946426f, _158, (_157 * -0.018150800839066505f)));
#endif
    } else {
      _170 = _59.x;
      _171 = _59.y;
      _172 = _59.z;
    }
  }
  float _173 = 1.0f - _47.w;
  float _177 = (_170 * _173) + _47.x;
  float _178 = (_171 * _173) + _47.y;
  float _179 = (_172 * _173) + _47.z;
  int _180 = int(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.w);
  [branch]
  if (_180 == 1) {
    float _192 = exp2(log2(abs(_177)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    float _193 = exp2(log2(abs(_178)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    float _194 = exp2(log2(abs(_179)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
    do {
      if (_192 < 0.003100000089034438f) {
        _206 = (_192 * 12.920000076293945f);
      } else {
        _206 = ((exp2(log2(abs(_192)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      do {
        if (_193 < 0.003100000089034438f) {
          _218 = (_193 * 12.920000076293945f);
        } else {
          _218 = ((exp2(log2(abs(_193)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        if (_194 < 0.003100000089034438f) {
          _284 = _206;
          _285 = _218;
          _286 = (_194 * 12.920000076293945f);
        } else {
          _284 = _206;
          _285 = _218;
          _286 = ((exp2(log2(abs(_194)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
      } while (false);
    } while (false);
  } else {
    if (_180 == 2) {
#if 1
      PQFromBT709(
          _177, _178, _179,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x,
          ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y,
          _284, _285, _286);
#else
      float _253 = exp2(log2(abs(mad(0.04331306740641594f, _179, mad(0.3292830288410187f, _178, (_177 * 0.6274039149284363f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      float _254 = exp2(log2(abs(mad(0.011362316086888313f, _179, mad(0.9195404052734375f, _178, (_177 * 0.06909728795289993f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      float _255 = exp2(log2(abs(mad(0.8955952525138855f, _179, mad(0.08801330626010895f, _178, (_177 * 0.016391439363360405f))) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_032.x);
      _284 = exp2(log2(abs(((_253 * 18.8515625f) + 0.8359375f) / ((_253 * 18.6875f) + 1.0f))) * 78.84375f);
      _285 = exp2(log2(abs(((_254 * 18.8515625f) + 0.8359375f) / ((_254 * 18.6875f) + 1.0f))) * 78.84375f);
      _286 = exp2(log2(abs(((_255 * 18.8515625f) + 0.8359375f) / ((_255 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      _284 = _177;
      _285 = _178;
      _286 = _179;
    }
  }
  float4 _290 = t2_space8.Load(int3((_37 & 31), (_38 & 31), 0));
  float _293 = (_290.x + -0.5f) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x;
  float4 _298 = u0_space8.Load(int2(_37, _38));
  u0_space8[int2(_37, _38)] = float4((_293 + _284), (_293 + _285), (_293 + _286), _298.w);
  float4 _301 = u0_space8.Load(int2(_37, _38));
  u0_space8[int2(_37, _38)] = float4(_301.x, _301.y, _301.z, _59.w);
}
