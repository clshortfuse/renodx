#include "../tonemap.hlsl"

Texture2D<float4> t5 : register(t5);
Texture3D<float4> t4 : register(t4);
Texture3D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[65];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[2].xy + cb0[2].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if (cb0[34].z > 0) {
    if (cb0[35].z == -1.0) {
      r1.x = 500 * cb0[34].z;
      r1.yz = float2(0.5,0.5) + -v1.xy;
      r1.w = dot(r1.yz, r1.yz);
      r1.w = sqrt(r1.w);
      r1.yz = r1.yz / r1.ww;
      r1.w = log2(r1.w);
      r1.x = r1.x * r1.w;
      r1.x = exp2(r1.x);
      r1.x = -cb0[35].x + r1.x;
      r1.x = max(0, r1.x);
      r1.xy = r1.yz * r1.xx + v1.xy;
      r2.z = dot(r0.xyz, float3(0.0396819152,0.45802179,0.00609653955));
      r2.xy = float2(5,5);
      r2.xyz = float3(0.441,0.156,5) * r2.xyz;
      r1.zw = float2(0.5,0.5) + -r1.xy;
      r2.w = dot(r1.zw, r1.zw);
      r2.w = rsqrt(r2.w);
      r1.zw = r2.ww * r1.zw;
      r2.xyz = cb0[3].xxx * r2.xyz;
      r3.xyzw = r1.zwzw * r2.xxyy + r1.xyxy;
      r3.xyzw = r3.xyzw * cb0[2].xyxy + cb0[2].zwzw;
      r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
      r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
      r1.xy = r1.zw * r2.zz + r1.xy;
      r1.xy = r1.xy * cb0[2].xy + cb0[2].zw;
      r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
      r0.x = r4.x;
      r0.y = r3.y;
      r0.z = r1.z;
    } else {
      r1.y = cb0[35].z > 0 ? v1.x : v1.y;
      r1.x = v1.x;
      r1.xy = float2(-0.5,-0.5) + r1.xy;
      r1.x = dot(r1.xy, r1.xy);
      r1.x = sqrt(r1.x);
      r1.y = cb0[35].y + -cb0[35].x;
      r1.x = -cb0[35].x + r1.x;
      r1.y = 1 / r1.y;
      r1.x = saturate(r1.x * r1.y);
      r1.y = r1.x * -2 + 3;
      r1.x = r1.x * r1.x;
      r1.x = r1.y * r1.x;
      r1.y = cb0[34].z * r1.x;
      r1.zw = cb0[34].zz * r1.xx + v1.xy;
      r1.zw = r1.zw * cb0[2].xy + cb0[2].zw;
      r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
      r1.zw = -cb0[34].zz * r1.xx + v1.xy;
      r1.zw = r1.zw * cb0[2].xy + cb0[2].zw;
      r3.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
      r1.y = -r1.y * 0.5 + 1;
      r3.x = r2.x;
      r3.y = r0.y;
      r1.yzw = r3.xyz * r1.yyy + -r0.xyz;
      r0.xyz = r1.xxx * r1.yzw + r0.xyz;
    }
  }
  //r1.xy = cmp(float2(0,0) < cb0[63].yx);
  if (cb0[63].y > 0) {
    r1.xz = w1.xy * cb0[64].xy + cb0[64].zw;
    r2.xyzw = t1.Sample(s5_s, r1.xz).xyzw;
    r1.x = dot(r0.xyz, float3(0.0396819152,0.45802179,0.00609653955));
    r1.x = r1.x * r1.x;
    r1.x = -r1.x * cb0[63].z + r2.x;
    r1.x = max(0, r1.x);
    r0.xyz = r1.xxx * -r0.xyz + r0.xyz;
  }
  //r1.xz = cmp(float2(0,5) < cb0[6].xx);
  if (cb0[6].x > 0) {
    r1.x = frac(cb1[0].y);
    r2.xyz = w1.xyx + r1.xxx;
    r1.x = 0.045 * cb0[32].y;
    r3.xyz = float3(443.897491,397.297302,491.187103) * r2.zyz;
    r3.xyz = frac(r3.xyz);
    r4.xyz = float3(19.19,19.19,19.19) + r3.yzx;
    r1.w = dot(r3.xyz, r4.xyz);
    r3.xyz = r3.xyz + r1.www;
    r1.w = r3.x + r3.y;
    r1.w = r1.w * r3.z;
    r1.w = frac(r1.w);
    r3.xyzw = float4(0.593739986,0.593739986,0.1,0.1) + r2.zyzy;
    r4.xyz = float3(443.897491,397.297302,491.187103) * r3.xyx;
    r4.xyz = frac(r4.xyz);
    r5.xyz = float3(19.19,19.19,19.19) + r4.yzx;
    r2.w = dot(r4.xyz, r5.xyz);
    r4.xyz = r4.xyz + r2.www;
    r2.w = r4.x + r4.y;
    r2.w = r2.w * r4.z;
    r2.w = frac(r2.w);
    r1.w = r2.w + r1.w;
    r4.x = -0.5 + r1.w;
    r3.xyz = float3(443.897491,397.297302,491.187103) * r3.zwz;
    r3.xyz = frac(r3.xyz);
    r5.xyz = float3(19.19,19.19,19.19) + r3.yzx;
    r1.w = dot(r3.xyz, r5.xyz);
    r3.xyz = r3.xyz + r1.www;
    r1.w = r3.x + r3.y;
    r1.w = r1.w * r3.z;
    r1.w = frac(r1.w);
    r3.xyzw = float4(0.69374,0.69374,0.14,0.14) + r2.zyzy;
    r5.xyz = float3(443.897491,397.297302,491.187103) * r3.xyx;
    r5.xyz = frac(r5.xyz);
    r6.xyz = float3(19.19,19.19,19.19) + r5.yzx;
    r2.w = dot(r5.xyz, r6.xyz);
    r5.xyz = r5.xyz + r2.www;
    r2.w = r5.x + r5.y;
    r2.w = r2.w * r5.z;
    r2.w = frac(r2.w);
    r1.w = r2.w + r1.w;
    r4.y = -0.5 + r1.w;
    r3.xyz = float3(443.897491,397.297302,491.187103) * r3.zwz;
    r3.xyz = frac(r3.xyz);
    r5.xyz = float3(19.1900005,19.1900005,19.1900005) + r3.yzx;
    r1.w = dot(r3.xyz, r5.xyz);
    r3.xyz = r3.xyz + r1.www;
    r1.w = r3.x + r3.y;
    r1.w = r1.w * r3.z;
    r1.w = frac(r1.w);
    r2.xyz = float3(0.733739972,0.733739972,0.733739972) + r2.xyz;
    r2.xyz = float3(443.897491,397.297302,491.187103) * r2.xyz;
    r2.xyz = frac(r2.xyz);
    r3.xyz = float3(19.1900005,19.1900005,19.1900005) + r2.yzx;
    r2.w = dot(r2.xyz, r3.xyz);
    r2.xyz = r2.xyz + r2.www;
    r2.x = r2.x + r2.y;
    r2.x = r2.x * r2.z;
    r2.x = frac(r2.x);
    r1.w = r2.x + r1.w;
    r4.z = -0.5 + r1.w;
    r0.xyz = r4.xyz * r1.xxx + r0.xyz;
  }
  if (cb0[58].x > 0) {
    r1.xw = w1.xy * cb0[5].xy + cb0[5].zw;
    r2.xyzw = t2.Sample(s1_s, r1.xw).xyzw;
    r1.xw = cb1[7].zx * r2.xx + cb1[7].wy;
    r1.xw = float2(1,1) / r1.xw;
    r1.x = -cb0[57].x + r1.x;
    r2.x = cb0[57].w + -cb0[57].x;
    r1.x = saturate(r1.x / r2.x);
    r1.x = log2(r1.x);
    r1.x = cb0[53].z * r1.x;
    r1.x = exp2(r1.x);
    r1.x = (r1.w > cb0[54].x) ? 0 : r1.x;
    r2.xyz = cb0[52].xyz + -r0.xyz;
    r0.xyz = r1.xxx * r2.xyz + r0.xyz;
  }
  if (cb0[42].x > 0) {
    r2.xyz = max(float3(0,0,0), r0.xyz);
    r2.xyz = r2.xyz / cb0[42].yyy;
    r1.x = -cb0[42].x * 0.5 + 1;
    r1.x = 1 / r1.x;
    r2.xyz = max(float3(9.99999994e-09,9.99999994e-09,9.99999994e-09), r2.xyz);
    r2.xyz = log2(r2.xyz);
    r2.xyz = r2.xyz * r1.xxx;
    r2.xyz = exp2(r2.xyz);
    r3.xyz = float3(1,1,1) + -r2.xyz;
    r4.xyz = r3.xyz * r3.xyz + cb0[42].zzz;
    r4.xyz = sqrt(r4.xyz);
    r3.xyz = -r4.xyz + r3.xyz;
    r2.xyz = r3.xyz * float3(0.5,0.5,0.5) + r2.xyz;
    r1.w = -26.5754242 * r1.x;
    r1.w = exp2(r1.w);
    r2.w = 1 + -r1.w;
    r3.x = r2.w * r2.w + cb0[42].z;
    r3.x = sqrt(r3.x);
    r2.w = -r3.x + r2.w;
    r1.w = r2.w * 0.5 + r1.w;
    r2.w = 1 / cb0[42].y;
    r2.w = max(9.99999994e-09, r2.w);
    r2.w = log2(r2.w);
    r1.x = r2.w * r1.x;
    r1.x = exp2(r1.x);
    r2.w = 1 + -r1.x;
    r3.x = r2.w * r2.w + cb0[42].z;
    r3.x = sqrt(r3.x);
    r2.w = -r3.x + r2.w;
    r1.x = r2.w * 0.5 + r1.x;
    r2.xyz = r2.xyz + -r1.www;
    r1.x = r1.x + -r1.w;
    r0.xyz = r2.xyz / r1.xxx;
    if(injectedData.toneMapType == 0.f){
      r0.xyz = saturate(r0.xyz);
    }
  }
  if (cb0[28].y > 0) {
    r1.xw = float2(-0.5,-0.5) + w1.xy;
    r1.x = dot(r1.xw, r1.xw);
    r1.x = sqrt(r1.x);
    r1.w = cb0[28].x + -cb0[27].w;
    r1.x = r1.x * cb0[28].y + -cb0[27].w;
    r1.w = 1 / r1.w;
    r1.x = saturate(r1.x * r1.w);
    r1.w = r1.x * -2 + 3;
    r1.x = r1.x * r1.x;
    r1.x = r1.w * r1.x;
    r2.xyz = cb0[29].xyz * r0.xyz;
    r3.xyz = -cb0[29].xyz * r0.xyz + r0.xyz;
    r0.xyz = r1.xxx * r3.xyz + r2.xyz;
  }
  if (cb0[41].x > 0) {
    r2.xyz = log2(r0.xyz);
    r2.w = log2(r0.w);
    r2.xyzw = cb0[41].xxxx * r2.xyzw;
    r0.xyzw = exp2(r2.xyzw);
  }
  r2.xyz = handleUserLUT(r0.xyz, t3, s3_s, 0.5 / cb0[49].w, 3, true);
  r2.xyz = r2.xyz + -r0.xyz;
  r2.w = 0;
  r0.xyzw = cb0[50].xxxx * r2.xyzw + r0.xyzw;
  if (cb0[50].w > 0) {
    r2.xyz = handleUserLUT(r0.xyz, t4, s4_s, 0.5 / cb0[49].w, 3, true);
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[50].www * r2.xyz + r0.xyz;
  }
  if (cb0[63].x > 0) {
    if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
    }
    r1.x = dot(r0.xyz, float3(0.2558,0.6511,0.0931));
    r2.xyz = -r1.xxx + r0.xyz;
    r1.y = max(-1, cb0[63].x);
    r1.y = 1 + r1.y;
    r1.xyw = r2.xyz * r1.yyy + r1.xxx;
    r1.xyw = r1.xyw + -r0.xyz;
    r1.xyw = float3(1.44269502,1.44269502,1.44269502) * r1.xyw;
    r2.xyz = exp2(r1.xyw);
    r1.xyw = exp2(-r1.xyw);
    r3.xyz = r2.xyz + -r1.xyw;
    r1.xyw = r2.xyz + r1.xyw;
    r1.xyw = float3(1,1,1) / r1.xyw;
    r0.xyz = r3.xyz * r1.xyw + r0.xyz;
  }
  if (cb0[6].x > 5) {
    r1.xy = asint(cb0[32].zw);
    r1.z = cb1[0].x + r1.y;
    r1.xy = w1.xy + r1.xz;
    r1.x = dot(r1.xy, float2(12.9898,78.233));
    r1.x = sin(r1.x);
    r1.x = 43758.5469 * r1.x;
    r1.x = frac(r1.x);
    r1.yz = w1.xy + r1.xx;
    r1.yz = r1.yz * cb0[30].xy + cb0[30].zw;
    r2.xyzw = t5.Sample(s2_s, r1.yz).xyzw;
    r1.xyz = r2.xyz * r1.xxx;
    r2.xyz = cb0[32].xxx + r0.xyz;
    r2.xyz = min(cb0[32].yyy, r2.xyz);
    r0.xyz = r1.xyz * r2.xyz + r0.xyz;
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
  r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
  r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}