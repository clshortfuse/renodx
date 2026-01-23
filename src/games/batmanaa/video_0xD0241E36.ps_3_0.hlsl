#include "./common.hlsli"

float4 consts : register(c3);
sampler2D tex0 : register(s0);
sampler2D tex1 : register(s1);
sampler2D tex2 : register(s2);
float4 tob : register(c2);
float4 tog : register(c1);
float4 tor : register(c0);

float4 main(float2 texcoord: TEXCOORD)
    : COLOR {
  float4 o;

  float4 r0;
  float4 r1;
  r0 = tex2D(tex0, texcoord);
  r1 = tex2D(tex1, texcoord);
  r0.y = r1.x;
  r1 = tex2D(tex2, texcoord);
  r0.z = r1.x;
  r0.w = consts.x;
  r1.x = dot(tor, r0);
  r1.x = log2(r1.x);
  r1.w = dot(tog, r0);
  r0.x = dot(tob, r0);
  r1.z = log2(r0.x);
  r1.y = log2(r1.w);
  r0.xyz = r1.xyz * consts.z;
  o.x = exp2(r0.x);
  o.y = exp2(r0.y);
  o.z = exp2(r0.z);
  o.w = consts.w;

  o = max(0, o);
  o.rgb = renodx::color::gamma::Decode(o.rgb);
  o.rgb *= RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
  o.rgb = renodx::color::gamma::Encode(o.rgb);

  return o;
}
