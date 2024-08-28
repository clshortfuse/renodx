#include "./shared.h"

SamplerState sInputS : register(s0);
Texture2D<float4> sInputT : register(t0);


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  out float4 o0 : SV_TARGET0)
{
  // Weights corresponding to each texture coordinate sample
  const float weights[9] = {
    0.162103f, 0.120259f, 0.120259f, 0.120259f,
    0.120259f, 0.089216f, 0.089216f, 0.089216f,
    0.089216f
  };

  // Coordinates to sample from
  float4 v[4] = { v2, v3, v4, v5 };
  
  // Initialize result color
  float4 result = 0;

  // Loop through and apply weighted samples
  for (int i = 0; i < 4; i++) {
    // Compute the index for the next texture coordinate pair
    int index1 = i * 2;
    int index2 = index1 + 1;

    // Sample texture at current coordinate (using .xy)
    float4 sample1 = sInputT.Sample(sInputS, v[i].xy);
    result += weights[index1] * sample1;

    // Sample texture at corresponding next coordinate (using .zw)
    float4 sample2 = sInputT.Sample(sInputS, v[i].zw);
    result += weights[index2] * sample2;
  }

  // Sample the input texture
  float4 input = sInputT.Sample(sInputS, v1.xy);

  // Compute the final output by blending the accumulated result with the final sample
  o0 = input * float4(0.0892157331f, 0.0892157331f, 0.0892157331f, 0.0892157331f) + result;

  return;
}