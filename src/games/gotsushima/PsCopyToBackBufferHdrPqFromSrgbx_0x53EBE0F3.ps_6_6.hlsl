cbuffer RootSrtCbv : register(b14, space0) {
  int bufferIndex : packoffset(c0);
  int unknown1 : packoffset(c0);
}

ByteAddressBuffer _13 : register(t1, space1);
SamplerState _22 : register(s12, space0);
SamplerState _23 : register(s1, space0);

static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

float3 pqFromLinear(float3 linearColor) {
  static const float m1 = 0.1593017578125f;
  static const float m2 = 78.84375f;
  static const float c1 = 0.8359375f;
  static const float c2 = 18.8515625f;
  static const float c3 = 18.6875f;

  float3 yM1 = pow(linearColor, m1);
  return pow((c1 + c2 * yM1) / (1.f + c3 * yM1), m2);
}

void frag_main() {


  SV_Target.x = 0.0f;
  SV_Target.y = 0.0f;
  SV_Target.z = 0.0f;
  SV_Target.w = 0.0f;
  // uint2 _49 = _19_m0[0u];
  uint _50 = bufferIndex;  // _49.x;
  uint _56 = (_50 + 64u);
  
  float2 _64 = asfloat(uint2(_13.Load(_56).x, _13.Load(_56 + 1u).x));
  SV_Target.x = 0.0f;
  SV_Target.y = 0.0f;
  SV_Target.z = 0.0f;
  SV_Target.w = 0.0f;
  Texture2D<float4> res0 = ResourceDescriptorHeap[_13.Load(_50).x];
  
  // float4 _82 = _9[_13.Load(_50).x].Sample(_22, float2(TEXCOORD.x, TEXCOORD.y));
  
  float4 _82 = res0.Sample(_22, float2(TEXCOORD.x, TEXCOORD.y));
  float3 srgbInputColor = _82.rgb;

  float _84 = _82.x;
  float _85 = _82.y;
  float _86 = _82.z;
  float _92 = asfloat(_13.Load((_50 + 112u)).x);
  float _101 = asfloat(_13.Load((_50 + 108u)).x);
  float _113 = asfloat(_13.Load((_50 + 104u)).x);
  float _125 = asfloat(_13.Load((_50 + 100u)).x);
  float _135 = asfloat(_13.Load((_50 + 96u)).x);
  float _147 = asfloat(_13.Load((_50 + 124u)).x);
  float _156 = asfloat(_13.Load((_50 + 120u)).x);
  float _168 = asfloat(_13.Load((_50 + 116u)).x);

  float _179 = (((((((((_92 * _84) + _101) * _84) + _113) * _84) + _125) * _84) + _135) * _84) / ((((((_147 * _84) + _156) * _84) + _168) * _84) + 1.0f);
  float _180 = (((((((((_92 * _85) + _101) * _85) + _113) * _85) + _125) * _85) + _135) * _85) / ((((((_147 * _85) + _156) * _85) + _168) * _85) + 1.0f);
  float _181 = (((((((((_92 * _86) + _101) * _86) + _113) * _86) + _125) * _86) + _135) * _86) / ((((((_147 * _86) + _156) * _86) + _168) * _86) + 1.0f);
  float _201 = sqrt(mad(
    _181, 0.043313510715961456298828125f, mad(_180, 0.329281747341156005859375f, _179 * 0.627403736114501953125f)
  ));
  float _202 = sqrt(mad(
    _181, 0.01136207766830921173095703125f, mad(_180, 0.9195404052734375f, _179 * 0.06909702718257904052734375f)
  ));
  float _203 = sqrt(mad(_181, 0.895595014095306396484375f, mad(_180, 0.088013507425785064697265625f, _179 * 0.01639144308865070343017578125f)));
  Texture2D<float4> res1 = ResourceDescriptorHeap[_13.Load((_50 + 32u)).x];
  // float _260 = (_9[_13.Load((_50 + 32u)).x].SampleLevel(_23, float2((_64.x * TEXCOORD.x) + 0.5f, (_64.y * TEXCOORD.y) + 0.5f), 0.0f).x * 0.000977517105638980865478515625f) + (-0.0004887585528194904327392578125f);
  float4 _260 = (res1.SampleLevel(_23, float2((_64.x * TEXCOORD.x) + 0.5f, (_64.y * TEXCOORD.y) + 0.5f), 0.0f).x * 0.000977517105638980865478515625f) + (-0.0004887585528194904327392578125f);

  SV_Target.x = _260 + (((((((_201 * 0.16258220374584197998046875f) + 8.06964778900146484375f) * _201) + 3.5209205150604248046875f) * _201) + 0.000487781013362109661102294921875f) / ((((_201 * 7.96455097198486328125f) + 10.5308475494384765625f) * _201) + 1.0f));
  SV_Target.y = _260 + (((((((_202 * 0.16258220374584197998046875f) + 8.06964778900146484375f) * _202) + 3.5209205150604248046875f) * _202) + 0.000487781013362109661102294921875f) / ((((_202 * 7.96455097198486328125f) + 10.5308475494384765625f) * _202) + 1.0f));
  SV_Target.z = _260 + (((((((_203 * 0.16258220374584197998046875f) + 8.06964778900146484375f) * _203) + 3.5209205150604248046875f) * _203) + 0.000487781013362109661102294921875f) / ((((_203 * 7.96455097198486328125f) + 10.5308475494384765625f) * _203) + 1.0f));
  SV_Target.w = 1.0f;

}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
