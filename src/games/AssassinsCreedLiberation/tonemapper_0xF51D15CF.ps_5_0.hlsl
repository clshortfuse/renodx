#include "./common.hlsl"

SamplerState _sampler_Scene_s : register(s0);
SamplerState _sampler_Exposure_s : register(s1);
Texture2D<float4> _texture_Scene : register(t0);
Texture2D<float4> _texture_Exposure : register(t1);

float3 GameACESFittedTonemap(float3 color)
{
    float3 aces;

    aces.x = dot(
        float3(
            0.597190022f,
            0.354579985f,
            0.0482299998f
        ),
        color
    );

    aces.y = dot(
        float3(
            0.0759999976f,
            0.908339977f,
            0.0156599991f
        ),
        color
    );

    aces.z = dot(
        float3(
            0.0284000002f,
            0.133829996f,
            0.837769985f
        ),
        color
    );


    float3 numerator =
        aces * (aces + 0.0245785993f)
        - 0.0000905370034f;

    float3 denominator =
        aces * (aces * 0.983729005f + 0.432951003f)
        + 0.238080993f;

    float3 mapped =
        numerator / max(denominator, 0.000001f);


    float3 output;

    output.x = dot(
        float3(
            1.60475004f,
            -0.531080008f,
            -0.0736699998f
        ),
        mapped
    );

    output.y = dot(
        float3(
            -0.102080002f,
            1.10812998f,
            -0.00604999997f
        ),
        mapped
    );

    output.z = dot(
        float3(
            -0.00326999999f,
            -0.0727600008f,
            1.07602f
        ),
        mapped
    );


    // Vanilla SDR path intentionally remains clamped.
    return saturate(output);
}


float3 MatchSceneToSDR(float3 scene, float peak, float type = -1.f) {
  float3 reference = GameACESFittedTonemap(scene);
  if (peak <= 1.f) return reference;
  float3 hdr = MapSceneToDisplay(scene, peak, type);
  float3 sdr = MapSceneToDisplay(scene, 1.f, type);
  float3 result = renodx::tonemap::UpgradeToneMap(hdr, sdr, reference);
  // Retain the original black/toe below the matched mid-gray pivot. The HDR
  // response is already fully active at mid-gray, well below paper white.
  result = lerp(reference, result, smoothstep(ACES_ANCHOR_IN * 0.5f,
      ACES_ANCHOR_IN, renodx::color::y::from::BT709(scene)));
  float maximum = max(result.r, max(result.g, result.b));
  float limit = GetWorkingPeak(peak);
  if (limit > 1.f && maximum > 0.f) {
    result *= renodx::tonemap::ExponentialRollOff(maximum, max(1.f, limit * 0.9f), limit) / maximum;
  }
  return max(result, 0.f);
}

void main(float4 position : SV_Position0, float2 uv : TEXCOORD0, out float4 output : SV_Target0) {
  float3 scene = max(_texture_Scene.Sample(_sampler_Scene_s, uv).rgb, 0.f);
  scene *= max(_texture_Exposure.Sample(_sampler_Exposure_s, 0.f.xx).x, 0.f);

  if (!IsCustomHDRMode() || RENODX_PEAK_WHITE_NITS <= 0.f) {
    output = float4(renodx::color::srgb::EncodeSafe(GameACESFittedTonemap(scene)), 1.f);
    return;
  }

  scene = PreTonemapSliders(scene);
  float peak = max(RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.f), 1.f);
  float3 color = MatchSceneToSDR(scene, peak);
  output = float4(renodx::color::srgb::EncodeSafe(max(color, 0.f)), 1.f);
}
