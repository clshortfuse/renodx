Texture2D<float4> t12 : register(t12);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[28];
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t3.Sample(s3_s, v0.xy).xyzw;
  r1.x = dot(r0.xyzw, float4(1,1,1,1));
  r1.y = cmp(0 < r1.x);
  r1.z = cmp(r1.x < 0);
  r1.y = (int)-r1.y + (int)r1.z;
  r1.y = (int)r1.y;
  r1.z = cmp(r1.y != 0.000000);
  r1.y = 9.99999991e-38 * r1.y;
  r1.y = r1.z ? r1.y : 9.99999991e-38;
  r1.z = cmp(9.99999991e-38 < abs(r1.x));
  r1.y = r1.z ? r1.x : r1.y;
  r1.x = min(1, r1.x);
  r1.x = 1 + -r1.x;
  r0.xyzw = r0.xyzw / r1.yyyy;
  r1.y = cb0[8].x * cb0[1].x;
  r1.zw = v0.xy + v0.zw;
  r2.xy = cb0[7].xx * r1.zw;
  r2.z = r1.y * 2 + r2.y;
  r1.yz = r2.xz + r2.xz;
  r1.yz = t2.Sample(s2_s, r1.yz).xy;
  r1.yz = r1.yz * float2(2,2) + float2(-1,-1);
  r2.w = cb0[8].x * cb0[1].x + r2.y;
  r2.xy = t2.Sample(s2_s, r2.xw).xy;
  r1.yz = r2.xy * float2(2,2) + r1.yz;
  r1.yz = float2(-1,-1) + r1.yz;
  r1.yz = cb0[6].xx * r1.yz + v0.xy;
  r1.w = 0.5 + v1.x;
  r2.xy = r1.ww * r1.yz;
  r3.xyzw = t1.Sample(s1_s, r1.yz).xyzw;
  r1.y = r2.y * cb0[9].x + v1.z;
  r4.z = cb0[1].x * cb0[10].x + r1.y;
  r4.x = cb0[9].x * r2.x;
  r4.xyzw = t0.Sample(s0_s, r4.xz).xyzw;
  r1.y = r2.y * cb0[11].x + v1.w;
  r2.x = cb0[11].x * r2.x;
  r2.z = cb0[1].x * cb0[10].x + r1.y;
  r2.xyzw = t0.Sample(s0_s, r2.xz).xyzw;
  r2.xyzw = r4.xyzw * r2.xyzw;
  r2.xyzw = r2.xyzw * r3.xyzw;
  r1.yzw = saturate(-r2.xyz * float3(4,4,4) + float3(1,1,1));
  r1.yzw = cb0[12].xyz * r1.yzw;
  r3.xyzw = float4(4,4,4,5.5999999) * r2.xyzw;
  r2.x = 28 * r2.w;
  r1.yzw = cb0[5].xyz * r3.xyz + r1.yzw;
  r1.yzw = r1.yzw * r3.xyz;
  r1.yzw = v3.xyz * r1.yzw;
  r4.xyz = saturate(r1.yzw + r1.yzw);
  r4.w = 1;
  r5.x = dot(cb0[4].xyzw, r4.xyzw);
  r5.y = dot(cb0[13].xyzw, r4.xyzw);
  r5.z = dot(cb0[14].xyzw, r4.xyzw);
  r5.w = dot(cb0[15].xyzw, r4.xyzw);
  r5.x = dot(r5.xyzw, r0.xyzw);
  r6.x = dot(cb0[16].xyzw, r4.xyzw);
  r6.y = dot(cb0[17].xyzw, r4.xyzw);
  r6.z = dot(cb0[18].xyzw, r4.xyzw);
  r6.w = dot(cb0[19].xyzw, r4.xyzw);
  r5.y = dot(r6.xyzw, r0.xyzw);
  r6.x = dot(cb0[20].xyzw, r4.xyzw);
  r6.y = dot(cb0[21].xyzw, r4.xyzw);
  r6.z = dot(cb0[22].xyzw, r4.xyzw);
  r6.w = dot(cb0[23].xyzw, r4.xyzw);
  r5.z = dot(r6.xyzw, r0.xyzw);
  r0.xyz = -r5.xyz + r4.xyz;
  r0.xyz = r1.xxx * r0.xyz + r5.xyz;
  r3.xyz = r0.xyz * r3.www;
  r0.xyz = r3.xyz;
  r1.x = dot(r3.ww, cb0[24].xx);
  r0.w = 0;
  r0.xyzw = -r3.xyzw + r0.xyzw;
  r0.xyzw = r1.xxxx * r0.xyzw + r3.xyzw;
  r1.xy = cmp(float2(9.99999991e-38,0) < abs(r2.xx));
  r1.y = (int)-r1.y;
  r1.z = cmp(r1.y != 0.000000);
  r1.y = 9.99999991e-38 * r1.y;
  r1.y = r1.z ? r1.y : 9.99999991e-38;
  r1.x = r1.x ? abs(r2.x) : r1.y;
  r1.x = log2(r1.x);
  r1.x = cb0[25].x * r1.x;
  r1.x = exp2(r1.x);
  r1.x = cb0[26].x * r1.x;
  r0.xyz = max(r1.xxx, r0.xyz);
  r0.xyzw = v3.wwww * r0.xyzw;
  r1.xy = cb0[2].xx + v5.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r1.x = t12.Sample(s12_s, r1.xy).x;
  r1.x = r1.x * cb0[0].w + -cb0[0].z;
  r1.x = -v2.x + r1.x;
  r1.x = saturate(r1.x / cb0[27].x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.x = 1 + -v4.w;
  o0.xyzw = r1.xxxx * r0.xyzw;
  o0.a = saturate(o0.a);
  return;
}