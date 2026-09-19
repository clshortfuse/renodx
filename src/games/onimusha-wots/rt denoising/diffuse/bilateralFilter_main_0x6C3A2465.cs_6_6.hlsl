#include "../denoising.hlsli"

Texture2D<float> depthSRV : register(t0);

Texture2D<float4> normalRoughnessSRV : register(t1);

Texture2D<float4> diffuseHistoryColorSRV : register(t2);

Texture2D<float4> diffuseHistorySHSRV : register(t3);

Texture2D<float> historyCountSRV : register(t4);

RWTexture2D<float4> diffuseHistoryColorUAV : register(u0);

RWTexture2D<float4> diffuseHistorySHUAV : register(u1);

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c000.x);
  row_major float3x4 transposeViewMat : packoffset(c004.x);
  row_major float3x4 transposeViewInvMat : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  row_major float4x4 viewProjInvMat : packoffset(c014.x);
  row_major float4x4 prevViewProjMat : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[8] : packoffset(c025.x);
  float4 clipplane : packoffset(c033.x);
  float2 vrsVelocityThreshold : packoffset(c034.x);
  uint GPUVisibleMask : packoffset(c034.z);
  uint resolutionRatioPacked : packoffset(c034.w);
  float3 worldOffset : packoffset(c035.x);
  uint sceneInfoMisc : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  uint blueNoiseJitterIndex : packoffset(c038.z);
  float tessellationParam : packoffset(c038.w);
  float SceneInfo_Reserve2 : packoffset(c039.x);
};

cbuffer EnvironmentInfo : register(b1) {
  uint timeMillisecond : packoffset(c000.x);
  uint frameCount : packoffset(c000.y);
  uint isOddFrame : packoffset(c000.z);
  uint reserveEnvironmentInfo : packoffset(c000.w);
  float breakingPBRSpecularIntensity : packoffset(c001.x);
  float breakingPBRIBLReflectanceBias : packoffset(c001.y);
  float breakingPBRIBLIntensity : packoffset(c001.z);
  float breakingPBR_Reserved : packoffset(c001.w);
  uint vrsTier2Enable : packoffset(c002.x);
  uint dynamicTextureTableNullBlackHandle : packoffset(c002.y);
  uint prevTimeMillisecond : packoffset(c002.z);
  uint bindlessMaterialMaxNum : packoffset(c002.w);
  float rtLightRadius : packoffset(c003.x);
  float accurateVelocityDistanceSq : packoffset(c003.y);
  uint texture1DDummyHandle : packoffset(c003.z);
  uint texture1DArrayDummyHandle : packoffset(c003.w);
  uint texture2DDummyHandle : packoffset(c004.x);
  uint texture2DArrayDummyHandle : packoffset(c004.y);
  uint texture3DDummyHandle : packoffset(c004.z);
  uint textureCubeDummyHandle : packoffset(c004.w);
  uint textureCubeArrayDummyHandle : packoffset(c005.x);
  uint byteAddressBufferDummyHandle : packoffset(c005.y);
  float EnvironmentInfoReserved1 : packoffset(c005.z);
  float EnvironmentInfoReserved2 : packoffset(c005.w);
  float4 userGlobalParams[32] : packoffset(c006.x);
  uint4 dynamicTextureTableHandles[256] : packoffset(c038.x);
  uint4 bakedResourceSharedTablesHandles[32] : packoffset(c294.x);
};

cbuffer CheckerBoardInfo : register(b2) {
  float2 cbr : packoffset(c000.x);
  float cbr_scale : packoffset(c000.z);
  float cbr_using : packoffset(c000.w);
  float2 cbr_padding : packoffset(c001.x);
  float cbr_mipmapReadjustRatio : packoffset(c001.z);
  int cbr_mipmapReadjustable : packoffset(c001.w);
};

cbuffer RayTracingDenoiserConstantBufferInfo : register(b3) {
  uint WaveletStep : packoffset(c000.x);
  float AODistance : packoffset(c000.y);
  uint UserStencilMask : packoffset(c000.z);
  float compressEV : packoffset(c000.w);
  uint diff_RT_WIDTH : packoffset(c001.x);
  uint diff_RT_HEIGHT : packoffset(c001.y);
  float diff_INV_RT_WIDTH : packoffset(c001.z);
  float diff_INV_RT_HEIGHT : packoffset(c001.w);
  uint spec_RT_WIDTH : packoffset(c002.x);
  uint spec_RT_HEIGHT : packoffset(c002.y);
  float spec_INV_RT_WIDTH : packoffset(c002.z);
  float spec_INV_RT_HEIGHT : packoffset(c002.w);
  float diffuseMultipler : packoffset(c003.x);
  float specularMultipler : packoffset(c003.y);
  float modelScaler : packoffset(c003.z);
  float depthRejectionThresold : packoffset(c003.w);
  float specularRoughnessThreshold : packoffset(c004.x);
  uint disocclusionStep : packoffset(c004.y);
  float maxDiffuseHistory : packoffset(c004.z);
  float maxSpecularHistory : packoffset(c004.w);
  float4 Rotator0 : packoffset(c005.x);
  float4 Rotator1 : packoffset(c006.x);
  float4 Rotator2 : packoffset(c007.x);
  float4 Rotator3 : packoffset(c008.x);
  row_major float4x4 prevViewProjInvMat : packoffset(c009.x);
  uint diffuseMaxIterationCount : packoffset(c013.x);
  uint specularMaxIterationCount : packoffset(c013.y);
  uint ps5HeatmapMode : packoffset(c013.z);
  float heatmapMaxIntersectionCount : packoffset(c013.w);
  float2 diffResolutionRatio : packoffset(c014.x);
  float GIHistoryThreshold : packoffset(c014.z);
  float GIFilterCenterWeight : packoffset(c014.w);
  float VFXDiffuseBoost : packoffset(c015.x);
  float VFXSpecularBoost : packoffset(c015.y);
  uint VFXSpecularMipBias : packoffset(c015.z);
  float VFXDiffuseResolutionRatio : packoffset(c015.w);
  float VFXSpecularResolutionRatio : packoffset(c016.x);
  float VFXInvalidateTemporalRatio : packoffset(c016.y);
  float VFXPrevSpecularResolutionRatio : packoffset(c016.z);
  float VFXTemporalCompositeRate : packoffset(c016.w);
  uint medianFilterStepSize : packoffset(c017.x);
  float specularSecondaryBounceRoughnessThreshold : packoffset(c017.y);
  float2 diffInvResolutionRatio : packoffset(c017.z);
  float2 specResolutionRatio : packoffset(c018.x);
  float2 specInvResolutionRatio : packoffset(c018.z);
  float specularTraceRoughnessThreshold : packoffset(c019.x);
  uint diffuseDisocclusionFrameRange : packoffset(c019.y);
  float diffuseDisocclusionFilteringStrength : packoffset(c019.z);
  float reserved0 : packoffset(c019.w);
  float iblLeakingAmountDiff : packoffset(c020.x);
  float iblLeakingAmountSpec : packoffset(c020.y);
  float iblLeakingDistanceDiff : packoffset(c020.z);
  float iblLeakingDistanceSpec : packoffset(c020.w);
  float2 diffUVAdjuster : packoffset(c021.x);
  float2 specUVAdjuster : packoffset(c021.z);
};

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

[noinline]
precise float AddPrecise0(float lhs, float rhs) {
  return lhs + rhs;
}
[noinline]
precise float AddPrecise1(float lhs, float rhs) {
  return lhs + rhs;
}

static const float _global_0[16] = { -0.6455659866333008f, 0.0266201663762331f, -0.41894465684890747f, 0.8573530316352844f, 0.04460543394088745f, 0.5316708087921143f, 0.5317319631576538f, 0.3773360848426819f, 0.649772047996521f, -0.1614876240491867f, 0.12475734949111938f, -0.2891661524772644f, 0.2474198341369629f, -0.8544320464134216f, -0.47650110721588135f, -0.6853070855140686f };

[numthreads(16, 16, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _58;
  float _59;
  float _151;
  float _152;
  float _215;
  float _216;
  float _217;
  float _218;
  float _219;
  float _220;
  float _221;
  float _222;
  float _223;
  int _224;
  float _336;
  float _337;
  float _29;
  float _44;
  float _68;
  float _69;
  float _105;
  float _106;
  float _107;
  float _108;
  float _119;
  float _128;
  float4 _130;
  float _135;
  float _136;
  float _138;
  float _139;
  float _140;
  float _143;
  float _154;
  float _155;
  float _156;
  float _157;
  float _168;
  float _171;
  float _174;
  float _176;
  float _178;
  float _179;
  float _180;
  float _181;
  float _182;
  float _183;
  float _184;
  float _185;
  float _186;
  float _187;
  float _188;
  float _189;
  float _190;
  float _191;
  float4 _193;
  float4 _199;
  float _228;
  float _232;
  float _243;
  float _244;
  float _254;
  float _255;
  float _256;
  float _284;
  float _309;
  float _310;
  uint _311;
  uint _312;
  float _314;
  float _322;
  float _346;
  float _347;
  float _383;
  float _395;
  float4 _397;
  float _406;
  float _407;
  float _408;
  float _409;
  float4 _411;
  float _420;
  float _421;
  float _422;
  float _423;
  float _424;
  int _425;
  if (((int)(int)(SV_DispatchThreadID.y) < (int)diff_RT_HEIGHT) && (((int)((int)(SV_DispatchThreadID.y) | (int)(SV_DispatchThreadID.x)) > (int)-1) && ((int)(int)(SV_DispatchThreadID.x) < (int)diff_RT_WIDTH))) {
    uint2 pixel = SV_DispatchThreadID.xy;
    _29 = depthSRV.Load(int3(pixel, 0));
    if (!(_29.x <= 0.0f)) {
      if (RT_SKIP_BILATERAL_FILTER) {
        diffuseHistoryColorUAV[pixel] = diffuseHistoryColorSRV.Load(int3(pixel, 0));
        diffuseHistorySHUAV[pixel] = diffuseHistorySHSRV.Load(int3(pixel, 0));
        return;
      }

      _44 = floor(diffResolutionRatio.y * ((float)((uint)SV_DispatchThreadID.y)));
      do {
        _58 = 0.5f;
        if (cbr_using != 0.0f) {
          _58 = ((((float)((uint)((uint)(((int)((uint)(isOddFrame) + (uint)(int(_44)))) & 1)))) * 0.5f) + 0.25f);
        }
        _59 = AddPrecise0(floor(diffResolutionRatio.x * ((float)((uint)SV_DispatchThreadID.x))), _58);
        _68 = (((_59 * 2.0f) * screenInverseSize.x) + -1.0f);
        _69 = 1.0f - (((_44 + 0.5f) * 2.0f) * screenInverseSize.y);
        _105 = mad(_29.x, (viewProjInvMat[2].w), mad(_69, (viewProjInvMat[1].w), (_68 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w);
        _106 = (mad(_29.x, (viewProjInvMat[2].x), mad(_69, (viewProjInvMat[1].x), (_68 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x)) / _105;
        _107 = (mad(_29.x, (viewProjInvMat[2].y), mad(_69, (viewProjInvMat[1].y), (_68 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y)) / _105;
        _108 = (mad(_29.x, (viewProjInvMat[2].z), mad(_69, (viewProjInvMat[1].z), (_68 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z)) / _105;
        _119 = saturate(((historyCountSRV.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0))).x) * 0.015625f);
        _128 = ((1.0f - (_119 * 0.8999999761581421f)) * abs(mad(_108, (transposeViewMat[2].z), mad(_107, (transposeViewMat[2].y), ((transposeViewMat[2].x) * _106))) + (transposeViewMat[2].w))) * modelScaler;
        _130 = normalRoughnessSRV.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
        _135 = (_130.x * 2.0f) + -1.0f;
        _136 = (_130.y * 2.0f) + -1.0f;
        _138 = 1.0f - abs(_135);
        _139 = abs(_136);
        _140 = _138 - _139;
        do {
          _151 = _135;
          _152 = _136;
          if (_140 < 0.0f) {
            _143 = 1.0f - _139;
            _151 = select((_135 >= 0.0f), _143, (-0.0f - _143));
            _152 = select((_136 >= 0.0f), _138, (-0.0f - _138));
          }
          _154 = rsqrt(dot(float3(_151, _152, _140), float3(_151, _152, _140)));
          _155 = _154 * _151;
          _156 = _154 * _152;
          _157 = _154 * _140;
          _168 = mad(_157, (transposeViewMat[2].x), mad(_156, (transposeViewMat[1].x), ((transposeViewMat[0].x) * _155)));
          _171 = mad(_157, (transposeViewMat[2].y), mad(_156, (transposeViewMat[1].y), ((transposeViewMat[0].y) * _155)));
          _174 = mad(_157, (transposeViewMat[2].z), mad(_156, (transposeViewMat[1].z), ((transposeViewMat[0].z) * _155)));
          _176 = select((_174 >= 0.0f), 1.0f, -1.0f);
          _178 = -1.0f / (_176 + _174);
          _179 = _178 * _171;
          _180 = _179 * _168;
          _181 = _168 * _168;
          _182 = _181 * _178;
          _183 = _182 * _176;
          _184 = _183 + 1.0f;
          _185 = _179 * _171;
          _186 = _176 + _185;
          _187 = _128 * (16.0f - (_119 * 15.0f));
          _188 = _187 * _180;
          _189 = _186 * _187;
          _190 = _187 * _171;
          _191 = -0.0f - _190;
          _193 = diffuseHistoryColorSRV.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
          _199 = diffuseHistorySHSRV.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
          _215 = 1.0f;
          _216 = _193.x;
          _217 = _193.y;
          _218 = _193.z;
          _219 = _193.w;
          _220 = _199.x;
          _221 = _199.y;
          _222 = _199.z;
          _223 = _199.w;
          _224 = 0;
          for (;;) {
            _228 = _global_0[_224 * 2];
            _232 = _global_0[(_224 * 2) + 1];
            _243 = (Rotator3.z * _228) + (Rotator3.w * _232);
            _244 = _187 * ((Rotator3.x * _228) + (Rotator3.y * _232));
            _254 = mad(_243, _188, (_244 * _184)) + _106;
            _255 = mad(_243, _189, ((_244 * _176) * _180)) + _107;
            _256 = mad(_243, _191, (-0.0f - ((_176 * _168) * _244))) + _108;
            _284 = mad(_256, (viewProjMat[2].w), mad(_255, (viewProjMat[1].w), ((viewProjMat[0].w) * _254))) + (viewProjMat[3].w);
            _309 = ((1.0f - diffInvResolutionRatio.x) * 0.5f) + (((float)((uint)(uint)(diff_RT_WIDTH))) * saturate(abs((((mad(_256, (viewProjMat[2].x), mad(_255, (viewProjMat[1].x), ((viewProjMat[0].x) * _254))) + (viewProjMat[3].x)) / _284) * 0.5f) + 0.5f)));
            _310 = ((1.0f - diffInvResolutionRatio.y) * 0.5f) + (((float)((uint)(uint)(diff_RT_HEIGHT))) * saturate(abs(0.5f - (((mad(_256, (viewProjMat[2].y), mad(_255, (viewProjMat[1].y), ((viewProjMat[0].y) * _254))) + (viewProjMat[3].y)) / _284) * 0.5f))));
            _311 = uint(_309);
            _312 = uint(_310);
            _314 = depthSRV.Load(int3(_311, _312, 0));
            _322 = floor(diffResolutionRatio.y * _310);
            _336 = 0.5f;
            if (cbr_using != 0.0f) {
              _336 = ((((float)((uint)((uint)(((int)((uint)(isOddFrame) + (uint)(int(_322)))) & 1)))) * 0.5f) + 0.25f);
            }
            _337 = AddPrecise1(floor(diffResolutionRatio.x * _309), _336);
            _346 = (((_337 * 2.0f) * screenInverseSize.x) + -1.0f);
            _347 = 1.0f - (((_322 + 0.5f) * 2.0f) * screenInverseSize.y);
            _383 = mad(_314.x, (viewProjInvMat[2].w), mad(_347, (viewProjInvMat[1].w), (_346 * (viewProjInvMat[0].w)))) + (viewProjInvMat[3].w);
            _395 = saturate(1.0f - (abs(dot(float3((((mad(_314.x, (viewProjInvMat[2].x), mad(_347, (viewProjInvMat[1].x), (_346 * (viewProjInvMat[0].x)))) + (viewProjInvMat[3].x)) / _383) - _106), (((mad(_314.x, (viewProjInvMat[2].y), mad(_347, (viewProjInvMat[1].y), (_346 * (viewProjInvMat[0].y)))) + (viewProjInvMat[3].y)) / _383) - _107), (((mad(_314.x, (viewProjInvMat[2].z), mad(_347, (viewProjInvMat[1].z), (_346 * (viewProjInvMat[0].z)))) + (viewProjInvMat[3].z)) / _383) - _108)), float3(_168, _171, _174))) / max(9.999999747378752e-05f, _128)));
            _397 = diffuseHistoryColorSRV.Load(int3(_311, _312, 0));
            _406 = (_397.x * _395) + _216;
            _407 = (_397.y * _395) + _217;
            _408 = (_397.z * _395) + _218;
            _409 = (_397.w * _395) + _219;
            _411 = diffuseHistorySHSRV.Load(int3(_311, _312, 0));
            _420 = (_411.x * _395) + _220;
            _421 = (_411.y * _395) + _221;
            _422 = (_411.z * _395) + _222;
            _423 = (_411.w * _395) + _223;
            _424 = _395 + _215;
            _425 = _224 + 1;
            if (_425 == 8) {
              break;
            } else {
              _215 = _424;
              _216 = _406;
              _217 = _407;
              _218 = _408;
              _219 = _409;
              _220 = _420;
              _221 = _421;
              _222 = _422;
              _223 = _423;
              _224 = _425;
              continue;
            }
          }
          diffuseHistoryColorUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4((_406 / _424), (_407 / _424), (_408 / _424), _409);
          diffuseHistorySHUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4((_420 / _424), (_421 / _424), (_422 / _424), (_423 / _424));
        } while (false);
      } while (false);
    }
  }
}
