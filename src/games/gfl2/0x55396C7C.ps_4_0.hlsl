#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.2 on Sun Mar 23 14:15:04 2025
Texture2D<float4> t9 : register(t9);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1467];
}




// 3Dmigoto declarations
#define cmp -
//Texture1D<float4> IniParams : register(t120);
//Texture2D<float4> StereoParams : register(t125);


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0.5 < cb0[1403].x);
  r0.yz = float2(-0.5,-0.5) + v1.xy;
  r1.xy = r0.yz * cb0[1412].zz + float2(0.5,0.5);
  r0.yz = r0.yz * cb0[1412].zz + -cb0[1411].xy;
  r0.yz = cb0[1411].zw * r0.yz;
  r0.w = dot(r0.yz, r0.yz);
  r0.w = sqrt(r0.w);
  r1.z = cmp(0 < cb0[1412].w);
  if (r1.z != 0) {
    r1.zw = cb0[1412].xy * r0.ww;
    sincos(r1.z, r2.x, r3.x);
    r1.z = r2.x / r3.x;
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w + -1;
    r1.zw = r0.yz * r1.zz + r1.xy;
  } else {
    r2.x = 1 / r0.w;
    r2.x = cb0[1412].x * r2.x;
    r0.w = cb0[1412].y * r0.w;
    r2.y = min(1, abs(r0.w));
    r2.z = max(1, abs(r0.w));
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z;
    r2.z = r2.y * r2.y;
    r2.w = r2.z * 0.0208350997 + -0.0851330012;
    r2.w = r2.z * r2.w + 0.180141002;
    r2.w = r2.z * r2.w + -0.330299497;
    r2.z = r2.z * r2.w + 0.999866009;
    r2.w = r2.y * r2.z;
    r3.x = cmp(1 < abs(r0.w));
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = r3.x ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r0.w = min(1, r0.w);
    r0.w = cmp(r0.w < -r0.w);
    r0.w = r0.w ? -r2.y : r2.y;
    r0.w = r2.x * r0.w + -1;
    r1.zw = r0.yz * r0.ww + r1.xy;
  }
  r0.xy = r0.xx ? r1.zw : v1.xy;
  r0.z = cmp(0.5 < cb0[1466].x);
  if (r0.z != 0) {
    r1.xyzw = t9.Sample(s1_s, r0.xy).xyzw;
    r0.xy = r1.xy + r0.xy;
  }

  r1.xyzw = t0.Sample(s3_s, r0.xy).xyzw;
  r2.xyzw = t2.Sample(s1_s, r0.xy).xyzw;
  r3.xyzw = t3.Sample(s1_s, r0.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r0.z = cmp(0 < cb0[1407].x);
  r3.xyz = r2.xyz * r2.www;
  r3.xyz = float3(8,8,8) * r3.xyz;
  r2.xyz = r0.zzz ? r3.xyz : r2.xyz;
  r2.xyz = r2.xyz * CUSTOM_BLOOM + r1.xyz;
  float3 untonemapped = r2.xyz;
  r0.z = cmp(0 < cb0[1415].z);
  if (r0.z != 0) {
    r0.xy = -cb0[1415].xy + r0.xy;
    r0.yz = cb0[1415].zz * abs(r0.xy);
    r0.x = cb0[1414].w * r0.y;
    r0.x = dot(r0.xz, r0.xz);
    r0.x = 1 + -r0.x;
    r0.x = max(0, r0.x);
    r0.x = log2(r0.x);
    r0.x = cb0[1415].w * r0.x;
    r0.x = exp2(r0.x);
    r0.yzw = float3(1,1,1) + -cb0[1414].xyz;
    r0.xyz = r0.xxx * r0.yzw + cb0[1414].xyz;
    r2.xyz = r2.xyz * r0.xyz;
  }

  r0.xyz = cb0[1404].www * r2.zxy;
  r0.xyz = r0.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009));
  r0.yzw = cb0[1404].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r2.xy = float2(0.5,0.5) * cb0[1404].xy;
  r2.yz = r0.zw * cb0[1404].xy + r2.xy;
  r2.x = r0.y * cb0[1404].y + r2.y;
  r3.xyzw = t5.SampleLevel(s1_s, r2.xz, 0).xyzw;
  r4.x = cb0[1404].y;
  r4.y = 0;
  r0.zw = r4.xy + r2.xz;
  r2.xyzw = t5.SampleLevel(s1_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[1404].z + -r0.y;
  r0.yzw = r2.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  r0.w = cmp(0 < cb0[1405].w);
  if (r0.w != 0) {
    r0.xyz = saturate(r0.xyz);
    r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
    r3.xyz = log2(r0.xyz);
    r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r4.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
    r2.xyz = r4.xyz ? r2.xyz : r3.xyz;
    r3.xyz = cb0[1405].zzz * r2.zxy;
    r0.w = floor(r3.x);
    r3.xw = float2(0.5,0.5) * cb0[1405].xy;
    r3.yz = r3.yz * cb0[1405].xy + r3.xw;
    r3.x = r0.w * cb0[1405].y + r3.y;
    r4.xyzw = t6.SampleLevel(s1_s, r3.xz, 0).xyzw;
    r5.x = cb0[1405].y;
    r5.y = 0;
    r3.xy = r5.xy + r3.xz;
    r3.xyzw = t6.SampleLevel(s1_s, r3.xy, 0).xyzw;
    r0.w = r2.z * cb0[1405].z + -r0.w;
    r3.xyz = r3.xyz + -r4.xyz;
    r3.xyz = r0.www * r3.xyz + r4.xyz;
    r3.xyz = r3.xyz + -r2.xyz;
    r2.xyz = cb0[1405].www * r3.xyz + r2.xyz;
    r3.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r2.xyz;
    r4.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r2.xyz;
    r4.xyz = float3(0.947867334,0.947867334,0.947867334) * r4.xyz;
    r4.xyz = log2(abs(r4.xyz));
    r4.xyz = float3(2.4000001,2.4000001,2.4000001) * r4.xyz;
    r4.xyz = exp2(r4.xyz);
    r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r2.xyz);
    r0.xyz = r2.xyz ? r3.xyz : r4.xyz;
  }
  r0.w = cmp(0 < cb0[1463].z);
  if (r0.w != 0) {
    r2.yz = cb0[1463].yx + v1.yx;
    r3.xy = -cb0[1463].xy + v1.xy;
    r4.xyzw = t8.Sample(s1_s, v1.xy).xyzw;
    r0.w = cmp(0 < cb0[1463].w);
    if (r0.w != 0) {
      r3.zw = v1.yx;
      r5.xyzw = t8.Sample(s1_s, r3.xz).xyzw;
      r2.xw = v1.yx;
      r6.xyzw = t8.Sample(s1_s, r2.zx).xyzw;
      r7.xyzw = t8.Sample(s1_s, r2.wy).xyzw;
      r8.xyzw = t8.Sample(s1_s, r3.wy).xyzw;
      r0.w = r6.x + r5.x;
      r0.w = r0.w + r7.x;
      r0.w = r0.w + r8.x;
    } else {
      r0.w = 0;
    }
    r2.xw = r3.xy;
    r5.xyzw = t8.Sample(s1_s, r2.xy).xyzw;
    r6.xyzw = t8.Sample(s1_s, r2.zy).xyzw;
    r3.xyzw = t8.Sample(s1_s, r3.xy).xyzw;
    r2.xyzw = t8.Sample(s1_s, r2.zw).xyzw;
    r0.w = r5.x + r0.w;
    r0.w = r0.w + r6.x;
    r0.w = r0.w + r3.x;
    r0.w = saturate(r0.w + r2.x);
    r0.w = saturate(r0.w + -r4.x);
    r2.xyzw = cb0[1464].xyzw * r0.wwww;
    r3.xyzw = cb0[1465].xyzw * r4.xxxx;
    r2.xyzw = saturate(max(r3.xyzw, r2.xyzw));
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = r2.www * r2.xyz + r0.xyz;
  }
  r2.xy = v1.xy * cb0[1417].xy + cb0[1417].zw;
  r2.xyzw = t4.Sample(s2_s, r2.xy).xyzw;
  r0.w = -0.5 + r2.w;
  r0.w = r0.w + r0.w;
  r2.x = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r2.x = sqrt(r2.x);
  r2.x = cb0[1416].y * -r2.x + 1;
  r2.yzw = r0.xyz * r0.www;
  r2.yzw = cb0[1416].xxx * r2.yzw;
  r1.xyz = r2.yzw * r2.xxx + r0.xyz;
  r0.x = cmp(0.5 < cb0[1448].y);
  if (r0.x != 0) {
    r0.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
    r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
    r2.xyzw = cb0[3].xyzw * r0.zzzz;
    r2.xyzw = cb0[2].xyzw * r0.yyyy + r2.xyzw;
    r0.xyzw = cb0[4].xyzw * r0.xxxx + r2.xyzw;
    r0.xyzw = cb0[5].xyzw + r0.xyzw;
    r0.xyz = r0.xyz / r0.www;
    r0.xyz = -cb0[1295].xyz + r0.xyz;
    r0.w = dot(r0.xyz, r0.xyz);
    r2.x = rsqrt(r0.w);
    r0.xyz = r2.xxx * r0.xyz;
    r0.y = cb0[1295].y / r0.y;
    r0.w = sqrt(r0.w);
    r0.y = min(abs(r0.y), r0.w);
    r0.xy = r0.xz * r0.yy + cb0[1295].xz;
    r0.xy = -cb0[1450].zw + r0.xy;
    r0.xy = cb0[1450].xy * r0.xy;
    r0.xyzw = t7.Sample(s1_s, r0.xy).xyzw;
    r0.x = 1 + -r0.y;
    r0.y = cb0[1449].w * r0.x;
    r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * cb0[1449].xyz;
    r3.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + cb0[1449].xyz;
    r3.xyz = float3(0.947867334,0.947867334,0.947867334) * r3.xyz;
    r3.xyz = log2(abs(r3.xyz));
    r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r4.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= cb0[1449].xyz);
    r2.xyz = r4.xyz ? r2.xyz : r3.xyz;
    r0.x = -r0.x * cb0[1449].w + 1;
    r0.xzw = r1.xyz * r0.xxx;
    r1.xyz = r2.xyz * r0.yyy + r0.xzw;
  }
  o0.xyzw = r1.xyzw;

  o0.rgb = renodx::draw::ToneMapPass(untonemapped, o0.rgb);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}