cbuffer psConstant : register(b1)
{
  float4 uACA : packoffset(c0);
  float4 uMACA : packoffset(c1);
  float4 uMDC : packoffset(c2);
  float4 uMSC : packoffset(c3);
  float4 uMEC : packoffset(c4);
  float4 uLAC : packoffset(c5);
  float4 uLDC : packoffset(c6);
  float4 uLSC : packoffset(c7);
  float4 uLVEC : packoffset(c8);
  float4 uMK : packoffset(c9);
  float4 uEYE : packoffset(c10);
}

cbuffer psConstant2 : register(b2)
{
  float4 uFogColor : packoffset(c0);
  float4 shadow_color : packoffset(c1);
  float4 uFlag : packoffset(c2);
  float4 uBitsFlag : packoffset(c3);
  float4 uBlendFlag : packoffset(c4);
  float4 uBlendFactor : packoffset(c5);
  float4 uLIGHTTYPE : packoffset(c6);
  float4 uEdgeParam : packoffset(c7);
  float4 uEdgeColor : packoffset(c8);
  float4 uDEBUG_COLOR : packoffset(c9);
}

cbuffer psConstant4 : register(b4)
{
  float4 uDEFCOLOR : packoffset(c0);
}

SamplerState smpAlbedo_s : register(s0);
SamplerState smpAlbedo2_s : register(s1);
SamplerState smpAlbedo3_s : register(s2);
SamplerState smpAlbedo4_s : register(s3);
SamplerState smpAlbedo_Shadow_s : register(s4);
Texture2D<float4> texAlbedo : register(t0);
Texture2D<float4> texAlbedo2 : register(t1);
Texture2D<float4> texAlbedo3 : register(t2);
Texture2D<float4> texAlbedo4 : register(t3);
Texture2D<float4> texAlbedo_Shadow : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float4 v1 : NORMAL0,
  float2 v2 : TEXCOORD0,
  float2 w2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float2 v5 : TEXCOORD4,
  float2 w5 : TEXCOORD6,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(uLIGHTTYPE.x != 0.000000);
  if (r0.x != 0) {
    r0.x = cmp(0.000000 != uDEFCOLOR.x);
    r0.yzw = uACA.xyz * v0.xyz;
    r0.yzw = r0.xxx ? r0.yzw : uACA.xyz;
    r1.xyz = uMACA.xyz * r0.yzw;
    r2.w = uMACA.w * uACA.w;
    r1.w = cmp(1 < uLIGHTTYPE.x);
    if (r1.w != 0) {
      r1.w = dot(v1.xyz, v1.xyz);
      r1.w = rsqrt(r1.w);
      r3.xyz = v1.xyz * r1.www;
      r4.xyz = float3(1,1,1) + -uLAC.xyz;
      r4.xyz = v0.xyz * r4.xyz + uLAC.xyz;
      r4.xyz = uMACA.xyz * r4.xyz;
      r5.xyz = uLAC.xyz * uMACA.xyz;
      r4.xyz = r0.xxx ? r4.xyz : r5.xyz;
      r1.w = dot(r3.xyz, uLVEC.xyz);
      r5.xyz = uLDC.xyz * uMDC.xyz;
      r3.w = max(0, r1.w);
      r4.w = cmp(uLIGHTTYPE.x >= 3);
      r6.xyz = uEYE.xyz + -v6.xyz;
      r5.w = dot(r6.xyz, r6.xyz);
      r5.w = rsqrt(r5.w);
      r6.xyz = r6.xyz * r5.www + uLVEC.xyz;
      r1.w = cmp(r1.w >= 0);
      r1.w = r1.w ? 1.000000 : 0;
      r7.xyz = uMSC.xyz * r1.www;
      r7.xyz = uLSC.xyz * r7.xyz;
      r1.w = dot(r6.xyz, r3.xyz);
      r1.w = max(0, r1.w);
      r1.w = log2(r1.w);
      r1.w = 10 * r1.w;
      r1.w = exp2(r1.w);
      r3.xyz = r7.xyz * r1.www;
      r3.xyz = uMK.xxx * r3.xyz;
      r3.xyz = float3(0.00249999994,0.00249999994,0.00249999994) * r3.xyz;
      r3.xyz = r4.www ? r3.xyz : 0;
      r4.xyz = r5.xyz * r3.www + r4.xyz;
      r3.xyz = r4.xyz + r3.xyz;
    } else {
      r3.xyz = float3(0,0,0);
    }
    r0.yzw = r0.yzw * uMACA.xyz + uMEC.xyz;
    r0.yzw = r0.yzw + r3.xyz;
    r1.xyz = r1.xyz * v0.xyz + uMEC.xyz;
    r1.xyz = r1.xyz + r3.xyz;
    r1.w = v0.w * r2.w;
    r2.xyz = r0.xxx ? r1.xyz : r0.yzw;
    r0.xyzw = r0.xxxx ? r1.xyzw : r2.xyzw;
  } else {
    r1.x = uMACA.x + uMACA.y;
    r1.x = uMACA.z + r1.x;
    r1.y = uMACA.w * v0.w;
    r2.w = uACA.w * r1.y;
    r1.x = cmp(0.000000 != r1.x);
    r2.xyz = v0.xyz;
    r3.xyz = uMACA.xyz;
    r3.w = r2.w;
    r0.xyzw = r1.xxxx ? r2.xyzw : r3.xyzw;
  }
  r1.x = dot(v1.xyz, v1.xyz);
  r1.y = sqrt(r1.x);
  r1.y = cmp(r1.y == 0.000000);
  r1.zw = v7.xy / v7.ww;
  r1.z = texAlbedo_Shadow.Sample(smpAlbedo_Shadow_s, r1.zw).x;
  if (r1.y != 0) {
    o0.xyzw = float4(0,1,0,1);
    return;
  }
  r1.y = min(uFlag.x, w5.x);
  r1.w = cmp(0.000000 == r1.y);
  if (r1.w != 0) {
    r1.w = cmp(r0.w < 0.00100000005);
    if (r1.w != 0) discard;
    r1.w = cmp(v5.x >= 0);
    r2.xyz = -uFogColor.xyz + r0.xyz;
    r2.xyz = v5.xxx * r2.xyz + uFogColor.xyz;
    o0.xyz = r1.www ? r2.xyz : r0.xyz;
    o0.w = saturate(r0.w);  // added saturate
    return;
  }
  r2.xyzw = texAlbedo.Sample(smpAlbedo_s, v2.xy).xyzw;
  r3.xyz = cmp(float3(1,2,3) < r1.yyy);
  if (r3.x != 0) {
    r1.y = cmp(1.000000 == uBlendFlag.x);
    r4.xyzw = texAlbedo2.Sample(smpAlbedo2_s, w2.xy).xyzw;
    r1.w = uBlendFactor.x * r4.w;
    r5.xyz = r4.xyz * r1.www + r2.xyz;
    r5.w = uBlendFactor.x * r4.w + r2.w;
    r4.xyz = r4.xyz + -r2.xyz;
    r4.w = 1;
    r4.xyzw = r4.xyzw * r1.wwww + r2.xyzw;
    r2.xyzw = r1.yyyy ? r5.xyzw : r4.xyzw;
  }
  if (r3.y != 0) {
    r1.y = cmp(1.000000 == uBlendFlag.y);
    r4.xyzw = texAlbedo3.Sample(smpAlbedo3_s, v3.xy).xyzw;
    r1.w = uBlendFactor.y * r4.w;
    r5.xyz = r4.xyz * r1.www + r2.xyz;
    r5.w = uBlendFactor.y * r4.w + r2.w;
    r4.xyz = r4.xyz + -r2.xyz;
    r4.w = 1;
    r4.xyzw = r4.xyzw * r1.wwww + r2.xyzw;
    r2.xyzw = r1.yyyy ? r5.xyzw : r4.xyzw;
  }
  if (r3.z != 0) {
    r1.y = cmp(1.000000 == uBlendFlag.z);
    r3.xyzw = texAlbedo4.Sample(smpAlbedo4_s, v4.xy).xyzw;
    r1.w = uBlendFactor.z * r3.w;
    r4.xyz = r3.xyz * r1.www + r2.xyz;
    r4.w = uBlendFactor.z * r3.w + r2.w;
    r3.xyz = r3.xyz + -r2.xyz;
    r3.w = 1;
    r3.xyzw = r3.xyzw * r1.wwww + r2.xyzw;
    r2.xyzw = r1.yyyy ? r4.xyzw : r3.xyzw;
  }
  r0.xyzw = r2.xyzw * r0.xyzw;
  r1.y = cmp(uLIGHTTYPE.y != 0.000000);
  if (r1.y != 0) {
    r1.y = rsqrt(r1.x);
    r1.y = v1.y * r1.y;
    r1.z = 1 + -r1.z;
    r1.z = max(0, r1.z);
    r1.z = v6.w * r1.z;
    r1.y = cmp(r1.y < 0.100000001);
    r1.w = cmp(1.000000 == uLIGHTTYPE.z);
    r1.y = r1.w ? r1.y : 0;
    r1.y = r1.y ? 1 : r1.z;
    r2.xyz = float3(1,1,1) + -shadow_color.xyz;
    r3.xyz = float3(1,1,1) + -r2.xyz;
    r1.yzw = r1.yyy * r3.xyz + r2.xyz;
    r0.xyz = r1.yzw * r0.xyz;
  }
  r1.y = cmp(r0.w < 0.00100000005);
  if (r1.y != 0) discard;
  r1.y = cmp(0.000000 != uBitsFlag.y);
  r2.xyz = uEYE.xyz + -v6.xyz;
  r1.z = dot(r2.xyz, r2.xyz);
  r1.z = rsqrt(r1.z);
  r2.xyz = r2.xyz * r1.zzz;
  r1.x = rsqrt(r1.x);
  r3.xyz = v1.xyz * r1.xxx;
  r1.z = dot(r3.xyz, r2.xyz);
  r1.z = min(0, r1.z);
  r4.xyz = v1.xyz * r1.xxx + -r2.xyz;
  r1.xzw = -r1.zzz * r4.xyz + r2.xyz;
  r1.x = dot(r1.xzw, r3.xyz);
  r1.x = 1 + -r1.x;
  r1.x = min(uEdgeParam.y, r1.x);
  r1.x = r1.x / uEdgeParam.y;
  r1.x = log2(r1.x);
  r1.x = uEdgeParam.z * r1.x;
  r1.x = exp2(r1.x);
  r1.x = saturate(uEdgeParam.x * r1.x);
  r1.xzw = uEdgeColor.xyz * r1.xxx + r0.xyz;
  r0.xyz = r1.yyy ? r1.xzw : r0.xyz;
  r1.x = cmp(v5.x >= 0);
  r1.yzw = -uFogColor.xyz + r0.xyz;
  r1.yzw = v5.xxx * r1.yzw + uFogColor.xyz;
  o0.xyz = r1.xxx ? r1.yzw : r0.xyz;
  o0.w = saturate(r0.w);  // added saturate
  return;
}
