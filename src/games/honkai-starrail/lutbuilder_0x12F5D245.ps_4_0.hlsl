#include "./tonemap.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sat Nov  8 01:13:21 2025

// 3Dmigoto declarations

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yz = -cb0[25].yz + v1.xy;
  r1.x = cb0[25].x * r0.y;
  r0.x = frac(r1.x);
  r1.x = r0.x / cb0[25].x;
  r0.w = -r1.x + r0.y;

  // ARRI_C1000_NO_CUT
  r0.xyz = r0.xzw * cb0[25].www + float3(-0.413588405, -0.413588405, -0.413588405);
  r0.xyz = r0.xyz * cb0[27].zzz + float3(0.0275523961, 0.0275523961, 0.0275523961);
  r0.xyz = float3(13.6054821, 13.6054821, 13.6054821) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(-0.0479959995, -0.0479959995, -0.0479959995) + r0.xyz;
  r0.xyz = float3(0.179999992, 0.179999992, 0.179999992) * r0.xyz;

  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.w = dot(r0.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
  r1.x = 1 / cb0[14].x;
  r1.x = saturate(r1.x * r0.w);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = -r1.y * r1.x + 1;
  r1.y = 1 + -cb0[14].y;
  r1.z = -cb0[14].y + r0.w;
  r1.y = 1 / r1.y;
  r1.y = saturate(r1.z * r1.y);
  r1.z = r1.y * -2 + 3;
  r1.y = r1.y * r1.y;
  r1.w = r1.z * r1.y;
  r2.x = 1 + -r1.x;
  r1.y = -r1.z * r1.y + r2.x;
  r2.xyz = cb0[5].xyz * cb0[5].www;
  r0.xyz = r0.xyz + -r0.www;
  r2.xyz = r2.xyz * r0.xyz + r0.www;
  r2.xyz = max(float3(0.00100000005, 0.00100000005, 0.00100000005), r2.xyz);
  r2.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r2.xyz;
  r3.xyz = cb0[6].xyz * cb0[6].www;
  r2.xyz = log2(r2.xyz);
  r2.xyz = r3.xyz * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r2.xyz;
  r3.xyz = cb0[7].xyz * cb0[7].www;
  r2.xyz = r3.xyz * r2.xyz;
  r3.xyz = cb0[11].xyz * cb0[11].www;
  r3.xyz = r3.xyz * r0.xyz + r0.www;
  r3.xyz = max(float3(0.00100000005, 0.00100000005, 0.00100000005), r3.xyz);
  r3.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r3.xyz;
  r4.xyz = cb0[12].xyz * cb0[12].www;
  r3.xyz = log2(r3.xyz);
  r3.xyz = r4.xyz * r3.xyz;
  r3.xyz = exp2(r3.xyz);
  r3.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r3.xyz;
  r4.xyz = cb0[13].xyz * cb0[13].www;
  r3.xyz = r4.xyz * r3.xyz;
  r4.xyz = cb0[8].xyz * cb0[8].www;
  r0.xyz = r4.xyz * r0.xyz + r0.www;
  r0.xyz = max(float3(0.00100000005, 0.00100000005, 0.00100000005), r0.xyz);
  r0.xyz = float3(5.55555534, 5.55555534, 5.55555534) * r0.xyz;
  r4.xyz = cb0[9].xyz * cb0[9].www;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r4.xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(0.180000007, 0.180000007, 0.180000007) * r0.xyz;
  r4.xyz = cb0[10].xyz * cb0[10].www;
  r0.xyz = r4.xyz * r0.xyz;
  r0.xyz = r0.xyz * r1.yyy;
  r0.xyz = r2.xyz * r1.xxx + r0.xyz;
  r0.xyz = r3.xyz * r1.www + r0.xyz;
  r1.x = cb0[0].x + cb0[0].y;
  r1.y = 0.5 * r1.x;
  r0.w = cmp(r1.y < r0.w);
  r1.yzw = -r1.xxx * float3(0.5, 0.5, 0.5) + r0.xyz;
  r2.x = -r1.x * 0.5 + cb0[0].x;
  r1.yzw = r1.yzw / r2.xxx;
  r1.yzw = r1.yzw * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
  r1.yzw = max(float3(0, 0, 0), r1.yzw);
  r0.xyz = r1.xxx * float3(0.5, 0.5, 0.5) + -r0.xyz;
  r1.x = r1.x * 0.5 + -cb0[0].y;
  r0.xyz = r0.xyz / r1.xxx;
  r0.xyz = -r0.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = r0.www ? r1.yzw : r0.xyz;
  r0.xyz = cb0[1].xyz * r0.xyz;

  float3 untonemapped_bt709 = r0.rgb;  // moved to after exposure cbuffer

  r0.rgb = ApplyVanillaToneMap(untonemapped_bt709);
  o0.xyz = applyUserTonemap(untonemapped_bt709, r0.xyz);
  o0.w = 1;
  return;
  r0.w = cmp(0.800000012 < cb0[35].z);
  if (r0.w != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  o0.xyz = max(float3(0, 0, 0), r0.xyz);
  o0.w = 1;
  return;
}
