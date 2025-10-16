#include "./shared.h"

Texture2D<float4> t0 : register(t0);

RWTexture2D<float3> u0 : register(u0);

// clang-format off
cbuffer cb6 : register(b6) {
  struct S_cbCAS {
    int4 S_cbCAS_000;
    int4 S_cbCAS_016;
    float4 S_cbCAS_032;
  } _cbCAS_000 : packoffset(c000.x);
};
// clang-format on

[numthreads(64, 1, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  int _7, _8, _9, _10, _11, _12, _15, _16, _147, _254;
  uint _13, _14;

  if (CUSTOM_SHARPENING == 0.f) {
    _7 = (uint)(SV_GroupThreadID.x) >> 1;
    _8 = _7 & 7;
    _9 = (uint)(SV_GroupThreadID.x) >> 3;
    _10 = (uint)(SV_GroupThreadID.x) & 1;
    _11 = _9 & 6;
    _12 = _11 | _10;
    _13 = (uint)(SV_GroupID.x) << 4;
    _14 = (uint)(SV_GroupID.y) << 4;
    _15 = _8 | _13;
    _16 = _12 | _14;
    _147 = _15 | 8;
    _254 = _16 | 8;

    u0[int2(_15, _16)] = t0.Load(int3(_15, _16, 0)).xyz;
    u0[int2(_147, _16)] = t0.Load(int3(_147, _16, 0)).xyz;
    u0[int2(_147, _254)] = t0.Load(int3(_147, _254, 0)).xyz;
    u0[int2(_15, _254)] = t0.Load(int3(_15, _254, 0)).xyz;
    return;
  } else if (CUSTOM_SHARPENING == 2.f) {
    _7 = (uint)(SV_GroupThreadID.x) >> 1;
    _8 = _7 & 7;
    _9 = (uint)(SV_GroupThreadID.x) >> 3;
    _10 = (uint)(SV_GroupThreadID.x) & 1;
    _11 = _9 & 6;
    _12 = _11 | _10;
    _13 = (uint)(SV_GroupID.x) << 4;
    _14 = (uint)(SV_GroupID.y) << 4;
    _15 = _8 | _13;
    _16 = _12 | _14;
    _147 = _15 | 8;
    _254 = _16 | 8;

    const float normalization_point = 100.f;
    const int2 coords[4] = {
      int2(_15, _16),
      int2(_147, _16),
      int2(_147, _254),
      int2(_15, _254)
    };

    uint tex_width, tex_height;
    t0.GetDimensions(tex_width, tex_height);
    int2 tex_max = int2(tex_width - 1, tex_height - 1);

    // from Lilium
    // RCAS - Robust Contrast Adaptive Sharpening
    [unroll]
    for (int i = 0; i < 4; ++i) {
      int2 coord = coords[i];

      // Algorithm uses minimal 3x3 pixel neighborhood.
      //    b
      //  d e f
      //    h

      float3 b = t0.Load(int3(clamp(coord + int2(0, -1), int2(0, 0), tex_max), 0)).rgb / normalization_point;
      float3 d = t0.Load(int3(clamp(coord + int2(-1, 0), int2(0, 0), tex_max), 0)).rgb / normalization_point;
      float3 e = t0.Load(int3(clamp(coord, int2(0, 0), tex_max), 0)).rgb / normalization_point;
      float3 f = t0.Load(int3(clamp(coord + int2(1, 0), int2(0, 0), tex_max), 0)).rgb / normalization_point;
      float3 h = t0.Load(int3(clamp(coord + int2(0, 1), int2(0, 0), tex_max), 0)).rgb / normalization_point;

      // Immediate constants for peak range.
      static const float2 peak_c = float2(1.f, -4.f);

      // Calculate luminance of center and neighbors
      float b_lum = renodx::color::y::from::BT709(b);
      float d_lum = renodx::color::y::from::BT709(d);
      float e_lum = renodx::color::y::from::BT709(e);
      float f_lum = renodx::color::y::from::BT709(f);
      float h_lum = renodx::color::y::from::BT709(h);

      // Min and max of ring.
      float min4_lum = renodx::math::Min(b_lum, d_lum, f_lum, h_lum);
      float max4_lum = renodx::math::Max(b_lum, d_lum, f_lum, h_lum);

      // 0.99 found through testing -> see my latest desmos or https://www.desmos.com/calculator/4dyqhishpl
      // this helps reducing massive overshoot that would happen otherwise
      // normal CAS applies a limiter too so that there is no overshoot
      float limited_max4_lum = min(max4_lum, 0.99f);

      float hit_min_lum = min4_lum * rcp(4.f * limited_max4_lum);
      float hit_max_lum = (peak_c.x - limited_max4_lum) * rcp(4.f * min4_lum + peak_c.y);
      float local_lobe = max(-hit_min_lum, hit_max_lum);

// This is set at the limit of providing unnatural results for sharpening.
// 0.25f - (1.f / 16.f)
#define FSR_RCAS_LIMIT 0.1875f

      const float sharpness_strength = 0.5f;
      float sharpness = exp2(-(1.0f - sharpness_strength));
      float lobe = max(float(-FSR_RCAS_LIMIT), min(local_lobe, 0.f)) * sharpness;

      // Noise detection.
      float b_luma_2x = b_lum * 2.f;
      float d_luma_2x = d_lum * 2.f;
      float e_luma_2x = e_lum * 2.f;
      float f_luma_2x = f_lum * 2.f;
      float h_luma_2x = h_lum * 2.f;

      float nz = 0.25f * b_luma_2x
                 + 0.25f * d_luma_2x
                 + 0.25f * f_luma_2x
                 + 0.25f * h_luma_2x
                 - e_luma_2x;

      float max_luma_2x = renodx::math::Max(renodx::math::Max(b_luma_2x, d_luma_2x, e_luma_2x), f_luma_2x, h_luma_2x);
      float min_luma_2x = renodx::math::Min(renodx::math::Min(b_luma_2x, d_luma_2x, e_luma_2x), f_luma_2x, h_luma_2x);

      nz = saturate(abs(nz) * rcp(max_luma_2x - min_luma_2x));
      nz = -0.5f * nz + 1.f;

      lobe *= nz;

      // Resolve, which needs the medium precision rcp approximation to avoid visible tonality changes.
      float rcp_l = rcp(4.f * lobe + 1.f);
      float pix_lum = ((b_lum + d_lum + h_lum + f_lum) * lobe + e_lum) * rcp_l;
      float3 sharpened = clamp(pix_lum / e_lum, 0.f, 4.f) * e;

      u0[coord] = sharpened * normalization_point;
    }
    return;
  }
  _7 = (uint)(SV_GroupThreadID.x) >> 1;
  _8 = _7 & 7;
  _9 = (uint)(SV_GroupThreadID.x) >> 3;
  _10 = (uint)(SV_GroupThreadID.x) & 1;
  _11 = _9 & 6;
  _12 = _11 | _10;
  _13 = (uint)(SV_GroupID.x) << 4;
  _14 = (uint)(SV_GroupID.y) << 4;
  _15 = _8 | _13;
  _16 = _12 | _14;
  float _19 = asfloat(_cbCAS_000.S_cbCAS_000.x);
  float _21 = asfloat(_cbCAS_000.S_cbCAS_000.y);
  float _24 = asfloat(_cbCAS_000.S_cbCAS_000.z);
  float _25 = asfloat(_cbCAS_000.S_cbCAS_000.w);
  float _28 = asfloat(_cbCAS_000.S_cbCAS_016.x);
  float _29 = saturate(_19);
  float _30 = _29 * 3.0f;
  float _31 = 8.0f - _30;
  float _32 = 1.0f / _31;
  float _33 = -0.0f - _32;
  float _34 = float((uint)_15);
  float _35 = float((uint)_16);
  float _36 = _34 + 0.5f;
  float _37 = _35 + 0.5f;
  float _38 = _24 * _36;
  float _39 = _25 * _37;
  float _40 = mad(_38, 2.0f, -1.0f);
  float _41 = mad(_39, 2.0f, -1.0f);
  float _42 = dot(float2(_40, _41), float2(_40, _41));
  float _43 = 1.0f - _42;
  float _44 = saturate(_43);
  float _45 = log2(_44);
  float _46 = _45 * _21;
  float _47 = exp2(_46);
  float _48 = saturate(_28);
  float _49 = _47 + -1.0f;
  float _50 = _48 * _49;
  float _51 = _50 + 1.0f;
  uint _52 = _16 + -1u;
  float4 _53 = t0.Load(int3(_15, _52, 0));
  float _57 = _53.y * 0.10000000149011612f;
  uint _58 = _15 + -1u;
  float4 _59 = t0.Load(int3(_58, _16, 0));
  float _63 = _59.y * 0.10000000149011612f;
  float4 _64 = t0.Load(int3(_15, _16, 0));
  float _68 = _64.y * 0.10000000149011612f;
  int _69 = _15 + 1;
  float4 _70 = t0.Load(int3(_69, _16, 0));
  float _74 = _70.y * 0.10000000149011612f;
  int _75 = _16 + 1;
  float4 _76 = t0.Load(int3(_15, _75, 0));
  float _80 = _76.y * 0.10000000149011612f;
  float _81 = min(_68, _74);
  float _82 = min(_63, _81);
  float _83 = min(_57, _80);
  float _84 = min(_82, _83);
  float _85 = max(_68, _74);
  float _86 = max(_63, _85);
  float _87 = max(_57, _80);
  float _88 = max(_86, _87);
  int _89 = asint(_88);
  uint _90 = 2129690299u - _89;
  float _91 = asfloat(_90);
  float _92 = 1.0f - _88;
  float _93 = min(_84, _92);
  float _94 = _91 * _93;
  float _95 = saturate(_94);
  int _96 = asint(_95);
  int _97 = (uint)(_96) >> 1;
  uint _98 = _97 + 532432441u;
  float _99 = asfloat(_98);
  float _100 = _99 * _33;
  float _101 = _100 * 4.0f;
  float _102 = _101 + 1.0f;
  int _103 = asint(_102);
  uint _104 = 2129764351u - _103;
  float _105 = asfloat(_104);
  float _106 = _105 * _102;
  float _107 = 2.0f - _106;
  float _108 = _107 * _105;
  float _109 = _59.x + _53.x;
  float _110 = _109 + _70.x;
  float _111 = _110 + _76.x;
  float _112 = _100 * _111;
  float _113 = _112 + _64.x;
  float _114 = _113 * 0.10000000149011612f;
  float _115 = _114 * _108;
  float _116 = saturate(_115);
  float _117 = _59.y + _53.y;
  float _118 = _117 + _70.y;
  float _119 = _118 + _76.y;
  float _120 = _119 * 0.10000000149011612f;
  float _121 = _120 * _100;
  float _122 = _121 + _68;
  float _123 = _108 * _122;
  float _124 = saturate(_123);
  float _125 = _59.z + _53.z;
  float _126 = _125 + _70.z;
  float _127 = _126 + _76.z;
  float _128 = _100 * _127;
  float _129 = _128 + _64.z;
  float _130 = _129 * 0.10000000149011612f;
  float _131 = _130 * _108;
  float _132 = saturate(_131);
  float _133 = _64.x * 0.10000000149011612f;
  float _134 = _64.z * 0.10000000149011612f;
  float _135 = _116 - _133;
  float _136 = _124 - _68;
  float _137 = _132 - _134;
  float _138 = _135 * _51;
  float _139 = _136 * _51;
  float _140 = _137 * _51;
  float _141 = _138 + _133;
  float _142 = _139 + _68;
  float _143 = _140 + _134;
  float _144 = _141 * 10.0f;
  float _145 = _142 * 10.0f;
  float _146 = _143 * 10.0f;
  u0[int2(_15, _16)] = float3(_144, _145, _146);
  _147 = _15 | 8;
  float _148 = float((uint)_147);
  float _149 = _148 + 0.5f;
  float _150 = _24 * _149;
  float _151 = mad(_150, 2.0f, -1.0f);
  float _152 = dot(float2(_151, _41), float2(_151, _41));
  float _153 = 1.0f - _152;
  float _154 = saturate(_153);
  float _155 = log2(_154);
  float _156 = _155 * _21;
  float _157 = exp2(_156);
  float _158 = _157 + -1.0f;
  float _159 = _48 * _158;
  float _160 = _159 + 1.0f;
  float4 _161 = t0.Load(int3(_147, _52, 0));
  float _165 = _161.y * 0.10000000149011612f;
  uint _166 = _147 + -1u;
  float4 _167 = t0.Load(int3(_166, _16, 0));
  float _171 = _167.y * 0.10000000149011612f;
  float4 _172 = t0.Load(int3(_147, _16, 0));
  float _176 = _172.y * 0.10000000149011612f;
  uint _177 = _147 + 1u;
  float4 _178 = t0.Load(int3(_177, _16, 0));
  float _182 = _178.y * 0.10000000149011612f;
  float4 _183 = t0.Load(int3(_147, _75, 0));
  float _187 = _183.y * 0.10000000149011612f;
  float _188 = min(_176, _182);
  float _189 = min(_171, _188);
  float _190 = min(_165, _187);
  float _191 = min(_189, _190);
  float _192 = max(_176, _182);
  float _193 = max(_171, _192);
  float _194 = max(_165, _187);
  float _195 = max(_193, _194);
  int _196 = asint(_195);
  uint _197 = 2129690299u - _196;
  float _198 = asfloat(_197);
  float _199 = 1.0f - _195;
  float _200 = min(_191, _199);
  float _201 = _198 * _200;
  float _202 = saturate(_201);
  int _203 = asint(_202);
  int _204 = (uint)(_203) >> 1;
  uint _205 = _204 + 532432441u;
  float _206 = asfloat(_205);
  float _207 = _206 * _33;
  float _208 = _207 * 4.0f;
  float _209 = _208 + 1.0f;
  int _210 = asint(_209);
  uint _211 = 2129764351u - _210;
  float _212 = asfloat(_211);
  float _213 = _212 * _209;
  float _214 = 2.0f - _213;
  float _215 = _214 * _212;
  float _216 = _167.x + _161.x;
  float _217 = _216 + _178.x;
  float _218 = _217 + _183.x;
  float _219 = _207 * _218;
  float _220 = _219 + _172.x;
  float _221 = _220 * 0.10000000149011612f;
  float _222 = _221 * _215;
  float _223 = saturate(_222);
  float _224 = _167.y + _161.y;
  float _225 = _224 + _178.y;
  float _226 = _225 + _183.y;
  float _227 = _226 * 0.10000000149011612f;
  float _228 = _227 * _207;
  float _229 = _228 + _176;
  float _230 = _215 * _229;
  float _231 = saturate(_230);
  float _232 = _167.z + _161.z;
  float _233 = _232 + _178.z;
  float _234 = _233 + _183.z;
  float _235 = _207 * _234;
  float _236 = _235 + _172.z;
  float _237 = _236 * 0.10000000149011612f;
  float _238 = _237 * _215;
  float _239 = saturate(_238);
  float _240 = _172.x * 0.10000000149011612f;
  float _241 = _172.z * 0.10000000149011612f;
  float _242 = _223 - _240;
  float _243 = _231 - _176;
  float _244 = _239 - _241;
  float _245 = _242 * _160;
  float _246 = _243 * _160;
  float _247 = _244 * _160;
  float _248 = _245 + _240;
  float _249 = _246 + _176;
  float _250 = _247 + _241;
  float _251 = _248 * 10.0f;
  float _252 = _249 * 10.0f;
  float _253 = _250 * 10.0f;
  u0[int2(_147, _16)] = float3(_251, _252, _253);
  _254 = _16 | 8;
  float _255 = float((uint)_254);
  float _256 = _255 + 0.5f;
  float _257 = _256 * _25;
  float _258 = mad(_257, 2.0f, -1.0f);
  float _259 = dot(float2(_151, _258), float2(_151, _258));
  float _260 = 1.0f - _259;
  float _261 = saturate(_260);
  float _262 = log2(_261);
  float _263 = _262 * _21;
  float _264 = exp2(_263);
  float _265 = _264 + -1.0f;
  float _266 = _48 * _265;
  float _267 = _266 + 1.0f;
  uint _268 = _254 + -1u;
  float4 _269 = t0.Load(int3(_147, _268, 0));
  float _273 = _269.y * 0.10000000149011612f;
  float4 _274 = t0.Load(int3(_166, _254, 0));
  float _278 = _274.y * 0.10000000149011612f;
  float4 _279 = t0.Load(int3(_147, _254, 0));
  float _283 = _279.y * 0.10000000149011612f;
  float4 _284 = t0.Load(int3(_177, _254, 0));
  float _288 = _284.y * 0.10000000149011612f;
  uint _289 = _254 + 1u;
  float4 _290 = t0.Load(int3(_147, _289, 0));
  float _294 = _290.y * 0.10000000149011612f;
  float _295 = min(_283, _288);
  float _296 = min(_278, _295);
  float _297 = min(_273, _294);
  float _298 = min(_296, _297);
  float _299 = max(_283, _288);
  float _300 = max(_278, _299);
  float _301 = max(_273, _294);
  float _302 = max(_300, _301);
  int _303 = asint(_302);
  uint _304 = 2129690299u - _303;
  float _305 = asfloat(_304);
  float _306 = 1.0f - _302;
  float _307 = min(_298, _306);
  float _308 = _305 * _307;
  float _309 = saturate(_308);
  int _310 = asint(_309);
  int _311 = (uint)(_310) >> 1;
  uint _312 = _311 + 532432441u;
  float _313 = asfloat(_312);
  float _314 = _313 * _33;
  float _315 = _314 * 4.0f;
  float _316 = _315 + 1.0f;
  int _317 = asint(_316);
  uint _318 = 2129764351u - _317;
  float _319 = asfloat(_318);
  float _320 = _319 * _316;
  float _321 = 2.0f - _320;
  float _322 = _321 * _319;
  float _323 = _274.x + _269.x;
  float _324 = _323 + _284.x;
  float _325 = _324 + _290.x;
  float _326 = _314 * _325;
  float _327 = _326 + _279.x;
  float _328 = _327 * 0.10000000149011612f;
  float _329 = _328 * _322;
  float _330 = saturate(_329);
  float _331 = _274.y + _269.y;
  float _332 = _331 + _284.y;
  float _333 = _332 + _290.y;
  float _334 = _333 * 0.10000000149011612f;
  float _335 = _334 * _314;
  float _336 = _335 + _283;
  float _337 = _322 * _336;
  float _338 = saturate(_337);
  float _339 = _274.z + _269.z;
  float _340 = _339 + _284.z;
  float _341 = _340 + _290.z;
  float _342 = _314 * _341;
  float _343 = _342 + _279.z;
  float _344 = _343 * 0.10000000149011612f;
  float _345 = _344 * _322;
  float _346 = saturate(_345);
  float _347 = _279.x * 0.10000000149011612f;
  float _348 = _279.z * 0.10000000149011612f;
  float _349 = _330 - _347;
  float _350 = _338 - _283;
  float _351 = _346 - _348;
  float _352 = _349 * _267;
  float _353 = _350 * _267;
  float _354 = _351 * _267;
  float _355 = _352 + _347;
  float _356 = _353 + _283;
  float _357 = _354 + _348;
  float _358 = _355 * 10.0f;
  float _359 = _356 * 10.0f;
  float _360 = _357 * 10.0f;
  u0[int2(_147, _254)] = float3(_358, _359, _360);
  float _361 = dot(float2(_40, _258), float2(_40, _258));
  float _362 = 1.0f - _361;
  float _363 = saturate(_362);
  float _364 = log2(_363);
  float _365 = _364 * _21;
  float _366 = exp2(_365);
  float _367 = _366 + -1.0f;
  float _368 = _48 * _367;
  float _369 = _368 + 1.0f;
  float4 _370 = t0.Load(int3(_15, _268, 0));
  float _374 = _370.y * 0.10000000149011612f;
  float4 _375 = t0.Load(int3(_58, _254, 0));
  float _379 = _375.y * 0.10000000149011612f;
  float4 _380 = t0.Load(int3(_15, _254, 0));
  float _384 = _380.y * 0.10000000149011612f;
  float4 _385 = t0.Load(int3(_69, _254, 0));
  float _389 = _385.y * 0.10000000149011612f;
  float4 _390 = t0.Load(int3(_15, _289, 0));
  float _394 = _390.y * 0.10000000149011612f;
  float _395 = min(_384, _389);
  float _396 = min(_379, _395);
  float _397 = min(_374, _394);
  float _398 = min(_396, _397);
  float _399 = max(_384, _389);
  float _400 = max(_379, _399);
  float _401 = max(_374, _394);
  float _402 = max(_400, _401);
  int _403 = asint(_402);
  uint _404 = 2129690299u - _403;
  float _405 = asfloat(_404);
  float _406 = 1.0f - _402;
  float _407 = min(_398, _406);
  float _408 = _405 * _407;
  float _409 = saturate(_408);
  int _410 = asint(_409);
  int _411 = (uint)(_410) >> 1;
  uint _412 = _411 + 532432441u;
  float _413 = asfloat(_412);
  float _414 = _413 * _33;
  float _415 = _414 * 4.0f;
  float _416 = _415 + 1.0f;
  int _417 = asint(_416);
  uint _418 = 2129764351u - _417;
  float _419 = asfloat(_418);
  float _420 = _419 * _416;
  float _421 = 2.0f - _420;
  float _422 = _421 * _419;
  float _423 = _375.x + _370.x;
  float _424 = _423 + _385.x;
  float _425 = _424 + _390.x;
  float _426 = _414 * _425;
  float _427 = _426 + _380.x;
  float _428 = _427 * 0.10000000149011612f;
  float _429 = _428 * _422;
  float _430 = saturate(_429);
  float _431 = _375.y + _370.y;
  float _432 = _431 + _385.y;
  float _433 = _432 + _390.y;
  float _434 = _433 * 0.10000000149011612f;
  float _435 = _434 * _414;
  float _436 = _435 + _384;
  float _437 = _422 * _436;
  float _438 = saturate(_437);
  float _439 = _375.z + _370.z;
  float _440 = _439 + _385.z;
  float _441 = _440 + _390.z;
  float _442 = _414 * _441;
  float _443 = _442 + _380.z;
  float _444 = _443 * 0.10000000149011612f;
  float _445 = _444 * _422;
  float _446 = saturate(_445);
  float _447 = _380.x * 0.10000000149011612f;
  float _448 = _380.z * 0.10000000149011612f;
  float _449 = _430 - _447;
  float _450 = _438 - _384;
  float _451 = _446 - _448;
  float _452 = _449 * _369;
  float _453 = _450 * _369;
  float _454 = _451 * _369;
  float _455 = _452 + _447;
  float _456 = _453 + _384;
  float _457 = _454 + _448;
  float _458 = _455 * 10.0f;
  float _459 = _456 * 10.0f;
  float _460 = _457 * 10.0f;
  u0[int2(_15, _254)] = float3(_458, _459, _460);
}
