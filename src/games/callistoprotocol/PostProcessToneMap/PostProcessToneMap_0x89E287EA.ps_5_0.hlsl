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

float dp3_f32(float3 a, float3 b) {
  precise float _225 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _225));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

float dp2_f32(float2 a, float2 b) {
  precise float _204 = a.x * b.x;
  return mad(a.y, b.y, _204);
}

void frag_main() {
  float _243 = frac(sin(mad(TEXCOORD2.w, 543.30999755859375f, TEXCOORD2.z)) * 493013.0f);
  float _251 = mad(-_243, _243, 1.0f) * asfloat(cb0_m[64u].z);
  float _260 = TEXCOORD2.x - TEXCOORD.x;
  float _261 = TEXCOORD2.y - TEXCOORD.y;
  float _262 = _251 * _260;
  float _263 = _251 * _261;
  float _264 = mad(_251, _260, TEXCOORD.x);
  float _265 = mad(_251, _261, TEXCOORD.y);
  float _281 = mad(TEXCOORD3.x, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _282 = mad(TEXCOORD3.y, asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y));
  float _302 = asfloat(cb0_m[71u].z);
  float _307 = float(int(((_281 < 0.0f) ? 4294967295u : 0u) + uint(_281 > 0.0f))) * clamp(abs(_281) - _302, 0.0f, 1.0f);
  float _308 = clamp(abs(_282) - _302, 0.0f, 1.0f) * float(int(((_282 < 0.0f) ? 4294967295u : 0u) + uint(_282 > 0.0f)));
  float _313 = asfloat(cb0_m[71u].x);
  float _314 = asfloat(cb0_m[71u].y);
  float _327 = asfloat(cb0_m[69u].z);
  float _328 = asfloat(cb0_m[69u].w);
  float _331 = asfloat(cb0_m[69u].x);
  float _332 = asfloat(cb0_m[69u].y);
  float _341 = asfloat(cb0_m[38u].z);
  float _342 = asfloat(cb0_m[38u].w);
  float _347 = asfloat(cb0_m[39u].x);
  float _348 = asfloat(cb0_m[39u].y);
  float _355 = asfloat(cb0_m[38u].x);
  float _356 = asfloat(cb0_m[38u].y);
  float _369 = asfloat(cb0_m[43u].z);
  float _370 = asfloat(cb0_m[43u].w);
  float _375 = asfloat(cb0_m[44u].x);
  float _376 = asfloat(cb0_m[44u].y);
  float _401 = asfloat(cb1_m[135u].z);
  float _402 = t0.Sample(s0, float2(clamp(_262 + (mad(mad(mad(-_307, _313, _281), _327, _331), _341, _347) * _355), _369, _375), clamp(_370, _263 + (_356 * mad(_342, mad(_328, mad(-_313, _308, _282), _332), _348)), _376))).x * _401;
  float _403 = t0.Sample(s0, float2(clamp(_369, _262 + (_355 * mad(_341, mad(_327, mad(-_307, _314, _281), _331), _347)), _375), clamp(_370, _263 + (_356 * mad(_342, mad(_328, mad(-_314, _308, _282), _332), _348)), _376))).y * _401;
  float _404 = t0.Sample(s0, float2(clamp(_264, _369, _375), clamp(_265, _370, _376))).z * _401;
  float _406 = dp3_f32(float3(_402, _403, _404), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
  float _423 = mad(float(cvt_f32_u32(floor(_264 * asfloat(cb0_m[37u].y))) & 1u), 2.0f, -1.0f);
  float _424 = mad(float(cvt_f32_u32(floor(_265 * asfloat(cb0_m[37u].z))) & 1u), 2.0f, -1.0f);
  float4 _432 = t0.Sample(s0, float2(mad(asfloat(cb0_m[38u].x), _423, _264), _265 + 0.0f));
  float _433 = _432.x;
  float _434 = _432.y;
  float _435 = _432.z;
  float4 _443 = t0.Sample(s0, float2(mad(_355, 0.0f, _264), mad(_356, _424, _265)));
  float _444 = _443.x;
  float _445 = _443.y;
  float _446 = _443.z;
  float _497 = clamp(mad(-max(max(abs(_406 - dp3_f32(float3(_401 * _444, _401 * _445, _401 * _446), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f))), abs(_406 - dp3_f32(float3(_401 * _433, _401 * _434, _401 * _435), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)))), max(abs(_406 + mad(ddx_fine(_406), _423, -_406)), abs(_406 + mad(ddy_fine(_406), _424, -_406)))), TEXCOORD1.x, 1.0f), 0.0f, 1.0f) * asfloat(cb0_m[62u].y);
  float4 _548 = t1.Sample(s1, float2(clamp(mad(TEXCOORD.x, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(TEXCOORD.y, asfloat(cb0_m[58u].w), asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))));
  float4 _561 = t3.Sample(s3, float2(mad(_281, 0.5f, 0.5f), mad(_282, -0.5f, 0.5f)));
  float _610 = asfloat(cb0_m[62u].x);
  float2 _613 = float2(TEXCOORD1.y * _610, TEXCOORD1.z * _610);
  float _616 = 1.0f / (dp2_f32(_613, _613) + 1.0f);
  float _617 = _616 * _616;
  float _627 = mad(_243, asfloat(cb0_m[64u].x), asfloat(cb0_m[64u].y));
  float _628 = ((TEXCOORD1.x * (((_401 * _548.x) * mad(_561.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((_402 - (mad(_402, -4.0f, (_402 - (ddy_fine(_402) * _424)) + mad(_401, _444, mad(_401, _433, _402 - (ddx_fine(_402) * _423)))) * _497)) * asfloat(cb0_m[60u].x)))) * _617) * _627;
  float _629 = _627 * (_617 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].y) * (_403 - (_497 * mad(_403, -4.0f, mad(_401, _445, mad(_401, _434, _403 - (ddx_fine(_403) * _423))) + (_403 - (ddy_fine(_403) * _424)))))) + (mad(_561.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_401 * _548.y)))));
  float _630 = _627 * (_617 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].z) * (_404 - (_497 * mad(_404, -4.0f, mad(_401, _446, mad(_401, _435, _404 - (ddx_fine(_404) * _423))) + (_404 - (ddy_fine(_404) * _424)))))) + (mad(_561.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_401 * _548.z)))));
  float _678;
  float _679;
  float _680;
  if (cb0_m[70u].x != 0u) {
    bool _637 = float(cb0_m[70u].x) > 1.0f;
    float _639 = dp3_f32(float3(_628, _629, _630), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _663 = float(cvt_f32_u32(gl_FragCoord.y - float(cb0_m[53u].w))) > (asfloat(cb0_m[54u].w) - 64.0f);
    float _674 = (1.0f / exp2(max(16.0f - floor((asfloat(cb0_m[55u].x) * float(cvt_f32_u32(gl_FragCoord.x - float(cb0_m[53u].z)))) * 17.0f), 0.0f))) * 10.0f;
    _678 = _663 ? _674 : (_637 ? _639 : _630);
    _679 = _663 ? _674 : (_637 ? _639 : _629);
    _680 = _663 ? _674 : (_637 ? _639 : _628);
  } else {
    _678 = _630;
    _679 = _629;
    _680 = _628;
  }
  float _690 = exp2(log2(_680 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _691 = exp2(log2(_679 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _692 = exp2(log2(_678 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _722 = t4.Sample(s4, float3(mad(exp2(log2((1.0f / mad(_690, 18.6875f, 1.0f)) * mad(_690, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_691, 18.6875f, 1.0f)) * mad(_691, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_692, 18.6875f, 1.0f)) * mad(_692, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)));
  float3 _729 = float3(_722.x * 1.0499999523162841796875f, _722.y * 1.0499999523162841796875f, _722.z * 1.0499999523162841796875f);
  float3 _733 = float3(dp3_f32(float3(0.61319148540496826171875f, 0.3395120799541473388671875f, 0.0473663322627544403076171875f), _729), dp3_f32(float3(0.070206902921199798583984375f, 0.9163358211517333984375f, 0.01345001161098480224609375f), _729), dp3_f32(float3(0.02061887085437774658203125f, 0.109567292034626007080078125f, 0.8696067333221435546875f), _729));
  float _746 = exp2(log2(dp3_f32(float3(1.025799274444580078125f, -0.02005250938236713409423828125f, -0.005771367810666561126708984375f), _733) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _747 = exp2(log2(dp3_f32(float3(-0.00223502493463456630706787109375f, 1.0045826435089111328125f, -0.00235231337137520313262939453125f), _733) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _748 = exp2(log2(dp3_f32(float3(-0.005014003254473209381103515625f, -0.025293387472629547119140625f, 1.03044021129608154296875f), _733) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _767 = exp2(log2(mad(_746, 18.8515625f, 0.8359375f) * (1.0f / mad(_746, 18.6875f, 1.0f))) * 78.84375f);
  float _768 = exp2(log2((1.0f / mad(_747, 18.6875f, 1.0f)) * mad(_747, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _769 = exp2(log2((1.0f / mad(_748, 18.6875f, 1.0f)) * mad(_748, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _772 = mad(_243, 0.00390625f, -0.001953125f);
  SV_Target.w = min(dp3_f32(float3(_767, _768, _769), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 1.0f);
  // Clamp after signed PQ-domain dither so it cannot make the fractional-power inputs negative.
  float3 dithered_pq = max(float3(_767, _768, _769) + _772, 0.0f);
  float _785 = exp2(log2(dithered_pq.r) * 0.0126833133399486541748046875f);
  float _786 = exp2(log2(dithered_pq.g) * 0.0126833133399486541748046875f);
  float _787 = exp2(log2(dithered_pq.b) * 0.0126833133399486541748046875f);
  float3 _812 = float3(exp2(log2(max(_785 - 0.8359375f, 0.0f) / mad(_785, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_786 - 0.8359375f, 0.0f) / mad(_786, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_787 - 0.8359375f, 0.0f) / mad(_787, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f);
  float3 _816 = float3(dp3_f32(float3(0.974913537502288818359375f, 0.019597612321376800537109375f, 0.00550352036952972412109375f), _812), dp3_f32(float3(0.002182342112064361572265625f, 0.995539963245391845703125f, 0.00228539831005036830902099609375f), _812), dp3_f32(float3(0.0047973222099244594573974609375f, 0.0245321206748485565185546875f, 0.97054231166839599609375f), _812));
  float _817 = dp3_f32(float3(1.70505154132843017578125f, -0.621790707111358642578125f, -0.083258397877216339111328125f), _816);
  float _818 = dp3_f32(float3(-0.13025714457035064697265625f, 1.140802860260009765625f, -0.0105485282838344573974609375f), _816);
  float _819 = dp3_f32(float3(-0.024003274738788604736328125f, -0.128968775272369384765625f, 1.152971744537353515625f), _816);
  float _846;
  float _847;
  float _848;
  if (cb0_m[66u].x != 0u) {
    _846 = (_819 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_819) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_819 * 12.9200000762939453125f);
    _847 = (_818 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_818) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_818 * 12.9200000762939453125f);
    _848 = (_817 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_817) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_817 * 12.9200000762939453125f);
  } else {
    _846 = _819;
    _847 = _818;
    _848 = _817;
  }
  float3 _849 = float3(_848, _847, _846);
  float3 _853 = float3(dp3_f32(float3(0.61319148540496826171875f, 0.3395120799541473388671875f, 0.0473663322627544403076171875f), _849), dp3_f32(float3(0.070206902921199798583984375f, 0.9163358211517333984375f, 0.01345001161098480224609375f), _849), dp3_f32(float3(0.02061887085437774658203125f, 0.109567292034626007080078125f, 0.8696067333221435546875f), _849));
  // Clamp the second reconstructed BT.2020 color before PQ encoding to prevent negative fractional-power inputs.
  float3 post_transfer_bt2020 = max(float3(
                                        dp3_f32(float3(1.025799274444580078125f, -0.02005250938236713409423828125f, -0.005771367810666561126708984375f), _853),
                                        dp3_f32(float3(-0.00223502493463456630706787109375f, 1.0045826435089111328125f, -0.00235231337137520313262939453125f), _853),
                                        dp3_f32(float3(-0.005014003254473209381103515625f, -0.025293387472629547119140625f, 1.03044021129608154296875f), _853)),
                                    0.0f);
  float _866 = exp2(log2(post_transfer_bt2020.r * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _867 = exp2(log2(post_transfer_bt2020.g * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _868 = exp2(log2(post_transfer_bt2020.b * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _887 = exp2(log2(mad(_866, 18.8515625f, 0.8359375f) * (1.0f / mad(_866, 18.6875f, 1.0f))) * 78.84375f);
  float _888 = exp2(log2((1.0f / mad(_867, 18.6875f, 1.0f)) * mad(_867, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _889 = exp2(log2((1.0f / mad(_868, 18.6875f, 1.0f)) * mad(_868, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _892 = 1.0f - dp3_f32(float3(_887, _888, _889), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _894 = _892 * _892;
  float _899 = (_892 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_892 * (_894 * _894), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _909 = mad(mad(-_887, _899, 1.0f), _887 - 1.0f, 1.0f);
  float _910 = mad(_888 - 1.0f, mad(-_888, _899, 1.0f), 1.0f);
  float _911 = mad(_889 - 1.0f, mad(-_889, _899, 1.0f), 1.0f);
  float3 grained_pq;
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _922 = frac(asfloat(cb1_m[142u].z));
    float _936 = asfloat(cb0_m[65u].y);
    float _942 = dp3_f32(float3(_909, _910, _911), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _943 = 1.0f - _942;
    float _953 = clamp(_942 * 20.0f, 0.0f, 1.0f);
    float _960 = asfloat(cb0_m[65u].z);
    float _977 = mad(((_960 + ((_953 <= 0.0f) ? 0.0f : (exp2(log2(_953) * 0.25f) * (1.0f - _960)))) * ((_943 <= 0.0f) ? 0.0f : exp2(log2(_943) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t2.Sample(s2, float2((floor(_922 * 25.0f) * 0.20000000298023223876953125f) + ((TEXCOORD4.x / (asfloat(cb0_m[54u].w) * asfloat(cb0_m[55u].x))) * _936), (TEXCOORD4.y * _936) + (floor(_922 * 5.0f) * 0.20000000298023223876953125f))).x - 0.5f, 0.5f);
    float _978 = 1.0f - _977;
    float _982 = _978 + _978;
    float _989 = _977 + _977;
    grained_pq.r = max((_909 >= 0.5f) ? mad(-(1.0f - _909), _982, 1.0f) : (_909 * _989), 0.0f);
    grained_pq.g = max((_910 >= 0.5f) ? mad(-(1.0f - _910), _982, 1.0f) : (_910 * _989), 0.0f);
    grained_pq.b = max((_911 >= 0.5f) ? mad(-(1.0f - _911), _982, 1.0f) : (_911 * _989), 0.0f);
  } else {
    grained_pq = ApplyPerceptualFilmGrainBT2020PQ(float3(_909, _910, _911), TEXCOORD.xy);
  }
  float _1008 = exp2(log2(grained_pq.r) * 0.0126833133399486541748046875f);
  float _1009 = exp2(log2(grained_pq.g) * 0.0126833133399486541748046875f);
  float _1010 = exp2(log2(grained_pq.b) * 0.0126833133399486541748046875f);
  float3 _1035 = float3(exp2(log2(max(_1008 - 0.8359375f, 0.0f) / mad(_1008, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_1009 - 0.8359375f, 0.0f) / mad(_1009, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_1010 - 0.8359375f, 0.0f) / mad(_1010, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f);
  float3 _1039 = float3(dp3_f32(float3(0.974913537502288818359375f, 0.019597612321376800537109375f, 0.00550352036952972412109375f), _1035), dp3_f32(float3(0.002182342112064361572265625f, 0.995539963245391845703125f, 0.00228539831005036830902099609375f), _1035), dp3_f32(float3(0.0047973222099244594573974609375f, 0.0245321206748485565185546875f, 0.97054231166839599609375f), _1035));
  SV_Target.x = dp3_f32(float3(1.70505154132843017578125f, -0.621790707111358642578125f, -0.083258397877216339111328125f), _1039);
  SV_Target.y = dp3_f32(float3(-0.13025714457035064697265625f, 1.140802860260009765625f, -0.0105485282838344573974609375f), _1039);
  SV_Target.z = dp3_f32(float3(-0.024003274738788604736328125f, -0.128968775272369384765625f, 1.152971744537353515625f), _1039);
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
