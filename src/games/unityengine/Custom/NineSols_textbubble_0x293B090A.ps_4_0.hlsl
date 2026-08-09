
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
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
  r0.z = r0.y * cb0[0].x + cb0[2].z;
  r0.z = sin(r0.z);
  r0.z = cb0[2].x * r0.z;
  r1.xy = cb0[4].zw + -cb0[4].xy;
  r2.x = r0.z * r1.x + r0.x;
  r0.x = r2.x * cb0[0].y + cb0[2].w;
  r0.x = cos(r0.x);
  r0.x = cb0[2].y * r0.x;
  r2.y = r0.x * r1.y + r0.y;
  r0.xy = r1.xy * float2(0.5,0.5) + cb0[4].xy;
  r0.zw = r2.xy + -r0.xy;
  r1.z = dot(r0.zw, r0.zw);
  r1.w = sqrt(r1.z);
  r1.z = rsqrt(r1.z);
  r0.zw = r1.zz * r0.zw;
  r1.z = -0.5 + cb0[0].z;
  r1.z = 4.44289351 * r1.z;
  r1.w = r1.w * -r1.z;
  r1.z = -r1.z * r0.y;
  r1.xy = r1.wz * r1.xy;
  r1.xy = float2(10,10) * r1.xy;
  r1.z = max(1, abs(r1.x));
  r1.z = 1 / r1.z;
  r1.w = min(1, abs(r1.x));
  r1.z = r1.w * r1.z;
  r1.w = r1.z * r1.z;
  r2.x = r1.w * 0.0208350997 + -0.0851330012;
  r2.x = r1.w * r2.x + 0.180141002;
  r2.x = r1.w * r2.x + -0.330299497;
  r1.w = r1.w * r2.x + 0.999866009;
  r2.x = r1.z * r1.w;
  r2.x = r2.x * -2 + 1.57079637;
  r2.y = cmp(1 < abs(r1.x));
  r1.x = min(1, r1.x);
  r1.x = cmp(r1.x < -r1.x);
  r2.x = r2.y ? r2.x : 0;
  r1.z = r1.z * r1.w + r2.x;
  r1.x = r1.x ? -r1.z : r1.z;
  r0.zw = r1.xx * r0.zw;
  r0.zw = r0.zw * r0.yy;
  r1.x = max(1, abs(r1.y));
  r1.x = 1 / r1.x;
  r1.z = min(1, abs(r1.y));
  r1.x = r1.z * r1.x;
  r1.z = r1.x * r1.x;
  r1.w = r1.z * 0.0208350997 + -0.0851330012;
  r1.w = r1.z * r1.w + 0.180141002;
  r1.w = r1.z * r1.w + -0.330299497;
  r1.z = r1.z * r1.w + 0.999866009;
  r1.w = r1.x * r1.z;
  r1.w = r1.w * -2 + 1.57079637;
  r2.x = cmp(1 < abs(r1.y));
  r1.y = min(1, r1.y);
  r1.y = cmp(r1.y < -r1.y);
  r1.w = r2.x ? r1.w : 0;
  r1.x = r1.x * r1.z + r1.w;
  r1.x = r1.y ? -r1.x : r1.x;
  r0.zw = r0.zw / r1.xx;
  r0.xy = r0.xy + r0.zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyz = v2.xyz * r0.xyz;
  o0.w = r0.w * v2.w + -cb0[3].x;
  o0.xyz = r0.xyz;
  o0.w = max(0.f, o0.w);
  return;
}