Texture2D<float4> t15 : register(t15);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s15_s : register(s15);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
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
  r0.yz = t3.Sample(s3_s, v0.zw).xy;
  r1.xy = r0.yz * float2(2,2) + float2(-1,-1);
  r0.y = dot(r1.xy, r1.xy);
  r0.y = 1 + -r0.y;
  r0.y = max(0, r0.y);
  r1.z = sqrt(r0.y);
  r0.yz = t1.Sample(s1_s, v0.xy).xy;
  r2.xy = r0.yz * float2(2,2) + float2(-1,-1);
  r0.y = dot(r2.xy, r2.xy);
  r0.y = 1 + -r0.y;
  r0.y = max(0, r0.y);
  r2.z = sqrt(r0.y);
  r0.yzw = -r2.xyz + r1.xyz;
  r1.x = t4.Sample(s4_s, v1.xy).x;
  r3.xyzw = t2.Sample(s2_s, v0.zw).xyzw;
  r1.y = saturate(r3.w + r3.w);
  r1.x = r1.y * r1.x;
  r0.yzw = r1.xxx * r0.yzw + r2.xyz;
  r1.y = dot(r0.yzw, r0.yzw);
  r1.y = rsqrt(r1.y);
  r0.yzw = r1.yyy * r0.yzw;
  r1.yzw = v5.xyz * r0.zzz;
  r1.yzw = r0.yyy * v6.xyz + r1.yzw;
  r0.yzw = r0.www * v7.xyz + r1.yzw;
  r1.y = dot(r0.yzw, r0.yzw);
  r1.y = sqrt(r1.y);
  r1.zw = cmp(float2(9.99999991e-38,0) < r1.yy);
  r1.w = (int)-r1.w;
  r2.x = cmp(r1.w != 0.000000);
  r1.w = 9.99999991e-38 * r1.w;
  r1.w = r2.x ? r1.w : 9.99999991e-38;
  r1.y = r1.z ? r1.y : r1.w;
  r2.xyz = r0.yzw / r1.yyy;
  r2.w = 1;
  r4.x = dot(r2.xyzw, v4.xyzw);
  r4.y = dot(r2.xyzw, v3.xyzw);
  r4.z = dot(r2.xyzw, v2.xyzw);
  r5.x = dot(r2.xyzw, cb0[2].xyzw);
  r5.y = dot(r2.xyzw, cb0[3].xyzw);
  r5.z = dot(r2.xyzw, cb0[4].xyzw);
  r0.y = saturate(dot(r2.xyzw, cb0[5].xyzw));
  r0.yzw = cb0[6].xyz * r0.yyy;
  r1.yzw = r5.xyz + r4.xyz;
  r0.yzw = r0.yzw * r0.xxx + r1.yzw;
  r0.x = max(0.5, r0.x);
  r4.x = v6.w;
  r4.y = v5.w;
  r4.z = v7.w;
  r1.y = dot(r4.xyz, r4.xyz);
  r1.y = rsqrt(r1.y);
  r1.yzw = r4.xyz * r1.yyy + cb0[7].xyz;
  r2.w = dot(r1.yzw, r1.yzw);
  r2.w = rsqrt(r2.w);
  r1.yzw = r2.www * r1.yzw;
  r1.y = dot(r2.xyz, r1.yzw);
  r1.y = max(9.99999975e-05, r1.y);
  r1.y = log2(r1.y);
  r1.z = -0.5 + r3.w;
  r2.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.w = -0.5 + r2.w;
  r1.zw = saturate(r1.zw + r1.zw);
  r1.z = r1.z + -r1.w;
  r1.z = r1.x * r1.z + r1.w;
  r4.xyzw = cb0[10].xyzw * r1.zzzz;
  r1.y = r4.w * r1.y;
  r4.xyz = r4.xyz + r4.xyz;
  r4.xyz = cb0[6].xyz * r4.xyz;
  r1.y = exp2(r1.y);
  r1.y = 0.5 * r1.y;
  r1.yzw = r4.xyz * r1.yyy;
  r1.yzw = r1.yzw * r0.xxx;
  r3.xyz = r3.xyz + -r2.xyz;
  r2.xyz = r1.xxx * r3.xyz + r2.xyz;
  r3.xyz = t5.Sample(s5_s, v1.zw).xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r0.xyz = r2.xyz * r0.yzw + r1.yzw;
  r0.w = 1 + -v9.w;
  o0.xyz = r0.xyz * r0.www + v9.xyz;
  o0.w = cb0[0].x;
  o0 = max(0, o0);
  return;
}