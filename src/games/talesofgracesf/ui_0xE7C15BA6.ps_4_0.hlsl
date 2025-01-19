// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 18 19:18:07 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[23];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[134];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  float4 v3 : INTERP2,
  float4 v4 : INTERP3,
  float4 v5 : INTERP4,
  float4 v6 : INTERP5,
  float3 v7 : INTERP6,
  float3 v8 : INTERP7,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cmp(cb1[3].xxxx == float4(4,3,2,0));
  r1.xy = r0.ww ? v1.xy : v2.xy;
  r0.zw = r0.zz ? v3.xy : r1.xy;
  r0.yz = r0.yy ? v4.xy : r0.zw;
  r0.xy = r0.xx ? v5.xy : r0.yz;
  r0.xy = float2(-0.5,-0.5) + r0.xy;
  sincos(cb1[13].w, r1.x, r2.x);
  r2.yz = r1.xx;
  r1.xyz = r2.xyz * float3(0.5,-0.5,0.5) + float3(0.5,0.5,0.5);
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.x = dot(r0.xy, r1.xz);
  r2.y = dot(r0.yx, r1.xy);
  r0.xy = float2(0.5,0.5) + r2.xy;
  r0.zw = cb1[14].xy * cb1[8].yz;
  r0.xy = r0.xy * cb1[14].xy + r0.zw;
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[7].x).xyzw;
  sincos(cb1[13].x, r1.x, r2.x);
  r2.yz = r1.xx;
  r1.xyz = r2.xyz * float3(0.5,-0.5,0.5) + float3(0.5,0.5,0.5);
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.xy = float2(-0.5,-0.5) + v1.xy;
  r3.x = dot(r2.xy, r1.xz);
  r3.y = dot(r2.yx, r1.xy);
  r1.xy = float2(0.5,0.5) + r3.xy;
  r1.zw = cb1[13].yz * cb1[7].xy;
  r1.xy = r1.xy * cb1[13].yz + r1.zw;
  r1.xyzw = t1.SampleBias(s1_s, r1.xy, cb0[7].x).xyzw;
  r2.xyz = r1.xyz * r0.xyz;
  r3.xyz = r2.xyz * float3(2,2,2) + -r1.xyz;
  r3.xyz = cb0[130].yyy * r3.xyz + r1.xyz;
  r4.xyzw = cmp(cb1[1].xxxx == float4(0,1,2,3));
  r2.xyz = r4.www ? r2.xyz : r3.xyz;
  r3.xyz = r1.xyz + -r0.xyz;
  r2.xyz = r4.zzz ? r3.xyz : r2.xyz;
  r3.xyz = r1.xyz + r0.xyz;
  r2.xyz = r4.yyy ? r3.xyz : r2.xyz;
  r0.xyz = r4.xxx ? r0.xyz : r2.xyz;
  r2.x = 1 + -r0.w;
  r1.xyz = r2.xxx * r1.xyz;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = v6.xyz * float3(0.5,0.5,0.5) + r0.xyz;
  r0.xyz = v6.xyz * r0.xyz;
  r2.xyz = r0.xyz + r0.xyz;
  r3.xy = cmp(cb1[0].xx == float2(2,1));
  r0.xyz = r3.yyy ? r2.xyz : r0.xyz;
  r0.xyz = r3.xxx ? r1.xyz : r0.xyz;
  r0.xyz = cb1[12].xyz * r0.xyz;
  r1.xy = cmp(float2(0,0) != cb1[22].zy);
  o0.xyz = r1.yyy ? r0.yyy : r0.xyz;
  r0.x = r1.x ? v6.w : 1;
  r0.x = r0.x * r1.w;
  r0.x = saturate(cb1[12].w * r0.x);
  r0.y = cmp(cb0[133].x >= v7.y);
  r0.y = r0.y ? 0 : r0.x;
  r0.z = cmp(0 != cb0[133].y);
  o0.w = r0.z ? r0.y : r0.x;
  o0.rgb = saturate(o0.rgb);
  return;
}