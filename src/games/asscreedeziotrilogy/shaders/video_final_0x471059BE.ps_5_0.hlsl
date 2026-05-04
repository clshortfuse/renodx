cbuffer cb0 : register(b0) {
  float4 cb0[12];
}

Texture2DArray<uint4> t0 : register(t0);

void main(
    float4 v0 : SV_POSITION0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_TARGET0) {
  uint width, height, layers;
  t0.GetDimensions(width, height, layers);

  float2 max_pixel = min(cb0[6].zw, float2(width - 1u, height - 1u));
  float2 pixel = clamp(v1.xy, 0.f, max_pixel);
  int2 texel = int2(pixel);
  int slice = int(cb0[6].x);

  uint packed = t0.Load(int4(texel, slice, 0)).x;
  uint4 rgba = uint4(
      (packed >> 16) & 0xffu,
      (packed >> 8) & 0xffu,
      packed & 0xffu,
      (packed >> 24) & 0xffu);

  float4 decoded = float4(rgba) / 255.f;

  o0 = decoded;
}
