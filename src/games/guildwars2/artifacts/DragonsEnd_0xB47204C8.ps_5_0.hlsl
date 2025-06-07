Texture2D<float4> t15 : register(t15);
Texture2D<float4> t0 : register(t0);
SamplerState s15_s : register(s15);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r1.x = saturate(r0.w + r0.w);
  r1.x = -0.5 + r1.x;
  r1.x = cmp(r1.x < 0);
  if (r1.x != 0) discard;
  r1.xy = t15.SampleLevel(s15_s, v3.xy, 0).xy;
  r1.y = -r1.x * r1.x + r1.y;
  r1.y = max(0, r1.y);
  r1.y = 4.99999987e-06 + r1.y;
  r1.y = min(1, r1.y);
  r1.z = -v3.z + r1.x;
  r1.x = cmp(v3.z < r1.x);
  r1.x = r1.x ? 1.000000 : 0;
  r1.z = r1.z * r1.z + r1.y;
  r1.y = r1.y / r1.z;
  r1.y = -0.4 + r1.y;
  r1.y = saturate(1.66666663 * r1.y);
  r1.x = max(r1.x, r1.y);
  r1.y = 1 + -r1.x;
  r1.z = saturate(v3.w * cb0[1].x + cb0[1].y);
  r1.x = r1.z * r1.y + r1.x;
  r1.y = 1 + -r1.x;
  r1.z = 1 + cb0[7].w;
  r1.y = -r1.y * r1.z + 1;
  r1.z = 1 + -cb0[7].w;
  r1.x = r1.x * r1.z;
  r1.z = cmp(cb0[7].w >= 0);
  r1.x = r1.z ? r1.x : r1.y;
  r1.y = dot(v2.xyz, v2.xyz);
  r1.y = rsqrt(r1.y);
  r2.xyz = v2.xyz * r1.yyy;
  r2.w = 1;
  r3.x = dot(r2.xyzw, cb0[2].xyzw);
  r3.y = dot(r2.xyzw, cb0[3].xyzw);
  r3.z = dot(r2.xyzw, cb0[4].xyzw);
  r1.y = saturate(dot(r2.xyzw, cb0[5].xyzw));
  r1.yzw = cb0[6].xyz * r1.yyy;
  r3.xyz = v4.xyz + r3.xyz;
  r1.yzw = r1.yzw * r1.xxx + r3.xyz;
  r1.x = max(0.5, r1.x);
  r3.xyz = cb0[7].xyz + v1.xyz;
  r2.w = dot(r3.xyz, r3.xyz);
  r2.w = rsqrt(r2.w);
  r3.xyz = r3.xyz * r2.www;
  r2.x = dot(r2.xyz, r3.xyz);
  r2.x = max(9.99999975e-05, r2.x);
  r2.x = log2(r2.x);
  r0.w = -0.5 + r0.w;
  r0.w = saturate(r0.w + r0.w);
  r2.y = 32 * r0.w;
  r0.w = r0.w + r0.w;
  r3.xyz = cb0[6].xyz * r0.www;
  r0.w = r2.y * r2.x;
  r0.w = exp2(r0.w);
  r0.w = 0.5 * r0.w;
  r2.xyz = r3.xyz * r0.www;
  r2.xyz = r2.xyz * r1.xxx;
  r0.xyz = r0.xyz * r1.yzw + r2.xyz;
  r0.w = 1 + -v5.w;
  o0.xyz = r0.xyz * r0.www + v5.xyz;
  o0.w = cb0[0].x;
  o0.rgb = max(0, o0.rgb);
  return;
}