#include "../shared.h"

// FMV YUV->RGB decode. Faithful 1:1 vanilla reconstruction (BT.601 limited-range), sRGB-encoded into
// the r8g8b8a8 video buffer. Registered via callback only to flag fxVideoActive; decode is unchanged.
Texture2D<float4> lumaTexture : register(t0);    // Y
Texture2D<float4> crTexture : register(t1);      // Cr
Texture2D<float4> cbTexture : register(t2);      // Cb

SamplerState lumaSampler : register(s0);
SamplerState crSampler : register(s1);
SamplerState cbSampler : register(s2);

struct PSInput {
  float4 position : SV_Position;
  float4 color : TEXCOORD0;     // vertex color / tint
  float2 texcoord : TEXCOORD1;
};

float4 main(PSInput input) : SV_Target {
  float y = lumaTexture.Sample(lumaSampler, input.texcoord).r;
  float cr = crTexture.Sample(crSampler, input.texcoord).r;
  float cb = cbTexture.Sample(cbSampler, input.texcoord).r;

  // BT.601 limited-range YCbCr -> RGB, vanilla constants verbatim (NOT bt709). Kept hand-rolled over
  // renodx::color::bt601::YCbCrLimited: the helper drifts ~0.1-0.5% from these rounded constants, and
  // it wants (Y,Cb,Cr) while our planes are t0=Y, t1=Cr, t2=Cb (Cr before Cb) — easy silent swap.
  float3 rgb;
  rgb.r = 1.164124f * y + 1.595795f * cr - 0.870655f;
  rgb.g = 1.164124f * y - 0.813477f * cr - 0.391449f * cb + 0.529705f;
  rgb.b = 1.164124f * y + 2.017822f * cb - 1.081669f;

  float4 output;
  output.rgb = rgb * input.color.rgb;
  output.a = input.color.a;
  return output;
}
