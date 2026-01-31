#include "./common.hlsl"

Texture2D<float4> sScreen : register(t0);

Texture2D<float4> sToneCurv : register(t1);

cbuffer Globals : register(b0) {
  float4 vConfigParam : packoffset(c000.x);
  float4 vOETFParam : packoffset(c001.x);
};

SamplerState __smpsScreen : register(s0);

SamplerState __smpsToneCurv : register(s1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float4 _8 = sScreen.Sample(__smpsScreen, float2(TEXCOORD.x, TEXCOORD.y));
  SV_Target = renodx::draw::SwapChainPass(_8);
  return SV_Target;
  float _15 = mad(0.043299999088048935f, _8.z, mad(0.3292999863624573f, _8.y, (_8.x * 0.6273999810218811f)));
  float _18 = mad(0.01140000019222498f, _8.z, mad(0.9194999933242798f, _8.y, (_8.x * 0.06909999996423721f)));
  float _21 = mad(0.8956000208854675f, _8.z, mad(0.08799999952316284f, _8.y, (_8.x * 0.01640000008046627f)));
  float _22 = dot(float3(_15, _18, _21), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f));
  float _31 = (vConfigParam.y * (_15 - _22)) + _22;
  float _32 = (vConfigParam.y * (_18 - _22)) + _22;
  float _33 = (vConfigParam.y * (_21 - _22)) + _22;
  float4 _43 = sToneCurv.Sample(__smpsToneCurv, float2(((_31 * vConfigParam.z) + vConfigParam.w), 0.5f));
  float _45 = renodx::math::Select((_31 <= 1.0f), _43.x, _31);
  float4 _47 = sToneCurv.Sample(__smpsToneCurv, float2(((_32 * vConfigParam.z) + vConfigParam.w), 0.5f));
  float _49 = renodx::math::Select((_32 <= 1.0f), _47.y, _32);
  float4 _51 = sToneCurv.Sample(__smpsToneCurv, float2(((_33 * vConfigParam.z) + vConfigParam.w), 0.5f));
  float _53 = renodx::math::Select((_33 <= 1.0f), _51.z, _33);
  float _71 = vConfigParam.x + -1.0f;
  float _99 = exp2(log2(((_45 * 0.009999999776482582f) * exp2(_71 * log2(saturate(_45 / (max((_45 + -0.5f), 0.0f) + 1.0f))))) * vOETFParam.x) * 0.1593019962310791f);
  float _100 = exp2(log2(((_49 * 0.009999999776482582f) * exp2(log2(saturate(_49 / (max((_49 + -0.5f), 0.0f) + 1.0f))) * _71)) * vOETFParam.x) * 0.1593019962310791f);
  float _101 = exp2(log2(((_53 * 0.009999999776482582f) * exp2(log2(saturate(_53 / (max((_53 + -0.5f), 0.0f) + 1.0f))) * _71)) * vOETFParam.x) * 0.1593019962310791f);
  SV_Target.x = exp2(log2(((_99 * 18.851558685302734f) + 0.8359370231628418f) / ((_99 * 18.6875f) + 1.0f)) * 78.84375762939453f);
  SV_Target.y = exp2(log2(((_100 * 18.851558685302734f) + 0.8359370231628418f) / ((_100 * 18.6875f) + 1.0f)) * 78.84375762939453f);
  SV_Target.z = exp2(log2(((_101 * 18.851558685302734f) + 0.8359370231628418f) / ((_101 * 18.6875f) + 1.0f)) * 78.84375762939453f);
  SV_Target.w = (_8.w * 0.009999999776482582f);
  return SV_Target;
}
