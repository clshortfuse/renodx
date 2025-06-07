Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[20];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 + -cb0[19].x;
  r0.x = 1 / r0.x;
  r0.y = cb0[19].x * v3.w;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.y = r1.w * cb0[19].x + r0.y;
  r0.y = -cb0[19].x + r0.y;
  r0.x = saturate(r0.y * r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.x = v3.x * r0.x + -0.5;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.x = dot(v1.xyz, v1.xyz);
  r0.x = sqrt(r0.x);
  r0.yz = cmp(float2(9.99999991e-38,0) < r0.xx);
  r0.z = (int)-r0.z;
  r0.w = cmp(r0.z != 0.000000);
  r0.z = 9.99999991e-38 * r0.z;
  r0.z = r0.w ? r0.z : 9.99999991e-38;
  r0.x = r0.y ? r0.x : r0.z;
  r0.xyz = v1.xyz / r0.xxx;
  r2.xy = t1.Sample(s1_s, v0.xy).xy;
  r2.xy = r2.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r2.xy, r2.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r2.z = sqrt(r0.w);
  r0.x = saturate(dot(r2.xyz, r0.xyz));
  r0.yz = cmp(float2(9.99999991e-38,0) < r0.xx);
  r0.z = (int)-r0.z;
  r0.w = cmp(r0.z != 0.000000);
  r0.z = 9.99999991e-38 * r0.z;
  r0.z = r0.w ? r0.z : 9.99999991e-38;
  r0.x = r0.y ? r0.x : r0.z;
  r0.x = log2(r0.x);
  r0.x = cb0[6].x * r0.x;
  r0.x = exp2(r0.x);
  r0.x = cb0[5].w * r0.x + cb0[7].x;
  r0.y = dot(v2.xyz, v2.xyz);
  r0.y = sqrt(r0.y);
  r0.zw = cmp(float2(9.99999991e-38,0) < r0.yy);
  r0.w = (int)-r0.w;
  r1.w = cmp(r0.w != 0.000000);
  r0.w = 9.99999991e-38 * r0.w;
  r0.w = r1.w ? r0.w : 9.99999991e-38;
  r0.y = r0.z ? r0.y : r0.w;
  r0.yzw = v2.xyz / r0.yyy;
  r0.y = saturate(dot(r2.xyz, r0.yzw));
  r0.zw = cmp(float2(9.99999991e-38,0) < r0.yy);
  r0.w = (int)-r0.w;
  r1.w = cmp(r0.w != 0.000000);
  r0.w = 9.99999991e-38 * r0.w;
  r0.w = r1.w ? r0.w : 9.99999991e-38;
  r0.y = r0.z ? r0.y : r0.w;
  r0.y = log2(r0.y);
  r0.x = r0.x * r0.y;
  r0.x = exp2(r0.x);
  r0.xyz = cb0[5].xyz * r0.xxx;
  r0.xyz = cb0[1].xyz * r0.xyz;
  r0.xyz = r0.xyz * float3(2,2,2) + r1.xyz;
  r1.xyzw = t2.Sample(s2_s, v0.xy).xyzw;
  r2.x = dot(r1.xyzw, float4(1,1,1,1));
  r2.y = cmp(0 < r2.x);
  r2.z = cmp(r2.x < 0);
  r2.y = (int)-r2.y + (int)r2.z;
  r2.y = (int)r2.y;
  r2.z = cmp(r2.y != 0.000000);
  r2.y = 9.99999991e-38 * r2.y;
  r2.y = r2.z ? r2.y : 9.99999991e-38;
  r2.z = cmp(9.99999991e-38 < abs(r2.x));
  r2.y = r2.z ? r2.x : r2.y;
  r2.x = min(1, r2.x);
  r2.x = 1 + -r2.x;
  r1.xyzw = r1.xyzw / r2.yyyy;
  r0.w = 1;
  r3.x = dot(cb0[4].xyzw, r0.xyzw);
  r3.y = dot(cb0[8].xyzw, r0.xyzw);
  r3.z = dot(cb0[9].xyzw, r0.xyzw);
  r3.w = dot(cb0[10].xyzw, r0.xyzw);
  r3.x = dot(r3.xyzw, r1.xyzw);
  r4.x = dot(cb0[11].xyzw, r0.xyzw);
  r4.y = dot(cb0[12].xyzw, r0.xyzw);
  r4.z = dot(cb0[13].xyzw, r0.xyzw);
  r4.w = dot(cb0[14].xyzw, r0.xyzw);
  r3.y = dot(r4.xyzw, r1.xyzw);
  r4.x = dot(cb0[15].xyzw, r0.xyzw);
  r4.y = dot(cb0[16].xyzw, r0.xyzw);
  r4.z = dot(cb0[17].xyzw, r0.xyzw);
  r4.w = dot(cb0[18].xyzw, r0.xyzw);
  r3.z = dot(r4.xyzw, r1.xyzw);
  r0.xyz = -r3.xyz + r0.xyz;
  r0.xyz = r2.xxx * r0.xyz + r3.xyz;
  r0.w = 1 + -v4.w;
  o0.xyz = r0.xyz * r0.www + v4.xyz;
  o0.w = cb0[0].x;
  o0 = max(0, o0);
  return;
}