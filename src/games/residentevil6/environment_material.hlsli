#include "./color_grade.hlsli"

#ifndef RE6_ENV_MASKED_LIGHTMAP
#define RE6_ENV_MASKED_LIGHTMAP 0
#endif
#ifndef RE6_ENV_LIGHTMAP
#define RE6_ENV_LIGHTMAP RE6_ENV_MASKED_LIGHTMAP
#endif
#ifndef RE6_ENV_REORDERED
#define RE6_ENV_REORDERED 0
#endif
#ifndef RE6_ENV_NORMAL_UV_ZW
#define RE6_ENV_NORMAL_UV_ZW 0
#endif
#ifndef RE6_ENV_TRANSPARENCY
#define RE6_ENV_TRANSPARENCY 0
#endif
#ifndef RE6_ENV_INVERSE_TRANSPARENCY
#define RE6_ENV_INVERSE_TRANSPARENCY 0
#endif

float4 CBHDRFactor__packed0 : register(c1);
float4 CBScreen__packed1 : register(c2);
#if RE6_ENV_TRANSPARENCY
float4 CBROPTest__packed0 : register(c3);
float fGlobalTransparency : register(c4);
float4 CBViewProjection__packed4 : register(c5);
#if RE6_ENV_REORDERED
float4 CBMaterial__packed0 : register(c6);
float4 CBMaterial__packed1 : register(c7);
float3 fLightMaskSelector : register(c8);
float4 CBAmbient__packed0 : register(c9);
float4 CBAmbient__packed1 : register(c10);
float3 fAlbedoColor : register(c11);
float3 fLightMapColor : register(c12);
float4 Globals__packed8 : register(c13);
float4 Globals__packed9 : register(c14);
#else
float3 fLightMaskSelector : register(c6);
float4 CBAmbient__packed0 : register(c7);
float4 CBAmbient__packed1 : register(c8);
float3 fAlbedoColor : register(c9);
float3 fLightMapColor : register(c10);
float4 Globals__packed8 : register(c11);
float4 Globals__packed9 : register(c12);
float4 CBMaterial__packed0 : register(c13);
float4 CBMaterial__packed1 : register(c14);
#endif
float4 CBFog__packed0 : register(c15);
float4 CBFog__packed1 : register(c16);
float4 CBFog__packed2 : register(c17);
float4 CBFog__packed4 : register(c18);
sampler2D light_mask : register(s0);
sampler2D light_accumulation : register(s1);
sampler2D normal_map : register(s2);
sampler2D albedo_map : register(s3);
sampler2D transparency_map : register(s4);
sampler2D light_map : register(s5);
samplerCUBE environment_map : register(s6);
sampler2D specular_map : register(s7);
#else
float fGlobalTransparency : register(c3);
float4 CBViewProjection__packed4 : register(c4);
#if RE6_ENV_MASKED_LIGHTMAP
#if RE6_ENV_REORDERED
float4 CBMaterial__packed0 : register(c5);
float4 CBMaterial__packed1 : register(c6);
float3 fLightMaskSelector : register(c7);
float4 CBAmbient__packed0 : register(c8);
float4 CBAmbient__packed1 : register(c9);
float3 fAlbedoColor : register(c10);
float3 fLightMapColor : register(c11);
float4 Globals__packed8 : register(c12);
float4 Globals__packed9 : register(c13);
#else
float3 fLightMaskSelector : register(c5);
float4 CBAmbient__packed0 : register(c6);
float4 CBAmbient__packed1 : register(c7);
float3 fAlbedoColor : register(c8);
float3 fLightMapColor : register(c9);
float4 Globals__packed8 : register(c10);
float4 Globals__packed9 : register(c11);
float4 CBMaterial__packed0 : register(c12);
float4 CBMaterial__packed1 : register(c13);
#endif
float4 CBFog__packed0 : register(c14);
float4 CBFog__packed1 : register(c15);
float4 CBFog__packed2 : register(c16);
float4 CBFog__packed4 : register(c17);
sampler2D light_mask : register(s0);
sampler2D light_accumulation : register(s1);
sampler2D normal_map : register(s2);
sampler2D albedo_map : register(s3);
sampler2D light_map : register(s4);
samplerCUBE environment_map : register(s5);
sampler2D specular_map : register(s6);
#elif RE6_ENV_LIGHTMAP
float4 CBMaterial__packed0 : register(c5);
float4 CBMaterial__packed1 : register(c6);
float3 fAlbedoColor : register(c7);
float3 fLightMapColor : register(c8);
float4 Globals__packed8 : register(c9);
float4 Globals__packed9 : register(c10);
float4 CBAmbient__packed1 : register(c11);
float4 CBFog__packed0 : register(c12);
float4 CBFog__packed1 : register(c13);
float4 CBFog__packed2 : register(c14);
float4 CBFog__packed4 : register(c15);
sampler2D normal_map : register(s0);
sampler2D albedo_map : register(s1);
sampler2D light_accumulation : register(s2);
sampler2D light_map : register(s3);
samplerCUBE environment_map : register(s4);
sampler2D specular_map : register(s5);
#else
float3 fAlbedoColor : register(c5);
float4 Globals__packed8 : register(c6);
float4 Globals__packed9 : register(c7);
float4 CBAmbient__packed1 : register(c8);
float4 CBMaterial__packed0 : register(c9);
float4 CBMaterial__packed1 : register(c10);
float4 CBFog__packed0 : register(c11);
float4 CBFog__packed1 : register(c12);
float4 CBFog__packed2 : register(c13);
float4 CBFog__packed4 : register(c14);
sampler2D normal_map : register(s0);
sampler2D albedo_map : register(s1);
sampler2D light_accumulation : register(s2);
samplerCUBE environment_map : register(s3);
sampler2D specular_map : register(s4);
#endif
#endif

struct EnvironmentMaterialInput {
  float4 color : COLOR0;
  float4 texcoord0 : TEXCOORD0;
  float4 texcoord1 : TEXCOORD1;
  float4 texcoord2 : TEXCOORD2;
  float4 texcoord3 : TEXCOORD3;
  float4 texcoord4 : TEXCOORD4;
  float4 texcoord5 : TEXCOORD5;
#if RE6_ENV_TRANSPARENCY
  float4 texcoord6 : TEXCOORD6;
#endif
  float2 screen_position : VPOS;
  float face_direction : VFACE;
};

float4 main(EnvironmentMaterialInput input) : COLOR0 {
#if RE6_ENV_LIGHTMAP && !RE6_ENV_TRANSPARENCY
  float3 geometry_normal = input.texcoord0.xyz;
  float intensity = input.texcoord0.w;
  float3 world_position = input.texcoord1.xyz;
  float3 tangent = input.texcoord2.xyz;
  float3 bitangent = input.texcoord3.xyz;
  float2 uv = input.texcoord4.xy;
#else
  float3 geometry_normal = input.texcoord1.xyz;
  float intensity = input.texcoord1.w;
  float3 world_position = input.texcoord2.xyz;
  float3 tangent = input.texcoord3.xyz;
  float3 bitangent = input.texcoord4.xyz;
  float2 uv = input.texcoord5.xy;
#endif
  float4 albedo = tex2D(albedo_map, uv);
#if RE6_ENV_TRANSPARENCY
  float transparency = tex2D(transparency_map, input.texcoord6.zw).g;
#if RE6_ENV_INVERSE_TRANSPARENCY
  transparency = rcp(max(1.f - transparency, 1.e-6f));
#endif
  float material_alpha = albedo.a * input.texcoord0.w * transparency * CBMaterial__packed0.w;
  // Match the original ROP test: equality is discarded too.
  if (material_alpha <= CBROPTest__packed0.x) discard;
  float alpha = saturate(material_alpha * fGlobalTransparency);
#else
  float alpha = fGlobalTransparency;
#endif
  geometry_normal *= input.face_direction >= 0.f ? -1.f : 1.f;
  geometry_normal /= max(length(geometry_normal), 1.e-6f);
  tangent /= max(length(tangent), 1.e-6f);
  bitangent /= max(length(bitangent), 1.e-6f);
#if RE6_ENV_NORMAL_UV_ZW
  float2 normal_xy = (tex2D(normal_map, input.texcoord4.zw).wy - 0.498039216f) * 2.f;
#else
  float2 normal_xy = (tex2D(normal_map, uv).wy - 0.498039216f) * 2.f;
#endif
  float normal_z_squared = 1.f - dot(normal_xy, normal_xy);
  float normal_z = normal_z_squared <= 0.0001f ? 0.01f : sqrt(max(normal_z_squared, 0.f));
  float3 normal = normalize(geometry_normal * normal_z + tangent * normal_xy.x + bitangent * normal_xy.y);
  float3 view_direction = normalize(world_position - CBViewProjection__packed4.xyz);
  float4 environment_sample = texCUBE(environment_map, reflect(view_direction, normal));
  float3 environment = environment_sample.rgb / environment_sample.a * CBMaterial__packed1.rgb;
  float2 screen_uv = (input.screen_position + 0.5f) * CBScreen__packed1.zw;
  float4 point_light = tex2D(light_accumulation, screen_uv);

#if RE6_ENV_MASKED_LIGHTMAP
  float4 masks = max(tex2D(light_mask, screen_uv).zwxy, CBAmbient__packed1.yzyz) * fLightMaskSelector.xyxy;
  float2 selected_mask = fLightMaskSelector.z <= 0.f ? masks.xy : masks.zw;
  float mask_strength = max(selected_mask.x, selected_mask.y);
  environment *= 1.f - CBAmbient__packed1.x * mask_strength;
#endif
#if RE6_ENV_LIGHTMAP
#if RE6_ENV_TRANSPARENCY
  float4 packed_light_map = tex2D(light_map, input.texcoord6.xy);
#else
  float4 packed_light_map = tex2D(light_map, input.texcoord5.xy);
#endif
  float3 decoded_light_map = packed_light_map.rgb / packed_light_map.a;
  float3 diffuse = decoded_light_map * fLightMapColor;
#if RE6_ENV_MASKED_LIGHTMAP
  diffuse += mask_strength * CBAmbient__packed0.w * (CBAmbient__packed0.rgb - diffuse);
#endif
  float specular_intensity = dot(decoded_light_map, 0.333333343f.xxx) * intensity;
#else
  float3 diffuse = input.texcoord0.xyz;
  float specular_intensity = dot(input.texcoord0.xyz, 0.333333343f.xxx) * intensity;
#endif
  diffuse = (diffuse + point_light.rgb) * CBMaterial__packed0.rgb * intensity;
  float point_luminance = dot(point_light.rgb, float3(0.298911989f, 0.586610019f, 0.114478f));
  float3 specular = point_light.rgb * (point_light.a / max(CBAmbient__packed1.w, point_luminance));
  specular = (specular * Globals__packed9.rgb + environment) * tex2D(specular_map, uv).g * specular_intensity;
  float fresnel = 1.f - dot(normal, -view_direction);
  float fresnel_squared = fresnel * fresnel;
  float fresnel_fifth = fresnel_squared * fresnel_squared * fresnel;
  specular *= fresnel_fifth + (1.f - fresnel_fifth) * Globals__packed8.x;
  // Match the existing ice fix: bound the completed specular term, leaving
  // diffuse lighting and the HDR scene/tonemap path independent of this cap.
  specular = min(specular, 1.f);
  float3 lit_color = albedo.rgb * fAlbedoColor * diffuse + specular;

  float fog0 = saturate((input.color.y - CBFog__packed1.z) * CBFog__packed1.w) * CBFog__packed0.w;
  float fog1 = saturate((world_position.y - CBFog__packed1.x) * CBFog__packed1.y) * CBFog__packed2.w;
  float remaining = (1.f - fog0 * CBFog__packed4.y) * (1.f - fog1 * CBFog__packed4.z);
  float3 fog_color = lerp(fog0 * CBFog__packed4.y * CBFog__packed0.rgb,
      CBFog__packed2.rgb, fog1 * CBFog__packed4.z);
  float3 attenuation = min(diffuse * (CBFog__packed4.w * CBFog__packed4.x) + remaining, 1.f);
  return float4(EncodeGameSRGB((lit_color * attenuation + fog_color) * CBHDRFactor__packed0.x), alpha);
}
