#include "./color_grade.hlsli"

float4 fSHCoef[7] : register(c1);
row_major float3x3 fView : register(c8);
float4 CBHDRFactor__packed0 : register(c11);
float4 CBScreen__packed1 : register(c12);
float fGlobalTransparency : register(c13);
float4 CBViewProjection__packed4 : register(c14);
float4 CBMaterial__packed0 : register(c15);
float4 CBAmbient__packed1 : register(c16);
float3 fAlbedoColor : register(c17);
float4 fAlbedoBlendColor : register(c18);
float4 Globals__packed2 : register(c19);
float4 Globals__packed8 : register(c20);
float4 Globals__packed9 : register(c21);
float4 CBFog__packed0 : register(c22);
float4 CBFog__packed1 : register(c23);
float4 CBFog__packed2 : register(c24);
float4 CBFog__packed4 : register(c25);

sampler2D light_accumulation : register(s0);
sampler2D normal_map : register(s1);
sampler2D detail_normal_map : register(s2);
sampler2D albedo_map : register(s3);
sampler2D albedo_blend_map : register(s4);
sampler2D specular_map : register(s5);

struct MaterialInput {
  float4 color : COLOR0;
  float4 normal_intensity : TEXCOORD0;
  float3 world_position : TEXCOORD1;
  float3 tangent : TEXCOORD2;
  float3 bitangent : TEXCOORD3;
  float4 uv : TEXCOORD4;
  float2 screen_position : VPOS;
  float face_direction : VFACE;
};

float4 main(MaterialInput input) : COLOR0 {
  float3 geometry_normal = input.normal_intensity.xyz * (input.face_direction >= 0.f ? -1.f : 1.f);
  geometry_normal /= max(length(geometry_normal), 1.e-6f);
  float3 tangent = input.tangent / max(length(input.tangent), 1.e-6f);
  float3 bitangent = input.bitangent / max(length(input.bitangent), 1.e-6f);
  float2 detail = (tex2D(detail_normal_map, input.uv.zw * Globals__packed2.y).wy - 0.498039216f)
                  * (2.f * Globals__packed2.x);
  float2 normal_xy = (tex2D(normal_map, input.uv.xy).wy - 0.498039216f) * 2.f + detail;
  float3 normal = geometry_normal * sqrt(max(1.f - dot(normal_xy, normal_xy), 0.f))
                  + tangent * normal_xy.x + bitangent * normal_xy.y;
  normal /= max(length(normal), 1.e-6f);

  float3 view_normal = mul(normal, fView);
  view_normal /= max(length(view_normal), 1.e-6f);
  float4 blend = tex2D(albedo_blend_map, float2(view_normal.x, -view_normal.y) * 0.5f + 0.5f);
  float3 albedo = tex2D(albedo_map, input.uv.xy).rgb * fAlbedoColor
                  * (1.f + blend.a * fAlbedoBlendColor.w * (blend.rgb * fAlbedoBlendColor.rgb - 1.f));

  float4 normal_basis = float4(normal, 1.f);
  float4 quadratic_basis = normal.yzzx * normal.xyzz;
  float3 ambient = float3(dot(fSHCoef[0], normal_basis), dot(fSHCoef[1], normal_basis), dot(fSHCoef[2], normal_basis))
                   + float3(dot(fSHCoef[3], quadratic_basis), dot(fSHCoef[4], quadratic_basis), dot(fSHCoef[5], quadratic_basis))
                   + fSHCoef[6].rgb * (normal.x * normal.x - normal.y * normal.y);
  float4 light = tex2D(light_accumulation, (input.screen_position + 0.5f) * CBScreen__packed1.zw);
  // Invalid accumulation texels cannot contribute lighting or enter metering.
  light = all(isfinite(light)) ? max(light, 0.f) : 0.f;
  float3 diffuse = (ambient + light.rgb) * CBMaterial__packed0.rgb * input.normal_intensity.w;
  float denominator = max(max(CBAmbient__packed1.w, dot(light.rgb, float3(0.298911989f, 0.586610019f, 0.114478f))), 1.e-6f);
  // Divide the RGB first: this avoids overflowing alpha / denominator before
  // multiplication by a correspondingly tiny light color.
  float3 specular = (light.rgb / denominator) * light.a * Globals__packed9.rgb
                    * tex2D(specular_map, input.uv.xy).g * input.normal_intensity.w;
  float3 view_direction = input.world_position - CBViewProjection__packed4.xyz;
  view_direction /= max(length(view_direction), 1.e-6f);
  float fresnel = saturate(1.f - dot(normal, -view_direction));
  float fresnel_squared = fresnel * fresnel;
  specular *= lerp(Globals__packed8.x, 1.f, fresnel_squared * fresnel_squared * fresnel);
  // Match the existing ice materials: constrain the completed legacy specular
  // term before it enters the upgraded scene target. Diffuse and fog retain HDR.
  specular = min(max(specular, 0.f), 1.f);
  float3 lit_color = albedo * diffuse + specular;

  float fog0 = saturate((input.color.y - CBFog__packed1.z) * CBFog__packed1.w) * CBFog__packed0.w;
  float fog1 = saturate((input.world_position.y - CBFog__packed1.x) * CBFog__packed1.y) * CBFog__packed2.w;
  float3 attenuation = min(diffuse * (CBFog__packed4.w * CBFog__packed4.x)
                              + (1.f - fog0 * CBFog__packed4.y) * (1.f - fog1 * CBFog__packed4.z),
                          1.f);
  float3 fog_color = lerp(fog0 * CBFog__packed4.y * CBFog__packed0.rgb, CBFog__packed2.rgb, fog1 * CBFog__packed4.z);
  float3 encoded = EncodeGameSRGB(max((lit_color * attenuation + fog_color) * CBHDRFactor__packed0.x, 0.f));
  // Keep valid HDR output; only reject nonfinite values and FP16 overflow.
  encoded = float3(isfinite(encoded.r) ? min(encoded.r, 65504.f) : 0.f,
                   isfinite(encoded.g) ? min(encoded.g, 65504.f) : 0.f,
                   isfinite(encoded.b) ? min(encoded.b, 65504.f) : 0.f);
  return float4(encoded, saturate(fGlobalTransparency));
}
