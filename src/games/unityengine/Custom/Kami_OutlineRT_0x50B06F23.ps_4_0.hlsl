Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[9];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float2 w2 : TEXCOORD1,
  float2 v3 : TEXCOORD2,
  float2 w3 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.y = 0;
  r1.x = cb0[8].x * cb0[7].x;
  r0.x = 3 * r1.x;
  r0.zw = -r0.xx;
  r2.xyzw = v2.xyxy + r0.zyyw;
  r3.xyzw = v2.xyxy + r0.xyyx;
  r0.xyzw = r0.xxxx * float4(-1,1,1,-1) + v2.xyxy;
  r4.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, r2.zw).xyzw;
  r5.xyzw = t1.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t1.Sample(s0_s, r3.zw).xyzw;
  r1.y = r5.w + r4.w;
  r1.y = r1.y + r3.w;
  r1.y = r1.y + r2.w;
  r1.zw = r1.xx * float2(3,3) + v2.xy;
  r2.xy = -r1.xx * float2(3,3) + v2.xy;
  r2.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r3.xyzw = t1.Sample(s0_s, r1.zw).xyzw;
  r1.x = r3.w + r1.y;
  r3.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t1.Sample(s0_s, r0.zw).xyzw;
  r0.x = r3.w + r1.x;
  r0.x = r0.x + r0.w;
  r0.x = saturate(r0.x + r2.w);
  r1.xyzw = t1.Sample(s0_s, v2.xy).xyzw;
  r0.x = -r1.w + r0.x;
  r1.y = 0;
  r1.xz = float2(-150,-10) * cb1[0].xx;
  r0.yz = v3.xy * cb0[5].xy + r1.yz;
  r0.w = v3.y * 0.5 + r1.x;
  r0.w = sin(r0.w);
  r0.w = 0.5 * r0.w;
  r0.w = max(0, r0.w);
  r1.xyz = float3(0,0.199999988,0.199999988) + r0.www;
  r2.xyzw = t2.Sample(s1_s, r0.yz).xyzw;
  r0.x = -r2.x * 0.150000006 + r0.x;
  r0.yzw = r0.xxx * r1.xyz + float3(1,0.74000001,0.579999983);
  o0.xyz = v1.xyz * r0.yzw;
  r2.xyzw = t0.Sample(s2_s, v2.xy).xyzw;
  r0.y = r2.w + -r1.w;
  r0.x = r0.x + r0.y;
  o0.w = v1.w * r0.x;
  o0.w = saturate(o0.w);
  return;
}