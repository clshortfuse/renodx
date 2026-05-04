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
  float _9 = max(_haloParams.z, 0.009999999776482582f);
  float _12 = (TEXCOORD.x * 2.0f) + -1.0f;
  float _13 = (TEXCOORD.y * 2.0f) + -1.0f;
  float _24 = tan(((atan(1.0f / _9) * _9) * sqrt((_13 * _13) + (_12 * _12))) / _9) * _9;
  float _26 = atan(_13 / _12);
  bool _29 = (_12 < 0.0f);
  bool _30 = (_12 == 0.0f);
  bool _31 = (_13 >= 0.0f);
  bool _32 = (_13 < 0.0f);
  float _40 = select(((_30) & (_31)), 1.5707963705062866f, select(((_30) & (_32)), -1.5707963705062866f, select(((_29) & (_32)), (_26 + -3.1415927410125732f), select(((_29) & (_31)), (_26 + 3.1415927410125732f), _26))));
  float _47 = ((cos(_40) * _24) + 1.0f) * 0.5f;
  float _48 = ((sin(_40) * _24) + 1.0f) * 0.5f;
  float _49 = 0.5f - TEXCOORD.x;
  float _50 = 0.5f - TEXCOORD.y;
  float _54 = rsqrt(dot(float2(_49, _50), float2(_49, _50))) * _haloParams.y;
  float _55 = _54 * _49;
  float _56 = _54 * _50;
  float _57 = TEXCOORD.x + -0.5f;
  float _58 = TEXCOORD.y + -0.5f;
  float _67 = saturate((saturate(sqrt((_58 * _58) + (_57 * _57)) * 2.0f) + -0.5f) * 2.0f);
  float _70 = _47 + -0.5f;
  float _71 = _48 + -0.5f;
  float _73 = _haloParams.w + 1.0f;
  float _76 = _55 + 0.5f;
  float _78 = _56 + 0.5f;
  float _82 = 1.0f - _haloParams.w;
  float3 _89 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((_76 + (_70 * _73)), (_78 + (_71 * _73))), 0.0f);
  float3 _91 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((_55 + _47), (_56 + _48)), 0.0f);
  float3 _93 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2((_76 + (_70 * _82)), (_78 + (_71 * _82))), 0.0f);
  float _99 = ((_67 * _67) * (_haloParams.x * 0.6000000238418579f)) * (3.0f - (_67 * 2.0f));
  SV_Target.x = (_89.x * _99);
  SV_Target.y = (_91.y * _99);
  SV_Target.z = (_93.z * _99);
  return SV_Target;
}
