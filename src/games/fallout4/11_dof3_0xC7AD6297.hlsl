// alpha mask dof

Texture2D<float4> t0 : register(t0);  // post lut
Texture2D<float4> t2 : register(t2);  // depth

cbuffer cb2 : register(b2) {
  float4 cb2[4];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, float2 w1 : TEXCOORD1, out float4 o0 : SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.5, 0.5) + -v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = saturate(r0.x * 1.41421354 + -cb2[2].x);
  r0.x = cb2[2].y * r0.x;
  r1.xy = (int2)w1.xy;
  r1.zw = float2(0, 0);
  r0.y = t2.Load(r1.xyz).x;
  r1.xyz = t0.Load(r1.xyw).xyz;
  o0.xyz = r1.xyz;
  r0.y = r0.y * 2 + -1;
  r0.y = -r0.y * cb2[3].z + cb2[3].y;
  r0.y = cb2[3].x / r0.y;
  r0.z = -cb2[0].y + r0.y;
  r0.z = max(0, r0.z);
  r0.z = saturate(r0.z / cb2[0].w);
  r0.z = cb2[2].z * r0.z;
  r0.w = cmp(r0.y >= cb2[3].w);
  r0.y = cb2[0].x + -r0.y;
  r0.y = max(0, r0.y);
  r0.y = saturate(r0.y / cb2[0].z);
  r1.x = cmp(cb2[2].w == 1.000000);
  r0.w = r0.w ? r1.x : 0;
  r0.z = r0.w ? 0 : r0.z;
  r0.w = max(r0.z, r0.x);
  r0.x = cmp(0 < r0.x);
  r1.x = cb2[2].z + cb2[2].z;
  r1.y = r1.x * r0.y;
  r0.y = -r1.x * r0.y + r0.z;
  r0.z = max(r1.y, r0.w);
  r0.x = r0.x ? -r0.z : r0.y;
  o0.w = 6 * abs(r0.x);
  return;
}
