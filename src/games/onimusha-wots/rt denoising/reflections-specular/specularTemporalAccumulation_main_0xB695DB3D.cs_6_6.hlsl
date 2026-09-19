
#include "../denoising.hlsli"

cbuffer SceneInfo : register(b0, space0) {
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

cbuffer EnvironmentInfo : register(b1, space0) {
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

cbuffer CheckerBoardInfo : register(b2, space0) {
  float2 cbr : packoffset(c000.x);
  float cbr_scale : packoffset(c000.z);
  float cbr_using : packoffset(c000.w);
  float2 cbr_padding : packoffset(c001.x);
  float cbr_mipmapReadjustRatio : packoffset(c001.z);
  int cbr_mipmapReadjustable : packoffset(c001.w);
};

cbuffer RayTracingDenoiserConstantBufferInfo : register(b3, space0) {
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
Texture2D<float> depthSRV : register(t0);
Texture2D<float4> normalRoughnessSRV : register(t1);
Texture2D<float4> weightSRV : register(t2);
Texture2D<float2> surfaceMotionSRV : register(t3);
Texture2D<float4> specularColorSRV : register(t4);
Texture2D<uint2> specularMomentSRV : register(t5);
Texture2D<float4> specularHistoryColorSRV : register(t6);
Texture2D<float> historyCountSRV : register(t7);
RWTexture2D<uint2> specularMomentUAV : register(u0);
RWTexture2D<float4> specularHistoryColorUAV : register(u1);
RWTexture2D<float> historyCountUAV : register(u2);

static uint3 gl_LocalInvocationID;
static uint3 gl_GlobalInvocationID;
static uint gl_LocalInvocationIndex;
struct SPIRV_Cross_Input {
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
  uint gl_LocalInvocationIndex : SV_GroupIndex;
};

groupshared float _52[1296];

uint PackSpecularMoment(float3 value) {
  float3 magnitude = abs(value);
  float maxMagnitude = max(max(magnitude.x, magnitude.y), magnitude.z);
  if (maxMagnitude == 0.0f) return 0u;

  float exponent = ceil(log2(maxMagnitude));
  uint3 mantissa = min(uint3(255u, 255u, 255u), uint3(round(exp2(-exponent) * 256.0f * magnitude)));
  return ((value.x < 0.0f) ? 256u : 0u)
         | ((value.y < 0.0f) ? 131072u : 0u)
         | ((value.z < 0.0f) ? 67108864u : 0u)
         | mantissa.x
         | (mantissa.y << 9u)
         | (mantissa.z << 18u)
         | (uint(clamp(exponent + 15.0f, 0.0f, 31.0f)) << 27u);
}

void comp_main() {
  uint _72 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + 4294967295u;
  uint _74 = (gl_GlobalInvocationID.y - gl_LocalInvocationID.y) + 4294967295u;
  float _78 = (float(int(gl_LocalInvocationIndex)) + 0.5f) * 0.0555555559694766998291015625f;
  uint _84 = uint(int(frac(_78) * 18.0f));
  uint _85 = uint(int(_78));
  if (int(_85) < int(14u)) {
    float4 _92 = specularColorSRV.Load(int3(uint2(_84 + _72, _85 + _74), 0u));
    _52[0u + ((_84 + (_85 * 18u)) * 4u)] = _92.x;
    _52[1u + ((_84 + (_85 * 18u)) * 4u)] = _92.y;
    _52[2u + ((_84 + (_85 * 18u)) * 4u)] = _92.z;
    _52[3u + ((_84 + (_85 * 18u)) * 4u)] = _92.w;
  }
  uint _123 = _85 + 14u;
  if (int(_123) < int(18u)) {
    float4 _128 = specularColorSRV.Load(int3(uint2(_84 + _72, _123 + _74), 0u));
    _52[0u + ((_84 + (_123 * 18u)) * 4u)] = _128.x;
    _52[1u + ((_84 + (_123 * 18u)) * 4u)] = _128.y;
    _52[2u + ((_84 + (_123 * 18u)) * 4u)] = _128.z;
    _52[3u + ((_84 + (_123 * 18u)) * 4u)] = _128.w;
  }
  GroupMemoryBarrierWithGroupSync();
  uint4 _159 = uint4(spec_RT_WIDTH, spec_RT_HEIGHT, asuint(spec_INV_RT_WIDTH), asuint(spec_INV_RT_HEIGHT));
  uint _160 = _159.x;
  uint _161 = _159.y;
  if ((int(gl_GlobalInvocationID.y) < int(_161)) && ((int(gl_GlobalInvocationID.y | gl_GlobalInvocationID.x) > int(4294967295u)) && (int(gl_GlobalInvocationID.x) < int(_160)))) {
    float4 _169 = depthSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
    float _171 = _169.x;
    if (!(_171 <= 0.0f)) {
      float4 _175 = normalRoughnessSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
      if (floor(_175.w * 3.099999904632568359375f) == 3.0f) {
        specularHistoryColorUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(specularHistoryColorUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)].xyz, -1.0f);
      } else {
        float4 _202 = specularColorSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
        if (RT_SKIP_TEMPORAL_ACCUMULATION) {
          uint2 pixel = gl_GlobalInvocationID.xy;
          specularMomentUAV[pixel] = uint2(PackSpecularMoment(_202.xyz), PackSpecularMoment(_202.xyz * _202.xyz));
          specularHistoryColorUAV[pixel] = _202;
          historyCountUAV[pixel] = 1.0f;
          return;
        }

        float _204 = _202.x;
        float _205 = _202.y;
        float _206 = _202.z;
        float _207 = _202.w;
        float _208 = float(int(gl_GlobalInvocationID.x));
        float _209 = float(int(gl_GlobalInvocationID.y));
        float _216 = floor(specResolutionRatio.x * _208);
        float _217 = floor(specResolutionRatio.y * _209);
        bool _221 = cbr_using != 0.0f;
        float _233;
        if (_221) {
          _233 = (float((uint4(timeMillisecond, frameCount, isOddFrame, reserveEnvironmentInfo).z + uint(int(_217))) & 1u) * 0.5f) + 0.25f;
        } else {
          _233 = 0.5f;
        }
        precise float _234 = _216 + _233;
        float _244 = screenInverseSize.y * (_217 + 0.5f);
        float _246 = ((_234 * 2.0f) * screenInverseSize.x) + (-1.0f);
        float _247 = 1.0f - (_244 * 2.0f);
        float _291 = mad(_171, viewProjInvMat[2].w, mad(_247, viewProjInvMat[1].w, _246 * viewProjInvMat[0].w)) + viewProjInvMat[3].w;
        float _292 = (mad(_171, viewProjInvMat[2].x, mad(_247, viewProjInvMat[1].x, _246 * viewProjInvMat[0].x)) + viewProjInvMat[3].x) / _291;
        float _293 = (mad(_171, viewProjInvMat[2].y, mad(_247, viewProjInvMat[1].y, _246 * viewProjInvMat[0].y)) + viewProjInvMat[3].y) / _291;
        float _294 = (mad(_171, viewProjInvMat[2].z, mad(_247, viewProjInvMat[1].z, _246 * viewProjInvMat[0].z)) + viewProjInvMat[3].z) / _291;
        float _307 = _292 - transposeViewInvMat[0].w;
        float _308 = _293 - transposeViewInvMat[1].w;
        float _309 = _294 - transposeViewInvMat[2].w;
        float _315 = rsqrt(dot(float3(_307, _308, _309), float3(_307, _308, _309))) * _207;
        float _351 = ((_315 * _307) + _292) - worldOffset.x;
        float _352 = ((_315 * _308) + _293) - worldOffset.y;
        float _353 = ((_315 * _309) + _294) - worldOffset.z;
        float _365 = mad(_353, prevViewProjMat[2].w, mad(_352, prevViewProjMat[1].w, _351 * prevViewProjMat[0].w)) + prevViewProjMat[3].w;
        float _381;
        if (_221) {
          _381 = (float((uint4(timeMillisecond, frameCount, isOddFrame, reserveEnvironmentInfo).z + uint(int(_217))) & 1u) * 0.5f) + 0.25f;
        } else {
          _381 = 0.5f;
        }
        precise float _382 = _216 + _381;
        float2 _388 = surfaceMotionSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
        float _390 = _388.x;
        float _391 = _388.y;
        float _392 = float(_160);
        float _393 = _390 * _392;
        float _395 = float(_161);
        float _396 = _391 * _395;
        float _401 = floor(_393 + _208);
        float _402 = floor(_396 + _209);
        uint _405 = uint(int(_401));
        uint _406 = uint(int(_402));
        uint _407 = uint(int(_401 + 1.0f));
        uint _408 = uint(int(_402 + 1.0f));
        float4 _410 = weightSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
        float _412 = _410.x;
        float _413 = _410.y;
        float _414 = _410.z;
        float _415 = _410.w;
        float4 _417 = specularHistoryColorSRV.Load(int3(uint2(_405, _406), 0u));
        float4 _427 = specularHistoryColorSRV.Load(int3(uint2(_407, _406), 0u));
        float4 _441 = specularHistoryColorSRV.Load(int3(uint2(_405, _408), 0u));
        float4 _455 = specularHistoryColorSRV.Load(int3(uint2(_407, _408), 0u));
        float _465 = (((_427.x * _413) + (_417.x * _412)) + (_441.x * _414)) + (_455.x * _415);
        float _466 = (((_427.y * _413) + (_417.y * _412)) + (_441.y * _414)) + (_455.y * _415);
        float _467 = (((_427.z * _413) + (_417.z * _412)) + (_441.z * _414)) + (_455.z * _415);
        float _468 = (((_427.w * _413) + (_417.w * _412)) + (_441.w * _414)) + (_455.w * _415);
        float _471 = ((((((mad(_353, prevViewProjMat[2].x, mad(_352, prevViewProjMat[1].x, _351 * prevViewProjMat[0].x)) + prevViewProjMat[3].x) / _365) * 0.5f) + 0.5f) - (_382 * screenInverseSize.x)) * _392) + _208;
        float _472 = (((0.5f - _244) - (((mad(_353, prevViewProjMat[2].y, mad(_352, prevViewProjMat[1].y, _351 * prevViewProjMat[0].y)) + prevViewProjMat[3].y) / _365) * 0.5f)) * _395) + _209;
        float _473 = floor(_471);
        float _474 = floor(_472);
        float _475 = frac(_471);
        float _476 = frac(_472);
        float _477 = 1.0f - _475;
        float _478 = 1.0f - _476;
        uint _483 = uint(int(_473));
        uint _484 = uint(int(_474));
        uint _486 = uint(int(_473 + 1.0f));
        uint _488 = uint(int(_474 + 1.0f));
        bool _491 = int(_483) < int(_160);
        float _496 = (_478 * _477) * ((_491 && (int(_484 | _483) > int(4294967295u))) ? float(int(_484) < int(_161)) : 0.0f);
        bool _499 = int(_486) < int(_160);
        float _504 = (_478 * _475) * ((_499 && (int(_486 | _484) > int(4294967295u))) ? float(int(_484) < int(_161)) : 0.0f);
        float _511 = (_477 * _476) * ((_491 && (int(_488 | _483) > int(4294967295u))) ? float(int(_488) < int(_161)) : 0.0f);
        float _518 = (_476 * _475) * ((_499 && (int(_488 | _486) > int(4294967295u))) ? float(int(_488) < int(_161)) : 0.0f);
        float _519 = dot(float4(_496, _504, _511, _518), 1.0f.xxxx);
        float4 _530 = specularHistoryColorSRV.Load(int3(uint2(_483, _484), 0u));
        float _535 = _530.w;
        float4 _536 = specularHistoryColorSRV.Load(int3(uint2(_486, _484), 0u));
        float _541 = _536.w;
        float4 _542 = specularHistoryColorSRV.Load(int3(uint2(_483, _488), 0u));
        float _547 = _542.w;
        float4 _548 = specularHistoryColorSRV.Load(int3(uint2(_486, _488), 0u));
        float _553 = _548.w;
        float _556 = ((_535 < 0.0f) ? 0.0f : 1.0f) * saturate(_496 / _519);
        float _559 = ((_541 < 0.0f) ? 0.0f : 1.0f) * saturate(_504 / _519);
        float _562 = ((_547 < 0.0f) ? 0.0f : 1.0f) * saturate(_511 / _519);
        float _565 = ((_553 < 0.0f) ? 0.0f : 1.0f) * saturate(_518 / _519);
        float _566 = dot(float4(_556, _559, _562, _565), 1.0f.xxxx);
        float _574;
        float _575;
        float _576;
        float _577;
        if (_566 > 0.0f) {
          _574 = _565 / _566;
          _575 = _562 / _566;
          _576 = _559 / _566;
          _577 = _556 / _566;
        } else {
          _574 = _565;
          _575 = _562;
          _576 = _559;
          _577 = _556;
        }
        float _595 = (((_575 * _542.x) + (_574 * _548.x)) + (_576 * _536.x)) + (_577 * _530.x);
        float _598 = (((_575 * _542.y) + (_574 * _548.y)) + (_576 * _536.y)) + (_577 * _530.y);
        float _601 = (((_575 * _542.z) + (_574 * _548.z)) + (_576 * _536.z)) + (_577 * _530.z);
        float _604 = _465 - _204;
        float _605 = _466 - _205;
        float _606 = _467 - _206;
        float _612 = sqrt(((_604 * _604) + (_605 * _605)) + (_606 * _606));
        float _613 = _595 - _204;
        float _614 = _598 - _205;
        float _615 = _601 - _206;
        float _621 = sqrt(((_613 * _613) + (_614 * _614)) + (_615 * _615));
        float _623 = max(9.9999997473787516355514526367188e-05f, max(_612, _621));
        float _632 = exp2(min(1.0f, _621 / _623) * (-10.0f));
        float _633 = _204 * _204;
        float _634 = _205 * _205;
        float _635 = _206 * _206;
        uint _636 = gl_GlobalInvocationID.x + 4294967295u;
        uint _637 = gl_GlobalInvocationID.y + 4294967295u;
        float _650;
        float _652;
        float _654;
        float _656;
        float _658;
        float _660;
        float _662;
        if ((int(_637) < int(_161)) && ((int(_637 | _636) > int(4294967295u)) && (int(_636) < int(_160)))) {
          float frontier_phi_18_17_ladder;
          float frontier_phi_18_17_ladder_1;
          float frontier_phi_18_17_ladder_2;
          float frontier_phi_18_17_ladder_3;
          float frontier_phi_18_17_ladder_4;
          float frontier_phi_18_17_ladder_5;
          float frontier_phi_18_17_ladder_6;
          if (floor(normalRoughnessSRV.Load(int3(uint2(_636, _637), 0u)).w * 3.099999904632568359375f) == 3.0f) {
            frontier_phi_18_17_ladder = _635;
            frontier_phi_18_17_ladder_1 = _204;
            frontier_phi_18_17_ladder_2 = _205;
            frontier_phi_18_17_ladder_3 = _206;
            frontier_phi_18_17_ladder_4 = _633;
            frontier_phi_18_17_ladder_5 = _634;
            frontier_phi_18_17_ladder_6 = 1.0f;
          } else {
            uint _677 = 0u + ((gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 18u)) * 4u);
            uint _683 = 1u + ((gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 18u)) * 4u);
            uint _689 = 2u + ((gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 18u)) * 4u);
            float frontier_phi_18_17_ladder_19_ladder;
            float frontier_phi_18_17_ladder_19_ladder_1;
            float frontier_phi_18_17_ladder_19_ladder_2;
            float frontier_phi_18_17_ladder_19_ladder_3;
            float frontier_phi_18_17_ladder_19_ladder_4;
            float frontier_phi_18_17_ladder_19_ladder_5;
            float frontier_phi_18_17_ladder_19_ladder_6;
            if (_52[3u + ((gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 18u)) * 4u)] < 0.0f) {
              frontier_phi_18_17_ladder_19_ladder = _635;
              frontier_phi_18_17_ladder_19_ladder_1 = _204;
              frontier_phi_18_17_ladder_19_ladder_2 = _205;
              frontier_phi_18_17_ladder_19_ladder_3 = _206;
              frontier_phi_18_17_ladder_19_ladder_4 = _633;
              frontier_phi_18_17_ladder_19_ladder_5 = _634;
              frontier_phi_18_17_ladder_19_ladder_6 = 1.0f;
            } else {
              frontier_phi_18_17_ladder_19_ladder = (_52[_689] * _52[_689]) + _635;
              frontier_phi_18_17_ladder_19_ladder_1 = _52[_677] + _204;
              frontier_phi_18_17_ladder_19_ladder_2 = _52[_683] + _205;
              frontier_phi_18_17_ladder_19_ladder_3 = _52[_689] + _206;
              frontier_phi_18_17_ladder_19_ladder_4 = (_52[_677] * _52[_677]) + _633;
              frontier_phi_18_17_ladder_19_ladder_5 = (_52[_683] * _52[_683]) + _634;
              frontier_phi_18_17_ladder_19_ladder_6 = 2.0f;
            }
            frontier_phi_18_17_ladder = frontier_phi_18_17_ladder_19_ladder;
            frontier_phi_18_17_ladder_1 = frontier_phi_18_17_ladder_19_ladder_1;
            frontier_phi_18_17_ladder_2 = frontier_phi_18_17_ladder_19_ladder_2;
            frontier_phi_18_17_ladder_3 = frontier_phi_18_17_ladder_19_ladder_3;
            frontier_phi_18_17_ladder_4 = frontier_phi_18_17_ladder_19_ladder_4;
            frontier_phi_18_17_ladder_5 = frontier_phi_18_17_ladder_19_ladder_5;
            frontier_phi_18_17_ladder_6 = frontier_phi_18_17_ladder_19_ladder_6;
          }
          _650 = frontier_phi_18_17_ladder_1;
          _652 = frontier_phi_18_17_ladder_2;
          _654 = frontier_phi_18_17_ladder_3;
          _656 = frontier_phi_18_17_ladder_4;
          _658 = frontier_phi_18_17_ladder_5;
          _660 = frontier_phi_18_17_ladder;
          _662 = frontier_phi_18_17_ladder_6;
        } else {
          _650 = _204;
          _652 = _205;
          _654 = _206;
          _656 = _633;
          _658 = _634;
          _660 = _635;
          _662 = 1.0f;
        }
        uint4 _665 = uint4(spec_RT_WIDTH, spec_RT_HEIGHT, asuint(spec_INV_RT_WIDTH), asuint(spec_INV_RT_HEIGHT));
        float _706;
        float _708;
        float _710;
        float _712;
        float _714;
        float _716;
        float _718;
        if ((int(_637) < int(_665.y)) && ((int(_637 | gl_GlobalInvocationID.x) > int(4294967295u)) && (int(gl_GlobalInvocationID.x) < int(_665.x)))) {
          float frontier_phi_21_20_ladder;
          float frontier_phi_21_20_ladder_1;
          float frontier_phi_21_20_ladder_2;
          float frontier_phi_21_20_ladder_3;
          float frontier_phi_21_20_ladder_4;
          float frontier_phi_21_20_ladder_5;
          float frontier_phi_21_20_ladder_6;
          if (floor(normalRoughnessSRV.Load(int3(uint2(gl_GlobalInvocationID.x, _637), 0u)).w * 3.099999904632568359375f) == 3.0f) {
            frontier_phi_21_20_ladder = _650;
            frontier_phi_21_20_ladder_1 = _652;
            frontier_phi_21_20_ladder_2 = _654;
            frontier_phi_21_20_ladder_3 = _656;
            frontier_phi_21_20_ladder_4 = _660;
            frontier_phi_21_20_ladder_5 = _662;
            frontier_phi_21_20_ladder_6 = _658;
          } else {
            uint _735 = gl_LocalInvocationID.x + 1u;
            uint _739 = 0u + ((_735 + (gl_LocalInvocationID.y * 18u)) * 4u);
            uint _745 = 1u + ((_735 + (gl_LocalInvocationID.y * 18u)) * 4u);
            uint _751 = 2u + ((_735 + (gl_LocalInvocationID.y * 18u)) * 4u);
            float frontier_phi_21_20_ladder_23_ladder;
            float frontier_phi_21_20_ladder_23_ladder_1;
            float frontier_phi_21_20_ladder_23_ladder_2;
            float frontier_phi_21_20_ladder_23_ladder_3;
            float frontier_phi_21_20_ladder_23_ladder_4;
            float frontier_phi_21_20_ladder_23_ladder_5;
            float frontier_phi_21_20_ladder_23_ladder_6;
            if (_52[3u + ((_735 + (gl_LocalInvocationID.y * 18u)) * 4u)] < 0.0f) {
              frontier_phi_21_20_ladder_23_ladder = _650;
              frontier_phi_21_20_ladder_23_ladder_1 = _652;
              frontier_phi_21_20_ladder_23_ladder_2 = _654;
              frontier_phi_21_20_ladder_23_ladder_3 = _656;
              frontier_phi_21_20_ladder_23_ladder_4 = _660;
              frontier_phi_21_20_ladder_23_ladder_5 = _662;
              frontier_phi_21_20_ladder_23_ladder_6 = _658;
            } else {
              frontier_phi_21_20_ladder_23_ladder = _52[_739] + _650;
              frontier_phi_21_20_ladder_23_ladder_1 = _52[_745] + _652;
              frontier_phi_21_20_ladder_23_ladder_2 = _52[_751] + _654;
              frontier_phi_21_20_ladder_23_ladder_3 = (_52[_739] * _52[_739]) + _656;
              frontier_phi_21_20_ladder_23_ladder_4 = (_52[_751] * _52[_751]) + _660;
              frontier_phi_21_20_ladder_23_ladder_5 = _662 + 1.0f;
              frontier_phi_21_20_ladder_23_ladder_6 = (_52[_745] * _52[_745]) + _658;
            }
            frontier_phi_21_20_ladder = frontier_phi_21_20_ladder_23_ladder;
            frontier_phi_21_20_ladder_1 = frontier_phi_21_20_ladder_23_ladder_1;
            frontier_phi_21_20_ladder_2 = frontier_phi_21_20_ladder_23_ladder_2;
            frontier_phi_21_20_ladder_3 = frontier_phi_21_20_ladder_23_ladder_3;
            frontier_phi_21_20_ladder_4 = frontier_phi_21_20_ladder_23_ladder_4;
            frontier_phi_21_20_ladder_5 = frontier_phi_21_20_ladder_23_ladder_5;
            frontier_phi_21_20_ladder_6 = frontier_phi_21_20_ladder_23_ladder_6;
          }
          _706 = frontier_phi_21_20_ladder;
          _708 = frontier_phi_21_20_ladder_1;
          _710 = frontier_phi_21_20_ladder_2;
          _712 = frontier_phi_21_20_ladder_3;
          _714 = frontier_phi_21_20_ladder_6;
          _716 = frontier_phi_21_20_ladder_4;
          _718 = frontier_phi_21_20_ladder_5;
        } else {
          _706 = _650;
          _708 = _652;
          _710 = _654;
          _712 = _656;
          _714 = _658;
          _716 = _660;
          _718 = _662;
        }
        uint _720 = gl_GlobalInvocationID.x + 1u;
        uint4 _723 = uint4(spec_RT_WIDTH, spec_RT_HEIGHT, asuint(spec_INV_RT_WIDTH), asuint(spec_INV_RT_HEIGHT));
        float _768;
        float _770;
        float _772;
        float _774;
        float _776;
        float _778;
        float _780;
        if ((int(_637) < int(_723.y)) && ((int(_637 | _720) > int(4294967295u)) && (int(_720) < int(_723.x)))) {
          float frontier_phi_25_24_ladder;
          float frontier_phi_25_24_ladder_1;
          float frontier_phi_25_24_ladder_2;
          float frontier_phi_25_24_ladder_3;
          float frontier_phi_25_24_ladder_4;
          float frontier_phi_25_24_ladder_5;
          float frontier_phi_25_24_ladder_6;
          if (floor(normalRoughnessSRV.Load(int3(uint2(_720, _637), 0u)).w * 3.099999904632568359375f) == 3.0f) {
            frontier_phi_25_24_ladder = _718;
            frontier_phi_25_24_ladder_1 = _716;
            frontier_phi_25_24_ladder_2 = _714;
            frontier_phi_25_24_ladder_3 = _712;
            frontier_phi_25_24_ladder_4 = _710;
            frontier_phi_25_24_ladder_5 = _708;
            frontier_phi_25_24_ladder_6 = _706;
          } else {
            uint _789 = gl_LocalInvocationID.x + 2u;
            uint _793 = 0u + ((_789 + (gl_LocalInvocationID.y * 18u)) * 4u);
            uint _799 = 1u + ((_789 + (gl_LocalInvocationID.y * 18u)) * 4u);
            uint _805 = 2u + ((_789 + (gl_LocalInvocationID.y * 18u)) * 4u);
            float frontier_phi_25_24_ladder_27_ladder;
            float frontier_phi_25_24_ladder_27_ladder_1;
            float frontier_phi_25_24_ladder_27_ladder_2;
            float frontier_phi_25_24_ladder_27_ladder_3;
            float frontier_phi_25_24_ladder_27_ladder_4;
            float frontier_phi_25_24_ladder_27_ladder_5;
            float frontier_phi_25_24_ladder_27_ladder_6;
            if (_52[3u + ((_789 + (gl_LocalInvocationID.y * 18u)) * 4u)] < 0.0f) {
              frontier_phi_25_24_ladder_27_ladder = _718;
              frontier_phi_25_24_ladder_27_ladder_1 = _716;
              frontier_phi_25_24_ladder_27_ladder_2 = _714;
              frontier_phi_25_24_ladder_27_ladder_3 = _712;
              frontier_phi_25_24_ladder_27_ladder_4 = _710;
              frontier_phi_25_24_ladder_27_ladder_5 = _708;
              frontier_phi_25_24_ladder_27_ladder_6 = _706;
            } else {
              frontier_phi_25_24_ladder_27_ladder = _718 + 1.0f;
              frontier_phi_25_24_ladder_27_ladder_1 = (_52[_805] * _52[_805]) + _716;
              frontier_phi_25_24_ladder_27_ladder_2 = (_52[_799] * _52[_799]) + _714;
              frontier_phi_25_24_ladder_27_ladder_3 = (_52[_793] * _52[_793]) + _712;
              frontier_phi_25_24_ladder_27_ladder_4 = _52[_805] + _710;
              frontier_phi_25_24_ladder_27_ladder_5 = _52[_799] + _708;
              frontier_phi_25_24_ladder_27_ladder_6 = _52[_793] + _706;
            }
            frontier_phi_25_24_ladder = frontier_phi_25_24_ladder_27_ladder;
            frontier_phi_25_24_ladder_1 = frontier_phi_25_24_ladder_27_ladder_1;
            frontier_phi_25_24_ladder_2 = frontier_phi_25_24_ladder_27_ladder_2;
            frontier_phi_25_24_ladder_3 = frontier_phi_25_24_ladder_27_ladder_3;
            frontier_phi_25_24_ladder_4 = frontier_phi_25_24_ladder_27_ladder_4;
            frontier_phi_25_24_ladder_5 = frontier_phi_25_24_ladder_27_ladder_5;
            frontier_phi_25_24_ladder_6 = frontier_phi_25_24_ladder_27_ladder_6;
          }
          _768 = frontier_phi_25_24_ladder_6;
          _770 = frontier_phi_25_24_ladder_5;
          _772 = frontier_phi_25_24_ladder_4;
          _774 = frontier_phi_25_24_ladder_3;
          _776 = frontier_phi_25_24_ladder_2;
          _778 = frontier_phi_25_24_ladder_1;
          _780 = frontier_phi_25_24_ladder;
        } else {
          _768 = _706;
          _770 = _708;
          _772 = _710;
          _774 = _712;
          _776 = _714;
          _778 = _716;
          _780 = _718;
        }
        float _784 = exp2(min(1.0f, _612 / _623) * (-10.0f));
        float _785 = _784 + _632;
        float _816;
        float _818;
        float _820;
        float _822;
        float _824;
        float _826;
        float _828;
        uint _830;
        float _847;
        float _849;
        float _851;
        float _853;
        float _855;
        float _857;
        float _859;
        float _815 = _768;
        float _817 = _770;
        float _819 = _772;
        float _821 = _774;
        float _823 = _776;
        float _825 = _778;
        float _827 = _780;
        uint _829 = 4294967295u;
        uint _831;
        bool _842;
        for (;;) {
          _831 = _829 + gl_GlobalInvocationID.x;
          uint4 _834 = uint4(spec_RT_WIDTH, spec_RT_HEIGHT, asuint(spec_INV_RT_WIDTH), asuint(spec_INV_RT_HEIGHT));
          _842 = (int(gl_GlobalInvocationID.y) < int(_834.y)) && ((int(_831 | gl_GlobalInvocationID.y) > int(4294967295u)) && (int(_831) < int(_834.x)));
          if (_842) {
            if (_829 == 0u) {
              _816 = _815;
              _818 = _817;
              _820 = _819;
              _822 = _821;
              _824 = _823;
              _826 = _825;
              _828 = _827;
              _830 = 1u;
              _815 = _816;
              _817 = _818;
              _819 = _820;
              _821 = _822;
              _823 = _824;
              _825 = _826;
              _827 = _828;
              _829 = _830;
              continue;
            }
            float frontier_phi_31_33_ladder;
            float frontier_phi_31_33_ladder_1;
            float frontier_phi_31_33_ladder_2;
            float frontier_phi_31_33_ladder_3;
            float frontier_phi_31_33_ladder_4;
            float frontier_phi_31_33_ladder_5;
            float frontier_phi_31_33_ladder_6;
            if (floor(normalRoughnessSRV.Load(int3(uint2(_831, gl_GlobalInvocationID.y), 0u)).w * 3.099999904632568359375f) == 3.0f) {
              frontier_phi_31_33_ladder = _817;
              frontier_phi_31_33_ladder_1 = _827;
              frontier_phi_31_33_ladder_2 = _825;
              frontier_phi_31_33_ladder_3 = _823;
              frontier_phi_31_33_ladder_4 = _821;
              frontier_phi_31_33_ladder_5 = _819;
              frontier_phi_31_33_ladder_6 = _815;
            } else {
              uint _883 = (gl_LocalInvocationID.x + 1u) + _829;
              uint _884 = gl_LocalInvocationID.y + 1u;
              uint _888 = 0u + ((_883 + (_884 * 18u)) * 4u);
              uint _894 = 1u + ((_883 + (_884 * 18u)) * 4u);
              uint _900 = 2u + ((_883 + (_884 * 18u)) * 4u);
              float frontier_phi_31_33_ladder_35_ladder;
              float frontier_phi_31_33_ladder_35_ladder_1;
              float frontier_phi_31_33_ladder_35_ladder_2;
              float frontier_phi_31_33_ladder_35_ladder_3;
              float frontier_phi_31_33_ladder_35_ladder_4;
              float frontier_phi_31_33_ladder_35_ladder_5;
              float frontier_phi_31_33_ladder_35_ladder_6;
              if (_52[3u + ((_883 + (_884 * 18u)) * 4u)] < 0.0f) {
                frontier_phi_31_33_ladder_35_ladder = _817;
                frontier_phi_31_33_ladder_35_ladder_1 = _827;
                frontier_phi_31_33_ladder_35_ladder_2 = _825;
                frontier_phi_31_33_ladder_35_ladder_3 = _823;
                frontier_phi_31_33_ladder_35_ladder_4 = _821;
                frontier_phi_31_33_ladder_35_ladder_5 = _819;
                frontier_phi_31_33_ladder_35_ladder_6 = _815;
              } else {
                frontier_phi_31_33_ladder_35_ladder = _52[_894] + _817;
                frontier_phi_31_33_ladder_35_ladder_1 = _827 + 1.0f;
                frontier_phi_31_33_ladder_35_ladder_2 = (_52[_900] * _52[_900]) + _825;
                frontier_phi_31_33_ladder_35_ladder_3 = (_52[_894] * _52[_894]) + _823;
                frontier_phi_31_33_ladder_35_ladder_4 = (_52[_888] * _52[_888]) + _821;
                frontier_phi_31_33_ladder_35_ladder_5 = _52[_900] + _819;
                frontier_phi_31_33_ladder_35_ladder_6 = _52[_888] + _815;
              }
              frontier_phi_31_33_ladder = frontier_phi_31_33_ladder_35_ladder;
              frontier_phi_31_33_ladder_1 = frontier_phi_31_33_ladder_35_ladder_1;
              frontier_phi_31_33_ladder_2 = frontier_phi_31_33_ladder_35_ladder_2;
              frontier_phi_31_33_ladder_3 = frontier_phi_31_33_ladder_35_ladder_3;
              frontier_phi_31_33_ladder_4 = frontier_phi_31_33_ladder_35_ladder_4;
              frontier_phi_31_33_ladder_5 = frontier_phi_31_33_ladder_35_ladder_5;
              frontier_phi_31_33_ladder_6 = frontier_phi_31_33_ladder_35_ladder_6;
            }
            _847 = frontier_phi_31_33_ladder_6;
            _849 = frontier_phi_31_33_ladder;
            _851 = frontier_phi_31_33_ladder_5;
            _853 = frontier_phi_31_33_ladder_4;
            _855 = frontier_phi_31_33_ladder_3;
            _857 = frontier_phi_31_33_ladder_2;
            _859 = frontier_phi_31_33_ladder_1;
          } else {
            _847 = _815;
            _849 = _817;
            _851 = _819;
            _853 = _821;
            _855 = _823;
            _857 = _825;
            _859 = _827;
          }
          uint _861 = _829 + 1u;
          if (int(_861) < int(2u)) {
            _816 = _847;
            _818 = _849;
            _820 = _851;
            _822 = _853;
            _824 = _855;
            _826 = _857;
            _828 = _859;
            _830 = _861;
            _815 = _816;
            _817 = _818;
            _819 = _820;
            _821 = _822;
            _823 = _824;
            _825 = _826;
            _827 = _828;
            _829 = _830;
            continue;
          } else {
            break;
          }
        }
        uint _870 = gl_GlobalInvocationID.y + 1u;
        uint4 _873 = uint4(spec_RT_WIDTH, spec_RT_HEIGHT, asuint(spec_INV_RT_WIDTH), asuint(spec_INV_RT_HEIGHT));
        float _917;
        float _919;
        float _921;
        float _923;
        float _925;
        float _927;
        float _929;
        if ((int(_870) < int(_873.y)) && ((int(_870 | _636) > int(4294967295u)) && (int(_636) < int(_873.x)))) {
          float frontier_phi_37_36_ladder;
          float frontier_phi_37_36_ladder_1;
          float frontier_phi_37_36_ladder_2;
          float frontier_phi_37_36_ladder_3;
          float frontier_phi_37_36_ladder_4;
          float frontier_phi_37_36_ladder_5;
          float frontier_phi_37_36_ladder_6;
          if (floor(normalRoughnessSRV.Load(int3(uint2(_636, _870), 0u)).w * 3.099999904632568359375f) == 3.0f) {
            frontier_phi_37_36_ladder = _859;
            frontier_phi_37_36_ladder_1 = _857;
            frontier_phi_37_36_ladder_2 = _855;
            frontier_phi_37_36_ladder_3 = _853;
            frontier_phi_37_36_ladder_4 = _851;
            frontier_phi_37_36_ladder_5 = _849;
            frontier_phi_37_36_ladder_6 = _847;
          } else {
            uint _945 = gl_LocalInvocationID.y + 2u;
            uint _949 = 0u + ((gl_LocalInvocationID.x + (_945 * 18u)) * 4u);
            uint _955 = 1u + ((gl_LocalInvocationID.x + (_945 * 18u)) * 4u);
            uint _961 = 2u + ((gl_LocalInvocationID.x + (_945 * 18u)) * 4u);
            float frontier_phi_37_36_ladder_39_ladder;
            float frontier_phi_37_36_ladder_39_ladder_1;
            float frontier_phi_37_36_ladder_39_ladder_2;
            float frontier_phi_37_36_ladder_39_ladder_3;
            float frontier_phi_37_36_ladder_39_ladder_4;
            float frontier_phi_37_36_ladder_39_ladder_5;
            float frontier_phi_37_36_ladder_39_ladder_6;
            if (_52[3u + ((gl_LocalInvocationID.x + (_945 * 18u)) * 4u)] < 0.0f) {
              frontier_phi_37_36_ladder_39_ladder = _859;
              frontier_phi_37_36_ladder_39_ladder_1 = _857;
              frontier_phi_37_36_ladder_39_ladder_2 = _855;
              frontier_phi_37_36_ladder_39_ladder_3 = _853;
              frontier_phi_37_36_ladder_39_ladder_4 = _851;
              frontier_phi_37_36_ladder_39_ladder_5 = _849;
              frontier_phi_37_36_ladder_39_ladder_6 = _847;
            } else {
              frontier_phi_37_36_ladder_39_ladder = _859 + 1.0f;
              frontier_phi_37_36_ladder_39_ladder_1 = (_52[_961] * _52[_961]) + _857;
              frontier_phi_37_36_ladder_39_ladder_2 = (_52[_955] * _52[_955]) + _855;
              frontier_phi_37_36_ladder_39_ladder_3 = (_52[_949] * _52[_949]) + _853;
              frontier_phi_37_36_ladder_39_ladder_4 = _52[_961] + _851;
              frontier_phi_37_36_ladder_39_ladder_5 = _52[_955] + _849;
              frontier_phi_37_36_ladder_39_ladder_6 = _52[_949] + _847;
            }
            frontier_phi_37_36_ladder = frontier_phi_37_36_ladder_39_ladder;
            frontier_phi_37_36_ladder_1 = frontier_phi_37_36_ladder_39_ladder_1;
            frontier_phi_37_36_ladder_2 = frontier_phi_37_36_ladder_39_ladder_2;
            frontier_phi_37_36_ladder_3 = frontier_phi_37_36_ladder_39_ladder_3;
            frontier_phi_37_36_ladder_4 = frontier_phi_37_36_ladder_39_ladder_4;
            frontier_phi_37_36_ladder_5 = frontier_phi_37_36_ladder_39_ladder_5;
            frontier_phi_37_36_ladder_6 = frontier_phi_37_36_ladder_39_ladder_6;
          }
          _917 = frontier_phi_37_36_ladder_6;
          _919 = frontier_phi_37_36_ladder_5;
          _921 = frontier_phi_37_36_ladder_4;
          _923 = frontier_phi_37_36_ladder_3;
          _925 = frontier_phi_37_36_ladder_2;
          _927 = frontier_phi_37_36_ladder_1;
          _929 = frontier_phi_37_36_ladder;
        } else {
          _917 = _847;
          _919 = _849;
          _921 = _851;
          _923 = _853;
          _925 = _855;
          _927 = _857;
          _929 = _859;
        }
        uint4 _933 = uint4(spec_RT_WIDTH, spec_RT_HEIGHT, asuint(spec_INV_RT_WIDTH), asuint(spec_INV_RT_HEIGHT));
        float _978;
        float _980;
        float _982;
        float _984;
        float _986;
        float _988;
        float _990;
        if ((int(_870) < int(_933.y)) && ((int(_870 | gl_GlobalInvocationID.x) > int(4294967295u)) && (int(gl_GlobalInvocationID.x) < int(_933.x)))) {
          float frontier_phi_41_40_ladder;
          float frontier_phi_41_40_ladder_1;
          float frontier_phi_41_40_ladder_2;
          float frontier_phi_41_40_ladder_3;
          float frontier_phi_41_40_ladder_4;
          float frontier_phi_41_40_ladder_5;
          float frontier_phi_41_40_ladder_6;
          if (floor(normalRoughnessSRV.Load(int3(uint2(gl_GlobalInvocationID.x, _870), 0u)).w * 3.099999904632568359375f) == 3.0f) {
            frontier_phi_41_40_ladder = _929;
            frontier_phi_41_40_ladder_1 = _917;
            frontier_phi_41_40_ladder_2 = _919;
            frontier_phi_41_40_ladder_3 = _921;
            frontier_phi_41_40_ladder_4 = _923;
            frontier_phi_41_40_ladder_5 = _925;
            frontier_phi_41_40_ladder_6 = _927;
          } else {
            uint _1006 = gl_LocalInvocationID.x + 1u;
            uint _1007 = gl_LocalInvocationID.y + 2u;
            uint _1011 = 0u + ((_1006 + (_1007 * 18u)) * 4u);
            uint _1017 = 1u + ((_1006 + (_1007 * 18u)) * 4u);
            uint _1023 = 2u + ((_1006 + (_1007 * 18u)) * 4u);
            float frontier_phi_41_40_ladder_43_ladder;
            float frontier_phi_41_40_ladder_43_ladder_1;
            float frontier_phi_41_40_ladder_43_ladder_2;
            float frontier_phi_41_40_ladder_43_ladder_3;
            float frontier_phi_41_40_ladder_43_ladder_4;
            float frontier_phi_41_40_ladder_43_ladder_5;
            float frontier_phi_41_40_ladder_43_ladder_6;
            if (_52[3u + ((_1006 + (_1007 * 18u)) * 4u)] < 0.0f) {
              frontier_phi_41_40_ladder_43_ladder = _929;
              frontier_phi_41_40_ladder_43_ladder_1 = _917;
              frontier_phi_41_40_ladder_43_ladder_2 = _919;
              frontier_phi_41_40_ladder_43_ladder_3 = _921;
              frontier_phi_41_40_ladder_43_ladder_4 = _923;
              frontier_phi_41_40_ladder_43_ladder_5 = _925;
              frontier_phi_41_40_ladder_43_ladder_6 = _927;
            } else {
              frontier_phi_41_40_ladder_43_ladder = _929 + 1.0f;
              frontier_phi_41_40_ladder_43_ladder_1 = _52[_1011] + _917;
              frontier_phi_41_40_ladder_43_ladder_2 = _52[_1017] + _919;
              frontier_phi_41_40_ladder_43_ladder_3 = _52[_1023] + _921;
              frontier_phi_41_40_ladder_43_ladder_4 = (_52[_1011] * _52[_1011]) + _923;
              frontier_phi_41_40_ladder_43_ladder_5 = (_52[_1017] * _52[_1017]) + _925;
              frontier_phi_41_40_ladder_43_ladder_6 = (_52[_1023] * _52[_1023]) + _927;
            }
            frontier_phi_41_40_ladder = frontier_phi_41_40_ladder_43_ladder;
            frontier_phi_41_40_ladder_1 = frontier_phi_41_40_ladder_43_ladder_1;
            frontier_phi_41_40_ladder_2 = frontier_phi_41_40_ladder_43_ladder_2;
            frontier_phi_41_40_ladder_3 = frontier_phi_41_40_ladder_43_ladder_3;
            frontier_phi_41_40_ladder_4 = frontier_phi_41_40_ladder_43_ladder_4;
            frontier_phi_41_40_ladder_5 = frontier_phi_41_40_ladder_43_ladder_5;
            frontier_phi_41_40_ladder_6 = frontier_phi_41_40_ladder_43_ladder_6;
          }
          _978 = frontier_phi_41_40_ladder_1;
          _980 = frontier_phi_41_40_ladder_2;
          _982 = frontier_phi_41_40_ladder_3;
          _984 = frontier_phi_41_40_ladder_4;
          _986 = frontier_phi_41_40_ladder_5;
          _988 = frontier_phi_41_40_ladder_6;
          _990 = frontier_phi_41_40_ladder;
        } else {
          _978 = _917;
          _980 = _919;
          _982 = _921;
          _984 = _923;
          _986 = _925;
          _988 = _927;
          _990 = _929;
        }
        uint4 _994 = uint4(spec_RT_WIDTH, spec_RT_HEIGHT, asuint(spec_INV_RT_WIDTH), asuint(spec_INV_RT_HEIGHT));
        float _1040;
        float _1042;
        float _1044;
        float _1046;
        float _1048;
        float _1050;
        float _1052;
        if ((int(_870) < int(_994.y)) && ((int(_870 | _720) > int(4294967295u)) && (int(_720) < int(_994.x)))) {
          float frontier_phi_45_44_ladder;
          float frontier_phi_45_44_ladder_1;
          float frontier_phi_45_44_ladder_2;
          float frontier_phi_45_44_ladder_3;
          float frontier_phi_45_44_ladder_4;
          float frontier_phi_45_44_ladder_5;
          float frontier_phi_45_44_ladder_6;
          if (floor(normalRoughnessSRV.Load(int3(uint2(_720, _870), 0u)).w * 3.099999904632568359375f) == 3.0f) {
            frontier_phi_45_44_ladder = _982;
            frontier_phi_45_44_ladder_1 = _978;
            frontier_phi_45_44_ladder_2 = _980;
            frontier_phi_45_44_ladder_3 = _984;
            frontier_phi_45_44_ladder_4 = _986;
            frontier_phi_45_44_ladder_5 = _988;
            frontier_phi_45_44_ladder_6 = _990;
          } else {
            uint _1133 = gl_LocalInvocationID.x + 2u;
            uint _1134 = gl_LocalInvocationID.y + 2u;
            uint _1138 = 0u + ((_1133 + (_1134 * 18u)) * 4u);
            uint _1144 = 1u + ((_1133 + (_1134 * 18u)) * 4u);
            uint _1150 = 2u + ((_1133 + (_1134 * 18u)) * 4u);
            float frontier_phi_45_44_ladder_47_ladder;
            float frontier_phi_45_44_ladder_47_ladder_1;
            float frontier_phi_45_44_ladder_47_ladder_2;
            float frontier_phi_45_44_ladder_47_ladder_3;
            float frontier_phi_45_44_ladder_47_ladder_4;
            float frontier_phi_45_44_ladder_47_ladder_5;
            float frontier_phi_45_44_ladder_47_ladder_6;
            if (_52[3u + ((_1133 + (_1134 * 18u)) * 4u)] < 0.0f) {
              frontier_phi_45_44_ladder_47_ladder = _982;
              frontier_phi_45_44_ladder_47_ladder_1 = _978;
              frontier_phi_45_44_ladder_47_ladder_2 = _980;
              frontier_phi_45_44_ladder_47_ladder_3 = _984;
              frontier_phi_45_44_ladder_47_ladder_4 = _986;
              frontier_phi_45_44_ladder_47_ladder_5 = _988;
              frontier_phi_45_44_ladder_47_ladder_6 = _990;
            } else {
              frontier_phi_45_44_ladder_47_ladder = _52[_1150] + _982;
              frontier_phi_45_44_ladder_47_ladder_1 = _52[_1138] + _978;
              frontier_phi_45_44_ladder_47_ladder_2 = _52[_1144] + _980;
              frontier_phi_45_44_ladder_47_ladder_3 = (_52[_1138] * _52[_1138]) + _984;
              frontier_phi_45_44_ladder_47_ladder_4 = (_52[_1144] * _52[_1144]) + _986;
              frontier_phi_45_44_ladder_47_ladder_5 = (_52[_1150] * _52[_1150]) + _988;
              frontier_phi_45_44_ladder_47_ladder_6 = _990 + 1.0f;
            }
            frontier_phi_45_44_ladder = frontier_phi_45_44_ladder_47_ladder;
            frontier_phi_45_44_ladder_1 = frontier_phi_45_44_ladder_47_ladder_1;
            frontier_phi_45_44_ladder_2 = frontier_phi_45_44_ladder_47_ladder_2;
            frontier_phi_45_44_ladder_3 = frontier_phi_45_44_ladder_47_ladder_3;
            frontier_phi_45_44_ladder_4 = frontier_phi_45_44_ladder_47_ladder_4;
            frontier_phi_45_44_ladder_5 = frontier_phi_45_44_ladder_47_ladder_5;
            frontier_phi_45_44_ladder_6 = frontier_phi_45_44_ladder_47_ladder_6;
          }
          _1040 = frontier_phi_45_44_ladder_1;
          _1042 = frontier_phi_45_44_ladder_2;
          _1044 = frontier_phi_45_44_ladder;
          _1046 = frontier_phi_45_44_ladder_3;
          _1048 = frontier_phi_45_44_ladder_4;
          _1050 = frontier_phi_45_44_ladder_5;
          _1052 = frontier_phi_45_44_ladder_6;
        } else {
          _1040 = _978;
          _1042 = _980;
          _1044 = _982;
          _1046 = _984;
          _1048 = _986;
          _1050 = _988;
          _1052 = _990;
        }
        uint2 _1061 = specularMomentSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
        uint _1063 = _1061.x;
        uint _1064 = _1061.y;
        float _1071 = exp2(float(int((_1063 >> 27u) + 4294967281u))) * 0.00390625f;
        float _1089 = (float(_1063 & 255u) * _1071) * (((_1063 & 256u) != 0u) ? (-1.0f) : 1.0f);
        float _1094 = (float((_1063 >> 9u) & 255u) * _1071) * (((_1063 & 131072u) != 0u) ? (-1.0f) : 1.0f);
        float _1099 = (float((_1063 >> 18u) & 255u) * _1071) * (((_1063 & 67108864u) != 0u) ? (-1.0f) : 1.0f);
        float _1104 = exp2(float(int((_1064 >> 27u) + 4294967281u))) * 0.00390625f;
        float _1119 = (float(_1064 & 255u) * _1104) * (((_1064 & 256u) != 0u) ? (-1.0f) : 1.0f);
        float _1123 = (float((_1064 >> 9u) & 255u) * _1104) * (((_1064 & 131072u) != 0u) ? (-1.0f) : 1.0f);
        float _1127 = (float((_1064 >> 18u) & 255u) * _1104) * (((_1064 & 67108864u) != 0u) ? (-1.0f) : 1.0f);
        float _1129 = (_1040 / _1052) - _1089;
        float _1160;
        if ((abs(_396) + abs(_393)) > 1.0f) {
          _1160 = 1.0f;
        } else {
          float _1284 = saturate((_175.z + (-0.039999999105930328369140625f)) / (specularRoughnessThreshold + (-0.039999999105930328369140625f)));
          _1160 = (((_1284 * _1284) * (3.0f - (_1284 * 2.0f))) * (min(0.25f, saturate(1.0f - (0.000977517105638980865478515625f / abs(_1129)))) + (-1.0f))) + 1.0f;
        }
        float _1167 = (_1160 * _1129) + _1089;
        float _1168 = (_1160 * ((_1042 / _1052) - _1094)) + _1094;
        float _1169 = (_1160 * ((_1044 / _1052) - _1099)) + _1099;
        float _1176 = (_1160 * ((_1046 / _1052) - _1119)) + _1119;
        float _1177 = (_1160 * ((_1048 / _1052) - _1123)) + _1123;
        float _1178 = (_1160 * ((_1050 / _1052) - _1127)) + _1127;
        float _1188 = sqrt(max(0.0f, _1176 - (_1167 * _1167)));
        float _1189 = sqrt(max(0.0f, _1177 - (_1168 * _1168)));
        float _1190 = sqrt(max(0.0f, _1178 - (_1169 * _1169)));
        float _1200 = 5.0f - (saturate(sqrt((_390 * _390) + (_391 * _391)) * 20.0f) * 3.75f);
        float _1202 = _1200 * _1188;
        float _1203 = _1200 * _1189;
        float _1204 = _1200 * _1190;
        float _1205 = _1167 - _1202;
        float _1206 = _1168 - _1203;
        float _1207 = _1169 - _1204;
        float _1208 = _1202 + _1167;
        float _1209 = _1203 + _1168;
        float _1210 = _1204 + _1169;
        float _1238 = saturate(((abs(_465 - _1167) / _1188) + (-1.0f)) * 0.5f);
        float _1239 = saturate(((abs(_466 - _1168) / _1189) + (-1.0f)) * 0.5f);
        float _1240 = saturate(((abs(_467 - _1169) / _1190) + (-1.0f)) * 0.5f);
        float _1251 = (3.0f - (_1238 * 2.0f)) * (_1238 * _1238);
        float _1254 = (3.0f - (_1239 * 2.0f)) * (_1239 * _1239);
        float _1257 = (3.0f - (_1240 * 2.0f)) * (_1240 * _1240);
        float _1259 = (_1251 * (min(max(_465, _1205), _1208) - _465)) + _465;
        float _1260 = (_1254 * (min(max(_466, _1206), _1209) - _466)) + _466;
        float _1261 = (_1257 * (min(max(_467, _1207), _1210) - _467)) + _467;
        float _1271 = abs(_1167);
        float _1272 = abs(_1168);
        float _1273 = abs(_1169);
        float _1275 = max(max(_1271, _1272), _1273);
        uint _1300;
        if (_1275 == 0.0f) {
          _1300 = 0u;
        } else {
          float _1309 = ceil(log2(_1275));
          float _1313 = exp2((-0.0f) - _1309) * 256.0f;
          _1300 = (((((((_1167 < 0.0f) ? 256u : 0u) | ((_1168 < 0.0f) ? 131072u : 0u)) | ((_1169 < 0.0f) ? 67108864u : 0u)) | min(255u, uint(round(_1313 * _1271)))) | (min(255u, uint(round(_1313 * _1272))) << 9u)) | (min(255u, uint(round(_1313 * _1273))) << 18u)) | (uint(min(max(_1309 + 15.0f, 0.0f), 31.0f)) << 27u);
        }
        float _1302 = abs(_1176);
        float _1303 = abs(_1177);
        float _1304 = abs(_1178);
        float _1306 = max(max(_1302, _1303), _1304);
        uint _1347;
        if (_1306 == 0.0f) {
          _1347 = 0u;
        } else {
          float _1354 = ceil(log2(_1306));
          float _1357 = exp2((-0.0f) - _1354) * 256.0f;
          _1347 = (((((((_1176 < 0.0f) ? 256u : 0u) | ((_1177 < 0.0f) ? 131072u : 0u)) | ((_1178 < 0.0f) ? 67108864u : 0u)) | min(255u, uint(round(_1357 * _1302)))) | (min(255u, uint(round(_1357 * _1303))) << 9u)) | (min(255u, uint(round(_1357 * _1304))) << 18u)) | (uint(min(max(_1354 + 15.0f, 0.0f), 31.0f)) << 27u);
        }
        specularMomentUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = uint2(_1300, _1347);
        float _1404;
        float _1405;
        float _1406;
        float _1407;
        if (_785 > 9.9999997473787516355514526367188e-05f) {
          _1404 = ((((_1251 * (min(max(_595, _1205), _1208) - _595)) + _595) * _632) + (_1259 * _784)) / _785;
          _1405 = ((((_1254 * (min(max(_598, _1206), _1209) - _598)) + _598) * _632) + (_1260 * _784)) / _785;
          _1406 = ((((_1257 * (min(max(_601, _1207), _1210) - _601)) + _601) * _632) + (_1261 * _784)) / _785;
          _1407 = ((_784 * _468) + (_632 * ((((_575 * _547) + (_574 * _553)) + (_576 * _541)) + (_577 * _535)))) / _785;
        } else {
          _1404 = _1259;
          _1405 = _1260;
          _1406 = _1261;
          _1407 = _468;
        }
        float4 _1409 = historyCountSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
        float _1411 = _1409.x;
        float _1414 = 1.0f / _1411;
        float _1427;
        float _1428;
        float _1429;
        float _1430;
        if (_566 > 0.00999999977648258209228515625f) {
          _1427 = (_1414 * (_204 - _1404)) + _1404;
          _1428 = (_1414 * (_205 - _1405)) + _1405;
          _1429 = (_1414 * (_206 - _1406)) + _1406;
          _1430 = (_1414 * (_207 - _1407)) + _1407;
        } else {
          _1427 = _204;
          _1428 = _205;
          _1429 = _206;
          _1430 = _207;
        }
        historyCountUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = _1411;
        specularHistoryColorUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(_1427, _1428, _1429, _1430);
      }
    } else {
      specularHistoryColorUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(specularHistoryColorUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)].xyz, -1.0f);
    }
  }
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  gl_LocalInvocationIndex = stage_input.gl_LocalInvocationIndex;
  comp_main();
}
