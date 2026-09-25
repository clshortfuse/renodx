#include "../common.hlsli"

Texture2DArray<float4> t6 : register(t6);
Texture2DArray<float4> t5 : register(t5);
struct t4_t {
  float val[1];
};
StructuredBuffer<t4_t> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
RWTexture2D<float4> u0 : register(u0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

// Wheel World

[numthreads(8, 8, 1)]
void main(uint2 vThreadID: SV_DispatchThreadID) {
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  u0.GetDimensions(uiDest.x, uiDest.y);
  r0.xy = uiDest.xy;
  if (vThreadID.x < uiDest.x && vThreadID.y < uiDest.y) {
    r0.zw = (uint2)vThreadID.xy;
    r1.xy = float2(0.5,0.5) + r0.zw;
    r0.xy = (uint2)r0.xy;
    r1.xy = r1.xy / r0.xy;
    r2.xyzw = u0[vThreadID.xy];
    r3.xy = vThreadID.xy;
    r3.zw = float2(0,0);
    r1.z = t3.Load(r3.xyw).x;
    r1.w = t2.Load(r3.xyz).w;
    r3.xyz = t0.SampleLevel(s2_s, r1.xy, 0).xyz;
    r3.xyz = r3.xyz + r2.xyz;
    r1.x = t4[0].val[0/4];
    r1.x = r1.x * 9.6 + 0.0001;
    r4.xyz = r3.xyz / r1.xxx;
    r3.xyz = float3(0.867980242,0.867980242,0.867980242) * r3.xyz;
    r3.xyz = (r1.z > 0) ? r3.xyz : r4.xyz;
    t1.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
    r1.xy = uiDest.xy;
    r0.xy = cb0[4].zz * r0.xy + r0.zw;
    r0.zw = (uint2)r1.xy;
    r1.xy = r0.xy * r0.zw;
    r0.zw = (r1.xy >= -r1.xy) ? r0.zw : -r0.zw;
    r1.xy = float2(1,1) / r0.zw;
    r0.xy = r1.xy * r0.xy;
    r0.xy = frac(r0.xy);
    r0.xy = r0.zw * r0.xy;
    r0.xy = (uint2)r0.xy;
    r0.zw = float2(0,0);
    r0.x = t1.Load(r0.xyz).x;
    r0.x = r0.x * 0.5 + 0.5;
    r0.xyz = r0.xxx * float3(0.00390625,0.00390625,0.00390625) + r3.xyz;
    r0.xyz = float3(-0.00390625,-0.00390625,-0.00390625) + r0.xyz;
    r3.xyz = cb0[4].www * r0.xyz;
    r0.xyz = (r1.z > 0) ? r0.xyz : r3.xyz;
    r0.xyz = SHAcesTonemap(r0.xyz);
    float3 preGrading = r0.xyz;
    float compression_scale;
    float max_channel_scale;
    if (RENODX_TONE_MAP_TYPE != 0.f) {
      GamutCompression(r0.xyz, compression_scale);
      NeutwoMaxCh(r0.xyz, max_channel_scale);
    }
    r0.w = r2.w;
    r1.xy = saturate(r0.xy);
    r0.x = saturate(r0.z);
    if (r1.z > 0) {
      r0.y = asint(cb0[4].y) + -1;
      r0.y = (int)r0.y;
      r0.z = r0.x * r0.y;
      r3.x = floor(r0.z);
      r3.w = ceil(r0.z);
      r3.yz = r1.xy * float2(1,-1) + float2(0,1);
      r4.xyz = t6.SampleLevel(s1_s, r3.yzx, 0).xyz;
      r3.xyz = t6.SampleLevel(s1_s, r3.yzw, 0).xyz;
      r0.z = frac(r0.z);
      r3.xyz = r3.xyz + -r4.xyz;
      r3.xyz = r0.zzz * r3.xyz + r4.xyz;
      r0.y = r2.z * r0.y;
      r4.x = floor(r0.y);
      r4.w = ceil(r0.y);
      r4.yz = r2.xy * float2(1,-1) + float2(0,1);
      r5.xyz = t6.SampleLevel(s1_s, r4.yzx, 0).xyz;
      r4.xyz = t6.SampleLevel(s1_s, r4.yzw, 0).xyz;
      r0.y = frac(r0.y);
      r4.xyz = r4.xyz + -r5.xyz;
      r2.xyz = r0.yyy * r4.xyz + r5.xyz;
    } else {
      r0.y = asint(cb0[2].y) + -1;
      r0.y = (int)r0.y;
      r0.x = r0.x * r0.y;
      r4.x = floor(r0.x);
      r4.w = ceil(r0.x);
      r4.yz = r1.xy * float2(1,-1) + float2(0,1);
      r1.xyz = t5.SampleLevel(s0_s, r4.yzx, 0).xyz;
      r4.xyz = t5.SampleLevel(s0_s, r4.yzw, 0).xyz;
      r0.x = frac(r0.x);
      r4.xyz = r4.xyz + -r1.xyz;
      r3.xyz = r0.xxx * r4.xyz + r1.xyz;
      r0.x = r2.z * r0.y;
      r4.x = floor(r0.x);
      r4.w = ceil(r0.x);
      r4.yz = r2.xy * float2(1,-1) + float2(0,1);
      r0.yzw = t5.SampleLevel(s0_s, r4.yzx, 0).xyz;
      r1.xyz = t5.SampleLevel(s0_s, r4.yzw, 0).xyz;
      r0.x = frac(r0.x);
      r1.xyz = r1.xyz + -r0.yzw;
      r2.xyz = r0.xxx * r1.xyz + r0.yzw;
    }
    r3.w = r2.w;
    r0.xyzw = (r1.w > 0) ? r2.xyzw : r3.xyzw;
    r0.xyz = lerp(preGrading, r0.xyz, CUSTOM_USER_LUT_STRENGTH);
    if (RENODX_TONE_MAP_TYPE != 0.f) {
      NeutwoMaxChInverse(r0.xyz, max_channel_scale);
      GamutDecompression(r0.xyz, compression_scale);
    }
    if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
      r0.xyz = GradeAndDisplayMap(r0.xyz);
    }
    if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
      r0.xyz = PostToneMapScale(r0.xyz);
    }
    u0[vThreadID.xy] = r0.xyzw;
  }
  return;
}