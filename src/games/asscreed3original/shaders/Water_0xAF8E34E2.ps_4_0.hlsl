// ---- Created with 3Dmigoto v1.3.16 on Thu May 14 01:42:47 2026

cbuffer _Globals : register(b0)
{
  float4 g_FogColor : packoffset(c16);
  float4 g_FogParams : packoffset(c17);
  float4 g_FogWeatherParams : packoffset(c90);
  float4 g_FogSunBackColor : packoffset(c31);
  float3x3 UVLayer0NEW_1_matrix : packoffset(c128);
  float4 g_LayeredSkyUserColor3 : packoffset(c3);
  float g_AlphaTestValue : packoffset(c113);
  float4 g_TileOffset : packoffset(c96);
  float4 g_UnusedPredicated1 : packoffset(c97);
  float4 g_UnusedPredicated2 : packoffset(c98);
  float4 g_UnusedPredicated3 : packoffset(c99);
  float4 g_VPosToUV : packoffset(c0);
  float4 g_ReverseProjectionParams : packoffset(c100);
  float2 g_ReverseProjectionParams2 : packoffset(c101);
  float4x4 g_ViewToWorld : packoffset(c102);
  float4x4 g_WorldToView : packoffset(c106);
  float4 g_EyePosition : packoffset(c12);

  struct
  {
    float3 m_Albedo;
    float2 m_VPOS;
    float2 m_ScreenPosition;
    float3 m_WorldPosition;
    float m_Alpha;
    float3 m_WorldNormal;
    float3 m_VertexWorldNormal;
    float3 m_TangentSpaceNormal;
    float m_SpecIntensity;
    float m_SpecGlossiness;
    float3 m_Emissive;
    float m_WeatherExposed;
    float m_LinearDepth;
  } c : packoffset(c131);

}

SamplerState WavesMap_0_s : register(s0);
SamplerState Layer0Reflection_0_s : register(s1);
SamplerState g_DepthSampler_s : register(s8);
Texture2D<float4> WavesMap_0 : register(t0);
TextureCube<float4> Layer0Reflection_0 : register(t1);
Texture2D<float4> g_DepthSampler : register(t8);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : COLOR0,
  float4 v4 : COLOR1,
  float4 v5 : TEXCOORD2,
  float4 v6 : TEXCOORD3,
  float4 v7 : TEXCOORD4,
  float4 v8 : TEXCOORD5,
  uint v9 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2,
  out float4 o3 : SV_Target3)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v2.xy;
  r0.z = 1;
  r1.x = dot(r0.xyz, UVLayer0NEW_1_matrix._m00_m10_m20);
  r1.y = dot(r0.xyz, UVLayer0NEW_1_matrix._m01_m11_m21);
  r0.xyzw = WavesMap_0.Sample(WavesMap_0_s, r1.xy).xyzw;
  r1.xy = r0.xy * float2(0.0399999991,0.0399999991) + v2.xy;
  r2.xz = float2(0,0);
  r2.yw = v2.zw;
  r1.xyzw = r2.xyzw + r1.xyxy;
  r2.xyzw = WavesMap_0.Sample(WavesMap_0_s, r1.zw).xyzw;
  r1.xyzw = WavesMap_0.Sample(WavesMap_0_s, r1.xy).xyzw;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r1.xyzw = v4.zzzz * r2.xyzw + r1.xyzw;
  r2.xy = g_VPosToUV.xy * v0.xy;
  r2.xyzw = g_DepthSampler.Sample(g_DepthSampler_s, r2.xy).xyzw;
  r0.w = -v1.w + r2.x;
  r0.w = saturate(0.5 * r0.w);
  r0.w = 1 + -r0.w;
  r2.x = r0.w * r0.w + v4.y;
  r1.w = saturate(r2.x * r1.w);
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = float3(-1,-1,-2) + r0.xyz;
  r0.xyz = v4.xxx * r0.xyz + float3(0,0,0.5);
  r0.xyz = r0.xyz + r0.xyz;
  o0.xyz = v3.xyz + r1.www;
  r0.w = -r0.w * r0.w + r1.w;
  r0.w = 1.10000002 + r0.w;
  o3.w = v3.w * r0.w;
  // clamp
  o3.w = saturate(o3.w);
  o0.w = 0;
  // clamp
  o0.w = saturate(o0.w);
  r0.w = dot(v7.xyz, v7.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v7.xyz * r0.www;
  r1.xyz = r1.xyz * r0.yyy;
  r0.y = dot(v6.xyz, v6.xyz);
  r0.y = rsqrt(r0.y);
  r2.xyz = v6.xyz * r0.yyy;
  r0.xyw = r0.xxx * r2.xyz + r1.xyz;
  r1.x = dot(v8.xyz, v8.xyz);
  r1.x = rsqrt(r1.x);
  r1.xyz = v8.xyz * r1.xxx;
  r0.xyz = r0.zzz * r1.xyz + r0.xyw;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  o1.xyz = saturate(r0.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5));
  o1.w = 0.0240000002;
  // clamp
  o1.w = saturate(o1.w);
  r1.xyz = -g_EyePosition.xzy + v5.xzy;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = r1.xyz * r0.www;
  r0.w = dot(r1.xzy, r0.xyz);
  r0.w = r0.w + r0.w;
  r1.xyz = r0.xzy * -r0.www + r1.xyz;
  r1.xyzw = Layer0Reflection_0.Sample(Layer0Reflection_0_s, r1.xyz).xyzw;
  r1.xyz = g_LayeredSkyUserColor3.xyz * r1.xyz;
  r2.xyz = v5.xyz;
  r2.w = 0;
  r2.xyzw = g_EyePosition.xyzw + -r2.xyzw;
  r0.w = dot(r2.xyzw, r2.xyzw);
  r0.w = rsqrt(r0.w);
  r2.xyz = r2.xyz * r0.www;
  r0.x = dot(r0.xyz, r2.xyz);
  r0.x = 1 + -r0.x;
  r0.x = r0.x * r0.x + 0.100000001;
  r0.x = min(1, r0.x);
  r0.xyz = r1.xyz * r0.xxx;
  r0.w = 1 + -v4.w;
  o2.xyz = r0.xyz * r0.www;
  o2.w = 0.899999976;

  // clamp
  o2.w = saturate(o2.w);

  o3.xyz = v1.zzz / v1.www;
  return;
}