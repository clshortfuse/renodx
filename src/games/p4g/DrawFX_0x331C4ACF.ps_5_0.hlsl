cbuffer _Globals : register(b0)
{
  float4 uACA : packoffset(c0);
  float4 uMACA : packoffset(c1);
  float4 uFogColor : packoffset(c2);
}

SamplerState smpAlbedo_s : register(s0);
Texture2D<float4> texAlbedo : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(uACA.xyz, uACA.xyz);
  r0.x = sqrt(r0.x);
  r0.x = cmp(0.000000 == r0.x);
  r0.y = uMACA.w * v0.w;
  r1.w = uACA.w * r0.y;
  r0.yzw = uACA.xyz * v0.xyz;
  r2.xyz = uMACA.xyz * r0.yzw;
  r1.xyz = v0.xyz;
  r2.w = r1.w;
  r0.xyzw = r0.xxxx ? r1.xyzw : r2.xyzw;
  r1.x = cmp(0 != w1.y);
  if (r1.x != 0) {
    r1.xyzw = texAlbedo.Sample(smpAlbedo_s, v1.xy).xyzw;
    r0.xyzw = r1.xyzw * r0.xyzw;
    o0.w = saturate(r0.w);  // added saturate
  } else {
    o0.w = saturate(r0.w);  // added saturate
  }
  r0.w = cmp(v2.x >= 0);
  r1.xyz = -uFogColor.xyz + r0.xyz;
  r1.xyz = v2.xxx * r1.xyz + uFogColor.xyz;
  o0.xyz = r0.www ? r1.xyz : r0.xyz;
  return;
}
