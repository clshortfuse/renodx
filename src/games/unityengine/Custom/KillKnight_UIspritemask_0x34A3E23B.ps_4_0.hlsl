Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[12];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xz = float2(0.100000001,-0.100000001) * cb0[11].xx;
  r0.yw = float2(0,0);
  r0.xyzw = v0.xyxy + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xy = v2.zw * r0.zw;
  r0.zw = v2.xw * r1.xw;
  r1.x = max(r0.w, r0.y);
  r0.xz = r0.xz * r0.yw;
  r2.x = log2(r0.z);
  r2.z = log2(r0.x);
  r0.x = cb0[11].y * r1.x;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.yz = v2.yw * r1.yw;
  r0.x = max(r0.x, r0.z);
  r2.y = log2(r0.y);
  r0.yzw = cb0[8].zzz * r2.xyz;
  r0.yzw = exp2(r0.yzw);
  r0.yzw = cb0[8].yyy * r0.yzw;
  r0.yzw = floor(r0.yzw);
  r0.yzw = r0.yzw / cb0[8].yyy;
  r0.yzw = log2(r0.yzw);
  r1.x = r0.x * r0.x;
  r1.x = cb0[7].x * r1.x;
  r1.xyz = cb0[6].xyz * r1.xxx;
  r1.w = 1 / cb0[8].z;
  r0.yzw = r1.www * r0.yzw;
  r0.yzw = exp2(r0.yzw);
  r1.w = 0.0174532942 * cb0[7].z;
  sincos(r1.w, r2.x, r3.x);
  r1.w = cb0[8].x * cb0[7].w;
  r2.y = r1.w * r3.x;
  r1.w = r1.w * r2.x;
  r3.xyzw = float4(0.412999988,0.300000012,0.588,0.885999978) * r2.yyyy;
  r2.xyzw = float4(0.700999975,0.587000012,0.114,0.298999995) * r2.yyyy;
  r3.yz = cb0[8].xx * float2(0.298999995,0.587000012) + -r3.yz;
  r3.xw = cb0[8].xx * float2(0.587000012,0.114) + r3.xw;
  r3.z = -r1.w * 1.04999995 + r3.z;
  r3.y = r1.w * 1.25 + r3.y;
  r3.z = r3.z * r0.z;
  r3.y = r3.y * r0.y + r3.z;
  r3.z = -r1.w * 0.202999994 + r3.w;
  r3.x = r1.w * 0.0350000001 + r3.x;
  r4.z = r3.z * r0.w + r3.y;
  r2.yzw = cb0[8].xxx * float3(0.587000012,0.114,0.298999995) + -r2.yzw;
  r2.x = cb0[8].x * 0.298999995 + r2.x;
  r2.x = r1.w * 0.167999998 + r2.x;
  r2.y = r1.w * 0.330000013 + r2.y;
  r2.y = r2.y * r0.z;
  r2.x = r2.x * r0.y + r2.y;
  r2.yw = -r1.ww * float2(0.497000009,0.328000009) + r2.zw;
  r1.w = r1.w * 0.291999996 + r2.z;
  r4.x = r2.y * r0.w + r2.x;
  r0.y = r2.w * r0.y;
  r0.y = r3.x * r0.z + r0.y;
  r4.y = r1.w * r0.w + r0.y;
  r0.yzw = r4.xyz * r1.xyz;
  r0.yzw = r4.xyz * cb0[7].yyy + r0.yzw;
  r1.xyz = cb0[10].xyz * cb0[8].www + -r0.yzw;
  r1.w = -r0.x * cb0[5].x + 1;
  r0.x = cb0[5].x * r0.x;
  r2.x = log2(r1.w);
  r2.y = max(9.99999975e-05, cb0[9].x);
  r2.x = r2.y * r2.x;
  r2.x = exp2(r2.x);
  r2.y = cmp(r0.x >= cb0[9].y);
  r2.y = r2.y ? 1.000000 : 0;
  r2.x = r2.x * r2.y;
  r2.x = cb0[9].z * r2.x;
  r3.xyz = r2.xxx * r1.xyz + r0.yzw;
  r0.y = cmp(1 < r2.x);
  r0.y = r0.y ? 1.000000 : 0;
  r3.w = r0.y * r1.w + r0.x;
  o0.xyzw = cb0[4].xyzw * r3.xyzw;
  o0 = saturate(o0);
  return;
}