Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[1];
}
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[11];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[5].z + -cb0[5].y;
  r0.yz = -cb0[5].yw + v0.xy;
  r1.xz = r0.yy / r0.xx;
  r0.x = cb0[6].x + -cb0[5].w;
  r0.x = r0.z / r0.x;
  r1.yw = float2(-0.5,-0.5) + r0.xx;
  r1.xyzw = cb0[10].wwww * r1.xyzw;
  r1.xyzw = float4(24,19,38,14) * r1.xyzw;
  r1.xyzw = floor(r1.xyzw);
  r1.xyzw = float4(4,4,4,4) * r1.xyzw;
  r0.yz = cmp(cb1[0].xy >= -cb1[0].xy);
  r0.yz = r0.yz ? float2(1,1) : float2(-1,-1);
  r2.xy = cb1[0].xy * r0.yz;
  r2.xy = frac(r2.xy);
  r0.yz = r2.xy * r0.yz;
  r0.yz = r0.yz * float2(12,12) + float2(50,50);
  r0.yz = floor(r0.yz);
  r1.xyzw = r1.xyzw * r0.yzyz;
  r0.yz = float2(2,1) * r0.yz;
  r0.y = dot(r0.yz, float2(127.099998,311.700012));
  r0.y = sin(r0.y);
  r0.y = 43758.5469 * r0.y;
  r0.y = frac(r0.y);
  r0.z = dot(r1.xy, float2(127.099998,311.700012));
  r0.w = dot(r1.zw, float2(127.099998,311.700012));
  r0.zw = sin(r0.zw);
  r0.zw = float2(43758.5469,43758.5469) * r0.zw;
  r0.zw = frac(r0.zw);
  r0.yzw = cb2[0].xxx + r0.yzw;
  r1.x = cmp(r0.z >= -r0.z);
  r1.x = r1.x ? 1 : -1;
  r0.z = r1.x * r0.z;
  r0.z = frac(r0.z);
  r0.z = r1.x * r0.z;
  r1.x = r0.z * r0.z;
  r0.z = r1.x * r0.z;
  r0.z = cb0[10].z * r0.z;
  r1.x = cmp(r0.w >= -r0.w);
  r1.x = r1.x ? 1 : -1;
  r0.w = r1.x * r0.w;
  r0.w = frac(r0.w);
  r0.w = r1.x * r0.w;
  r1.x = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r0.z = r0.z * r0.w;
  r0.z = 0.0199999996 * r0.z;
  r0.w = cmp(r0.y >= -r0.y);
  r0.w = r0.w ? 1 : -1;
  r0.y = r0.y * r0.w;
  r0.y = frac(r0.y);
  r0.y = r0.w * r0.y;
  r1.x = r0.z * r0.y;
  r1.yw = float2(0,0);
  r0.yz = v0.xy + r1.xy;
  r2.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r0.yz = v2.yw * r2.yw;
  r1.z = 0.100000001 * cb0[10].x;
  r1.xy = v0.xy + r1.zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xy = v2.xw * r1.xw;
  r2.x = -0.100000001 * cb0[10].x;
  r2.y = 0;
  r1.zw = v0.xy + r2.xy;
  r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.zw = v2.zw * r2.zw;
  r0.w = max(r1.y, r1.w);
  r1.x = r1.x * r1.y;
  r1.y = r1.z * r1.w;
  r0.w = cb0[10].y * r0.w;
  r2.w = max(r0.w, r0.z);
  r0.z = cb2[0].x + cb1[0].x;
  r0.w = cmp(r0.z >= -r0.z);
  r0.w = r0.w ? 1 : -1;
  r0.z = r0.z * r0.w;
  r0.z = frac(r0.z);
  r0.z = r0.w * r0.z;
  r0.x = r0.z * cb0[7].w + r0.x;
  r0.z = cb0[7].x + cb0[7].z;
  r0.w = r0.x * r0.z;
  r0.w = cmp(r0.w >= -r0.w);
  r0.w = r0.w ? r0.z : -r0.z;
  r1.z = 1 / r0.w;
  r0.x = r1.z * r0.x;
  r0.x = frac(r0.x);
  r0.x = r0.w * r0.x;
  r0.x = r0.x / r0.z;
  r0.z = cb0[7].z / r0.z;
  r0.w = r0.z + -abs(r0.x);
  r0.x = abs(r0.x) + -r0.z;
  r0.z = cmp(0 < r0.w);
  r0.w = cmp(r0.w < 0);
  r0.z = (int)-r0.z + (int)r0.w;
  r0.z = (int)r0.z;
  r0.z = max(0, r0.z);
  r0.w = cmp(r0.z >= 0.00999999978);
  r3.xyz = r0.www ? float3(0,0,0) : cb0[9].xyz;
  r3.xyz = r3.xyz * r2.www;
  r0.w = cmp(0 < r0.x);
  r1.z = cmp(r0.x < 0);
  r0.x = saturate(r0.x);
  r0.w = (int)-r0.w + (int)r1.z;
  r0.w = (int)r0.w;
  r0.w = max(0, r0.w);
  r0.w = cb0[8].x * r0.w;
  r0.w = max(1, r0.w);
  r1.z = 0.0174532942 * cb0[6].y;
  sincos(r1.z, r4.x, r5.x);
  r1.z = cb0[6].w * cb0[6].z;
  r1.w = r1.z * r5.x;
  r1.z = r1.z * r4.x;
  r4.xyzw = float4(0.412999988,0.300000012,0.588,0.885999978) * r1.wwww;
  r5.xyzw = float4(0.700999975,0.587000012,0.114,0.298999995) * r1.wwww;
  r4.yz = cb0[6].ww * float2(0.298999995,0.587000012) + -r4.yz;
  r4.xw = cb0[6].ww * float2(0.587000012,0.114) + r4.xw;
  r1.w = -r1.z * 1.04999995 + r4.z;
  r3.w = r1.z * 1.25 + r4.y;
  r1.w = r1.w * r0.y;
  r1.w = r3.w * r1.x + r1.w;
  r3.w = -r1.z * 0.202999994 + r4.w;
  r4.x = r1.z * 0.0350000001 + r4.x;
  r4.x = r4.x * r0.y;
  r2.z = r3.w * r1.y + r1.w;
  r4.yzw = cb0[6].www * float3(0.587000012,0.114,0.298999995) + -r5.yzw;
  r1.w = cb0[6].w * 0.298999995 + r5.x;
  r1.w = r1.z * 0.167999998 + r1.w;
  r3.w = r1.z * 0.330000013 + r4.y;
  r0.y = r3.w * r0.y;
  r0.y = r1.w * r1.x + r0.y;
  r4.yw = -r1.zz * float2(0.497000009,0.328000009) + r4.zw;
  r1.z = r1.z * 0.291999996 + r4.z;
  r2.x = r4.y * r1.y + r0.y;
  r0.y = r4.w * r1.x + r4.x;
  r2.y = r1.z * r1.y + r0.y;
  r1.xyz = r2.xyz * r0.www + r3.xyz;
  r0.y = saturate(cb0[8].x);
  r0.y = -cb0[7].y + r0.y;
  r0.x = r0.x * r0.y + cb0[7].y;
  r0.y = 1 + -r0.x;
  r0.x = r0.z * r0.y + r0.x;
  r1.w = r2.w * r0.x;
  r0.xyzw = r1.xyzw + -r2.xyzw;
  r0.xyzw = cb0[8].yyyy * r0.xyzw + r2.xyzw;
  r0.w = cb0[5].x * r0.w;
  o0.xyzw = cb0[4].xyzw * r0.xyzw;
  o0 = saturate(o0);
  return;
}