#include "./common.hlsl"

Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

/* cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
}; */

SamplerState PointBorder : register(s2, space32);

// SamplerState TrilinearClamp : register(s9, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _17 = (HDRMapping_000x) * 0.009999999776482582f;  // overall brightness
  float _18 = _17 * (_11.x);
  float _19 = _17 * (_11.y);
  float _20 = _17 * (_11.z);

  if (RENODX_TONE_MAP_TYPE > 0.f) {
    float3 untonemapped = _11.rgb;

    renodx::lut::Config lut_config = renodx::lut::config::Create();
    lut_config.lut_sampler = TrilinearClamp;
    lut_config.size = 64u;
    lut_config.tetrahedral = false;
    lut_config.type_input = renodx::lut::config::type::LINEAR;
    lut_config.type_output = renodx::lut::config::type::LINEAR;
    lut_config.scaling = 0.f;

    float3 lutOutput = renodx::color::pq::EncodeSafe(untonemapped, RENODX_GAME_NITS);
    // Outputs PQ
    lutOutput = renodx::lut::Sample(
        SrcLUT,
        lut_config,
        lutOutput);

    lutOutput = renodx::color::pq::DecodeSafe(lutOutput, 100.f);  // 100.f because ingame LUT encodes to 100.f
    lutOutput = renodx::color::bt709::from::BT2020(lutOutput);
    SV_Target.rgb = renodx::draw::ToneMapPass(untonemapped, renodx::tonemap::renodrt::NeutralSDR(lutOutput));
    SV_Target = FinalizeOutput(SV_Target.rgb);
    // SV_Target = float4(lutOutput, 1.f);
    return SV_Target;
  }

  float _35 = -0.35844698548316956f;
  float _50;
  float _65;

  // ACEScc according to Lilium
  // Apparently ACEScc <=> ACES can cause shadow detail loss because ACEScc uses negative values
  if ((!(_18 <= 0.0f))) {
    if (((_18 < 3.0517578125e-05f))) {
      _35 = (((log2(((_18 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _35 = (((log2(_18)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _50 = -0.35844698548316956f;
  if ((!(_19 <= 0.0f))) {
    if (((_19 < 3.0517578125e-05f))) {
      _50 = (((log2(((_19 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _50 = (((log2(_19)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _65 = -0.35844698548316956f;
  if ((!(_20 <= 0.0f))) {
    if (((_20 < 3.0517578125e-05f))) {
      _65 = (((log2(((_20 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _65 = (((log2(_20)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }

  float4 _74 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_35 * 0.984375f) + 0.0078125f), ((_50 * 0.984375f) + 0.0078125f), ((_65 * 0.984375f) + 0.0078125f)), 0.0f);

  SV_Target.x = (_74.x);
  SV_Target.y = (_74.y);
  SV_Target.z = (_74.z);

  SV_Target.w = 1.0f;
  return SV_Target;
}
