Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[1];
}
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[17];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD3,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = cb2[0].xxx + cb1[0].xyw;
  r1.xy = cb0[10].xy * r0.xx;
  r1.zw = cmp(r1.xy >= -r1.xy);
  r1.zw = r1.zw ? float2(1,1) : float2(-1,-1);
  r1.xy = r1.xy * r1.zw;
  r1.xy = frac(r1.xy);
  r1.xy = r1.zw * r1.xy + w0.xy;
  r1.xyzw = t0.Sample(s1_s, r1.xy).xyzw;
  r0.w = -0.5 + r1.x;
  r0.w = 0.200000003 * r0.w;
  r1.xy = r0.ww * cb0[10].zz + v0.xy;
  r1.zw = cb0[6].xy * cb0[2].xy + -r1.xy;
  r2.xy = cmp(r1.zw >= -r1.zw);
  r2.xy = r2.xy ? float2(1,1) : float2(-1,-1);
  r1.zw = r2.xy * r1.zw;
  r1.zw = frac(r1.zw);
  r2.yz = r2.xy * r1.zw;
  r0.w = cb1[6].x / cb1[6].y;
  r2.x = r2.y * r0.w;
  r0.w = dot(r2.xz, r2.xz);
  r0.w = sqrt(r0.w);
  r0.y = cb0[5].z * r0.y;
  r0.y = r0.w * cb0[5].y + -r0.y;
  r0.y = sin(r0.y);
  r0.yw = r2.xz * r0.yy;
  r1.z = 0.00100000005 * cb0[5].w;
  r0.yw = r0.yw * r1.zz + r1.xy;
  r1.xyzw = t1.Sample(s0_s, r0.yw).xyzw;
  r1.yz = v2.yw * r1.yw;
  r2.xz = float2(0.100000001,-0.100000001) * cb0[14].xx;
  r2.yw = float2(0,0);
  r2.xyzw = r2.xyzw + r0.ywyw;
  r0.yw = cb0[15].yz + r0.yw;
  r3.xyzw = t1.Sample(s0_s, r0.yw).xyzw;
  r4.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, r2.zw).xyzw;
  r0.yw = v2.zw * r2.zw;
  r2.xy = v2.xw * r4.xw;
  r1.x = r2.x * r2.y;
  r2.x = max(r2.y, r0.w);
  r1.w = r0.y * r0.w;
  r0.y = cb0[14].y * r2.x;
  r0.y = max(r0.y, r1.z);
  r0.w = r3.w + -r0.y;
  r1.z = 1 + -r0.y;
  r0.w = -r0.w * r1.z + 1;
  r2.xyz = cb0[16].xyz * r3.www;
  r2.w = cb0[15].w * r3.w;
  r2.w = v2.w * r2.w;
  r3.w = max(r2.w, r0.y);
  r2.xyz = r2.xyz * r1.zzz;
  r1.xyz = r1.xyw * r0.www + r2.xyz;
  r0.y = r3.w * r3.w;
  r0.y = cb0[8].x * r0.y;
  r2.xyz = cb0[7].xyz * r0.yyy;
  r2.xyz = r2.xyz * r1.xyz;
  r3.xyz = r1.xyz * cb0[8].yyy + r2.xyz;
  r0.y = cmp(r0.x >= -r0.x);
  r0.y = r0.y ? 1 : -1;
  r0.x = r0.x * r0.y;
  r0.z = r0.z * cb0[14].z + 0.0500000007;
  r0.xz = frac(r0.xz);
  r0.x = r0.y * r0.x;
  r0.x = r0.x * cb0[11].z + v0.y;
  r0.y = cb0[11].y + cb0[10].w;
  r0.w = r0.x * r0.y;
  r0.w = cmp(r0.w >= -r0.w);
  r0.w = r0.w ? r0.y : -r0.y;
  r1.x = 1 / r0.w;
  r0.x = r1.x * r0.x;
  r0.x = frac(r0.x);
  r0.x = r0.w * r0.x;
  r0.x = r0.x / r0.y;
  r0.y = cb0[11].y / r0.y;
  r0.w = r0.y + -abs(r0.x);
  r0.x = abs(r0.x) + -r0.y;
  r0.y = cmp(0 < r0.w);
  r0.w = cmp(r0.w < 0);
  r0.y = (int)-r0.y + (int)r0.w;
  r0.y = (int)r0.y;
  r0.y = max(0, r0.y);
  r0.w = cmp(r0.y >= 0.00999999978);
  r1.xyz = r0.www ? float3(0,0,0) : cb0[13].xyz;
  r1.xyz = r1.xyz * r3.www;
  r0.w = cmp(0 < r0.x);
  r1.w = cmp(r0.x < 0);
  r0.x = saturate(r0.x);
  r0.w = (int)-r0.w + (int)r1.w;
  r0.w = (int)r0.w;
  r0.w = max(0, r0.w);
  r0.w = cb0[11].w * r0.w;
  r0.w = max(1, r0.w);
  r1.xyz = r3.xyz * r0.www + r1.xyz;
  r0.w = saturate(cb0[11].w);
  r0.w = -cb0[11].x + r0.w;
  r0.x = r0.x * r0.w + cb0[11].x;
  r0.w = 1 + -r0.x;
  r0.x = r0.y * r0.w + r0.x;
  r1.w = r3.w * r0.x;
  r1.xyzw = r1.xyzw + -r3.xyzw;
  r1.xyzw = cb0[12].xxxx * r1.xyzw + r3.xyzw;
  r0.x = 1 + -cb0[14].w;
  r0.x = cmp(r0.x >= r0.z);
  r0.x = r0.x ? 1.000000 : 0;
  r0.x = saturate(r1.w * r0.x + cb0[15].x);
  r0.x = r1.w * r0.x;
  r1.w = cb0[5].x * r0.x;
  o0.xyzw = cb0[4].xyzw * r1.xyzw;
  o0 = saturate(o0);
  return;
}