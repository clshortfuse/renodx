struct SurfelData {
  uint _baseColor;
  uint _normal;
  half3 _radiance;
  uint16_t _radius;
};


Texture3D<uint> __3__36__0__0__g_surfelIndicesVoxelsTextures : register(t67, space36);

RWTexture3D<float4> __3__38__0__1__g_dstIndirectCacheVoxelsTextureUAV : register(u5, space38);

RWTexture3D<float4> __3__38__0__1__g_dstIndirectCacheChromaVoxelsTextureUAV : register(u6, space38);

RWStructuredBuffer<SurfelData> __3__39__0__1__g_surfelDataBufferUAV : register(u9, space39);

cbuffer __3__1__0__0__GenerateVoxelConstants : register(b0, space1) {
  int4 _srcStartIndex : packoffset(c000.x);
  int4 _dstStartIndex : packoffset(c001.x);
  int4 _clearVoxelsParams : packoffset(c002.x);
  float4 _clearColor : packoffset(c003.x);
  float4 _generateParams : packoffset(c004.x);
};

cbuffer __3__35__0__0__EnvironmentLightingHistoryConstantBuffer : register(b17, space35) {
  float4 _environmentLightingHistory[4] : packoffset(c000.x);
};

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int _27 = min(max(select((_clearColor.y > 0.0f), ((uint)(SV_DispatchThreadID.z) >> 7), (6 - int(_environmentLightingHistory[1].z))), 0), 5);
  int _28 = (int)(SV_DispatchThreadID.z) & 127;
  bool _37 = ((int)_27 < (int)4);
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  int _103;
  [branch]
  if (_37) {
    [branch]
    if ((((((int)(int)(SV_DispatchThreadID.x) < (int)64)) && (((int)(int)(SV_DispatchThreadID.y) < (int)32)))) && (((uint)_28 < (uint)64))) {
      float4 _46 = __3__38__0__1__g_dstIndirectCacheVoxelsTextureUAV.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), ((int)(((uint)(((int)(_27 * 66)) | 1)) + (uint)(_28)))));
      float4 _52 = __3__38__0__1__g_dstIndirectCacheChromaVoxelsTextureUAV.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), ((int)(((uint)(((int)(_27 * 66)) | 1)) + (uint)(_28)))));
      _58 = _46.x;
      _59 = _46.y;
      _60 = _46.z;
      _61 = _46.w;
      _62 = _52.x;
      _63 = _52.y;
      _64 = _52.z;
      _65 = _52.w;
    } else {
      _58 = 0.0f;
      _59 = 0.0f;
      _60 = 0.0f;
      _61 = 0.0f;
      _62 = 0.0f;
      _63 = 0.0f;
      _64 = 0.0f;
      _65 = 0.0f;
    }
  } else {
    _58 = 0.0f;
    _59 = 0.0f;
    _60 = 0.0f;
    _61 = 0.0f;
    _62 = 0.0f;
    _63 = 0.0f;
    _64 = 0.0f;
    _65 = 0.0f;
  }
  float _74 = min((_environmentLightingHistory[0].w), dot(float3((_environmentLightingHistory[0].x), (_environmentLightingHistory[0].y), (_environmentLightingHistory[0].z)), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f))) * 0.10000000149011612f;
  float _77 = saturate(_74 / max(9.999999974752427e-07f, max(0.0f, (sqrt(((_60 * _60) + (_59 * _59)) + (_61 * _61)) + _58))));
  [branch]
  if ((int)_27 < (int)6) {
    if (_37) {
      [branch]
      if ((((((int)(int)(SV_DispatchThreadID.x) < (int)64)) && (((int)(int)(SV_DispatchThreadID.y) < (int)32)))) && (((uint)_28 < (uint)64))) {
        __3__38__0__1__g_dstIndirectCacheVoxelsTextureUAV[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), ((int)(((uint)(((int)(_27 * 130)) | 1)) + (uint)(_28))))] = float4((_77 * _58), (_77 * _59), (_77 * _60), (_77 * _61));
        __3__38__0__1__g_dstIndirectCacheChromaVoxelsTextureUAV[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), ((int)(((uint)(((int)(_27 * 130)) | 1)) + (uint)(_28))))] = float4((_77 * _62), (_77 * _63), _64, _65);
      }
    }
    uint _97 = __3__36__0__0__g_surfelIndicesVoxelsTextures.Load(int4((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), ((int)(((uint)(((int)(_27 * 130)) | 1)) + (uint)(_28))), 0));
    int _99 = _97.x & 4194303;
    [branch]
    if (!(_99 == 0)) {
      _103 = 0;
      while(true) {
        int _108 = __3__39__0__1__g_surfelDataBufferUAV[((_99 + -1) + _103)]._baseColor;
        int _110 = __3__39__0__1__g_surfelDataBufferUAV[((_99 + -1) + _103)]._normal;
        half _112 = __3__39__0__1__g_surfelDataBufferUAV[((_99 + -1) + _103)]._radiance.x;
        half _113 = __3__39__0__1__g_surfelDataBufferUAV[((_99 + -1) + _103)]._radiance.y;
        half _114 = __3__39__0__1__g_surfelDataBufferUAV[((_99 + -1) + _103)]._radiance.z;
        int16_t _116 = __3__39__0__1__g_surfelDataBufferUAV[((_99 + -1) + _103)]._radius;
        float _117 = float(_112);
        float _118 = float(_113);
        float _119 = float(_114);
        float _123 = saturate(_74 / max(9.999999974752427e-07f, dot(float3(_117, _118, _119), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f))));
        SurfelData __struct_store_0;
        __struct_store_0._baseColor = _108;
        __struct_store_0._normal = _110;
        __struct_store_0._radiance = half3(half(_123 * _117), half(_123 * _118), half(_123 * _119));
        __struct_store_0._radius = (int)(_116);
        __3__39__0__1__g_surfelDataBufferUAV[((_99 + -1) + _103)] = __struct_store_0;
        if (!((_103 + 1) == 4)) {
          _103 = (_103 + 1);
          continue;
        }
        break;
      }
    }
  }
}