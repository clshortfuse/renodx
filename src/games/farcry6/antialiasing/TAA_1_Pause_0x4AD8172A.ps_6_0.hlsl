#include "../shared.h"

Texture2D<float2> t0 : register(t0);

Texture2D<float2> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture2D<float> t5 : register(t5);

Texture2D<float> t6 : register(t6);

Texture2D<float> t7 : register(t7);

cbuffer cb0 : register(b0) {
  float cb0_011x : packoffset(c011.x);
  float cb0_011y : packoffset(c011.y);
  float cb0_011z : packoffset(c011.z);
  float cb0_011w : packoffset(c011.w);
};

SamplerState s2_space2 : register(s2, space2);

SamplerState s5_space2 : register(s5, space2);

// clang-format off
#define INFINITY +1.#INF
// clang-format on

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
    linear float2 TEXCOORD0_centroid: TEXCOORD0_centroid,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_IsFrontFace: SV_IsFrontFace) {
  float4 SV_Target;
  float4 SV_Target_1;
  float2 _14 = t0.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _17 = _14.x + -0.49803921580314636f;
  float _18 = _17 * 2.0f;
  bool _19 = (_18 < -0.6687403321266174f);
  float _38;
  float _61;
  float _207;
  float _229;
  if (_19) {
    float _21 = _17 * 4.830047130584717f;
    float _22 = _21 + 1.415023684501648f;
    _38 = _22;
  } else {
    bool _24 = (_18 < 0.6687403321266174f);
    if (_24) {
      float _26 = _17 * INFINITY;
      float _27 = _26 + 0.5f;
      float _28 = saturate(_27);
      float _29 = _28 * 2.0f;
      float _30 = _29 + -1.0f;
      float _31 = _18 * _18;
      float _32 = _31 * _31;
      float _33 = _32 * _30;
      _38 = _33;
    } else {
      float _35 = _17 * 4.830047130584717f;
      float _36 = _35 + -1.415023684501648f;
      _38 = _36;
    }
  }
  float _39 = _38 * 0.10000000149011612f;
  float _40 = _14.y + -0.49803921580314636f;
  float _41 = _40 * 2.0f;
  bool _42 = (_41 < -0.6687403321266174f);
  if (_42) {
    float _44 = _40 * 4.830047130584717f;
    float _45 = _44 + 1.415023684501648f;
    _61 = _45;
  } else {
    bool _47 = (_41 < 0.6687403321266174f);
    if (_47) {
      float _49 = _40 * INFINITY;
      float _50 = _49 + 0.5f;
      float _51 = saturate(_50);
      float _52 = _51 * 2.0f;
      float _53 = _52 + -1.0f;
      float _54 = _41 * _41;
      float _55 = _54 * _54;
      float _56 = _55 * _53;
      _61 = _56;
    } else {
      float _58 = _40 * 4.830047130584717f;
      float _59 = _58 + -1.415023684501648f;
      _61 = _59;
    }
  }
  float _62 = _61 * 0.10000000149011612f;

  // Sample the scene
  float4 _63 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(-1, -1));
  float4 _68 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(0, -1));
  float4 _73 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(1, -1));
  float4 _78 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(-1, 0));
  float4 _83 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _88 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(1, 0));
  float4 _93 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(-1, 1));
  float4 _98 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(0, 1));
  float4 _103 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(1, 1));

  float _108 = min(_98.x, _103.x);
  float _109 = min(_93.x, _108);
  float _110 = min(_98.y, _103.y);
  float _111 = min(_93.y, _110);
  float _112 = min(_98.z, _103.z);
  float _113 = min(_93.z, _112);
  float _114 = min(_98.w, _103.w);
  float _115 = min(_93.w, _114);
  float _116 = min(_88.x, _109);
  float _117 = min(_83.x, _116);
  float _118 = min(_88.y, _111);
  float _119 = min(_83.y, _118);
  float _120 = min(_88.z, _113);
  float _121 = min(_83.z, _120);
  float _122 = min(_88.w, _115);
  float _123 = min(_83.w, _122);
  float _124 = min(_78.x, _117);
  float _125 = min(_73.x, _124);
  float _126 = min(_78.y, _119);
  float _127 = min(_73.y, _126);
  float _128 = min(_78.z, _121);
  float _129 = min(_73.z, _128);
  float _130 = min(_78.w, _123);
  float _131 = min(_73.w, _130);
  float _132 = min(_68.x, _125);
  float _133 = min(_63.x, _132);
  float _134 = min(_68.y, _127);
  float _135 = min(_63.y, _134);
  float _136 = min(_68.z, _129);
  float _137 = min(_63.z, _136);
  float _138 = min(_68.w, _131);
  float _139 = min(_63.w, _138);
  float _140 = max(_98.x, _103.x);
  float _141 = max(_93.x, _140);
  float _142 = max(_98.y, _103.y);
  float _143 = max(_93.y, _142);
  float _144 = max(_98.z, _103.z);
  float _145 = max(_93.z, _144);
  float _146 = max(_98.w, _103.w);
  float _147 = max(_93.w, _146);
  float _148 = max(_88.x, _141);
  float _149 = max(_83.x, _148);
  float _150 = max(_88.y, _143);
  float _151 = max(_83.y, _150);
  float _152 = max(_88.z, _145);
  float _153 = max(_83.z, _152);
  float _154 = max(_88.w, _147);
  float _155 = max(_83.w, _154);
  float _156 = max(_78.x, _149);
  float _157 = max(_73.x, _156);
  float _158 = max(_78.y, _151);
  float _159 = max(_73.y, _158);
  float _160 = max(_78.z, _153);
  float _161 = max(_73.z, _160);
  float _162 = max(_78.w, _155);
  float _163 = max(_73.w, _162);
  float _164 = max(_68.x, _157);
  float _165 = max(_63.x, _164);
  float _166 = max(_68.y, _159);
  float _167 = max(_63.y, _166);
  float _168 = max(_68.z, _161);
  float _169 = max(_63.z, _168);
  float _170 = max(_68.w, _163);
  float _171 = max(_63.w, _170);
  float _172 = _39 + TEXCOORD0_centroid.x;
  float _173 = _62 + TEXCOORD0_centroid.y;

  // Sample the previous frame?
  float4 _174 = t3.SampleLevel(s2_space2, float2(_172, _173), 0.0f);
  float4 _179 = t4.SampleLevel(s2_space2, float2(_172, _173), 0.0f);

  float2 _183 = t1.SampleLevel(s2_space2, float2(_172, _173), 0.0f);
  float _186 = _183.x + -0.49803921580314636f;
  float _187 = _186 * 2.0f;
  bool _188 = (_187 < -0.6687403321266174f);
  if (_188) {
    float _190 = _186 * 4.830047130584717f;
    float _191 = _190 + 1.415023684501648f;
    _207 = _191;
  } else {
    bool _193 = (_187 < 0.6687403321266174f);
    if (_193) {
      float _195 = _186 * INFINITY;
      float _196 = _195 + 0.5f;
      float _197 = saturate(_196);
      float _198 = _197 * 2.0f;
      float _199 = _198 + -1.0f;
      float _200 = _187 * _187;
      float _201 = _200 * _200;
      float _202 = _201 * _199;
      _207 = _202;
    } else {
      float _204 = _186 * 4.830047130584717f;
      float _205 = _204 + -1.415023684501648f;
      _207 = _205;
    }
  }
  float _208 = _183.y + -0.49803921580314636f;
  float _209 = _208 * 2.0f;
  bool _210 = (_209 < -0.6687403321266174f);
  if (_210) {
    float _212 = _208 * 4.830047130584717f;
    float _213 = _212 + 1.415023684501648f;
    _229 = _213;
  } else {
    bool _215 = (_209 < 0.6687403321266174f);
    if (_215) {
      float _217 = _208 * INFINITY;
      float _218 = _217 + 0.5f;
      float _219 = saturate(_218);
      float _220 = _219 * 2.0f;
      float _221 = _220 + -1.0f;
      float _222 = _209 * _209;
      float _223 = _222 * _222;
      float _224 = _223 * _221;
      _229 = _224;
    } else {
      float _226 = _208 * 4.830047130584717f;
      float _227 = _226 + -1.415023684501648f;
      _229 = _227;
    }
  }
  float _230 = _207 - _38;
  float _231 = _230 * 0.10000000149011612f;
  float _232 = _229 - _61;
  float _233 = _232 * 0.10000000149011612f;
  float _234 = _231 * _231;
  float _235 = _233 * _233;
  float _236 = _235 + _234;
  float _237 = sqrt(_236);
  float _238 = _237 * 32.0f;
  float _239 = 1.0f - _238;
  float _240 = saturate(_239);
  float _241 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _243 = t7.SampleLevel(s2_space2, float2(_172, _173), 0.0f);
  float _245 = max(_241.x, _243.x);
  float _246 = _240 - _245;
  float _247 = saturate(_246);
  float _248 = _165 - _133;
  float _249 = _167 - _135;
  float _250 = _169 - _137;
  float _253 = cb0_011x * _248;
  float _254 = cb0_011x * _249;
  float _255 = cb0_011x * _250;
  float _256 = _133 - _253;
  float _257 = _135 - _254;
  float _258 = _137 - _255;
  float _259 = max(_256, 0.0f);
  float _260 = max(_257, 0.0f);
  float _261 = max(_258, 0.0f);
  float _262 = _259 - _179.x;
  float _263 = _260 - _179.y;
  float _264 = _261 - _179.z;
  float _265 = saturate(_262);
  float _266 = saturate(_263);
  float _267 = saturate(_264);
  float _268 = _179.x - _165;
  float _269 = _268 - _253;
  float _270 = _179.y - _167;
  float _271 = _270 - _254;
  float _272 = _179.z - _169;
  float _273 = _272 - _255;
  float _274 = saturate(_269);
  float _275 = saturate(_271);
  float _276 = saturate(_273);
  float _277 = _274 + _265;
  float _278 = _275 + _266;
  float _279 = _276 + _267;
  float _280 = max(_179.x, _133);
  float _281 = max(_179.y, _135);
  float _282 = max(_179.z, _137);
  float _283 = min(_165, _280);
  float _284 = min(_167, _281);
  float _285 = min(_169, _282);
  float _286 = max(_174.x, _133);
  float _287 = max(_174.y, _135);
  float _288 = max(_174.z, _137);
  float _289 = min(_165, _286);
  float _290 = min(_167, _287);
  float _291 = min(_169, _288);
  float _292 = t5.SampleLevel(s2_space2, float2(_172, _173), 0.0f);
  float _294 = max(_292.x, _139);
  float _295 = min(_171, _294);
  float _296 = max(_174.w, _139);
  float _297 = min(_171, _296);
  float _298 = _83.x - _179.x;
  float _299 = _83.y - _179.y;
  float _300 = _83.z - _179.z;
  float _301 = abs(_298);
  float _302 = abs(_299);
  float _303 = abs(_300);
  float _304 = _301 * _301;
  float _305 = _302 * _302;
  float _306 = _305 + _304;
  float _307 = _303 * _303;
  float _308 = _306 + _307;
  float _309 = sqrt(_308);
  float _310 = _277 * _277;
  float _311 = _278 * _278;
  float _312 = _311 + _310;
  float _313 = _279 * _279;
  float _314 = _312 + _313;
  float _315 = sqrt(_314);
  float _318 = cb0_011z * _309;
  float _319 = cb0_011w * _315;
  float _320 = _318 - _319;
  float _321 = max(_320, 0.0f);
  float _322 = _321 + 0.0010000000474974513f;
  float _323 = 1.0f / _322;
  float _324 = saturate(_323);
  float _326 = max(cb0_011y, _324);
  bool _327 = (_172 > 1.0f);
  bool _328 = (_172 < 0.0f);
  bool _329 = _328 || _327;
  bool _330 = (_173 > 1.0f);
  bool _331 = _329 || _330;
  bool _332 = (_173 < 0.0f);
  bool _333 = _332 || _331;
  float _334 = select(_333, 0.0f, 1.0f);
  float _335 = _326 + 1.0f;
  float _336 = select(_333, 2.0f, _335);
  float _337 = _336 - _247;
  float _338 = saturate(_337);
  float _339 = _247 * _334;

  // squaring the color values?
  // float _340 = _83.x * _83.x;
  // float _341 = _83.y * _83.y;
  // float _342 = _83.z * _83.z;
  // float _343 = _283 * _283;
  // float _344 = _284 * _284;
  // float _345 = _285 * _285;
  // float _346 = _289 * _289;
  // float _347 = _290 * _290;
  // float _348 = _291 * _291;
  float _340 = sign(_83.x) * abs(_83.x) * abs(_83.x);
  float _341 = sign(_83.y) * abs(_83.y) * abs(_83.y);
  float _342 = sign(_83.z) * abs(_83.z) * abs(_83.z);
  float _343 = sign(_283) * abs(_283) * abs(_283);
  float _344 = sign(_284) * abs(_284) * abs(_284);
  float _345 = sign(_285) * abs(_285) * abs(_285);
  float _346 = sign(_289) * abs(_289) * abs(_289);
  float _347 = sign(_290) * abs(_290) * abs(_290);
  float _348 = sign(_291) * abs(_291) * abs(_291);

  float _349 = _339 * 0.5f;
  float _350 = _346 - _340;
  float _351 = _347 - _341;
  float _352 = _348 - _342;
  float _353 = _350 * _349;
  float _354 = _351 * _349;
  float _355 = _352 * _349;
  float _356 = _353 + _340;
  float _357 = _354 + _341;
  float _358 = _355 + _342;
  float _359 = _338 * _356;
  float _360 = _338 * _357;
  float _361 = _338 * _358;
  float _362 = 1.0f - _338;
  float _363 = _343 * _362;
  float _364 = _344 * _362;
  float _365 = _345 * _362;
  float _366 = _363 + _359;
  float _367 = _364 + _360;
  float _368 = _365 + _361;


  // float _369 = sqrt(_366);
  // float _370 = sqrt(_367);
  // float _371 = sqrt(_368);
  float _369 = renodx::math::SignSqrt(_366);
  float _370 = renodx::math::SignSqrt(_367);
  float _371 = renodx::math::SignSqrt(_368);
   

  float _372 = _297 - _83.w;
  float _373 = _349 * _372;
  float _374 = _373 + _83.w;
  float _375 = _338 * _374;
  float _376 = _362 * _295;
  float _377 = _376 + _375;
  SV_Target.x = _369;
  SV_Target.y = _370;
  SV_Target.z = _371;
  SV_Target.w = 1.0f;
  SV_Target_1.x = _377;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;

  // SV_Target.rgb = renodx::color::bt709::from::BT2020(SV_Target.rgb);

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
