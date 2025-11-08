#include "./materials.hlsli"

cbuffer TonemapUBO : register(b0) {
  float4 Tonemap_m0[3] : packoffset(c0);
};

cbuffer Polygon3DConstantUBO : register(b1) {
  float4 Polygon3DConstant_m0[40] : packoffset(c0);
};

Buffer<uint4> WhitePtSrv : register(t0);
Texture2D<float4> primTex : register(t1);
SamplerState BilinearClamp : register(s5, space32);
SamplerState TrilinearClamp : register(s9, space32);

static float4 gl_FragCoord;
static float4 Color;
static float4 AlphaCorrection;
static float4 GeometryAttribute;
static float2 TexCoord;
static float4 TexCoord_1;
static uint RgbItem;
static float GhostItem;
static float ParticleTimerItem;
static float3 NormalFromEmitterItem;
static float4 SV_Target;
static float SV_Target_1;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float4 Color : Color;
  float4 AlphaCorrection : AlphaCorrection;
  float4 GeometryAttribute : GeometryAttribute;
  float2 TexCoord : TexCoord;
  float GhostItem : GhostItem;
  float ParticleTimerItem : ParticleTimerItem;
  float4 TexCoord_1 : TexCoord1;
  nointerpolation uint RgbItem : RgbItem;
  float3 NormalFromEmitterItem : NormalFromEmitterItem;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
};

uint spvPackHalf2x16(float2 value) {
  uint2 Packed = f32tof16(value);
  return Packed.x | (Packed.y << 16);
}

float2 spvUnpackHalf2x16(uint value) {
  return f16tof32(uint2(value & 0xffff, value >> 16));
}

void frag_main() {
  uint4 _93 = asuint(Polygon3DConstant_m0[4u]);
  uint _94 = _93.y;
  bool _98 = (_94 & 8u) == 0u;
  float _99;
  float _101;
  if (_98) {
    _99 = TexCoord.x;
    _101 = TexCoord.y;
  } else {
    _99 = frac(TexCoord.x);
    _101 = frac(TexCoord.y);
  }
  float _108 = TexCoord_1.z - TexCoord_1.x;
  float _110 = (clamp(_99, 0.0f, 1.0f) * _108) + TexCoord_1.x;
  float _111 = TexCoord_1.w - TexCoord_1.y;
  float _113 = (clamp(_101, 0.0f, 1.0f) * _111) + TexCoord_1.y;
  uint4 _117 = asuint(Polygon3DConstant_m0[26u]);
  uint _118 = _117.w;
  float _122;
  float _125;
  if ((_118 & 131072u) == 0u) {
    _122 = _110;
    _125 = _113;
  } else {
    float frontier_phi_3_4_ladder;
    float frontier_phi_3_4_ladder_1;
    if ((_94 & 134217728u) == 0u) {
      float _154 = _110 / Polygon3DConstant_m0[19u].x;
      float _155 = _113 / Polygon3DConstant_m0[19u].y;
      float _163 = frac(abs(_154));
      float _164 = frac(abs(_155));
      float _167 = (_154 >= ((-0.0f) - _154)) ? _163 : ((-0.0f) - _163);
      float _168 = (_155 >= ((-0.0f) - _155)) ? _164 : ((-0.0f) - _164);
      float _188 = sin(((_168 * 6.283185482025146484375f) * Polygon3DConstant_m0[20u].x) + Polygon3DConstant_m0[18u].x);
      float _193 = sin(((_167 * 6.283185482025146484375f) * Polygon3DConstant_m0[20u].z) + Polygon3DConstant_m0[18u].y);
      frontier_phi_3_4_ladder = (((_193 * max(Polygon3DConstant_m0[20u].w, 0.0f)) + (_188 * abs(min(Polygon3DConstant_m0[20u].y, 0.0f)))) * 0.100000001490116119384765625f) + _113;
      frontier_phi_3_4_ladder_1 = (((_193 * abs(min(Polygon3DConstant_m0[20u].w, 0.0f))) + (_188 * max(Polygon3DConstant_m0[20u].y, 0.0f))) * 0.100000001490116119384765625f) + _110;
    } else {
      float _205 = Polygon3DConstant_m0[19u].z * Polygon3DConstant_m0[19u].x;
      float _206 = Polygon3DConstant_m0[19u].w * Polygon3DConstant_m0[19u].y;
      float _207 = _110 / _205;
      float _208 = _113 / _206;
      float _215 = frac(abs(_207));
      float _216 = frac(abs(_208));
      float _219 = (_207 >= ((-0.0f) - _207)) ? _215 : ((-0.0f) - _215);
      float _220 = (_208 >= ((-0.0f) - _208)) ? _216 : ((-0.0f) - _216);
      float _225 = _219 + (-0.5f);
      float _227 = _220 + (-0.5f);
      float _231 = sqrt((_227 * _227) + (_225 * _225));
      float _233 = atan(_227 / _225);
      bool _238 = _225 < 0.0f;
      bool _239 = _225 == 0.0f;
      bool _240 = _227 >= 0.0f;
      bool _241 = _227 < 0.0f;
      float _250 = (_239 && _240) ? 1.57079637050628662109375f : ((_239 && _241) ? (-1.57079637050628662109375f) : ((_238 && _241) ? (_233 + (-3.1415927410125732421875f)) : ((_238 && _240) ? (_233 + 3.1415927410125732421875f) : _233)));
      float _258 = (((_94 & 268435456u) != 0u) && (_250 > 0.0f)) ? ((-0.0f) - _250) : _250;
      float _262 = log2(_231 * 2.0f);
      float _371;
      if (Polygon3DConstant_m0[18u].y > 0.0f) {
        _371 = (_258 + 1.0f) - exp2((Polygon3DConstant_m0[18u].y * (-0.15915493667125701904296875f)) * _262);
      } else {
        _371 = (_258 + (-1.0f)) + exp2((Polygon3DConstant_m0[18u].y * 0.15915493667125701904296875f) * _262);
      }
      float _396 = _371 + (-3.1415927410125732421875f);
      float _401 = Polygon3DConstant_m0[21u].z * _396;
      float _403 = sin(_401);
      float _406 = sin(_401 * 3.1415927410125732421875f);
      float _414 = Polygon3DConstant_m0[22u].x * _396;
      float _416 = sin(_414);
      float _419 = sin(_414 * 3.1415927410125732421875f);
      float _429 = (Polygon3DConstant_m0[18u].z + _371) + ((((((Polygon3DConstant_m0[21u].w * _403) + _406) * 2.0f) - Polygon3DConstant_m0[21u].w) * 0.00999999977648258209228515625f) * (_406 + _403));
      float _439 = ((((((Polygon3DConstant_m0[20u].y * sin(((_231 * 6.283185482025146484375f) * Polygon3DConstant_m0[20u].x) + Polygon3DConstant_m0[18u].x)) + Polygon3DConstant_m0[20u].w) * 0.100000001490116119384765625f) * exp2(log2(_231) * Polygon3DConstant_m0[20u].z)) + _231) + ((((((Polygon3DConstant_m0[22u].y * _416) + _419) * 2.0f) - Polygon3DConstant_m0[22u].y) * 0.00999999977648258209228515625f) * (_419 + _416))) + (sin(Polygon3DConstant_m0[21u].x * _429) * Polygon3DConstant_m0[21u].y);
      frontier_phi_3_4_ladder = ((float(uint(_208)) + 0.5f) + (sin(_429) * _439)) * _206;
      frontier_phi_3_4_ladder_1 = ((float(uint(_207)) + 0.5f) + (_439 * cos(_429))) * _205;
    }
    _122 = frontier_phi_3_4_ladder_1;
    _125 = frontier_phi_3_4_ladder;
  }
  float _333;
  float _334;
  float _335;
  float _336;
  if ((_118 & 65536u) == 0u) {
    bool _146 = (_118 & 6144u) == 0u;
    float frontier_phi_17_5_ladder;
    float frontier_phi_17_5_ladder_1;
    float frontier_phi_17_5_ladder_2;
    float frontier_phi_17_5_ladder_3;
    if (GeometryAttribute.w < 0.0f) {
      bool _265 = (_118 & 1024u) != 0u;
      float frontier_phi_17_5_ladder_9_ladder;
      float frontier_phi_17_5_ladder_9_ladder_1;
      float frontier_phi_17_5_ladder_9_ladder_2;
      float frontier_phi_17_5_ladder_9_ladder_3;
      if (_98) {
        float4 _302 = primTex.Sample(BilinearClamp, float2(_122, _125));
        float _304 = _302.x;
        float _305 = _302.y;
        float _308 = _265 ? _304 : _305;
        float _309 = _265 ? _304 : _302.z;
        float _310 = _265 ? _305 : _302.w;
        float frontier_phi_17_5_ladder_9_ladder_14_ladder;
        float frontier_phi_17_5_ladder_9_ladder_14_ladder_1;
        float frontier_phi_17_5_ladder_9_ladder_14_ladder_2;
        float frontier_phi_17_5_ladder_9_ladder_14_ladder_3;
        if (_146) {
          frontier_phi_17_5_ladder_9_ladder_14_ladder = exp2(log2(_310) * 4.840000152587890625f);
          frontier_phi_17_5_ladder_9_ladder_14_ladder_1 = _309;
          frontier_phi_17_5_ladder_9_ladder_14_ladder_2 = _308;
          frontier_phi_17_5_ladder_9_ladder_14_ladder_3 = _304;
        } else {
          frontier_phi_17_5_ladder_9_ladder_14_ladder = _310;
          frontier_phi_17_5_ladder_9_ladder_14_ladder_1 = _309;
          frontier_phi_17_5_ladder_9_ladder_14_ladder_2 = _308;
          frontier_phi_17_5_ladder_9_ladder_14_ladder_3 = _304;
        }
        frontier_phi_17_5_ladder_9_ladder = frontier_phi_17_5_ladder_9_ladder_14_ladder;
        frontier_phi_17_5_ladder_9_ladder_1 = frontier_phi_17_5_ladder_9_ladder_14_ladder_1;
        frontier_phi_17_5_ladder_9_ladder_2 = frontier_phi_17_5_ladder_9_ladder_14_ladder_2;
        frontier_phi_17_5_ladder_9_ladder_3 = frontier_phi_17_5_ladder_9_ladder_14_ladder_3;
      } else {
        float _311 = _108 * TexCoord.x;
        float _312 = _111 * TexCoord.y;
        float _313 = ddy_coarse(_311);
        float _314 = ddy_coarse(_312);
        float _315 = ddx_coarse(_311);
        float _316 = ddx_coarse(_312);
        float4 _318 = primTex.SampleGrad(BilinearClamp, float2(_122, _125), float2(_315, _316), float2(_313, _314));
        float _322 = _318.x;
        float _323 = _318.y;
        float _326 = _265 ? _322 : _323;
        float _327 = _265 ? _322 : _318.z;
        float _328 = _265 ? _323 : _318.w;
        float frontier_phi_17_5_ladder_9_ladder_15_ladder;
        float frontier_phi_17_5_ladder_9_ladder_15_ladder_1;
        float frontier_phi_17_5_ladder_9_ladder_15_ladder_2;
        float frontier_phi_17_5_ladder_9_ladder_15_ladder_3;
        if (_146) {
          frontier_phi_17_5_ladder_9_ladder_15_ladder = exp2(log2(_328) * 4.840000152587890625f);
          frontier_phi_17_5_ladder_9_ladder_15_ladder_1 = _327;
          frontier_phi_17_5_ladder_9_ladder_15_ladder_2 = _326;
          frontier_phi_17_5_ladder_9_ladder_15_ladder_3 = _322;
        } else {
          frontier_phi_17_5_ladder_9_ladder_15_ladder = _328;
          frontier_phi_17_5_ladder_9_ladder_15_ladder_1 = _327;
          frontier_phi_17_5_ladder_9_ladder_15_ladder_2 = _326;
          frontier_phi_17_5_ladder_9_ladder_15_ladder_3 = _322;
        }
        frontier_phi_17_5_ladder_9_ladder = frontier_phi_17_5_ladder_9_ladder_15_ladder;
        frontier_phi_17_5_ladder_9_ladder_1 = frontier_phi_17_5_ladder_9_ladder_15_ladder_1;
        frontier_phi_17_5_ladder_9_ladder_2 = frontier_phi_17_5_ladder_9_ladder_15_ladder_2;
        frontier_phi_17_5_ladder_9_ladder_3 = frontier_phi_17_5_ladder_9_ladder_15_ladder_3;
      }
      frontier_phi_17_5_ladder = frontier_phi_17_5_ladder_9_ladder;
      frontier_phi_17_5_ladder_1 = frontier_phi_17_5_ladder_9_ladder_1;
      frontier_phi_17_5_ladder_2 = frontier_phi_17_5_ladder_9_ladder_2;
      frontier_phi_17_5_ladder_3 = frontier_phi_17_5_ladder_9_ladder_3;
    } else {
      float4 _268 = primTex.SampleLevel(TrilinearClamp, float2(_122, _125), GeometryAttribute.w);
      float _270 = _268.x;
      float _271 = _268.y;
      float _272 = _268.z;
      float _273 = _268.w;
      float frontier_phi_17_5_ladder_10_ladder;
      float frontier_phi_17_5_ladder_10_ladder_1;
      float frontier_phi_17_5_ladder_10_ladder_2;
      float frontier_phi_17_5_ladder_10_ladder_3;
      if (_146) {
        frontier_phi_17_5_ladder_10_ladder = exp2(log2(_273) * 4.840000152587890625f);
        frontier_phi_17_5_ladder_10_ladder_1 = _272;
        frontier_phi_17_5_ladder_10_ladder_2 = _271;
        frontier_phi_17_5_ladder_10_ladder_3 = _270;
      } else {
        frontier_phi_17_5_ladder_10_ladder = _273;
        frontier_phi_17_5_ladder_10_ladder_1 = _272;
        frontier_phi_17_5_ladder_10_ladder_2 = _271;
        frontier_phi_17_5_ladder_10_ladder_3 = _270;
      }
      frontier_phi_17_5_ladder = frontier_phi_17_5_ladder_10_ladder;
      frontier_phi_17_5_ladder_1 = frontier_phi_17_5_ladder_10_ladder_1;
      frontier_phi_17_5_ladder_2 = frontier_phi_17_5_ladder_10_ladder_2;
      frontier_phi_17_5_ladder_3 = frontier_phi_17_5_ladder_10_ladder_3;
    }
    _333 = frontier_phi_17_5_ladder_3;
    _334 = frontier_phi_17_5_ladder_2;
    _335 = frontier_phi_17_5_ladder_1;
    _336 = frontier_phi_17_5_ladder;
  } else {
    float _149 = ((_125 - TexCoord_1.y) / _111) * GhostItem;
    float _152 = (GhostItem + (-1.0f)) * 0.125f;
    float _275;
    float _277;
    float _279;
    float _281;
    float _274 = 0.0f;
    float _276 = 0.0f;
    float _278 = 0.0f;
    float _280 = 0.0f;
    float _282 = _149;
    uint _284 = 0u;
    bool _288;
    for (;;) {
      _288 = (_282 >= 0.0f) && (_282 <= 1.0f);
      float frontier_phi_19_pred;
      float frontier_phi_19_pred_1;
      float frontier_phi_19_pred_2;
      float frontier_phi_19_pred_3;
      if (_288) {
        uint4 _350 = asuint(Polygon3DConstant_m0[26u]);
        uint _351 = _350.w;
        bool _353 = (_351 & 1024u) != 0u;
        float4 _355 = primTex.Sample(BilinearClamp, float2(_122, (_282 * _111) + TexCoord_1.y));
        float _357 = _355.x;
        float _358 = _355.y;
        float _363 = _353 ? _358 : _355.w;
        float _598;
        if ((_351 & 6144u) == 0u) {
          _598 = exp2(log2(_363) * 4.840000152587890625f);
        } else {
          _598 = _363;
        }
        float _602 = (float(int(8u - _284)) * 0.125f) * _598;
        frontier_phi_19_pred = (_602 * (_357 - _274)) + _274;
        frontier_phi_19_pred_1 = (_602 * ((_353 ? _357 : _358) - _276)) + _276;
        frontier_phi_19_pred_2 = 1.0f - ((1.0f - _602) * (1.0f - _280));
        frontier_phi_19_pred_3 = (_602 * ((_353 ? _357 : _355.z) - _278)) + _278;
      } else {
        frontier_phi_19_pred = _274;
        frontier_phi_19_pred_1 = _276;
        frontier_phi_19_pred_2 = _280;
        frontier_phi_19_pred_3 = _278;
      }
      _275 = frontier_phi_19_pred;
      _277 = frontier_phi_19_pred_1;
      _281 = frontier_phi_19_pred_2;
      _279 = frontier_phi_19_pred_3;
      uint _285 = _284 + 1u;
      if (_285 == 8u) {
        break;
      } else {
        _274 = _275;
        _276 = _277;
        _278 = _279;
        _280 = _281;
        _282 -= _152;
        _284 = _285;
        continue;
      }
    }
    _333 = _275;
    _334 = _277;
    _335 = _279;
    _336 = _281;
  }
  uint4 _341 = asuint(Polygon3DConstant_m0[26u]);
  uint _342 = _341.w;
  float _612;
  float _614;
  float _616;
  float _618;
  float _620;
  float _621;
  float _622;
  if ((_342 & 2048u) == 0u) {
    float frontier_phi_28_23_ladder;
    float frontier_phi_28_23_ladder_1;
    float frontier_phi_28_23_ladder_2;
    float frontier_phi_28_23_ladder_3;
    float frontier_phi_28_23_ladder_4;
    float frontier_phi_28_23_ladder_5;
    float frontier_phi_28_23_ladder_6;
    if ((_342 & 4096u) == 0u) {
      frontier_phi_28_23_ladder = 0.0f;
      frontier_phi_28_23_ladder_1 = _333;
      frontier_phi_28_23_ladder_2 = _334;
      frontier_phi_28_23_ladder_3 = _335;
      frontier_phi_28_23_ladder_4 = _336;
      frontier_phi_28_23_ladder_5 = 0.0f;
      frontier_phi_28_23_ladder_6 = 0.0f;
    } else {
      uint4 _667 = asuint(Polygon3DConstant_m0[38u]);
      uint _668 = _667.x;
      uint _679 = _667.y;
      uint _690 = _667.z;
      float2 _693 = spvUnpackHalf2x16((_690 << 4u) & 32752u);
      float _694 = _693.x;
      float2 _697 = spvUnpackHalf2x16((_690 >> 7u) & 32752u);
      float _698 = _697.x;
      float _717 = _694 * _333;
      float _724 = (spvUnpackHalf2x16((RgbItem >> 22u) << 5u).x * (_335 - _334)) + _334;
      frontier_phi_28_23_ladder = 0.0f;
      frontier_phi_28_23_ladder_1 = (((_698 * float(_679 & 255u)) * _724) + ((float(_668 & 255u) * _333) * _694)) * 0.0039215688593685626983642578125f;
      frontier_phi_28_23_ladder_2 = (((float((_679 >> 8u) & 255u) * _698) * _724) + (_717 * float((_668 >> 8u) & 255u))) * 0.0039215688593685626983642578125f;
      frontier_phi_28_23_ladder_3 = (((float((_679 >> 16u) & 255u) * _698) * _724) + (_717 * float((_668 >> 16u) & 255u))) * 0.0039215688593685626983642578125f;
      frontier_phi_28_23_ladder_4 = clamp(((_336 * 0.0039215688593685626983642578125f) * spvUnpackHalf2x16((_690 >> 22u) << 5u).x) * (((spvUnpackHalf2x16((RgbItem >> 7u) & 32752u).x * float(_679 >> 24u)) * _724) + ((float(_668 >> 24u) * _333) * spvUnpackHalf2x16((RgbItem << 4u) & 32752u).x)), 0.0f, 1.0f);
      frontier_phi_28_23_ladder_5 = 0.0f;
      frontier_phi_28_23_ladder_6 = 0.0f;
    }
    _612 = frontier_phi_28_23_ladder_1;
    _614 = frontier_phi_28_23_ladder_2;
    _616 = frontier_phi_28_23_ladder_3;
    _618 = frontier_phi_28_23_ladder_4;
    _620 = frontier_phi_28_23_ladder;
    _621 = frontier_phi_28_23_ladder_5;
    _622 = frontier_phi_28_23_ladder_6;
  } else {
    bool _455 = (_342 & 16384u) != 0u;
    bool _458 = (_342 & 8192u) != 0u;
    uint4 _462 = asuint(Polygon3DConstant_m0[38u]);
    uint _463 = _462.x;
    float _477 = float(_463 & 255u) * 0.0039215688593685626983642578125f;
    float _479 = float((_463 >> 8u) & 255u) * 0.0039215688593685626983642578125f;
    float _480 = float((_463 >> 16u) & 255u) * 0.0039215688593685626983642578125f;
    uint _482 = _462.y;
    uint _497 = _462.z;
    uint _513 = _462.w;
    float2 _524 = spvUnpackHalf2x16(RgbItem & 65535u);
    float _525 = _524.x;
    float _535 = (float(_463 >> 24u) * 0.0039215688593685626983642578125f) * exp2(log2(max(spvUnpackHalf2x16(RgbItem >> 16u).x * _334, 9.9999999392252902907785028219223e-09f)) * spvUnpackHalf2x16((_497 >> 7u) & 32752u).x);
    float _536 = _535 * spvUnpackHalf2x16((_497 << 4u) & 32752u).x;
    float _540 = clamp(_536 / max(spvUnpackHalf2x16((_497 >> 22u) << 5u).x, 9.9999999747524270787835121154785e-07f), 0.0f, 1.0f);
    float _541 = _540 * _540;
    float _551 = ((_541 * (1.0f - _477)) + _477) * _536;
    float _552 = ((_541 * (1.0f - _479)) + _479) * _536;
    float _553 = ((_541 * (1.0f - _480)) + _480) * _536;
    float _561 = ((_525 * (_335 - _333)) + _333) * spvUnpackHalf2x16((_513 << 4u) & 32752u).x;
    float _562 = (float(_482 & 255u) * 0.0039215688593685626983642578125f) * _561;
    float _563 = (float((_482 >> 8u) & 255u) * 0.0039215688593685626983642578125f) * _561;
    float _564 = (float((_482 >> 16u) & 255u) * 0.0039215688593685626983642578125f) * _561;
    float _566 = float(!_458);
    float _571 = float(!_455);
    float _578 = float(_458);
    float _582 = float(_455);
    float _591 = clamp((_535 + ((float(_482 >> 24u) * 0.0039215688593685626983642578125f) * ((_525 * (_335 - _336)) + _336))) * spvUnpackHalf2x16((_513 >> 7u) & 32752u).x, 0.0f, 1.0f);
    _612 = (_551 * _582) + (_562 * _578);
    _614 = (_552 * _582) + (_563 * _578);
    _616 = (_553 * _582) + (_564 * _578);
    _618 = (_591 <= 9.9999997473787516355514526367188e-05f) ? 0.0f : _591;
    _620 = (_551 * _571) + (_562 * _566);
    _621 = (_552 * _571) + (_563 * _566);
    _622 = (_553 * _571) + (_564 * _566);
  }

#if 1
  HueShiftFire(_612, _614, _616);
#endif

  float _630 = clamp((_618 - Polygon3DConstant_m0[26u].z) / (Polygon3DConstant_m0[26u].y - Polygon3DConstant_m0[26u].z), 0.0f, 1.0f);
  float _640 = exp2(log2(((_630 * _630) * _618) * (3.0f - (_630 * 2.0f))) * Polygon3DConstant_m0[26u].x);
  float _641 = 1.0f / AlphaCorrection.y;
  float _649 = clamp(clamp(((_640 * Color.w) - AlphaCorrection.x) * _641, 0.0f, 1.0f), 0.0f, 1.0f);
  float _662 = (((((_649 * _649) * AlphaCorrection.z) * (3.0f - (_649 * 2.0f))) + (clamp((_640 - AlphaCorrection.x) * _641, 0.0f, 1.0f) * (1.0f - AlphaCorrection.z))) * AlphaCorrection.w) + ((Color.w * (1.0f - AlphaCorrection.w)) * _640);
  if (_662 < 1.1920928955078125e-07f) {
    SV_Target.x = 0.0f;
    SV_Target.y = 0.0f;
    SV_Target.z = 0.0f;
    SV_Target.w = 0.0f;
    SV_Target_1 = 0.0f;
    SV_Target.x = 0.0f;
    SV_Target.y = 0.0f;
    SV_Target.z = 0.0f;
    SV_Target.w = 0.0f;
    SV_Target_1 = 0.0f;
  } else {
    bool _752 = Polygon3DConstant_m0[29u].y > 0.0f;
    float _782;
    float _783;
    if (_752) {
      float _774 = (((clamp(Polygon3DConstant_m0[28u].x + clamp((dot(float3(_612, _614, _616), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) * _662) * Polygon3DConstant_m0[28u].w, 0.0f, 1.0f), 0.0f, 1.0f) / (Polygon3DConstant_m0[28u].x + 1.0f)) * 2.0f) + (-1.0f)) * Polygon3DConstant_m0[28u].y;
      _782 = clamp(_774, 0.0f, 1.0f);
      _783 = float(clamp((-0.0f) - _774, 0.0f, 1.0f) < Polygon3DConstant_m0[28u].z) * _662;
    } else {
      _782 = 1.0f;
      _783 = _662;
    }
    uint4 _789 = asuint(Polygon3DConstant_m0[29u]);
    uint _790 = _789.w;
    uint _791 = _789.z;
    float _796;
    float _798;
    float _800;
    if ((_342 & 262144u) == 0u) {
      _796 = 1.0f;
      _798 = 1.0f;
      _800 = 1.0f;
    } else {
      float _816 = clamp(((dot(float3(_612, _614, _616), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) * Color.w) - Polygon3DConstant_m0[30u].w) / (Polygon3DConstant_m0[30u].z - Polygon3DConstant_m0[30u].w), 0.0f, 1.0f);
      float _820 = (_816 * _816) * (3.0f - (_816 * 2.0f));
      float _829 = Polygon3DConstant_m0[30u].x * 0.0039215688593685626983642578125f;
      float _841 = Polygon3DConstant_m0[30u].y * 0.0039215688593685626983642578125f;
      float _842 = _841 * float(_790 & 255u);
      float _843 = _841 * float((_790 >> 8u) & 255u);
      float _844 = _841 * float((_790 >> 16u) & 255u);
      _796 = (_820 * ((_829 * float(_791 & 255u)) - _842)) + _842;
      _798 = (_820 * ((_829 * float((_791 >> 8u) & 255u)) - _843)) + _843;
      _800 = (_820 * ((_829 * float((_791 >> 16u) & 255u)) - _844)) + _844;
    }
    float _851;
    float _857;
    float _863;
    float _869;
    switch ((_94 >> 11u) & 15u) {
      case 0u: {
        float _888 = (Polygon3DConstant_m0[15u].w * (_620 + _612)) * Color.x;
        float _891 = (Polygon3DConstant_m0[15u].w * (_621 + _614)) * Color.y;
        float _894 = (Polygon3DConstant_m0[15u].w * (_622 + _616)) * Color.z;
        float _899 = _888 * Polygon3DConstant_m0[32u].y;
        float _900 = _891 * Polygon3DConstant_m0[32u].y;
        float _901 = _894 * Polygon3DConstant_m0[32u].y;
        float _1013;
        float _1015;
        float _1017;
        if ((_94 & 1024u) == 0u) {
          _1013 = _899;
          _1015 = _900;
          _1017 = _901;
        } else {
          float _1042 = (((asuint(Tonemap_m0[1u]).x != 0u) ? asfloat(WhitePtSrv.Load(0u).x) : 1.0f) * Tonemap_m0[0u].x) * max(1.0f - Tonemap_m0[0u].y, 9.9999997473787516355514526367188e-05f);
          _1013 = (Polygon3DConstant_m0[16u].y * (max(0.0f, _888 / _1042) - _899)) + _899;
          _1015 = (Polygon3DConstant_m0[16u].y * (max(0.0f, _891 / _1042) - _900)) + _900;
          _1017 = (Polygon3DConstant_m0[16u].y * (max(0.0f, _894 / _1042) - _901)) + _901;
        }
        float _874 = exp2(log2(max(9.9999999747524270787835121154785e-07f, Color.w)) * Polygon3DConstant_m0[13u].y) * _783;
        float _1222;
        float _1223;
        float _1224;
        if (_752) {
          uint _1197 = _789.x;
          float _1209 = exp2(Polygon3DConstant_m0[29u].y * 1.44269502162933349609375f) * 0.0039215688593685626983642578125f;
          float _1210 = _1209 * float(_1197 & 255u);
          float _1211 = _1209 * float((_1197 >> 8u) & 255u);
          float _1212 = _1209 * float((_1197 >> 16u) & 255u);
          _1222 = (_1210 + _1013) - (_1210 * _782);
          _1223 = (_1211 + _1015) - (_1211 * _782);
          _1224 = (_1212 + _1017) - (_1212 * _782);
        } else {
          _1222 = _1013;
          _1223 = _1015;
          _1224 = _1017;
        }
        _851 = ((_874 * _796) * _1222) * Polygon3DConstant_m0[12u].w;
        _857 = ((_874 * _798) * _1223) * Polygon3DConstant_m0[12u].w;
        _863 = ((_874 * _800) * _1224) * Polygon3DConstant_m0[12u].w;
        _869 = _874;
        break;
      }
      case 1u: {
        float _911 = dot(float3(_612, _614, _616), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
        float _918 = (((_911 * _911) * 37.5f) * Polygon3DConstant_m0[15u].w) * Polygon3DConstant_m0[32u].x;
        float _919 = _918 + 1.0f;
        float _920 = _918 + Polygon3DConstant_m0[32u].y;
        float _925 = ((_920 * _612) + _620) * Color.x;
        float _927 = ((_920 * _614) + _621) * Color.y;
        float _929 = ((_920 * _616) + _622) * Color.z;
        float _1058;
        float _1060;
        float _1062;
        if ((_94 & 1024u) == 0u) {
          _1058 = _925;
          _1060 = _927;
          _1062 = _929;
        } else {
          float _1094 = (((asuint(Tonemap_m0[1u]).x != 0u) ? asfloat(WhitePtSrv.Load(0u).x) : 1.0f) * Tonemap_m0[0u].x) * max(1.0f - Tonemap_m0[0u].y, 9.9999997473787516355514526367188e-05f);
          _1058 = (Polygon3DConstant_m0[16u].y * (max(0.0f, ((_612 * Color.x) * _919) / _1094) - _925)) + _925;
          _1060 = (Polygon3DConstant_m0[16u].y * (max(0.0f, ((_614 * Color.y) * _919) / _1094) - _927)) + _927;
          _1062 = (Polygon3DConstant_m0[16u].y * (max(0.0f, ((_616 * Color.z) * _919) / _1094) - _929)) + _929;
        }
        float _1071 = exp2(log2(max(9.9999999747524270787835121154785e-07f, Color.w)) * Polygon3DConstant_m0[13u].y) * _783;
        float _1259;
        float _1260;
        float _1261;
        if (_752) {
          uint _1235 = _789.x;
          float _1246 = exp2(Polygon3DConstant_m0[29u].y * 1.44269502162933349609375f) * 0.0039215688593685626983642578125f;
          float _1247 = _1246 * float(_1235 & 255u);
          float _1248 = _1246 * float((_1235 >> 8u) & 255u);
          float _1249 = _1246 * float((_1235 >> 16u) & 255u);
          _1259 = (_1247 + _1058) - (_1247 * _782);
          _1260 = (_1248 + _1060) - (_1248 * _782);
          _1261 = (_1249 + _1062) - (_1249 * _782);
        } else {
          _1259 = _1058;
          _1260 = _1060;
          _1261 = _1062;
        }
        _851 = ((_1071 * _796) * _1259) * Polygon3DConstant_m0[12u].w;
        _857 = ((_1071 * _798) * _1260) * Polygon3DConstant_m0[12u].w;
        _863 = ((_1071 * _800) * _1261) * Polygon3DConstant_m0[12u].w;
        _869 = Polygon3DConstant_m0[16u].x * _1071;
        break;
      }
      case 2u: {
        float _942 = (Polygon3DConstant_m0[15u].w * (_620 + _612)) * Color.x;
        float _945 = (Polygon3DConstant_m0[15u].w * (_621 + _614)) * Color.y;
        float _948 = (Polygon3DConstant_m0[15u].w * (_622 + _616)) * Color.z;
        float _1274;
        float _1275;
        float _1276;
        if ((_94 & 1024u) == 0u) {
          _1274 = Polygon3DConstant_m0[32u].y * _942;
          _1275 = Polygon3DConstant_m0[32u].y * _945;
          _1276 = Polygon3DConstant_m0[32u].y * _948;
        } else {
          float _1132 = (((asuint(Tonemap_m0[1u]).x != 0u) ? asfloat(WhitePtSrv.Load(0u).x) : 1.0f) * Tonemap_m0[0u].x) * max(1.0f - Tonemap_m0[0u].y, 9.9999997473787516355514526367188e-05f);
          _1274 = max(0.0f, _942 / _1132);
          _1275 = max(0.0f, _945 / _1132);
          _1276 = max(0.0f, _948 / _1132);
        }
        float _1282 = exp2(log2(max(9.9999999747524270787835121154785e-07f, Color.w)) * Polygon3DConstant_m0[13u].y) * _783;
        float _1324;
        float _1325;
        float _1326;
        if (_752) {
          uint _1300 = _789.x;
          float _1311 = exp2(Polygon3DConstant_m0[29u].y * 1.44269502162933349609375f) * 0.0039215688593685626983642578125f;
          float _1312 = _1311 * float(_1300 & 255u);
          float _1313 = _1311 * float((_1300 >> 8u) & 255u);
          float _1314 = _1311 * float((_1300 >> 16u) & 255u);
          _1324 = (_1312 + _1274) - (_1312 * _782);
          _1325 = (_1313 + _1275) - (_1313 * _782);
          _1326 = (_1314 + _1276) - (_1314 * _782);
        } else {
          _1324 = _1274;
          _1325 = _1275;
          _1326 = _1276;
        }
        _851 = ((_1282 * _796) * _1324) * Polygon3DConstant_m0[12u].w;
        _857 = ((_1282 * _798) * _1325) * Polygon3DConstant_m0[12u].w;
        _863 = ((_1282 * _800) * _1326) * Polygon3DConstant_m0[12u].w;
        _869 = (-0.0f) - (_783 * Polygon3DConstant_m0[13u].w);
        break;
      }
      case 3u: {
        float _957 = exp2(log2(1.0f - _640) * Polygon3DConstant_m0[15u].z);
        float _958 = 1.0f - _957;
        float _970 = _957 * 100.0f;
        float _984 = ((Polygon3DConstant_m0[15u].w * (_620 + _958)) * Color.x) + (((_970 * Polygon3DConstant_m0[14u].x) * Polygon3DConstant_m0[13u].w) * Polygon3DConstant_m0[14u].w);
        float _988 = ((Polygon3DConstant_m0[15u].w * (_621 + _958)) * Color.y) + (((_970 * Polygon3DConstant_m0[14u].y) * Polygon3DConstant_m0[13u].w) * Polygon3DConstant_m0[14u].w);
        float _992 = ((Polygon3DConstant_m0[15u].w * (_622 + _958)) * Color.z) + (((_970 * Polygon3DConstant_m0[14u].z) * Polygon3DConstant_m0[13u].w) * Polygon3DConstant_m0[14u].w);
        float _1283;
        float _1284;
        float _1285;
        if ((_94 & 1024u) == 0u) {
          _1283 = Polygon3DConstant_m0[32u].y * _984;
          _1284 = Polygon3DConstant_m0[32u].y * _988;
          _1285 = Polygon3DConstant_m0[32u].y * _992;
        } else {
          float _1161 = (((asuint(Tonemap_m0[1u]).x != 0u) ? asfloat(WhitePtSrv.Load(0u).x) : 1.0f) * Tonemap_m0[0u].x) * max(1.0f - Tonemap_m0[0u].y, 9.9999997473787516355514526367188e-05f);
          _1283 = max(0.0f, _984 / _1161);
          _1284 = max(0.0f, _988 / _1161);
          _1285 = max(0.0f, _992 / _1161);
        }
        float _871 = exp2(log2(max(9.9999999747524270787835121154785e-07f, Color.w)) * Polygon3DConstant_m0[13u].y) * _783;
        float _1360;
        float _1361;
        float _1362;
        if (_752) {
          uint _1336 = _789.x;
          float _1347 = exp2(Polygon3DConstant_m0[29u].y * 1.44269502162933349609375f) * 0.0039215688593685626983642578125f;
          float _1348 = _1347 * float(_1336 & 255u);
          float _1349 = _1347 * float((_1336 >> 8u) & 255u);
          float _1350 = _1347 * float((_1336 >> 16u) & 255u);
          _1360 = (_1348 + _1283) - (_1348 * _782);
          _1361 = (_1349 + _1284) - (_1349 * _782);
          _1362 = (_1350 + _1285) - (_1350 * _782);
        } else {
          _1360 = _1283;
          _1361 = _1284;
          _1362 = _1285;
        }
        _851 = ((_871 * _796) * _1360) * Polygon3DConstant_m0[12u].w;
        _857 = ((_871 * _798) * _1361) * Polygon3DConstant_m0[12u].w;
        _863 = ((_871 * _800) * _1362) * Polygon3DConstant_m0[12u].w;
        _869 = _871;
        break;
      }
      case 4u: {
        float _1004 = (Polygon3DConstant_m0[15u].w * (_620 + _612)) * Color.x;
        float _1007 = (Polygon3DConstant_m0[15u].w * (_621 + _614)) * Color.y;
        float _1010 = (Polygon3DConstant_m0[15u].w * (_622 + _616)) * Color.z;
        float _1291;
        float _1292;
        float _1293;
        if ((_94 & 1024u) == 0u) {
          _1291 = Polygon3DConstant_m0[32u].y * _1004;
          _1292 = Polygon3DConstant_m0[32u].y * _1007;
          _1293 = Polygon3DConstant_m0[32u].y * _1010;
        } else {
          float _1190 = (((asuint(Tonemap_m0[1u]).x != 0u) ? asfloat(WhitePtSrv.Load(0u).x) : 1.0f) * Tonemap_m0[0u].x) * max(1.0f - Tonemap_m0[0u].y, 9.9999997473787516355514526367188e-05f);
          _1291 = max(0.0f, _1004 / _1190);
          _1292 = max(0.0f, _1007 / _1190);
          _1293 = max(0.0f, _1010 / _1190);
        }
        float _1299 = exp2(log2(max(9.9999999747524270787835121154785e-07f, Color.w)) * Polygon3DConstant_m0[13u].y) * _783;
        float _1396;
        float _1397;
        float _1398;
        if (_752) {
          uint _1372 = _789.x;
          float _1383 = exp2(Polygon3DConstant_m0[29u].y * 1.44269502162933349609375f) * 0.0039215688593685626983642578125f;
          float _1384 = _1383 * float(_1372 & 255u);
          float _1385 = _1383 * float((_1372 >> 8u) & 255u);
          float _1386 = _1383 * float((_1372 >> 16u) & 255u);
          _1396 = (_1384 + _1291) - (_1384 * _782);
          _1397 = (_1385 + _1292) - (_1385 * _782);
          _1398 = (_1386 + _1293) - (_1386 * _782);
        } else {
          _1396 = _1291;
          _1397 = _1292;
          _1398 = _1293;
        }
        _851 = ((_1299 * _796) * _1396) * Polygon3DConstant_m0[12u].w;
        _857 = ((_1299 * _798) * _1397) * Polygon3DConstant_m0[12u].w;
        _863 = ((_1299 * _800) * _1398) * Polygon3DConstant_m0[12u].w;
        _869 = min((Polygon3DConstant_m0[13u].w * Color.w) * _1299, 1.0f);
        break;
      }
      default: {
        _851 = 0.0f;
        _857 = 0.0f;
        _863 = 0.0f;
        _869 = 0.0f;
        break;
      }
    }
    SV_Target.x = 0.0f;
    SV_Target.y = 0.0f;
    SV_Target.z = 0.0f;
    SV_Target.w = 0.0f;
    SV_Target_1 = 0.0f;
    SV_Target.x = _851;
    SV_Target.y = _857;
    SV_Target.z = _863;
    SV_Target.w = _869;
    SV_Target_1 = _869;
  }

}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  Color = stage_input.Color;
  AlphaCorrection = stage_input.AlphaCorrection;
  GeometryAttribute = stage_input.GeometryAttribute;
  TexCoord = stage_input.TexCoord;
  TexCoord_1 = stage_input.TexCoord_1;
  RgbItem = stage_input.RgbItem;
  GhostItem = stage_input.GhostItem;
  ParticleTimerItem = stage_input.ParticleTimerItem;
  NormalFromEmitterItem = stage_input.NormalFromEmitterItem;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
