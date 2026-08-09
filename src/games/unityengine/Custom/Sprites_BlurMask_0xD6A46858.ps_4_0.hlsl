#include "../shared.h"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb2 : register(b2){
  float4 cb2[2];
}
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v2.xy).xyzw;
  r1.yw = float2(0,0);
  r2.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.x = -r3.w + r2.x;
  r2.x = cb2[1].z * r2.x + r3.w;
  r2.x = v1.z * r2.x;
  r2.x = saturate(cb0[6].z * r2.x);
  r2.y = cb0[6].x * cb0[6].y;
  r2.x = r2.y * r2.x;
  r1.xz = float2(0.166666672,0.333333343) * r2.xx;
  r1.xyzw = v2.xyxy + r1.xyzw;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.yw = float2(0,0);
  r1.xz = float2(0.5,0.666666687) * r2.xx;
  r1.xyzw = v2.xyxy + r1.xyzw;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.yw = float2(0,0);
  r1.xz = float2(0.833333373,1) * r2.xx;
  r1.xyzw = v2.xyxy + r1.xyzw;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.x = cb1[6].x * r2.x;
  r2.y = r1.x / cb1[6].y;
  r1.xyzw = r2.xyxy * float4(0.153979927,0.063780576,0.307959855,0.127561152) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.461939752,0.191341728,0.615919709,0.255122304) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.769899607,0.31890288,0.923879504,0.382683456) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.117851131,0.117851131,0.235702261,0.235702261) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.353553385,0.353553385,0.471404523,0.471404523) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.589255631,0.589255631,0.707106769,0.707106769) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.063780576,0.153979927,0.127561152,0.307959855) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.191341713,0.461939752,0.255122304,0.615919709) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.31890285,0.769899607,0.382683426,0.923879504) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-7.28523153e-09,0.166666672,-1.45704631e-08,0.333333343) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-2.18556941e-08,0.5,-2.91409261e-08,0.666666687) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-3.64261581e-08,0.833333373,-4.37113883e-08,1) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.0637805909,0.153979927,-0.127561182,0.307959855) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.191341758,0.461939752,-0.255122364,0.615919709) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.31890294,0.769899607,-0.382683516,0.923879504) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.117851131,0.117851131,-0.235702261,0.235702261) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.353553385,0.353553385,-0.471404523,0.471404523) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.589255631,0.589255631,-0.707106769,0.707106769) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.153979942,0.0637805462,-0.307959884,0.127561092) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.461939812,0.191341639,-0.615919769,0.255122185) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.769899726,0.318902731,-0.923879623,0.382683277) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.166666672,-1.45704631e-08,-0.333333343,-2.91409261e-08) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.5,-4.37113883e-08,-0.666666687,-5.82818522e-08) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.833333373,-7.28523162e-08,-1,-8.74227766e-08) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.153979927,-0.063780576,-0.307959855,-0.127561152) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.461939752,-0.191341713,-0.615919709,-0.255122304) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.769899607,-0.31890285,-0.923879504,-0.382683426) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.117851108,-0.117851153,-0.235702217,-0.235702306) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.353553325,-0.353553444,-0.471404433,-0.471404612) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.589255571,-0.58925575,-0.70710665,-0.707106888) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.0637805238,-0.153979957,-0.127561048,-0.307959914) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.191341564,-0.461939842,-0.255122095,-0.615919828) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(-0.318902612,-0.769899786,-0.382683128,-0.923879683) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(1.98748018e-09,-0.166666672,3.97496036e-09,-0.333333343) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(5.96244032e-09,-0.5,7.94992072e-09,-0.666666687) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(9.93740112e-09,-0.833333373,1.19248806e-08,-1) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.0637806058,-0.153979912,0.127561212,-0.307959825) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.191341802,-0.461939722,0.255122423,-0.61591965) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.318902999,-0.769899547,0.382683605,-0.923879445) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.117851168,-0.117851093,0.235702336,-0.235702187) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.353553504,-0.353553265,0.471404672,-0.471404374) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.589255869,-0.589255452,0.707107008,-0.707106531) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.153979927,-0.063780576,0.307959855,-0.127561152) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = r2.xyxy * float4(0.461939782,-0.191341713,0.615919709,-0.255122304) + v2.xyxy;
  r2.xyzw = r2.xyxy * float4(0.769899666,-0.31890285,0.923879564,-0.382683426) + v2.xyxy;
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r3.xyzw = saturate(r3.xyzw);
  }
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.zw).xyzw;
  if(injectedData.toneMapType == 0.f){
  r2.xyzw = saturate(r2.xyzw);
  r1.xyzw = saturate(r1.xyzw);
  }
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r2.xyzw;
  o0.xyzw = float4(0.010309278,0.010309278,0.010309278,0.010309278) * r0.xyzw;
  return;
}