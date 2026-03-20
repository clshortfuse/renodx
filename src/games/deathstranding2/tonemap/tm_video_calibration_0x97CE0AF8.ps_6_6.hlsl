#include "./tonemap.hlsli"
Texture2D<float4> t0_space8 : register(t0, space8);

Texture2D<float4> t1_space8 : register(t1, space8);

Texture2D<float4> t2_space8 : register(t2, space8);

Texture2D<float4> t3_space8 : register(t3, space8);

// clang-format off
cbuffer cb0_space8 : register(b0, space8) {
  struct ShaderInstance_PerInstance_Constants {
    struct InUniform_Constant {
      float4 InUniform_Constant_000;
      float4 InUniform_Constant_016;
      float4 InUniform_Constant_032;
      float4 InUniform_Constant_048;
      float4 InUniform_Constant_064;
      float4 InUniform_Constant_080;
      float4 InUniform_Constant_096;
    } ShaderInstance_PerInstance_Constants_000;
  } ShaderInstance_PerInstance_000 : packoffset(c000.x);
};
// clang-format on

SamplerState s0_space8 : register(s0, space8);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float2 SV_Target_1 : SV_Target1;
  float SV_Target_2 : SV_Target2;
};

OutputSignature main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) {
  float4 SV_Target;
  float2 SV_Target_1;
  float SV_Target_2;
  float _28 = TEXCOORD.x - ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_016.z;
  float _29 = TEXCOORD.y - ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_016.w;
  float4 _32 = t0_space8.Sample(s0_space8, float2(_28, _29));
  float4 _35 = t1_space8.Sample(s0_space8, float2(_28, _29));
  float4 _38 = t2_space8.Sample(s0_space8, float2(_28, _29));
  float _166;
  float _178;
  float _190;
  float _193;
  float _194;
  float _195;
  if (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.x > 0.0f) {
    float4 _47 = t3_space8.Sample(s0_space8, float2(_28, _29));
    float _50 = (_35.x * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.x) + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.z;
    float _52 = (_38.x * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.y) + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000.w;
    float _54 = (_47.x + _32.x) * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_016.x;
    float _55 = _50 * 0.008609036915004253f;
    float _58 = _52 * 0.11102962493896484f;
    float _75 = exp2(log2(max(((_58 + _55) + _54), 0.0f)) * 0.012683313339948654f);
    float _76 = exp2(log2(max((((-0.0f - _55) - _58) + _54), 0.0f)) * 0.012683313339948654f);
    float _77 = exp2(log2(max((((_50 * 0.5600313544273376f) - (_52 * 0.3206271827220917f)) + _54), 0.0f)) * 0.012683313339948654f);
    float _102 = exp2(log2(abs(max(0.0f, (_75 + -0.8359375f)) / (18.8515625f - (_75 * 18.6875f)))) * 6.277394771575928f);
    float _103 = exp2(log2(abs(max(0.0f, (_76 + -0.8359375f)) / (18.8515625f - (_76 * 18.6875f)))) * 6.277394771575928f);
    float _104 = exp2(log2(abs(max(0.0f, (_77 + -0.8359375f)) / (18.8515625f - (_77 * 18.6875f)))) * 6.277394771575928f);
    float _117 = ((_102 * 429.5758361816406f) - (_103 * 313.3065185546875f)) + (_104 * 8.730677604675293f);
    float _118 = ((_103 * 247.95005798339844f) - (_102 * 98.91619873046875f)) - (_104 * 24.03386116027832f);
    float _119 = ((_103 * -12.364213943481445f) - (_102 * 3.2437374591827393f)) + (_104 * 140.6079559326172f);
#if 0
    float _126 = -0.0f - ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.x;
    float _137 = select((_117 < ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_080.z), ((_117 * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.y) + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.z), ((_126 / (_117 + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.y)) + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.z));
    float _139 = select((_118 < ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_080.z), ((_118 * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.y) + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.z), ((_126 / (_118 + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.y)) + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.z));
    float _141 = select((_119 < ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_080.z), ((_119 * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.y) + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.z), ((_126 / (_119 + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.y)) + ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.z));
    
    {
      float cbuffer_064_y = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.y;
      float cbuffer_064_z = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.z;
      float cbuffer_080_z = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_080.z;
      float cbuffer_096_x = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.x;
      float cbuffer_096_y = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.y;
      float cbuffer_096_z = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.z;

      renodx::canvas::Context dbg = renodx::canvas::CreateContext(
          SV_Position.xy,
          float2(24.0f, 24.0f),
          float2(14.0f, 22.0f),
          float3(_137, _139, _141),
          1.0f,
          float3(0.749f, 0.812f, 0.800f),
          1.0f,
          1.0f);

      renodx::canvas::DrawText(dbg, 'c', 'b', '0', '6', '4', '_', 'y', ':', ' ');
      renodx::canvas::DrawFloat(dbg, cbuffer_064_y, 1.0f, 6.0f, false, false);

      renodx::canvas::NewLine(dbg);
      renodx::canvas::DrawText(dbg, 'c', 'b', '0', '6', '4', '_', 'z', ':', ' ');
      renodx::canvas::DrawFloat(dbg, cbuffer_064_z, 1.0f, 6.0f, false, false);

      renodx::canvas::NewLine(dbg);
      renodx::canvas::DrawText(dbg, 'c', 'b', '0', '8', '0', '_', 'z', ':', ' ');
      renodx::canvas::DrawFloat(dbg, cbuffer_080_z, 1.0f, 6.0f, false, false);

      renodx::canvas::NewLine(dbg);
      renodx::canvas::DrawText(dbg, 'c', 'b', '0', '9', '6', '_', 'x', ':', ' ');
      renodx::canvas::DrawFloat(dbg, cbuffer_096_x, 1.0f, 6.0f, false, false);

      renodx::canvas::NewLine(dbg);
      renodx::canvas::DrawText(dbg, 'c', 'b', '0', '9', '6', '_', 'y', ':', ' ');
      renodx::canvas::DrawFloat(dbg, cbuffer_096_y, 1.0f, 6.0f, false, false);

      renodx::canvas::NewLine(dbg);
      renodx::canvas::DrawText(dbg, 'c', 'b', '0', '9', '6', '_', 'z', ':', ' ');
      renodx::canvas::DrawFloat(dbg, cbuffer_096_z, 1.0f, 6.0f, false, false);

      renodx::canvas::NewLine(dbg);
      renodx::canvas::DrawText(dbg, '_', '1', '2', '6', ':', ' ');
      renodx::canvas::DrawFloat(dbg, _126, 1.0f, 6.0f, false, false);

      float3 dbg_rgb = renodx::canvas::GetOutput(dbg).rgb;
      _137 = dbg_rgb.r;
      _139 = dbg_rgb.g;
      _141 = dbg_rgb.b;
    }
#else
    float cbuffer_064_y = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.y;
    float cbuffer_064_z = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064.z;
    float cbuffer_080_z = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_080.z;
    float cbuffer_096_x = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.x;
    float cbuffer_096_y = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.y;
    float cbuffer_096_z = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_096.z;

    float _137;
    float _139;
    float _141;
    ApplyUserGradingAndToneMapAndScale(_117, _118, _119,
                                       cbuffer_064_y, cbuffer_064_z,
                                       cbuffer_080_z,
                                       cbuffer_096_x, cbuffer_096_y, cbuffer_096_z,
                                       _137, _139, _141,
                                       false  // use_scaling
    );
#endif
    SV_Target_1.x = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.z;
    SV_Target_1.y = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.w;
    SV_Target_2 = dot(float3(_137, _139, _141), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    _193 = _137;
    _194 = _139;
    _195 = _141;
  } else {
    float _149 = (_32.x + -0.7009999752044678f) + (_35.x * 1.4019999504089355f);
    float _152 = ((_32.x + 0.5291399955749512f) - (_35.x * 0.714139997959137f)) - (_38.x * 0.3441399931907654f);
    float _154 = (_32.x + -0.8859999775886536f) + (_38.x * 1.7719999551773071f);
    do {
      if (_149 < 0.040449999272823334f) {
        _166 = (_149 * 0.07739938050508499f);
      } else {
        _166 = exp2(log2(abs((_149 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
      }
      do {
        if (_152 < 0.040449999272823334f) {
          _178 = (_152 * 0.07739938050508499f);
        } else {
          _178 = exp2(log2(abs((_152 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
        }
        do {
          if (_154 < 0.040449999272823334f) {
            _190 = (_154 * 0.07739938050508499f);
          } else {
            _190 = exp2(log2(abs((_154 * 0.9478672742843628f) + 0.05213269963860512f)) * 2.4000000953674316f);
          }

          // ScaleVideo(_166, _178, _190);

          SV_Target_1.x = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.z;
          SV_Target_1.y = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_048.w;
          SV_Target_2 = dot(float3(_166, _178, _190), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
          _193 = _166;
          _194 = _178;
          _195 = _190;
        } while (false);
      } while (false);
    } while (false);
  }
  SV_Target.x = _193;
  SV_Target.y = _194;
  SV_Target.z = _195;
  SV_Target.w = 1.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1, SV_Target_2 };
  return output_signature;
}
