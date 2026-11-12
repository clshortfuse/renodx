#include "./color_grade.hlsli"

sampler2D SSFilter__tBaseMap             : register(s0);
sampler2D SSWrapPoint__tTVNoiseMap       : register(s1);
sampler2D SSWrapPoint__tTVNoiseMaskMap   : register(s2);
sampler2D SSLinear__tFilterTempMap2      : register(s3);
sampler2D SSPoint__tColorCorrectTableMap : register(s4);

row_major float4x4 fColorCorrectMatrix : register(c1);

float4 fTVNoisePower    : register(c5);
float4 fTVNoiseUVOffset : register(c6);
float4 fTVNoiseScanline : register(c7);
float4 fTVNoiseHVSync   : register(c8);

float4 CBBloomFilter__packed0 : register(c9);
float4 fColorCorrectColor     : register(c10);


float3 RGBToYCbCr_WithNoise(
    float3 rgb,
    float3 noise
)
{
    float y =
        dot(
            rgb,
            float3(0.299f, 0.587f, 0.114f)
        );

    float cb =
        dot(
            rgb.zxy,
            float3(0.5f, -0.169f, -0.331f)
        );

    float cr =
        dot(
            rgb,
            float3(0.5f, -0.419f, -0.081f)
        );

    y  += fTVNoisePower.x * noise.z;
    cb += fTVNoisePower.y * noise.x;
    cr += fTVNoisePower.y * noise.y;

    return float3(
        y,
        cb,
        cr
    );
}


float3 YCbCrToRGB(float3 ycbcr)
{
    float y  = ycbcr.x;
    float cb = ycbcr.y;
    float cr = ycbcr.z;

    float r =
        y + 1.402f * cr;

    float g =
        y
        - 0.344f * cb
        - 0.714f * cr;

    float b =
        y + 1.772f * cb;

    return float3(
        r,
        g,
        b
    );
}


float3 SampleGameGradeInput(float2 texcoord, float2 noise_uv, bool hdr) {
  float4 noise_coords = noise_uv.xyxy * fTVNoisePower.zwzw + fTVNoiseUVOffset.xyxy;
  float4 noise_a = tex2D(SSWrapPoint__tTVNoiseMap, noise_coords.xy);
  float4 noise_b = tex2D(SSWrapPoint__tTVNoiseMap, noise_coords.zw);
  float3 noise = (float3(noise_b.yz, noise_a.x) - 0.5f) * (1.f + fTVNoiseHVSync.z);

  float3 base = tex2D(SSFilter__tBaseMap, texcoord).rgb;
  float3 color = DecodeGameSRGB(hdr ? base : saturate(base));
  color = YCbCrToRGB(RGBToYCbCr_WithNoise(color, noise));
  float scanline = tex2D(SSWrapPoint__tTVNoiseMaskMap, noise_uv * fTVNoiseScanline.z).x;
  color *= 1.f - (1.f - scanline) * fTVNoiseScanline.y;

  float3 bloom = tex2D(SSLinear__tFilterTempMap2, texcoord).rgb;
  return color + DecodeGameSRGB(hdr ? bloom : saturate(bloom)) * CBBloomFilter__packed0.rgb;
}

float3 ApplyGameLut2HDR(float3 color) {
  float strength = fColorCorrectColor.w * saturate(RENODX_COLOR_GRADE_STRENGTH);
  if (strength <= 0.f) return color;

  float3 address = max(mul(float4(color, 1.f), fColorCorrectMatrix).rgb, 0.f);
  float address_y = renodx::color::y::from::BT709(address);
  float lookup_y = renodx::tonemap::ExponentialRollOff(address_y, 0.38f, 0.87f);
  float lookup_scale = renodx::math::DivideSafe(lookup_y, address_y, 1.f);
  float3 lookup = address * lookup_scale;
  float3 graded_sdr = SampleGameLutLinear(SSPoint__tColorCorrectTableMap, lookup);

  // Fit saturated colors into the usable table range. Account for this
  // temporary exposure change in the same neutral reference as the luma rolloff.
  float lookup_peak = renodx::math::Max(lookup);
  [branch]
  if (lookup_peak > 0.94f || any(graded_sdr > 0.98f)) {
    float limit = 0.96f * GameLutWhiteCoordinate(SSPoint__tColorCorrectTableMap);
    if (lookup_peak > limit) {
      lookup_scale *= limit / lookup_peak;
      lookup = address * lookup_scale;
      graded_sdr = SampleGameLutLinear(SSPoint__tColorCorrectTableMap, lookup);
    }
  }

  float3 graded = graded_sdr;
  [branch]
  if (lookup_scale < 1.f) {
    // The RE6 LUT includes a tone curve. Sample the same curve on a neutral
    // input at the fitted luminance to retain its scene-dependent exposure.
    float3 neutral_sdr = SampleGameLutLinear(SSPoint__tColorCorrectTableMap, (address_y * lookup_scale).xxx);
    float neutral_y = renodx::color::y::from::BT709(neutral_sdr);
    float3 scene = max(color, 0.f);
    float scene_y = renodx::color::y::from::BT709(scene);
    float removed_y = scene_y * (1.f - lookup_scale);
    float reference_gain = clamp(renodx::math::DivideSafe(neutral_y, scene_y * lookup_scale, 1.f), 1.f, 2.f);

    // Retain the reference gain near the shoulder and ease it back into
    // genuine highlights above scene white.
    const float recovery_range = 0.07f;
    float shoulder = recovery_range * (1.f - exp(-removed_y / recovery_range));
    float over_white = max(scene_y - 1.f, 0.f);
    float recovered_y = removed_y + (reference_gain - 1.f) * (shoulder + over_white * (over_white / (1.f + over_white)));
    float3 hdr_reference = scene * renodx::math::DivideSafe(neutral_y + recovered_y, scene_y, 0.f);
    renodx::draw::Config config = renodx::draw::BuildConfig();
    config.color_grade_strength = 1.f;
    graded = renodx::draw::ComputeUntonemappedGraded(hdr_reference, graded_sdr, neutral_sdr, config);
  }

  return lerp(color, ApplyGameMidtoneSeparation(graded), strength);
}

float4 main(float2 texcoord : TEXCOORD0, float2 noise_uv : TEXCOORD1) : COLOR0 {
  bool hdr = UseSceneHDR();
  float3 color = SampleGameGradeInput(texcoord, noise_uv, hdr);
  float3 graded = hdr ? ApplyGameLut2HDR(color)
      : ApplyGameColorGrade(color, fColorCorrectMatrix, SSPoint__tColorCorrectTableMap, fColorCorrectColor.w, false);
  float3 encoded = EncodeGameSRGB(graded);
  return float4(hdr ? max(encoded, 0.f) : saturate(encoded), 1.f);
}
