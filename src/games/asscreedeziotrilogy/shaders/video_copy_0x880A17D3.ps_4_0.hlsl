Texture2D<float4> t0 : register(t0);

void main(
    float4 v0 : SV_POSITION0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_TARGET0) {
  int2 texel = int2(v1.xy);
  float4 color = t0.Load(int3(texel, 0));

  o0 = color;
}
