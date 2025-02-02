
SamplerState g_diffuse_sampler_sampler_s : register(s0);
Texture2D<float4> g_diffuse_sampler_texture : register(t0);

void main(
    float4 v0: SV_Position0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    float w2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = saturate(w2.x);
  r1.xyzw = g_diffuse_sampler_texture.Sample(g_diffuse_sampler_sampler_s, v2.xy).xyzw;
  r0.y = dot(r1.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r2.xyz = r1.xyz + -r0.yyy;
  r1.xyz = r0.xxx * r2.xyz + r0.yyy;
  o0.xyzw = v1.xyzw * r1.xyzw;
  return;
}
