#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[12];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v0.xy;
  r0.zw = r0.xy + r0.xy;
  r0.xy = cb0[7].yy * r0.xy;
  r0.xy = log2(abs(r0.xy));
  r0.xy = cb0[7].ww * r0.xy;
  r0.xy = exp2(r0.xy);
  r0.x = r0.x + r0.y;
  r0.x = sqrt(r0.x);
  r0.x = 1 + -r0.x;
  r0.y = r0.w / cb0[3].w;
  r0.y = r0.y * r0.y + 1;
  r0.y = -cb0[4].x + r0.y;
  r1.x = r0.z * r0.y;
  r0.y = r1.x / cb0[3].w;
  r0.y = r0.y * r0.y + -cb0[4].x;
  r0.y = 1 + r0.y;
  r1.y = r0.w * r0.y;
  r0.y = 0.5 * r1.y;
  r1.yz = r1.yx * float2(0.5,0.5) + float2(0.5,0.5);
  r0.zw = r1.xx * float2(0.5,0.5) + float2(0.5,0.5);
  r1.xw = cb0[2].zw / cb0[5].zw;
  r2.x = 0.5 * r1.x;
  r3.xy = cb0[2].xy * r1.xw;
  r1.x = ceil(r2.x);
  r1.w = -1 + r1.x;
  r2.x = cb0[2].x * r1.x;
  r4.x = cb0[2].x * r1.w;
  r4.yz = float2(0.5,0);
  r1.xw = r4.xy + r0.zy;
  r4.xy = -r4.xz + r1.zy;
  r4.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r4.xyz = InvertToneMapScale(r4.xyz);
  }
  r5.xyzw = t0.Sample(s0_s, r1.xw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r5.xyz = InvertToneMapScale(r5.xyz);
  }
  r0.z = cb0[4].w * r5.x;
  r1.xw = cb0[5].xy * r5.yz;
  r0.z = max(r1.x, r0.z);
  r0.z = max(r0.z, r1.w);
  r5.xyzw = r5.xyzw * r0.zzzz;
  r0.z = min(1, r0.z);
  r0.z = 2 + r0.z;
  r1.xw = cb0[4].yy + r1.zy;
  r6.xyzw = t0.Sample(s0_s, r1.xw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r6.xyz = InvertToneMapScale(r6.xyz);
  }
  r7.xyzw = t0.Sample(s0_s, r1.zy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r7.xyz = InvertToneMapScale(r7.xyz);
  }
  r6.xyzw = r7.xyzw + r6.xyzw;
  r7.xyzw = cb0[4].yyyy * float4(1,-1,-1,1) + r1.zyzy;
  r8.xyzw = t0.Sample(s0_s, r7.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r8.xyz = InvertToneMapScale(r8.xyz);
  }
  r7.xyzw = t0.Sample(s0_s, r7.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r7.xyz = InvertToneMapScale(r7.xyz);
  }
  r6.xyzw = r8.xyzw + r6.xyzw;
  r6.xyzw = r6.xyzw + r7.xyzw;
  r1.xw = -cb0[4].yy + r1.zy;
  r7.xyzw = t0.Sample(s0_s, r1.xw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r7.xyz = InvertToneMapScale(r7.xyz);
  }
  r6.xyzw = r7.xyzw + r6.xyzw;
  r1.xw = cb0[10].yz + r1.zy;
  r7.xyzw = t0.Sample(s0_s, r1.xw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r7.xyz = InvertToneMapScale(r7.xyz);
  }
  r6.x = r6.x * 0.2 + r7.x;
  r7.xyzw = cb0[11].xyzw + r1.zyzy;
  r8.xyzw = t0.Sample(s0_s, r7.xy).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r8.xyz = InvertToneMapScale(r8.xyz);
  }
  r7.xyzw = t0.Sample(s0_s, r7.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r7.xyz = InvertToneMapScale(r7.xyz);
  }
  r6.z = r6.z * 0.2 + r7.z;
  r6.y = r6.y * 0.2 + r8.y;
  r5.xyzw = r6.xyzw * float4(1,1,1,0.4) + r5.xyzw;
  r2.yz = float2(0.5,0);
  r0.yw = r2.xy + r0.wy;
  r1.xw = -r2.xz + r1.zy;
  r2.xyzw = t0.Sample(s0_s, r1.xw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r2.xyz = InvertToneMapScale(r2.xyz);
  }
  r6.xyzw = t0.Sample(s0_s, r0.yw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r6.xyz = InvertToneMapScale(r6.xyz);
  }
  r0.y = cb0[4].w * r6.x;
  r1.xw = cb0[5].xy * r6.yz;
  r0.y = max(r1.x, r0.y);
  r0.y = max(r0.y, r1.w);
  r5.xyzw = r6.xyzw * r0.yyyy + r5.xyzw;
  r0.y = min(1, r0.y);
  r0.y = r0.z + r0.y;
  r0.z = cb0[4].w * r4.x;
  r1.xw = cb0[5].xy * r4.yz;
  r0.z = max(r1.x, r0.z);
  r0.z = max(r0.z, r1.w);
  r4.xyzw = r4.xyzw * r0.zzzz + r5.xyzw;
  r0.z = min(1, r0.z);
  r0.y = r0.y + r0.z;
  r0.z = cb0[4].w * r2.x;
  r1.xw = cb0[5].xy * r2.yz;
  r0.z = max(r1.x, r0.z);
  r0.z = max(r0.z, r1.w);
  r2.xyzw = r2.xyzw * r0.zzzz + r4.xyzw;
  r0.z = min(1, r0.z);
  r0.y = r0.y + r0.z;
  r2.xyzw = r2.xyzw / r0.yyyy;
  r0.y = -cb0[2].y * 0.5 + r1.y;
  r0.y = r0.y / r3.y;
  r0.y = r0.y >= -r0.y ? frac(abs(r0.y)) : -frac(abs(r0.y));
  r0.y = r0.y * r3.y;
  r0.y = cb0[5].w * r0.y;
  r0.y = 3.14159274 * r0.y;
  r0.y = sin(r0.y);
  r0.y = max(0.4, r0.y);
  r0.y = -1 + r0.y;
  r0.y = cb0[6].x * r0.y + 1;
  r2.xyzw = r2.xyzw * r0.yyyy;
  r0.y = cb0[2].z * r1.z;
  r0.y = floor(r0.y);
  r0.y = 0.5 * r0.y;
  r0.y = r0.y >= -r0.y ? frac(abs(r0.y)) : -frac(abs(r0.y));
  r0.y = r0.y + r0.y;
  r0.y = -r0.y * cb0[6].y + 1;
  r4.xyzw = r2.xyzw * r0.yyyy;
  r0.z = r4.x + r4.y;
  r0.y = r2.z * r0.y + r0.z;
  r3.w = -1 * r3.y;
  r0.zw = r3.xw * float2(0.5,1) + r1.zy;
  r2.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r2.xyz = InvertToneMapScale(r2.xyz);
  }
  r0.z = max(r2.y, r2.z);
  r0.z = max(r2.x, r0.z);
  //r0.yz = cmp(r0.yz >= float2(0.100000001,0.400000006));
  r0.w = (r0.z >= 0.4) ? -1 : -0;
  //r0.z = (r0.z >= 0.4) ? 1.000000 : 0;
  r0.z = step(0.4f, r0.z);
  r2.xyzw = r2.xyzw * r0.zzzz;
  r1.xw = r3.xy * float2(-0.5,-1) + r1.zy;
  r5.xyzw = t0.Sample(s0_s, r1.xw).xyzw;
  if(injectedData.countOld == injectedData.countNew){
    r5.xyz = InvertToneMapScale(r5.xyz);
  }
  r0.z = max(r5.y, r5.z);
  r0.z = max(r5.x, r0.z);
  //r0.z = (r0.z >= 0.4) ? 1.000000 : 0;
  r0.z = step(0.4f, r0.z);
  r0.w = r0.z + r0.w;
  r2.xyzw = r5.xyzw * r0.zzzz + r2.xyzw;
  r0.z = cb0[4].z * abs(r0.w);
  r0.y = (r0.y >= 0.1) ? 0 : r0.z;
  r0.z = r1.y / r3.y;
  r0.z = r0.z >= -r0.z ? frac(abs(r0.z)) : -frac(abs(r0.z));
  r0.z = r0.z * r3.y;
  r0.z = -r0.z * cb0[5].w + 1;
  r0.y = r0.y * r0.z;
  r2.xyzw = r2.xyzw * r0.yyyy + r4.xyzw;
  r2.xyzw = log2(r2.xyzw);
  r0.y = 1 / cb0[9].y;
  r2.xyzw = r0.yyyy * r2.xyzw;
  r2.xyzw = exp2(r2.xyzw);
  r2.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r2.xyzw;
  r2.xyzw = cb0[9].xxxx * r2.xyzw + float4(0.5,0.5,0.5,0.5);
  r2.xyzw = cb0[8].wwww + r2.xyzw;
  r2.xy = cb0[9].zw * r2.xy;
  r2.z = cb0[10].x * r2.z;
  r0.yz = cb0[8].xx * r1.zy;
  r1.xy = cb0[6].zz * r1.yz;
  r1.zw = frac(r0.yz);
  r0.yz = floor(r0.yz);
  r3.xy = r1.zw * float2(-2,-2) + float2(3,3);
  r1.zw = r1.zw * r1.zw;
  r0.w = -r3.x * r1.z + 1;
  r1.zw = r3.xy * r1.zw;
  r3.xyzw = float4(1,0,0,1) + r0.yzyz;
  r3.x = dot(r3.xy, float2(12.4898005,78.2330017));
  r3.y = dot(r3.zw, float2(12.4898005,78.2330017));
  r3.xy = sin(r3.xy);
  r3.xy = float2(43758.543,43758.543) * r3.xy;
  r3.z = cb0[8].z * cb0[3].z;
  r3.z = sin(r3.z);
  r3.xy = r3.xy * r3.zz;
  r3.xy = frac(r3.xy);
  r3.w = dot(r0.yz, float2(12.4898005,78.2330017));
  r0.yz = float2(1,1) + r0.yz;
  r0.y = dot(r0.yz, float2(12.4898005,78.2330017));
  r0.y = sin(r0.y);
  r0.y = 43758.543 * r0.y;
  r0.y = r0.y * r3.z;
  r0.y = frac(r0.y);
  r0.y = r0.y + -r3.x;
  r0.y = r0.y * r1.z;
  r0.z = sin(r3.w);
  r0.z = 43758.543 * r0.z;
  r0.z = r0.z * r3.z;
  r0.z = frac(r0.z);
  r3.x = r3.x + -r0.z;
  r1.z = r1.z * r3.x + r0.z;
  r0.z = r3.y + -r0.z;
  r0.z = r0.z * r1.w;
  r0.z = r0.z * r0.w + r1.z;
  r0.y = r0.y * r1.w + r0.z;
  r3.xyzw = r0.yyyy + -r2.xyzw;
  r2.xyzw = cb0[8].yyyy * r3.xyzw + r2.xyzw;
  r0.y = cb0[6].w * cb0[3].z;
  r0.yz = r1.xy * float2(3.14159274,3.14159274) + r0.yy;
  r0.yz = sin(r0.yz);
  r1.xyzw = r0.yyyy + -r2.xyzw;
  r0.y = saturate(cb0[6].z);
  r0.y = cb0[7].x * r0.y;
  r1.xyzw = r0.yyyy * r1.xyzw + r2.xyzw;
  r2.xyzw = -r1.xyzw + r0.zzzz;
  r0.y = saturate(-cb0[6].z);
  r0.y = cb0[7].x * r0.y;
  r1.xyzw = r0.yyyy * r2.xyzw + r1.xyzw;
  r0.y = 1 / cb0[7].z;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  o0.xyzw = r1.xyzw * r0.xxxx;
  if(injectedData.countOld == injectedData.countNew){
  o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}