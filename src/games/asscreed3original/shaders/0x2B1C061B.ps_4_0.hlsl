// ---- Created with 3Dmigoto v1.3.16 on Wed May 13 19:42:18 2026

cbuffer _Globals : register(b0)
{
  float4 g_FogColor : packoffset(c16);
  float4 g_FogParams : packoffset(c17);
  float4 g_FogWeatherParams : packoffset(c90);
  float4 g_FogSunBackColor : packoffset(c31);
  float Alpha_1 : packoffset(c128);
  float NearFallofMin_2 : packoffset(c129);
  float NearFallofMax_3 : packoffset(c130);
  float IsScreenshot_4 : packoffset(c131);

  struct
  {
    float4 m_PositionFar;
    float4 m_ColorFade;
  } g_OmniLights[4] : packoffset(c32);


  struct
  {
    float3 m_Direction;
    float4 m_Color;
  } g_DirectLights[2] : packoffset(c40);


  struct
  {
    float4 m_PositionFar;
    float4 m_ColorFade;
    float3 m_Direction;
    float4 m_ConeAngles;
  } g_SpotLights[2] : packoffset(c44);


  struct
  {
    float3 m_Direction;
    float4 m_Color;
    float3 m_SpecularDirection;
  } g_ShadowedDirect : packoffset(c52);

  float4 g_ProjWorldToLight[8] : packoffset(c55);
  float4 g_ProjShadowParams[2] : packoffset(c119);
  float g_HasSunDX11 : packoffset(c251);
  float4 g_SunDirection : packoffset(c21);
  float4 g_TileOffset : packoffset(c96);
  float4 g_UnusedPredicated1 : packoffset(c97);
  float4 g_UnusedPredicated2 : packoffset(c98);
  float4 g_UnusedPredicated3 : packoffset(c99);
  float4 g_VPosToUV : packoffset(c0);
  float4 g_ReverseProjectionParams : packoffset(c100);
  float2 g_ReverseProjectionParams2 : packoffset(c101);
  float4x4 g_ViewToWorld : packoffset(c102);
  float4x4 g_WorldToView : packoffset(c106);
  float g_AlphaTestValue : packoffset(c113);
  float4 g_EyePosition : packoffset(c12);
  float4 g_AmbientCube[6] : packoffset(c24);

  struct
  {
    float2 m_VPOS;
    float2 m_ScreenPosition;
    float3 m_WorldNormal;
    float3 m_VertexWorldNormal;
    float3 m_TangentSpaceNormal;
    float3 m_WorldPosition;
    float3 m_WorldEyeVector;
    float3 m_NormalizedWorldEyeVector;
    float4 m_UnitLightSpacePos;
    float3 m_LightSpaceNormal;
    float4 m_Albedo;
    float m_alpha;
    float m_WeatherExposed;
    float m_DistanceAttenuation;
    float4 m_LightColor;
    float3 m_IncidentLightAngle;
    float3 m_SpecularIncidentLightAngle;
    float m_SpecularInfluence;
    float m_Alpha;
    float m_SpecularPower;
    float4 m_EmissiveColor;
    float3 m_ShadowResult;
  } c : packoffset(c252);

  bool g_HasSunOther : packoffset(c268.w);
}

SamplerState Operator725_0_s : register(s0);
SamplerState g_RefractionSampler_s : register(s12);
Texture2D<float4> Operator725_0 : register(t0);
Texture2D<float4> g_RefractionSampler : register(t12);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  float4 v7 : TEXCOORD5,
  uint v8 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v3.w < 0);
  if (r0.x != 0) discard;
  r0.xy = v0.xy * g_VPosToUV.xy + float2(-1,-0.569999993);
  r0.zw = float2(1.25,1.25) * v2.xy;
  r0.xy = r0.xy * float2(0.600000024,0.600000024) + r0.zw;
  r0.zw = trunc(abs(r0.xy));
  r0.xy = abs(r0.xy) + -r0.zw;
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  r0.xy = r0.xy + r0.xy;
  r0.zw = cmp(r0.xy >= -r0.xy);
  r0.xy = frac(abs(r0.xy));
  r0.xy = r0.zw ? r0.xy : -r0.xy;
  r0.xy = abs(r0.xy);
  r1.xyzw = Operator725_0.Sample(Operator725_0_s, r0.xy).xyzw;
  r0.xyzw = g_RefractionSampler.Sample(g_RefractionSampler_s, r0.xy).xyzw;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = saturate(IsScreenshot_4 * r1.xyz + r0.xyz);
  r1.xyz = g_EyePosition.xyz + -v3.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r0.w);
  r0.w = sqrt(r0.w);
  r1.xyz = r1.xyz * r1.www;
  r1.x = dot(g_SunDirection.xyz, r1.xyz);
  r1.x = 1 + r1.x;
  r1.x = -r1.x * 0.5 + 1;
  r1.x = r1.x * r1.x;
  r1.yzw = -g_FogSunBackColor.xyz + g_FogColor.xyz;
  r1.xyz = r1.xxx * r1.yzw + g_FogSunBackColor.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r1.w = -g_FogParams.x + r0.w;
  r0.w = -20 + r0.w;
  r0.w = saturate(0.0700000003 * r0.w);
  r0.w = 1 + -r0.w;
  r0.w = -r0.w * r0.w + 1;
  r0.w = g_FogWeatherParams.x * r0.w;
  r2.x = g_FogParams.y + -g_FogParams.x;
  r1.w = saturate(r1.w / r2.x);
  r1.w = 1 + -r1.w;
  r1.w = r1.w * r1.w;
  r1.w = -r1.w * r1.w + 1;
  r2.x = -g_FogParams.z + v3.z;
  r2.y = -g_FogParams.z + g_EyePosition.z;
  r2.x = min(r2.x, r2.y);
  r2.x = saturate(-r2.x * g_FogParams.w + 1);
  r0.w = saturate(r1.w * r2.x + r0.w);
  o0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.x = 1 + -r0.w;
  r0.y = dot(v6.xyz, v6.xyz);
  r0.y = rsqrt(r0.y);
  r0.yzw = v6.xyz * r0.yyy;
  r1.xyz = v3.xyz;
  r1.w = 0;
  r1.xyzw = -g_EyePosition.xyzw + r1.xyzw;
  r1.w = dot(r1.xyzw, r1.xyzw);
  r2.x = rsqrt(r1.w);
  r1.w = sqrt(r1.w);
  r1.w = -NearFallofMin_2 + r1.w;
  r1.xyz = r2.xxx * r1.xyz;
  r0.y = dot(r0.yzw, r1.xyz);
  r0.y = abs(r0.y) * abs(r0.y);
  r0.y = min(1, r0.y);
  r0.y = v2.w * r0.y;
  r0.z = NearFallofMax_3 + -NearFallofMin_2;
  r0.z = saturate(r1.w / r0.z);
  r0.y = r0.z * r0.y;
  r0.y = Alpha_1 * r0.y;
  r0.x = r0.y * r0.x;
  o0.w = r0.x;

  // clamp
  o0.w = saturate(o0.w);

  o1.w = r0.x;
  o1.xyz = v1.zzz / v1.www;

  // clamp
  o1.w = saturate(o1.w);
  return;
}