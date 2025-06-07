Texture2D<float4> t12 : register(t12);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
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
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[7].x * cb0[1].x;
  r1.zw = cb0[8].xx * v0.xy;
  r1.y = r0.x * 2 + r1.z;
  r0.xy = r1.yw + r1.yw;
  r0.xy = t2.Sample(s2_s, r0.xy).xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r1.x = cb0[7].x * cb0[1].x + r1.z;
  r0.zw = t2.Sample(s2_s, r1.xw).xy;
  r0.xy = r0.zw * float2(2,2) + r0.xy;
  r0.xy = float2(-1,-1) + r0.xy;
  r0.xy = cb0[6].xx * r0.xy + v0.xy;
  r0.zw = float2(0.5,0.5) * r0.xy;
  r1.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r2.z = cb0[9].x * r0.w;
  r0.x = cb0[10].x * cb0[1].x;
  r2.x = r0.z * cb0[9].x + r0.x;
  r0.x = r0.z * cb0[11].x + r0.x;
  r0.z = cb0[11].x * r0.w;
  r0.xyzw = t0.Sample(s0_s, r0.xz).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.xz).xyzw;
  r0.xyzw = r2.xyzw * r0.xyzw;
  r0.xyzw = r0.xyzw * r1.xyzw;
  r0.xyzw = float4(4,4,4,4) * r0.xyzw;
  r1.xyzw = cmp(float4(9.99999991e-38,0,9.99999991e-38,0) < abs(r0.yyww));
  r1.yw = (int2)-r1.yw;
  r2.xy = cmp(r1.yw != float2(0,0));
  r1.yw = float2(9.99999991e-38,9.99999991e-38) * r1.yw;
  r1.yw = r2.xy ? r1.yw : float2(9.99999991e-38,9.99999991e-38);
  r1.xy = r1.xz ? abs(r0.yw) : r1.yw;
  r1.xy = log2(r1.xy);
  r1.x = cb0[12].x * r1.x;
  r1.y = cb0[13].x * r1.y;
  r2.w = exp2(r1.y);
  r1.x = exp2(r1.x);
  r3.xyzw = cb0[5].xyzw + -cb0[4].xyzw;
  r1.xyzw = r1.xxxx * r3.xyzw + cb0[4].xyzw;
  r1.xyz = saturate(r1.xyz * r0.xyz);
  r1.w = saturate(r1.w);
  r0.x = dot(r0.ww, cb0[14].xx);
  r2.xyz = r1.xyz;
  r1.xyzw = r1.xyzw + -r2.xyzw;
  r0.xyzw = r0.xxxx * r1.xyzw + r2.xyzw;
  r1.x = cb0[15].x * r2.w;
  r1.xyz = max(r1.xxx, r0.xyz);
  r1.xyz = v1.xyz * r1.xyz;
  r0.xyz = r1.xyz + r1.xyz;
  r0.xyzw = v1.wwww * r0.xyzw;
  r1.xy = cb0[2].xx + v3.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r1.x = t12.Sample(s12_s, r1.xy).x;
  r1.x = r1.x * cb0[0].w + -cb0[0].z;
  r1.x = -w0.x + r1.x;
  r1.x = saturate(r1.x / cb0[16].x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.x = 1 + -v2.w;
  o0.xyzw = r1.xxxx * r0.xyzw;
  o0.a = saturate(o0.a);
  return;
}