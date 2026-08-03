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
  precise float _213 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _213));
}

uint cvt_f32_u32(float v) {
  return (v > 4294967040.0f) ? 4294967295u : uint(max(v, 0.0f));
}

void frag_main() {
  float _231 = frac(sin(mad(TEXCOORD2.w, 543.30999755859375f, TEXCOORD2.z)) * 493013.0f);
  float _239 = mad(-_231, _231, 1.0f) * asfloat(cb0_m[64u].z);
  float _248 = TEXCOORD2.x - TEXCOORD.x;
  float _249 = TEXCOORD2.y - TEXCOORD.y;
  float _250 = _239 * _248;
  float _251 = _239 * _249;
  float _252 = mad(_239, _248, TEXCOORD.x);
  float _253 = mad(_239, _249, TEXCOORD.y);
  float _269 = mad(TEXCOORD3.x, asfloat(cb0_m[68u].z), asfloat(cb0_m[68u].x));
  float _270 = mad(TEXCOORD3.y, asfloat(cb0_m[68u].w), asfloat(cb0_m[68u].y));
  float _290 = asfloat(cb0_m[71u].z);
  float _295 = float(int(((_269 < 0.0f) ? 4294967295u : 0u) + uint(_269 > 0.0f))) * clamp(abs(_269) - _290, 0.0f, 1.0f);
  float _296 = clamp(abs(_270) - _290, 0.0f, 1.0f) * float(int(((_270 < 0.0f) ? 4294967295u : 0u) + uint(_270 > 0.0f)));
  float _301 = asfloat(cb0_m[71u].x);
  float _302 = asfloat(cb0_m[71u].y);
  float _315 = asfloat(cb0_m[69u].z);
  float _316 = asfloat(cb0_m[69u].w);
  float _319 = asfloat(cb0_m[69u].x);
  float _320 = asfloat(cb0_m[69u].y);
  float _329 = asfloat(cb0_m[38u].z);
  float _330 = asfloat(cb0_m[38u].w);
  float _335 = asfloat(cb0_m[39u].x);
  float _336 = asfloat(cb0_m[39u].y);
  float _343 = asfloat(cb0_m[38u].x);
  float _344 = asfloat(cb0_m[38u].y);
  float _357 = asfloat(cb0_m[43u].z);
  float _358 = asfloat(cb0_m[43u].w);
  float _363 = asfloat(cb0_m[44u].x);
  float _364 = asfloat(cb0_m[44u].y);
  float _389 = asfloat(cb1_m[135u].z);
  float _390 = t0.Sample(s0, float2(clamp(_250 + (mad(mad(mad(-_295, _301, _269), _315, _319), _329, _335) * _343), _357, _363), clamp(_358, _251 + (_344 * mad(_330, mad(_316, mad(-_301, _296, _270), _320), _336)), _364))).x * _389;
  float _391 = t0.Sample(s0, float2(clamp(_357, _250 + (_343 * mad(_329, mad(_315, mad(-_295, _302, _269), _319), _335)), _363), clamp(_358, _251 + (_344 * mad(_330, mad(_316, mad(-_302, _296, _270), _320), _336)), _364))).y * _389;
  float _392 = t0.Sample(s0, float2(clamp(_252, _357, _363), clamp(_253, _358, _364))).z * _389;
  float _394 = dp3_f32(float3(_390, _391, _392), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
  float _411 = mad(float(cvt_f32_u32(floor(_252 * asfloat(cb0_m[37u].y))) & 1u), 2.0f, -1.0f);
  float _412 = mad(float(cvt_f32_u32(floor(_253 * asfloat(cb0_m[37u].z))) & 1u), 2.0f, -1.0f);
  float4 _420 = t0.Sample(s0, float2(mad(asfloat(cb0_m[38u].x), _411, _252), _253 + 0.0f));
  float _421 = _420.x;
  float _422 = _420.y;
  float _423 = _420.z;
  float4 _431 = t0.Sample(s0, float2(mad(_343, 0.0f, _252), mad(_344, _412, _253)));
  float _432 = _431.x;
  float _433 = _431.y;
  float _434 = _431.z;
  float _485 = clamp(mad(-max(max(abs(_394 - dp3_f32(float3(_389 * _432, _389 * _433, _389 * _434), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f))), abs(_394 - dp3_f32(float3(_389 * _421, _389 * _422, _389 * _423), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)))), max(abs(_394 + mad(ddx_fine(_394), _411, -_394)), abs(_394 + mad(ddy_fine(_394), _412, -_394)))), TEXCOORD1.x, 1.0f), 0.0f, 1.0f) * asfloat(cb0_m[62u].y);
  float4 _536 = t1.Sample(s1, float2(clamp(mad(TEXCOORD.x, asfloat(cb0_m[58u].z), asfloat(cb0_m[59u].x)), asfloat(cb0_m[50u].z), asfloat(cb0_m[51u].x)), clamp(asfloat(cb0_m[50u].w), mad(TEXCOORD.y, asfloat(cb0_m[58u].w), asfloat(cb0_m[59u].y)), asfloat(cb0_m[51u].y))));
  float4 _549 = t3.Sample(s3, float2(mad(_269, 0.5f, 0.5f), mad(_270, -0.5f, 0.5f)));
  float _598 = mad(_231, asfloat(cb0_m[64u].x), asfloat(cb0_m[64u].y));
  float _599 = (TEXCOORD1.x * (((_389 * _536.x) * mad(_549.x, asfloat(cb0_m[67u].x), asfloat(cb0_m[61u].x))) + ((_390 - (mad(_390, -4.0f, (_390 - (ddy_fine(_390) * _412)) + mad(_389, _432, mad(_389, _421, _390 - (ddx_fine(_390) * _411)))) * _485)) * asfloat(cb0_m[60u].x)))) * _598;
  float _600 = _598 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].y) * (_391 - (_485 * mad(_391, -4.0f, mad(_389, _433, mad(_389, _422, _391 - (ddx_fine(_391) * _411))) + (_391 - (ddy_fine(_391) * _412)))))) + (mad(_549.y, asfloat(cb0_m[67u].y), asfloat(cb0_m[61u].y)) * (_389 * _536.y))));
  float _601 = _598 * (TEXCOORD1.x * ((asfloat(cb0_m[60u].z) * (_392 - (_485 * mad(_392, -4.0f, mad(_389, _434, mad(_389, _423, _392 - (ddx_fine(_392) * _411))) + (_392 - (ddy_fine(_392) * _412)))))) + (mad(_549.z, asfloat(cb0_m[67u].z), asfloat(cb0_m[61u].z)) * (_389 * _536.z))));
  float _649;
  float _650;
  float _651;
  if (cb0_m[70u].x != 0u) {
    bool _608 = float(cb0_m[70u].x) > 1.0f;
    float _610 = dp3_f32(float3(_599, _600, _601), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
    bool _634 = float(cvt_f32_u32(gl_FragCoord.y - float(cb0_m[53u].w))) > (asfloat(cb0_m[54u].w) - 64.0f);
    float _645 = (1.0f / exp2(max(16.0f - floor((asfloat(cb0_m[55u].x) * float(cvt_f32_u32(gl_FragCoord.x - float(cb0_m[53u].z)))) * 17.0f), 0.0f))) * 10.0f;
    _649 = _634 ? _645 : (_608 ? _610 : _601);
    _650 = _634 ? _645 : (_608 ? _610 : _600);
    _651 = _634 ? _645 : (_608 ? _610 : _599);
  } else {
    _649 = _601;
    _650 = _600;
    _651 = _599;
  }
  float _661 = exp2(log2(_651 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _662 = exp2(log2(_650 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float _663 = exp2(log2(_649 * 0.00999999977648258209228515625f) * 0.1593017578125f);
  float4 _693 = t4.Sample(s4, float3(mad(exp2(log2((1.0f / mad(_661, 18.6875f, 1.0f)) * mad(_661, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_662, 18.6875f, 1.0f)) * mad(_662, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f), mad(exp2(log2((1.0f / mad(_663, 18.6875f, 1.0f)) * mad(_663, 18.8515625f, 0.8359375f)) * 78.84375f), 0.984375f, 0.0078125f)));
  float3 _700 = float3(_693.x * 1.0499999523162841796875f, _693.y * 1.0499999523162841796875f, _693.z * 1.0499999523162841796875f);
  float3 _704 = float3(dp3_f32(float3(0.61319148540496826171875f, 0.3395120799541473388671875f, 0.0473663322627544403076171875f), _700), dp3_f32(float3(0.070206902921199798583984375f, 0.9163358211517333984375f, 0.01345001161098480224609375f), _700), dp3_f32(float3(0.02061887085437774658203125f, 0.109567292034626007080078125f, 0.8696067333221435546875f), _700));
  float _717 = exp2(log2(dp3_f32(float3(1.025799274444580078125f, -0.02005250938236713409423828125f, -0.005771367810666561126708984375f), _704) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _718 = exp2(log2(dp3_f32(float3(-0.00223502493463456630706787109375f, 1.0045826435089111328125f, -0.00235231337137520313262939453125f), _704) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _719 = exp2(log2(dp3_f32(float3(-0.005014003254473209381103515625f, -0.025293387472629547119140625f, 1.03044021129608154296875f), _704) * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _738 = exp2(log2(mad(_717, 18.8515625f, 0.8359375f) * (1.0f / mad(_717, 18.6875f, 1.0f))) * 78.84375f);
  float _739 = exp2(log2((1.0f / mad(_718, 18.6875f, 1.0f)) * mad(_718, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _740 = exp2(log2((1.0f / mad(_719, 18.6875f, 1.0f)) * mad(_719, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _743 = mad(_231, 0.00390625f, -0.001953125f);
  SV_Target.w = min(dp3_f32(float3(_738, _739, _740), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 1.0f);
  // Clamp after signed PQ-domain dither so it cannot make the fractional-power inputs negative.
  float3 dithered_pq = max(float3(_738, _739, _740) + _743, 0.0f);
  float _756 = exp2(log2(dithered_pq.r) * 0.0126833133399486541748046875f);
  float _757 = exp2(log2(dithered_pq.g) * 0.0126833133399486541748046875f);
  float _758 = exp2(log2(dithered_pq.b) * 0.0126833133399486541748046875f);
  float3 _783 = float3(exp2(log2(max(_756 - 0.8359375f, 0.0f) / mad(_756, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_757 - 0.8359375f, 0.0f) / mad(_757, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_758 - 0.8359375f, 0.0f) / mad(_758, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f);
  float3 _787 = float3(dp3_f32(float3(0.974913537502288818359375f, 0.019597612321376800537109375f, 0.00550352036952972412109375f), _783), dp3_f32(float3(0.002182342112064361572265625f, 0.995539963245391845703125f, 0.00228539831005036830902099609375f), _783), dp3_f32(float3(0.0047973222099244594573974609375f, 0.0245321206748485565185546875f, 0.97054231166839599609375f), _783));
  float _788 = dp3_f32(float3(1.70505154132843017578125f, -0.621790707111358642578125f, -0.083258397877216339111328125f), _787);
  float _789 = dp3_f32(float3(-0.13025714457035064697265625f, 1.140802860260009765625f, -0.0105485282838344573974609375f), _787);
  float _790 = dp3_f32(float3(-0.024003274738788604736328125f, -0.128968775272369384765625f, 1.152971744537353515625f), _787);
  float _817;
  float _818;
  float _819;
  if (cb0_m[66u].x != 0u) {
    _817 = (_790 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_790) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_790 * 12.9200000762939453125f);
    _818 = (_789 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_789) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_789 * 12.9200000762939453125f);
    _819 = (_788 >= 0.00313066993840038776397705078125f) ? mad(exp2(log2(_788) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f) : (_788 * 12.9200000762939453125f);
  } else {
    _817 = _790;
    _818 = _789;
    _819 = _788;
  }
  float3 _820 = float3(_819, _818, _817);
  float3 _824 = float3(dp3_f32(float3(0.61319148540496826171875f, 0.3395120799541473388671875f, 0.0473663322627544403076171875f), _820), dp3_f32(float3(0.070206902921199798583984375f, 0.9163358211517333984375f, 0.01345001161098480224609375f), _820), dp3_f32(float3(0.02061887085437774658203125f, 0.109567292034626007080078125f, 0.8696067333221435546875f), _820));
  // Clamp the second reconstructed BT.2020 color before PQ encoding to prevent negative fractional-power inputs.
  float3 post_transfer_bt2020 = max(float3(
                                        dp3_f32(float3(1.025799274444580078125f, -0.02005250938236713409423828125f, -0.005771367810666561126708984375f), _824),
                                        dp3_f32(float3(-0.00223502493463456630706787109375f, 1.0045826435089111328125f, -0.00235231337137520313262939453125f), _824),
                                        dp3_f32(float3(-0.005014003254473209381103515625f, -0.025293387472629547119140625f, 1.03044021129608154296875f), _824)),
                                    0.0f);
  float _837 = exp2(log2(post_transfer_bt2020.r * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _838 = exp2(log2(post_transfer_bt2020.g * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _839 = exp2(log2(post_transfer_bt2020.b * 0.024999998509883880615234375f) * 0.1593017578125f);
  float _858 = exp2(log2(mad(_837, 18.8515625f, 0.8359375f) * (1.0f / mad(_837, 18.6875f, 1.0f))) * 78.84375f);
  float _859 = exp2(log2((1.0f / mad(_838, 18.6875f, 1.0f)) * mad(_838, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _860 = exp2(log2((1.0f / mad(_839, 18.6875f, 1.0f)) * mad(_839, 18.8515625f, 0.8359375f)) * 78.84375f);
  float _863 = 1.0f - dp3_f32(float3(_858, _859, _860), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _865 = _863 * _863;
  float _870 = (_863 <= 0.0f) ? 0.110009253025054931640625f : (clamp(_863 * (_865 * _865), 0.19523799419403076171875f, 1.0f) * 0.563462316989898681640625f);
  float _880 = mad(mad(-_858, _870, 1.0f), _858 - 1.0f, 1.0f);
  float _881 = mad(_859 - 1.0f, mad(-_859, _870, 1.0f), 1.0f);
  float _882 = mad(_860 - 1.0f, mad(-_860, _870, 1.0f), 1.0f);
  float3 grained_pq;
  if (CUSTOM_GRAIN_TYPE == 0.f) {
    float _893 = frac(asfloat(cb1_m[142u].z));
    float _907 = asfloat(cb0_m[65u].y);
    float _913 = dp3_f32(float3(_880, _881, _882), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _914 = 1.0f - _913;
    float _924 = clamp(_913 * 20.0f, 0.0f, 1.0f);
    float _931 = asfloat(cb0_m[65u].z);
    float _948 = mad(((_931 + ((_924 <= 0.0f) ? 0.0f : (exp2(log2(_924) * 0.25f) * (1.0f - _931)))) * ((_914 <= 0.0f) ? 0.0f : exp2(log2(_914) * asfloat(cb0_m[65u].x)))) * asfloat(cb0_m[64u].w), t2.Sample(s2, float2((floor(_893 * 25.0f) * 0.20000000298023223876953125f) + ((TEXCOORD4.x / (asfloat(cb0_m[54u].w) * asfloat(cb0_m[55u].x))) * _907), (TEXCOORD4.y * _907) + (floor(_893 * 5.0f) * 0.20000000298023223876953125f))).x - 0.5f, 0.5f);
    float _949 = 1.0f - _948;
    float _953 = _949 + _949;
    float _960 = _948 + _948;
    grained_pq.r = max((_880 >= 0.5f) ? mad(-(1.0f - _880), _953, 1.0f) : (_880 * _960), 0.0f);
    grained_pq.g = max((_881 >= 0.5f) ? mad(-(1.0f - _881), _953, 1.0f) : (_881 * _960), 0.0f);
    grained_pq.b = max((_882 >= 0.5f) ? mad(-(1.0f - _882), _953, 1.0f) : (_882 * _960), 0.0f);
  } else {
    grained_pq = ApplyPerceptualFilmGrainBT2020PQ(float3(_880, _881, _882), TEXCOORD.xy);
  }
  float _979 = exp2(log2(grained_pq.r) * 0.0126833133399486541748046875f);
  float _980 = exp2(log2(grained_pq.g) * 0.0126833133399486541748046875f);
  float _981 = exp2(log2(grained_pq.b) * 0.0126833133399486541748046875f);
  float3 _1006 = float3(exp2(log2(max(_979 - 0.8359375f, 0.0f) / mad(_979, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_980 - 0.8359375f, 0.0f) / mad(_980, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f, exp2(log2(max(_981 - 0.8359375f, 0.0f) / mad(_981, -18.6875f, 18.8515625f)) * 6.277394771575927734375f) * 40.0f);
  float3 _1010 = float3(dp3_f32(float3(0.974913537502288818359375f, 0.019597612321376800537109375f, 0.00550352036952972412109375f), _1006), dp3_f32(float3(0.002182342112064361572265625f, 0.995539963245391845703125f, 0.00228539831005036830902099609375f), _1006), dp3_f32(float3(0.0047973222099244594573974609375f, 0.0245321206748485565185546875f, 0.97054231166839599609375f), _1006));
  SV_Target.x = dp3_f32(float3(1.70505154132843017578125f, -0.621790707111358642578125f, -0.083258397877216339111328125f), _1010);
  SV_Target.y = dp3_f32(float3(-0.13025714457035064697265625f, 1.140802860260009765625f, -0.0105485282838344573974609375f), _1010);
  SV_Target.z = dp3_f32(float3(-0.024003274738788604736328125f, -0.128968775272369384765625f, 1.152971744537353515625f), _1010);
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
