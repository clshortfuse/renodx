Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

float3 DecodeVideoSample(float4 raw_sample) {
  uint3 color_bits = asuint(raw_sample.rgb);
  color_bits = (color_bits & asuint(cb3[44].rgb)) | asuint(cb3[45].rgb);

  float3 decoded = asfloat(color_bits);
  float3 raw_rgb = raw_sample.rgb;

  bool decoded_looks_broken =
      ((dot(decoded, 1.f) < 1e-5f) && (dot(raw_rgb, 1.f) > 1e-3f)) ||
      any(decoded < 0.f.xxx);

  return decoded_looks_broken ? raw_rgb : decoded;
}

float2 GetVideoUV(float4 position, float4 texcoord) {
  float2 uv_from_texcoord = texcoord.xy;
  bool texcoord_is_normalized =
      all(uv_from_texcoord >= -0.001f) &&
      all(uv_from_texcoord <= 1.001f);
  if (texcoord_is_normalized) {
    return saturate(uv_from_texcoord);
  }

  bool texcoord_is_fullscreen =
      all(uv_from_texcoord >= -0.001f) &&
      all(uv_from_texcoord <= 2.001f);
  if (texcoord_is_fullscreen) {
    return saturate(uv_from_texcoord * 0.5f);
  }

  uint width, height;
  t0.GetDimensions(width, height);
  return saturate(position.xy / max(float2(width, height), 1.f));
}

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    float4 v2 : COLOR0,
    float4 v3 : COLOR1,
    float4 v4 : TEXCOORD9,
    float4 v5 : TEXCOORD0,
    float4 v6 : TEXCOORD1,
    float4 v7 : TEXCOORD2,
    float4 v8 : TEXCOORD3,
    float4 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    out float4 o0 : SV_TARGET0) {
  float4 color = t0.Sample(s0_s, GetVideoUV(v0, v5));
  float3 graded = DecodeVideoSample(color);
  graded = (graded - cb4[11].rgb) * cb4[10].x + cb4[11].rgb;

  o0.rgb = graded;
  o0.a = 1.f;
}
