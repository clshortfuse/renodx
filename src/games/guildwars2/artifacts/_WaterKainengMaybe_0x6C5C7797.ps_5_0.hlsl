Texture2D<float4> t15 : register(t15);
Texture2D<float4> t12 : register(t12);
Texture2D<float4> t0 : register(t0);
SamplerState s15_s : register(s15);
SamplerState s12_s : register(s12);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float w0 : TEXCOORD2,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD3,
  float4 v3 : TEXCOORD4,
  float4 v4 : TEXCOORD5,
  float4 v5 : TEXCOORD6,
  float4 v6 : TEXCOORD7,
  float4 v7 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[9].xx + v7.xy;
  r0.xy = cb0[0].xy * r0.xy;
  r0.x = t12.Sample(s12_s, r0.xy).x;
  r0.x = r0.x * cb0[0].w + -cb0[0].z;
  r0.x = -w0.x + r0.x;
  r0.x = saturate(r0.x / cb0[14].x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.z = -cb0[15].x + v1.z;
  r0.w = 1 / -cb0[16].x;
  r0.z = saturate(r0.z * r0.w);
  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.yz = r0.yw * r0.xz;
  r0.x = r0.y * r0.z;
  r0.yz = float2(-9.99999975e-06,-9.99999975e-06) + r0.xy;
  r0.yz = cmp(r0.yz < float2(0,0));
  r0.y = (int)r0.z | (int)r0.y;
  if (r0.y != 0) discard;
  r0.yz = t15.SampleLevel(s15_s, v3.xy, 0).xy;
  r0.z = -r0.y * r0.y + r0.z;
  r0.z = max(0, r0.z);
  r0.z = 4.99999987e-06 + r0.z;
  r0.z = min(1, r0.z);
  r0.w = -v3.z + r0.y;
  r0.y = cmp(v3.z < r0.y);
  r0.y = r0.y ? 1.000000 : 0;
  r0.w = r0.w * r0.w + r0.z;
  r0.z = r0.z / r0.w;
  r0.z = -0.4 + r0.z;
  r0.z = saturate(1.66666663 * r0.z);
  r0.y = max(r0.y, r0.z);
  r0.z = 1 + -r0.y;
  r0.w = saturate(v3.w * cb0[1].x + cb0[1].y);
  r0.y = r0.w * r0.z + r0.y;
  r0.z = 1 + -r0.y;
  r0.w = 1 + cb0[7].w;
  r0.z = -r0.z * r0.w + 1;
  r0.w = 1 + -cb0[7].w;
  r0.y = r0.y * r0.w;
  r0.w = cmp(cb0[7].w >= 0);
  r0.y = r0.w ? r0.y : r0.z;
  r0.y = 0.004 + r0.y;
  r0.z = dot(cb0[5].xyz, cb0[5].xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = cb0[5].xyz * r0.zzz;
  r0.z = dot(r1.xyz, v2.xyz);
  r0.z = r0.z * 0.5 + 0.5;
  r0.z = 1 + -r0.z;
  r1.xy = cmp(float2(9.99999991e-38,0) < abs(r0.zz));
  r0.w = (int)-r1.y;
  r1.y = cmp(r0.w != 0.000000);
  r0.w = 9.99999991e-38 * r0.w;
  r0.w = r1.y ? r0.w : 9.99999991e-38;
  r0.z = r1.x ? abs(r0.z) : r0.w;
  r0.z = -r0.z * r0.z + 1;
  r1.xyz = cb0[6].xyz * r0.zzz;
  r2.xyzw = saturate(v4.xyzw);
  r0.yzw = r1.xyz * r0.yyy + r2.xyz;
  r0.yzw = v5.xyz * r0.yzw;
  r0.yzw = r0.yzw + r0.yzw;
  r1.xyz = v2.xyz;
  r1.w = 1;
  r3.x = saturate(dot(r1.xyzw, cb0[2].xyzw));
  r3.y = saturate(dot(r1.xyzw, cb0[3].xyzw));
  r3.z = saturate(dot(r1.xyzw, cb0[4].xyzw));
  r0.yzw = r3.xyz * cb0[12].xxx + r0.yzw;
  r1.x = max(r0.z, r0.w);
  r1.x = max(r1.x, r0.y);
  r1.y = min(r0.z, r0.w);
  r1.y = min(r1.y, r0.y);
  r1.z = r1.x + -r1.y;
  r1.w = cmp(0 < r1.z);
  r3.x = cmp(r1.z < 0);
  r1.w = (int)-r1.w + (int)r3.x;
  r1.w = (int)r1.w;
  r3.x = cmp(r1.w != 0.000000);
  r1.w = 9.99999991e-38 * r1.w;
  r1.w = r3.x ? r1.w : 9.99999991e-38;
  r3.x = cmp(9.99999991e-38 < abs(r1.z));
  r1.z = r3.x ? r1.z : r1.w;
  r3.xyz = -r1.yyy + r0.yzw;
  r3.xyz = r3.xyz / r1.zzz;
  r1.z = r1.y + r1.x;
  r1.z = 0.5 * r1.z;
  r1.w = cb0[13].x / r1.z;
  r1.z = saturate(r1.z / cb0[13].x);
  r1.y = r1.y * r1.w;
  r1.x = r1.x * r1.w + -r1.y;
  r1.xyw = r3.xyz * r1.xxx + r1.yyy;
  r0.yzw = -r1.xyw + r0.yzw;
  r2.xyz = r1.zzz * r0.yzw + r1.xyw;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.xyzw = r2.xyzw * r1.xyzw;
  r0.y = v5.w * r1.w;
  r0.z = r0.y * r0.x + -cb0[8].x;
  r0.x = r0.y * r0.x;
  o0.w = r0.x;
  r0.x = cmp(r0.z < 0);
  if (r0.x != 0) discard;
  r0.x = 1 + -v6.w;
  o0.xyz = r1.xyz * r0.xxx + v6.xyz;
  o0.rgb = max(0, o0.rgb);
  return;
}