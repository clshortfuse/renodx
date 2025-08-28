Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[4].xyzw * cb0[0].xxxx;
  r0.xyzw = frac(r0.xyzw);
  r0.xyzw = float4(6.28318024,6.28318024,6.28318024,6.28318024) * r0.xyzw;
  sincos(r0.xyzw, r0.xyzw, r1.xyzw);
  r2.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + v0.yyxx;
  r3.xyzw = r2.yyyy * r0.xyzw;
  r3.xyzw = r2.wwww * r1.xyzw + -r3.xyzw;
  r3.xyzw = float4(0.5,0.5,0.5,0.5) + r3.zxwy;
  r4.xz = r3.yw;
  r1.xyzw = r2.yyyy * r1.xyzw;
  r0.xyzw = r2.wwww * r0.xyzw + r1.xyzw;
  r0.xyzw = float4(0.5,0.5,0.5,0.5) + r0.xyzw;
  r4.yw = r0.xy;
  r3.yw = r0.zw;
  r0.x = t0.Sample(s0_s, r4.xy).x;
  r0.y = t0.Sample(s0_s, r4.zw).y;
  r0.x = r0.x + r0.y;
  r0.y = t0.Sample(s0_s, r3.xy).z;
  r0.z = t0.Sample(s0_s, r3.zw).w;
  r0.x = r0.x + r0.y;
  r0.x = r0.x + r0.z;
  r0.yz = cb0[5].xy * cb0[0].xx;
  r0.yz = frac(r0.yz);
  r0.yz = float2(6.28318024,6.28318024) * r0.yz;
  sincos(r0.yz, r1.xy, r3.xy);
  r1.xyzw = r2.xyzw * r1.xyxy;
  r0.yz = r2.ww * r3.xy + -r1.xy;
  r1.xy = r2.yy * r3.xy + r1.zw;
  r1.zw = float2(0.5,0.5) + r1.xy;
  r1.xy = float2(0.5,0.5) + r0.yz;
  r0.y = t1.Sample(s1_s, r1.yw).x;
  r0.zw = t1.Sample(s1_s, r1.xz).yz;
  r0.y = r0.y + r0.z;
  r0.x = r0.x * r0.w + r0.y;
  r0.xyzw = cb0[3].xyzw * r0.xxxx;
  r0.xyzw = cb0[2].xxxx * r0.xyzw;
  r0.xyz = r0.xyz * r0.www;
  o0.w = r0.w;
  r0.w = 1 + -v1.w;
  o0.xyz = r0.xyz * r0.www;
  o0 = saturate(o0);
  return;
}