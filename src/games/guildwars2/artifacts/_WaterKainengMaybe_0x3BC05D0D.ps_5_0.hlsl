Texture2D<float4> t15 : register(t15);
Texture2D<float4> t12 : register(t12);
Texture2D<float4> t0 : register(t0);
SamplerState s15_s : register(s15);
SamplerState s12_s : register(s12);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[15];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float w0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  float4 v4 : TEXCOORD5,
  float4 v5 : TEXCOORD6,
  float4 v6 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t15.SampleLevel(s15_s, v2.xy, 0).xy;
  r0.y = -r0.x * r0.x + r0.y;
  r0.y = max(0, r0.y);
  r0.y = 4.99999987e-06 + r0.y;
  r0.y = min(1, r0.y);
  r0.z = -v2.z + r0.x;
  r0.x = cmp(v2.z < r0.x);
  r0.x = r0.x ? 1.000000 : 0;
  r0.z = r0.z * r0.z + r0.y;
  r0.y = r0.y / r0.z;
  r0.y = -0.4 + r0.y;
  r0.y = saturate(1.66666663 * r0.y);
  r0.x = max(r0.x, r0.y);
  r0.y = 1 + -r0.x;
  r0.z = saturate(v2.w * cb0[1].x + cb0[1].y);
  r0.x = r0.z * r0.y + r0.x;
  r0.y = 1 + -r0.x;
  r0.z = 1 + cb0[7].w;
  r0.y = -r0.y * r0.z + 1;
  r0.z = 1 + -cb0[7].w;
  r0.x = r0.x * r0.z;
  r0.z = cmp(cb0[7].w >= 0);
  r0.x = r0.z ? r0.x : r0.y;
  r0.x = 0.004 + r0.x;
  r0.y = dot(cb0[5].xyz, cb0[5].xyz);
  r0.y = rsqrt(r0.y);
  r0.yzw = cb0[5].xyz * r0.yyy;
  r0.y = dot(r0.yzw, v1.xyz);
  r0.y = r0.y * 0.5 + 0.5;
  r0.y = 1 + -r0.y;
  r0.zw = cmp(float2(9.99999991e-38,0) < abs(r0.yy));
  r0.w = (int)-r0.w;
  r1.x = cmp(r0.w != 0.000000);
  r0.w = 9.99999991e-38 * r0.w;
  r0.w = r1.x ? r0.w : 9.99999991e-38;
  r0.y = r0.z ? abs(r0.y) : r0.w;
  r0.y = -r0.y * r0.y + 1;
  r0.yzw = cb0[6].xyz * r0.yyy;
  r1.xyzw = saturate(v3.xyzw);
  r0.xyz = r0.yzw * r0.xxx + r1.xyz;
  r0.xyz = v4.xyz * r0.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r2.xyz = v1.xyz;
  r2.w = 1;
  r3.x = saturate(dot(r2.xyzw, cb0[2].xyzw));
  r3.y = saturate(dot(r2.xyzw, cb0[3].xyzw));
  r3.z = saturate(dot(r2.xyzw, cb0[4].xyzw));
  r0.xyz = r3.xyz * cb0[12].xxx + r0.xyz;
  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r2.x = min(r0.y, r0.z);
  r2.x = min(r2.x, r0.x);
  r2.y = -r2.x + r0.w;
  r2.z = cmp(0 < r2.y);
  r2.w = cmp(r2.y < 0);
  r2.z = (int)-r2.z + (int)r2.w;
  r2.z = (int)r2.z;
  r2.w = cmp(r2.z != 0.000000);
  r2.z = 9.99999991e-38 * r2.z;
  r2.z = r2.w ? r2.z : 9.99999991e-38;
  r2.w = cmp(9.99999991e-38 < abs(r2.y));
  r2.y = r2.w ? r2.y : r2.z;
  r3.xyz = -r2.xxx + r0.xyz;
  r2.yzw = r3.xyz / r2.yyy;
  r3.x = r2.x + r0.w;
  r3.x = 0.5 * r3.x;
  r3.y = cb0[13].x / r3.x;
  r3.x = saturate(r3.x / cb0[13].x);
  r2.x = r3.y * r2.x;
  r0.w = r0.w * r3.y + -r2.x;
  r2.xyz = r2.yzw * r0.www + r2.xxx;
  r0.xyz = -r2.xyz + r0.xyz;
  r1.xyz = r3.xxx * r0.xyz + r2.xyz;
  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.xyzw = r1.xyzw * r0.xyzw;
  r0.w = v4.w * r0.w;
  r1.xy = cb0[9].xx + v6.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r1.x = t12.Sample(s12_s, r1.xy).x;
  r1.x = r1.x * cb0[0].w + -cb0[0].z;
  r1.x = -w0.x + r1.x;
  r1.x = saturate(r1.x / cb0[14].x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r1.y = r0.w * r1.x + -cb0[8].x;
  r0.w = r1.x * r0.w;
  o0.w = r0.w;
  r0.w = cmp(r1.y < 0);
  if (r0.w != 0) discard;
  r0.w = 1 + -v5.w;
  o0.xyz = r0.xyz * r0.www + v5.xyz;
  o0.rgb = max(0, o0.rgb);
  return;
}