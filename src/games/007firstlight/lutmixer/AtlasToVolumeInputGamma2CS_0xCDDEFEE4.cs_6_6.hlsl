Texture2D<float4> srvAtlasTexture : register(t0);

RWTexture3D<float4> uavVolumeTexture : register(u0);

SamplerState samplerLinearClampNode : register(s4);

[numthreads(4, 4, 4)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _10;
  float _11;
  float _12;
  float _13;
  float _14;
  float _15;
  float _37;
  float _38;
  float _39;
  float _55;
  uint _56;
  uint _57;
  float _59;
  float _62;
  float _63;
  float4 _86;
  float4 _91;
  float _104;
  float _105;
  float _106;
  float _129;
  float _130;
  float _131;
  _10 = float((int)((int)(SV_DispatchThreadID.x))) * 0.06666667014360428f;
  _11 = float((int)((int)(SV_DispatchThreadID.y))) * 0.06666667014360428f;
  _12 = float((int)((int)(SV_DispatchThreadID.z))) * 0.06666667014360428f;
  _13 = _10 * _10;
  _14 = _11 * _11;
  _15 = _12 * _12;
  _37 = _13 * 12.920000076293945f;
  _38 = _14 * 12.920000076293945f;
  _39 = _15 * 12.920000076293945f;
  _55 = saturate((((-0.054999999701976776f - _39) + (exp2(log2(abs(_15)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_15 > 0.0031308000907301903f))) + _39) * 15.0f;
  _56 = uint(_55);
  _57 = _56 + 1u;
  _59 = _55 - float((uint)_56);
  _62 = (saturate((((-0.054999999701976776f - _37) + (exp2(log2(abs(_13)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_13 > 0.0031308000907301903f))) + _37) * 15.0f) + 0.5f;
  _63 = (saturate((((-0.054999999701976776f - _38) + (exp2(log2(abs(_14)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_14 > 0.0031308000907301903f))) + _38) * 15.0f) + 0.5f;
  _86 = srvAtlasTexture.SampleLevel(samplerLinearClampNode, float2(((float((uint)((uint)(((int)(_56 << 4)) & 48))) + _62) * 0.015625f), ((float((uint)(((uint)(_56) >> 2) << 4)) + _63) * 0.015625f)), 0.0f);
  _91 = srvAtlasTexture.SampleLevel(samplerLinearClampNode, float2(((float((uint)((uint)(((int)(_57 << 4)) & 48))) + _62) * 0.015625f), ((float((uint)(((uint)(_57) >> 2) << 4)) + _63) * 0.015625f)), 0.0f);
  _104 = ((_91.x - _86.x) * _59) + _86.x;
  _105 = ((_91.y - _86.y) * _59) + _86.y;
  _106 = ((_91.z - _86.z) * _59) + _86.z;
  _129 = _104 * 12.920000076293945f;
  _130 = _105 * 12.920000076293945f;
  _131 = _106 * 12.920000076293945f;
  uavVolumeTexture[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4(saturate((((-0.054999999701976776f - _129) + (exp2(log2(abs(_104)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_104 > 0.0031308000907301903f))) + _129),
                                                                                                                            saturate((((-0.054999999701976776f - _130) + (exp2(log2(abs(_105)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_105 > 0.0031308000907301903f))) + _130),
                                                                                                                            saturate((((-0.054999999701976776f - _131) + (exp2(log2(abs(_106)) * 0.4166666567325592f) * 1.0549999475479126f)) * float((bool)(uint)(_106 > 0.0031308000907301903f))) + _131),
                                                                                                                            (lerp(_86.w, _91.w, _59)));
}
