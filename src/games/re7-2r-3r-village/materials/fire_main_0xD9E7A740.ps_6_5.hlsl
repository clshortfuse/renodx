#include "./materials.hlsli"

cbuffer SceneInfoUBO : register(b0, space0) {
  float4 SceneInfo_m0[33] : packoffset(c0);
};

cbuffer TonemapUBO : register(b1, space0) {
  float4 Tonemap_m0[3] : packoffset(c0);
};

cbuffer Polygon3DConstantUBO : register(b2, space0) {
  float4 Polygon3DConstant_m0[40] : packoffset(c0);
};

Texture2D<float4> ReadonlyDepth : register(t0, space0);
Buffer<uint4> WhitePtSrv : register(t1, space0);
Texture2D<float4> primTex : register(t2, space0);
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
  uint4 _106 = asuint(Polygon3DConstant_m0[4u]);
  uint _107 = _106.y;
  bool _111 = (_107 & 8u) == 0u;
  float _112;
  float _114;
  if (_111) {
    _112 = TexCoord.x;
    _114 = TexCoord.y;
  } else {
    _112 = frac(TexCoord.x);
    _114 = frac(TexCoord.y);
  }
  float _121 = TexCoord_1.z - TexCoord_1.x;
  float _123 = (clamp(_112, 0.0f, 1.0f) * _121) + TexCoord_1.x;
  float _124 = TexCoord_1.w - TexCoord_1.y;
  float _126 = (clamp(_114, 0.0f, 1.0f) * _124) + TexCoord_1.y;
  uint4 _130 = asuint(Polygon3DConstant_m0[26u]);
  uint _131 = _130.w;
  float _135;
  float _138;
  if ((_131 & 131072u) == 0u) {
    _135 = _123;
    _138 = _126;
  } else {
    float frontier_phi_3_4_ladder;
    float frontier_phi_3_4_ladder_1;
    if ((_107 & 134217728u) == 0u) {
      float _167 = _123 / Polygon3DConstant_m0[19u].x;
      float _168 = _126 / Polygon3DConstant_m0[19u].y;
      float _176 = frac(abs(_167));
      float _177 = frac(abs(_168));
      float _180 = (_167 >= ((-0.0f) - _167)) ? _176 : ((-0.0f) - _176);
      float _181 = (_168 >= ((-0.0f) - _168)) ? _177 : ((-0.0f) - _177);
      float _201 = sin(((_181 * 6.283185482025146484375f) * Polygon3DConstant_m0[20u].x) + Polygon3DConstant_m0[18u].x);
      float _206 = sin(((_180 * 6.283185482025146484375f) * Polygon3DConstant_m0[20u].z) + Polygon3DConstant_m0[18u].y);
      frontier_phi_3_4_ladder = (((_206 * max(Polygon3DConstant_m0[20u].w, 0.0f)) + (_201 * abs(min(Polygon3DConstant_m0[20u].y, 0.0f)))) * 0.100000001490116119384765625f) + _126;
      frontier_phi_3_4_ladder_1 = (((_206 * abs(min(Polygon3DConstant_m0[20u].w, 0.0f))) + (_201 * max(Polygon3DConstant_m0[20u].y, 0.0f))) * 0.100000001490116119384765625f) + _123;
    } else {
      float _218 = Polygon3DConstant_m0[19u].z * Polygon3DConstant_m0[19u].x;
      float _219 = Polygon3DConstant_m0[19u].w * Polygon3DConstant_m0[19u].y;
      float _220 = _123 / _218;
      float _221 = _126 / _219;
      float _228 = frac(abs(_220));
      float _229 = frac(abs(_221));
      float _232 = (_220 >= ((-0.0f) - _220)) ? _228 : ((-0.0f) - _228);
      float _233 = (_221 >= ((-0.0f) - _221)) ? _229 : ((-0.0f) - _229);
      float _238 = _232 + (-0.5f);
      float _240 = _233 + (-0.5f);
      float _244 = sqrt((_240 * _240) + (_238 * _238));
      float _246 = atan(_240 / _238);
      bool _251 = _238 < 0.0f;
      bool _252 = _238 == 0.0f;
      bool _253 = _240 >= 0.0f;
      bool _254 = _240 < 0.0f;
      float _263 = (_252 && _253) ? 1.57079637050628662109375f : ((_252 && _254) ? (-1.57079637050628662109375f) : ((_251 && _254) ? (_246 + (-3.1415927410125732421875f)) : ((_251 && _253) ? (_246 + 3.1415927410125732421875f) : _246)));
      float _271 = (((_107 & 268435456u) != 0u) && (_263 > 0.0f)) ? ((-0.0f) - _263) : _263;
      float _275 = log2(_244 * 2.0f);
      float _384;
      if (Polygon3DConstant_m0[18u].y > 0.0f) {
        _384 = (_271 + 1.0f) - exp2((Polygon3DConstant_m0[18u].y * (-0.15915493667125701904296875f)) * _275);
      } else {
        _384 = (_271 + (-1.0f)) + exp2((Polygon3DConstant_m0[18u].y * 0.15915493667125701904296875f) * _275);
      }
      float _409 = _384 + (-3.1415927410125732421875f);
      float _414 = Polygon3DConstant_m0[21u].z * _409;
      float _416 = sin(_414);
      float _419 = sin(_414 * 3.1415927410125732421875f);
      float _427 = Polygon3DConstant_m0[22u].x * _409;
      float _429 = sin(_427);
      float _432 = sin(_427 * 3.1415927410125732421875f);
      float _442 = (Polygon3DConstant_m0[18u].z + _384) + ((((((Polygon3DConstant_m0[21u].w * _416) + _419) * 2.0f) - Polygon3DConstant_m0[21u].w) * 0.00999999977648258209228515625f) * (_419 + _416));
      float _452 = ((((((Polygon3DConstant_m0[20u].y * sin(((_244 * 6.283185482025146484375f) * Polygon3DConstant_m0[20u].x) + Polygon3DConstant_m0[18u].x)) + Polygon3DConstant_m0[20u].w) * 0.100000001490116119384765625f) * exp2(log2(_244) * Polygon3DConstant_m0[20u].z)) + _244) + ((((((Polygon3DConstant_m0[22u].y * _429) + _432) * 2.0f) - Polygon3DConstant_m0[22u].y) * 0.00999999977648258209228515625f) * (_432 + _429))) + (sin(Polygon3DConstant_m0[21u].x * _442) * Polygon3DConstant_m0[21u].y);
      frontier_phi_3_4_ladder = ((float(uint(_221)) + 0.5f) + (sin(_442) * _452)) * _219;
      frontier_phi_3_4_ladder_1 = ((float(uint(_220)) + 0.5f) + (_452 * cos(_442))) * _218;
    }
    _135 = frontier_phi_3_4_ladder_1;
    _138 = frontier_phi_3_4_ladder;
  }
  float _346;
  float _347;
  float _348;
  float _349;
  if ((_131 & 65536u) == 0u) {
    bool _159 = (_131 & 6144u) == 0u;
    float frontier_phi_17_5_ladder;
    float frontier_phi_17_5_ladder_1;
    float frontier_phi_17_5_ladder_2;
    float frontier_phi_17_5_ladder_3;
    if (GeometryAttribute.w < 0.0f) {
      bool _278 = (_131 & 1024u) != 0u;
      float frontier_phi_17_5_ladder_9_ladder;
      float frontier_phi_17_5_ladder_9_ladder_1;
      float frontier_phi_17_5_ladder_9_ladder_2;
      float frontier_phi_17_5_ladder_9_ladder_3;
      if (_111) {
        float4 _315 = primTex.Sample(BilinearClamp, float2(_135, _138));
        float _317 = _315.x;
        float _318 = _315.y;
        float _321 = _278 ? _317 : _318;
        float _322 = _278 ? _317 : _315.z;
        float _323 = _278 ? _318 : _315.w;
        float frontier_phi_17_5_ladder_9_ladder_14_ladder;
        float frontier_phi_17_5_ladder_9_ladder_14_ladder_1;
        float frontier_phi_17_5_ladder_9_ladder_14_ladder_2;
        float frontier_phi_17_5_ladder_9_ladder_14_ladder_3;
        if (_159) {
          frontier_phi_17_5_ladder_9_ladder_14_ladder = exp2(log2(_323) * 4.840000152587890625f);
          frontier_phi_17_5_ladder_9_ladder_14_ladder_1 = _317;
          frontier_phi_17_5_ladder_9_ladder_14_ladder_2 = _321;
          frontier_phi_17_5_ladder_9_ladder_14_ladder_3 = _322;
        } else {
          frontier_phi_17_5_ladder_9_ladder_14_ladder = _323;
          frontier_phi_17_5_ladder_9_ladder_14_ladder_1 = _317;
          frontier_phi_17_5_ladder_9_ladder_14_ladder_2 = _321;
          frontier_phi_17_5_ladder_9_ladder_14_ladder_3 = _322;
        }
        frontier_phi_17_5_ladder_9_ladder = frontier_phi_17_5_ladder_9_ladder_14_ladder;
        frontier_phi_17_5_ladder_9_ladder_1 = frontier_phi_17_5_ladder_9_ladder_14_ladder_1;
        frontier_phi_17_5_ladder_9_ladder_2 = frontier_phi_17_5_ladder_9_ladder_14_ladder_2;
        frontier_phi_17_5_ladder_9_ladder_3 = frontier_phi_17_5_ladder_9_ladder_14_ladder_3;
      } else {
        float _324 = _121 * TexCoord.x;
        float _325 = _124 * TexCoord.y;
        float _326 = ddy_coarse(_324);
        float _327 = ddy_coarse(_325);
        float _328 = ddx_coarse(_324);
        float _329 = ddx_coarse(_325);
        float4 _331 = primTex.SampleGrad(BilinearClamp, float2(_135, _138), float2(_328, _329), float2(_326, _327));
        float _335 = _331.x;
        float _336 = _331.y;
        float _339 = _278 ? _335 : _336;
        float _340 = _278 ? _335 : _331.z;
        float _341 = _278 ? _336 : _331.w;
        float frontier_phi_17_5_ladder_9_ladder_15_ladder;
        float frontier_phi_17_5_ladder_9_ladder_15_ladder_1;
        float frontier_phi_17_5_ladder_9_ladder_15_ladder_2;
        float frontier_phi_17_5_ladder_9_ladder_15_ladder_3;
        if (_159) {
          frontier_phi_17_5_ladder_9_ladder_15_ladder = exp2(log2(_341) * 4.840000152587890625f);
          frontier_phi_17_5_ladder_9_ladder_15_ladder_1 = _335;
          frontier_phi_17_5_ladder_9_ladder_15_ladder_2 = _339;
          frontier_phi_17_5_ladder_9_ladder_15_ladder_3 = _340;
        } else {
          frontier_phi_17_5_ladder_9_ladder_15_ladder = _341;
          frontier_phi_17_5_ladder_9_ladder_15_ladder_1 = _335;
          frontier_phi_17_5_ladder_9_ladder_15_ladder_2 = _339;
          frontier_phi_17_5_ladder_9_ladder_15_ladder_3 = _340;
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
      float4 _281 = primTex.SampleLevel(TrilinearClamp, float2(_135, _138), GeometryAttribute.w);
      float _283 = _281.x;
      float _284 = _281.y;
      float _285 = _281.z;
      float _286 = _281.w;
      float frontier_phi_17_5_ladder_10_ladder;
      float frontier_phi_17_5_ladder_10_ladder_1;
      float frontier_phi_17_5_ladder_10_ladder_2;
      float frontier_phi_17_5_ladder_10_ladder_3;
      if (_159) {
        frontier_phi_17_5_ladder_10_ladder = exp2(log2(_286) * 4.840000152587890625f);
        frontier_phi_17_5_ladder_10_ladder_1 = _283;
        frontier_phi_17_5_ladder_10_ladder_2 = _284;
        frontier_phi_17_5_ladder_10_ladder_3 = _285;
      } else {
        frontier_phi_17_5_ladder_10_ladder = _286;
        frontier_phi_17_5_ladder_10_ladder_1 = _283;
        frontier_phi_17_5_ladder_10_ladder_2 = _284;
        frontier_phi_17_5_ladder_10_ladder_3 = _285;
      }
      frontier_phi_17_5_ladder = frontier_phi_17_5_ladder_10_ladder;
      frontier_phi_17_5_ladder_1 = frontier_phi_17_5_ladder_10_ladder_1;
      frontier_phi_17_5_ladder_2 = frontier_phi_17_5_ladder_10_ladder_2;
      frontier_phi_17_5_ladder_3 = frontier_phi_17_5_ladder_10_ladder_3;
    }
    _346 = frontier_phi_17_5_ladder_1;
    _347 = frontier_phi_17_5_ladder_2;
    _348 = frontier_phi_17_5_ladder_3;
    _349 = frontier_phi_17_5_ladder;
  } else {
    float _162 = ((_138 - TexCoord_1.y) / _124) * GhostItem;
    float _165 = (GhostItem + (-1.0f)) * 0.125f;
    float _288;
    float _290;
    float _292;
    float _294;
    float _287 = 0.0f;
    float _289 = 0.0f;
    float _291 = 0.0f;
    float _293 = 0.0f;
    float _295 = _162;
    uint _297 = 0u;
    bool _301;
    for (;;) {
      _301 = (_295 >= 0.0f) && (_295 <= 1.0f);
      float frontier_phi_19_pred;
      float frontier_phi_19_pred_1;
      float frontier_phi_19_pred_2;
      float frontier_phi_19_pred_3;
      if (_301) {
        uint4 _363 = asuint(Polygon3DConstant_m0[26u]);
        uint _364 = _363.w;
        bool _366 = (_364 & 1024u) != 0u;
        float4 _368 = primTex.Sample(BilinearClamp, float2(_135, (_295 * _124) + TexCoord_1.y));
        float _370 = _368.x;
        float _371 = _368.y;
        float _376 = _366 ? _371 : _368.w;
        float _611;
        if ((_364 & 6144u) == 0u) {
          _611 = exp2(log2(_376) * 4.840000152587890625f);
        } else {
          _611 = _376;
        }
        float _615 = (float(int(8u - _297)) * 0.125f) * _611;
        frontier_phi_19_pred = 1.0f - ((1.0f - _615) * (1.0f - _293));
        frontier_phi_19_pred_1 = (_615 * ((_366 ? _370 : _368.z) - _291)) + _291;
        frontier_phi_19_pred_2 = (_615 * ((_366 ? _370 : _371) - _289)) + _289;
        frontier_phi_19_pred_3 = (_615 * (_370 - _287)) + _287;
      } else {
        frontier_phi_19_pred = _293;
        frontier_phi_19_pred_1 = _291;
        frontier_phi_19_pred_2 = _289;
        frontier_phi_19_pred_3 = _287;
      }
      _294 = frontier_phi_19_pred;
      _292 = frontier_phi_19_pred_1;
      _290 = frontier_phi_19_pred_2;
      _288 = frontier_phi_19_pred_3;
      uint _298 = _297 + 1u;
      if (_298 == 8u) {
        break;
      } else {
        _287 = _288;
        _289 = _290;
        _291 = _292;
        _293 = _294;
        _295 -= _165;
        _297 = _298;
        continue;
      }
    }
    _346 = _288;
    _347 = _290;
    _348 = _292;
    _349 = _294;
  }
  uint4 _354 = asuint(Polygon3DConstant_m0[26u]);
  uint _355 = _354.w;
  float _625;
  float _627;
  float _629;
  float _631;
  float _633;
  float _634;
  float _635;
  if ((_355 & 2048u) == 0u) {
    float frontier_phi_28_23_ladder;
    float frontier_phi_28_23_ladder_1;
    float frontier_phi_28_23_ladder_2;
    float frontier_phi_28_23_ladder_3;
    float frontier_phi_28_23_ladder_4;
    float frontier_phi_28_23_ladder_5;
    float frontier_phi_28_23_ladder_6;
    if ((_355 & 4096u) == 0u) {
      frontier_phi_28_23_ladder = 0.0f;
      frontier_phi_28_23_ladder_1 = 0.0f;
      frontier_phi_28_23_ladder_2 = 0.0f;
      frontier_phi_28_23_ladder_3 = _349;
      frontier_phi_28_23_ladder_4 = _348;
      frontier_phi_28_23_ladder_5 = _347;
      frontier_phi_28_23_ladder_6 = _346;
    } else {
      uint4 _684 = asuint(Polygon3DConstant_m0[38u]);
      uint _685 = _684.x;
      uint _696 = _684.y;
      uint _707 = _684.z;
      float2 _710 = spvUnpackHalf2x16((_707 << 4u) & 32752u);
      float _711 = _710.x;
      float2 _714 = spvUnpackHalf2x16((_707 >> 7u) & 32752u);
      float _715 = _714.x;
      float _734 = _711 * _346;
      float _741 = (spvUnpackHalf2x16((RgbItem >> 22u) << 5u).x * (_348 - _347)) + _347;
      frontier_phi_28_23_ladder = 0.0f;
      frontier_phi_28_23_ladder_1 = 0.0f;
      frontier_phi_28_23_ladder_2 = 0.0f;
      frontier_phi_28_23_ladder_3 = clamp(((_349 * 0.0039215688593685626983642578125f) * spvUnpackHalf2x16((_707 >> 22u) << 5u).x) * (((spvUnpackHalf2x16((RgbItem >> 7u) & 32752u).x * float(_696 >> 24u)) * _741) + ((float(_685 >> 24u) * _346) * spvUnpackHalf2x16((RgbItem << 4u) & 32752u).x)), 0.0f, 1.0f);
      frontier_phi_28_23_ladder_4 = (((float((_696 >> 16u) & 255u) * _715) * _741) + (_734 * float((_685 >> 16u) & 255u))) * 0.0039215688593685626983642578125f;
      frontier_phi_28_23_ladder_5 = (((float((_696 >> 8u) & 255u) * _715) * _741) + (_734 * float((_685 >> 8u) & 255u))) * 0.0039215688593685626983642578125f;
      frontier_phi_28_23_ladder_6 = (((_715 * float(_696 & 255u)) * _741) + ((float(_685 & 255u) * _346) * _711)) * 0.0039215688593685626983642578125f;
    }
    _625 = frontier_phi_28_23_ladder_6;
    _627 = frontier_phi_28_23_ladder_5;
    _629 = frontier_phi_28_23_ladder_4;
    _631 = frontier_phi_28_23_ladder_3;
    _633 = frontier_phi_28_23_ladder_2;
    _634 = frontier_phi_28_23_ladder_1;
    _635 = frontier_phi_28_23_ladder;
  } else {
    bool _468 = (_355 & 16384u) != 0u;
    bool _471 = (_355 & 8192u) != 0u;
    uint4 _475 = asuint(Polygon3DConstant_m0[38u]);
    uint _476 = _475.x;
    float _490 = float(_476 & 255u) * 0.0039215688593685626983642578125f;
    float _492 = float((_476 >> 8u) & 255u) * 0.0039215688593685626983642578125f;
    float _493 = float((_476 >> 16u) & 255u) * 0.0039215688593685626983642578125f;
    uint _495 = _475.y;
    uint _510 = _475.z;
    uint _526 = _475.w;
    float2 _537 = spvUnpackHalf2x16(RgbItem & 65535u);
    float _538 = _537.x;
    float _548 = (float(_476 >> 24u) * 0.0039215688593685626983642578125f) * exp2(log2(max(spvUnpackHalf2x16(RgbItem >> 16u).x * _347, 9.9999999392252902907785028219223e-09f)) * spvUnpackHalf2x16((_510 >> 7u) & 32752u).x);
    float _549 = _548 * spvUnpackHalf2x16((_510 << 4u) & 32752u).x;
    float _553 = clamp(_549 / max(spvUnpackHalf2x16((_510 >> 22u) << 5u).x, 9.9999999747524270787835121154785e-07f), 0.0f, 1.0f);
    float _554 = _553 * _553;
    float _564 = ((_554 * (1.0f - _490)) + _490) * _549;
    float _565 = ((_554 * (1.0f - _492)) + _492) * _549;
    float _566 = ((_554 * (1.0f - _493)) + _493) * _549;
    float _574 = ((_538 * (_348 - _346)) + _346) * spvUnpackHalf2x16((_526 << 4u) & 32752u).x;
    float _575 = (float(_495 & 255u) * 0.0039215688593685626983642578125f) * _574;
    float _576 = (float((_495 >> 8u) & 255u) * 0.0039215688593685626983642578125f) * _574;
    float _577 = (float((_495 >> 16u) & 255u) * 0.0039215688593685626983642578125f) * _574;
    float _579 = float(!_471);
    float _584 = float(!_468);
    float _591 = float(_471);
    float _595 = float(_468);
    float _604 = clamp((_548 + ((float(_495 >> 24u) * 0.0039215688593685626983642578125f) * ((_538 * (_348 - _349)) + _349))) * spvUnpackHalf2x16((_526 >> 7u) & 32752u).x, 0.0f, 1.0f);
    _625 = (_564 * _595) + (_575 * _591);
    _627 = (_565 * _595) + (_576 * _591);
    _629 = (_566 * _595) + (_577 * _591);
    _631 = (_604 <= 9.9999997473787516355514526367188e-05f) ? 0.0f : _604;
    _633 = (_564 * _584) + (_575 * _579);
    _634 = (_565 * _584) + (_576 * _579);
    _635 = (_566 * _584) + (_577 * _579);
  }

#if 1
  HueShiftFire(_625, _627, _629);
#endif

  float _641 = _631 * Color.w;
  float _658 = SceneInfo_m0[22u].z / (SceneInfo_m0[22u].x - (SceneInfo_m0[22u].y * ReadonlyDepth.Load(int3(uint2(uint(int(gl_FragCoord.x)), uint(int(gl_FragCoord.y))), 0u)).x));
  float _662 = dot(float3(_625, _627, _629), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _668 = _662 * _641;
  float _680 = ((SceneInfo_m0[22u].z / (SceneInfo_m0[22u].x - (SceneInfo_m0[22u].y * gl_FragCoord.z))) + Polygon3DConstant_m0[27u].z) - ((((exp2(log2(sin(_641 * 1.57079637050628662109375f)) * 0.4545449912548065185546875f) - _668) * Polygon3DConstant_m0[27u].w) + _668) * Polygon3DConstant_m0[27u].z);
  float _761;
  if (Polygon3DConstant_m0[0u].y > 0.0f) {
    _761 = clamp((_658 - _680) / Polygon3DConstant_m0[0u].y, 0.0f, 1.0f);
  } else {
    float frontier_phi_32_31_ladder;
    if (Polygon3DConstant_m0[0u].y < 0.0f) {
      float _810 = clamp(abs(_658 - _680) / ((-0.0f) - Polygon3DConstant_m0[0u].y), 0.0f, 1.0f);
      float _812 = (_810 < 0.5f) ? 0.0f : 1.0f;
      frontier_phi_32_31_ladder = ((_810 * 2.0f) * (1.0f - _812)) + ((1.0f - ((_810 + (-0.5f)) * 2.0f)) * _812);
    } else {
      frontier_phi_32_31_ladder = 1.0f;
    }
    _761 = frontier_phi_32_31_ladder;
  }
  float _770 = clamp((_631 - Polygon3DConstant_m0[26u].z) / (Polygon3DConstant_m0[26u].y - Polygon3DConstant_m0[26u].z), 0.0f, 1.0f);
  float _780 = exp2(log2(((_770 * _770) * _631) * (3.0f - (_770 * 2.0f))) * Polygon3DConstant_m0[26u].x);
  float _781 = 1.0f / AlphaCorrection.y;
  float _789 = clamp(clamp(((_780 * Color.w) - AlphaCorrection.x) * _781, 0.0f, 1.0f), 0.0f, 1.0f);
  float _803 = ((((((_789 * _789) * AlphaCorrection.z) * (3.0f - (_789 * 2.0f))) + (clamp((_780 - AlphaCorrection.x) * _781, 0.0f, 1.0f) * (1.0f - AlphaCorrection.z))) * AlphaCorrection.w) + ((Color.w * (1.0f - AlphaCorrection.w)) * _780)) * _761;
  if (_803 < 1.1920928955078125e-07f) {
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
    bool _832 = Polygon3DConstant_m0[29u].y > 0.0f;
    float _856;
    float _857;
    if (_832) {
      float _848 = (((clamp(Polygon3DConstant_m0[28u].x + clamp((_662 * _803) * Polygon3DConstant_m0[28u].w, 0.0f, 1.0f), 0.0f, 1.0f) / (Polygon3DConstant_m0[28u].x + 1.0f)) * 2.0f) + (-1.0f)) * Polygon3DConstant_m0[28u].y;
      _856 = clamp(_848, 0.0f, 1.0f);
      _857 = float(clamp((-0.0f) - _848, 0.0f, 1.0f) < Polygon3DConstant_m0[28u].z) * _803;
    } else {
      _856 = 1.0f;
      _857 = _803;
    }
    uint4 _863 = asuint(Polygon3DConstant_m0[29u]);
    uint _864 = _863.w;
    uint _865 = _863.z;
    float _870;
    float _872;
    float _874;
    if ((_355 & 262144u) == 0u) {
      _870 = 1.0f;
      _872 = 1.0f;
      _874 = 1.0f;
    } else {
      float _887 = clamp(((_662 * Color.w) - Polygon3DConstant_m0[30u].w) / (Polygon3DConstant_m0[30u].z - Polygon3DConstant_m0[30u].w), 0.0f, 1.0f);
      float _891 = (_887 * _887) * (3.0f - (_887 * 2.0f));
      float _900 = Polygon3DConstant_m0[30u].x * 0.0039215688593685626983642578125f;
      float _912 = Polygon3DConstant_m0[30u].y * 0.0039215688593685626983642578125f;
      float _913 = _912 * float(_864 & 255u);
      float _914 = _912 * float((_864 >> 8u) & 255u);
      float _915 = _912 * float((_864 >> 16u) & 255u);
      _870 = (_891 * ((_900 * float(_865 & 255u)) - _913)) + _913;
      _872 = (_891 * ((_900 * float((_865 >> 8u) & 255u)) - _914)) + _914;
      _874 = (_891 * ((_900 * float((_865 >> 16u) & 255u)) - _915)) + _915;
    }
    float _922;
    float _928;
    float _934;
    float _940;
    switch ((_107 >> 11u) & 15u) {
      case 0u: {
        float _959 = (Polygon3DConstant_m0[15u].w * (_633 + _625)) * Color.x;
        float _962 = (Polygon3DConstant_m0[15u].w * (_634 + _627)) * Color.y;
        float _965 = (Polygon3DConstant_m0[15u].w * (_635 + _629)) * Color.z;
        float _970 = _959 * Polygon3DConstant_m0[32u].y;
        float _971 = _962 * Polygon3DConstant_m0[32u].y;
        float _972 = _965 * Polygon3DConstant_m0[32u].y;
        float _1090;
        float _1092;
        float _1094;
        if ((_107 & 1024u) == 0u) {
          _1090 = _970;
          _1092 = _971;
          _1094 = _972;
        } else {
          float _1119 = (((asuint(Tonemap_m0[1u]).x != 0u) ? asfloat(WhitePtSrv.Load(0u).x) : 1.0f) * Tonemap_m0[0u].x) * max(1.0f - Tonemap_m0[0u].y, 9.9999997473787516355514526367188e-05f);
          _1090 = (Polygon3DConstant_m0[16u].y * (max(0.0f, _959 / _1119) - _970)) + _970;
          _1092 = (Polygon3DConstant_m0[16u].y * (max(0.0f, _962 / _1119) - _971)) + _971;
          _1094 = (Polygon3DConstant_m0[16u].y * (max(0.0f, _965 / _1119) - _972)) + _972;
        }
        float _945 = exp2(log2(max(9.9999999747524270787835121154785e-07f, Color.w)) * Polygon3DConstant_m0[13u].y) * _857;
        float _1296;
        float _1297;
        float _1298;
        if (_832) {
          uint _1271 = _863.x;
          float _1283 = exp2(Polygon3DConstant_m0[29u].y * 1.44269502162933349609375f) * 0.0039215688593685626983642578125f;
          float _1284 = _1283 * float(_1271 & 255u);
          float _1285 = _1283 * float((_1271 >> 8u) & 255u);
          float _1286 = _1283 * float((_1271 >> 16u) & 255u);
          _1296 = (_1284 + _1090) - (_1284 * _856);
          _1297 = (_1285 + _1092) - (_1285 * _856);
          _1298 = (_1286 + _1094) - (_1286 * _856);
        } else {
          _1296 = _1090;
          _1297 = _1092;
          _1298 = _1094;
        }
        _922 = ((_945 * _870) * _1296) * Polygon3DConstant_m0[12u].w;
        _928 = ((_945 * _872) * _1297) * Polygon3DConstant_m0[12u].w;
        _934 = ((_945 * _874) * _1298) * Polygon3DConstant_m0[12u].w;
        _940 = _945;
        break;
      }
      case 1u: {
        float _986 = (((_662 * _662) * 37.5f) * Polygon3DConstant_m0[15u].w) * Polygon3DConstant_m0[32u].x;
        float _987 = _986 + 1.0f;
        float _988 = _986 + Polygon3DConstant_m0[32u].y;
        float _992 = (_761 * Color.x) * _625;
        float _994 = (_761 * Color.y) * _627;
        float _996 = (_761 * Color.z) * _629;
        float _1004 = (_992 * _988) + ((_633 * Color.x) * _761);
        float _1005 = (_994 * _988) + ((_634 * Color.y) * _761);
        float _1006 = (_996 * _988) + ((_635 * Color.z) * _761);
        float _1135;
        float _1137;
        float _1139;
        if ((_107 & 1024u) == 0u) {
          _1135 = _1004;
          _1137 = _1005;
          _1139 = _1006;
        } else {
          float _1168 = (((asuint(Tonemap_m0[1u]).x != 0u) ? asfloat(WhitePtSrv.Load(0u).x) : 1.0f) * Tonemap_m0[0u].x) * max(1.0f - Tonemap_m0[0u].y, 9.9999997473787516355514526367188e-05f);
          _1135 = (Polygon3DConstant_m0[16u].y * (max(0.0f, (_992 * _987) / _1168) - _1004)) + _1004;
          _1137 = (Polygon3DConstant_m0[16u].y * (max(0.0f, (_994 * _987) / _1168) - _1005)) + _1005;
          _1139 = (Polygon3DConstant_m0[16u].y * (max(0.0f, (_996 * _987) / _1168) - _1006)) + _1006;
        }
        float _1148 = exp2(log2(max(9.9999999747524270787835121154785e-07f, Color.w)) * Polygon3DConstant_m0[13u].y) * _857;
        float _1333;
        float _1334;
        float _1335;
        if (_832) {
          uint _1309 = _863.x;
          float _1320 = exp2(Polygon3DConstant_m0[29u].y * 1.44269502162933349609375f) * 0.0039215688593685626983642578125f;
          float _1321 = _1320 * float(_1309 & 255u);
          float _1322 = _1320 * float((_1309 >> 8u) & 255u);
          float _1323 = _1320 * float((_1309 >> 16u) & 255u);
          _1333 = (_1321 + _1135) - (_1321 * _856);
          _1334 = (_1322 + _1137) - (_1322 * _856);
          _1335 = (_1323 + _1139) - (_1323 * _856);
        } else {
          _1333 = _1135;
          _1334 = _1137;
          _1335 = _1139;
        }
        _922 = ((_1148 * _870) * _1333) * Polygon3DConstant_m0[12u].w;
        _928 = ((_1148 * _872) * _1334) * Polygon3DConstant_m0[12u].w;
        _934 = ((_1148 * _874) * _1335) * Polygon3DConstant_m0[12u].w;
        _940 = Polygon3DConstant_m0[16u].x * _1148;
        break;
      }
      case 2u: {
        float _1019 = (Polygon3DConstant_m0[15u].w * (_633 + _625)) * Color.x;
        float _1022 = (Polygon3DConstant_m0[15u].w * (_634 + _627)) * Color.y;
        float _1025 = (Polygon3DConstant_m0[15u].w * (_635 + _629)) * Color.z;
        float _1348;
        float _1349;
        float _1350;
        if ((_107 & 1024u) == 0u) {
          _1348 = Polygon3DConstant_m0[32u].y * _1019;
          _1349 = Polygon3DConstant_m0[32u].y * _1022;
          _1350 = Polygon3DConstant_m0[32u].y * _1025;
        } else {
          float _1206 = (((asuint(Tonemap_m0[1u]).x != 0u) ? asfloat(WhitePtSrv.Load(0u).x) : 1.0f) * Tonemap_m0[0u].x) * max(1.0f - Tonemap_m0[0u].y, 9.9999997473787516355514526367188e-05f);
          _1348 = max(0.0f, _1019 / _1206);
          _1349 = max(0.0f, _1022 / _1206);
          _1350 = max(0.0f, _1025 / _1206);
        }
        float _1356 = exp2(log2(max(9.9999999747524270787835121154785e-07f, Color.w)) * Polygon3DConstant_m0[13u].y) * _857;
        float _1398;
        float _1399;
        float _1400;
        if (_832) {
          uint _1374 = _863.x;
          float _1385 = exp2(Polygon3DConstant_m0[29u].y * 1.44269502162933349609375f) * 0.0039215688593685626983642578125f;
          float _1386 = _1385 * float(_1374 & 255u);
          float _1387 = _1385 * float((_1374 >> 8u) & 255u);
          float _1388 = _1385 * float((_1374 >> 16u) & 255u);
          _1398 = (_1386 + _1348) - (_1386 * _856);
          _1399 = (_1387 + _1349) - (_1387 * _856);
          _1400 = (_1388 + _1350) - (_1388 * _856);
        } else {
          _1398 = _1348;
          _1399 = _1349;
          _1400 = _1350;
        }
        _922 = ((_1356 * _870) * _1398) * Polygon3DConstant_m0[12u].w;
        _928 = ((_1356 * _872) * _1399) * Polygon3DConstant_m0[12u].w;
        _934 = ((_1356 * _874) * _1400) * Polygon3DConstant_m0[12u].w;
        _940 = (-0.0f) - (_857 * Polygon3DConstant_m0[13u].w);
        break;
      }
      case 3u: {
        float _1034 = exp2(log2(1.0f - _780) * Polygon3DConstant_m0[15u].z);
        float _1035 = 1.0f - _1034;
        float _1047 = _1034 * 100.0f;
        float _1061 = ((Polygon3DConstant_m0[15u].w * (_633 + _1035)) * Color.x) + (((_1047 * Polygon3DConstant_m0[14u].x) * Polygon3DConstant_m0[13u].w) * Polygon3DConstant_m0[14u].w);
        float _1065 = ((Polygon3DConstant_m0[15u].w * (_634 + _1035)) * Color.y) + (((_1047 * Polygon3DConstant_m0[14u].y) * Polygon3DConstant_m0[13u].w) * Polygon3DConstant_m0[14u].w);
        float _1069 = ((Polygon3DConstant_m0[15u].w * (_635 + _1035)) * Color.z) + (((_1047 * Polygon3DConstant_m0[14u].z) * Polygon3DConstant_m0[13u].w) * Polygon3DConstant_m0[14u].w);
        float _1357;
        float _1358;
        float _1359;
        if ((_107 & 1024u) == 0u) {
          _1357 = Polygon3DConstant_m0[32u].y * _1061;
          _1358 = Polygon3DConstant_m0[32u].y * _1065;
          _1359 = Polygon3DConstant_m0[32u].y * _1069;
        } else {
          float _1235 = (((asuint(Tonemap_m0[1u]).x != 0u) ? asfloat(WhitePtSrv.Load(0u).x) : 1.0f) * Tonemap_m0[0u].x) * max(1.0f - Tonemap_m0[0u].y, 9.9999997473787516355514526367188e-05f);
          _1357 = max(0.0f, _1061 / _1235);
          _1358 = max(0.0f, _1065 / _1235);
          _1359 = max(0.0f, _1069 / _1235);
        }
        float _942 = exp2(log2(max(9.9999999747524270787835121154785e-07f, Color.w)) * Polygon3DConstant_m0[13u].y) * _857;
        float _1434;
        float _1435;
        float _1436;
        if (_832) {
          uint _1410 = _863.x;
          float _1421 = exp2(Polygon3DConstant_m0[29u].y * 1.44269502162933349609375f) * 0.0039215688593685626983642578125f;
          float _1422 = _1421 * float(_1410 & 255u);
          float _1423 = _1421 * float((_1410 >> 8u) & 255u);
          float _1424 = _1421 * float((_1410 >> 16u) & 255u);
          _1434 = (_1422 + _1357) - (_1422 * _856);
          _1435 = (_1423 + _1358) - (_1423 * _856);
          _1436 = (_1424 + _1359) - (_1424 * _856);
        } else {
          _1434 = _1357;
          _1435 = _1358;
          _1436 = _1359;
        }
        _922 = ((_942 * _870) * _1434) * Polygon3DConstant_m0[12u].w;
        _928 = ((_942 * _872) * _1435) * Polygon3DConstant_m0[12u].w;
        _934 = ((_942 * _874) * _1436) * Polygon3DConstant_m0[12u].w;
        _940 = _942;
        break;
      }
      case 4u: {
        float _1081 = (Polygon3DConstant_m0[15u].w * (_633 + _625)) * Color.x;
        float _1084 = (Polygon3DConstant_m0[15u].w * (_634 + _627)) * Color.y;
        float _1087 = (Polygon3DConstant_m0[15u].w * (_635 + _629)) * Color.z;
        float _1365;
        float _1366;
        float _1367;
        if ((_107 & 1024u) == 0u) {
          _1365 = Polygon3DConstant_m0[32u].y * _1081;
          _1366 = Polygon3DConstant_m0[32u].y * _1084;
          _1367 = Polygon3DConstant_m0[32u].y * _1087;
        } else {
          float _1264 = (((asuint(Tonemap_m0[1u]).x != 0u) ? asfloat(WhitePtSrv.Load(0u).x) : 1.0f) * Tonemap_m0[0u].x) * max(1.0f - Tonemap_m0[0u].y, 9.9999997473787516355514526367188e-05f);
          _1365 = max(0.0f, _1081 / _1264);
          _1366 = max(0.0f, _1084 / _1264);
          _1367 = max(0.0f, _1087 / _1264);
        }
        float _1373 = exp2(log2(max(9.9999999747524270787835121154785e-07f, Color.w)) * Polygon3DConstant_m0[13u].y) * _857;
        float _1470;
        float _1471;
        float _1472;
        if (_832) {
          uint _1446 = _863.x;
          float _1457 = exp2(Polygon3DConstant_m0[29u].y * 1.44269502162933349609375f) * 0.0039215688593685626983642578125f;
          float _1458 = _1457 * float(_1446 & 255u);
          float _1459 = _1457 * float((_1446 >> 8u) & 255u);
          float _1460 = _1457 * float((_1446 >> 16u) & 255u);
          _1470 = (_1458 + _1365) - (_1458 * _856);
          _1471 = (_1459 + _1366) - (_1459 * _856);
          _1472 = (_1460 + _1367) - (_1460 * _856);
        } else {
          _1470 = _1365;
          _1471 = _1366;
          _1472 = _1367;
        }
        _922 = ((_1373 * _870) * _1470) * Polygon3DConstant_m0[12u].w;
        _928 = ((_1373 * _872) * _1471) * Polygon3DConstant_m0[12u].w;
        _934 = ((_1373 * _874) * _1472) * Polygon3DConstant_m0[12u].w;
        _940 = min((Polygon3DConstant_m0[13u].w * Color.w) * _1373, 1.0f);
        break;
      }
      default: {
        _922 = 0.0f;
        _928 = 0.0f;
        _934 = 0.0f;
        _940 = 0.0f;
        break;
      }
    }
    SV_Target.x = 0.0f;
    SV_Target.y = 0.0f;
    SV_Target.z = 0.0f;
    SV_Target.w = 0.0f;
    SV_Target_1 = 0.0f;
    SV_Target.x = _922;
    SV_Target.y = _928;
    SV_Target.z = _934;
    SV_Target.w = _940;
    SV_Target_1 = _940;
  }

  // HueShiftFire(SV_Target.rgb);
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
