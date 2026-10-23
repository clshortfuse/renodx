#include "../denoising.hlsli"

cbuffer RayTracingDenoiserConstantBufferInfo : register(b0, space0) {
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
Texture2D<float4> weightSRV : register(t1);
Texture2D<float2> surfaceMotionSRV : register(t2);
Texture2D<float2> diffuseMomentSRV : register(t3);
Texture2D<float4> diffuseColorSRV : register(t4);
Texture2D<float4> diffuseSHSRV : register(t5);
Texture2D<float4> diffuseHistoryColorSRV : register(t6);
Texture2D<float4> diffuseHistorySHSRV : register(t7);
Texture2D<float> historyCountSRV : register(t8);
RWTexture2D<float2> diffuseMomentUAV : register(u0);
RWTexture2D<float4> diffuseHistoryColorUAV : register(u1);
RWTexture2D<float4> diffuseHistorySHUAV : register(u2);
RWTexture2D<float> historyCountUAV : register(u3);

static uint3 gl_LocalInvocationID;
static uint3 gl_GlobalInvocationID;
static uint gl_LocalInvocationIndex;
struct SPIRV_Cross_Input {
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
  uint gl_LocalInvocationIndex : SV_GroupIndex;
};

groupshared float _33[324];

void comp_main() {
  uint _53 = (gl_GlobalInvocationID.x - gl_LocalInvocationID.x) + 4294967295u;
  uint _55 = (gl_GlobalInvocationID.y - gl_LocalInvocationID.y) + 4294967295u;
  float _59 = (float(int(gl_LocalInvocationIndex)) + 0.5f) * 0.0555555559694766998291015625f;
  uint _65 = uint(int(frac(_59) * 18.0f));
  uint _66 = uint(int(_59));
  if (int(_66) < int(14u)) {
    _33[_65 + (_66 * 18u)] = diffuseColorSRV.Load(int3(uint2(_65 + _53, _66 + _55), 0u)).x;
  }
  uint _82 = _66 + 14u;
  if (int(_82) < int(18u)) {
    _33[_65 + (_82 * 18u)] = diffuseColorSRV.Load(int3(uint2(_65 + _53, _82 + _55), 0u)).x;
  }
  GroupMemoryBarrierWithGroupSync();
  uint4 _99 = uint4(diff_RT_WIDTH, diff_RT_HEIGHT, asuint(diff_INV_RT_WIDTH), asuint(diff_INV_RT_HEIGHT));
  uint _100 = _99.x;
  uint _101 = _99.y;
  if ((int(gl_GlobalInvocationID.y) < int(_101)) && ((int(gl_GlobalInvocationID.y | gl_GlobalInvocationID.x) > int(4294967295u)) && (int(gl_GlobalInvocationID.x) < int(_100)))) {
    uint2 pixel = gl_GlobalInvocationID.xy;
    if (!(depthSRV.Load(int3(pixel, 0u)).x <= 0.0f)) {
      if (RT_SKIP_TEMPORAL_ACCUMULATION) {
        float4 currentColor = diffuseColorSRV.Load(int3(pixel, 0u));
        diffuseMomentUAV[pixel] = float2(currentColor.x, currentColor.x * currentColor.x);
        diffuseHistoryColorUAV[pixel] = currentColor;
        diffuseHistorySHUAV[pixel] = diffuseSHSRV.Load(int3(pixel, 0u));
        historyCountUAV[pixel] = 1.0f;
        return;
      }

      float2 _115 = surfaceMotionSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
      float _125 = (_115.x * float(_100)) + float(int(gl_GlobalInvocationID.x));
      float _126 = (_115.y * float(_101)) + float(int(gl_GlobalInvocationID.y));
      float _127 = floor(_125);
      float _128 = floor(_126);
      uint _132 = uint(int(_127));
      uint _133 = uint(int(_128));
      uint _134 = uint(int(_127 + 1.0f));
      uint _135 = uint(int(_128 + 1.0f));
      float4 _137 = weightSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
      float _139 = _137.x;
      float _143 = dot(float4(_139, _137.yzw), 1.0f.xxxx);
      float4 _147 = historyCountSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
      float _149 = _147.x;
      float4 _151 = diffuseColorSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
      float _153 = _151.x;
      float _154 = _151.y;
      float _155 = _151.z;
      float _156 = _151.w;
      float4 _158 = diffuseSHSRV.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
      float _160 = _158.x;
      float _161 = _158.y;
      float _162 = _158.z;
      float _163 = _158.w;
      float _298;
      float _300;
      float _302;
      float _304;
      float _306;
      float _308;
      float _310;
      float _312;
      float _314;
      if (_143 > 0.00999999977648258209228515625f) {
        float _170 = saturate(_139 / _143);
        float _171 = saturate(_137.y / _143);
        float _172 = saturate(_137.z / _143);
        float _173 = saturate(_137.w / _143);
        float4 _175 = diffuseHistoryColorSRV.Load(int3(uint2(_132, _133), 0u));
        float4 _181 = diffuseHistoryColorSRV.Load(int3(uint2(_134, _133), 0u));
        float4 _187 = diffuseHistoryColorSRV.Load(int3(uint2(_132, _135), 0u));
        float4 _193 = diffuseHistoryColorSRV.Load(int3(uint2(_134, _135), 0u));
        float4 _200 = diffuseHistorySHSRV.Load(int3(uint2(_132, _133), 0u));
        float4 _206 = diffuseHistorySHSRV.Load(int3(uint2(_134, _133), 0u));
        float4 _212 = diffuseHistorySHSRV.Load(int3(uint2(_132, _135), 0u));
        float4 _218 = diffuseHistorySHSRV.Load(int3(uint2(_134, _135), 0u));
        float _283 = compressEV * ((((_181.x * _171) + (_175.x * _170)) + (_187.x * _172)) + (_193.x * _173));
        float _284 = compressEV * ((((_181.y * _171) + (_175.y * _170)) + (_187.y * _172)) + (_193.y * _173));
        float _285 = compressEV * ((((_181.z * _171) + (_175.z * _170)) + (_187.z * _172)) + (_193.z * _173));
        float _286 = compressEV * ((((_181.w * _171) + (_175.w * _170)) + (_187.w * _172)) + (_193.w * _173));
        float _287 = ((((_206.x * _171) + (_200.x * _170)) + (_212.x * _172)) + (_218.x * _173)) * compressEV;
        float _288 = ((((_206.y * _171) + (_200.y * _170)) + (_212.y * _172)) + (_218.y * _173)) * compressEV;
        float _289 = ((((_206.z * _171) + (_200.z * _170)) + (_212.z * _172)) + (_218.z * _173)) * compressEV;
        float _290 = ((((_206.w * _171) + (_200.w * _170)) + (_212.w * _172)) + (_218.w * _173)) * compressEV;
        float _332;
        float _333;
        float _334;
        float _335;
        if (((isnan(_283) || isnan(_284)) || isnan(_285)) || isnan(_286)) {
          _332 = 0.0f;
          _333 = 0.0f;
          _334 = 0.0f;
          _335 = 0.0f;
        } else {
          float frontier_phi_12_11_ladder;
          float frontier_phi_12_11_ladder_1;
          float frontier_phi_12_11_ladder_2;
          float frontier_phi_12_11_ladder_3;
          if (((isinf(_283) || isinf(_284)) || isinf(_285)) || isinf(_286)) {
            frontier_phi_12_11_ladder = 0.0f;
            frontier_phi_12_11_ladder_1 = 0.0f;
            frontier_phi_12_11_ladder_2 = 0.0f;
            frontier_phi_12_11_ladder_3 = 0.0f;
          } else {
            frontier_phi_12_11_ladder = _286;
            frontier_phi_12_11_ladder_1 = _285;
            frontier_phi_12_11_ladder_2 = _284;
            frontier_phi_12_11_ladder_3 = _283;
          }
          _332 = frontier_phi_12_11_ladder_3;
          _333 = frontier_phi_12_11_ladder_2;
          _334 = frontier_phi_12_11_ladder_1;
          _335 = frontier_phi_12_11_ladder;
        }
        float _350;
        float _351;
        float _352;
        float _353;
        if (((isnan(_287) || isnan(_288)) || isnan(_289)) || isnan(_290)) {
          _350 = 0.0f;
          _351 = 0.0f;
          _352 = 0.0f;
          _353 = 0.0f;
        } else {
          float frontier_phi_15_14_ladder;
          float frontier_phi_15_14_ladder_1;
          float frontier_phi_15_14_ladder_2;
          float frontier_phi_15_14_ladder_3;
          if (((isinf(_287) || isinf(_288)) || isinf(_289)) || isinf(_290)) {
            frontier_phi_15_14_ladder = 0.0f;
            frontier_phi_15_14_ladder_1 = 0.0f;
            frontier_phi_15_14_ladder_2 = 0.0f;
            frontier_phi_15_14_ladder_3 = 0.0f;
          } else {
            frontier_phi_15_14_ladder = _290;
            frontier_phi_15_14_ladder_1 = _289;
            frontier_phi_15_14_ladder_2 = _288;
            frontier_phi_15_14_ladder_3 = _287;
          }
          _350 = frontier_phi_15_14_ladder_3;
          _351 = frontier_phi_15_14_ladder_2;
          _352 = frontier_phi_15_14_ladder_1;
          _353 = frontier_phi_15_14_ladder;
        }
        float _354 = _153 * _153;
        uint _355 = gl_GlobalInvocationID.x + 4294967295u;
        uint _356 = gl_GlobalInvocationID.y + 4294967295u;
        float _370;
        float _371;
        float _372;
        if ((int(_356) < int(_101)) && ((int(_356 | _355) > int(4294967295u)) && (int(_355) < int(_100)))) {
          uint _364 = gl_LocalInvocationID.x + (gl_LocalInvocationID.y * 18u);
          _370 = _33[_364] + _153;
          _371 = (_33[_364] * _33[_364]) + _354;
          _372 = 2.0f;
        } else {
          _370 = _153;
          _371 = _354;
          _372 = 1.0f;
        }
        uint4 _376 = uint4(diff_RT_WIDTH, diff_RT_HEIGHT, asuint(diff_INV_RT_WIDTH), asuint(diff_INV_RT_HEIGHT));
        float _394;
        float _395;
        float _396;
        if ((int(_356) < int(_376.y)) && ((int(_356 | gl_GlobalInvocationID.x) > int(4294967295u)) && (int(gl_GlobalInvocationID.x) < int(_376.x)))) {
          uint _387 = (gl_LocalInvocationID.x + 1u) + (gl_LocalInvocationID.y * 18u);
          _394 = _33[_387] + _370;
          _395 = (_33[_387] * _33[_387]) + _371;
          _396 = _372 + 1.0f;
        } else {
          _394 = _370;
          _395 = _371;
          _396 = _372;
        }
        uint _397 = gl_GlobalInvocationID.x + 1u;
        uint4 _400 = uint4(diff_RT_WIDTH, diff_RT_HEIGHT, asuint(diff_INV_RT_WIDTH), asuint(diff_INV_RT_HEIGHT));
        float _418;
        float _419;
        float _420;
        if ((int(_356) < int(_400.y)) && ((int(_356 | _397) > int(4294967295u)) && (int(_397) < int(_400.x)))) {
          uint _411 = (gl_LocalInvocationID.x + 2u) + (gl_LocalInvocationID.y * 18u);
          _418 = _33[_411] + _394;
          _419 = (_33[_411] * _33[_411]) + _395;
          _420 = _396 + 1.0f;
        } else {
          _418 = _394;
          _419 = _395;
          _420 = _396;
        }
        float _430;
        float _431;
        float _432;
        float _421 = _418;
        float _422;
        float _423 = _419;
        float _424;
        float _425 = _420;
        float _426;
        uint _427 = 4294967295u;
        uint _428;
        for (;;) {
          if (_427 == 0u) {
            _422 = _421;
            _424 = _423;
            _426 = _425;
            _428 = 1u;
            _421 = _422;
            _423 = _424;
            _425 = _426;
            _427 = _428;
            continue;
          } else {
            uint _434 = _427 + gl_GlobalInvocationID.x;
            uint4 _437 = uint4(diff_RT_WIDTH, diff_RT_HEIGHT, asuint(diff_INV_RT_WIDTH), asuint(diff_INV_RT_HEIGHT));
            if ((int(gl_GlobalInvocationID.y) < int(_437.y)) && ((int(_434 | gl_GlobalInvocationID.y) > int(4294967295u)) && (int(_434) < int(_437.x)))) {
              uint _450 = ((gl_LocalInvocationID.x + 1u) + _427) + ((gl_LocalInvocationID.y + 1u) * 18u);
              _430 = _33[_450] + _421;
              _431 = (_33[_450] * _33[_450]) + _423;
              _432 = _425 + 1.0f;
            } else {
              _430 = _421;
              _431 = _423;
              _432 = _425;
            }
            uint _433 = _427 + 1u;
            if (int(_433) < int(2u)) {
              _422 = _430;
              _424 = _431;
              _426 = _432;
              _428 = _433;
              _421 = _422;
              _423 = _424;
              _425 = _426;
              _427 = _428;
              continue;
            } else {
              break;
            }
          }
        }
        uint _458 = gl_GlobalInvocationID.y + 1u;
        uint4 _461 = uint4(diff_RT_WIDTH, diff_RT_HEIGHT, asuint(diff_INV_RT_WIDTH), asuint(diff_INV_RT_HEIGHT));
        float _479;
        float _480;
        float _481;
        if ((int(_458) < int(_461.y)) && ((int(_458 | _355) > int(4294967295u)) && (int(_355) < int(_461.x)))) {
          uint _472 = gl_LocalInvocationID.x + ((gl_LocalInvocationID.y + 2u) * 18u);
          _479 = _33[_472] + _430;
          _480 = (_33[_472] * _33[_472]) + _431;
          _481 = _432 + 1.0f;
        } else {
          _479 = _430;
          _480 = _431;
          _481 = _432;
        }
        uint4 _484 = uint4(diff_RT_WIDTH, diff_RT_HEIGHT, asuint(diff_INV_RT_WIDTH), asuint(diff_INV_RT_HEIGHT));
        float _503;
        float _504;
        float _505;
        if ((int(_458) < int(_484.y)) && ((int(_458 | gl_GlobalInvocationID.x) > int(4294967295u)) && (int(gl_GlobalInvocationID.x) < int(_484.x)))) {
          uint _496 = (gl_LocalInvocationID.x + 1u) + ((gl_LocalInvocationID.y + 2u) * 18u);
          _503 = _33[_496] + _479;
          _504 = (_33[_496] * _33[_496]) + _480;
          _505 = _481 + 1.0f;
        } else {
          _503 = _479;
          _504 = _480;
          _505 = _481;
        }
        uint4 _508 = uint4(diff_RT_WIDTH, diff_RT_HEIGHT, asuint(diff_INV_RT_WIDTH), asuint(diff_INV_RT_HEIGHT));
        float _527;
        float _528;
        float _529;
        if ((int(_458) < int(_508.y)) && ((int(_458 | _397) > int(4294967295u)) && (int(_397) < int(_508.x)))) {
          uint _520 = (gl_LocalInvocationID.x + 2u) + ((gl_LocalInvocationID.y + 2u) * 18u);
          _527 = _33[_520] + _503;
          _528 = (_33[_520] * _33[_520]) + _504;
          _529 = _505 + 1.0f;
        } else {
          _527 = _503;
          _528 = _504;
          _529 = _505;
        }
        float2 _535 = diffuseMomentSRV.Load(int3(uint2(uint(_125), uint(_126)), 0u));
        float _537 = _535.x;
        float _538 = _535.y;
        float _539 = (_527 / _529) - _537;
        float _545 = min(0.125f, saturate(1.0f - (0.000977517105638980865478515625f / abs(_539))));
        float _550 = (_545 * _539) + _537;
        float _551 = (_545 * ((_528 / _529) - _538)) + _538;
        diffuseMomentUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float2(_550, _551);
        float _565 = saturate(((abs(_332 - _550) / sqrt(max(0.0f, _551 - (_550 * _550)))) + (-1.0f)) * 2.0f);
        float _299 = (((_565 * _565) * (1.0f - _149)) * (3.0f - (_565 * 2.0f))) + _149;
        float _573 = 1.0f / _299;
        _298 = _299;
        _300 = (_573 * (_153 - _332)) + _332;
        _302 = (_573 * (_154 - _333)) + _333;
        _304 = (_573 * (_155 - _334)) + _334;
        _306 = (_573 * (_156 - _335)) + _335;
        _308 = (_573 * (_160 - _350)) + _350;
        _310 = (_573 * (_161 - _351)) + _351;
        _312 = (_573 * (_162 - _352)) + _352;
        _314 = (_573 * (_163 - _353)) + _353;
      } else {
        _298 = 1.0f;
        _300 = _153;
        _302 = _154;
        _304 = _155;
        _306 = _156;
        _308 = _160;
        _310 = _161;
        _312 = _162;
        _314 = _163;
      }
      historyCountUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = _298;
      diffuseHistoryColorUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(_300, _302, _304, _306);
      diffuseHistorySHUAV[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(_308, _310, _312, _314);
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
