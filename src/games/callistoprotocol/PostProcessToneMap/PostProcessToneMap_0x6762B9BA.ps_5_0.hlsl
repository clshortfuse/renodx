#include "./PostProcessToneMap.hlsli"

cbuffer cb0_buf : register(b0) {
  uint4 cb0_m[71] : packoffset(c0);
};

cbuffer cb1_buf : register(b1) {
  uint4 cb1_m[143] : packoffset(c0);
};

SamplerState s0 : register(s0);
SamplerState s1 : register(s1);
SamplerState s2 : register(s2);
SamplerState s3 : register(s3);
SamplerState s4 : register(s4);
Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture3D<float4> t4 : register(t4);

#define SKIP_POST_CURVE_PROCESSING 1

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float2 TEXCOORD3;
static float3 TEXCOORD1;
static float4 TEXCOORD2;
static float2 TEXCOORD4;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  noperspective float2 TEXCOORD : TEXCOORD0;
  noperspective float2 TEXCOORD3 : TEXCOORD3;
  noperspective float3 TEXCOORD1 : TEXCOORD1;
  noperspective float4 TEXCOORD2 : TEXCOORD2;
  noperspective float2 TEXCOORD4 : TEXCOORD4;
  float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

float dp2_f32(float2 a, float2 b) {
  precise float _212 = a.x * b.x;
  return mad(a.y, b.y, _212);
}

float dp3_f32(float3 a, float3 b) {
  precise float _198 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _198));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float4 _237 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float _245 = asfloat(cb1_m[135u].z);
  float4 _283 = t1.Sample(s1, float2(clamp(mad(TEXCOORD.x, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(TEXCOORD.y, asfloat(cb0_m[58u].w), asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))));
  float4 _312 = t3.Sample(s3, float2(mad(mad(TEXCOORD3.x, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x)), 0.5f, 0.5f), mad(mad(TEXCOORD3.y, asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y)), -0.5f, 0.5f)));
  float _363 = asfloat(cb0_m[62u].x);
  float2 _366 = float2(TEXCOORD1.y * _363, TEXCOORD1.z * _363);
  float _369 = 1.0f / (dp2_f32(_366, _366) + 1.0f);
  float _370 = _369 * _369;
  float _371 = ((((_245 * _283.x) * mad(_312.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + (asfloat(cb0_m[60u].x) * (_237.x * _245))) * TEXCOORD1.x) * _370;
  float _372 = _370 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].y) * (_237.y * _245)) + ((_245 * _283.y) * mad(_312.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)))));
  float _373 = _370 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].z) * (_237.z * _245)) + ((_245 * _283.z) * mad(_312.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)))));
  float _421;
  float _422;
  float _423;
  if (cb0_m[70u].x != 0u) {
    bool _380 = float(cb0_m[70u].x) > 1.0f;
    float _382 = dp3_f32(float3(_371, _372, _373), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _406 = float(cvt_f32_u32(gl_FragCoord.y - float(cb0_m[53u].w))) > (asfloat(cb0_m[54u].w) - 64.0f);
    float _417 = (1.0f / exp2(max(16.0f - floor((asfloat(cb0_m[55u].x) * float(cvt_f32_u32(gl_FragCoord.x - float(cb0_m[53u].z)))) * 17.0f), 0.0f))) * 10.0f;
    _421 = _406 ? _417 : (_380 ? _382 : _373);
    _422 = _406 ? _417 : (_380 ? _382 : _372);
    _423 = _406 ? _417 : (_380 ? _382 : _371);
  } else {
    _421 = _373;
    _422 = _372;
    _423 = _371;
  }
  float _433 = exp2(log2(_423 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _434 = exp2(log2(_422 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _435 = exp2(log2(_421 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _465 = t4.Sample(s4, float3(mad(exp2(log2((1.0f / mad(_433, 18.6875f, 1.0f)) * mad(_433, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_434, 18.6875f, 1.0f)) * mad(_434, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_435, 18.6875f, 1.0f)) * mad(_435, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)));
  float3 _472 = float3(_465.x * 1.0499999523162841796875f, _465.y * 1.0499999523162841796875f, _465.z * 1.0499999523162841796875f);
  float3 _476 = float3(dp3_f32(float3(0.61319148540496826171875f, 0.3395120799541473388671875f, 0.0473663322627544403076171875f), _472), dp3_f32(float3(0.070206902921199798583984375f, 0.9163358211517333984375f, 0.01345001161098480224609375f), _472), dp3_f32(float3(0.02061887085437774658203125f, 0.109567292034626007080078125f, 0.8696067333221435546875f), _472));
  float _489 = exp2(log2(dp3_f32(float3(1.025799274444580078125f, -0.02005250938236713409423828125f, -0.005771367810666561126708984375f), _476) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _490 = exp2(log2(dp3_f32(float3(-0.00223502493463456630706787109375f, 1.0045826435089111328125f, -0.00235231337137520313262939453125f), _476) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _491 = exp2(log2(dp3_f32(float3(-0.005014003254473209381103515625f, -0.025293387472629547119140625f, 1.03044021129608154296875f), _476) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _510 = exp2(log2(mad(_489, 18.8515625f, 0.8359375f) * (1.0f / mad(_489, 18.6875f, 1.0f))) * 78.84375f);
  float _511 = exp2(log2((1.0f / mad(_490, 18.6875f, 1.0f)) * mad(_490, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _512 = exp2(log2((1.0f / mad(_491, 18.6875f, 1.0f)) * mad(_491, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _515 = mad(frac(sin(mad(TEXCOORD2.w, 543.30999755859375f, TEXCOORD2.z)) * 493013.0f), 0.00390625f, -0.001953125f);
  SV_Target.w = min(dp3_f32(float3(_510, _511, _512), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 1.0f);
  // Clamp after signed PQ-domain dither so it cannot make the fractional-power inputs negative.
  float3 dithered_pq = max(float3(_510, _511, _512) + _515, 0.0f);
  float _528 = exp2(log2(dithered_pq.r) * 0.0126833133399486541748046875f);
  float _529 = exp2(log2(dithered_pq.g) * 0.0126833133399486541748046875f);
  float _530 = exp2(log2(dithered_pq.b) * 0.0126833133399486541748046875f);
  float3 _555 = float3(exp2(log2(max(_528 - 0.8359375f, 0.0f) / mad(_528, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_529 - 0.8359375f, 0.0f) / mad(_529, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_530 - 0.8359375f, 0.0f) / mad(_530, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f);
  float3 _559 = float3(dp3_f32(float3(0.974913537502288818359375f, 0.019597612321376800537109375f, 0.00550352036952972412109375f), _555), dp3_f32(float3(0.002182342112064361572265625f, 0.995539963245391845703125f, 0.00228539831005036830902099609375f), _555), dp3_f32(float3(0.0047973222099244594573974609375f, 0.0245321206748485565185546875f, 0.97054231166839599609375f), _555));
  float _560 = dp3_f32(float3(1.70505154132843017578125f, -0.621790707111358642578125f, -0.083258397877216339111328125f), _559);
  float _561 = dp3_f32(float3(-0.13025714457035064697265625f, 1.140802860260009765625f, -0.0105485282838344573974609375f), _559);
  float _562 = dp3_f32(float3(-0.024003274738788604736328125f, -0.128968775272369384765625f, 1.152971744537353515625f), _559);
  float _589;
  float _590;
  float _591;
  if (cb0_m[66u].x != 0u) {
    _589 = (_562 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_562) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_562 * 12.9200000762939453125f);
    _590 = (_561 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_561) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_561 * 12.9200000762939453125f);
    _591 = (_560 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_560) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_560 * 12.9200000762939453125f);
  } else {
    _589 = _562;
    _590 = _561;
    _591 = _560;
  }
  float3 _592 = float3(_591, _590, _589);
  float3 _596 = float3(dp3_f32(float3(0.61319148540496826171875f, 0.3395120799541473388671875f, 0.0473663322627544403076171875f), _592), dp3_f32(float3(0.070206902921199798583984375f, 0.9163358211517333984375f, 0.01345001161098480224609375f), _592), dp3_f32(float3(0.02061887085437774658203125f, 0.109567292034626007080078125f, 0.8696067333221435546875f), _592));
  // Clamp the second reconstructed BT.2020 color before PQ encoding to prevent negative fractional-power inputs.
  float3 post_transfer_bt2020 = max(float3(
                                        dp3_f32(float3(1.025799274444580078125f, -0.02005250938236713409423828125f, -0.005771367810666561126708984375f), _596),
                                        dp3_f32(float3(-0.00223502493463456630706787109375f, 1.0045826435089111328125f, -0.00235231337137520313262939453125f), _596),
                                        dp3_f32(float3(-0.005014003254473209381103515625f, -0.025293387472629547119140625f, 1.03044021129608154296875f), _596)),
                                    0.0f);
  float _609 = exp2(log2(post_transfer_bt2020.r * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _610 = exp2(log2(post_transfer_bt2020.g * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _611 = exp2(log2(post_transfer_bt2020.b * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _630 = exp2(log2(mad(_609, 18.8515625f, 0.8359375f) * (1.0f / mad(_609, 18.6875f, 1.0f))) * 78.84375f);
  float _631 = exp2(log2((1.0f / mad(_610, 18.6875f, 1.0f)) * mad(_610, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _632 = exp2(log2((1.0f / mad(_611, 18.6875f, 1.0f)) * mad(_611, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _635 = 1.0f - dp3_f32(float3(_630, _631, _632), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _637 = _635 * _635;
  float _642 = (_635 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_635 * (_637 * _637), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _652 = mad(mad(-_630, _642, 1.0f), _630 - 1.0f, 1.0f);
  float _653 = mad(_631 - 1.0f, mad(-_631, _642, 1.0f), 1.0f);
  float _654 = mad(_632 - 1.0f, mad(-_632, _642, 1.0f), 1.0f);
  float3 grained_pq;
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _665 = frac(asfloat(cb1_m[142u].z));
    float _679 = asfloat(cb0_m[65u].y);
    float _685 = dp3_f32(float3(_652, _653, _654), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _686 = 1.0f - _685;
    float _695 = clamp(_685 * 20.0f, 0.0f, 1.0f);
    float _702 = asfloat(cb0_m[65u].z);
    float _720 = mad(t2.Sample(s2, float2((floor(_665 * 25.0f) * 0.20000000298023223876953125f) + ((TEXCOORD4.x / (asfloat(cb0_m[54u].w) * asfloat(cb0_m[55u].x))) * _679), (TEXCOORD4.y * _679) + (floor(_665 * 5.0f) * 0.20000000298023223876953125f))).x - 0.5f, (_686 <= 0.0f) ? 0.0f : ((exp2(log2(_686) * asfloat(cb0_m[65u].x)) * (_702 + ((_695 <= 0.0f) ? 0.0f : (exp2(log2(_695) * 0.25f) * (1.0f - _702))))) * asfloat(cb0_m[64u].w)), 0.5f);
    float _721 = 1.0f - _720;
    float _725 = _721 + _721;
    float _732 = _720 + _720;
    grained_pq.r = max((_652 >= 0.5f) ? mad(-(1.0f - _652), _725, 1.0f) : (_652 * _732), 0.0f);
    grained_pq.g = max((_653 >= 0.5f) ? mad(-(1.0f - _653), _725, 1.0f) : (_653 * _732), 0.0f);
    grained_pq.b = max((_654 >= 0.5f) ? mad(-(1.0f - _654), _725, 1.0f) : (_654 * _732), 0.0f);
  } else {
    grained_pq = ApplyPerceptualFilmGrainBT2020PQ(float3(_652, _653, _654), TEXCOORD.xy);
  }
  float _751 = exp2(log2(grained_pq.r) * 0.0126833133399486541748046875f);
  float _752 = exp2(log2(grained_pq.g) * 0.0126833133399486541748046875f);
  float _753 = exp2(log2(grained_pq.b) * 0.0126833133399486541748046875f);
  float3 _778 = float3(exp2(log2(max(_751 - 0.8359375f, 0.0f) / mad(_751, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_752 - 0.8359375f, 0.0f) / mad(_752, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_753 - 0.8359375f, 0.0f) / mad(_753, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f);
  float3 _782 = float3(dp3_f32(float3(0.974913537502288818359375f, 0.019597612321376800537109375f, 0.00550352036952972412109375f), _778), dp3_f32(float3(0.002182342112064361572265625f, 0.995539963245391845703125f, 0.00228539831005036830902099609375f), _778), dp3_f32(float3(0.0047973222099244594573974609375f, 0.0245321206748485565185546875f, 0.97054231166839599609375f), _778));
  SV_Target.x = dp3_f32(float3(1.70505154132843017578125f, -0.621790707111358642578125f, -0.083258397877216339111328125f), _782);
  SV_Target.y = dp3_f32(float3(-0.13025714457035064697265625f, 1.140802860260009765625f, -0.0105485282838344573974609375f), _782);
  SV_Target.z = dp3_f32(float3(-0.024003274738788604736328125f, -0.128968775272369384765625f, 1.152971744537353515625f), _782);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  TEXCOORD3 = stage_input.TEXCOORD3;
  TEXCOORD1 = stage_input.TEXCOORD1;
  TEXCOORD2 = stage_input.TEXCOORD2;
  TEXCOORD4 = stage_input.TEXCOORD4;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
