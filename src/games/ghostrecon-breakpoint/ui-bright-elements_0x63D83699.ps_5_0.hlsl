// ---- Created with 3Dmigoto v1.4.1 on Tue Dec  9 16:53:14 2025

cbuffer cb_g_Frame : register(b1)
{

  struct
  {
    float4 m_CurrentTime;
    float4 m_TimeOfDayHour;
    float4 m_GlobalWind;
    float4 m_MainCameraPosition;

    struct
    {
      float4 m_ShadowMapSize;
      float4 m_Offsets[4];
      float4 m_Scales[4];
      float4 m_SplitBlendMulAddUVAndZ[4];
      float4 m_NoiseScale;
      float4 m_NearFar;
      float4 m_FadeParams;
      float4 m_CascadesRangesMax;
      float4 m_CascadesRangesMin;
      float4 m_GlobalFadeParams;
      float4 m_ShadowSplitBlendUVAmount;
      float4x4 m_WorldToLightProjContinuous;
      float4x4 m_WorldToLightProjQuantized;
      float4x4 m_DebugShadowVisiblePixelMat;
      float m_FadeOutThresholdElevation;
      uint m_padding1;
      uint m_padding2;
      uint m_padding3;
    } m_SunShadows;


    struct
    {
      float m_WorldInvSize;
      float m_SunMapInvSize;
      float m_EdgeFadeOutStartDistance;
      float m_EdgeFadeOutInvRange;
    } m_LongRangeShadows;


    struct
    {
      float4 m_Direction;
      float4 m_Color;
    } m_SunLight;


    struct
    {
      float4 IndoorVolumeScale;
      float4 IndoorVolumeCenter;
      float4 OutdoorVolumeScale;
      float4 OutdoorVolumeCenter;
      float2 FarGIScale;
      float2 FarGIOffset;
      float CameraIndoorFactor;
      float CameraUndergroundFactor;
      float CameraIndoorOrUndergroundFactor;
      uint IsolationVar;
    } m_GIDynConsts;

    float4 m_CubeMapParams;

    struct
    {
      float4 boxMax;
      float4 boxMin;
      float4 innerBlendBoxMax;
      float4 blendBoxMax;
      float4 worldPosition;
      float4x4 worldToLocal;
      uint cubeMapArrayIndex;
      bool isAffectedByTimeOfDay;
      uint padding1;
      uint padding2;
    } m_LocalCubeMaps;


    struct
    {
      float4 VolumeInvTransZ;
      float4 VolumeTexScale;
      float4 VolumeTexBias;
      float4 SunColor;
      float4 SunColorByOneOverPi;
      float4 TemporalJitter;
      float4 AmbientColor;
    } m_VolumetricFog;


    struct
    {
      float4 CoordMod;
      bool SpringPhysicsEnabled;
      float3 __padding;
    } m_GrassFlattening;


    struct
    {
      float2 detailedWavesAttenuationFactors;
      float oceanShadowToClassificationBufferRatio;
      float oceanDiffuseToClassificationBufferRatio;
    } m_WaterParams;


    struct
    {
      bool Enabled;
      float ScreenFadeStart;
      float ScreenFadeRange;
      float DepthFadeStart;
      float DepthFadeRange;
      float FadeWeightMax;
    } m_SuperVision;


    struct
    {
      float2 m_AverageWindSpeed1;
      float2 m_AverageWindSpeed1NoExposition;
      float2 m_WindDirection1;
      float2 m_WindSpeedMinMax1;
      float2 m_WindScroll1;
      float m_WindTile1;
      float m_WindDummy1;
      float2 m_AverageWindSpeed2;
      float2 m_AverageWindSpeed2NoExposition;
      float2 m_WindDirection2;
      float2 m_WindSpeedMinMax2;
      float2 m_WindScroll2;
      float m_WindTile2;
      float m_WindDummy2;
      float2 m_WindDummy5;
      float m_WindBurstIntensity;
      float m_WindBurstMaxIntensity;
      float2 m_ImposterWindDir;
      float m_ImposterWindFactor;
      float m_WindDummy4;
      float4 LocalCoordMod;
      float2 m_GrassPhaseLow;
      float2 m_GrassPhaseHi;
      float2 m_GrassAmplFactor;
      float2 m_GrassAmplOffset;
    } m_WorldWind;

    float4 m_WorldMapFogExtents;
    float4 m_WorldMapFogTextureSize;
    uint m_WorldMapFogVisibilityFlags;
    uint m_NightVision;
    uint m_ThermalVision;
    uint m_ForcedPCF4;
    float4 m_UILighting[6];
    float2 m_FrameAAJitter;
    float2 pad0;
    float4 m_DynamicResolutionRatio;
    float4 m_DynamicResolutionUVMax;
    float m_PreviousTime;
    uint m_WhiteHotThermal;
    float2 m_Padding;

    struct
    {
      float2 m_AverageWindSpeed1;
      float2 m_AverageWindSpeed1NoExposition;
      float2 m_WindDirection1;
      float2 m_WindSpeedMinMax1;
      float2 m_WindScroll1;
      float m_WindTile1;
      float m_WindDummy1;
      float2 m_AverageWindSpeed2;
      float2 m_AverageWindSpeed2NoExposition;
      float2 m_WindDirection2;
      float2 m_WindSpeedMinMax2;
      float2 m_WindScroll2;
      float m_WindTile2;
      float m_WindDummy2;
      float2 m_WindDummy5;
      float m_WindBurstIntensity;
      float m_WindBurstMaxIntensity;
      float2 m_ImposterWindDir;
      float m_ImposterWindFactor;
      float m_WindDummy4;
      float4 LocalCoordMod;
      float2 m_GrassPhaseLow;
      float2 m_GrassPhaseHi;
      float2 m_GrassAmplFactor;
      float2 m_GrassAmplOffset;
    } m_WorldWindPrevFrame;


    struct
    {

      struct
      {
        float4 m_TranslucencyParam1[8];
        float4 m_TranslucencyParam2[8];
        float4 m_TranslucencyParam3[8];
        float4 m_TransluFadeSettings;
        float m_EnableTranslucency;
        uint m_padding0;
        uint m_padding1;
        uint m_padding2;
      } m_TranslucencyParams;


      struct
      {
        bool Precompute;
        float RoughnessThreshold;
        float ConfidenceThreshold;
        float Intensity;
      } m_SSLRMaskParams;

      bool m_SSAOIsValid;
      bool m_UsingSSS;
      bool m_UsingSSLR;
      uint m_padding0;
    } m_SilexFrameConsts;


    struct
    {
      uint m_UseGamma22;
      float m_MaxDisplayLuminance;
      float m_PeakBrightness;
      float m_PaperWhite;
    } m_HdrParams;

  } g_Frame : packoffset(c0);

}

cbuffer cb_g_Phoenix_ConstantBuffer : register(b5)
{

  struct
  {
    float4x4 World;
    float4x4 ViewProj;
    float2 TextureWeights;
    float AlphaTestThreshold;
    uint bUseHDR;
  } g_Phoenix_ConstantBuffer : packoffset(c0);

}

cbuffer cb_g_Phoenix_SoftMaskConstantBuffer : register(b8)
{

  struct
  {
    uint SoftMaskCount;
  } g_Phoenix_SoftMaskConstantBuffer : packoffset(c0);

}

cbuffer cb_g_Phoenix_SoftMaskConstantBufferParams : register(b9)
{

  struct
  {
    float4 SoftMaskParams0[8];
    float4 SoftMaskParams1[8];
    float4 SoftMaskParams2[8];
    float4 SoftMaskParams3[8];
  } g_Phoenix_SoftMaskConstantBufferParams : packoffset(c0);

}

SamplerState s_TrilinearClamp_s : register(s12);
Texture2D<float4> t_shaderTexture : register(t0);
Texture2D<float4> t_softMaskTexture0 : register(t3);
Texture2D<float4> t_softMaskTexture1 : register(t4);
Texture2D<float4> t_softMaskTexture2 : register(t5);
Texture2D<float4> t_softMaskTexture3 : register(t6);
Texture2D<float4> t_softMaskTexture4 : register(t7);
Texture2D<float4> t_softMaskTexture5 : register(t8);
Texture2D<float4> t_softMaskTexture6 : register(t9);
Texture2D<float4> t_softMaskTexture7 : register(t10);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : NORMAL0,
  float4 v2 : COLOR0,
  float2 v3 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  // Sample base texture and apply texture weight
  r0.xyzw = t_shaderTexture.Sample(s_TrilinearClamp_s, v3.xy).xyzw;
  r0.xyzw = g_Phoenix_ConstantBuffer.TextureWeights.xxxy * r0.xyzw;
  // Modulate by vertex color (note swizzle: v2.wxyz)
  r0.xyzw = v2.wxyz * r0.wxyz;
  // Optional soft-mask accumulation
  if (g_Phoenix_SoftMaskConstantBuffer.SoftMaskCount != 0) {
    r1.xy = v0.xy;
    r1.z = 1;
    r2.z = 1;
    r1.w = 1;
    r2.w = 0;
    while (true) {
      r3.x = cmp((uint)r2.w >= (uint)g_Phoenix_SoftMaskConstantBuffer.SoftMaskCount);
      if (r3.x != 0) break;
      // Project position into soft-mask UVs
      r2.x = dot(g_Phoenix_SoftMaskConstantBufferParams.SoftMaskParams0[r2.w].xyz, r1.xyz);
      r2.y = dot(g_Phoenix_SoftMaskConstantBufferParams.SoftMaskParams1[r2.w].xyz, r1.xyz);
      // Discard if outside [0,1]
      r3.xy = cmp(r2.xy < float2(0,0));
      r3.zw = cmp(float2(1,1) < r2.xy);
      r3.x = (int)r3.z | (int)r3.x;
      r3.x = (int)r3.y | (int)r3.x;
      r3.x = (int)r3.w | (int)r3.x;
      if (r3.x != 0) discard;
      // Build mask UV and sample appropriate mask texture (by index)
      r3.x = dot(g_Phoenix_SoftMaskConstantBufferParams.SoftMaskParams2[r2.w].xyz, r2.xyz);
      r2.x = dot(g_Phoenix_SoftMaskConstantBufferParams.SoftMaskParams3[r2.w].xyz, r2.xyz);
      r3.y = 1 + -r2.x;
      if (r2.w == 0) {
        r2.x = t_softMaskTexture0.Sample(s_TrilinearClamp_s, r3.xy).w;
      } else {
        r2.y = cmp((int)r2.w == 1);
        if (r2.y != 0) {
          r2.x = t_softMaskTexture1.Sample(s_TrilinearClamp_s, r3.xy).w;
        } else {
          r2.y = cmp((int)r2.w == 2);
          if (r2.y != 0) {
            r2.x = t_softMaskTexture2.Sample(s_TrilinearClamp_s, r3.xy).w;
          } else {
            r2.y = cmp((int)r2.w == 3);
            if (r2.y != 0) {
              r2.x = t_softMaskTexture3.Sample(s_TrilinearClamp_s, r3.xy).w;
            } else {
              r2.y = cmp((int)r2.w == 4);
              if (r2.y != 0) {
                r2.x = t_softMaskTexture4.Sample(s_TrilinearClamp_s, r3.xy).w;
              } else {
                r2.y = cmp((int)r2.w == 5);
                if (r2.y != 0) {
                  r2.x = t_softMaskTexture5.Sample(s_TrilinearClamp_s, r3.xy).w;
                } else {
                  r2.y = cmp((int)r2.w == 6);
                  if (r2.y != 0) {
                    r2.x = t_softMaskTexture6.Sample(s_TrilinearClamp_s, r3.xy).w;
                  } else {
                    r2.x = t_softMaskTexture7.Sample(s_TrilinearClamp_s, r3.xy).w;
                  }
                }
              }
            }
          }
        }
      }
      // Normalize and smoothstep mask, accumulate multiplicatively
      r2.y = g_Phoenix_SoftMaskConstantBufferParams.SoftMaskParams1[r2.w].w + -g_Phoenix_SoftMaskConstantBufferParams.SoftMaskParams0[r2.w].w;
      r2.x = -g_Phoenix_SoftMaskConstantBufferParams.SoftMaskParams0[r2.w].w + r2.x;
      r2.y = 1 / r2.y;
      r2.x = saturate(r2.x * r2.y);
      r2.y = r2.x * -2 + 3;
      r2.x = r2.x * r2.x;
      r2.x = r2.y * r2.x;
      r1.w = r2.x * r1.w;
      r2.w = (int)r2.w + 1;
    }
    // Apply combined soft mask to base color (r0.x holds weighted alpha channel)
    r0.x = r1.w * r0.x;
  }
  // Optional HDR encode
  if (g_Phoenix_ConstantBuffer.bUseHDR != 0) {
    // Gamma expand from sRGB-ish (pow 2.2)
    r1.xyz = max(float3(0,0,0), r0.yzw);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(2.20000005,2.20000005,2.20000005) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    // Choose PQ-like or gamma 2.2 output based on m_UseGamma22
    if (g_Frame.m_HdrParams.m_UseGamma22 == 0) {
      // Convert to display space with PQ-ish curve scaled by paper white
      r2.x = dot(float3(0.627402008,0.329291999,0.0433060005), r1.xyz);
      r2.y = dot(float3(0.0690950006,0.919543982,0.0113599999), r1.xyz);
      r2.z = dot(float3(0.0163940005,0.0880279988,0.895578027), r1.xyz);
      r2.xyz = g_Frame.m_HdrParams.m_PaperWhite * r2.xyz;
      r2.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r2.xyz;
      r2.xyz = log2(abs(r2.xyz));
      r2.xyz = float3(0.159301758,0.159301758,0.159301758) * r2.xyz;
      r2.xyz = exp2(r2.xyz);
      r3.xyz = r2.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
      r2.xyz = r2.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
      r2.xyz = r3.xyz / r2.xyz;
      r2.xyz = log2(r2.xyz);
      r2.xyz = float3(78.84375,78.84375,78.84375) * r2.xyz;
      r0.yzw = exp2(r2.xyz);
    } else {
      // Simple gamma 2.2 encode scaled by paper white / max display
      r1.w = g_Frame.m_HdrParams.m_PaperWhite / g_Frame.m_HdrParams.m_MaxDisplayLuminance;
      r1.xyz = r1.xyz * r1.www;
      r1.xyz = max(float3(0,0,0), r1.xyz);
      r1.xyz = log2(r1.xyz);
      r1.xyz = float3(0.454545468,0.454545468,0.454545468) * r1.xyz;
      r0.yzw = exp2(r1.xyz);
    }
  }
  // Output: rgb = color * weighted alpha channel; alpha cleared to 0
  o0.xyz = r0.yzw * r0.xxx;
  o0.w = 0;
  return;
}