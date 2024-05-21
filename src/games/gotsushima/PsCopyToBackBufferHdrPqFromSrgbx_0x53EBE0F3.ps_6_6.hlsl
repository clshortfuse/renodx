cbuffer RootSrtCbv : register(b14, space0) {
  int bufferIndex : packoffset(c0);
  int unknown1 : packoffset(c0);
}

ByteAddressBuffer bufferT1 : register(t1, space1);
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

  float2 _64;

  uint _50 = bufferIndex;  // _49.x;
  uint index32 = _50 + 32u;
  uint _56 = (_50 + 64u);
  _64 = bufferT1.Load<float2>(_56);

  SV_Target.x = 0.0f;
  SV_Target.y = 0.0f;
  SV_Target.z = 0.0f;
  SV_Target.w = 0.0f;

  uint index96 = _50 + 96u;

  uint value00 = bufferT1.Load<uint>(_50);

  Texture2D<float4> res0 = ResourceDescriptorHeap[value00];

  // float4 _82 = _9[bufferT1.Load(_50).x].Sample(_22, float2(TEXCOORD.x, TEXCOORD.y));

  float4 _82 = res0.Sample(_22, float2(TEXCOORD.x, TEXCOORD.y));
  float3 srgbInputColor = _82.rgb;

  float3 scaledColor = (((((((((bufferT1.Load<float>(_50 + 112u)
                                * _82.rgb)
                               + bufferT1.Load<float>(_50 + 108u))
                              * _82.rgb)
                             + bufferT1.Load<float>(_50 + 104u))
                            * _82.rgb)
                           + bufferT1.Load<float>(_50 + 100u))
                          * _82.rgb)
                         + bufferT1.Load<float>(index96))
                        * _82.rgb)
                     / ((((((bufferT1.Load<float>(_50 + 124u) * _82.rgb)
                            + bufferT1.Load<float>(_50 + 120u))
                           * _82.rgb)
                          + bufferT1.Load<float>(_50 + 116u))
                         * _82.rgb)
                        + 1.0f);

  float3 bt2020Color = mul(
    // clang-format off
    float3x3(
      0.627403736114501953125f, 0.329281747341156005859375f, 0.043313510715961456298828125f,
      0.06909702718257904052734375f, 0.9195404052734375f, 0.01136207766830921173095703125f,
      0.01639144308865070343017578125f, 0.088013507425785064697265625f, 0.895595014095306396484375f
    ),
    // clang-format on
    scaledColor
  );

  float3 sqrtOfBt2020 = sqrt(bt2020Color);

  float3 pqColor = (((((((sqrtOfBt2020 * 0.16258220374584197998046875f) + 8.06964778900146484375f) * sqrtOfBt2020) + 3.5209205150604248046875f) * sqrtOfBt2020) + 0.000487781013362109661102294921875f) / ((((sqrtOfBt2020 * 7.96455097198486328125f) + 10.5308475494384765625f) * sqrtOfBt2020) + 1.0f));

  Texture2D<float> res1 = ResourceDescriptorHeap[bufferT1.Load<uint>(index32)];
  // float _260 = (_9[bufferT1.Load((_50 + 32u)).x].SampleLevel(_23, float2((_64.x * TEXCOORD.x) + 0.5f, (_64.y * TEXCOORD.y) + 0.5f), 0.0f).x * 0.000977517105638980865478515625f) + (-0.0004887585528194904327392578125f);

  float4 _260 = (res1.SampleLevel(_23, float2((_64.x * TEXCOORD.x) + 0.5f, (_64.y * TEXCOORD.y) + 0.5f), 0.0f).x * 0.000977517105638980865478515625f) + (-0.0004887585528194904327392578125f);

  SV_Target.xyz = _260.rgb + pqColor;
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
