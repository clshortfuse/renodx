#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sun Feb 16 23:16:06 2025
cbuffer cb0 : register(b0) {
  float4 cb0[35];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.yz = -cb0[23].yz + v1.xy;
  r1.x = cb0[23].x * r0.y;
  r0.x = frac(r1.x);
  r1.x = r0.x / cb0[23].x;
  r0.w = -r1.x + r0.y;

  // ARRI_C1000_NO_CUT
  r0.xyz = r0.xzw * cb0[23].www + float3(-0.413588405, -0.413588405, -0.413588405);
  r0.xyz = r0.xyz * cb0[25].zzz + float3(0.0275523961, 0.0275523961, 0.0275523961);
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
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
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
  r3.xyz = max(float3(0, 0, 0), r3.xyz);
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
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
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

  float3 untonemapped = r0.rgb;
  
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = r0.www ? r1.yzw : r0.xyz;
  r0.xyz = cb0[1].xyz * r0.xyz;
  r0.w = cmp(0.5 >= cb0[34].x);
  if (r0.w != 0) {
    r0.w = cmp(0.5 < cb0[33].z);
    if (r0.w != 0) {
      r1.x = dot(float3(0.613189995, 0.339509994, 0.0473700017), r0.xyz);
      r1.y = dot(float3(0.0702100024, 0.916339993, 0.0134500004), r0.xyz);
      r1.z = dot(float3(0.0206199996, 0.109569997, 0.869610012), r0.xyz);
      r0.w = dot(r1.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
      r2.xyz = r1.xyz / r0.www;
      r2.xyz = float3(-1, -1, -1) + r2.xyz;
      r1.w = dot(r2.xyz, r2.xyz);
      r1.w = -4 * r1.w;
      r1.w = exp2(r1.w);
      r1.w = 1 + -r1.w;
      r0.w = r0.w * r0.w;
      r0.w = cb0[33].x * r0.w;
      r0.w = -4 * r0.w;
      r0.w = exp2(r0.w);
      r0.w = 1 + -r0.w;
      r0.w = r1.w * r0.w;
      r2.x = dot(float3(1.37041104, -0.329291195, -0.0636843145), r1.xyz);
      r2.y = dot(float3(-0.0834370106, 1.09708822, -0.0108630517), r1.xyz);
      r2.z = dot(float3(-0.0257899351, -0.0986270159, 1.20369244), r1.xyz);
      r2.xyz = r2.xyz + -r1.xyz;
      r0.xyz = r0.www * r2.xyz + r1.xyz;

      r0.w = cmp(0.5 < cb0[33].w);
      if (r0.w == 0) {
        r1.xyz = cb0[26].xxx * r0.xyz;
        r2.xyzw = cmp(r1.xxyy < cb0[26].yzyz);
        r3.xyzw = r2.yyyy ? cb0[29].xyzw : cb0[31].xyzw;
        r4.xyzw = r2.yyww ? cb0[30].xyxy : cb0[32].xyxy;
        r3.xyzw = r2.xxxx ? cb0[27].xyzw : r3.xyzw;
        r4.xyzw = r2.xxzz ? cb0[28].xyxy : r4.xyzw;
        r0.w = r0.x * cb0[26].x + -r3.x;
        r0.w = r0.w * r3.z;
        r1.x = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r4.y * r0.w;
        r0.w = r0.w * 0.693147182 + r4.x;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.x ? r0.w : 0;
        r3.x = r0.w * r3.w + r3.y;
        r5.xyzw = r2.wwww ? cb0[29].xyzw : cb0[31].xyzw;
        r5.xyzw = r2.zzzz ? cb0[27].xyzw : r5.xyzw;
        r0.w = r0.y * cb0[26].x + -r5.x;
        r0.w = r0.w * r5.z;
        r1.x = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r4.w * r0.w;
        r0.w = r0.w * 0.693147182 + r4.z;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.x ? r0.w : 0;
        r3.y = r0.w * r5.w + r5.y;
        r1.xy = cmp(r1.zz < cb0[26].yz);
        r4.xyzw = r1.yyyy ? cb0[29].xyzw : cb0[31].xyzw;
        r1.yz = r1.yy ? cb0[30].xy : cb0[32].xy;
        r4.xyzw = r1.xxxx ? cb0[27].xyzw : r4.xyzw;
        r1.yz = r1.xx ? cb0[28].xy : r1.yz;
        r0.w = r0.z * cb0[26].x + -r4.x;
        r0.w = r0.w * r4.z;
        r1.w = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r1.z * r0.w;
        r0.w = r0.w * 0.693147182 + r1.y;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.w ? r0.w : 0;
        r3.z = r0.w * r4.w + r4.y;
        r4.xyzw = r2.xxxx ? cb0[27].xyzw : cb0[29].xyzw;
        r5.xyzw = r2.xxzz ? cb0[28].xyxy : cb0[30].xyxy;
        r0.w = r0.x * cb0[26].x + -r4.x;
        r0.w = r0.w * r4.z;
        r1.y = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r5.y * r0.w;
        r0.w = r0.w * 0.693147182 + r5.x;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.y ? r0.w : 0;
        r0.w = r0.w * r4.w + r4.y;
        r0.w = r0.w / cb0[33].y;
        r1.yz = float2(-0.899999976, -0.699999988) + r0.ww;
        r1.w = cmp(0.200000003 >= abs(r1.y));
        r1.z = r1.z * r1.z;
        r1.z = r1.z * -1.171875 + r0.w;
        r2.x = cmp(0.200000003 < r1.y);
        r1.y = r1.y * 0.0625 + 0.899999976;
        r0.w = r2.x ? r1.y : r0.w;
        r0.w = r1.w ? r1.z : r0.w;
        r4.x = cb0[33].y * r0.w;
        r2.xyzw = r2.zzzz ? cb0[27].xyzw : cb0[29].xyzw;
        r0.w = r0.y * cb0[26].x + -r2.x;
        r0.w = r0.w * r2.z;
        r1.y = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r5.w * r0.w;
        r0.w = r0.w * 0.693147182 + r5.z;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.y ? r0.w : 0;
        r0.w = r0.w * r2.w + r2.y;
        r0.w = r0.w / cb0[33].y;
        r1.yz = float2(-0.899999976, -0.699999988) + r0.ww;
        r1.w = cmp(0.200000003 >= abs(r1.y));
        r1.z = r1.z * r1.z;
        r1.z = r1.z * -1.171875 + r0.w;
        r2.x = cmp(0.200000003 < r1.y);
        r1.y = r1.y * 0.0625 + 0.899999976;
        r0.w = r2.x ? r1.y : r0.w;
        r0.w = r1.w ? r1.z : r0.w;
        r4.y = cb0[33].y * r0.w;
        r2.xyzw = r1.xxxx ? cb0[27].xyzw : cb0[29].xyzw;
        r1.xy = r1.xx ? cb0[28].xy : cb0[30].xy;
        r0.w = r0.z * cb0[26].x + -r2.x;
        r0.w = r0.w * r2.z;
        r1.z = cmp(0 < r0.w);
        r0.w = log2(r0.w);
        r0.w = r1.y * r0.w;
        r0.w = r0.w * 0.693147182 + r1.x;
        r0.w = 1.44269502 * r0.w;
        r0.w = exp2(r0.w);
        r0.w = r1.z ? r0.w : 0;
        r0.w = r0.w * r2.w + r2.y;
        r0.w = r0.w / cb0[33].y;
        r1.xy = float2(-0.899999976, -0.699999988) + r0.ww;
        r1.z = cmp(0.200000003 >= abs(r1.x));
        r1.y = r1.y * r1.y;
        r1.y = r1.y * -1.171875 + r0.w;
        r1.w = cmp(0.200000003 < r1.x);
        r1.x = r1.x * 0.0625 + 0.899999976;
        r0.w = r1.w ? r1.x : r0.w;
        r0.w = r1.z ? r1.y : r0.w;
        r4.z = cb0[33].y * r0.w;
        r0.w = dot(r4.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
        r1.x = dot(r3.xyz, float3(0.272228986, 0.674081981, 0.0536894985));
        r1.y = cmp(r1.x < 9.99999997e-07);
        r0.w = r0.w / r1.x;
        r0.w = r1.y ? 0 : r0.w;
        r1.xyz = r3.xyz * r0.www;

        // AP1_to_sRGB
        r0.x = dot(float3(1.70504999, -0.621789992, -0.0832599998), r1.xyz);
        r0.y = dot(float3(-0.130260006, 1.1408, -0.0105499998), r1.xyz);
        r0.z = dot(float3(-0.0240000002, -0.128969997, 1.15296996), r1.xyz);
      }
    } else {
      r1.xyz = cb0[26].xxx * r0.xyz;
      r2.xyzw = cmp(r1.xxyy < cb0[26].yzyz);
      r3.xyzw = r2.yyyy ? cb0[29].xyzw : cb0[31].xyzw;
      r4.xyzw = r2.yyww ? cb0[30].xyxy : cb0[32].xyxy;
      r3.xyzw = r2.xxxx ? cb0[27].xyzw : r3.xyzw;
      r4.xyzw = r2.xxzz ? cb0[28].xyxy : r4.xyzw;
      r0.w = r0.x * cb0[26].x + -r3.x;
      r0.w = r0.w * r3.z;
      r1.x = cmp(0 < r0.w);
      r0.w = log2(r0.w);
      r0.w = r4.y * r0.w;
      r0.w = r0.w * 0.693147182 + r4.x;
      r0.w = 1.44269502 * r0.w;
      r0.w = exp2(r0.w);
      r0.w = r1.x ? r0.w : 0;
      r0.x = r0.w * r3.w + r3.y;
      r3.xyzw = r2.wwww ? cb0[29].xyzw : cb0[31].xyzw;
      r2.xyzw = r2.zzzz ? cb0[27].xyzw : r3.xyzw;
      r0.w = r0.y * cb0[26].x + -r2.x;
      r0.w = r0.w * r2.z;
      r1.x = cmp(0 < r0.w);
      r0.w = log2(r0.w);
      r0.w = r4.w * r0.w;
      r0.w = r0.w * 0.693147182 + r4.z;
      r0.w = 1.44269502 * r0.w;
      r0.w = exp2(r0.w);
      r0.w = r1.x ? r0.w : 0;
      r0.y = r0.w * r2.w + r2.y;
      r1.xy = cmp(r1.zz < cb0[26].yz);
      r2.xyzw = r1.yyyy ? cb0[29].xyzw : cb0[31].xyzw;
      r1.yz = r1.yy ? cb0[30].xy : cb0[32].xy;
      r2.xyzw = r1.xxxx ? cb0[27].xyzw : r2.xyzw;
      r1.xy = r1.xx ? cb0[28].xy : r1.yz;
      r0.w = r0.z * cb0[26].x + -r2.x;
      r0.w = r0.w * r2.z;
      r1.z = cmp(0 < r0.w);
      r0.w = log2(r0.w);
      r0.w = r1.y * r0.w;
      r0.w = r0.w * 0.693147182 + r1.x;
      r0.w = 1.44269502 * r0.w;
      r0.w = exp2(r0.w);
      r0.w = r1.z ? r0.w : 0;
      r0.z = r0.w * r2.w + r2.y;
    }
  }
  o0.xyz = applyUserTonemap(untonemapped, r0.xyz);
  o0.w = 1;
  return;
  r0.w = cmp(0.800000012 < cb0[33].z);
  if (r0.w != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  o0.xyz = max(float3(0, 0, 0), r0.xyz);
  o0.w = 1;
  return;
}
