Texture2D<float4> t12 : register(t12);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[17];
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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * float2(2,2) + float2(-1,-1);
  r1.xyzw = cmp(float4(9.99999991e-38,0,9.99999991e-38,0) < abs(r0.xxyy));
  r0.zw = (int2)-r1.yw;
  r1.yw = cmp(r0.zw != float2(0,0));
  r0.zw = float2(9.99999991e-38,9.99999991e-38) * r0.zw;
  r0.zw = r1.yw ? r0.zw : float2(9.99999991e-38,9.99999991e-38);
  r0.xy = r1.xz ? abs(r0.xy) : r0.zw;
  r0.xy = r0.xy * r0.xy;
  r0.x = r0.x + r0.y;
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.yz = cmp(float2(9.99999991e-38,0) < r0.xx);
  r0.z = (int)-r0.z;
  r0.w = cmp(r0.z != 0.000000);
  r0.z = 9.99999991e-38 * r0.z;
  r0.z = r0.w ? r0.z : 9.99999991e-38;
  r0.x = r0.y ? r0.x : r0.z;
  r0.x = log2(r0.x);
  r0.x = cb0[4].x * r0.x;
  r0.x = exp2(r0.x);
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.y = dot(r1.xyzw, float4(1,1,1,1));
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
  r1.xyzw = r1.xyzw / r0.zzzz;
  r2.xyzw = v1.xyzw * r0.xxxx;
  r3.xyz = r2.xyz;
  r3.w = 1;
  r4.x = dot(cb0[3].xyzw, r3.xyzw);
  r4.y = dot(cb0[5].xyzw, r3.xyzw);
  r4.z = dot(cb0[6].xyzw, r3.xyzw);
  r4.w = dot(cb0[7].xyzw, r3.xyzw);
  r2.x = dot(r4.xyzw, r1.xyzw);
  r4.x = dot(cb0[8].xyzw, r3.xyzw);
  r4.y = dot(cb0[9].xyzw, r3.xyzw);
  r4.z = dot(cb0[10].xyzw, r3.xyzw);
  r4.w = dot(cb0[11].xyzw, r3.xyzw);
  r2.y = dot(r4.xyzw, r1.xyzw);
  r4.x = dot(cb0[12].xyzw, r3.xyzw);
  r4.y = dot(cb0[13].xyzw, r3.xyzw);
  r4.z = dot(cb0[14].xyzw, r3.xyzw);
  r4.w = dot(cb0[15].xyzw, r3.xyzw);
  r2.z = dot(r4.xyzw, r1.xyzw);
  r1.xyz = r0.xxx * v1.xyz + -r2.xyz;
  r0.x = 4 * r0.x;
  r0.x = min(1, r0.x);
  r0.yzw = r0.yyy * r1.xyz + r2.xyz;
  r0.xyz = r0.yzw * r0.xxx;
  r1.xy = cb0[1].xx + v3.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r1.x = t12.Sample(s12_s, r1.xy).x;
  r1.x = r1.x * cb0[0].w + -cb0[0].z;
  r1.x = -w0.x + r1.x;
  r1.x = saturate(r1.x / cb0[16].x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r0.w = r2.w * r1.x;
  r0.xyzw = r0.wwww * r0.xyzw;
  r1.x = 1 + -v2.w;
  o0.xyzw = r1.xxxx * r0.xyzw;
  o0 = max(0, o0);
  return;
}