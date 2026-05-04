#include "../common.hlsli"

struct IntelTAASRT_Constant {
  float4 IntelTAASRT_Constant_000[4];
  float4 IntelTAASRT_Constant_064;
  float4 IntelTAASRT_Constant_080;
  float4 IntelTAASRT_Constant_096;
  float4 IntelTAASRT_Constant_112;
  float4 IntelTAASRT_Constant_128;
  float4 IntelTAASRT_Constant_144;
  float4 IntelTAASRT_Constant_160;
  float4 IntelTAASRT_Constant_176;
  float2 IntelTAASRT_Constant_192;
  float2 IntelTAASRT_Constant_200;
  float4 IntelTAASRT_Constant_208;
  float2 IntelTAASRT_Constant_224;
  int IntelTAASRT_Constant_232;
  int IntelTAASRT_Constant_236;
  float IntelTAASRT_Constant_240;
  float IntelTAASRT_Constant_244;
  float IntelTAASRT_Constant_248;
  float IntelTAASRT_Constant_252;
  float IntelTAASRT_Constant_256;
  float IntelTAASRT_Constant_260;
  float IntelTAASRT_Constant_264;
  float IntelTAASRT_Constant_268;
};

struct Scratch_PerBatch_Constants {
  IntelTAASRT_Constant Scratch_PerBatch_Constants_000;
};

Texture2D<float3> t0_space5 : register(t0, space5);

Texture2D<float4> t4_space5 : register(t4, space5);

RWTexture2D<float4> u0_space5 : register(u0, space5);

cbuffer cb0_space5 : register(b0, space5) {
  Scratch_PerBatch_Constants Scratch_PerBatch_000 : packoffset(c000.x);
};

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float3 _15 = t0_space5.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
  int _20 = int(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.w);
  bool _21 = (_20 == 1);
  float _35;
  float _47;
  float _59;
  float _145;
  float _157;
  float _169;
  float _237;
  float _238;
  float _239;
  float _271;
  float _283;
  float _349;
  float _350;
  float _351;
  if (Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_080.w < 1.0f) {
    [branch]
    if (_21) {
      do {
        if (_15.x < 0.040449999272823334f) {
          _35 = (_15.x * 0.07739938050508499f);
        } else {
          _35 = exp2(log2(abs((_15.x * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
        }
        do {
          if (_15.y < 0.040449999272823334f) {
            _47 = (_15.y * 0.07739938050508499f);
          } else {
            _47 = exp2(log2(abs((_15.y * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
          }
          do {
            if (_15.z < 0.040449999272823334f) {
              _59 = (_15.z * 0.07739938050508499f);
            } else {
              _59 = exp2(log2(abs((_15.z * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
            }
            float _60 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x;
            _349 = exp2(log2(abs(_35)) * _60);
            _350 = exp2(log2(abs(_47)) * _60);
            _351 = exp2(log2(abs(_59)) * _60);
          } while (false);
        } while (false);
      } while (false);
    } else {
      if (_20 == 2) {
#if 1
        BT709FromPQ(
            _15.x, _15.y, _15.z,
            Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x,
            Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.y,
            _349, _350, _351);
#else
        float _85 = exp2(log2(abs(_15.x)) * 0.012683313339948654f);
        float _86 = exp2(log2(abs(_15.y)) * 0.012683313339948654f);
        float _87 = exp2(log2(abs(_15.z)) * 0.012683313339948654f);
        float _100 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x;
        float _113 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.y;
        float _114 = _113 * exp2(log2(abs((_85 + -0.8359375f) / (18.8515625f - (_85 * 18.6875f)))) * _100);
        float _115 = _113 * exp2(log2(abs((_86 + -0.8359375f) / (18.8515625f - (_86 * 18.6875f)))) * _100);
        float _116 = _113 * exp2(log2(abs((_87 + -0.8359375f) / (18.8515625f - (_87 * 18.6875f)))) * _100);
        _349 = mad(-0.07284989953041077f, _116, mad(-0.5876410007476807f, _115, (_114 * 1.6604900360107422f)));
        _350 = mad(-0.008349419571459293f, _116, mad(1.1328999996185303f, _115, (_114 * -0.124549999833107f)));
        _351 = mad(1.1187299489974976f, _116, mad(-0.10057900100946426f, _115, (_114 * -0.018150800839066505f)));
#endif
      } else {
        _349 = _15.x;
        _350 = _15.y;
        _351 = _15.z;
      }
    }
  } else {
    float4 _128 = t4_space5.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
    do {
      [branch]
      if (_21) {
        do {
          if (_15.x < 0.040449999272823334f) {
            _145 = (_15.x * 0.07739938050508499f);
          } else {
            _145 = exp2(log2(abs((_15.x * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
          }
          do {
            if (_15.y < 0.040449999272823334f) {
              _157 = (_15.y * 0.07739938050508499f);
            } else {
              _157 = exp2(log2(abs((_15.y * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
            }
            do {
              if (_15.z < 0.040449999272823334f) {
                _169 = (_15.z * 0.07739938050508499f);
              } else {
                _169 = exp2(log2(abs((_15.z * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
              }
              float _170 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x;
              _237 = exp2(log2(abs(_145)) * _170);
              _238 = exp2(log2(abs(_157)) * _170);
              _239 = exp2(log2(abs(_169)) * _170);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if (_20 == 2) {
#if 1
          BT709FromPQ(
              _15.x, _15.y, _15.z,
              Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x,
              Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.y,
              _237, _238, _239);
#else
          float _195 = exp2(log2(abs(_15.x)) * 0.012683313339948654f);
          float _196 = exp2(log2(abs(_15.y)) * 0.012683313339948654f);
          float _197 = exp2(log2(abs(_15.z)) * 0.012683313339948654f);
          float _210 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x;
          float _223 = 1.0f / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.y;
          float _224 = _223 * exp2(log2(abs((_195 + -0.8359375f) / (18.8515625f - (_195 * 18.6875f)))) * _210);
          float _225 = _223 * exp2(log2(abs((_196 + -0.8359375f) / (18.8515625f - (_196 * 18.6875f)))) * _210);
          float _226 = _223 * exp2(log2(abs((_197 + -0.8359375f) / (18.8515625f - (_197 * 18.6875f)))) * _210);
          _237 = mad(-0.07284989953041077f, _226, mad(-0.5876410007476807f, _225, (_224 * 1.6604900360107422f)));
          _238 = mad(-0.008349419571459293f, _226, mad(1.1328999996185303f, _225, (_224 * -0.124549999833107f)));
          _239 = mad(1.1187299489974976f, _226, mad(-0.10057900100946426f, _225, (_224 * -0.018150800839066505f)));
#endif
        } else {
          _237 = _15.x;
          _238 = _15.y;
          _239 = _15.z;
        }
      }
      float _240 = 1.0f - _128.w;
      float _244 = (_237 * _240) + _128.x;
      float _245 = (_238 * _240) + _128.y;
      float _246 = (_239 * _240) + _128.z;
      [branch]
      if (_21) {
        float _257 = exp2(log2(abs(_244)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x);
        float _258 = exp2(log2(abs(_245)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x);
        float _259 = exp2(log2(abs(_246)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x);
        do {
          if (_257 < 0.003100000089034438f) {
            _271 = (_257 * 12.920000076293945f);
          } else {
            _271 = ((exp2(log2(abs(_257)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            if (_258 < 0.003100000089034438f) {
              _283 = (_258 * 12.920000076293945f);
            } else {
              _283 = ((exp2(log2(abs(_258)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            if (_259 < 0.003100000089034438f) {
              _349 = _271;
              _350 = _283;
              _351 = (_259 * 12.920000076293945f);
            } else {
              _349 = _271;
              _350 = _283;
              _351 = ((exp2(log2(abs(_259)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
            }
          } while (false);
        } while (false);
      } else {
        if (_20 == 2) {
#if 1
          PQFromBT709(
              _244, _245, _246,
              Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x,
              Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.y,
              _349, _350, _351);
#else
          float _318 = exp2(log2(abs(mad(0.04331306740641594f, _246, mad(0.3292830288410187f, _245, (_244 * 0.6274039149284363f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x);
          float _319 = exp2(log2(abs(mad(0.011362316086888313f, _246, mad(0.9195404052734375f, _245, (_244 * 0.06909728795289993f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x);
          float _320 = exp2(log2(abs(mad(0.8955952525138855f, _246, mad(0.08801330626010895f, _245, (_244 * 0.016391439363360405f))) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.y)) * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.IntelTAASRT_Constant_064.x);
          _349 = exp2(log2(abs(((_318 * 18.8515625f) + 0.8359375f) / ((_318 * 18.6875f) + 1.0f))) * 78.84375f);
          _350 = exp2(log2(abs(((_319 * 18.8515625f) + 0.8359375f) / ((_319 * 18.6875f) + 1.0f))) * 78.84375f);
          _351 = exp2(log2(abs(((_320 * 18.8515625f) + 0.8359375f) / ((_320 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
        } else {
          _349 = _244;
          _350 = _245;
          _351 = _246;
        }
      }
    } while (false);
  }
  u0_space5[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_349, _350, _351, 1.0f);
}
