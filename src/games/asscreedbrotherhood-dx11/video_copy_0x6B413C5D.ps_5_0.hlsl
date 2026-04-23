Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

float2 GetVideoUV(float4 position, float4 texcoord) {
  uint width, height;
  t0.GetDimensions(width, height);

  float2 uv_from_position = saturate(position.xy / max(float2(width, height), 1.f));
  float2 uv_from_texcoord = texcoord.xy;
  bool texcoord_valid = all(uv_from_texcoord >= -0.001f) && all(uv_from_texcoord <= 1.001f) && any(abs(uv_from_texcoord) > 0.0001f);

  return texcoord_valid ? saturate(uv_from_texcoord) : uv_from_position;
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
  uint4 color_bits = asuint(color);
  color_bits = (color_bits & asuint(cb3[44])) | asuint(cb3[45]);
  o0 = asfloat(color_bits);
}
