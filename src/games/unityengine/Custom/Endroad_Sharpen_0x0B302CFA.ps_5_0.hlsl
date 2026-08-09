#include "../common.hlsl"

cbuffer _Globals : register(b0){
  float4 unity_Lightmap_HDR : packoffset(c0);
  float4 unity_DynamicLightmap_HDR : packoffset(c1);
  float4 _DkGlobals : packoffset(c2);
  float4x4 _DkMatrix_LastPj : packoffset(c3);
  float4x4 _DkMatrix_LastPnj : packoffset(c7);
  float4x4 _DkMatrix_LastVPj : packoffset(c11);
  float4x4 _DkMatrix_LastVPnj : packoffset(c15);
  float4x4 _DkMatrix_LastV : packoffset(c19);
  float4x4 _DkMatrix_P : packoffset(c23);
  float4x4 _DkMatrix_Pj : packoffset(c27);
  float4x4 _DkMatrix_Pnj : packoffset(c31);
  float4x4 _DkMatrix_VP : packoffset(c35);
  float4x4 _DkMatrix_VPj : packoffset(c39);
  float4x4 _DkMatrix_VPnj : packoffset(c43);
  float4x4 _DkMatrix_V_inv : packoffset(c47);
  float4x4 _DkMatrix_V : packoffset(c51);
  float4 _DkRenderScreenParams : packoffset(c55);
  float4 _DkCameraScreenParams : packoffset(c56);
  float _DkVertexLitThreshold : packoffset(c57);
  float _DkVertexLitTransition : packoffset(c57.y);
  float4 _DkCameraPosition : packoffset(c58);
  float4 _DkCameraForward : packoffset(c59);
  float4 _DkCameraRight : packoffset(c60);
  float4 _DkCameraProjectionCoef : packoffset(c61);
  float4 _DkApplicationSettings : packoffset(c62);
  float _DkPlayerDistance : packoffset(c63);
  float4 _DkPlayerPosition : packoffset(c64);
  float _DkEnableFog : packoffset(c65);
  float _DkEnableFogDynamicLighting : packoffset(c65.y);
  float _DkEnableGI : packoffset(c65.z);
  float4 _DkUICanvasSize : packoffset(c66);
  float4 _DkUICanvasResolution : packoffset(c67);
  float _DkDynamicObject : packoffset(c68);
  float4 _Jitter : packoffset(c69);
  int _DkUnlitMode : packoffset(c70);
  float _DkLODBias : packoffset(c70.y);
  float _GammaCorrection : packoffset(c70.z);
  float _Sharpen : packoffset(c70.w);
}

SamplerState _DkColorPyramid_s : register(s0);
Texture2D<float4> _DkColorPyramid : register(t0);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(1,-1) + float2(0,1);
  r1.xyzw = _DkRenderScreenParams.zwzw * float4(-1,0,1,0) + r0.xyxy;
  r2.xyzw = _DkColorPyramid.SampleLevel(_DkColorPyramid_s, r1.xy, 0).xyzw;
  r1.xyzw = _DkColorPyramid.SampleLevel(_DkColorPyramid_s, r1.zw, 0).xyzw;
  r0.z = _GammaCorrection * 0.8 + 1;
  r0.z = max(0.001, r0.z);
  r0.z = 1 / r0.z;
  r0.z = min(1, r0.z);
  if(injectedData.toneMapType == 0.f){
  r1.xyzw = saturate(r1.xyzw);
  r2.xyzw = saturate(r2.xyzw);
  r1.xyzw = log2(r1.xyzw);
  r2.xyzw = log2(r2.xyzw);
  r2.xyzw = r0.zzzz * r2.xyzw;
  r2.xyzw = exp2(r2.xyzw);
  r1.xyzw = r0.zzzz * r1.xyzw;
  r1.xyzw = exp2(r1.xyzw);
  } else if(injectedData.toneMapType >= 2.f) {
    r1.w = saturate(r1.w);
    r2.w = saturate(r2.w);
    r1.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r2.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r1.xyzw = pow(abs(r1.xyzw), r0.z);
    r2.xyzw = pow(abs(r2.xyzw), r0.z);
  } else {
    r1.w = saturate(r1.w);
    r2.w = saturate(r2.w);
    r1.xyz /= 50.f;
    r2.xyz /= 50.f;
    r1.xyzw = pow(abs(r1.xyzw), r0.z);
    r2.xyzw = pow(abs(r2.xyzw), r0.z);
  }
  r1.xyzw = r2.xyzw + r1.xyzw;
  r2.xyzw = _DkRenderScreenParams.zwzw * float4(0,-1,0,1) + r0.xyxy;
  r3.xyzw = _DkColorPyramid.SampleLevel(_DkColorPyramid_s, r0.xy, 0).xyzw;
  r4.xyzw = _DkColorPyramid.SampleLevel(_DkColorPyramid_s, r2.xy, 0).xyzw;
  r2.xyzw = _DkColorPyramid.SampleLevel(_DkColorPyramid_s, r2.zw, 0).xyzw;
  if(injectedData.toneMapType == 0.f){
  r3.xyzw = saturate(r3.xyzw);
  r3.xyzw = log2(r3.xyzw);
  r3.xyzw = r3.xyzw * r0.zzzz;
  r3.xyzw = exp2(r3.xyzw);
  r2.xyzw = saturate(r2.xyzw);
  r2.xyzw = log2(r2.xyzw);
  r2.xyzw = r2.xyzw * r0.zzzz;
  r2.xyzw = exp2(r2.xyzw);
  r4.xyzw = saturate(r4.xyzw);
  r4.xyzw = log2(r4.xyzw);
  r0.xyzw = r4.xyzw * r0.zzzz;
  r0.xyzw = exp2(r0.xyzw);
  } else if(injectedData.toneMapType >= 2.f) {
    r3.w = saturate(r3.w);
    r2.w = saturate(r2.w);
    r0.w = saturate(r4.w);
    r3.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r2.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r4.xyz /= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
    r3.xyzw = renodx::math::SignPow(r3.xyzw, r0.z);
    r2.xyzw = pow(abs(r2.xyzw), r0.z);
    r0.xyzw = pow(abs(r4.xyzw), r0.z);
  } else {
    r3.w = saturate(r3.w);
    r2.w = saturate(r2.w);
    r0.w = saturate(r4.w);
    r3.xyz /= 50.f;
    r2.xyz /= 50.f;
    r4.xyz /= 50.f;
    r3.xyzw = renodx::math::SignPow(r3.xyzw, r0.z);
    r2.xyzw = pow(abs(r2.xyzw), r0.z);
    r0.xyzw = pow(abs(r4.xyzw), r0.z);
  }
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r2.xyzw;
  if(injectedData.toneMapType == 0.f){
  r0.xyzw = r3.xyzw * float4(5,5,5,5) + -r0.xyzw;
  } else {
    r0.xyzw = sign(r3.xyzw) * max(0.f, (abs(r3.xyzw) * 5.f - r0.xyzw));
  }
  r0.xyzw = r0.xyzw + -r3.xyzw;
  o0.xyzw = _Sharpen * r0.xyzw + r3.xyzw;
  o0.w = saturate(o0.w);
  if(injectedData.toneMapType == 0.f){
    o0.xyz = saturate(o0.xyz);
  } else if (injectedData.toneMapType >= 2.f){
    o0.xyz *= (injectedData.toneMapPeakNits / injectedData.toneMapGameNits);
  } else {
    o0.xyz *= 50.f;
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}