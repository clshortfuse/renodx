#include "./shared.h"

cbuffer stub_PushConstantWrapper_ColorGradingMerge : register(b0, space0) {
  uint lut0Strength : packoffset(c0);
  uint lut1Strength : packoffset(c0);
  uint lut2Strength : packoffset(c0);
  uint lut3Strength : packoffset(c0);
  uint value04 : packoffset(c0);
}

Texture2D<float3> lut0 : register(t0, space8);
Texture2D<float3> lut1 : register(t1, space8);
Texture2D<float3> lut2 : register(t2, space8);
Texture2D<float3> lut3 : register(t3, space8);
RWTexture3D<float3> lutOut : register(u0, space8);

static uint3 gl_GlobalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

[numthreads(16, 16, 1)] void main(SPIRV_Cross_Input stage_input) {
  uint _36 = (gl_GlobalInvocationID.z << 4u) + gl_GlobalInvocationID.x;
  float _50 = asfloat(value04);

  float3 lut0Color = lut0.Load(int3(uint2(_36, gl_GlobalInvocationID.y), 0u));
  float3 lut1Color = lut1.Load(int3(uint2(_36, gl_GlobalInvocationID.y), 0u));
  float3 lut2Color = lut2.Load(int3(uint2(_36, gl_GlobalInvocationID.y), 0u));
  float3 lut3Color = lut3.Load(int3(uint2(_36, gl_GlobalInvocationID.y), 0u));

  float3 finalColor = (lut0Color * lut0Strength)
                    + (lut1Color * lut1Strength)
                    + (lut2Color * lut2Strength)
                    + (lut3Color * lut3Strength)
                    + ((float(gl_GlobalInvocationID.x) * 0.066666670143604278564453125f) * _50);

  lutOut[uint3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y, gl_GlobalInvocationID.z)] = finalColor.rgb;
}
