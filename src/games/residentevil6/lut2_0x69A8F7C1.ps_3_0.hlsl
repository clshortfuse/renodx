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

float4 main(float2 texcoord : TEXCOORD0, float2 noise_uv : TEXCOORD1) : COLOR0 {
  bool hdr = UseSceneHDR();
  float3 color = SampleGameGradeInput(texcoord, noise_uv, hdr);
  float3 graded = ApplyGameColorGrade(color, fColorCorrectMatrix, SSPoint__tColorCorrectTableMap, fColorCorrectColor.w, hdr);
  float3 encoded = EncodeGameSRGB(graded);
  return float4(hdr ? max(encoded, 0.f) : saturate(encoded), 1.f);
}
