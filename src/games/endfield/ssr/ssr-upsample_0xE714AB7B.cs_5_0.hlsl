
#include "../shared.h"

Texture2D<float4> t2 : register(t2); 
Texture2D<float4> t1 : register(t1);  
Texture2D<float4> t0 : register(t0);  

SamplerState s1_s : register(s1);  
SamplerState s0_s : register(s0);  

cbuffer cb1 : register(b1)
{
  float4 cb1[6];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[83];
}

RWTexture2D<float4> u0 : register(u0);

#define cmp -

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5, 0.5) + r0.xy;
  r0.xy = cb0[82].zw * r0.xy;

  // Sample sharp temporal color and apply inverse Reinhard
  r1.xyz = t1.SampleLevel(s1_s, r0.xy, 0).xyz;
  r0.z = max(r1.x, r1.y);
  r0.z = max(r0.z, r1.z);
  r0.z = 1 + -r0.z;
  r0.z = 1 / r0.z;
  r1.xyzw = r1.xyzx * r0.zzzz;

  // Read mip from filter weight texture
  r0.z = t0.SampleLevel(s0_s, r0.xy, 0).y;
  r0.z = cb1[5].y * r0.z;

  if (shader_injection.improved_ssr >= 0.5f) {
    // Improved mode: fractional mip blending (ported from Miru's Vulkan mod)
    if (r0.z < 0.25) {
      // Low mip — use sharp temporal color directly
      r0.xyzw = r1.xyzw;
    } else {
      // Blend between sharp and blurred based on fractional mip
      float mip0 = floor(r0.z);
      float fraction = saturate(r0.z - mip0);
      float4 color_blurred = t2.SampleLevel(s1_s, r0.xy, 0).xyzx;

      if (mip0 == 0.0) {
        // Fractional blend between sharp and blurred
        r0.xyzw = lerp(r1.xyzw, color_blurred, fraction);
      } else {
        // High mip — use blurred resolve entirely
        r0.xyzw = color_blurred;
      }
    }
  } else {
    // Vanilla mode: hard cutoff at mip 0.25
    r0.xyw = t2.SampleLevel(s1_s, r0.xy, 0).xyz;
    r0.z = cmp(r0.z < 0.25);
    r0.xyzw = r0.zzzz ? r1.xyzw : r0.xywx;
  }

  u0[vThreadID.xy] = r0.xyzw;
  return;
}
