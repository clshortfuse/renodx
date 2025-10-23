#version 450

#include "../shared.h"

precise const float EXPOSURE = 1.3703000545501708984375;
const float VANILLA_MID_GRAY = 0.18f;

void ApplyTonemap(inout float4 vanillaColor, float4 untonemapped, sampler3D lutTexture, float lerpFactor) {
  if (RENODX_TONE_MAP_TYPE) {
    float3 vanilla_mid_gray = VANILLA_MID_GRAY;
    vanilla_mid_gray = renodx::color::gamma::Encode(vanilla_mid_gray);
    vanilla_mid_gray = texture(lutTexture, vec3(fma(vanilla_mid_gray, 0.9375, 0.03125))).rgb;
    vanilla_mid_gray = lerp(float3(0.18f, 0.18f, 0.18f), vanilla_mid_gray, lerpFactor);
    vanilla_mid_gray *= EXPOSURE;  // TRY WITHOUT THIS
    vanilla_mid_gray = renodx::color::gamma::Decode(vanilla_mid_gray);

    untonemapped.rgb = renodx::color::gamma::EncodeSafe(untonemapped.rgb);
    untonemapped.rgb *= EXPOSURE;
    untonemapped.rgb = renodx::color::gamma::DecodeSafe(untonemapped.rgb);

    vanillaColor.rgb = renodx::draw::ToneMapPass(untonemapped.rgb, vanillaColor.rgb);
  } else {
    vanillaColor.rgb = saturate(vanillaColor.rgb);
  }

  vanillaColor.rgb = renodx::color::correct::GamutCompress(vanillaColor.rgb);
  vanillaColor.rgb = renodx::draw::RenderIntermediatePass(vanillaColor.rgb);
  vanillaColor.a = clamp(vanillaColor.a, 0, 1);
}
