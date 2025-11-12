#include "../common.hlsli"

sampler2D Texture2D_0 : register(s0);
sampler2D Texture2D_1 : register(s1);
float4 UniformVector_0 : register(c0);

struct PS_IN {
  float2 texcoord : TEXCOORD;
  float4 texcoord1 : TEXCOORD1;
  float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i)
    : COLOR {
  float4 o;

  float4 r0;
  float4 r1;
  r0 = tex2D(Texture2D_0, i.texcoord);
  r1.x = max(r0.x, 0);
  r0.x = r1.x + -0.6;
  r0.y = r1.x * 0.2;
  r0.x = (r0.x >= 0) ? 0.120000005 : r0.y;
  r0.yz = i.texcoord.x * 1.5 + float2(1.5, -0.24);
  r1 = tex2D(Texture2D_1, r0.yzzw);
  r0.x = r1.x * 0.6 + r0.x;
  r0.x = r0.x * i.texcoord1.w;
  r1.xy = float2(0.4, 0.5);
  r0.yzw = i.texcoord1.xxy * r1.xxy + UniformVector_0.xxy;
  r0.yzw = r0.xyz * i.texcoord4.w;
  o.xyz = r0.x * r0.yzw;
  o.w = 0;

  o.rgb = ApplyCustomLensFlare(o.rgb);

  return o;
}
