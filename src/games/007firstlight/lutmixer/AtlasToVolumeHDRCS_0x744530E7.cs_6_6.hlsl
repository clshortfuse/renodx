Texture2D<float4> srvAtlasTexture : register(t0);

RWTexture3D<float4> uavVolumeTexture : register(u0);

SamplerState samplerLinearClampNode : register(s4);

[numthreads(4, 4, 4)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _9;
  uint _10;
  uint _11;
  float _13;
  float _14;
  float _15;
  float4 _38;
  float4 _43;

  
  _9 = float((uint)SV_DispatchThreadID.z);
  _10 = uint(_9);
  _11 = _10 + 1u;
  _13 = _9 - float((uint)_10);

  // uavVolumeTexture[int3(SV_DispatchThreadID)] = float4(SV_DispatchThreadID.rgb / 15.f, 1.f);
  // return;

  _14 = float((uint)SV_DispatchThreadID.x) + 0.5f;
  _15 = float((uint)SV_DispatchThreadID.y) + 0.5f;
  _38 = srvAtlasTexture.SampleLevel(samplerLinearClampNode, float2(((float((uint)((uint)(((int)(_10 << 4)) & 48))) + _14) * 0.015625f), ((float((uint)(((uint)(_10) >> 2) << 4)) + _15) * 0.015625f)), 0.0f);
  _43 = srvAtlasTexture.SampleLevel(samplerLinearClampNode, float2(((float((uint)((uint)(((int)(_11 << 4)) & 48))) + _14) * 0.015625f), ((float((uint)(((uint)(_11) >> 2) << 4)) + _15) * 0.015625f)), 0.0f);
  uavVolumeTexture[int3(SV_DispatchThreadID)] = float4((lerp(_38.x, _43.x, _13)), (lerp(_38.y, _43.y, _13)), (lerp(_38.z, _43.z, _13)), (lerp(_38.w, _43.w, _13)));
}
