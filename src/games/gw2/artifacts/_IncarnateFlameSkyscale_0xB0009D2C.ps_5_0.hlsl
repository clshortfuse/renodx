Texture2D<float4> t12 : register(t12);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[30];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float w0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[9].x * cb0[1].x;
  r1.zw = cb0[10].xx * v0.xy;
  r1.y = r0.x * 2 + r1.z;
  r0.xy = r1.yw + r1.yw;
  r0.xy = t2.Sample(s2_s, r0.xy).xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r1.x = cb0[9].x * cb0[1].x + r1.z;
  r0.zw = t2.Sample(s2_s, r1.xw).xy;
  r0.xy = r0.zw * float2(2,2) + r0.xy;
  r0.xy = float2(-1,-1) + r0.xy;
  r0.xy = cb0[8].xx * r0.xy + v0.xy;
  r0.zw = float2(0.5,0.5) * r0.xy;
  r1.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r2.z = cb0[11].x * r0.w;
  r0.x = cb0[12].x * cb0[1].x;
  r2.x = r0.z * cb0[11].x + r0.x;
  r0.x = r0.z * cb0[13].x + r0.x;
  r0.z = cb0[13].x * r0.w;
  r0.xyzw = t0.Sample(s0_s, r0.xz).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.xz).xyzw;
  r0.xyzw = r2.xyzw * r0.xyzw;
  r0.xyzw = r0.xyzw * r1.xyzw;
  r1.x = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r1.x = saturate(10 * r1.x);
  r0.xyzw = float4(4,4,4,4) * r0.xyzw;
  r2.xyzw = cmp(float4(9.99999991e-38,0,9.99999991e-38,0) < abs(r0.yyww));
  r1.yz = (int2)-r2.yw;
  r2.yw = cmp(r1.yz != float2(0,0));
  r1.yz = float2(9.99999991e-38,9.99999991e-38) * r1.yz;
  r1.yz = r2.yw ? r1.yz : float2(9.99999991e-38,9.99999991e-38);
  r1.yz = r2.xz ? abs(r0.yw) : r1.yz;
  r1.yz = log2(r1.yz);
  r1.y = cb0[14].x * r1.y;
  r1.z = cb0[26].x * r1.z;
  r2.w = exp2(r1.z);
  r1.y = exp2(r1.y);
  r3.xyz = cb0[7].xyz + -cb0[6].xyz;
  r1.yzw = r1.yyy * r3.xyz + cb0[6].xyz;
  r3.xyz = saturate(r1.yzw * r0.xyz);
  r0.x = dot(r0.ww, cb0[27].xx);
  r4.xyzw = t3.Sample(s3_s, v0.xy).xyzw;
  r0.y = dot(r4.xyzw, float4(1,1,1,1));
  r0.z = cmp(0 < r0.y);
  r0.w = cmp(r0.y < 0);
  r0.z = (int)-r0.z + (int)r0.w;
  r0.z = (int)r0.z;
  r0.w = cmp(r0.z != 0.000000);
  r0.z = 9.99999991e-38 * r0.z;
  r0.z = r0.w ? r0.z : 9.99999991e-38;
  r0.w = cmp(9.99999991e-38 < abs(r0.y));
  r0.z = r0.w ? r0.y : r0.z;
  r0.y = min(1, r0.y);
  r0.y = 1 + -r0.y;
  r4.xyzw = r4.xyzw / r0.zzzz;
  r3.w = 1;
  r5.x = dot(cb0[5].xyzw, r3.xyzw);
  r5.y = dot(cb0[15].xyzw, r3.xyzw);
  r5.z = dot(cb0[16].xyzw, r3.xyzw);
  r5.w = dot(cb0[17].xyzw, r3.xyzw);
  r5.x = dot(r5.xyzw, r4.xyzw);
  r6.x = dot(cb0[18].xyzw, r3.xyzw);
  r6.y = dot(cb0[19].xyzw, r3.xyzw);
  r6.z = dot(cb0[20].xyzw, r3.xyzw);
  r6.w = dot(cb0[21].xyzw, r3.xyzw);
  r5.y = dot(r6.xyzw, r4.xyzw);
  r6.x = dot(cb0[22].xyzw, r3.xyzw);
  r6.y = dot(cb0[23].xyzw, r3.xyzw);
  r6.z = dot(cb0[24].xyzw, r3.xyzw);
  r6.w = dot(cb0[25].xyzw, r3.xyzw);
  r5.z = dot(r6.xyzw, r4.xyzw);
  r1.yzw = -r5.xyz + r3.xyz;
  r0.yzw = r0.yyy * r1.yzw + r5.xyz;
  r2.xyz = r0.yzw * r1.xxx;
  r1.xyz = r2.xyz;
  r1.w = 0;
  r1.xyzw = r1.xyzw + -r2.xyzw;
  r0.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;
  r1.x = cb0[28].x * r2.w;
  r1.xyz = max(r1.xxx, r0.xyz);
  r1.xyz = v1.xyz * r1.xyz;
  r0.xyz = r1.xyz + r1.xyz;
  r0.xyzw = v1.wwww * r0.xyzw;
  r1.xy = cb0[3].xx + v3.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r1.x = t12.Sample(s12_s, r1.xy).x;
  r1.x = r1.x * cb0[0].w + -cb0[0].z;
  r1.x = -w0.x + r1.x;
  r1.x = saturate(r1.x / cb0[29].x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyz = cb0[2].xyz * r0.xyz;
  r0.xyzw = cb0[2].wwww * r0.xyzw;
  r1.x = 1 + -v2.w;
  o0.xyzw = r1.xxxx * r0.xyzw;
  o0.a = saturate(o0.a);
  return;
}