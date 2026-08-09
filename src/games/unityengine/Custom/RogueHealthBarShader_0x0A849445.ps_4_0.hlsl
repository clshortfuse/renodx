Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[4];
}
cbuffer cb0 : register(b0){
  float4 cb0[131];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD3,
  float4 v3 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.004,0.004) * v1.xy;
  r1.z = cb1[2].z * r0.y;
  r0.y = cb1[2].y * cb0[19].x;
  r1.x = r0.x * cb1[2].z + r0.y;
  r0.x = v1.x * 0.004 + r0.y;
  r1.xyzw = t0.Sample(s0_s, r1.xz).xyzw;
  r0.y = 0.004 * v1.y;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = r0.x + r1.x;
  r0.yz = r0.xx * cb1[2].ww + v2.xy;
  r0.yz = cb1[2].ww * float2(-0.5,-0.5) + r0.yz;
  r1.xy = float2(1,1) / cb1[3].xy;
  r2.x = cb0[128].x;
  r0.w = -r2.x + r1.x;
  r0.w = r0.y + r0.w;
  r0.w = saturate(cb1[3].x * r0.w);
  r1.x = r0.w * r0.w;
  r1.zw = float2(4,4) * cb1[3].xy;
  r2.yw = float2(1,1) / r1.zw;
  r2.y = r2.y + -r2.x;
  r2.y = r2.y + r0.y;
  r3.x = r2.y * r1.z;
  r1.z = -r2.y * r1.z + 1;
  r3.x = saturate(r3.x);
  r2.y = r3.x * r3.x;
  r3.y = r2.y * r3.x;
  r0.w = r1.x * r0.w + r3.y;
  r1.x = ddx(r1.z);
  r3.y = ddy(r1.z);
  r1.x = abs(r3.y) + abs(r1.x);
  r1.x = saturate(r1.z / r1.x);
  r0.w = r1.x * r0.w;
  r1.xz = v2.xy * cb1[0].xy + cb1[0].zw;
  r4.xyzw = t1.Sample(s1_s, r1.xz).xyzw;
  r5.xyzw = cb0[129].xyzw * r4.xyzw;
  r3.yzw = saturate(r0.www * cb0[129].xyz + r5.xyz);
  r5.xyz = r2.yyy * r3.xxx + r3.yzw;
  r3.xyzw = r4.xyzw * v3.xyzw + -r5.xyzw;
  r4.y = -1;
  r4.x = -cb0[130].x;
  r1.xz = r4.xy + abs(r0.yz);
  r4.yz = ddx(r1.xz);
  r6.xy = ddy(r1.xz);
  r4.yz = abs(r6.xy) + abs(r4.yz);
  r1.xz = r1.xz / r4.yz;
  r1.xz = float2(1,1) + -r1.xz;
  r0.w = saturate(min(r1.x, r1.z));
  r3.xyzw = r0.wwww * r3.xyzw + r5.xyzw;
  r0.w = 1 + -r0.y;
  r1.x = 1 + r4.x;
  r1.x = r2.w + -r1.x;
  r1.z = r4.x + r2.w;
  r1.y = r4.x + r1.y;
  r1.yz = r1.yz + r0.yy;
  r1.y = saturate(cb1[3].y * r1.y);
  r0.w = r1.x + r0.w;
  r0.w = saturate(r0.w * r1.w);
  r1.x = r0.w * r0.w;
  r2.y = -r1.z * r1.w + 1;
  r1.z = r1.z * r1.w;
  r1.z = saturate(r1.z);
  r1.w = ddx(r2.y);
  r2.w = ddy(r2.y);
  r1.w = abs(r2.w) + abs(r1.w);
  r4.x = saturate(r2.y / r1.w);
  r0.w = r1.x * r0.w + r4.x;
  r1.x = r1.z * r1.z;
  r1.x = r1.x * r1.z;
  r1.z = r1.y * r1.y;
  r1.w = r1.z * r1.y + r1.x;
  r1.y = r1.z * r1.y;
  r1.z = r1.w * r0.w + r0.x;
  r0.w = r1.w * r0.w;
  r0.x = 0.5 + r0.x;
  r5.xyz = r3.xyz + r1.zzz;
  r5.xyz = saturate(float3(-1,-1,-1) + r5.xyz);
  r3.xyz = cb1[2].xxx * r3.xyz;
  r4.yzw = float3(1,0,0.242167801);
  r1.xzw = r1.xxx * r4.xyx;
  r6.xy = r4.zx;
  r6.z = 0.104818799;
  r1.xzw = r6.xyz * r1.xzw;
  r6.xyz = r1.yyy * r4.xyx;
  r1.xyz = r6.xyz * r4.zxw + r1.xzw;
  r1.xyz = r1.xyz + r1.xyz;
  o0.xyz = r3.xyz * r5.xyz + r1.xyz;
  r2.z = 1;
  r0.yz = -r2.xz + abs(r0.yz);
  r1.xy = ddx(r0.yz);
  r1.zw = ddy(r0.yz);
  r1.xy = abs(r1.xy) + abs(r1.zw);
  r0.yz = r0.yz / r1.xy;
  r0.yz = float2(1,1) + -r0.yz;
  r0.y = saturate(min(r0.y, r0.z));
  r0.y = r0.y * r3.w;
  r1.xy = v2.xy * cb1[1].xy + cb1[1].zw;
  r1.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r0.x = r1.w * r0.x;
  r0.x = v3.w * r0.x;
  r0.x = cb1[3].z * r0.x + r0.w;
  o0.w = r0.y * r0.x;
  o0.w = saturate(o0.w);
  return;
}