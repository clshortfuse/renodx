#include "./common.hlsli"

// Genshin Impact HDR LUT builder (32x32x32, dispatched every frame, HDR mode only).
// Input coordinate: PQ-encoded scene where scene 1.0 = 100 nits (the uberpost
// encodes `scene * 0.01` before sampling this LUT).
// Output: PQ-encoded BT.2020 nits. The uberpost and AA passes stay vanilla and
// consume this LUT; the final composite (0xAE711F61) converts it to the RenoDX
// intermediate encoding for the swapchain proxy.
// Original bytecode decompiled with 3Dmigoto, cleaned up and annotated.

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float4 cb0[9];
}

// cb0[3].xy  1 / LUT size
// cb0[4].y   peak nits (game HDR setting)
// cb0[4].z   paper white nits (game HDR setting)
// cb0[4].w   color boost strength
// cb0[5].xy  exposure, exposure blend
// cb0[6..8]  color grading matrix columns

static const float3 VANILLA_LUMA_BT709 = float3(0.212500006f, 0.715399981f, 0.0720999986f);
static const float3 VANILLA_LUMA_AP1 = float3(0.272228718f, 0.674081743f, 0.0536895171f);

static const float3x3 BT709_TO_XYZ = float3x3(
    0.412456393f, 0.357576102f, 0.180437505f,
    0.212672904f, 0.715152204f, 0.0721750036f,
    0.0193339009f, 0.119191997f, 0.950304091f);
static const float3x3 D65_TO_D60 = float3x3(
    1.01303005f, 0.00610530982f, -0.0149710001f,
    0.00769822998f, 0.998165011f, -0.00503202993f,
    -0.00284131011f, 0.00468515977f, 0.924507022f);
static const float3x3 XYZ_TO_AP1 = float3x3(
    1.6410234f, -0.324803293f, -0.236424699f,
    -0.663662851f, 1.61533165f, 0.0167563483f,
    0.0117218941f, -0.00828444213f, 0.988394856f);
static const float3x3 COLOR_BOOST = float3x3(
    1.37041271f, -0.329291314f, -0.0636827648f,
    -0.0834341869f, 1.09709096f, -0.0108615728f,
    -0.0257932581f, -0.0986256376f, 1.20369434f);
static const float3x3 AP1_TO_XYZ = float3x3(
    0.662454188f, 0.134004205f, 0.156187683f,
    0.272228718f, 0.674081743f, 0.0536895171f,
    -0.00557464967f, 0.0040607336f, 1.01033914f);
static const float3x3 D60_TO_D65 = float3x3(
    0.987223983f, -0.00611326983f, 0.0159533005f,
    -0.00759836007f, 1.00186002f, 0.0053300201f,
    0.00307257008f, -0.00509594986f, 1.08168006f);
static const float3x3 XYZ_TO_BT2020 = float3x3(
    1.71660841f, -0.355662107f, -0.253360093f,
    -0.666682899f, 1.61647761f, 0.0157685f,
    0.0176422f, -0.0427763015f, 0.942228675f);

// Vanilla HDR mapping, returns PQ BT.2020.
float3 VanillaHDRToneMap(float3 untonemapped) {
  // Per-channel curve for chroma, untonemapped luminance restored on top
  float3 tonemapped = VanillaToneMap(untonemapped);
  float y_tonemapped = dot(tonemapped, VANILLA_LUMA_BT709);
  float y_untonemapped = dot(untonemapped, VANILLA_LUMA_BT709);
  float3 color = tonemapped * ((y_tonemapped < 1e-6f) ? 0.f : (y_untonemapped / y_tonemapped));

  float3 ap1 = mul(XYZ_TO_AP1, mul(D65_TO_D60, mul(BT709_TO_XYZ, color)));

  // Saturation boost weighted by luminance and chroma
  float y_ap1 = dot(ap1, VANILLA_LUMA_AP1);
  float3 chroma = ap1 / y_ap1 - 1.f;
  float boost = (1.f - exp2(-4.f * cb0[4].w * y_ap1 * y_ap1)) * (1.f - exp2(-4.f * dot(chroma, chroma)));
  color = lerp(ap1, mul(COLOR_BOOST, ap1), boost);

  // Paper white, then a max-channel shoulder from 50% of peak
  color = clamp(color * cb0[4].z, 0.f, 10000.f);
  float max_channel = max(color.r, max(color.g, color.b));
  float x = max_channel / cb0[4].y;
  float rolled;
  if (abs(x - 0.9f) <= 0.4f) {
    rolled = x - 0.6f * (x - 0.5f) * (x - 0.5f);
  } else if (x > 1.3f) {
    rolled = (x - 0.9f) * 0.04f + 0.9f;
  } else {
    rolled = x;
  }
  rolled = saturate(rolled) * cb0[4].y;
  color *= (max_channel == 0.f) ? 1.f : saturate(rolled / max_channel);

  float3 bt2020 = mul(XYZ_TO_BT2020, mul(D60_TO_D65, mul(AP1_TO_XYZ, color)));
  return renodx::color::pq::EncodeSafe(bt2020, 1.f);
}

[numthreads(4, 4, 4)]
void main(uint3 vThreadID : SV_DispatchThreadID) {
  // LUT texel -> PQ coordinate -> linear BT.709 scene (1.0 = 100 nits)
  float2 pq_xy = ((float2(vThreadID.xy) + 0.5f) * cb0[3].xy - 0.015625f) * 1.03225803f;
  float pq_z = float(vThreadID.z) * 0.0322580636f;
  float3 scene = renodx::color::pq::Decode(float3(pq_xy, pq_z), 100.f);

  // Vanilla color grading matrix and exposure
  float3 untonemapped = cb0[6].xyz * scene.x + cb0[7].xyz * scene.y + cb0[8].xyz * scene.z;
  untonemapped *= (cb0[5].y > 0.f) ? lerp(cb0[5].x, 1.f, cb0[5].y) : cb0[5].x;

  float3 output;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    output = VanillaHDRToneMap(untonemapped);
  } else {
    // Vanilla SDR look as the graded reference, then store the intermediate
    // result as PQ nits (1.0 intermediate = UI white nits) for the composite
    renodx::draw::Config config = renodx::draw::BuildConfig();
    float3 color = renodx::draw::ToneMapPass(untonemapped, VanillaToneMap(untonemapped), config);
    color = renodx::draw::RenderIntermediatePass(color, config);
    float3 nits = renodx::draw::DecodeColor(color, config.intermediate_encoding) * config.graphics_white_nits;
    output = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(nits), 1.f);
  }

  u0[vThreadID] = float4(output, 0.f);
}
