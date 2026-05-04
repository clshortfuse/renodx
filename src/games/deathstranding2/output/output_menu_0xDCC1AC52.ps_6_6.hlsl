#include "./output.hlsli"

Texture2D<float4> t0_space8 : register(t0, space8);

// clang-format off
cbuffer cb0_space8 : register(b0, space8) {
  struct ShaderInstance_PerInstance_Constants {
    struct InUniform_Constant {
      float4 InUniform_Constant_000;
    } ShaderInstance_PerInstance_Constants_000;
  } ShaderInstance_PerInstance_000: packoffset(c000.x);
};
// clang-format on

SamplerState s0_space8 : register(s0, space8);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _13 = t0_space8.Sample(s0_space8, float2(TEXCOORD.x, TEXCOORD.y));
  int _17 = int(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.w);
  float _43;
  float _55;
  float _121;
  float _122;
  float _123;
  [branch]
  if (_17 == 1) {
    float _29 = exp2(log2(abs(_13.x)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x);
    float _30 = exp2(log2(abs(_13.y)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x);
    float _31 = exp2(log2(abs(_13.z)) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x);
    do {
      if (_29 < 0.003100000089034438f) {
        _43 = (_29 * 12.920000076293945f);
      } else {
        _43 = ((exp2(log2(abs(_29)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
      }
      do {
        if (_30 < 0.003100000089034438f) {
          _55 = (_30 * 12.920000076293945f);
        } else {
          _55 = ((exp2(log2(abs(_30)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        if (_31 < 0.003100000089034438f) {
          _121 = _43;
          _122 = _55;
          _123 = (_31 * 12.920000076293945f);
        } else {
          _121 = _43;
          _122 = _55;
          _123 = ((exp2(log2(abs(_31)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f);
        }
      } while (false);
    } while (false);
  } else {
    if (_17 == 2) {
#if 1
      float cbuffer_diffuse_white = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.y;
      float cbuffer_PQ_M1 = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x;

      PQFromBT709FinalWithGammaCorrection(_13.r, _13.g, _13.b,
                  cbuffer_PQ_M1, cbuffer_diffuse_white,
                  _121, _122, _123);
#else
      float cbuffer_diffuse_white = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.y;
      // float cbuffer_diffuse_white = 412.63f / 10000.f;
      float cbuffer_PQ_M1 = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x;

      // insert canvas with the value of ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x and ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.y printed out

      {
        renodx::canvas::Context dbg = renodx::canvas::CreateContext(
            SV_Position.xy,                  // current pixel position
            float2(24.0f, 24.0f),            // text origin (top-left)
            float2(16.0f, 24.0f),            // glyph size
            _13.rgb,                         // background (linear)
            1.0f,                            // output alpha
            float3(0.749f, 0.812f, 0.800f),  // text color (linear)
            1.0f,                            // alpha scale
            1.0f                             // intensity scale
        );

        renodx::canvas::DrawText(
            dbg,
            'c', 'b', 'u', 'f', 'f', 'e', 'r', '_',
            'P', 'Q', '_', 'M', '1', ':', ' ');
        renodx::canvas::DrawFloat(dbg, cbuffer_PQ_M1, 1.0f, 9.0f, false, false);

        renodx::canvas::NewLine(dbg);
        renodx::canvas::DrawText(
            dbg,
            'c', 'b', 'u', 'f', 'f', 'e', 'r', '_',
            'd', 'i', 'f', 'f', 'u', 's', 'e', '_');  // 16-char limit
        renodx::canvas::DrawText(dbg, 'w', 'h', 'i', 't', 'e', ':', ' ');
        renodx::canvas::DrawFloat(dbg, cbuffer_diffuse_white, 1.0f, 6.0f, false, false);

        _13.rgb = renodx::canvas::GetOutput(dbg).rgb;
      }

      float _90 = exp2(log2(abs(mad(0.04331306740641594f, _13.z, mad(0.3292830288410187f, _13.y, (_13.x * 0.6274039149284363f))) * cbuffer_diffuse_white)) * cbuffer_PQ_M1);
      float _91 = exp2(log2(abs(mad(0.011362316086888313f, _13.z, mad(0.9195404052734375f, _13.y, (_13.x * 0.06909728795289993f))) * cbuffer_diffuse_white)) * cbuffer_PQ_M1);
      float _92 = exp2(log2(abs(mad(0.8955952525138855f, _13.z, mad(0.08801330626010895f, _13.y, (_13.x * 0.016391439363360405f))) * cbuffer_diffuse_white)) * cbuffer_PQ_M1);
      _121 = exp2(log2(abs(((_90 * 18.8515625f) + 0.8359375f) / ((_90 * 18.6875f) + 1.0f))) * 78.84375f);
      _122 = exp2(log2(abs(((_91 * 18.8515625f) + 0.8359375f) / ((_91 * 18.6875f) + 1.0f))) * 78.84375f);
      _123 = exp2(log2(abs(((_92 * 18.8515625f) + 0.8359375f) / ((_92 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      _121 = _13.x;
      _122 = _13.y;
      _123 = _13.z;
    }
  }
  SV_Target.x = _121;
  SV_Target.y = _122;
  SV_Target.z = _123;
  SV_Target.w = 1.0f;
  return SV_Target;
}
