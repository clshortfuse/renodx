#include "../common.hlsl"

struct u0_t {
  float val[4];
};
RWStructuredBuffer<u0_t> u0 : register(u0);
Texture2D<float4> t0 : register(t0);
RWTexture2D<float4> u1 : register(u1);

[numthreads(64, 1, 1)]
void main(uint3 vThreadIDInGroup: SV_GroupThreadID, uint3 vThreadGroupID: SV_GroupID, uint3 vThreadID: SV_DispatchThreadID) {
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0,0);
  r1.x = (uint)vThreadIDInGroup.x >> 3;
  bitmask.y = ((~(-1 << 1)) << 0) & 0xffffffff;  r1.y = (((uint)vThreadIDInGroup.x << 0) & bitmask.y) | ((uint)r1.x & ~bitmask.y);
  if (3 == 0) r1.x = 0; else if (3+1 < 32) {   r1.x = (uint)vThreadIDInGroup.x << (32-(3 + 1)); r1.x = (uint)r1.x >> (32-3);  } else r1.x = (uint)vThreadIDInGroup.x >> 1;
  r1.xy = mad((int2)vThreadGroupID.xy, int2(8,8), (int2)r1.xy);
  r2.xyzw = (int4)r1.xyxy + int4(0,-1,-1,0);
  r0.xy = r2.zw;
  r0.xyz = t0.Load(r0.xyz).xyz;
  if(injectedData.toneMapType == 0.f){
  r3.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  r0.xyz = max(float3(0.0404499359,0.0404499359,0.0404499359), r0.xyz);
  r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = min(r3.xyz, r0.xyz);
  }
  r3.xyzw = (int4)r1.xyxy + int4(0,1,1,0);
  r4.xy = r3.zw;
  r4.zw = float2(0,0);
  r4.xyz = t0.Load(r4.xyz).xyz;
  if(injectedData.toneMapType == 0.f){
  r5.xyz = log2(abs(r4.xyz));
  r4.xyz = float3(12.9200001,12.9200001,12.9200001) * r4.xyz;
  r4.xyz = max(float3(0.0404499359,0.0404499359,0.0404499359), r4.xyz);
  r5.xyz = float3(0.416666657,0.416666657,0.416666657) * r5.xyz;
  r5.xyz = exp2(r5.xyz);
  r5.xyz = r5.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r4.xyz = min(r5.xyz, r4.xyz);
  }
  r2.zw = float2(0,0);
  r2.xyz = t0.Load(r2.xyz).xyz;
  if(injectedData.toneMapType == 0.f){
  r6.xyz = log2(abs(r2.xyz));
  r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r2.xyz;
  r2.xyz = max(float3(0.0404499359,0.0404499359,0.0404499359), r2.xyz);
  r6.xyz = float3(0.416666657,0.416666657,0.416666657) * r6.xyz;
  r6.xyz = exp2(r6.xyz);
  r6.xyz = r6.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = min(r6.xyz, r2.xyz);
  }
  r3.zw = float2(0,0);
  r3.xyz = t0.Load(r3.xyz).xyz;
  if(injectedData.toneMapType == 0.f){
  r6.xyz = log2(abs(r3.xyz));
  r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r3.xyz;
  r3.xyz = max(float3(0.0404499359,0.0404499359,0.0404499359), r3.xyz);
  r6.xyz = float3(0.416666657,0.416666657,0.416666657) * r6.xyz;
  r6.xyz = exp2(r6.xyz);
  r6.xyz = r6.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r3.xyz = min(r6.xyz, r3.xyz);
  } else if(injectedData.toneMapType >= 2.f){
    r0.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r4.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r2.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r3.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
  } else if(injectedData.toneMapType == 1.f){
    r0.xyz /= 50.f;
    r4.xyz /= 50.f;
    r2.xyz /= 50.f;
    r3.xyz /= 50.f;
  }
  r5.xyz = min(r4.xyz, r0.xyz);
  r5.xyz = min(r2.xyz, r5.xyz);
  r5.xyz = min(r5.xyz, r3.xyz);
  r6.xyz = r5.xyz * float3(4,4,4) + float3(-4,-4,-4);
  r6.xyz = rcp(r6.xyz);
  r7.xyz = max(r4.xyz, r0.xyz);
  r7.xyz = max(r7.xyz, r2.xyz);
  r7.xyz = max(r7.xyz, r3.xyz);
  r8.xyz = float3(1,1,1) + -r7.xyz;
  r7.xyz = float3(4,4,4) * r7.xyz;
  r7.xyz = rcp(r7.xyz);
  r5.xyz = r7.xyz * r5.xyz;
  r6.xyz = r8.xyz * r6.xyz;
  r5.xyz = max(r6.xyz, -r5.xyz);
  r0.w = max(r5.y, r5.z);
  r0.w = max(r5.x, r0.w);
  r0.w = min(0, r0.w);
  r0.w = max(-0.1875, r0.w);
  r2.w = u0[0].val[0/4];
  r0.w = r2.w * r0.w;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r0.xyz = r0.www * r3.xyz + r0.xyz;
  r0.xyz = r0.www * r4.xyz + r0.xyz;
  r0.w = r0.w * 4 + 1;
  r1.zw = float2(0,0);
  r2.xyz = t0.Load(r1.xyz).xyz;
  if(injectedData.toneMapType == 0.f){
  r3.xyz = log2(abs(r2.xyz));
  r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r2.xyz;
  r2.xyz = max(float3(0.0404499359,0.0404499359,0.0404499359), r2.xyz);
  r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = min(r3.xyz, r2.xyz);
  } else if(injectedData.toneMapType >= 2.f){
    r2.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
  } else if(injectedData.toneMapType == 1.f){
    r2.xyz /= 50.f;
  }
  r0.xyz = r2.xyz + r0.xyz;
  r1.z = asfloat(2129764351u - asuint(r0.w));
  r0.w = -r1.z * r0.w + 2;
  r0.w = r1.z * r0.w;
  r0.xyz = r0.xyz * r0.www;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = renodx::color::srgb::Decode(r0.xyz);
  } else if(injectedData.toneMapType >= 2.f){
    r0.xyz *= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
  } else if(injectedData.toneMapType == 1.f){
    r0.xyz *= 50.f;
  }
  r0.w = 1;
  u1[uint2(r0.xy)] = r0;
  return;
}