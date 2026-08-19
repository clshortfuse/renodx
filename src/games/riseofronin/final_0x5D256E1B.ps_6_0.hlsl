#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float4 $Globals_000 : packoffset(c000.x);
  float4 $Globals_016 : packoffset(c001.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(noperspective float4 SV_Position: SV_Position,
            linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _8 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 color = _8.rgb;

    color.rgb = renodx::color::bt2020::from::BT709(color.rgb);
    color.rgb = renodx::draw::SwapChainPass(color.rgb);
    SV_Target.rgb = color.rgb;
    SV_Target.a = 1.f;
    return SV_Target;
  }

  float _15 = mad(0.043299999088048935f, _8.z,
                  mad(0.3292999863624573f, _8.y, (_8.x * 0.6273999810218811f)));
  float _18 =
      mad(0.01140000019222498f, _8.z,
          mad(0.9194999933242798f, _8.y, (_8.x * 0.06909999996423721f)));
  float _21 =
      mad(0.8956000208854675f, _8.z,
          mad(0.08799999952316284f, _8.y, (_8.x * 0.01640000008046627f)));
  float _22 = dot(
      float3(_15, _18, _21),
      float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f));
  float _31 = (($Globals_000.y) * (_15 - _22)) + _22;
  float _32 = (($Globals_000.y) * (_18 - _22)) + _22;
  float _33 = (($Globals_000.y) * (_21 - _22)) + _22;
  float4 _43 = t1.Sample(
      s1, float2(((_31 * ($Globals_000.z)) + ($Globals_000.w)), 0.5f));
  float _45 = select((_31 <= 1.0f), _43.x, _31);
  float4 _47 = t1.Sample(
      s1, float2(((_32 * ($Globals_000.z)) + ($Globals_000.w)), 0.5f));
  float _49 = select((_32 <= 1.0f), _47.y, _32);
  float4 _51 = t1.Sample(
      s1, float2(((_33 * ($Globals_000.z)) + ($Globals_000.w)), 0.5f));
  float _53 = select((_33 <= 1.0f), _51.z, _33);
  float _71 = ($Globals_000.x) + -1.0f;
  float _99 = exp2(
      log2(((_45 * 0.009999999776482582f) * exp2(_71 * log2(saturate(_45 / (max((_45 + -0.5f), 0.0f) + 1.0f))))) * ($Globals_016.x)) * 0.1593019962310791f);
  float _100 =
      exp2(log2(((_49 * 0.009999999776482582f) * exp2(log2(saturate(_49 / (max((_49 + -0.5f), 0.0f) + 1.0f))) * _71)) * ($Globals_016.x)) * 0.1593019962310791f);
  float _101 =
      exp2(log2(((_53 * 0.009999999776482582f) * exp2(log2(saturate(_53 / (max((_53 + -0.5f), 0.0f) + 1.0f))) * _71)) * ($Globals_016.x)) * 0.1593019962310791f);
  SV_Target.x = exp2(log2(((_99 * 18.851558685302734f) + 0.8359370231628418f) / ((_99 * 18.6875f) + 1.0f)) * 78.84375762939453f);
  SV_Target.y = exp2(log2(((_100 * 18.851558685302734f) + 0.8359370231628418f) / ((_100 * 18.6875f) + 1.0f)) * 78.84375762939453f);
  SV_Target.z = exp2(log2(((_101 * 18.851558685302734f) + 0.8359370231628418f) / ((_101 * 18.6875f) + 1.0f)) * 78.84375762939453f);
  SV_Target.w = (_8.w * 0.009999999776482582f);
  return SV_Target;
}
