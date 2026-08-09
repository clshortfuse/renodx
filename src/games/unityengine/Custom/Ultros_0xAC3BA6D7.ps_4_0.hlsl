Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float3 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -cb0[4].x + v2.x;
  r0.y = cmp(abs(r0.x) < cb0[4].y);
  if (r0.y != 0) {
    o0.xyzw = float4(0,0,0,0);
    return;
  } else {
    r0.y = 0.0149999997 + cb0[4].y;
    r0.x = cmp(abs(r0.x) < r0.y);
    if (r0.x != 0) {
      o0.xyzw = float4(1,1,1,1);
      return;
    }
  }
  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyz = v1.xyz * r0.xyz;
  r1.xy = -cb0[3].xy + v3.xy;
  r1.z = 1.77777779 * r1.x;
  r1.xy = r1.zy / cb0[3].zz;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = 0.5 + -r1.x;
  r1.x = -r1.x * r1.x + 1;
  r1.y = r1.x * r1.x;
  r1.y = r1.y * r1.y;
  r1.x = r1.y * r1.x;
  o0.xyz = r1.xxx * r0.xyz;
  o0.w = r0.w;
  o0 = max(0, o0);  
  return;
}