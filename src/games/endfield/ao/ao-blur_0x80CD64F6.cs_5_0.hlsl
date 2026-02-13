#include "../shared.h"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

RWTexture2D<unorm float> u0 : register(u0);

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID) {
  // If game AO is disabled, just write 1.0 (no occlusion)
  if (shader_injection.disable_game_ao >= 0.5f) {
    u0[vThreadID.xy] = 1.0;
    return;
  }

  // Original ao-blur logic
  float2 r0xy = float2(vThreadID.xy) + float2(0.5, 0.5);
  float2 r0zw = cb0[3].zw * r0xy;
  
  float r1x = t1.SampleLevel(s0_s, r0zw, 0).z;
  r1x = 1.0 - r1x;
  r1x = saturate(r1x + r1x);
  r1x *= AO_DENOISER_BLUR_BETA;
  
  float r1y = t0.SampleLevel(s0_s, r0zw, 0).x;
  float r1z = cb0[3].z;
  
  float2 r2;
  r2.y = 0;
  
  float3 r3 = float3(-3, 0, 0);
  
  [loop]
  while (true) {
    if (3 < r3.x) break;
    
    float r1w = r3.x * r1z;
    r2.x = r1w * r1x;
    float2 r2zw = r2.xy * cb0[3].zw + r0zw;
    
    r1w = t0.SampleLevel(s0_s, r2zw, 0).x;
    r1w = r1w - r1y;
    r1w = min(1.0, abs(r1w));
    r1w = 1.0 - r1w;
    
    float3 r4;
    r4.x = r3.y + r1w;
    
    float2 r2xz = r0xy * cb0[3].zw + r2.xy;
    float r2x_sample = t2.SampleLevel(s0_s, r2xz, 0).x;
    r4.y = r2x_sample * r1w + r3.z;
    r4.z = 1.0 + r3.x;
    
    r3 = r4.zxy;
  }
  
  float result = max(9.99999975e-05, r3.y);
  result = r3.z / result;
  
  u0[vThreadID.xy] = result;
}
