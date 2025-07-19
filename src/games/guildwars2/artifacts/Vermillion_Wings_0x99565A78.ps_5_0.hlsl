Texture2D<float4> t12 : register(t12);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[18];
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

  r0.xy = v0.xy * float2(2,2) + float2(-1,-1);
  r1.xyzw = cmp(float4(9.99999991e-38,0,9.99999991e-38,0) < abs(r0.xxyy));
  r0.zw = (int2)-r1.yw;
  r1.yw = cmp(r0.zw != float2(0,0));
  r0.zw = float2(9.99999991e-38,9.99999991e-38) * r0.zw;
  r0.zw = r1.yw ? r0.zw : float2(9.99999991e-38,9.99999991e-38);
  r0.xy = r1.xz ? abs(r0.xy) : r0.zw;
  r0.xy = r0.xy * r0.xy;
  r0.x = r0.x + r0.y;
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.yz = cmp(float2(9.99999991e-38,0) < r0.xx);
  r0.z = (int)-r0.z;
  r0.w = cmp(r0.z != 0.000000);
  r0.z = 9.99999991e-38 * r0.z;
  r0.z = r0.w ? r0.z : 9.99999991e-38;
  r0.x = r0.y ? r0.x : r0.z;
  r0.x = log2(r0.x);
  r0.x = cb0[4].x * r0.x;
  r0.x = exp2(r0.x);
  r1.xyzw = v1.xyzw * r0.xxxx;
  r2.xyz = r1.xyz;
  r2.w = 1;
  r1.x = dot(r2.xyzw, cb0[5].xyzw);
  r1.y = dot(r2.xyzw, cb0[6].xyzw);
  r1.z = dot(r2.xyzw, cb0[7].xyzw);
  r0.yzw = -r0.xxx * v1.xyz + r1.xyz;
  r0.x = 4 * r0.x;
  r0.x = min(1, r0.x);
  r3.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.yzw = r3.xxx * r0.yzw + r2.xyz;
  r1.x = dot(r2.xyzw, cb0[8].xyzw);
  r1.y = dot(r2.xyzw, cb0[9].xyzw);
  r1.z = dot(r2.xyzw, cb0[10].xyzw);
  r1.xyz = r1.xyz + -r0.yzw;
  r2.xyz = r3.yyy * r1.xyz + r0.yzw;
  r2.w = 1;
  r1.x = dot(r2.xyzw, cb0[11].xyzw);
  r1.y = dot(r2.xyzw, cb0[12].xyzw);
  r1.z = dot(r2.xyzw, cb0[13].xyzw);
  r0.yzw = r1.xyz + -r2.xyz;
  r0.yzw = r3.zzz * r0.yzw + r2.xyz;
  r1.x = dot(r2.xyzw, cb0[14].xyzw);
  r1.y = dot(r2.xyzw, cb0[15].xyzw);
  r1.z = dot(r2.xyzw, cb0[16].xyzw);
  r1.xyz = r1.xyz + -r0.yzw;
  r0.yzw = r3.www * r1.xyz + r0.yzw;
  r0.xyz = r0.yzw * r0.xxx;
  r1.xy = cb0[2].xx + v3.xy;
  r1.xy = cb0[0].xy * r1.xy;
  r0.w = t12.Sample(s12_s, r1.xy).x;
  r0.w = r0.w * cb0[0].w + -cb0[0].z;
  r0.w = -w0.x + r0.w;
  r0.w = saturate(r0.w / cb0[17].x);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r1.w = r1.w * r0.w;
  r0.xyz = r1.www * r0.xyz;
  r1.xyz = cb0[1].xyz * r0.xyz;
  r0.xyzw = cb0[1].wwww * r1.xyzw;
  r1.x = 1 + -v2.w;
  o0.xyz = r1.xxx * r0.xyz;
  o0.w = r0.w;
  o0 = max(0.f, o0);
  return;
}