Texture2D<float4> t15 : register(t15);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s15_s : register(s15);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  float4 v6 : TEXCOORD6,
  float4 v7 : TEXCOORD7,
  float4 v8 : TEXCOORD8,
  float4 v9 : TEXCOORD9,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t15.SampleLevel(s15_s, v8.xy, 0).xy;
  r0.y = -r0.x * r0.x + r0.y;
  r0.y = max(0, r0.y);
  r0.y = 4.99999987e-06 + r0.y;
  r0.y = min(1, r0.y);
  r0.z = -v8.z + r0.x;
  r0.x = cmp(v8.z < r0.x);
  r0.x = r0.x ? 1.000000 : 0;
  r0.z = r0.z * r0.z + r0.y;
  r0.y = r0.y / r0.z;
  r0.y = -0.4 + r0.y;
  r0.y = saturate(1.66666663 * r0.y);
  r0.x = max(r0.x, r0.y);
  r0.y = 1 + -r0.x;
  r0.z = saturate(v8.w * cb0[1].x + cb0[1].y);
  r0.x = r0.z * r0.y + r0.x;
  r0.y = 1 + -r0.x;
  r0.z = 1 + cb0[7].w;
  r0.y = -r0.y * r0.z + 1;
  r0.z = 1 + -cb0[7].w;
  r0.x = r0.x * r0.z;
  r0.z = cmp(cb0[7].w >= 0);
  r0.x = r0.z ? r0.x : r0.y;
  r0.yz = t2.Sample(s2_s, v0.zw).xy;
  r1.xy = r0.yz * float2(2,2) + float2(-1,-1);
  r0.y = dot(r1.xy, r1.xy);
  r0.y = 1 + -r0.y;
  r0.y = max(0, r0.y);
  r1.z = sqrt(r0.y);
  r0.y = dot(r1.xyz, r1.xyz);
  r0.y = rsqrt(r0.y);
  r0.yzw = r1.xyz * r0.yyy;
  r1.xyz = v5.xyz * r0.zzz;
  r1.xyz = r0.yyy * v6.xyz + r1.xyz;
  r0.yzw = r0.www * v7.xyz + r1.xyz;
  r1.x = dot(r0.yzw, r0.yzw);
  r1.x = sqrt(r1.x);
  r1.yz = cmp(float2(9.99999991e-38,0) < r1.xx);
  r1.z = (int)-r1.z;
  r1.w = cmp(r1.z != 0.000000);
  r1.z = 9.99999991e-38 * r1.z;
  r1.z = r1.w ? r1.z : 9.99999991e-38;
  r1.x = r1.y ? r1.x : r1.z;
  r1.xyz = r0.yzw / r1.xxx;
  r1.w = 1;
  r2.x = dot(r1.xyzw, v4.xyzw);
  r2.y = dot(r1.xyzw, v3.xyzw);
  r2.z = dot(r1.xyzw, v2.xyzw);
  r3.x = dot(r1.xyzw, cb0[2].xyzw);
  r3.y = dot(r1.xyzw, cb0[3].xyzw);
  r3.z = dot(r1.xyzw, cb0[4].xyzw);
  r0.y = saturate(dot(r1.xyzw, cb0[5].xyzw));
  r0.yzw = cb0[6].xyz * r0.yyy;
  r2.xyz = r3.xyz + r2.xyz;
  r0.yzw = r0.yzw * r0.xxx + r2.xyz;
  r0.x = max(0.5, r0.x);
  r2.xyz = t3.Sample(s3_s, v0.xy).xyz;
  r3.xyzw = t0.Sample(s0_s, v0.zw).xyzw;
  r2.xyz = r3.xyz * r2.xyz;
  r1.w = -0.5 + r3.w;
  r1.w = saturate(r1.w + r1.w);
  r3.xyzw = cb0[10].xyzw * r1.wwww;
  r4.xyz = r2.xyz + r2.xyz;
  r5.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyz = -r2.xyz * float3(2,2,2) + r5.xyz;
  r1.w = saturate(r5.w + r5.w);
  r2.xyz = r1.www * r2.xyz + r4.xyz;
  r1.w = -0.5 + r5.w;
  r1.w = saturate(r1.w + r1.w);
  r4.xyz = r1.www * r5.xyz;
  r0.yzw = r2.xyz * r0.yzw + r4.xyz;
  r2.x = v6.w;
  r2.y = v5.w;
  r2.z = v7.w;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r2.xyz * r1.www + cb0[7].xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r2.xyz * r1.www;
  r1.x = dot(r1.xyz, r2.xyz);
  r1.x = max(9.99999975e-05, r1.x);
  r1.x = log2(r1.x);
  r1.x = r3.w * r1.x;
  r1.yzw = r3.xyz + r3.xyz;
  r1.yzw = cb0[6].xyz * r1.yzw;
  r1.x = exp2(r1.x);
  r1.x = 0.5 * r1.x;
  r1.xyz = r1.yzw * r1.xxx;
  r0.xyz = r1.xyz * r0.xxx + r0.yzw;
  r0.w = 1 + -v9.w;
  o0.xyz = r0.xyz * r0.www + v9.xyz;
  o0.w = cb0[0].x;
  o0 = max(0, o0);
  return;
}