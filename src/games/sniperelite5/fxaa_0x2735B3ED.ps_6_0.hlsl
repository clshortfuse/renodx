#include "./shared.h"
Texture2D<float4> g_xPostToneMapFrameBufferTexture : register(t2);

cbuffer FXAAConstants : register(b9) {
  float2 g_xRcpFrame : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);

#include "./fxaa.hlsli"

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _9 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float4 _14 = g_xPostToneMapFrameBufferTexture.GatherAlpha(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _18 = g_xPostToneMapFrameBufferTexture.GatherAlpha(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), int2(-1, -1));
  float _22 = max(_14.x, _9.w);
  float _23 = min(_14.x, _9.w);
  float _24 = max(_14.z, _22);
  float _25 = min(_14.z, _23);
  float _26 = max(_18.z, _18.x);
  float _27 = min(_18.z, _18.x);
  float _28 = max(_26, _24);
  float _29 = min(_27, _25);
  float _30 = _28 * 0.1666666716337204f;
  float _31 = _28 - _29;
  float _32 = max(0.0833333358168602f, _30);
  bool _33 = (_31 < _32);
  float _76;
  float _79;
  float _82;
  float _94;
  float _104;
  float _109;
  float _125;
  float _142;
  float _147;
  float _153;
  float _158;
  float _164;
  float _169;
  float _173;
  float _177;
  float _186;
  float _191;
  float _196;
  float _201;
  float _202;
  float _203;
  float _204;
  float _205;
  float _206;
  float _212;
  float _216;
  float _235;
  float _240;
  float _246;
  float _247;
  float _248;
  [branch]
  if (!_33) {
    float4 _35 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, -1));
    float4 _37 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, 1));
    float _39 = _18.z + _14.x;
    float _40 = _18.x + _14.z;
    float _41 = 1.0f / _31;
    float _42 = _39 + _40;
    float _43 = _9.w * 2.0f;
    float _44 = _39 - _43;
    float _45 = _40 - _43;
    float _46 = _35.w + _14.y;
    float _47 = _18.w + _35.w;
    float _48 = _14.z * 2.0f;
    float _49 = _46 - _48;
    float _50 = _18.z * 2.0f;
    float _51 = _47 - _50;
    float _52 = _37.w + _18.w;
    float _53 = _14.y + _37.w;
    float _54 = abs(_44);
    float _55 = _54 * 2.0f;
    float _56 = abs(_49);
    float _57 = _55 + _56;
    float _58 = abs(_45);
    float _59 = _58 * 2.0f;
    float _60 = abs(_51);
    float _61 = _59 + _60;
    float _62 = _18.x * 2.0f;
    float _63 = _52 - _62;
    float _64 = _14.x * 2.0f;
    float _65 = _53 - _64;
    float _66 = abs(_63);
    float _67 = _57 + _66;
    float _68 = abs(_65);
    float _69 = _61 + _68;
    bool _70 = (_67 >= _69);
    float _71 = _42 * 2.0f;
    float _72 = _46 + _71;
    float _73 = _72 + _52;
    [branch]
    if (!_70) {
      _76 = _18.x;
    } else {
      _76 = _18.z;
    }
    [branch]
    if (!_70) {
      _79 = _14.z;
    } else {
      _79 = _14.x;
    }
    [branch]
    if (_70) {
      _82 = g_xRcpFrame.y;
    } else {
      _82 = g_xRcpFrame.x;
    }
    float _83 = _73 * 0.0833333358168602f;
    float _84 = _83 - _9.w;
    float _85 = _76 - _9.w;
    float _86 = _79 - _9.w;
    float _87 = abs(_85);
    float _88 = abs(_86);
    bool _89 = (_87 >= _88);
    float _90 = max(_87, _88);
    [branch]
    if (_89) {
      float _92 = -0.0f - _82;
      _94 = _92;
    } else {
      _94 = _82;
    }
    float _95 = abs(_84);
    float _96 = _95 * _41;
    float _97 = saturate(_96);
    float _98 = select(_70, g_xRcpFrame.x, 0.0f);
    float _99 = select(_70, 0.0f, g_xRcpFrame.y);
    [branch]
    if (!_70) {
      float _101 = _94 * 0.5f;
      float _102 = _101 + TEXCOORD.x;
      _104 = _102;
    } else {
      _104 = TEXCOORD.x;
    }
    [branch]
    if (_70) {
      float _106 = _94 * 0.5f;
      float _107 = _106 + TEXCOORD.y;
      _109 = _107;
    } else {
      _109 = TEXCOORD.y;
    }
    float _110 = _98 * 1.5f;
    float _111 = _104 - _110;
    float _112 = _99 * 1.5f;
    float _113 = _109 - _112;
    float _114 = _104 + _110;
    float _115 = _109 + _112;
    float _116 = _97 * 2.0f;
    float _117 = 3.0f - _116;
    float4 _118 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_111, _113), 0.0f);
    float _120 = _97 * _97;
    float4 _121 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_114, _115), 0.0f);
    [branch]
    if (!_89) {
      _125 = _79;
    } else {
      _125 = _76;
    }
    float _126 = _9.w + _125;
    float _127 = _90 * 0.25f;
    float _128 = _126 * 0.5f;
    float _129 = _9.w - _128;
    float _130 = _120 * _117;
    bool _131 = (_129 < 0.0f);
    float _132 = _118.w - _128;
    float _133 = _121.w - _128;
    float _134 = abs(_132);
    bool _135 = (_134 >= _127);
    float _136 = abs(_133);
    bool _137 = (_136 >= _127);
    [branch]
    if (!_135) {
      float _139 = _98 * 2.0f;
      float _140 = _111 - _139;
      _142 = _140;
    } else {
      _142 = _111;
    }
    [branch]
    if (!_135) {
      float _144 = _99 * 2.0f;
      float _145 = _113 - _144;
      _147 = _145;
    } else {
      _147 = _113;
    }
    bool _148 = _135 && _137;
    [branch]
    if (!_137) {
      float _150 = _98 * 2.0f;
      float _151 = _114 + _150;
      _153 = _151;
    } else {
      _153 = _114;
    }
    [branch]
    if (!_137) {
      float _155 = _99 * 2.0f;
      float _156 = _115 + _155;
      _158 = _156;
    } else {
      _158 = _115;
    }
    [branch]
    if (!_148) {
      [branch]
      if (!_135) {
        float4 _161 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_142, _147), 0.0f);
        _164 = _161.w;
      } else {
        _164 = _132;
      }
      [branch]
      if (!_137) {
        float4 _166 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_153, _158), 0.0f);
        _169 = _166.w;
      } else {
        _169 = _133;
      }
      [branch]
      if (!_135) {
        float _171 = _164 - _128;
        _173 = _171;
      } else {
        _173 = _164;
      }
      [branch]
      if (!_137) {
        float _175 = _169 - _128;
        _177 = _175;
      } else {
        _177 = _169;
      }
      float _178 = abs(_173);
      bool _179 = (_178 >= _127);
      float _180 = abs(_177);
      bool _181 = (_180 >= _127);
      [branch]
      if (!_179) {
        float _183 = _98 * 8.0f;
        float _184 = _142 - _183;
        _186 = _184;
      } else {
        _186 = _142;
      }
      [branch]
      if (!_179) {
        float _188 = _99 * 8.0f;
        float _189 = _147 - _188;
        _191 = _189;
      } else {
        _191 = _147;
      }
      [branch]
      if (!_181) {
        float _193 = _98 * 8.0f;
        float _194 = _153 + _193;
        _196 = _194;
      } else {
        _196 = _153;
      }
      [branch]
      if (!_181) {
        float _198 = _99 * 8.0f;
        float _199 = _158 + _198;
        _201 = _186;
        _202 = _191;
        _203 = _196;
        _204 = _199;
        _205 = _173;
        _206 = _177;
      } else {
        _201 = _186;
        _202 = _191;
        _203 = _196;
        _204 = _158;
        _205 = _173;
        _206 = _177;
      }
    } else {
      _201 = _142;
      _202 = _147;
      _203 = _153;
      _204 = _158;
      _205 = _132;
      _206 = _133;
    }
    float _207 = TEXCOORD.x - _201;
    float _208 = _203 - TEXCOORD.x;
    [branch]
    if (!_70) {
      float _210 = TEXCOORD.y - _202;
      _212 = _210;
    } else {
      _212 = _207;
    }
    [branch]
    if (!_70) {
      float _214 = _204 - TEXCOORD.y;
      _216 = _214;
    } else {
      _216 = _208;
    }
    bool _217 = (_205 < 0.0f);
    float _218 = _216 + _212;
    bool _219 = (_206 < 0.0f);
    float _220 = 1.0f / _218;
    bool _221 = (_212 < _216);
    float _222 = min(_212, _216);
    bool _223 = select(_221, _217, _219);
    bool _224 = _131 ^ _223;
    float _225 = _222 * _220;
    float _226 = 0.5f - _225;
    float _227 = _130 * _130;
    float _228 = _227 * 0.75f;
    float _229 = select(_224, _226, 0.0f);
    float _230 = max(_229, _228);
    [branch]
    if (!_70) {
      float _232 = _230 * _94;
      float _233 = _232 + TEXCOORD.x;
      _235 = _233;
    } else {
      _235 = TEXCOORD.x;
    }
    [branch]
    if (_70) {
      float _237 = _230 * _94;
      float _238 = _237 + TEXCOORD.y;
      _240 = _238;
    } else {
      _240 = TEXCOORD.y;
    }
    float4 _241;
    if (RENODX_TONE_MAP_TYPE == 0.f || CUSTOM_AA_HIGHLIGHT_WEIGHT == 0.f) {
      _241 = g_xPostToneMapFrameBufferTexture.SampleLevel(g_xBilinearClamp, float2(_235, _240), 0.0f);
    } else {
      _241 = SampleHighlightWeighted(float2(_235, _240));
    }
    _246 = _241.x;
    _247 = _241.y;
    _248 = _241.z;
  } else {
    _246 = _9.x;
    _247 = _9.y;
    _248 = _9.z;
  }
  SV_Target.x = _246;
  SV_Target.y = _247;
  SV_Target.z = _248;
  SV_Target.w = _9.w;
  return SV_Target;
}
