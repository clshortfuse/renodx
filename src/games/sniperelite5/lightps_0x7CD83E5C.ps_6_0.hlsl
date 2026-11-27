#include "./shared.h"
// Baseline: 4 fewer fmul fast (dxc reassociation of the specular chains t905/t979), 1 fewer identical row-40 cbuffer load (CSE), phi order/undef-vs-0 only; otherwise identical to the original DXIL.

struct ProjectorParams {
  float4 m_xProjectorMatrix[4];
  float4 m_xWorldToBoundingSpace[4];
  float4 m_xProjectionDirection;
  float4 m_xDetailOffsetScale;
  float4 m_xCausticOffsets;
  float3 m_xProjectorPos;
  float m_fPad;
  float4 m_xOrientation1;
  float4 m_xOrientation2;
  float4 m_xOrientation3;
  float4 m_xPosition_UVAspect;
  float4 m_xOffsets;
  float3 m_xLightColour;
  float m_fDistanceFade;
  float m_fLightFalloffScale;
  float m_fLightFalloffPower;
  float m_fAngularFalloffOfs;
  float m_fAngularFalloffScale;
  float m_fMinRange;
  float m_fLightRange;
  float m_fShadowStrength;
  int m_bCustomBoundingVolumeSet;
  float m_f2DFilterSize;
  float m_fCubeFilterSize;
  float m_fCubeClampWidth;
  int m_iShadowTextureIndex;
  float m_fShadowSoftness;
  float m_fShadowNearPlane;
  float m_fShadowFarPlane;
  float m_fProjectorOneOverTanHalfFov;
  float m_fShadowBias;
  float m_fSpecularStrength;
  float m_fAreaLightRadius;
  uint m_uShadowPoolLevel;
  int m_iTextureIndex;
  int m_iDetailTextureIndex;
  int m_iCausticTextureIndex;
  int m_bIsProjector;
};

Texture2D<float4> g_xTextureArray[] : register(t0, space1);
Texture2D<float4> g_xLighting_NormalBuffer : register(t2);
Texture2D<float4> g_xLighting_AlbedoBuffer : register(t3);
Texture2D<float4> g_xLighting_PBRPropertiesBuffer : register(t4);
Texture2D<float4> g_xLighting_DepthStencil : register(t5);
StructuredBuffer<ProjectorParams> g_axProjectors : register(t42);

cbuffer FrameConstants : register(b0) {
  float4 g_xView[4] : packoffset(c000.x);
  float4 g_xProj[4] : packoffset(c004.x);
  float4 g_xViewProj[4] : packoffset(c008.x);
  float4 g_xInvView[4] : packoffset(c012.x);
  float4 g_xInvProj[4] : packoffset(c016.x);
  float4 g_xInvViewProj[4] : packoffset(c020.x);
  float3 g_xCamPos : packoffset(c024.x);
  float g_fScaledTime : packoffset(c024.w);
  float4 g_xTwoOverScreenDimensions : packoffset(c025.x);
  float2 g_xCameraTanHalfFOV : packoffset(c026.x);
  float2 g_xCameraFarClipValues : packoffset(c026.z);
  float2 g_xRcpScreenDims : packoffset(c027.x);
  float2 g_xDepthProjViewUnpack : packoffset(c027.z);
  float4 g_axViewFrustumPlanes[6] : packoffset(c028.x);
  int4 g_xScreenDimensions : packoffset(c034.x);
  float4 g_xTessCutoffAndFactors : packoffset(c035.x);
  float g_fTessMaxDist : packoffset(c036.x);
  float g_fTessRcpRange : packoffset(c036.y);
  float g_fDisplacementScale : packoffset(c036.z);
  float g_fBackFaceCutoff : packoffset(c036.w);
  float g_fFoliageFadeInvDistance : packoffset(c037.x);
  float g_fFoliageFadePower : packoffset(c037.y);
  int g_bFoliageFadeEnabled : packoffset(c037.z);
  float g_fEnvironmentDecalBias : packoffset(c037.w);
  float g_fInstanceDecalBias : packoffset(c038.x);
  float3 g_xWindDirection : packoffset(c038.y);
  float g_fWindStrength : packoffset(c039.x);
  float3 g_xSubsurfaceScatteringWeight : packoffset(c039.y);
  float g_fGlobalSamplerBias : packoffset(c040.x);
  float3 g_xDeformationWindowCentre : packoffset(c040.y);
  float g_fDeformationWindowSize : packoffset(c041.x);
  float g_fDeformationUVDensity : packoffset(c041.y);
  float g_fDeformationNormalIntensity : packoffset(c041.z);
  float g_fRainfallIntensity : packoffset(c041.w);
  float g_fRainBaseWetness : packoffset(c042.x);
  float3 g_xRainDirection : packoffset(c042.y);
};

cbuffer ProjectorIndex : register(b4) {
  uint g_uProjectorIndex : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);
SamplerState g_xTrilinearWrap : register(s4);
SamplerState g_xTrilinearClamp : register(s5);
SamplerComparisonState g_xShadowCmpSampler : register(s8);

void main(
    noperspective float4 pos : SV_Position,
    float3 camdir : CamDir,
    out float4 outColor : SV_Target) {
  float2 dpu = g_xDepthProjViewUnpack;
  float2 tanFov = g_xCameraTanHalfFOV;
  float4 two = g_xTwoOverScreenDimensions;
  int t17 = (int)pos.x;
  int t18 = (int)pos.y;
  float4 t19 = g_xLighting_DepthStencil.Load(int3(t17, t18, 0));
  float t25 = dpu.x / (dpu.y - t19.x);
  float t42 = (tanFov.x * t25) * (((two.z + pos.x) * two.x) + -1.f);
  float t43 = (tanFov.y * t25) * (((two.w + pos.y) * two.y) + -1.f);

  ProjectorParams P = g_axProjectors[g_uProjectorIndex];

  float4 t111 = g_xLighting_NormalBuffer.Load(int3(t17, t18, 0));
  float4 t116 = g_xLighting_AlbedoBuffer.Load(int3(t17, t18, 0));
  float4 t121 = g_xLighting_PBRPropertiesBuffer.Load(int3(t17, t18, 0));

  float t129 = (t111.x * 2.f) + -1.f;
  float t130 = (t111.y * 2.f) + -1.f;
  float t131 = (t111.z * 2.f) + -1.f;
  float t133 = rsqrt(dot(float3(t129, t130, t131), float3(t129, t130, t131)));
  float t134 = t133 * t129;
  float t135 = t133 * t130;
  float t136 = t133 * t131;

  float t139 = (t121.z * 2.f) + -1.f;
  float t140 = (t121.w * 2.f) + -1.f;
  float t144 = sqrt(saturate(1.f - dot(float2(t139, t140), float2(t139, t140))));
  float t147 = (t111.w != 0.f) ? t144 : -t144;

  float t149 = rsqrt(dot(camdir, camdir));
  float t150 = t149 * camdir.x;
  float t151 = t149 * camdir.y;
  float t152 = t149 * camdir.z;

  float4 pm0 = P.m_xProjectorMatrix[0];
  float4 pm1 = P.m_xProjectorMatrix[1];
  float4 pm2 = P.m_xProjectorMatrix[2];
  float4 pm3 = P.m_xProjectorMatrix[3];
  float t156 = mad(pm2.z, t25, mad(pm1.z, t43, pm0.z * t42)) + pm3.z;
  float t160 = mad(pm2.w, t25, mad(pm1.w, t43, pm0.w * t42)) + pm3.w;

  bool inside = false;
  float t193;
  float t194;
  [branch] if (t156 < 0.f) {
  } else {
    t193 = (mad(pm2.x, t25, mad(pm1.x, t43, pm0.x * t42)) + pm3.x) / t160;
    t194 = (mad(pm2.y, t25, mad(pm1.y, t43, pm0.y * t42)) + pm3.y) / t160;
    [branch] if (((0.5f - abs(t193 + -0.5f)) < 0.f) | ((0.5f - abs(t194 + -0.5f)) < 0.f)) {
    } else {
      inside = true;
    }
  }
  bool lit = false;
  float4 color;
  [branch] if (inside) {
  float4 iv0 = g_xInvView[0];
  float4 iv1 = g_xInvView[1];
  float4 iv2 = g_xInvView[2];
  float4 iv3 = g_xInvView[3];
  float t222 = (P.m_xProjectorPos.x - iv3.x) - mad(iv2.x, t25, mad(iv1.x, t43, iv0.x * t42));
  float t224 = (P.m_xProjectorPos.y - iv3.y) - mad(iv2.y, t25, mad(iv1.y, t43, iv0.y * t42));
  float t226 = (P.m_xProjectorPos.z - iv3.z) - mad(iv2.z, t25, mad(iv1.z, t43, iv0.z * t42));

  [branch] if (P.m_bCustomBoundingVolumeSet != 0 && ((P.m_fMinRange > -dot(float3(t222, t224, t226), P.m_xProjectionDirection.xyz)) | (P.m_fLightRange < -dot(float3(t222, t224, t226), P.m_xProjectionDirection.xyz)))) {
  } else {
  float t240 = sqrt(((t224 * t224) + (t222 * t222)) + (t226 * t226));
  float t241 = t222 / t240;
  float t242 = t224 / t240;
  float t243 = t226 / t240;
  float t254 = pow(saturate((1.f - saturate((t240 - P.m_fAreaLightRadius) / (P.m_fLightRange - P.m_fAreaLightRadius))) * P.m_fLightFalloffScale), P.m_fLightFalloffPower) * P.m_fDistanceFade;
  [branch] if ((t254 + -0.0001f) < 0.f) {
  } else {
  float t602 = 1.f;
  [branch] if (P.m_iShadowTextureIndex != -1) {
    float t266 = (max((1.f - saturate(dot(float3(t134, t135, t136), float3(t241, t242, t243)))) * P.m_fShadowBias, P.m_fShadowBias) + t156) / t160;
    float t271 = (P.m_fShadowNearPlane * 2.f) * P.m_fShadowFarPlane;
    float t272 = P.m_fShadowFarPlane + P.m_fShadowNearPlane;
    float t273 = P.m_fShadowFarPlane - P.m_fShadowNearPlane;
    float t279 = saturate(((t271 / (t272 - ((((1.f - t266) * 2.f) + -1.f) * t273))) - P.m_fShadowNearPlane) / t273);
    [branch] if (P.m_fShadowStrength > 0.f) {
      Texture2D<float4> res0_0 = g_xTextureArray[NonUniformResourceIndex(P.m_iShadowTextureIndex)];
      float t598;
      [branch] if (P.m_fShadowSoftness > 0.f) {
        float t290 = frac(frac(dot(float2(pos.x, pos.y), float2(0.06711056f, 0.00583715f))) * 52.9829178f) * 6.283185f;
        float t291 = sin(t290);
        float t292 = cos(t290);
        float t294 = (P.m_fShadowSoftness * 0.025f) * P.m_fProjectorOneOverTanHalfFov;
        float sum = 0.f;
        float cnt = 0.f;
        [unroll]
        for (int i = 0; i < 4; ++i) {
          float angle = t290 + ((float)i * 2.4f);
          float radius = t294 * sqrt(((float)i + 0.5f) * 0.25f);
          float depthSample = res0_0.SampleBias(g_xBilinearClamp, float2((radius * cos(angle)) + t193, (radius * sin(angle)) + t194), g_fGlobalSamplerBias).x;
          float blockerDepth = saturate(((t271 / (t272 - ((((1.f - depthSample) * 2.f) + -1.f) * t273))) - P.m_fShadowNearPlane) / t273);
          [branch] if (blockerDepth < t279) {
            sum = blockerDepth + sum;
            cnt = cnt + 1.f;
          }
        }
        t598 = 0.f;
        [branch] if (cnt > 0.f) {
          float t400 = sum / cnt;
          float t402 = (t279 - t400) / t400;
          float t407 = (t294 * saturate(t402 * t402)) + (P.m_f2DFilterSize * 2.f);
          float t418 = res0_0.SampleCmp(g_xShadowCmpSampler, float2((t407 * ((t292 * 0.405805f) - (t291 * 0.326212f))) + t193, (t407 * ((t292 * -0.326212f) - (t291 * 0.405805f))) + t194), t266);
          float t430 = res0_0.SampleCmp(g_xShadowCmpSampler, float2((t407 * ((t292 * 0.07358f) - (t291 * 0.840144f))) + t193, (t407 * ((t292 * -0.840144f) - (t291 * 0.07358f))) + t194), t266);
          float t443 = res0_0.SampleCmp(g_xShadowCmpSampler, float2((t407 * ((t291 * -0.695914f) - (t292 * 0.457137f))) + t193, (t407 * ((t291 * 0.457137f) - (t292 * 0.695914f))) + t194), t266);
          float t456 = res0_0.SampleCmp(g_xShadowCmpSampler, float2((t407 * ((t291 * -0.203345f) - (t292 * 0.620716f))) + t193, (t407 * ((t291 * 0.620716f) - (t292 * 0.203345f))) + t194), t266);
          float t469 = res0_0.SampleCmp(g_xShadowCmpSampler, float2((t407 * ((t292 * 0.194983f) + (t291 * 0.96234f))) + t193, (t407 * ((t292 * 0.96234f) - (t291 * 0.194983f))) + t194), t266);
          float t482 = res0_0.SampleCmp(g_xShadowCmpSampler, float2((t407 * ((t292 * 0.480026f) + (t291 * 0.473434f))) + t193, (t407 * ((t292 * 0.473434f) - (t291 * 0.480026f))) + t194), t266);
          float t495 = res0_0.SampleCmp(g_xShadowCmpSampler, float2((t407 * ((t291 * 0.519456f) - (t292 * 0.767022f))) + t193, (t407 * ((t292 * 0.519456f) + (t291 * 0.767022f))) + t194), t266);
          float t508 = res0_0.SampleCmp(g_xShadowCmpSampler, float2((t407 * ((t292 * 0.893124f) + (t291 * 0.185461f))) + t193, (t407 * ((t292 * 0.185461f) - (t291 * 0.893124f))) + t194), t266);
          t598 = (((((((t430 + t418) + t443) + t456) + t469) + t482) + t495) + t508) * 0.125f;
        }
      } else {
        float t517 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 - (P.m_f2DFilterSize * 0.326212f), t194 - (P.m_f2DFilterSize * 0.405805f)), t266);
        float t523 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 - (P.m_f2DFilterSize * 0.840144f), t194 - (P.m_f2DFilterSize * 0.07358f)), t266);
        float t530 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 - (P.m_f2DFilterSize * 0.695914f), t194 + (P.m_f2DFilterSize * 0.457137f)), t266);
        float t537 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 - (P.m_f2DFilterSize * 0.203345f), t194 + (P.m_f2DFilterSize * 0.620716f)), t266);
        float t544 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 + (P.m_f2DFilterSize * 0.96234f), t194 - (P.m_f2DFilterSize * 0.194983f)), t266);
        float t551 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 + (P.m_f2DFilterSize * 0.473434f), t194 - (P.m_f2DFilterSize * 0.480026f)), t266);
        float t558 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 + (P.m_f2DFilterSize * 0.519456f), t194 + (P.m_f2DFilterSize * 0.767022f)), t266);
        float t565 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 + (P.m_f2DFilterSize * 0.185461f), t194 - (P.m_f2DFilterSize * 0.893124f)), t266);
        float t572 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 + (P.m_f2DFilterSize * 0.507431f), t194 + (P.m_f2DFilterSize * 0.064425f)), t266);
        float t579 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 + (P.m_f2DFilterSize * 0.89642f), t194 + (P.m_f2DFilterSize * 0.412458f)), t266);
        float t586 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 - (P.m_f2DFilterSize * 0.32194f), t194 - (P.m_f2DFilterSize * 0.932615f)), t266);
        float t593 = res0_0.SampleCmp(g_xShadowCmpSampler, float2(t193 - (P.m_f2DFilterSize * 0.791559f), t194 - (P.m_f2DFilterSize * 0.597705f)), t266);
        t598 = (((((((((((t523 + t517) + t530) + t537) + t544) + t551) + t558) + t565) + t572) + t579) + t586) + t593) * 0.0833333358f;
      }
      t602 = 1.f - (t598 * P.m_fShadowStrength);
    }
  }
  [branch] if (t602 > 0.f) {
  float t614 = 1.f;
  float t615 = 1.f;
  float t616 = 1.f;
  [branch] if (P.m_iTextureIndex > 0) {
    float4 t609 = g_xTextureArray[NonUniformResourceIndex(P.m_iTextureIndex)].SampleLevel(g_xTrilinearClamp, float2(t193, t194), 0.f);
    t614 = t609.x;
    t615 = t609.y;
    t616 = t609.z;
  }
  [branch] if (P.m_iDetailTextureIndex > 0) {
    float4 t625 = g_xTextureArray[NonUniformResourceIndex(P.m_iDetailTextureIndex)].SampleLevel(g_xTrilinearWrap, float2((t193 * P.m_xDetailOffsetScale.z) + P.m_xDetailOffsetScale.x, (t194 * P.m_xDetailOffsetScale.w) + P.m_xDetailOffsetScale.y), 0.f);
    t614 = t625.x * t614;
    t615 = t625.y * t615;
    t616 = t625.z * t616;
  }
  float t633 = t614;
  float t634 = t615;
  float t635 = t616;
  float t639 = ((t254 * P.m_xLightColour.x) * t633);
  float t640 = ((t254 * P.m_xLightColour.y) * t634);
  float t641 = ((t254 * P.m_xLightColour.z) * t635);

  float t685 = t241;
  float t686 = t242;
  float t687 = t243;
  float t688 = 0.f;
  [branch] if (P.m_fAreaLightRadius > 0.f) {
    float t645 = dot(float3(t150, t151, t152), float3(t134, t135, t136)) * 2.f;
    float t652 = -(t150 - (t645 * t134));
    float t653 = -(t151 - (t645 * t135));
    float t654 = -(t152 - (t645 * t136));
    float t655 = dot(float3(t222, t224, t226), float3(t652, t653, t654));
    float t659 = (t655 * t652) - t222;
    float t660 = (t655 * t653) - t224;
    float t661 = (t655 * t654) - t226;
    float t669 = saturate(P.m_fAreaLightRadius / sqrt(((t659 * t659) + (t660 * t660)) + (t661 * t661)));
    float t673 = (t659 * t669) + t222;
    float t674 = (t660 * t669) + t224;
    float t675 = (t661 * t669) + t226;
    float t677 = rsqrt(dot(float3(t673, t674, t675), float3(t673, t674, t675)));
    t685 = t673 * t677;
    t686 = t674 * t677;
    t687 = t675 * t677;
    t688 = rsqrt(dot(float3(t222, t224, t226), float3(t222, t224, t226))) * P.m_fAreaLightRadius;
  }

  // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
  float t690 = (!MaterialIdEquals(t116.w, 0.019607843831181526f)) ? t121.x : 0.f;
  float t691 = t685 + t150;
  float t692 = t686 + t151;
  float t693 = t687 + t152;
  float t695 = rsqrt(dot(float3(t691, t692, t693), float3(t691, t692, t693)));
  float t696 = t695 * t691;
  float t697 = t695 * t692;
  float t698 = t695 * t693;

  float t700 = saturate(dot(float3(t134, t135, t136), float3(t241, t242, t243)));
  float t702 = saturate(dot(float3(t134, t135, t136), float3(t150, t151, t152)));
  float t704 = saturate(dot(float3(t134, t135, t136), float3(t696, t697, t698)));
  float t706 = saturate(dot(float3(t150, t151, t152), float3(t696, t697, t698)));
  bool t707 = MaterialIdEquals(t116.w, 0.01568627543747425f);

  float t748 = t116.x;
  float t749 = t116.y;
  float t750 = t116.z;
  float t751 = 0.047f;
  float t752 = 0.047f;
  float t753 = 0.047f;
  float t754 = t700;
  [branch] if (!t707) {
    [branch] if (MaterialIdEquals(t116.w, 0.007843137718737125f)) {
      t751 = 0.028f;
      t752 = 0.028f;
      t753 = 0.028f;
    } else [branch] if (MaterialIdEquals(t116.w, 0.003921568859368563f)) {
      float t727 = pow(saturate(dot(float3(t241, t242, t243), float3(-t150, -t151, -t152))), 7.f) + (saturate(dot(float3(t241, t242, t243), float3(-t134, -t135, -t136))) * 0.4f);
      t751 = 0.028f;
      t752 = 0.028f;
      t753 = 0.028f;
      t754 = (saturate(t727) * t690) + t700;
    } else {
      t748 = t116.x - (t690 * t116.x);
      t749 = t116.y - (t690 * t116.y);
      t750 = t116.z - (t690 * t116.z);
      t751 = (t690 * (t116.x + -0.04f)) + 0.04f;
      t752 = (t690 * (t116.y + -0.04f)) + 0.04f;
      t753 = (t690 * (t116.z + -0.04f)) + 0.04f;
    }
  }
  float t755 = t754 * t748;
  float t756 = t754 * t749;
  float t757 = t754 * t750;
  float t758 = max(t121.y, 0.05f);
  float t759 = t758 * t758;

  float t913;
  float t914;
  float t915;
  float t855;
  [branch] if (t707) {
    float t762 = saturate(1.f - t121.y);
    float t764 = t121.x * 0.6f;
    float t765 = t764 + -0.350000024f;
    float t768 = (t764 + -0.25f) - (t762 * 0.05f);
    float t771 = pow(t762, 8.f);
    float t775 = pow(t762, 6.f);
    float t786 = (t134 * t765) + t139;
    float t787 = (t135 * t765) + t140;
    float t788 = t147 + (t136 * t765);
    float t790 = rsqrt(dot(float3(t786, t787, t788), float3(t786, t787, t788)));
    float t794 = dot(float3(t790 * t786, t790 * t787, t790 * t788), float3(t696, t697, t698));
    float t800 = saturate(t794 + 1.f);
    float t813 = (((t800 * t800) * (((t762 + 0.1f) * ((t121.x * 0.135f) + 0.0150000006f)) * ((t771 * 19.89437f) + 1.11408472f))) * (3.f - (t800 * 2.f))) * pow(sqrt(saturate(1.f - (t794 * t794))), (t771 * 500.f) + 20.f);
    float t814 = max(dot(float3(t116.x, t116.y, t116.z), float3(0.3f, 0.59f, 0.11f)), 0.001f);
    float t824 = (t768 * t134) + t139;
    float t825 = (t768 * t135) + t140;
    float t826 = (t768 * t136) + t147;
    float t828 = rsqrt(dot(float3(t824, t825, t826), float3(t824, t825, t826)));
    float t832 = dot(float3(t828 * t824, t828 * t825, t828 * t826), float3(t696, t697, t698));
    float t838 = saturate(t832 + 1.f);
    float t851 = (((t838 * t838) * ((t762 * ((t121.x * 0.0075f) + 0.0075f)) * ((t775 * 79.57748f) + 2.307747f))) * (3.f - (t838 * 2.f))) * pow(sqrt(saturate(1.f - (t832 * t832))), (t775 * 2000.f) + 50.f);
    t855 = t700 * P.m_fSpecularStrength;
    t913 = t855 * (t851 + (t813 * (t116.x / t814)));
    t914 = t855 * (t851 + (t813 * (t116.y / t814)));
    t915 = t855 * (t851 + (t813 * (t116.z / t814)));
  } else {
    float t862 = saturate((1.f - t759) * t688);
    float t869 = exp2(((-6.98316f) - (t706 * 5.55473f)) * t706);
    float t873 = (t869 * (1.f - t751)) + t751;
    float t874 = (t869 * (1.f - t752)) + t752;
    float t875 = (t869 * (1.f - t753)) + t753;
    float t877 = t759 * t759;
    float t888 = 1.f;
    [branch] if (t862 > 0.f) {
      t888 = t877 / ((((t862 * 0.25f) * (t862 + (t759 * 3.f))) / (t706 + 0.001f)) + t877);
    }
    float t889 = 2.f - t759;
    float t899 = (((t877 * t704) - t704) * t704) + 1.f;
    float t905 = (((t700 * P.m_fSpecularStrength) * t877) * (1.f / (((t889 * t702) + t759) * ((t889 * t700) + t759)))) * (1.f / (t899 * t899));
    t913 = (t888 * t873) * t905;
    t914 = (t888 * t874) * t905;
    t915 = (t888 * t875) * t905;
  }
  float t916 = t913 + t755;
  float t917 = t914 + t756;
  float t918 = t915 + t757;
  float t1000 = t916;
  float t1001 = t917;
  float t1002 = t918;
  [branch] if (MaterialIdEquals(t116.w, 0.019607843831181526f)) {
    bool t921 = t121.x > 0.498039216f;
    float t924 = (t921 ? (t121.x + -0.5019608f) : t121.x) * 2.007874f;
    float t940 = pow(saturate(dot(float3(t241, t242, t243), float3(-t150, -t151, -t152))), 7.f) + (saturate(dot(float3(t241, t242, t243), float3(-t134, -t135, -t136))) * 0.4f);
    float t942 = saturate(t940) * (t921 ? 0.5f : 0.f);
    float t949 = sqrt(abs(t748));
    float t950 = sqrt(abs(t749));
    float t951 = sqrt(abs(t750));
    float t958 = exp2(((-6.98316f) - (t706 * 5.55473f)) * t706);
    float t962 = (t958 * (1.f - t949)) + t949;
    float t963 = (t958 * (1.f - t950)) + t950;
    float t964 = ((1.f - t951) * t958) + t951;
    float t971 = 0.5f / t759;
    float t979 = ((t971 + 1.f) * (1.f / ((((t702 + t700) - (t702 * t700)) * 4.f) + 1e-20f))) * pow(1.f - (t704 * t704), t971);
    float t980 = t700 * P.m_fSpecularStrength;
    t1000 = ((((t942 * t748) - t913) + ((t962 * t980) * t979)) * t924) + t916;
    t1001 = ((((t942 * t749) - t914) + ((t963 * t980) * t979)) * t924) + t917;
    t1002 = ((((t942 * t750) - t915) + ((t964 * t980) * t979)) * t924) + t918;
  }
  float t1006 = min(t639 * t1000, 1000.f);
  float t1007 = min(t640 * t1001, 1000.f);
  float t1008 = min(t641 * t1002, 1000.f);
  [branch] if ((t25 < 3.f) & (MaterialIdEquals(t116.w, 0.007843137718737125f))) {
    float t1014 = max(t25 + -2.f, 0.f);
    t1006 = ((((1.f - g_xSubsurfaceScatteringWeight.x) * t1014) + g_xSubsurfaceScatteringWeight.x) * t1006);
    t1007 = ((((1.f - g_xSubsurfaceScatteringWeight.y) * t1014) + g_xSubsurfaceScatteringWeight.y) * t1007);
    t1008 = ((((1.f - g_xSubsurfaceScatteringWeight.z) * t1014) + g_xSubsurfaceScatteringWeight.z) * t1008);
  }
  color = float4(t1006, t1007, t1008, t602);
  lit = true;
  } else {
    color = float4(0.f, 0.f, 0.f, t602);
    lit = true;
  }
  }
  }
  }
  [branch] if (lit) {
  } else {
    discard;
  }
  outColor = color;
}
