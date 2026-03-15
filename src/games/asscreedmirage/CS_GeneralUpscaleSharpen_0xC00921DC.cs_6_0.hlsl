Texture2D<float4> t0_space6 : register(t0, space6);

RWTexture2D<float4> u0_space6 : register(u0, space6);

cbuffer cb0_space6 : register(b0, space6) {
  struct GeneralUpscaleSharpen__Constants {
    int4 GeneralUpscaleSharpen__Constants_000;
  } GeneralUpscaleSharpen_cbuffer_000 : packoffset(c000.x);
};

[numthreads(16, 16, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float4 _9 = t0_space6.Load(int3((uint)(SV_DispatchThreadID.x), ((uint)(SV_DispatchThreadID.y + -1u)), 0));
  float4 _14 = t0_space6.Load(int3(((uint)(SV_DispatchThreadID.x + -1u)), (uint)(SV_DispatchThreadID.y), 0));
  float4 _18 = t0_space6.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
  float4 _23 = t0_space6.Load(int3(((uint)(SV_DispatchThreadID.x + 1u)), (uint)(SV_DispatchThreadID.y), 0));
  float4 _28 = t0_space6.Load(int3((uint)(SV_DispatchThreadID.x), ((uint)(SV_DispatchThreadID.y + 1u)), 0));
  float _34 = min(min(_9.x, min(_14.x, _23.x)), _28.x);
  float _37 = min(min(_9.y, min(_14.y, _23.y)), _28.y);
  float _40 = min(min(_9.z, min(_14.z, _23.z)), _28.z);
  float _43 = max(max(_9.x, max(_14.x, _23.x)), _28.x);
  float _46 = max(max(_9.y, max(_14.y, _23.y)), _28.y);
  float _49 = max(max(_9.z, max(_14.z, _23.z)), _28.z);
  float _82 = max(-0.1875f, min(max(max((-0.0f - (_34 * (0.25f / _43))), ((1.0f / ((_34 * 4.0f) + -4.0f)) * (1.0f - _43))), max(max((-0.0f - (_37 * (0.25f / _46))), ((1.0f / ((_37 * 4.0f) + -4.0f)) * (1.0f - _46))), max((-0.0f - (_40 * (0.25f / _49))), ((1.0f / ((_40 * 4.0f) + -4.0f)) * (1.0f - _49))))), 0.0f)) * asfloat(GeneralUpscaleSharpen_cbuffer_000.GeneralUpscaleSharpen__Constants_000.x);
  float _84 = (_82 * 4.0f) + 1.0f;
  float _87 = asfloat(((uint)(2129764351u - (int)(asint(_84)))));
  float _90 = (2.0f - (_87 * _84)) * _87;
  u0_space6[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4((_90 * ((_82 * (((_14.x + _9.x) + _23.x) + _28.x)) + _18.x)), (_90 * ((_82 * (((_14.y + _9.y) + _23.y) + _28.y)) + _18.y)), (_90 * ((_82 * (((_14.z + _9.z) + _23.z) + _28.z)) + _18.z)), 1.0f);
}
