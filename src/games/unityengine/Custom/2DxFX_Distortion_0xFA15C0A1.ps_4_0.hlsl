Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = min(cb0[4].zw, v0.xy);
  r0.xy = max(cb0[4].xy, r0.xy);
  r0.zw = cb0[4].zw + -cb0[4].xy;
  r1.xy = float2(1,1) / r0.zw;
  r1.y = r1.y * r0.y;
  r1.y = r1.y * cb0[0].x + cb0[2].z;
  r1.y = sin(r1.y);
  r1.y = cb0[2].x * r1.y;
  r2.x = r1.y * r0.z + r0.x;
  r0.x = r2.x * r1.x;
  r0.x = r0.x * cb0[0].y + cb0[2].w;
  r0.x = cos(r0.x);
  r0.x = cb0[2].y * r0.x;
  r2.y = r0.x * r0.w + r0.y;
  r0.xy = cmp(r2.xy < cb0[4].xy);
  r0.zw = cmp(cb0[4].zw < r2.xy);
  r1.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r1.xyzw = v2.xyzw * r1.xyzw;
  r0.x = (int)r0.z | (int)r0.x;
  r0.x = (int)r0.y | (int)r0.x;
  r0.x = (int)r0.w | (int)r0.x;
  r0.xyzw = r0.xxxx ? float4(0,0,0,0) : r1.xyzw;
  r0.xyzw = cb0[5].x == 1.0 ? r0.xyzw : r1.xyzw;
  o0.w = -cb0[3].x + r0.w;
  o0.xyz = r0.xyz;
  o0.w = saturate(o0.w);
  return;
}