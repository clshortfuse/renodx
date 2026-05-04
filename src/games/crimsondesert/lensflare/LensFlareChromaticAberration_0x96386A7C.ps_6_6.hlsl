Texture2D<float3> __3__36__0__0__g_sceneColor : register(t15, space36);

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _textureSizeAndInvSize : packoffset(c000.x);
  float4 _ghostsParams : packoffset(c001.x);
  float4 _ghostsMultiplyColor : packoffset(c002.x);
  float4 _haloParams : packoffset(c003.x);
  float4 _glareBladeParams : packoffset(c004.x);
  uint2 _tileXY : packoffset(c005.x);
  float2 _bufferRatio : packoffset(c005.z);
  float _lensFlareColorScale : packoffset(c006.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

float3 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float3 SV_Target;
  float _7 = TEXCOORD.x + -0.5f;
  float _8 = TEXCOORD.y + -0.5f;
  float _11 = _ghostsParams.z + 1.0f;
  float _16 = 1.0f - _ghostsParams.z;
  float3 _23 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((_11 * _7) + 0.5f), ((_11 * _8) + 0.5f)), 0.0f);
  float3 _25 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float3 _27 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(((_16 * _7) + 0.5f), ((_16 * _8) + 0.5f)), 0.0f);
  float _29 = 0.5f - TEXCOORD.x;
  float _32 = _ghostsParams.w * (0.5f - TEXCOORD.y);
  float _40 = saturate(saturate(sqrt((_32 * _32) + (_29 * _29)) + -0.009999999776482582f) * 20.0f);
  SV_Target.x = (_40 * _23.x);
  SV_Target.y = (_40 * _25.y);
  SV_Target.z = (_40 * _27.z);
  return SV_Target;
}
