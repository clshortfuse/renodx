TextureCube<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerComparisonState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb4 : register(b4){
  float4 cb4[26];
}
cbuffer cb3 : register(b3){
  float4 cb3[3];
}
cbuffer cb2 : register(b2){
  float4 cb2[22];
}
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float3 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[5].z / v2.z;
  r0.xyz = v2.xyz * r0.xxx;
  r1.xy = v1.xy / v1.ww;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = cb1[7].x * r2.x + cb1[7].y;
  r0.w = 1 / r0.w;
  r2.xyz = r0.xyz * r0.www;
  r3.xyz = cb2[19].xyz * r2.yyy;
  r2.xyw = cb2[18].xyz * r2.xxx + r3.xyz;
  r2.xyw = cb2[20].xyz * r2.zzz + r2.xyw;
  r2.xyw = cb2[21].xyz + r2.xyw;
  r3.xyz = -cb4[25].xyz + r2.xyw;
  r0.x = dot(r3.xyz, r3.xyz);
  r0.x = sqrt(r0.x);
  r0.x = -r0.z * r0.w + r0.x;
  r0.x = cb4[25].w * r0.x + r2.z;
  r0.yzw = -cb0[4].xyz + r2.xyw;
  r1.z = dot(r0.yzw, r0.yzw);
  r1.w = rsqrt(r1.z);
  r3.xyz = r1.www * r0.yzw;
  r1.z = cb0[4].w * r1.z;
  r4.xyzw = t1.Sample(s1_s, r1.zz).xyzw;
  r0.x = saturate(r0.x * cb4[24].z + cb4[24].w);
  r1.z = cmp(r0.x < 0.99000001);
  if (r1.z != 0) {
    r1.z = max(abs(r0.y), abs(r0.z));
    r1.z = max(r1.z, abs(r0.w));
    r1.z = -cb3[2].z + r1.z;
    r1.z = max(9.99999975e-06, r1.z);
    r1.z = cb3[2].w * r1.z;
    r1.z = cb3[2].y / r1.z;
    r1.z = -cb3[2].x + r1.z;
    r1.z = 1 + -r1.z;
    r4.yzw = float3(0.0078125,0.0078125,0.0078125) + r0.yzw;
    r5.x = t5.SampleCmpLevelZero(s2_s, r4.yzw, r1.z).x;
    r4.yzw = float3(-0.0078125,-0.0078125,0.0078125) + r0.yzw;
    r5.y = t5.SampleCmpLevelZero(s2_s, r4.yzw, r1.z).x;
    r4.yzw = float3(-0.0078125,0.0078125,-0.0078125) + r0.yzw;
    r5.z = t5.SampleCmpLevelZero(s2_s, r4.yzw, r1.z).x;
    r4.yzw = float3(0.0078125,-0.0078125,-0.0078125) + r0.yzw;
    r5.w = t5.SampleCmpLevelZero(s2_s, r4.yzw, r1.z).x;
    r1.z = dot(r5.xyzw, float4(0.25,0.25,0.25,0.25));
    r2.z = 1 + -cb4[24].x;
    r1.z = r1.z * r2.z + cb4[24].x;
  } else {
    r1.z = 1;
  }
  r2.z = 1 + -r1.z;
  r0.x = r0.x * r2.z + r1.z;
  r0.x = r4.x * r0.x;
  r4.xyz = cb0[5].xyz * r0.xxx;
  r5.xyzw = t2.Sample(s3_s, r1.xy).xyzw;
  r6.xyzw = t3.Sample(s4_s, r1.xy).xyzw;
  r7.xyzw = t4.Sample(s5_s, r1.xy).xyzw;
  r1.xyz = r7.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.x = dot(r1.xyz, r1.xyz);
  r0.x = rsqrt(r0.x);
  r1.xyz = r1.xyz * r0.xxx;
  r2.xyz = -cb1[4].xyz + r2.xyw;
  r0.x = dot(r2.xyz, r2.xyz);
  r0.x = rsqrt(r0.x);
  r2.xyz = r2.xyz * r0.xxx;
  r7.xyzw = float4(1,1,1,1) + -r6.wxyz;
  r0.xyz = -r0.yzw * r1.www + -r2.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = max(0.00100000005, r0.w);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.w = dot(r1.xyz, -r2.xyz);
  r1.w = saturate(dot(r1.xyz, -r3.xyz));
  r1.x = saturate(dot(r1.xyz, r0.xyz));
  r0.x = saturate(dot(-r3.xyz, r0.xyz));
  r0.y = r0.x + r0.x;
  r0.y = r0.y * r0.x;
  r0.y = r0.y * r7.x + -0.5;
  r0.z = 1 + -r1.w;
  r1.y = r0.z * r0.z;
  r1.y = r1.y * r1.y;
  r0.z = r1.y * r0.z;
  r0.z = r0.y * r0.z + 1;
  r1.y = 1 + -abs(r0.w);
  r1.z = r1.y * r1.y;
  r1.z = r1.z * r1.z;
  r1.y = r1.z * r1.y;
  r0.y = r0.y * r1.y + 1;
  r0.y = r0.z * r0.y;
  r0.z = r7.x * r7.x;
  r0.z = max(0.00200000009, r0.z);
  r1.y = 1 + -r0.z;
  r1.z = abs(r0.w) * r1.y + r0.z;
  r1.y = r1.w * r1.y + r0.z;
  r0.w = r1.y * abs(r0.w);
  r0.w = r1.w * r1.z + r0.w;
  r0.w = 9.99999975e-06 + r0.w;
  r0.w = 0.5 / r0.w;
  r0.z = r0.z * r0.z;
  r1.y = r1.x * r0.z + -r1.x;
  r1.x = r1.y * r1.x + 1;
  r0.z = 0.318309873 * r0.z;
  r1.x = r1.x * r1.x + 1.00000001e-07;
  r0.z = r0.z / r1.x;
  r0.z = r0.w * r0.z;
  r0.z = 3.14159274 * r0.z;
  r0.yz = r0.yz * r1.ww;
  r0.z = max(0, r0.z);
  r0.w = dot(r6.xyz, r6.xyz);
  r0.w = cmp(r0.w != 0.000000);
  r0.w = r0.w ? 1.000000 : 0;
  r0.z = r0.z * r0.w;
  r1.xyz = r4.xyz * r0.yyy;
  r0.yzw = r0.zzz * r4.xyz;
  r0.x = 1 + -r0.x;
  r1.w = r0.x * r0.x;
  r1.w = r1.w * r1.w;
  r0.x = r1.w * r0.x;
  r2.xyz = r7.yzw * r0.xxx + r6.xyz;
  r0.xyz = r2.xyz * r0.yzw;
  o0.xyz = r5.xyz * r1.xyz + r0.xyz;
  o0.w = 1;
  o0.xyz = max(0.f, o0.xyz);
  return;
}