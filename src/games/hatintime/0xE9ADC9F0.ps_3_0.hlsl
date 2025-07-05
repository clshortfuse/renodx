#include "./shared.h"

float4 BloomTintAndScreenBlendThreshold : register(c0);
float4 ImageAdjustments2 : register(c8);
float4 ImageAdjustments3 : register(c9);
float4 HalfResMaskRect : register(c10);
sampler SceneColorTexture : register(s0);
sampler FilterColor1Texture : register(s1);
sampler ColorGradingLUT : register(s2);
sampler LowResPostProcessBuffer : register(s3);

struct PS_IN {
  float4 texcoord : TEXCOORD;
  float4 texcoord1 : TEXCOORD1;
};

float3 Sample(sampler s, float3 color, float size) {
  color = saturate(color);

  const float max_index = size - 1.f;
  const float slice = 1.f / size;
  const float texel_size = slice * slice;

  float z_position = color.z * max_index;
  float z_integer = floor(z_position);
  float z_fraction = z_position - z_integer;

  const float x_offset = (color.r * max_index * texel_size) + (texel_size * 0.5f);
  const float y_offset = (color.g * max_index * slice) + (slice * 0.5f);
  const float z_offset = z_integer * slice;

  float2 uv = float2(z_offset + x_offset, y_offset);

  float3 color0 = tex2D(s, uv).rgb;
  uv.x += slice;
  float3 color1 = tex2D(s, uv).rgb;

  return lerp(color0, color1, z_fraction);
}

half4 main(PS_IN i) : COLOR {
  float4 o;

  half4 oh;

  float4 r0;
  float4 r1;
  float4 r2;
  float4 r3;

  half4 r0h;
  half4 r1h;
  half4 r2h;
  half4 r3h;

  float4 c1 = float4(1, 0, 4, 65503);
  float4 c2 = float4(0.300000012, 0.589999974, 0.109999999, -3);
  float4 c3 = float4(10000, 0.454545468, 15, 0.0625);
  float4 c4 = float4(14.9998999, 0.05859375, 0.9375, 0);
  float4 c5 = float4(0.001953125, 0.03125, 0.064453125, 0);
  float4 c6 = float4(0.298999995, 0.587000012, 0.114, 0);

  r0 = float4(1, 1, 0, 0) * i.texcoord1.xyxx;                           // mul r0, c1.xxyy, v1.xyxx
  r0h = tex2Dlod(SceneColorTexture, r0);                                // texldl_pp r0, r0, s0
  r1.xy = max(i.texcoord1.zw, HalfResMaskRect.xy);                      // max r1.xy, v1.zwzw, c10
  r2.xy = min(HalfResMaskRect.zw, r1.xy);                               // min r2.xy, c10.zwzw, r1
  r1h = tex2D(LowResPostProcessBuffer, r2.xyxx);                        // texld_pp r1, r2, s3
  r0.xyz = -(r1h.xyz * 4.0) + r0h.xyz;                                  // mad r0.xyz, r1, -c1.z, r0
  r1.xyz = r1h.xyz * 4.0;                                               // mul r1.xyz, r1, c1.z
  r0h.xyz = mad(r1h.www, r0.xyz, r1.xyz);                               // mad_pp r0.xyz, r1.w, r0, r1
  r1h.xyz = min(r0h.xyz, 65503.0h);                                     // min_pp r1.xyz, r0, c1.w
  r0h.x = dot(r1h.xyz, float3(0.300000012, 0.589999974, 0.109999999));  // dp3_pp r0.x, r1, c2
  r0h.x = r0h.x * -3;                                                   // mul_pp r0.x, r0.x, c2.w
  r0h.x = exp2(r0h.x);                                                  // exp_pp r0.x, r0.x
  r0h.x = saturate(r0h.x * BloomTintAndScreenBlendThreshold.w);         // mul_sat_pp r0.x, r0.x, c0.w
  r2 = tex2D(FilterColor1Texture, i.texcoord.zw);                       // texld r2, v0.zwzw, s1
  r0.yzw = (r2.xxyz * BloomTintAndScreenBlendThreshold.xxyz).yzw;       // mul r0.yzw, r2.xxyz, c0.xxyz
  r0h.yzw = r0.yzw * 4;                                                 // mul_pp r0.yzw, r0, c1.z
  r0h.xyz = (r0h.yzw * r0h.x + r1h.xyz);                                // mad_pp r0.xyz, r0.yzww, r0.x, r1
  r1h.xyz = r0h.xyz + ImageAdjustments2.xxx;                            // add_pp r1.xyz, r0, c8.x
  r2.z = rcp(abs(r1h.x));                                               // rcp r2.z, r1_abs.x
  r2.w = rcp(abs(r1h.y));                                               // rcp r2.w, r1_abs.y
  r2.xy = rcp(abs(r1h.zz));                                             // rcp r2.xy, r1_abs.z
  r1h = r0h.zzxy * r2;                                                  // mul_pp r1, r0.zzxy, r2
  r2.xyz = r0h.xyz * ImageAdjustments2.www;                             // mul_pp r2.xyz, r0, c8.w
  r0h = r0h.zzxy + -ImageAdjustments2.z;                                // add_pp r0, r0.zzxy, -c8.z
  r0h = saturate(r0h * 10000);                                          // mul_sat_pp r0, r0, c3.x
  r3.x = log2(r2.x);                                                    // log r3.x, r2.x
  r3.y = log2(r2.y);                                                    // log r3.y, r2.y
  r3.z = log2(r2.z);                                                    // log r3.z, r2.z
  r2.xyz = r3.xyz * 0.454545468;                                        // mul r2.xyz, r3, c3.y
  r3h.z = exp2(r2.x);                                                   // exp_pp r3.z, r2.x
  r3h.w = exp2(r2.y);                                                   // exp_pp r3.w, r2.y
  r3h.xy = exp2(r2.zz);                                                 // exp_pp r3.xy, r2.z
  r2h = r1h.yyzw * ImageAdjustments2.y + -r3h.yyzw;                     // mad_pp r2, r1.yyzw, c8.y, -r3.yyzw
  r0h = r0h * r2h + r3h;                                                // mad_pp r0, r0, r2, r3
  r1 = r1h * ImageAdjustments2.y + -r0h.yyzw;                           // mad r1, r1, c8.y, -r0.yyzw

  float3 untonemapped_gamma = max(0, ImageAdjustments3.x * r1 + r0h).zwx;
  float3 untonemapped = renodx::color::gamma::Decode(untonemapped_gamma, 2.2f);
  float3 tonemapped = renodx::tonemap::renodrt::NeutralSDR(untonemapped);
  float3 tonemapped_gamma = renodx::color::gamma::Encode(tonemapped, 2.2f);
  float3 lutted = Sample(ColorGradingLUT, tonemapped_gamma, 16.f);

  r0h = saturate(ImageAdjustments3.x * r1 + r0h);                            // mad_sat_pp r0, c9.x, r1, r0
  r1.xyw = (r0h.xwzz * float4(14.9998999, 0.9375, 0.9375, 0.05859375)).xyw;  // mul r1.xyw, r0.xwzz, c4.xzzy
  r0.x = frac(r1.x);                                                         // frc r0.x, r1.x
  r0.x = -r0.x + r1.x;                                                       // add r0.x, -r0.x, r1.x
  r1.x = mad(r0.x, 0.0625, r1.w);                                            // mad r1.x, r0.x, c3.w, r1.w
  r0.x = mad(r0h.y, 15, -r0.x);                                              // mad r0.x, r0.y, c3.z, -r0.x
  r1 = r1.xyxy + float4(0.001953125, 0.03125, 0.064453125, 0.03125);         // add r1, r1.xyxy, c5.xyzy
  r2h = tex2D(ColorGradingLUT, r1.xy);                                       // texld_pp r2, r1, s2
  r1h = tex2D(ColorGradingLUT, r1.zw);                                       // texld_pp r1, r1.zwzw, s2
  r3h.xyz = lerp(r2h.xyz, r1h.xyz, r0.xxxx).xyz;                             // lrp_pp r3.xyz, r0.x, r1, r2
  oh.w = dot(r3h.xyz, float3(0.298999995, 0.587000012, 0.114));              // dp3_pp oC0.w, r3, c6
  oh.xyz = r3h.xyz;                                                          // mov_pp oC0.xyz, r3

  float3 lutted_linear = renodx::color::gamma::DecodeSafe(lutted, 2.2f);
  oh.rgb = renodx::draw::ToneMapPass(untonemapped, lutted_linear);
  oh.a = renodx::color::y::from::BT709(oh.rgb);
  oh.rgb = renodx::draw::RenderIntermediatePass(oh.rgb);

  return oh;
}
