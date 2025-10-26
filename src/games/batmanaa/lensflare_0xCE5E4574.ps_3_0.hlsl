#include "./common.hlsli"

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
  r0.x = min(r1.x, 0.6);
  r0.y = i.texcoord.x * 1.5 + -0.24;
  r0.z = i.texcoord.y * 1.25 + -0.125;
  r1 = tex2D(Texture2D_1, r0.yzzw);
  r0.y = r1.x * 0.6;
  r0.x = r0.x * 0.2 + r0.y;
  r0.x = r0.x * i.texcoord1.w;
  r1.xy = float2(0.4, 0.5);
  r0.y = i.texcoord1.x * r1.x + UniformVector_0.x;
  r0.z = i.texcoord1.y * r1.y + UniformVector_0.y;
  r0.w = i.texcoord1.z * r1.y + UniformVector_0.z;
  r0.yzw = r0.yzw * i.texcoord4.w;
  o.xyz = r0.x * r0.yzw;
  o.w = 0;

  if (CUSTOM_LENS_FLARE_TYPE != 0.f) {
    float y_in = renodx::color::y::from::BT709(o.rgb);
    float y_out = renodx::color::grade::Highlights(y_in, 3.f, 0.18f, 3.f);
    float3 boosted = renodx::color::correct::Luminance(o.rgb, y_in, y_out);
    o.rgb = lerp(o.rgb, boosted, saturate(y_in));
  }

  return o;
}
