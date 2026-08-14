#include "./PostProcessToneMap.hlsli"

cbuffer cb0_buf : register(b0) {
  uint4 cb0_m[72] : packoffset(c0);
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
  precise float _217 = a.x * b.x;
  return mad(a.y, b.y, _217);
}

float dp3_f32(float3 a, float3 b) {
  precise float _203 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _203));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float _249 = mad(TEXCOORD3.x, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _250 = mad(TEXCOORD3.y, asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y));
  float _271 = asfloat(cb0_m[71u].z);
  float _276 = float(int(((_249 < 0.0f) ? 4294967295u : 0u) + uint(_249 > 0.0f))) * clamp(abs(_249) - _271, 0.0f, 1.0f);
  float _277 = clamp(abs(_250) - _271, 0.0f, 1.0f) * float(int(uint(_250 > 0.0f) + ((_250 < 0.0f) ? 4294967295u : 0u)));
  float _282 = asfloat(cb0_m[71u].x);
  float _283 = asfloat(cb0_m[71u].y);
  float _296 = asfloat(cb0_m[69u].z);
  float _297 = asfloat(cb0_m[69u].w);
  float _300 = asfloat(cb0_m[69u].x);
  float _301 = asfloat(cb0_m[69u].y);
  float _310 = asfloat(cb0_m[38u].z);
  float _311 = asfloat(cb0_m[38u].w);
  float _316 = asfloat(cb0_m[39u].x);
  float _317 = asfloat(cb0_m[39u].y);
  float _324 = asfloat(cb0_m[38u].x);
  float _325 = asfloat(cb0_m[38u].y);
  float _352 = asfloat(cb1_m[135u].z);
  float4 _388 = t1.Sample(s1, float2(clamp(mad(TEXCOORD.x, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(TEXCOORD.y, asfloat(cb0_m[58u].w), asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))));
  float4 _401 = t3.Sample(s3, float2(mad(_249, 0.5f, 0.5f), mad(_250, -0.5f, 0.5f)));
  float _452 = asfloat(cb0_m[62u].x);
  float2 _455 = float2(TEXCOORD1.y * _452, TEXCOORD1.z * _452);
  float _458 = 1.0f / (dp2_f32(_455, _455) + 1.0f);
  float _459 = _458 * _458;
  float _460 = ((((_352 * _388.x) * mad(_401.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((t0.Sample(s0, float2(mad(mad(mad(-_276, _282, _249), _296, _300), _310, _316) * _324, _325 * mad(_311, mad(_297, mad(-_282, _277, _250), _301), _317))).x * _352) * asfloat(cb0_m[60u].x))) * TEXCOORD1.x) * _459;
  float _461 = _459 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].y) * (t0.Sample(s0, float2(_324 * mad(_310, mad(_296, mad(-_276, _283, _249), _300), _316), _325 * mad(_311, mad(_297, mad(-_283, _277, _250), _301), _317))).y * _352)) + (mad(_401.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_352 * _388.y))));
  float _462 = _459 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].z) * (t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y)).z * _352)) + (mad(_401.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_352 * _388.z))));
  float _510;
  float _511;
  float _512;
  if (cb0_m[70u].x != 0u) {
    bool _469 = float(cb0_m[70u].x) > 1.0f;
    float _471 = dp3_f32(float3(_460, _461, _462), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _495 = float(cvt_f32_u32(gl_FragCoord.y - float(cb0_m[53u].w))) > (asfloat(cb0_m[54u].w) - 64.0f);
    float _506 = (1.0f / exp2(max(16.0f - floor((asfloat(cb0_m[55u].x) * float(cvt_f32_u32(gl_FragCoord.x - float(cb0_m[53u].z)))) * 17.0f), 0.0f))) * 10.0f;
    _510 = _495 ? _506 : (_469 ? _471 : _462);
    _511 = _495 ? _506 : (_469 ? _471 : _461);
    _512 = _495 ? _506 : (_469 ? _471 : _460);
  } else {
    _510 = _462;
    _511 = _461;
    _512 = _460;
  }
  float _522 = exp2(log2(_512 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _523 = exp2(log2(_511 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _524 = exp2(log2(_510 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _554 = t4.Sample(s4, float3(mad(exp2(log2((1.0f / mad(_522, 18.6875f, 1.0f)) * mad(_522, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_523, 18.6875f, 1.0f)) * mad(_523, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_524, 18.6875f, 1.0f)) * mad(_524, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)));
  float3 _561 = float3(_554.x * 1.0499999523162841796875f, _554.y * 1.0499999523162841796875f, _554.z * 1.0499999523162841796875f);
  float3 _565 = float3(dp3_f32(float3(0.61319148540496826171875f, 0.3395120799541473388671875f, 0.0473663322627544403076171875f), _561), dp3_f32(float3(0.070206902921199798583984375f, 0.9163358211517333984375f, 0.01345001161098480224609375f), _561), dp3_f32(float3(0.02061887085437774658203125f, 0.109567292034626007080078125f, 0.8696067333221435546875f), _561));
  float _578 = exp2(log2(dp3_f32(float3(1.025799274444580078125f, -0.02005250938236713409423828125f, -0.005771367810666561126708984375f), _565) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _579 = exp2(log2(dp3_f32(float3(-0.00223502493463456630706787109375f, 1.0045826435089111328125f, -0.00235231337137520313262939453125f), _565) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _580 = exp2(log2(dp3_f32(float3(-0.005014003254473209381103515625f, -0.025293387472629547119140625f, 1.03044021129608154296875f), _565) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _599 = exp2(log2(mad(_578, 18.8515625f, 0.8359375f) * (1.0f / mad(_578, 18.6875f, 1.0f))) * 78.84375f);
  float _600 = exp2(log2((1.0f / mad(_579, 18.6875f, 1.0f)) * mad(_579, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _601 = exp2(log2((1.0f / mad(_580, 18.6875f, 1.0f)) * mad(_580, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _604 = mad(frac(sin(mad(TEXCOORD2.w, 543.30999755859375f, TEXCOORD2.z)) * 493013.0f), 0.00390625f, -0.001953125f);
  SV_Target.w = min(dp3_f32(float3(_599, _600, _601), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 1.0f);
  // Clamp after signed PQ-domain dither so it cannot make the fractional-power inputs negative.
  float3 dithered_pq = max(float3(_599, _600, _601) + _604, 0.0f);
  float _617 = exp2(log2(dithered_pq.r) * 0.0126833133399486541748046875f);
  float _618 = exp2(log2(dithered_pq.g) * 0.0126833133399486541748046875f);
  float _619 = exp2(log2(dithered_pq.b) * 0.0126833133399486541748046875f);
  float3 _644 = float3(exp2(log2(max(_617 - 0.8359375f, 0.0f) / mad(_617, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_618 - 0.8359375f, 0.0f) / mad(_618, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_619 - 0.8359375f, 0.0f) / mad(_619, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f);
  float3 _648 = float3(dp3_f32(float3(0.974913537502288818359375f, 0.019597612321376800537109375f, 0.00550352036952972412109375f), _644), dp3_f32(float3(0.002182342112064361572265625f, 0.995539963245391845703125f, 0.00228539831005036830902099609375f), _644), dp3_f32(float3(0.0047973222099244594573974609375f, 0.0245321206748485565185546875f, 0.97054231166839599609375f), _644));
  float _649 = dp3_f32(float3(1.70505154132843017578125f, -0.621790707111358642578125f, -0.083258397877216339111328125f), _648);
  float _650 = dp3_f32(float3(-0.13025714457035064697265625f, 1.140802860260009765625f, -0.0105485282838344573974609375f), _648);
  float _651 = dp3_f32(float3(-0.024003274738788604736328125f, -0.128968775272369384765625f, 1.152971744537353515625f), _648);
  float _678;
  float _679;
  float _680;
  if (cb0_m[66u].x != 0u) {
    _678 = (_651 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_651) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_651 * 12.9200000762939453125f);
    _679 = (_650 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_650) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_650 * 12.9200000762939453125f);
    _680 = (_649 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_649) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_649 * 12.9200000762939453125f);
  } else {
    _678 = _651;
    _679 = _650;
    _680 = _649;
  }
  float3 _681 = float3(_680, _679, _678);
  float3 _685 = float3(dp3_f32(float3(0.61319148540496826171875f, 0.3395120799541473388671875f, 0.0473663322627544403076171875f), _681), dp3_f32(float3(0.070206902921199798583984375f, 0.9163358211517333984375f, 0.01345001161098480224609375f), _681), dp3_f32(float3(0.02061887085437774658203125f, 0.109567292034626007080078125f, 0.8696067333221435546875f), _681));
  // Clamp the second reconstructed BT.2020 color before PQ encoding to prevent negative fractional-power inputs.
  float3 post_transfer_bt2020 = max(float3(
                                        dp3_f32(float3(1.025799274444580078125f, -0.02005250938236713409423828125f, -0.005771367810666561126708984375f), _685),
                                        dp3_f32(float3(-0.00223502493463456630706787109375f, 1.0045826435089111328125f, -0.00235231337137520313262939453125f), _685),
                                        dp3_f32(float3(-0.005014003254473209381103515625f, -0.025293387472629547119140625f, 1.03044021129608154296875f), _685)),
                                    0.0f);
  float _698 = exp2(log2(post_transfer_bt2020.r * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _699 = exp2(log2(post_transfer_bt2020.g * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _700 = exp2(log2(post_transfer_bt2020.b * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _719 = exp2(log2(mad(_698, 18.8515625f, 0.8359375f) * (1.0f / mad(_698, 18.6875f, 1.0f))) * 78.84375f);
  float _720 = exp2(log2((1.0f / mad(_699, 18.6875f, 1.0f)) * mad(_699, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _721 = exp2(log2((1.0f / mad(_700, 18.6875f, 1.0f)) * mad(_700, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _724 = 1.0f - dp3_f32(float3(_719, _720, _721), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _726 = _724 * _724;
  float _731 = (_724 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_724 * (_726 * _726), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _741 = mad(mad(-_719, _731, 1.0f), _719 - 1.0f, 1.0f);
  float _742 = mad(_720 - 1.0f, mad(-_720, _731, 1.0f), 1.0f);
  float _743 = mad(_721 - 1.0f, mad(-_721, _731, 1.0f), 1.0f);
  float3 grained_pq;
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _754 = frac(asfloat(cb1_m[142u].z));
    float _768 = asfloat(cb0_m[65u].y);
    float _774 = dp3_f32(float3(_741, _742, _743), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _775 = 1.0f - _774;
    float _785 = clamp(_774 * 20.0f, 0.0f, 1.0f);
    float _792 = asfloat(cb0_m[65u].z);
    float _809 = mad(((_792 + ((_785 <= 0.0f) ? 0.0f : (exp2(log2(_785) * 0.25f) * (1.0f - _792)))) * ((_775 <= 0.0f) ? 0.0f : exp2(log2(_775) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t2.Sample(s2, float2((floor(_754 * 25.0f) * 0.20000000298023223876953125f) + ((TEXCOORD4.x / (asfloat(cb0_m[54u].w) * asfloat(cb0_m[55u].x))) * _768), (TEXCOORD4.y * _768) + (floor(_754 * 5.0f) * 0.20000000298023223876953125f))).x - 0.5f, 0.5f);
    float _810 = 1.0f - _809;
    float _814 = _810 + _810;
    float _821 = _809 + _809;
    grained_pq.r = max((_741 >= 0.5f) ? mad(-(1.0f - _741), _814, 1.0f) : (_741 * _821), 0.0f);
    grained_pq.g = max((_742 >= 0.5f) ? mad(-(1.0f - _742), _814, 1.0f) : (_742 * _821), 0.0f);
    grained_pq.b = max((_743 >= 0.5f) ? mad(-(1.0f - _743), _814, 1.0f) : (_743 * _821), 0.0f);
  } else {
    grained_pq = ApplyPerceptualFilmGrainBT2020PQ(float3(_741, _742, _743), TEXCOORD.xy);
  }
  float _840 = exp2(log2(grained_pq.r) * 0.0126833133399486541748046875f);
  float _841 = exp2(log2(grained_pq.g) * 0.0126833133399486541748046875f);
  float _842 = exp2(log2(grained_pq.b) * 0.0126833133399486541748046875f);
  float3 _867 = float3(exp2(log2(max(_840 - 0.8359375f, 0.0f) / mad(_840, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_841 - 0.8359375f, 0.0f) / mad(_841, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_842 - 0.8359375f, 0.0f) / mad(_842, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f);
  float3 _871 = float3(dp3_f32(float3(0.974913537502288818359375f, 0.019597612321376800537109375f, 0.00550352036952972412109375f), _867), dp3_f32(float3(0.002182342112064361572265625f, 0.995539963245391845703125f, 0.00228539831005036830902099609375f), _867), dp3_f32(float3(0.0047973222099244594573974609375f, 0.0245321206748485565185546875f, 0.97054231166839599609375f), _867));
  SV_Target.x = dp3_f32(float3(1.70505154132843017578125f, -0.621790707111358642578125f, -0.083258397877216339111328125f), _871);
  SV_Target.y = dp3_f32(float3(-0.13025714457035064697265625f, 1.140802860260009765625f, -0.0105485282838344573974609375f), _871);
  SV_Target.z = dp3_f32(float3(-0.024003274738788604736328125f, -0.128968775272369384765625f, 1.152971744537353515625f), _871);
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
