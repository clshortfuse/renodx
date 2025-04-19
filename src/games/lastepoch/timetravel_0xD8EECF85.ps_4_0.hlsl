#include "./common.hlsl"

Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[1];
}
cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(1, 2, 1, 0.180000007) * v1.xyxy;
  r1.xyzw = cb1[0].yyyy * float4(-0.0355699994, 0.745612204, 0.0548, 0.655485988) + r0.xyxy;
  r2.x = dot(r1.zw, float2(0.696706712, 0.717356086));
  r2.y = dot(r1.zw, float2(-0.717356086, 0.696706712));
  r1.xyzw = t3.Sample(s4_s, r1.xy).xyzw;
  r2.xyzw = t4.Sample(s5_s, r2.xy).xyzw;
  r3.xyzw = cb1[0].yyyy * float4(-0.0355699994, 0.811235011, 0.0253400002, 0.255600005) + r0.xyxy;
  r4.x = dot(r3.xy, float2(0.696706712, 0.717356086));
  r4.y = dot(r3.xy, float2(-0.717356086, 0.696706712));
  r3.xyzw = t5.Sample(s6_s, r3.zw).xyzw;
  r4.xyzw = t4.Sample(s5_s, r4.xy).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r2.xyzw = float4(0.223139301, 0.728760183, 1.63921595, 0) * r2.xyzw;
  r4.xyzw = float4(-0.0253999997, 2.5, 0.0548, 1) * cb1[0].yyyy;
  r4.zw = v1.xy * float2(1, 2) + r4.zw;
  r4.xy = v1.xy * float2(1, 5) + r4.xy;
  r5.xyzw = t2.Sample(s3_s, r4.xy).xyzw;
  r4.xyzw = t3.Sample(s4_s, r4.zw).xyzw;
  r1.xyzw = r4.xyzw + r1.xyzw;
  r1.xyzw = float4(0.330178589, 0.321568608, 0.58431381, 0) * r1.xyzw;
  r1.xyzw = r1.xyzw + r2.xyzw;
  r2.xyzw = cb1[0].yyyy * float4(0.0253400002, 0.654411972, -0.043531999, 0.586619973) + r0.xyxy;
  r4.xyzw = t0.Sample(s1_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s1_s, r2.zw).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r4.xyzw = cb1[0].yyyy * float4(-0.0334299989, 0.735414982, 0.0445870012, 0.0657799989) + r0.xyzw;
  r6.xyzw = t0.Sample(s1_s, r4.xy).xyzw;
  r4.xyzw = t1.Sample(s2_s, r4.zw).xyzw;
  r4.xyzw = min(float4(0.849056602, 0.849056602, 0.849056602, 0), r4.xyzw);
  r4.xyzw = max(float4(0, 0, 0, 0), r4.xyzw);
  r2.xyzw = r6.xyzw + r2.xyzw;
  r2.xyzw = -r2.xyzw * float4(8, 8, 8, 8) + float4(1, 1, 1, 1);
  r2.xyzw = max(float4(0, 0, 0, 0), r2.xyzw);
  r2.xyzw = min(float4(1, 1, 1, 0), r2.xyzw);
  r1.xyzw = r2.xyzw * r1.xyzw;
  r6.xyzw = cb1[0].yyyy * float4(-0.043531999, 0.534460008, -0.0334299989, 0.756500006) + r0.xyxy;
  r0.xyzw = cb1[0].yyyy * float4(0, 0.356429994, -0.0253999997, 0.454580009) + r0.xyxy;
  r7.xyzw = t5.Sample(s6_s, r6.xy).xyzw;
  r6.xyzw = t5.Sample(s6_s, r6.zw).xyzw;
  r3.xyzw = r7.xyzw + r3.xyzw;
  r3.xyzw = r3.xyzw + r6.xyzw;
  r3.xyzw = -r3.xyzw * float4(4, 4, 4, 4) + float4(1, 1, 1, 1);
  r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
  r3.xyzw = min(float4(1, 1, 1, 0), r3.xyzw);
  r1.xyzw = r3.xyzw * r1.xyzw;
  r3.xyzw = t6.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t6.Sample(s0_s, r0.zw).xyzw;
  r0.xyz = r3.xyz + r0.xyz;
  r0.xyz = r0.xyz * r2.xyz;
  r0.xyz = float3(0.200000003, 0.200000003, 0.200000003) * r0.xyz;
  r2.xyzw = float4(0.0520000011, 0.0886999965, -0.0253999997, 0.1875) * cb1[0].yyyy;
  r2.xyzw = v1.xyxy * float4(1, 0.230000004, 1, 0.200000003) + r2.xyzw;
  r3.xyzw = t1.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s2_s, r2.zw).xyzw;
  r2.xyzw = min(float4(0.106283396, 0.105882399, 0.549019575, 0), r2.xyzw);
  r2.xyzw = max(float4(0, 0, 0, 0), r2.xyzw);
  r3.xyzw = min(float4(0.0313725509, 0.2614685, 0.745098114, 0), r3.xyzw);
  r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
  r3.xyzw = r4.xyzw + r3.xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r3.xy = float2(1, 5) * v1.xy;
  r3.xyzw = cb1[0].yyyy * float4(0.0445870012, 2, 0.0520000011, 3) + r3.xyxy;
  r4.xyzw = t2.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s3_s, r3.zw).xyzw;
  r3.xyzw = float4(0.137161002, 0.175536007, 1.63735998, 0) * r3.xyzw;
  r4.xyzw = float4(0.117773801, 0.122330502, 1.18393695, 0) * r4.xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r3.xyzw = r5.xyzw * float4(2, 2, 2, 2) + r3.xyzw;
  r2.xyzw = r3.xyzw * float4(0.300000012, 0.300000012, 0.300000012, 0.300000012) + r2.xyzw;
  r0.w = 0;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw * float4(0.800000012, 0.800000012, 0.800000012, 0.800000012) + r1.xyzw;
  r1.x = cb0[2].x + v1.y;
  r1.x = 1 + -r1.x;
  r1.x = saturate(r1.x + r1.x);
  o0.xyzw = r1.xxxx * r0.xyzw;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
