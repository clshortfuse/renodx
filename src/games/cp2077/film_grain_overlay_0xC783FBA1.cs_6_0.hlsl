// Film Grain overlay

#include "../../common/filmgrain.hlsl"
#include "./colormath.hlsl"
#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

cbuffer _27_29 : register(b0, space0) {
  float4 cb0[30] : packoffset(c0);
}

cbuffer _36_38 : register(b6, space0) {
  float4 cb6[30] : packoffset(c0);
}

cbuffer _32_34 : register(b12, space0) {
  float4 cb12[99] : packoffset(c0);
}

Texture2D<float4> textureRender : register(t32, space0);
Texture2D<uint2> _12 : register(t51, space0);
Texture2D<float4> _13 : register(t1, space0);
Texture2D<float4> _14 : register(t2, space0);
Texture2D<float4> _15 : register(t3, space0);
StructuredBuffer<uint> _18 : register(t7, space0);
Texture2D<float4> _19 : register(t10, space0);
RWTexture2D<float4> _22 : register(u0, space0);
RWTexture2D<float4> _23 : register(u1, space0);
SamplerState _41 : register(s0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main() {
  uint4 _73 = _18.Load(asuint(cb6[13u]).x + gl_WorkGroupID.x);
  uint _74 = _73.x;
  uint _82 = ((_74 << 4u) & 1048560u) + gl_LocalInvocationID.x;
  uint _83 = ((_74 >> 16u) << 4u) + gl_LocalInvocationID.y;
  float3 inputColor = textureRender.Load(int3(uint2(_82, _83), 0u)).rgb;
  float _87 = inputColor.r;
  float _88 = inputColor.g;
  float _89 = inputColor.b;
  float _97 = float(_82);
  float _98 = float(_83);
  float _282;
  float _283;
  float _284;

  // 8.0 @ 100 nits
  // 4.0 @ 200 nits
  // 2.0 @ 400 nits
  // 1.0 on SDR

  float grainStrength = cb6[12u].x;  // Film Grain Strength? Should be 0 or 1
  float uiPaperWhiteScaler = cb6[12u].y;

  // float userUIPaperWhite = uiPaperWhiteScaler / 8.0f;

  if (grainStrength > 0.0f) {
    if (injectedData.fxFilmGrain) {
      float3 grainColor = _13.Load(int3(uint2(_82 & 255u, _83 & 255u), 0u)).rgb;
      float3 grainedColor = computeFilmGrain(
        inputColor,
        grainColor.xy,
        frac(cb0[0u].x / 1000.f),
        injectedData.fxFilmGrain * 0.03f,
        (uiPaperWhiteScaler == 1.f) ? 1.f : (203.f / 100.f)
        // ,injectedData.debugValue02 != 1.f
      );
      _282 = grainedColor.r;
      _283 = grainedColor.g;
      _284 = grainedColor.b;
    } else {
      uint _113 = 1u << (_12.Load(int3(uint2(uint(cb12[79u].x * _97), uint(cb12[79u].y * _98)), 0u)).y & 31u);
      float3 grainStrengthAdjusted = inputColor * grainStrength;

      float3 grainColor = _13.Load(int3(uint2(_82 & 255u, _83 & 255u), 0u)).rgb;

      float averageChannel = (grainColor.r + grainColor.g + grainColor.z) / 3.f;
      float3 distanceFromAverage = grainColor - averageChannel;

      float _129 = grainStrengthAdjusted.r;
      float _130 = grainStrengthAdjusted.g;
      float _131 = grainStrengthAdjusted.b;

      float _148 = distanceFromAverage.r;
      float _149 = distanceFromAverage.g;
      float _150 = distanceFromAverage.b;

      float _154 = averageChannel - 0.5f;
      uint4 _168 = asuint(cb6[17u]);

      float _172 = float(min((_168.x & _113), 1u));
      float _201 = float(min((_168.y & _113), 1u));
      float _230 = float(min((_168.z & _113), 1u));
      float _259 = float(min((_168.w & _113), 1u));
      float _266 = (((((((_154 + (cb6[18u].w * _148)) * cb6[18u].x) * _172) + 1.0f)
                      * (_129 / max(1.0f - _129, 9.9999999747524270787835121154785e-07f)))
                     * ((((_154 + (cb6[19u].w * _148)) * cb6[19u].x) * _201) + 1.0f))
                    * ((((_154 + (cb6[20u].w * _148)) * cb6[20u].x) * _230) + 1.0f))
                 * ((((_154 + (cb6[21u].w * _148)) * cb6[21u].x) * _259) + 1.0f);

      float _267 = (((((((_154 + (cb6[18u].w * _149)) * cb6[18u].y) * _172) + 1.0f) * (_130 / max(1.0f - _130, 9.9999999747524270787835121154785e-07f))) * ((((_154 + (cb6[19u].w * _149)) * cb6[19u].y) * _201) + 1.0f)) * ((((_154 + (cb6[20u].w * _149)) * cb6[20u].y) * _230) + 1.0f)) * ((((_154 + (cb6[21u].w * _149)) * cb6[21u].y) * _259) + 1.0f);
      float _268 = (((((((_154 + (cb6[18u].w * _150)) * cb6[18u].z) * _172) + 1.0f) * (_131 / max(1.0f - _131, 9.9999999747524270787835121154785e-07f))) * ((((_154 + (cb6[19u].w * _150)) * cb6[19u].z) * _201) + 1.0f)) * ((((_154 + (cb6[20u].w * _150)) * cb6[20u].z) * _230) + 1.0f)) * ((((_154 + (cb6[21u].w * _150)) * cb6[21u].z) * _259) + 1.0f);
      _282 = uiPaperWhiteScaler * (_266 / max(_266 + 1.0f, 1.0f));
      _283 = uiPaperWhiteScaler * (_267 / max(_267 + 1.0f, 1.0f));
      _284 = uiPaperWhiteScaler * (_268 / max(_268 + 1.0f, 1.0f));
      // if (injectedData.debugValue02 != 1.f) {
      //   float oldColorY = dot(inputColor, float3(0.2126390039920806884765625f, 0.715168654918670654296875f, 0.072192318737506866455078125f));
      //   float newColorY = dot(float3(_282, _283, _284), float3(0.2126390039920806884765625f, 0.715168654918670654296875f, 0.072192318737506866455078125f));
      //   float yChange = oldColorY ? (newColorY / oldColorY) - 1.f : 0;
      //   _282 = _283 = _284 = abs(yChange);
      // }
    }
  } else {
    _282 = _87;
    _283 = _88;
    _284 = _89;
  }
  uint4 _290 = asuint(cb6[12u]);
  float _295 = (_97 + 0.5f) / float(_290.z);
  float _296 = (_98 + 0.5f) / float(_290.w);
  float _311;
  float _313;
  float _315;
  if (((_295 < cb6[9u].y) || (_296 < cb6[9u].z)) || (((1.0f - cb6[9u].y) < _295) || ((1.0f - cb6[9u].z) < _296))) {
    _311 = 0.0f;
    _313 = 0.0f;
    _315 = 0.0f;
  } else {
    float4 _324 = _15.SampleLevel(_41, float2(_295, _296), 0.0f);
    float4 _332 = _14.SampleLevel(_41, float2(_295, _296), 0.0f);
    float _337 = _332.w;
    float _338 = 1.0f - _337;
    float _343 = (_338 * _324.w) + _337;
    _311 = ((_343 * ((_332.x - _282) + (_338 * _324.x))) + _282) * cb6[1u].z;
    _313 = ((_343 * ((_332.y - _283) + (_338 * _324.y))) + _283) * cb6[1u].z;
    _315 = ((_343 * ((_332.z - _284) + (_338 * _324.z))) + _284) * cb6[1u].z;
  }
  float _374;
  float _376;
  float _378;
  if (cb6[14u].w > 0.0f) {
    uint4 _362 = asuint(cb6[10u]);
    uint _363 = _362.x;
    uint _365 = _362.z;
    uint _368 = _362.y;
    uint _371 = _362.w;
    float frontier_phi_6_5_ladder;
    float frontier_phi_6_5_ladder_1;
    float frontier_phi_6_5_ladder_2;
    if ((((_82 >= _363) && (_82 < _365)) && (_83 >= _368)) && (_83 < _371)) {
      float4 _407 = _19.SampleLevel(_41, float2((cb6[11u].z * ((_97 - float(int(_363))) / float(int(_365 - _363)))) + cb6[11u].x, (cb6[11u].w * ((_98 - float(int(_368))) / float(int(_371 - _368)))) + cb6[11u].y), 0.0f);
      frontier_phi_6_5_ladder = _407.x * cb6[14u].w;
      frontier_phi_6_5_ladder_1 = _407.y * cb6[14u].w;
      frontier_phi_6_5_ladder_2 = _407.z * cb6[14u].w;
    } else {
      frontier_phi_6_5_ladder = _311;
      frontier_phi_6_5_ladder_1 = _313;
      frontier_phi_6_5_ladder_2 = _315;
    }
    _374 = frontier_phi_6_5_ladder;
    _376 = frontier_phi_6_5_ladder_1;
    _378 = frontier_phi_6_5_ladder_2;
  } else {
    _374 = _311;
    _376 = _313;
    _378 = _315;
  }
  uint4 _382 = asuint(cb6[13u]);
  float3 outputColor1 = float3(_374, _376, _378);
  if (_382.y != 0u) {
    ConvertColorParams params = {
      _382.w,      // outputTypeEnum
      cb6[14u].x,  // paperWhiteScaling
      cb6[14u].y,  // blackFloorAdjust
      cb6[14u].z,  // gammaCorrection
      cb6[16u].x,  // pqSaturation
      float3x3(
        // clang-format off
        cb6[22u].x, cb6[22u].y, cb6[22u].z,
        cb6[23u].x, cb6[23u].y, cb6[23u].z,
        cb6[24u].x, cb6[24u].y, cb6[24u].z
        // clang-format on
      ),                           // pqMatrix
      float3(_97, _98, cb0[0u].x)  // random3
    };
    outputColor1 = convertColor(outputColor1, params);
  }

  _22[uint2(_82, _83)] = float4(outputColor1.rgb, 1.0f);

  if (asuint(cb6[15u]).x != 0u) {
    ConvertColorParams params = {
      _382.w,      // outputTypeEnum
      cb6[15u].y,  // paperWhiteScaling
      cb6[15u].z,  // blackFloorAdjust
      cb6[15u].w,  // gammaCorrection
      cb6[16u].x,  // pqSaturation
      float3x3(
        // clang-format off
        cb6[26u].x, cb6[26u].y, cb6[26u].z,
        cb6[27u].x, cb6[27u].y, cb6[27u].z,
        cb6[28u].x, cb6[28u].y, cb6[28u].z
        // clang-format on
      ),                           // pqMatrix
      float3(_97, _98, cb0[0u].x)  // random3
    };

    float3 outputColor2 = float3(_311, _313, _315);
    outputColor2 = convertColor(outputColor2, params);
    _23[uint2(_82, _83)] = float4(outputColor2.rgb, 1.0f);
  }
}

[numthreads(16, 16, 1)] void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
