#include "../../common.hlsli"
struct SExposureData {
  float SExposureData_000;
  float SExposureData_004;
  float SExposureData_008;
  float SExposureData_012;
  float SExposureData_016;
  float SExposureData_020;
};

StructuredBuffer<SExposureData> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

Texture2D<float4> t7 : register(t7);

Texture3D<float2> t8 : register(t8);

Texture2D<float4> t9 : register(t9);

cbuffer cb0 : register(b0) {
  float cb0_028x : packoffset(c028.x);
  float cb0_028z : packoffset(c028.z);
};

cbuffer cb1 : register(b1) {
  float cb1_018y : packoffset(c018.y);
  float cb1_018z : packoffset(c018.z);
  uint cb1_018w : packoffset(c018.w);
};

cbuffer cb2 : register(b2) {
  float cb2_000x : packoffset(c000.x);
  float cb2_000y : packoffset(c000.y);
  float cb2_000z : packoffset(c000.z);
  float cb2_015x : packoffset(c015.x);
  float cb2_015y : packoffset(c015.y);
  float cb2_015z : packoffset(c015.z);
  float cb2_015w : packoffset(c015.w);
  float cb2_016x : packoffset(c016.x);
  float cb2_016y : packoffset(c016.y);
  float cb2_016z : packoffset(c016.z);
  float cb2_016w : packoffset(c016.w);
  float cb2_017x : packoffset(c017.x);
  float cb2_017y : packoffset(c017.y);
  float cb2_017z : packoffset(c017.z);
  float cb2_017w : packoffset(c017.w);
  float cb2_018x : packoffset(c018.x);
  float cb2_018y : packoffset(c018.y);
  uint cb2_019x : packoffset(c019.x);
  uint cb2_019y : packoffset(c019.y);
  uint cb2_019z : packoffset(c019.z);
  uint cb2_019w : packoffset(c019.w);
  float cb2_020x : packoffset(c020.x);
  float cb2_020y : packoffset(c020.y);
  float cb2_020z : packoffset(c020.z);
  float cb2_020w : packoffset(c020.w);
  float cb2_021x : packoffset(c021.x);
  float cb2_021y : packoffset(c021.y);
  float cb2_021z : packoffset(c021.z);
  float cb2_021w : packoffset(c021.w);
  float cb2_022x : packoffset(c022.x);
  float cb2_023x : packoffset(c023.x);
  float cb2_023y : packoffset(c023.y);
  float cb2_023z : packoffset(c023.z);
  float cb2_023w : packoffset(c023.w);
  float cb2_024x : packoffset(c024.x);
  float cb2_024y : packoffset(c024.y);
  float cb2_024z : packoffset(c024.z);
  float cb2_024w : packoffset(c024.w);
  float cb2_025x : packoffset(c025.x);
  float cb2_025y : packoffset(c025.y);
  float cb2_025z : packoffset(c025.z);
  float cb2_025w : packoffset(c025.w);
  float cb2_026x : packoffset(c026.x);
  float cb2_026z : packoffset(c026.z);
  float cb2_026w : packoffset(c026.w);
  float cb2_027x : packoffset(c027.x);
  float cb2_027y : packoffset(c027.y);
  float cb2_027z : packoffset(c027.z);
  float cb2_027w : packoffset(c027.w);
  uint cb2_069y : packoffset(c069.y);
};

SamplerState s0_space2 : register(s0, space2);

SamplerState s2_space2 : register(s2, space2);

SamplerState s4_space2 : register(s4, space2);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
  linear float2 TEXCOORD0_centroid : TEXCOORD0_centroid,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace
) {
  float4 SV_Target;
  float4 SV_Target_1;
  float _24 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _29 = cb2_015x * TEXCOORD0_centroid.x;
  float _30 = cb2_015y * TEXCOORD0_centroid.y;
  float _33 = _29 + cb2_015z;
  float _34 = _30 + cb2_015w;
  float4 _35 = t7.SampleLevel(s0_space2, float2(_33, _34), 0.0f);
  float _39 = saturate(_35.x);
  float _40 = saturate(_35.z);
  float _43 = cb2_026x * _40;
  float _44 = _39 * 6.283199787139893f;
  float _45 = cos(_44);
  float _46 = sin(_44);
  float _47 = _43 * _45;
  float _48 = _46 * _43;
  float _49 = 1.0f - _35.y;
  float _50 = saturate(_49);
  float _51 = _47 * _50;
  float _52 = _48 * _50;
  float _53 = _51 + TEXCOORD0_centroid.x;
  float _54 = _52 + TEXCOORD0_centroid.y;
  float4 _55 = t1.SampleLevel(s4_space2, float2(_53, _54), 0.0f);
  float _59 = max(_55.x, 0.0f);
  float _60 = max(_55.y, 0.0f);
  float _61 = max(_55.z, 0.0f);
  float _62 = min(_59, 65000.0f);
  float _63 = min(_60, 65000.0f);
  float _64 = min(_61, 65000.0f);
  float4 _65 = t4.SampleLevel(s2_space2, float2(_53, _54), 0.0f);
  float _70 = max(_65.x, 0.0f);
  float _71 = max(_65.y, 0.0f);
  float _72 = max(_65.z, 0.0f);
  float _73 = max(_65.w, 0.0f);
  float _74 = min(_70, 5000.0f);
  float _75 = min(_71, 5000.0f);
  float _76 = min(_72, 5000.0f);
  float _77 = min(_73, 5000.0f);
  float _80 = _24.x * cb0_028z;
  float _81 = _80 + cb0_028x;
  float _82 = cb2_027w / _81;
  float _83 = 1.0f - _82;
  float _84 = abs(_83);
  float _86 = cb2_027y * _84;
  float _88 = _86 - cb2_027z;
  float _89 = saturate(_88);
  float _90 = max(_89, _77);
  float _91 = saturate(_90);
  float4 _92 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _96 = _74 - _62;
  float _97 = _75 - _63;
  float _98 = _76 - _64;
  float _99 = _91 * _96;
  float _100 = _91 * _97;
  float _101 = _91 * _98;
  float _102 = _99 + _62;
  float _103 = _100 + _63;
  float _104 = _101 + _64;
  float _105 = dot(float3(_102, _103, _104), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _109 = t0[0].SExposureData_020;
  float _111 = t0[0].SExposureData_004;
  float _113 = cb2_018x * 0.5f;
  float _114 = _113 * cb2_018y;
  float _115 = _111.x - _114;
  float _116 = cb2_018y * cb2_018x;
  float _117 = 1.0f / _116;
  float _118 = _115 * _117;
  float _119 = _105 / _109.x;
  float _120 = _119 * 5464.01611328125f;
  float _121 = _120 + 9.99999993922529e-09f;
  float _122 = log2(_121);
  float _123 = _122 - _115;
  float _124 = _123 * _117;
  float _125 = saturate(_124);
  float2 _126 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _125), 0.0f);
  float _129 = max(_126.y, 1.0000000116860974e-07f);
  float _130 = _126.x / _129;
  float _131 = _130 + _118;
  float _132 = _131 / _117;
  float _133 = _132 - _111.x;
  float _134 = -0.0f - _133;
  float _136 = _134 - cb2_027x;
  float _137 = max(0.0f, _136);
  float _139 = cb2_026z * _137;
  float _140 = _133 - cb2_027x;
  float _141 = max(0.0f, _140);
  float _143 = cb2_026w * _141;
  bool _144 = (_133 < 0.0f);
  float _145 = select(_144, _139, _143);
  float _146 = exp2(_145);
  float _147 = _146 * _102;
  float _148 = _146 * _103;
  float _149 = _146 * _104;
  float _154 = cb2_024y * _92.x;
  float _155 = cb2_024z * _92.y;
  float _156 = cb2_024w * _92.z;
  float _157 = _154 + _147;
  float _158 = _155 + _148;
  float _159 = _156 + _149;
  float _164 = _157 * cb2_025x;
  float _165 = _158 * cb2_025y;
  float _166 = _159 * cb2_025z;
  float _167 = dot(float3(_164, _165, _166), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _168 = t0[0].SExposureData_012;
  float _170 = _167 * 5464.01611328125f;
  float _171 = _170 * _168.x;
  float _172 = _171 + 9.99999993922529e-09f;
  float _173 = log2(_172);
  float _174 = _173 + 16.929765701293945f;
  float _175 = _174 * 0.05734497308731079f;
  float _176 = saturate(_175);
  float _177 = _176 * _176;
  float _178 = _176 * 2.0f;
  float _179 = 3.0f - _178;
  float _180 = _177 * _179;
  float _181 = _165 * 0.8450999855995178f;
  float _182 = _166 * 0.14589999616146088f;
  float _183 = _181 + _182;
  float _184 = _183 * 2.4890189170837402f;
  float _185 = _183 * 0.3754962384700775f;
  float _186 = _183 * 2.811495304107666f;
  float _187 = _183 * 5.519708156585693f;
  float _188 = _167 - _184;
  float _189 = _180 * _188;
  float _190 = _189 + _184;
  float _191 = _180 * 0.5f;
  float _192 = _191 + 0.5f;
  float _193 = _192 * _188;
  float _194 = _193 + _184;
  float _195 = _164 - _185;
  float _196 = _165 - _186;
  float _197 = _166 - _187;
  float _198 = _192 * _195;
  float _199 = _192 * _196;
  float _200 = _192 * _197;
  float _201 = _198 + _185;
  float _202 = _199 + _186;
  float _203 = _200 + _187;
  float _204 = 1.0f / _194;
  float _205 = _190 * _204;
  float _206 = _205 * _201;
  float _207 = _205 * _202;
  float _208 = _205 * _203;
  float _212 = cb2_020x * TEXCOORD0_centroid.x;
  float _213 = cb2_020y * TEXCOORD0_centroid.y;
  float _216 = _212 + cb2_020z;
  float _217 = _213 + cb2_020w;
  float _220 = dot(float2(_216, _217), float2(_216, _217));
  float _221 = 1.0f - _220;
  float _222 = saturate(_221);
  float _223 = log2(_222);
  float _224 = _223 * cb2_021w;
  float _225 = exp2(_224);
  float _229 = _206 - cb2_021x;
  float _230 = _207 - cb2_021y;
  float _231 = _208 - cb2_021z;
  float _232 = _229 * _225;
  float _233 = _230 * _225;
  float _234 = _231 * _225;
  float _235 = _232 + cb2_021x;
  float _236 = _233 + cb2_021y;
  float _237 = _234 + cb2_021z;
  float _238 = t0[0].SExposureData_000;
  float _240 = max(_109.x, 0.0010000000474974513f);
  float _241 = 1.0f / _240;
  float _242 = _241 * _238.x;
  bool _245 = ((uint)(cb2_069y) == 0);
  float _251;
  float _252;
  float _253;
  float _307;
  float _308;
  float _309;
  float _340;
  float _341;
  float _342;
  float _443;
  float _444;
  float _445;
  float _470;
  float _482;
  float _510;
  float _522;
  float _534;
  float _535;
  float _536;
  float _563;
  float _564;
  float _565;
  if (!_245) {
    float _247 = _242 * _235;
    float _248 = _242 * _236;
    float _249 = _242 * _237;
    _251 = _247;
    _252 = _248;
    _253 = _249;
  } else {
    _251 = _235;
    _252 = _236;
    _253 = _237;
  }
  float _254 = _251 * 0.6130970120429993f;
  float _255 = mad(0.33952298760414124f, _252, _254);
  float _256 = mad(0.04737899824976921f, _253, _255);
  float _257 = _251 * 0.07019399851560593f;
  float _258 = mad(0.9163540005683899f, _252, _257);
  float _259 = mad(0.013451999984681606f, _253, _258);
  float _260 = _251 * 0.02061600051820278f;
  float _261 = mad(0.10956999659538269f, _252, _260);
  float _262 = mad(0.8698149919509888f, _253, _261);
  float _263 = log2(_256);
  float _264 = log2(_259);
  float _265 = log2(_262);
  float _266 = _263 * 0.04211956635117531f;
  float _267 = _264 * 0.04211956635117531f;
  float _268 = _265 * 0.04211956635117531f;
  float _269 = _266 + 0.6252607107162476f;
  float _270 = _267 + 0.6252607107162476f;
  float _271 = _268 + 0.6252607107162476f;
  float4 _272 = t6.SampleLevel(s2_space2, float3(_269, _270, _271), 0.0f);
  bool _278 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_278 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _282 = cb2_017x * _272.x;
    float _283 = cb2_017x * _272.y;
    float _284 = cb2_017x * _272.z;
    float _286 = _282 + cb2_017y;
    float _287 = _283 + cb2_017y;
    float _288 = _284 + cb2_017y;
    float _289 = exp2(_286);
    float _290 = exp2(_287);
    float _291 = exp2(_288);
    float _292 = _289 + 1.0f;
    float _293 = _290 + 1.0f;
    float _294 = _291 + 1.0f;
    float _295 = 1.0f / _292;
    float _296 = 1.0f / _293;
    float _297 = 1.0f / _294;
    float _299 = cb2_017z * _295;
    float _300 = cb2_017z * _296;
    float _301 = cb2_017z * _297;
    float _303 = _299 + cb2_017w;
    float _304 = _300 + cb2_017w;
    float _305 = _301 + cb2_017w;
    _307 = _303;
    _308 = _304;
    _309 = _305;
  } else {
    _307 = _272.x;
    _308 = _272.y;
    _309 = _272.z;
  }
  float _310 = _307 * 23.0f;
  float _311 = _310 + -14.473931312561035f;
  float _312 = exp2(_311);
  float _313 = _308 * 23.0f;
  float _314 = _313 + -14.473931312561035f;
  float _315 = exp2(_314);
  float _316 = _309 * 23.0f;
  float _317 = _316 + -14.473931312561035f;
  float _318 = exp2(_317);
  float _325 = cb2_016x - _312;
  float _326 = cb2_016y - _315;
  float _327 = cb2_016z - _318;
  float _328 = _325 * cb2_016w;
  float _329 = _326 * cb2_016w;
  float _330 = _327 * cb2_016w;
  float _331 = _328 + _312;
  float _332 = _329 + _315;
  float _333 = _330 + _318;
  if (_278 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _336 = cb2_024x * _331;
    float _337 = cb2_024x * _332;
    float _338 = cb2_024x * _333;
    _340 = _336;
    _341 = _337;
    _342 = _338;
  } else {
    _340 = _331;
    _341 = _332;
    _342 = _333;
  }
  float _343 = _340 * 0.9708889722824097f;
  float _344 = mad(0.026962999254465103f, _341, _343);
  float _345 = mad(0.002148000057786703f, _342, _344);
  float _346 = _340 * 0.01088900025933981f;
  float _347 = mad(0.9869629740715027f, _341, _346);
  float _348 = mad(0.002148000057786703f, _342, _347);
  float _349 = mad(0.026962999254465103f, _341, _346);
  float _350 = mad(0.9621480107307434f, _342, _349);
  if (_278) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _355 = cb1_018y * 0.10000000149011612f;
        float _356 = log2(cb1_018z);
        float _357 = _356 + -13.287712097167969f;
        float _358 = _357 * 1.4929734468460083f;
        float _359 = _358 + 18.0f;
        float _360 = exp2(_359);
        float _361 = _360 * 0.18000000715255737f;
        float _362 = abs(_361);
        float _363 = log2(_362);
        float _364 = _363 * 1.5f;
        float _365 = exp2(_364);
        float _366 = _365 * _355;
        float _367 = _366 / cb1_018z;
        float _368 = _367 + -0.07636754959821701f;
        float _369 = _363 * 1.2750000953674316f;
        float _370 = exp2(_369);
        float _371 = _370 * 0.07636754959821701f;
        float _372 = cb1_018y * 0.011232397519052029f;
        float _373 = _372 * _365;
        float _374 = _373 / cb1_018z;
        float _375 = _371 - _374;
        float _376 = _370 + -0.11232396960258484f;
        float _377 = _376 * _355;
        float _378 = _377 / cb1_018z;
        float _379 = _378 * cb1_018z;
        float _380 = abs(_345);
        float _381 = abs(_348);
        float _382 = abs(_350);
        float _383 = log2(_380);
        float _384 = log2(_381);
        float _385 = log2(_382);
        float _386 = _383 * 1.5f;
        float _387 = _384 * 1.5f;
        float _388 = _385 * 1.5f;
        float _389 = exp2(_386);
        float _390 = exp2(_387);
        float _391 = exp2(_388);
        float _392 = _389 * _379;
        float _393 = _390 * _379;
        float _394 = _391 * _379;
        float _395 = _383 * 1.2750000953674316f;
        float _396 = _384 * 1.2750000953674316f;
        float _397 = _385 * 1.2750000953674316f;
        float _398 = exp2(_395);
        float _399 = exp2(_396);
        float _400 = exp2(_397);
        float _401 = _398 * _368;
        float _402 = _399 * _368;
        float _403 = _400 * _368;
        float _404 = _401 + _375;
        float _405 = _402 + _375;
        float _406 = _403 + _375;
        float _407 = _392 / _404;
        float _408 = _393 / _405;
        float _409 = _394 / _406;
        float _410 = _407 * 9.999999747378752e-05f;
        float _411 = _408 * 9.999999747378752e-05f;
        float _412 = _409 * 9.999999747378752e-05f;
        float _413 = 5000.0f / cb1_018y;
        float _414 = _410 * _413;
        float _415 = _411 * _413;
        float _416 = _412 * _413;
        _443 = _414;
        _444 = _415;
        _445 = _416;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_345, _348, _350));
      _443 = tonemapped.x, _444 = tonemapped.y, _445 = tonemapped.z;
    }
      } else {
        float _418 = _345 + 0.020616600289940834f;
        float _419 = _348 + 0.020616600289940834f;
        float _420 = _350 + 0.020616600289940834f;
        float _421 = _418 * _345;
        float _422 = _419 * _348;
        float _423 = _420 * _350;
        float _424 = _421 + -7.456949970219284e-05f;
        float _425 = _422 + -7.456949970219284e-05f;
        float _426 = _423 + -7.456949970219284e-05f;
        float _427 = _345 * 0.9837960004806519f;
        float _428 = _348 * 0.9837960004806519f;
        float _429 = _350 * 0.9837960004806519f;
        float _430 = _427 + 0.4336790144443512f;
        float _431 = _428 + 0.4336790144443512f;
        float _432 = _429 + 0.4336790144443512f;
        float _433 = _430 * _345;
        float _434 = _431 * _348;
        float _435 = _432 * _350;
        float _436 = _433 + 0.24617899954319f;
        float _437 = _434 + 0.24617899954319f;
        float _438 = _435 + 0.24617899954319f;
        float _439 = _424 / _436;
        float _440 = _425 / _437;
        float _441 = _426 / _438;
        _443 = _439;
        _444 = _440;
        _445 = _441;
      }
      float _446 = _443 * 1.6047500371932983f;
      float _447 = mad(-0.5310800075531006f, _444, _446);
      float _448 = mad(-0.07366999983787537f, _445, _447);
      float _449 = _443 * -0.10208000242710114f;
      float _450 = mad(1.1081299781799316f, _444, _449);
      float _451 = mad(-0.006049999967217445f, _445, _450);
      float _452 = _443 * -0.0032599999103695154f;
      float _453 = mad(-0.07275000214576721f, _444, _452);
      float _454 = mad(1.0760200023651123f, _445, _453);
      if (_278) {
        // float _456 = max(_448, 0.0f);
        // float _457 = max(_451, 0.0f);
        // float _458 = max(_454, 0.0f);
        // bool _459 = !(_456 >= 0.0030399328097701073f);
        // if (!_459) {
        //   float _461 = abs(_456);
        //   float _462 = log2(_461);
        //   float _463 = _462 * 0.4166666567325592f;
        //   float _464 = exp2(_463);
        //   float _465 = _464 * 1.0549999475479126f;
        //   float _466 = _465 + -0.054999999701976776f;
        //   _470 = _466;
        // } else {
        //   float _468 = _456 * 12.923210144042969f;
        //   _470 = _468;
        // }
        // bool _471 = !(_457 >= 0.0030399328097701073f);
        // if (!_471) {
        //   float _473 = abs(_457);
        //   float _474 = log2(_473);
        //   float _475 = _474 * 0.4166666567325592f;
        //   float _476 = exp2(_475);
        //   float _477 = _476 * 1.0549999475479126f;
        //   float _478 = _477 + -0.054999999701976776f;
        //   _482 = _478;
        // } else {
        //   float _480 = _457 * 12.923210144042969f;
        //   _482 = _480;
        // }
        // bool _483 = !(_458 >= 0.0030399328097701073f);
        // if (!_483) {
        //   float _485 = abs(_458);
        //   float _486 = log2(_485);
        //   float _487 = _486 * 0.4166666567325592f;
        //   float _488 = exp2(_487);
        //   float _489 = _488 * 1.0549999475479126f;
        //   float _490 = _489 + -0.054999999701976776f;
        //   _563 = _470;
        //   _564 = _482;
        //   _565 = _490;
        // } else {
        //   float _492 = _458 * 12.923210144042969f;
        //   _563 = _470;
        //   _564 = _482;
        //   _565 = _492;
        // }
        _563 = renodx::color::srgb::EncodeSafe(_448);
        _564 = renodx::color::srgb::EncodeSafe(_451);
        _565 = renodx::color::srgb::EncodeSafe(_454);

      } else {
        float _494 = saturate(_448);
        float _495 = saturate(_451);
        float _496 = saturate(_454);
        bool _497 = ((uint)(cb1_018w) == -2);
        if (!_497) {
          bool _499 = !(_494 >= 0.0030399328097701073f);
          if (!_499) {
            float _501 = abs(_494);
            float _502 = log2(_501);
            float _503 = _502 * 0.4166666567325592f;
            float _504 = exp2(_503);
            float _505 = _504 * 1.0549999475479126f;
            float _506 = _505 + -0.054999999701976776f;
            _510 = _506;
          } else {
            float _508 = _494 * 12.923210144042969f;
            _510 = _508;
          }
          bool _511 = !(_495 >= 0.0030399328097701073f);
          if (!_511) {
            float _513 = abs(_495);
            float _514 = log2(_513);
            float _515 = _514 * 0.4166666567325592f;
            float _516 = exp2(_515);
            float _517 = _516 * 1.0549999475479126f;
            float _518 = _517 + -0.054999999701976776f;
            _522 = _518;
          } else {
            float _520 = _495 * 12.923210144042969f;
            _522 = _520;
          }
          bool _523 = !(_496 >= 0.0030399328097701073f);
          if (!_523) {
            float _525 = abs(_496);
            float _526 = log2(_525);
            float _527 = _526 * 0.4166666567325592f;
            float _528 = exp2(_527);
            float _529 = _528 * 1.0549999475479126f;
            float _530 = _529 + -0.054999999701976776f;
            _534 = _510;
            _535 = _522;
            _536 = _530;
          } else {
            float _532 = _496 * 12.923210144042969f;
            _534 = _510;
            _535 = _522;
            _536 = _532;
          }
        } else {
          _534 = _494;
          _535 = _495;
          _536 = _496;
        }
        float _541 = abs(_534);
        float _542 = abs(_535);
        float _543 = abs(_536);
        float _544 = log2(_541);
        float _545 = log2(_542);
        float _546 = log2(_543);
        float _547 = _544 * cb2_000z;
        float _548 = _545 * cb2_000z;
        float _549 = _546 * cb2_000z;
        float _550 = exp2(_547);
        float _551 = exp2(_548);
        float _552 = exp2(_549);
        float _553 = _550 * cb2_000y;
        float _554 = _551 * cb2_000y;
        float _555 = _552 * cb2_000y;
        float _556 = _553 + cb2_000x;
        float _557 = _554 + cb2_000x;
        float _558 = _555 + cb2_000x;
        float _559 = saturate(_556);
        float _560 = saturate(_557);
        float _561 = saturate(_558);
        _563 = _559;
        _564 = _560;
        _565 = _561;
      }
      float _569 = cb2_023x * TEXCOORD0_centroid.x;
      float _570 = cb2_023y * TEXCOORD0_centroid.y;
      float _573 = _569 + cb2_023z;
      float _574 = _570 + cb2_023w;
      float4 _577 = t9.SampleLevel(s0_space2, float2(_573, _574), 0.0f);
      float _579 = _577.x + -0.5f;
      float _580 = _579 * cb2_022x;
      float _581 = _580 + 0.5f;
      float _582 = _581 * 2.0f;
      float _583 = _582 * _563;
      float _584 = _582 * _564;
      float _585 = _582 * _565;
      float _589 = float((uint)(cb2_019z));
      float _590 = float((uint)(cb2_019w));
      float _591 = _589 + SV_Position.x;
      float _592 = _590 + SV_Position.y;
      uint _593 = uint(_591);
      uint _594 = uint(_592);
      uint _597 = cb2_019x + -1u;
      uint _598 = cb2_019y + -1u;
      int _599 = _593 & _597;
      int _600 = _594 & _598;
      float4 _601 = t3.Load(int3(_599, _600, 0));
      float _605 = _601.x * 2.0f;
      float _606 = _601.y * 2.0f;
      float _607 = _601.z * 2.0f;
      float _608 = _605 + -1.0f;
      float _609 = _606 + -1.0f;
      float _610 = _607 + -1.0f;
      float _611 = _608 * cb2_025w;
      float _612 = _609 * cb2_025w;
      float _613 = _610 * cb2_025w;
      float _614 = _611 + _583;
      float _615 = _612 + _584;
      float _616 = _613 + _585;
      float _617 = dot(float3(_614, _615, _616), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _614;
      SV_Target.y = _615;
      SV_Target.z = _616;
      SV_Target.w = _617;
      SV_Target_1.x = _617;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
