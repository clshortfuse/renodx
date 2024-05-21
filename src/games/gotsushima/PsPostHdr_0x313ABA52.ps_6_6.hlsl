cbuffer RootSrtCbv : register(b14, space0) {
  int bufferIndex : packoffset(c0);
  int unknown1 : packoffset(c0);
}

// cbuffer _24_26 : register(b14, space0) { float4 _26_m0[1] : packoffset(c0); };

// Texture2D<float4> _9[] : register(t0, space0);
// Texture3D<float4> _13[] : register(t0, space0);
// Buffer<uint4> _18[] : register(t0, space0);
ByteAddressBuffer bufferT1 : register(t1, space1);
SamplerState sampler12 : register(s12, space0);
SamplerState sampler0 : register(s0, space0);
SamplerState sampler1 : register(s1, space0);

static float2 TEXCOORD;
static float4 SV_Target;
static float SV_Target_1;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
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
  SV_Target_1 = 0.0f;

  // uint4 _58 = asuint(_26_m0[0u]);
  // uint _59 = _58.x;
  uint _59 = bufferIndex;  // _49.x;

  uint res00Index = _59;
  uint res64Index = _59 + 64u;
  uint res96Index = _59 + 96u;
  uint res128Index = _59 + 128u;
  uint res160Index = _59 + 160u;
  uint res192Index = _59 + 192u;
  uint res224Index = _59 + 224u;
  uint res256Index = _59 + 256u;

  float4 _90 = bufferT1.Load<float4>(_59 + 272u);
  float4 _110 = bufferT1.Load<float4>(_59 + 288u);
  float _615a = bufferT1.Load<float>((_59 + 304u));

  float4 _136 = bufferT1.Load<float4>(_59 + 308u);
  float4 _156 = bufferT1.Load<float4>(_59 + 324u);
  float _697a = bufferT1.Load<float>(_59 + 340u);
  uint _640a = _59 + 344u;

  float _174 = bufferT1.Load<float>(_59 + 368u);
  float _180 = bufferT1.Load<float>(_59 + 376u);
  float _186 = bufferT1.Load<float>(_59 + 380u);
  float _192 = bufferT1.Load<float>(_59 + 384u);

  float2 _203 = bufferT1.Load<float2>(_59 + 388u).xy;

  uint index396 = _59 + 396u;

  float _739a = bufferT1.Load<float>(_59 + 404u);

  float value408 = bufferT1.Load<float>(_59 + 408u);

  uint value412 = bufferT1.Load<uint>(_59 + 412u);
  float value416 = bufferT1.Load<float>(_59 + 416u);
  float value420 = bufferT1.Load<float>(_59 + 420u);
  float value424 = bufferT1.Load<float>(_59 + 424u);

  float2 _252 = bufferT1.Load<float2>(_59 + 428u);

  float value444 = bufferT1.Load<float>(_59 + 444u);
  float value448 = bufferT1.Load<float>(_59 + 448u);
  float value452 = bufferT1.Load<float>(_59 + 452u);
  uint value456 = bufferT1.Load<uint>(_59 + 456u);

  float _281 = bufferT1.Load<float>(_59 + 460u);
  float _287 = bufferT1.Load<float>(_59 + 464u);
  float _293 = bufferT1.Load<float>(_59 + 468u);
  float4 _309 = bufferT1.Load<float4>(_59 + 472u);

  float4 _329 = bufferT1.Load<float4>(_59 + 488u);

  float value504 = bufferT1.Load<float>(_59 + 504u);
  float value508 = bufferT1.Load<float>(_59 + 508u);
  float value512 = bufferT1.Load<float>(_59 + 512u);
  float value516 = bufferT1.Load<float>(_59 + 516u);
  float value524 = bufferT1.Load<float>(_59 + 524u);
  float value528 = bufferT1.Load<float>(_59 + 528u);
  float value532 = bufferT1.Load<float>(_59 + 532u);
  float value536 = bufferT1.Load<float>(_59 + 536u);
  float value540 = bufferT1.Load<float>(_59 + 540u);
  float value544 = bufferT1.Load<float>(_59 + 544u);

  float2 _403 = bufferT1.Load<float2>(_59 + 548u);
  float2 _415 = bufferT1.Load<float2>(_59 + 556u);
  float2 _427 = bufferT1.Load<float2>(_59 + 564u);

  SV_Target_1 = 0.0f;

  // float4 _439 = _9[bufferT1.Load((_59 + 64u)).x].Sample(sampler12, float2(TEXCOORD.x, TEXCOORD.y));
  Texture2D<float4> res64 = ResourceDescriptorHeap[bufferT1.Load((res64Index)).x];
  float4 _439 = res64.Sample(sampler12, float2(TEXCOORD.x, TEXCOORD.y));

  float _445a = _439.x * _287;
  float _446a = _439.y * _287;

  float _445 = _445a + TEXCOORD.x;
  float _446 = _446a + TEXCOORD.y;

  // float4 _454 = _9[bufferT1.Load(_59).x].Sample(sampler12, float2(_445, _446));
  Texture2D<float4> res00 = ResourceDescriptorHeap[bufferT1.Load((res00Index)).x];
  float4 _454 = res00.Sample(sampler12, float2(_445, _446));

  float _460 = max(0.0f, _454.x);
  float _461 = max(0.0f, _454.y);
  float _462 = max(0.0f, _454.z);
  float _465;
  float _467;
  float _469;
  if (value456 == 0u) {
    _465 = _460;
    _467 = _461;
    _469 = _462;
  } else {
    uint index436 = _59 + 436u;
    float _548 = TEXCOORD.y - _252.y;
    float _549 = value448 * (TEXCOORD.x - _252.x);
    float _570 = exp2(log2(saturate((sqrt((_549 * _549) + (_548 * _548)) * bufferT1.Load<float>(index436)) + bufferT1.Load<float>(_59 + 440u))) * value452) * value444;
    _465 = _570 + _460;
    _467 = _570 + _461;
    _469 = _570 + _462;
  }

  float _471 = dot(float3(_465, _467, _469), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _478 = log2(_471);

  float _479 = _446 * value532;
  float _515a = _478 * value536;
  float _515b = _515a + value540;
  float _515c = saturate(_515b);

  uint value192 = bufferT1.Load<uint>(res192Index);

  Texture3D<float> res192 = ResourceDescriptorHeap[value192];

  // float4 _501 = _9[bufferT1.Load((_59 + 224u)).x].SampleLevel(sampler12, float2(_445, _479), 0.0f);

  float _515sample = res192.SampleLevel(sampler12, float3(_445, _479, _515c), 0.0f);

  uint value224 = bufferT1.Load<uint>(res224Index);
  Texture2D<float> res224 = ResourceDescriptorHeap[value224];
  float4 _501 = res224.SampleLevel(sampler12, float2(_445, _479), 0.0f);
  float _503 = _501.x;
  float _515e = (((_515sample - _503) * value544) + _503);

  uint value256 = bufferT1.Load<uint>(res256Index);

  // float _514 = asfloat(_18[bufferT1.Load((_59 + 256u)).x].Load(0u).x);
  StructuredBuffer<float> res256 = ResourceDescriptorHeap[value256];
  float _514 = res256.Load(0u).x;

  // float _515 = (((_13[bufferT1.Load((_59 + 192u)).x].SampleLevel(sampler12, float3(_445, _479, clamp((_478 * asfloat(bufferT1.Load((_59 + 536u)).x)) + asfloat(bufferT1.Load((_59 + 540u)).x), 0.0f, 1.0f)), 0.0f).x - _503) * asfloat(bufferT1.Load((_59 + 544u)).x)) + _503) + _514;

  float _515 = _515e + _514;

  float _527 = (((_478 * value528) + value516) + (_514 * value524)) + (((_515 * value504) + log2(exp2(_515 * value508) + 1.0f)) * value512);
  float _528 = exp2(_527);
  float _571;
  float _573;
  float _575;
  if (value412 == 0u) {
    _571 = _180;
    _573 = _186;
    _575 = _192;
  } else {
    float _738 = TEXCOORD.y - _203.y;
    //float _739 = (TEXCOORD.x - _203.x) * asfloat(bufferT1.Load((_59 + 404u)).x);
    float _739 = (TEXCOORD.x - _203.x) * _739a;
    float _759 = exp2(log2(saturate((asfloat(bufferT1.Load((index396)).x) * sqrt((_739 * _739) + (_738 * _738))) + asfloat(bufferT1.Load((_59 + 400u)).x))) * value408);
    _571 = (_759 * (value416 - _180)) + _180;
    _573 = (_759 * (value420 - _186)) + _186;
    _575 = (_759 * (value424 - _192)) + _192;
  }
  float _577 = (_527 + _478) - _571;
  float _581 = exp2(((_577 < 0.0f) ? _573 : _575) * _577);
  float _588 = _329.x * (TEXCOORD.x + (-0.5f));
  float _589 = _329.y * (TEXCOORD.y + (-0.5f));
  float _596 = saturate((sqrt((_588 * _588) + (_589 * _589)) * _329.z) + _329.w);
  float _600 = ((_596 - (_596 * _596)) * _596) + _596;
  float _604 = max(0.0f, (((((_471 - _465) * _281) + _465) * _528) * _581) * _600);
  float _605 = max(0.0f, (((((_471 - _467) * _281) + _467) * _528) * _581) * _600);
  float _606 = max(0.0f, (((((_471 - _469) * _281) + _469) * _528) * _581) * _600);
  float _609 = mad(_606, _110.z, mad(_605, _90.w, _604 * _90.x));
  float _612 = mad(_606, _110.w, mad(_605, _110.x, _604 * _90.y));
  // float _615 = mad(_606, asfloat(bufferT1.Load((_59 + 304u)).x), mad(_605, _110.y, _604 * _90.z));
  float _615 = mad(_606, _615a, mad(_605, _110.y, _604 * _90.z));
  float _621 = asfloat(bufferT1.Load((_59 + 352u)).x);
  float _630 = asfloat(bufferT1.Load((_59 + 348u)).x);
  float _640 = bufferT1.Load<float>(_640a);
  float _652 = asfloat(bufferT1.Load((_59 + 364u)).x);
  float _661 = asfloat(bufferT1.Load((_59 + 360u)).x);
  float _673 = asfloat(bufferT1.Load((_59 + 356u)).x);
  float _683 = (((((_621 * _609) + _630) * _609) + _640) * _609) / ((((((_652 * _609) + _661) * _609) + _673) * _609) + 1.0f);
  float _684 = (((((_621 * _612) + _630) * _612) + _640) * _612) / ((((((_652 * _612) + _661) * _612) + _673) * _612) + 1.0f);
  float _685 = (((((_621 * _615) + _630) * _615) + _640) * _615) / ((((((_652 * _615) + _661) * _615) + _673) * _615) + 1.0f);
  float _695 = sqrt(mad(_685, _156.z, mad(_684, _136.w, _683 * _136.x)));
  float _696 = sqrt(mad(_685, _156.w, mad(_684, _156.x, _683 * _136.y)));
  // float _697 = sqrt(mad(_685, asfloat(bufferT1.Load((_59 + 340u)).x), mad(_684, _156.y, _683 * _136.z)));
  float _697 = sqrt(mad(_685, _697a, mad(_684, _156.y, _683 * _136.z)));
  float _700 = max(max(_695, max(_696, _697)), 9.9999999747524270787835121154785e-07f);
  float _702 = 1.0f - _700;
  float _707 = saturate((_702 * 0.95238101482391357421875f) + 0.5f);

  // SmoothClamp
  float _714 = (1.0f - ((_702 < 0.52499997615814208984375f) ? ((_707 * _707) * 0.52499997615814208984375f) : _702)) / _700;
  float _715 = _714 * _695;
  float _716 = _714 * _696;
  float _717 = _714 * _697;
  // float4 _731 = _13[bufferT1.Load((_59 + 128u)).x].Sample(sampler1, float3((_715 * _310) + _311, (_716 * _310) + _311, (_717 * _310) + _311));
  Texture3D<float4> res128 = ResourceDescriptorHeap[bufferT1.Load<uint>(res128Index)];
  float _310 = _309.x;
  float _311 = _309.y;
  float _312 = _309.z;
  float _313 = _309.w;

  float4 _731 = res128.Sample(sampler1, float3((_715 * _310) + _311, (_716 * _310) + _311, (_717 * _310) + _311));

  float _733 = _731.x;
  float _734 = _731.y;
  float _735 = _731.z;
  float _792;
  float _793;
  float _794;
  if (_293 > 0.0f) {
    // float4 _778 = _13[bufferT1.Load((_59 + 160u)).x].Sample(sampler1, float3((_312 * _715) + _313, (_312 * _716) + _313, (_312 * _717) + _313));
    Texture3D<float4> res160 = ResourceDescriptorHeap[bufferT1.Load<uint>(res160Index)];

    float4 _778 = res160.Sample(sampler1, float3((_312 * _715) + _313, (_312 * _716) + _313, (_312 * _717) + _313));

    _792 = ((_778.x - _733) * _293) + _733;
    _793 = ((_778.y - _734) * _293) + _734;
    _794 = ((_778.z - _735) * _293) + _735;
  } else {
    _792 = _733;
    _793 = _734;
    _794 = _735;
  }
  float _795 = _792 / _714;
  float _796 = _793 / _714;
  float _797 = _794 / _714;
  // float _815 = (_9[bufferT1.Load((_59 + 96u)).x].Sample(sampler0, float2(_403.x * TEXCOORD.x, _403.y * TEXCOORD.y)).x * 0.000977517105638980865478515625f) + (-0.0004887585528194904327392578125f);
  Texture2D<float> res96 = ResourceDescriptorHeap[bufferT1.Load<uint>(res96Index)];
  float _815 = (res96.Sample(sampler0, float2(_403.x * TEXCOORD.x, _403.y * TEXCOORD.y)).x * 0.000977517105638980865478515625f) + (-0.0004887585528194904327392578125f);

  float _823 = dot(float3(_795, _796, _797), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) * _174;
  SV_Target_1 = _823;

  float _416 = _415.x;
  float _417 = _415.y;
  float _428 = _427.x;
  float _429 = _427.y;

  bool _834 = (min(max(TEXCOORD.x, min(_416, _428)), max(_416, _428)) != TEXCOORD.x) || (min(max(TEXCOORD.y, min(_417, _429)), max(_417, _429)) != TEXCOORD.y);
  float _835 = _834 ? 0.0f : _823;
  SV_Target_1 = _835;

  SV_Target.x = _834 ? 0.0f : (_815 + (_795 * _174));
  SV_Target.y = _834 ? 0.0f : (_815 + (_796 * _174));
  SV_Target.z = _834 ? 0.0f : (_815 + (_797 * _174));
  SV_Target.w = _835;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
