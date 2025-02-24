Texture2D<float4> t12 : register(t12);
SamplerState s5_s : register(s5);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t12.SampleLevel(s5_s, v1.xy, 0).xyzw;
  r1.xyz = r0.xyz;
  r0.w = 1;
  while (true) {
    r1.w = cmp((int)r0.w >= 8);
    if (r1.w != 0) break;
    r1.w = (int)r0.w;
    r2.xy = -v1.zw * r1.ww + v1.xy;
    r2.xyzw = t12.SampleLevel(s5_s, r2.xy, 0).xyzw;
    r1.xyz = r2.xyz + r1.xyz;
    r0.w = (int)r0.w + 1;
  }
  r1.xyz = r1.xyz * float3(0.125,0.125,0.125) + -r0.xyz;
  o0.xyz = cb1[2].xxx * r1.xyz + r0.xyz;
  o0.w = 1;
  return;
}