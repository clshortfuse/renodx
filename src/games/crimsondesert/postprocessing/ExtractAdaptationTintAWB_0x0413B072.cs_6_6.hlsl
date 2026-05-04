Texture2D<float3> __3__36__0__0__g_colorAdatationSource : register(t76, space36);

RWStructuredBuffer<float4> __3__39__0__1__g_autoWhiteBalanceColorUAV : register(u14, space39);

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _textureSizeAndInvSize : packoffset(c000.x);
  float4 _blurParam : packoffset(c001.x);
  float4 _glareParam : packoffset(c002.x);
  float4 _renderParam : packoffset(c003.x);
  float4 _exposureParam : packoffset(c004.x);
  float4 _histogramParam : packoffset(c005.x);
  float4 _whiteBalance : packoffset(c006.x);
  float4 _glareBlurParam : packoffset(c007.x);
  float4 _preFrameViewPosition : packoffset(c008.x);
};

groupshared float _global_0[4096];

[numthreads(32, 32, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  int2 _7; __3__36__0__0__g_colorAdatationSource.GetDimensions(_7.x, _7.y);
  float _9 = float((int)(_7.x));
  float _11 = float((int)(_7.y));
  int _12 = int(_9);
  int _13 = int(_11);
  int _14 = _12 * _13;
  bool _15 = ((uint)(int)(SV_GroupIndex) < (uint)_14);
  float _24;
  float _25;
  float _26;
  float _27;
  int _43;
  if (_15) {
    uint _17 = (int)(SV_GroupIndex) % _12;
    int _18 = (int)(SV_GroupIndex) / _12;
    float3 _19 = __3__36__0__0__g_colorAdatationSource.Load(int3(_17, _18, 0));
    _24 = _19.x;
    _25 = _19.y;
    _26 = _19.z;
    _27 = 1.0f;
  } else {
    _24 = 0.0f;
    _25 = 0.0f;
    _26 = 0.0f;
    _27 = 0.0f;
  }
  uint _28 = (int)(SV_GroupIndex) * 4;
  uint _29 = 0u + _28;
  _global_0[_29] = _24;
  uint _31 = (int)(SV_GroupIndex) * 4;
  uint _32 = 1u + _31;
  _global_0[_32] = _25;
  uint _34 = (int)(SV_GroupIndex) * 4;
  uint _35 = 2u + _34;
  _global_0[_35] = _26;
  uint _37 = (int)(SV_GroupIndex) * 4;
  uint _38 = 3u + _37;
  _global_0[_38] = _27;
  GroupMemoryBarrierWithGroupSync();
  _43 = 512;
  while(true) {
    uint _44 = _43 + SV_GroupIndex;
    uint _45 = _44 * 4;
    uint _46 = 0u + _45;
    float _48 = _global_0[_46];
    uint _49 = _44 * 4;
    uint _50 = 1u + _49;
    float _52 = _global_0[_50];
    uint _53 = _44 * 4;
    uint _54 = 2u + _53;
    float _56 = _global_0[_54];
    uint _57 = _44 * 4;
    uint _58 = 3u + _57;
    float _60 = _global_0[_58];
    uint _61 = (int)(SV_GroupIndex) * 4;
    uint _62 = 0u + _61;
    float _64 = _global_0[_62];
    float _65 = _global_0[_32];
    float _66 = _global_0[_35];
    float _67 = _global_0[_38];
    float _68 = _64 + _48;
    float _69 = _65 + _52;
    float _70 = _66 + _56;
    float _71 = _67 + _60;
    _global_0[_62] = _68;
    _global_0[_32] = _69;
    _global_0[_35] = _70;
    _global_0[_38] = _71;
    GroupMemoryBarrierWithGroupSync();
    int _72 = (uint)(_43) >> 1;
    bool _73 = (_72 == 0);
    if (!_73) {
      _43 = _72;
      continue;
    }
    bool _41 = ((int)(SV_GroupIndex) == 0);
    if (_41) {
      float _75 = _global_0[0];
      float _76 = _global_0[1];
      float _77 = _global_0[2];
      int _78 = max(_14, 1);
      float _79 = float((uint)_78);
      float _80 = _75 / _79;
      float _81 = _76 / _79;
      float _82 = _77 / _79;
      float _83 = dot(float3(_80, _81, _82), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
      float _84 = max(_83, 9.999999747378752e-05f);
      float _85 = _80 / _84;
      float _86 = _81 / _84;
      float _87 = _82 / _84;
      float _90 = min(_83, _renderParam.x);
      float _91 = _90 * _85;
      float _92 = _90 * _86;
      float _93 = _90 * _87;
      bool _94 = isnan(_91);
      bool _95 = isnan(_92);
      bool _96 = isnan(_93);
      bool _97 = isnan(_90);
      bool _98 = (_94) | (_95);
      bool _99 = (_98) | (_96);
      bool _100 = (_99) | (_97);
      float _101 = select(_100, 0.0f, _91);
      float _102 = select(_100, 0.0f, _92);
      float _103 = select(_100, 0.0f, _93);
      float _104 = select(_100, 0.0f, _90);
      float _107 = __3__39__0__1__g_autoWhiteBalanceColorUAV[1].x;
      float _108 = __3__39__0__1__g_autoWhiteBalanceColorUAV[1].y;
      float _109 = __3__39__0__1__g_autoWhiteBalanceColorUAV[1].z;
      float _110 = __3__39__0__1__g_autoWhiteBalanceColorUAV[1].w;
      bool _111 = isnan(_107);
      bool _112 = isnan(_108);
      bool _113 = isnan(_109);
      bool _114 = isnan(_110);
      bool _115 = (_111) | (_112);
      bool _116 = (_115) | (_113);
      bool _117 = (_116) | (_114);
      float _118 = select(_117, _101, _107);
      float _119 = select(_117, _102, _108);
      float _120 = select(_117, _103, _109);
      float _121 = select(_117, _104, _110);
      float _122 = _101 - _118;
      float _123 = _102 - _119;
      float _124 = _103 - _120;
      float _125 = _104 - _121;
      float _126 = _122 * 0.10000000149011612f;
      float _127 = _123 * 0.10000000149011612f;
      float _128 = _124 * 0.10000000149011612f;
      float _129 = _125 * 0.10000000149011612f;
      float _130 = _126 + _118;
      float _131 = _127 + _119;
      float _132 = _128 + _120;
      float _133 = _129 + _121;
      __3__39__0__1__g_autoWhiteBalanceColorUAV[1].x = _130; __3__39__0__1__g_autoWhiteBalanceColorUAV[1].y = _131; __3__39__0__1__g_autoWhiteBalanceColorUAV[1].z = _132; __3__39__0__1__g_autoWhiteBalanceColorUAV[1].w = _133;
    }
    break;
  }
}
