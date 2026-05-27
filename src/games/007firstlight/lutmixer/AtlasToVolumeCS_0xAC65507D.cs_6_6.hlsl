#include "./lutmixer.hlsli"

Texture2D<float4> srvAtlasTexture : register(t0);

RWTexture3D<float4> uavVolumeTexture : register(u0);

[numthreads(4, 4, 4)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float4 _13;
  float _39;
  float _40;
  float _41;
  _13 = srvAtlasTexture.Load(int3(((int)(((uint)(((int)((int)(SV_DispatchThreadID.z) << 4)) & 48)) + SV_DispatchThreadID.x)), ((int)((((uint)(SV_DispatchThreadID.z) >> 2) << 4) + SV_DispatchThreadID.y)), 0));
  _39 = _13.x * 12.920000076293945f;
  _40 = _13.y * 12.920000076293945f;
  _41 = _13.z * 12.920000076293945f;
  uavVolumeTexture[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(saturate((((-0.054999999701976776f - _39) + (exp2(log2(abs(_13.x)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_13.x > 0.0031308000907301903f))) + _39),
                                                                                                                            saturate((((-0.054999999701976776f - _40) + (exp2(log2(abs(_13.y)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_13.y > 0.0031308000907301903f))) + _40),
                                                                                                                            saturate((((-0.054999999701976776f - _41) + (exp2(log2(abs(_13.z)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_13.z > 0.0031308000907301903f))) + _41),
                                                                                                                            _13.w);
}
