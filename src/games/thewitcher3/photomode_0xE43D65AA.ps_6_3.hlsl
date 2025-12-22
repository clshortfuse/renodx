#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

cbuffer cb3 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

SamplerState s1 : register(s1);

// float4 main(
//     noperspective float4 SV_Position: SV_Position,
//     linear float2 TEXCOORD: TEXCOORD,
//     linear float2 TEXCOORD_2: TEXCOORD2
// ) : SV_Target {
//   float4 SV_Target;
//   float _16 = (TEXCOORD.x - CustomPixelConsts_272.x) / CustomPixelConsts_272.x;
//   float _17 = (TEXCOORD.y - CustomPixelConsts_272.y) / CustomPixelConsts_272.y;
//   float _21 = sqrt((_17 * _17) + (_16 * _16));
//   float _24 = saturate((_21 - CustomPixelConsts_256.y) * CustomPixelConsts_256.z);
//   float4 _25 = t0.SampleLevel(s1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
//   float _55;
//   float _56;
//   [branch]
//   if (_24 > 0.0f) {
//     float _39 = ((_24 * _24) * CustomPixelConsts_256.x) * min(max((1.0f / _21), -3.4028234663852886e+38f), 3.4028234663852886e+38f);
//     float _41 = (_16 * CustomPixelConsts_272.z) * _39;
//     float _43 = (_17 * CustomPixelConsts_272.w) * _39;
//     float4 _48 = t0.SampleLevel(s1, float2((TEXCOORD.x - (_41 * 2.0f)), (TEXCOORD.y - (_43 * 2.0f))), 0.0f);
//     float4 _52 = t0.SampleLevel(s1, float2((TEXCOORD.x - _41), (TEXCOORD.y - _43)), 0.0f);
//     _55 = _48.x;
//     _56 = _52.y;
//   } else {
//     _55 = _25.x;
//     _56 = _25.y;
//   }
//   float _75 = saturate((CustomPixelConsts_288.y * (saturate(CustomPixelConsts_288.x * _55) + -0.5f)) + 0.5f);
//   float _76 = saturate((CustomPixelConsts_288.y * (saturate(CustomPixelConsts_288.x * _56) + -0.5f)) + 0.5f);
//   float _77 = saturate((CustomPixelConsts_288.y * (saturate(CustomPixelConsts_288.x * _25.z) + -0.5f)) + 0.5f);
//   bool _79 = (CustomPixelConsts_288.w <= 6500.0f);
//   float _88 = saturate((CustomPixelConsts_288.w + -1000.0f) * -0.0010000000474974513f);
//   float _92 = (_88 * _88) * (3.0f - (_88 * 2.0f));
//   float _105 = min(max((select(_79, 1.0f, 0.5599538683891296f) + (select(_79, 0.0f, 1745.04248046875f) / (select(_79, 0.0f, -2666.347412109375f) + CustomPixelConsts_288.w))), 0.0f), 1.0f);
//   float _106 = min(max(((select(_79, -2902.195556640625f, 1216.6168212890625f) / (select(_79, 1669.580322265625f, -2173.101318359375f) + CustomPixelConsts_288.w)) + select(_79, 1.3302674293518066f, 0.7038120031356812f)), 0.0f), 1.0f);
//   float _107 = min(max((1.8993754386901855f - (8257.7998046875f / (CustomPixelConsts_288.w + 2575.28271484375f))), 0.0f), 1.0f);
//   float _126 = ((((lerp(_105, 1.0f, _92)) * _75) - _75) * 0.699999988079071f) + _75;
//   float _127 = ((((lerp(_106, 1.0f, _92)) * _76) - _76) * 0.699999988079071f) + _76;
//   float _128 = ((((lerp(_107, 1.0f, _92)) * _77) - _77) * 0.699999988079071f) + _77;
//   float _129 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_126, _127, _128));
//   float _132 = _129 / max(dot(float3(_126, _127, _128), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f)), 9.999999747378752e-06f);
//   float _152 = (TEXCOORD_2.x * 0.125f) * CustomPixelConsts_304.z;
//   float _155 = (TEXCOORD_2.y * 0.125f) * CustomPixelConsts_304.w;
//   float _157 = CustomPixelConsts_304.y * 10.0f;
//   float _158 = dot(float3(_152, _155, _157), float3(0.3333333432674408f, 0.3333333432674408f, 0.3333333432674408f));
//   float _162 = floor(_152 + _158);
//   float _163 = floor(_155 + _158);
//   float _164 = floor(_157 + _158);
//   float _168 = dot(float3(_162, _163, _164), float3(0.1666666716337204f, 0.1666666716337204f, 0.1666666716337204f));
//   float _169 = _168 + (_152 - _162);
//   float _170 = _168 + (_155 - _163);
//   float _171 = (_157 - _164) + _168;
//   float _175 = select((_169 < _170), 0.0f, 1.0f);
//   float _176 = select((_170 < _171), 0.0f, 1.0f);
//   float _177 = select((_171 < _169), 0.0f, 1.0f);
//   float _178 = 1.0f - _175;
//   float _179 = 1.0f - _176;
//   float _180 = 1.0f - _177;
//   float _181 = min(_175, _180);
//   float _182 = min(_176, _178);
//   float _183 = min(_177, _179);
//   float _184 = max(_175, _180);
//   float _185 = max(_176, _178);
//   float _186 = max(_177, _179);
//   float _190 = (_169 - _181) + 0.1666666716337204f;
//   float _191 = (_170 - _182) + 0.1666666716337204f;
//   float _192 = (_171 - _183) + 0.1666666716337204f;
//   float _196 = (_169 - _184) + 0.3333333432674408f;
//   float _197 = (_170 - _185) + 0.3333333432674408f;
//   float _198 = (_171 - _186) + 0.3333333432674408f;
//   float _199 = _169 + -0.5f;
//   float _200 = _170 + -0.5f;
//   float _201 = _171 + -0.5f;
//   float _211 = _162 - (floor(_162 * 0.0034602077212184668f) * 289.0f);
//   float _212 = _163 - (floor(_163 * 0.0034602077212184668f) * 289.0f);
//   float _213 = _164 - (floor(_164 * 0.0034602077212184668f) * 289.0f);
//   float _214 = _213 + _183;
//   float _215 = _213 + _186;
//   float _216 = _213 + 1.0f;
//   float _225 = ((_213 * 34.0f) + 10.0f) * _213;
//   float _226 = ((_214 * 34.0f) + 10.0f) * _214;
//   float _227 = ((_215 * 34.0f) + 10.0f) * _215;
//   float _228 = ((_216 * 34.0f) + 10.0f) * _216;
//   float _242 = (_225 - (floor(_225 * 0.0034602077212184668f) * 289.0f)) + _212;
//   float _245 = ((_212 + _182) - (floor(_226 * 0.0034602077212184668f) * 289.0f)) + _226;
//   float _248 = ((_212 + _185) - (floor(_227 * 0.0034602077212184668f) * 289.0f)) + _227;
//   float _251 = ((_212 + 1.0f) - (floor(_228 * 0.0034602077212184668f) * 289.0f)) + _228;
//   float _260 = ((_242 * 34.0f) + 10.0f) * _242;
//   float _261 = ((_245 * 34.0f) + 10.0f) * _245;
//   float _262 = ((_248 * 34.0f) + 10.0f) * _248;
//   float _263 = ((_251 * 34.0f) + 10.0f) * _251;
//   float _277 = (_260 - (floor(_260 * 0.0034602077212184668f) * 289.0f)) + _211;
//   float _280 = ((_211 + _181) - (floor(_261 * 0.0034602077212184668f) * 289.0f)) + _261;
//   float _283 = ((_211 + _184) - (floor(_262 * 0.0034602077212184668f) * 289.0f)) + _262;
//   float _286 = ((_211 + 1.0f) - (floor(_263 * 0.0034602077212184668f) * 289.0f)) + _263;
//   float _295 = ((_277 * 34.0f) + 10.0f) * _277;
//   float _296 = ((_280 * 34.0f) + 10.0f) * _280;
//   float _297 = ((_283 * 34.0f) + 10.0f) * _283;
//   float _298 = ((_286 * 34.0f) + 10.0f) * _286;
//   float _311 = _295 - (floor(_295 * 0.0034602077212184668f) * 289.0f);
//   float _312 = _296 - (floor(_296 * 0.0034602077212184668f) * 289.0f);
//   float _313 = _297 - (floor(_297 * 0.0034602077212184668f) * 289.0f);
//   float _314 = _298 - (floor(_298 * 0.0034602077212184668f) * 289.0f);
//   float _327 = _311 - (floor(_311 * 0.020408164709806442f) * 49.0f);
//   float _328 = _312 - (floor(_312 * 0.020408164709806442f) * 49.0f);
//   float _329 = _313 - (floor(_313 * 0.020408164709806442f) * 49.0f);
//   float _330 = _314 - (floor(_314 * 0.020408164709806442f) * 49.0f);
//   float _335 = floor(_327 * 0.1428571492433548f);
//   float _336 = floor(_328 * 0.1428571492433548f);
//   float _337 = floor(_329 * 0.1428571492433548f);
//   float _338 = floor(_330 * 0.1428571492433548f);
//   float _355 = (_335 * 0.2857142984867096f) + -0.9285714030265808f;
//   float _356 = (_336 * 0.2857142984867096f) + -0.9285714030265808f;
//   float _357 = (_337 * 0.2857142984867096f) + -0.9285714030265808f;
//   float _358 = (_338 * 0.2857142984867096f) + -0.9285714030265808f;
//   float _363 = (floor(_327 - (_335 * 7.0f)) * 0.2857142984867096f) + -0.9285714030265808f;
//   float _364 = (floor(_328 - (_336 * 7.0f)) * 0.2857142984867096f) + -0.9285714030265808f;
//   float _365 = (floor(_329 - (_337 * 7.0f)) * 0.2857142984867096f) + -0.9285714030265808f;
//   float _366 = (floor(_330 - (_338 * 7.0f)) * 0.2857142984867096f) + -0.9285714030265808f;
//   float _379 = (1.0f - abs(_355)) - abs(_363);
//   float _380 = (1.0f - abs(_356)) - abs(_364);
//   float _381 = (1.0f - abs(_357)) - abs(_365);
//   float _382 = (1.0f - abs(_358)) - abs(_366);
//   float _411 = select((_379 > 0.0f), -0.0f, -1.0f);
//   float _412 = select((_380 > 0.0f), -0.0f, -1.0f);
//   float _413 = select((_381 > 0.0f), -0.0f, -1.0f);
//   float _414 = select((_382 > 0.0f), -0.0f, -1.0f);
//   float _419 = (((floor(_355) * 2.0f) + 1.0f) * _411) + _355;
//   float _420 = (((floor(_363) * 2.0f) + 1.0f) * _411) + _363;
//   float _421 = (((floor(_356) * 2.0f) + 1.0f) * _412) + _356;
//   float _422 = (((floor(_364) * 2.0f) + 1.0f) * _412) + _364;
//   float _427 = (((floor(_357) * 2.0f) + 1.0f) * _413) + _357;
//   float _428 = (((floor(_365) * 2.0f) + 1.0f) * _413) + _365;
//   float _429 = (((floor(_358) * 2.0f) + 1.0f) * _414) + _358;
//   float _430 = (((floor(_366) * 2.0f) + 1.0f) * _414) + _366;
//   float _439 = 1.7928428649902344f - (dot(float3(_419, _420, _379), float3(_419, _420, _379)) * 0.8537347316741943f);
//   float _440 = 1.7928428649902344f - (dot(float3(_421, _422, _380), float3(_421, _422, _380)) * 0.8537347316741943f);
//   float _441 = 1.7928428649902344f - (dot(float3(_427, _428, _381), float3(_427, _428, _381)) * 0.8537347316741943f);
//   float _442 = 1.7928428649902344f - (dot(float3(_429, _430, _382), float3(_429, _430, _382)) * 0.8537347316741943f);
//   float _463 = max((0.5f - dot(float3(_169, _170, _171), float3(_169, _170, _171))), 0.0f);
//   float _464 = max((0.5f - dot(float3(_190, _191, _192), float3(_190, _191, _192))), 0.0f);
//   float _465 = max((0.5f - dot(float3(_196, _197, _198), float3(_196, _197, _198))), 0.0f);
//   float _466 = max((0.5f - dot(float3(_199, _200, _201), float3(_199, _200, _201))), 0.0f);
//   float _467 = _463 * _463;
//   float _468 = _464 * _464;
//   float _469 = _465 * _465;
//   float _470 = _466 * _466;
//   float _482 = (dot(float4((_467 * _467), (_468 * _468), (_469 * _469), (_470 * _470)), float4(dot(float3((_439 * _419), (_439 * _420), (_439 * _379)), float3(_169, _170, _171)), dot(float3((_440 * _421), (_440 * _422), (_440 * _380)), float3(_190, _191, _192)), dot(float3((_441 * _427), (_441 * _428), (_441 * _381)), float3(_196, _197, _198)), dot(float3((_442 * _429), (_442 * _430), (_442 * _382)), float3(_199, _200, _201)))) * 105.0f) * CustomPixelConsts_304.x;
//   float _522 = exp2(log2(((CustomPixelConsts_224.x * exp2(log2(abs(saturate(_482 + saturate((((_126 * _132) - _129) * CustomPixelConsts_288.z) + _129)))) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y)) * CustomPixelConsts_224.z);
//   float _523 = exp2(log2(((CustomPixelConsts_224.x * exp2(log2(abs(saturate(_482 + saturate((((_127 * _132) - _129) * CustomPixelConsts_288.z) + _129)))) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y)) * CustomPixelConsts_224.z);
//   float _524 = exp2(log2(((CustomPixelConsts_224.x * exp2(log2(abs(saturate(_482 + saturate((((_128 * _132) - _129) * CustomPixelConsts_288.z) + _129)))) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y)) * CustomPixelConsts_224.z);
//   float _525 = dot(float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f), float3(_522, _523, _524));
//   float _531 = saturate((_525 - CustomPixelConsts_160.x) * CustomPixelConsts_160.y);
//   float _536 = saturate((_525 - CustomPixelConsts_160.z) * CustomPixelConsts_160.w);
//   float _546 = CustomGammaDecode(_522);
//   float _547 = CustomGammaDecode(_523);
//   float _548 = CustomGammaDecode(_524);
//   float _549 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_546, _547, _548));
//   float _568 = ((CustomPixelConsts_176.x - CustomPixelConsts_192.x) * _531) + CustomPixelConsts_192.x;
//   float _569 = ((CustomPixelConsts_176.y - CustomPixelConsts_192.y) * _531) + CustomPixelConsts_192.y;
//   float _570 = ((CustomPixelConsts_176.z - CustomPixelConsts_192.z) * _531) + CustomPixelConsts_192.z;
//   float _571 = ((CustomPixelConsts_176.w - CustomPixelConsts_192.w) * _531) + CustomPixelConsts_192.w;
//   float _588 = ((CustomPixelConsts_208.w - _571) * _536) + _571;
//   float _617 = CustomPixelConsts_144.x * CustomGammaEncode(((_588 * (_546 - _549)) + _549) * (lerp(_568, CustomPixelConsts_208.x, _536)));
//   float _618 = CustomPixelConsts_144.y * CustomGammaEncode(((_588 * (_547 - _549)) + _549) * (lerp(_569, CustomPixelConsts_208.y, _536)));
//   float _619 = CustomPixelConsts_144.z * CustomGammaEncode(((_588 * (_548 - _549)) + _549) * (lerp(_570, CustomPixelConsts_208.z, _536)));
//   float _620 = TEXCOORD_2.x + -0.5f;
//   float _621 = TEXCOORD_2.y + -0.5f;
//   float _632 = saturate((((sqrt((_621 * _621) + (_620 * _620)) * 2.0f) + -0.550000011920929f) + CustomPixelConsts_112.w) * 1.2195122241973877f);
//   float _633 = _632 * _632;
//   float _657 = saturate((CustomPixelConsts_096.w * min(dot(float4(-0.10000000149011612f, -0.10499999672174454f, 1.1200000047683716f, 0.09000000357627869f), float4((_633 * _633), (_633 * _632), _633, _632)), 0.9399999976158142f)) * saturate(1.0f - dot(float3((pow(_617, 2.200000047683716f)), (pow(_618, 2.200000047683716f)), (pow(_619, 2.200000047683716f))), float3(CustomPixelConsts_096.x, CustomPixelConsts_096.y, CustomPixelConsts_096.z))));
//   float _673 = CustomPixelConsts_240.y - CustomPixelConsts_240.x;
//   SV_Target.x = ((lerp(_617, CustomPixelConsts_112.x, _657)) * _673) + CustomPixelConsts_240.x;
//   SV_Target.y = ((lerp(_618, CustomPixelConsts_112.y, _657)) * _673) + CustomPixelConsts_240.x;
//   SV_Target.z = ((lerp(_619, CustomPixelConsts_112.z, _657)) * _673) + CustomPixelConsts_240.x;
//   SV_Target.w = 1.0f;

//   SV_Target.xyz = CustomGammaEncode(CustomTonemap(CustomGammaDecode(SV_Target.xyz)));
//   //SV_Target.rgb *= 5;
//   return SV_Target;
// }

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _6 = t0.SampleLevel(s1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _43 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_6.x)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _44 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_6.y)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  float _45 = exp2(log2(max(0.0f, ((CustomPixelConsts_224.x * exp2(log2(abs(_6.z)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y))) * CustomPixelConsts_224.z);
  // float _43 = exp2(log2(((CustomPixelConsts_224.x * exp2(log2(abs(_6.x)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y)) * CustomPixelConsts_224.z);
  // float _44 = exp2(log2(((CustomPixelConsts_224.x * exp2(log2(abs(_6.y)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y)) * CustomPixelConsts_224.z);
  // float _45 = exp2(log2(((CustomPixelConsts_224.x * exp2(log2(abs(_6.z)) * CustomPixelConsts_128.x)) + CustomPixelConsts_224.y)) * CustomPixelConsts_224.z);
  float _46 = dot(float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f), float3(_43, _44, _45));
  float _52 = saturate((_46 - CustomPixelConsts_160.x) * CustomPixelConsts_160.y);
  float _57 = saturate((_46 - CustomPixelConsts_160.z) * CustomPixelConsts_160.w);
  // float _67 = exp2(log2(max(0.0f, _43)) * 2.200000047683716f);
  // float _68 = exp2(log2(max(0.0f, _44)) * 2.200000047683716f);
  // float _69 = exp2(log2(max(0.0f, _45)) * 2.200000047683716f);
  float _67 = CustomGammaDecode(_43);
  float _68 = CustomGammaDecode(_44);
  float _69 = CustomGammaDecode(_45);
  float3 ungraded = float3(_67, _68, _69);

  float _70 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_67, _68, _69));
  float _89 = ((CustomPixelConsts_176.x - CustomPixelConsts_192.x) * _52) + CustomPixelConsts_192.x;
  float _90 = ((CustomPixelConsts_176.y - CustomPixelConsts_192.y) * _52) + CustomPixelConsts_192.y;
  float _91 = ((CustomPixelConsts_176.z - CustomPixelConsts_192.z) * _52) + CustomPixelConsts_192.z;
  float _92 = ((CustomPixelConsts_176.w - CustomPixelConsts_192.w) * _52) + CustomPixelConsts_192.w;
  float _109 = ((CustomPixelConsts_208.w - _92) * _57) + _92;
  float _144 = CustomPixelConsts_240.y - CustomPixelConsts_240.x;
  // SV_Target.x = (((CustomPixelConsts_144.x * exp2(log2(max(0.0f, (((_109 * (_67 - _70)) + _70) * (lerp(_89, CustomPixelConsts_208.x, _57))))) * 0.4545454680919647f)) * _144) + CustomPixelConsts_240.x);
  // SV_Target.y = (((CustomPixelConsts_144.y * exp2(log2(max(0.0f, (((_109 * (_68 - _70)) + _70) * (lerp(_90, CustomPixelConsts_208.y, _57))))) * 0.4545454680919647f)) * _144) + CustomPixelConsts_240.x);
  // SV_Target.z = (((CustomPixelConsts_144.z * exp2(log2(max(0.0f, (((_109 * (_69 - _70)) + _70) * (lerp(_91, CustomPixelConsts_208.z, _57))))) * 0.4545454680919647f)) * _144) + CustomPixelConsts_240.x);
  SV_Target.x = (((CustomPixelConsts_144.x * CustomGammaEncode((((_109 * (_67 - _70)) + _70) * (lerp(_89, CustomPixelConsts_208.x, _57))))) * _144) + CustomPixelConsts_240.x);
  SV_Target.y = (((CustomPixelConsts_144.y * CustomGammaEncode((((_109 * (_68 - _70)) + _70) * (lerp(_90, CustomPixelConsts_208.y, _57))))) * _144) + CustomPixelConsts_240.x);
  SV_Target.z = (((CustomPixelConsts_144.z * CustomGammaEncode((((_109 * (_69 - _70)) + _70) * (lerp(_91, CustomPixelConsts_208.z, _57))))) * _144) + CustomPixelConsts_240.x);
  SV_Target.w = 1.0f;

  SV_Target.xyz = renodx::color::gamma::DecodeSafe(SV_Target.xyz);
  SV_Target.xyz = CustomColorGrading(ungraded, SV_Target.xyz);
  SV_Target.xyz = renodx::color::gamma::EncodeSafe(CustomTonemap(SV_Target.xyz));

  return SV_Target;
}
