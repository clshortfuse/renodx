Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[122];
}

void main(
    float4 v0: SV_POSITION0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    float4 v3: TEXCOORD2,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.w = dot(r0.xyz, float3(0.0396819152, 0.45802179, 0.00609653955));
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.x = dot(r1.xyz, float3(0.0396819152, 0.45802179, 0.00609653955));
  r2.xyzw = t0.Sample(s0_s, v2.xw).xyzw;
  r1.y = dot(r2.xyz, float3(0.0396819152, 0.45802179, 0.00609653955));
  r2.xyzw = t0.Sample(s0_s, v2.zy).xyzw;
  r1.z = dot(r2.xyz, float3(0.0396819152, 0.45802179, 0.00609653955));
  r1.z = 0.00260416674 + r1.z;
  r2.xyzw = t0.Sample(s0_s, v2.zw).xyzw;
  r1.w = dot(r2.xyz, float3(0.0396819152, 0.45802179, 0.00609653955));
  r2.xy = max(r1.zx, r1.wy);
  r2.x = max(r2.x, r2.y);
  r2.yz = min(r1.zx, r1.wy);
  r2.y = min(r2.y, r2.z);
  r2.z = max(r2.x, r0.w);
  r0.w = min(r2.y, r0.w);
  r0.w = r2.z + -r0.w;
  r2.z = cb0[121].x * r2.x;
  r2.z = max(0, r2.z);
  if (r0.w < r2.z) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  r0.xy = r1.yw + -r1.zx;
  r1.x = r0.x + r0.y;
  r1.y = r0.x + -r0.y;
  r0.x = dot(r1.xy, r1.xy);
  r0.x = rsqrt(r0.x);
  r0.xy = r1.xy * r0.xx;
  r0.z = min(abs(r0.x), abs(r0.y));
  r0.z = cb0[121].y * r0.z;
  r1.xy = -r0.xy * v3.xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r2.zw = r0.xy * v3.xy + v1.xy;
  r3.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r0.xy = r0.xy / r0.zz;
  r0.xy = max(float2(-2, -2), r0.xy);
  r0.xy = min(float2(2, 2), r0.xy);
  r0.zw = -r0.xy * v3.zw + v1.xy;
  r4.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xy = r0.xy * v3.zw + v1.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.xyz = r3.xyz + r1.xyz;
  r0.xyz = r4.xyz + r0.xyz;
  r3.xyz = float3(0.25, 0.25, 0.25) * r1.xyz;
  r0.xyz = r0.xyz * float3(0.25, 0.25, 0.25) + r3.xyz;
  r0.w = dot(r1.xyz, float3(0.0396819152, 0.45802179, 0.00609653955));
  r1.w = dot(r0.xyz, float3(0.0396819152, 0.45802179, 0.00609653955));
  if (r0.w < r2.y || r2.x < r1.w) {
    o0.xyz = float3(0.5, 0.5, 0.5) * r1.xyz;
    o0.w = 1;
    return;
  } else {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  return;
}
