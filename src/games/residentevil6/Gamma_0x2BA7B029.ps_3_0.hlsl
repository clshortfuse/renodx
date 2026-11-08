#include "./display_mapping.hlsli"

sampler2D SSPoint__tBaseMap : register(s0);
sampler2D scene_before_hud : register(s12);
sampler2D scene_transmission : register(s13);
float3 fGamma : register(c1);

float3 GameGammaWithHeadroom(float3 color, float gamma) {
  return pow(min(color, 1.f), gamma) + max(color - 1.f, 0.f) * gamma;
}

float4 main(float2 texcoord : TEXCOORD0) : COLOR0 {
  float4 sample_color = tex2D(SSPoint__tBaseMap, texcoord);
  float gamma = max(fGamma.x, 1.e-6f);
  [branch]
  if (!UseSceneHDR()) {
    float3 original = pow(max(DecodeGameSRGB(saturate(sample_color.rgb)), 0.f), gamma);
    return saturate(float4(EncodeGameSRGB(original), sample_color.a));
  }

  bool split = RENODX_SCENE_HUD_SPLIT == 1.f;
  float3 scene_encoded = sample_color.rgb;
  [branch]
  if (split) {
    scene_encoded = tex2D(scene_before_hud, texcoord).rgb;
  }
  // Continue each channel at the white boundary with its local slope.
  float3 scene = GameGammaWithHeadroom(max(DecodeGameSRGB(scene_encoded), 0.f), gamma);
  float3 mapped = MapGameTone(scene, RENODX_TONE_MAP_TYPE);

  [branch]
  if (split) {
    float transmission = saturate(tex2D(scene_transmission, texcoord).r);
    [branch]
    if (transmission < 1.f || any(sample_color.rgb != scene_encoded)) {
      // Preserve the game's encoded blend domain. Its affine HUD contribution
      // is the composite minus the original scene times its transmission.
      float3 hud = sample_color.rgb - scene_encoded * transmission;
      float3 mapped_pre_gamma = sign(mapped) * GameGammaWithHeadroom(abs(mapped), rcp(gamma));
      float3 recomposed = DecodeGameSRGB(EncodeGameSRGB(mapped_pre_gamma) * transmission + hud);
      mapped = sign(recomposed) * GameGammaWithHeadroom(abs(recomposed), gamma);
    }
  }
  return float4(renodx::draw::RenderIntermediatePass(mapped), saturate(sample_color.a));
}
