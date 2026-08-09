cbuffer cb0 : register(b0){
  float4 cb0[130];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.0833333358,0.0833333358) * v1.xy;
  r0.z = cb0[129].y * cb0[128].w;
  r1.xy = r0.xy * r0.zz;
  r1.xy = floor(r1.xy);
  r0.xy = r0.xy * r0.zz + -r1.xy;
  sincos(r0.z, r1.x, r2.x);
  r0.x = dot(r0.xy, float2(0.000100,98.233002));
  r0.x = sin(r0.x);
  r0.y = 925895936 * r0.x;
  r0.y = floor(r0.y);
  r0.x = r0.x * 925895936 + -r0.y;
  r0.y = r1.x / r2.x;
  r0.y = sin(r0.y);
  r0.y = frac(r0.y);
  o0.z = r0.x * r0.y;
  r0.y = sin(r1.x);
  r0.z = sin(r2.x);
  r0.yz = frac(r0.yz);
  o0.xy = r0.xx * r0.yz;
  o0.w = r0.x;
  o0 = saturate(o0);
  return;
}