#include "./common.hlsl"

// https://github.com/Unity-Technologies/Graphics/blob/master/Packages/com.unity.render-pipelines.high-definition/Runtime/PostProcessing/Shaders/LutBuilder3D.compute

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
RWTexture3D<float4> u0 : register(u0);
cbuffer cb0 : register(b0){
  float4 cb0[25];
}

#define cmp -

[numthreads(4, 4, 4)] void main(uint3 vThreadID : SV_DispatchThreadID) {
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = (uint3)vThreadID.xyz;
  r0.w = cmp(0 < cb0[17].x);
  if (r0.w != 0) {
    r1.xyz = r0.xyz * cb0[0].yyy;
      r1.rgb = lutShaper(r1.rgb, true);
      float3 preCG = r1.rgb;
    // WhiteBalance
    r2.x = dot(float3(0.390404999,0.549941003,0.00892631989), r1.xyz);
    r2.y = dot(float3(0.070841603,0.963172019,0.00135775004), r1.xyz);
    r2.z = dot(float3(0.0231081992,0.128021002,0.936245024), r1.xyz);
    r1.xyz = cb0[2].xyz * r2.xyz;
    r2.x = dot(float3(2.85846996,-1.62879002,-0.0248910002), r1.xyz);
    r2.y = dot(float3(-0.210181996,1.15820003,0.000324280991), r1.xyz);
    r2.z = dot(float3(-0.0418119989,-0.118169002,1.06867003), r1.xyz);
    // LineartoLogC
    r1.xyz = r2.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = r1.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(-0.0275523961,-0.0275523961,-0.0275523961);
    // LogCtoLinear
    r1.xyz = r1.xyz * cb0[7].zzz + float3(0.0275523961,0.0275523961,0.0275523961);
    r1.xyz = float3(13.6054821,13.6054821,13.6054821) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = float3(-0.0479959995,-0.0479959995,-0.0479959995) + r1.xyz;
    r1.xyz = cb0[3].xyz * r1.xyz;
    r1.xyz = float3(0.179999992,0.179999992,0.179999992) * r1.xyz;
    // Gamma space
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.454545468,0.454545468,0.454545468) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    // Split Toning
    r2.xyz = min(float3(1,1,1), r1.xyz);
    r0.w = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r0.w = saturate(cb0[15].w + r0.w);
    r1.w = 1 + -r0.w;
    r2.xyz = float3(-0.5,-0.5,-0.5) + cb0[15].xyz;
    r2.xyz = r1.www * r2.xyz + float3(0.5,0.5,0.5);
    r3.xyz = float3(-0.5,-0.5,-0.5) + cb0[16].xyz;
    r3.xyz = r0.www * r3.xyz + float3(0.5,0.5,0.5);
    r4.xyz = r1.xyz + r1.xyz;
    r5.xyz = r1.xyz * r1.xyz;
    r6.xyz = -r2.xyz * float3(2,2,2) + float3(1,1,1);
    r5.xyz = r6.xyz * r5.xyz;
    r5.xyz = r4.xyz * r2.xyz + r5.xyz;
    r1.xyz = sqrt(r1.xyz);
    r6.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r7.xyz = float3(1,1,1) + -r2.xyz;
    r4.xyz = r7.xyz * r4.xyz;
    r1.xyz = r1.xyz * r6.xyz + r4.xyz;
    r2.xyz = cmp(r2.xyz >= float3(0.5,0.5,0.5));
    r4.xyz = r2.xyz ? float3(1,1,1) : 0;
    r2.xyz = r2.xyz ? float3(0,0,0) : float3(1,1,1);
    r2.xyz = r2.xyz * r5.xyz;
    r1.xyz = r1.xyz * r4.xyz + r2.xyz;
    r2.xyz = r1.xyz + r1.xyz;
    r4.xyz = r1.xyz * r1.xyz;
    r5.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
    r4.xyz = r5.xyz * r4.xyz;
    r4.xyz = r2.xyz * r3.xyz + r4.xyz;
    r1.xyz = sqrt(r1.xyz);
    r5.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r6.xyz = float3(1,1,1) + -r3.xyz;
    r2.xyz = r6.xyz * r2.xyz;
    r1.xyz = r1.xyz * r5.xyz + r2.xyz;
    r2.xyz = cmp(r3.xyz >= float3(0.5,0.5,0.5));
    r3.xyz = r2.xyz ? float3(1,1,1) : 0;
    r2.xyz = r2.xyz ? float3(0,0,0) : float3(1,1,1);
    r2.xyz = r2.xyz * r4.xyz;
    r1.xyz = r1.xyz * r3.xyz + r2.xyz;
    // Linear Space
    r1.xyz = log2(abs(r1.xyz));
    r1.xyz = float3(2.20000005,2.20000005,2.20000005) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    // Channel mixing
    r2.x = dot(r1.xyz, cb0[4].xyz);
    r2.y = dot(r1.xyz, cb0[5].xyz);
    r2.z = dot(r1.xyz, cb0[6].xyz);
    // Shadows, midtones, highlights
    r0.w = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r1.xy = cb0[14].yw + -cb0[14].xz;
    r1.zw = -cb0[14].xz + r0.ww;
    r1.xy = float2(1,1) / r1.xy;
    r1.xy = saturate(r1.zw * r1.xy);
    r1.zw = r1.xy * float2(-2,-2) + float2(3,3);
    r1.xy = r1.xy * r1.xy;
    r0.w = r1.w * r1.y;
    r1.x = -r1.z * r1.x + 1;
    r1.z = 1 + -r1.x;
    r1.y = -r1.w * r1.y + r1.z;
    r3.xyz = cb0[11].xyz * r2.xyz;
    r4.xyz = cb0[12].xyz * r2.xyz;
    r1.yzw = r4.xyz * r1.yyy;
    r1.xyz = r3.xyz * r1.xxx + r1.yzw;
    r2.xyz = cb0[13].xyz * r2.xyz;
    r1.xyz = r2.xyz * r0.www + r1.xyz;
    // Lift, gamma, gain
    r1.xyz = r1.xyz * cb0[10].xyz + cb0[8].xyz;
    r2.xyz = cmp(float3(0,0,0) < r1.xyz);
    r3.xyz = cmp(r1.xyz < float3(0,0,0));
    r2.xyz = (int3)-r2.xyz + (int3)r3.xyz;
    r2.xyz = (int3)r2.xyz;
    r1.xyz = log2(abs(r1.xyz));
    r1.xyz = cb0[9].xyz * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r3.xyz = r2.xyz * r1.xyz;
    // HSV stuff
    r0.w = cmp(r3.y >= r3.z);
    r0.w = r0.w ? 1.000000 : 0;
    r4.xy = r3.zy;
    r4.zw = float2(-1,0.666666687);
    r1.xy = r2.yz * r1.yz + -r4.xy;
    r1.zw = float2(1,-1);
    r1.xyzw = r0.wwww * r1.xyzw + r4.xyzw;
    r0.w = cmp(r3.x >= r1.x);
    r0.w = r0.w ? 1.000000 : 0;
    r2.xyz = r1.xyw;
    r2.w = r3.x;
    r1.xyw = r2.wyx;
    r1.xyzw = r1.xyzw + -r2.xyzw;
    r1.xyzw = r0.wwww * r1.xyzw + r2.xyzw;
    r0.w = min(r1.w, r1.y);
    r0.w = r1.x + -r0.w;
    r1.y = r1.w + -r1.y;
    r1.w = r0.w * 6 + 9.99999975e-05;
    r1.y = r1.y / r1.w;
    r1.y = r1.z + r1.y;
    r2.x = abs(r1.y);
    r1.y = 9.99999975e-05 + r1.x;
    r2.z = r0.w / r1.y;
    // Hue vs Sat
    r2.yw = float2(0,0);
    r0.w = t5.SampleLevel(s0_s, r2.xy, 0).x;
    r0.w = saturate(r0.w);
    r0.w = r0.w + r0.w;
    // Sat vs Sat
    r1.y = t6.SampleLevel(s0_s, r2.zw, 0).x;
    r1.y = saturate(r1.y);
    r0.w = dot(r1.yy, r0.ww);
    // Luma vs Sat
    r3.x = dot(r3.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r3.yw = float2(0,0);
    r1.y = t7.SampleLevel(s0_s, r3.xy, 0).x;
    r1.y = saturate(r1.y);
    r0.w = r1.y * r0.w;
    // Hue Shift & Hue vs Hue
    r3.z = cb0[7].x + r2.x;
    r1.y = t4.SampleLevel(s0_s, r3.zw, 0).x;
    r1.y = saturate(r1.y);
    r1.y = r1.y + r3.z;
    r1.yzw = float3(-0.5,0.5,-1.5) + r1.yyy;
    r2.x = cmp(r1.y < 0);
    r2.y = cmp(1 < r1.y);
    r1.y = r2.y ? r1.w : r1.y;
    r1.y = r2.x ? r1.z : r1.y;
    r1.yzw = float3(1,0.666666687,0.333333343) + r1.yyy;
    r1.yzw = frac(r1.yzw);
    r1.yzw = r1.yzw * float3(6,6,6) + float3(-3,-3,-3);
    r1.yzw = saturate(float3(-1,-1,-1) + abs(r1.yzw));
    r1.yzw = float3(-1,-1,-1) + r1.yzw;
    r1.yzw = r2.zzz * r1.yzw + float3(1,1,1);
    // Saturation
    r2.xyz = r1.xxx * r1.yzw;
    r2.x = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
    r0.w = dot(cb0[7].yy, r0.ww);
    r1.xyz = r1.xxx * r1.yzw + -r2.xxx;
    r1.xyz = r0.www * r1.xyz + r2.xxx;
    // FastTonemap
    r0.w = max(r1.x, r1.y);
    r0.w = max(r0.w, r1.z);
    r0.w = 1 + r0.w;
    r0.w = rcp(r0.w);
    // Y (master)
    r1.xyz = r1.xyz * r0.www + float3(0.00390625,0.00390625,0.00390625);
    r1.w = 0;
    r2.x = t0.SampleLevel(s0_s, r1.xw, 0).x;
    r2.x = saturate(r2.x);
    r2.y = t0.SampleLevel(s0_s, r1.yw, 0).x;
    r2.y = saturate(r2.y);
    r2.z = t0.SampleLevel(s0_s, r1.zw, 0).x;
    r2.z = saturate(r2.z);
    // RGB
    r1.xyz = float3(0.00390625,0.00390625,0.00390625) + r2.xyz;
    r1.w = 0;
    r2.x = t1.SampleLevel(s0_s, r1.xw, 0).x;
    r2.x = saturate(r2.x);
    r2.y = t2.SampleLevel(s0_s, r1.yw, 0).x;
    r2.y = saturate(r2.y);
    r2.z = t3.SampleLevel(s0_s, r1.zw, 0).x;
    r2.z = saturate(r2.z);
    // FastTonemapInvert
    r0.w = max(r2.x, r2.y);
    r0.w = max(r0.w, r2.z);
    r0.w = 1 + -r0.w;
    r0.w = rcp(r0.w);
    r1.xyz = r2.xyz * r0.www;
      r1.rgb = lerp(preCG, r1.rgb, injectedData.colorGradeLUTStrength);
  } else {
    r1.xyz = r0.xyz * cb0[0].yyy;
      r1.rgb = lutShaper(r1.rgb, true);
  }
    float3 untonemapped = r1.rgb;
// CustomTonemap
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r1.xyz = cb0[18].xxx * r0.xyz;
  r2.xyzw = cmp(r1.xxyy < cb0[18].yzyz);
  r3.xyzw = r2.yyyy ? cb0[21].xyzw : cb0[23].xyzw;
  r4.xyzw = r2.yyww ? cb0[22].xyxy : cb0[24].xyxy;
  r3.xyzw = r2.xxxx ? cb0[19].xyzw : r3.xyzw;
  r4.xyzw = r2.xxzz ? cb0[20].xyxy : r4.xyzw;
  r0.x = r0.x * cb0[18].x + -r3.x;
  r0.x = r0.x * r3.z;
  r0.w = cmp(0 < r0.x);
  r0.x = log2(r0.x);
  r0.x = r4.y * r0.x;
  r0.x = r0.x * 0.693147182 + r4.x;
  r0.x = 1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.w ? r0.x : 0;
  r3.x = r0.x * r3.w + r3.y;
  r5.xyzw = r2.wwww ? cb0[21].xyzw : cb0[23].xyzw;
  r2.xyzw = r2.zzzz ? cb0[19].xyzw : r5.xyzw;
  r0.x = r0.y * cb0[18].x + -r2.x;
  r0.x = r0.x * r2.z;
  r0.y = cmp(0 < r0.x);
  r0.x = log2(r0.x);
  r0.x = r4.w * r0.x;
  r0.x = r0.x * 0.693147182 + r4.z;
  r0.x = 1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.y ? r0.x : 0;
  r3.y = r0.x * r2.w + r2.y;
  r0.xy = cmp(r1.zz < cb0[18].yz);
  r1.xyzw = r0.yyyy ? cb0[21].xyzw : cb0[23].xyzw;
  r0.yw = r0.yy ? cb0[22].xy : cb0[24].xy;
  r1.xyzw = r0.xxxx ? cb0[19].xyzw : r1.xyzw;
  r0.xy = r0.xx ? cb0[20].xy : r0.yw;
  r0.z = r0.z * cb0[18].x + -r1.x;
  r0.z = r0.z * r1.z;
  r0.w = cmp(0 < r0.z);
  r0.z = log2(r0.z);
  r0.y = r0.y * r0.z;
  r0.x = r0.y * 0.693147182 + r0.x;
  r0.x = 1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.w ? r0.x : 0;
  r3.z = r0.x * r1.w + r1.y;
  r0.xyz = max(float3(0,0,0), r3.xyz);
    float3 vanilla = r0.rgb;
    r1.rgb = float3(0.18,0.18,0.18);
  r0.xyz = max(float3(0,0,0), r1.xyz);
  r1.xyz = cb0[18].xxx * r0.xyz;
  r2.xyzw = cmp(r1.xxyy < cb0[18].yzyz);
  r3.xyzw = r2.yyyy ? cb0[21].xyzw : cb0[23].xyzw;
  r4.xyzw = r2.yyww ? cb0[22].xyxy : cb0[24].xyxy;
  r3.xyzw = r2.xxxx ? cb0[19].xyzw : r3.xyzw;
  r4.xyzw = r2.xxzz ? cb0[20].xyxy : r4.xyzw;
  r0.x = r0.x * cb0[18].x + -r3.x;
  r0.x = r0.x * r3.z;
  r0.w = cmp(0 < r0.x);
  r0.x = log2(r0.x);
  r0.x = r4.y * r0.x;
  r0.x = r0.x * 0.693147182 + r4.x;
  r0.x = 1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.w ? r0.x : 0;
  r3.x = r0.x * r3.w + r3.y;
  r5.xyzw = r2.wwww ? cb0[21].xyzw : cb0[23].xyzw;
  r2.xyzw = r2.zzzz ? cb0[19].xyzw : r5.xyzw;
  r0.x = r0.y * cb0[18].x + -r2.x;
  r0.x = r0.x * r2.z;
  r0.y = cmp(0 < r0.x);
  r0.x = log2(r0.x);
  r0.x = r4.w * r0.x;
  r0.x = r0.x * 0.693147182 + r4.z;
  r0.x = 1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.y ? r0.x : 0;
  r3.y = r0.x * r2.w + r2.y;
  r0.xy = cmp(r1.zz < cb0[18].yz);
  r1.xyzw = r0.yyyy ? cb0[21].xyzw : cb0[23].xyzw;
  r0.yw = r0.yy ? cb0[22].xy : cb0[24].xy;
  r1.xyzw = r0.xxxx ? cb0[19].xyzw : r1.xyzw;
  r0.xy = r0.xx ? cb0[20].xy : r0.yw;
  r0.z = r0.z * cb0[18].x + -r1.x;
  r0.z = r0.z * r1.z;
  r0.w = cmp(0 < r0.z);
  r0.z = log2(r0.z);
  r0.y = r0.y * r0.z;
  r0.x = r0.y * 0.693147182 + r0.x;
  r0.x = 1.44269502 * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.w ? r0.x : 0;
  r3.z = r0.x * r1.w + r1.y;
  r0.xyz = max(float3(0,0,0), r3.xyz);
    float midGray = renodx::color::y::from::BT709(r0.rgb);
    r0.rgb = applyUserTonemap(untonemapped, vanilla, midGray);
  r0.w = 1;
  u0[vThreadID.xyz] = r0.xyzw;
  return;
}