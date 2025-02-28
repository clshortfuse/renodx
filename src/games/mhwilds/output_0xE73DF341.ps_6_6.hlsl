#include "./common.hlsl"

Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
};

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _11 = SrcTexture.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _17 = (HDRMapping_000x) * 0.009999999776482582f;
  float _18 = _17 * (_11.x);
  float _19 = _17 * (_11.y);
  float _20 = _17 * (_11.z);
  bool _21 = !(_18 <= 0.0f);
  float _35 = -0.35844698548316956f;
  float _50;
  float _65;
  if (_21) {
    bool _23 = (_18 < 3.0517578125e-05f);
    if (_23) {
      float _25 = _18 * 0.5f;
      float _26 = _25 + 1.52587890625e-05f;
      float _27 = log2(_26);
      float _28 = _27 * 0.05707760155200958f;
      float _29 = _28 + 0.5547950267791748f;
      _35 = _29;
    } else {
      float _31 = log2(_18);
      float _32 = _31 * 0.05707760155200958f;
      float _33 = _32 + 0.5547950267791748f;
      _35 = _33;
    }
  }
  bool _36 = !(_19 <= 0.0f);
  _50 = -0.35844698548316956f;
  if (_36) {
    bool _38 = (_19 < 3.0517578125e-05f);
    if (_38) {
      float _40 = _19 * 0.5f;
      float _41 = _40 + 1.52587890625e-05f;
      float _42 = log2(_41);
      float _43 = _42 * 0.05707760155200958f;
      float _44 = _43 + 0.5547950267791748f;
      _50 = _44;
    } else {
      float _46 = log2(_19);
      float _47 = _46 * 0.05707760155200958f;
      float _48 = _47 + 0.5547950267791748f;
      _50 = _48;
    }
  }
  bool _51 = !(_20 <= 0.0f);
  _65 = -0.35844698548316956f;
  if (_51) {
    bool _53 = (_20 < 3.0517578125e-05f);
    if (_53) {
      float _55 = _20 * 0.5f;
      float _56 = _55 + 1.52587890625e-05f;
      float _57 = log2(_56);
      float _58 = _57 * 0.05707760155200958f;
      float _59 = _58 + 0.5547950267791748f;
      _65 = _59;
    } else {
      float _61 = log2(_20);
      float _62 = _61 * 0.05707760155200958f;
      float _63 = _62 + 0.5547950267791748f;
      _65 = _63;
    }
  }
  float _66 = _35 * 0.984375f;
  float _67 = _50 * 0.984375f;
  float _68 = _65 * 0.984375f;
  float _69 = _66 + 0.0078125f;
  float _70 = _67 + 0.0078125f;
  float _71 = _68 + 0.0078125f;
  float4 _74 = SrcLUT.SampleLevel(TrilinearClamp, float3(_69, _70, _71), 0.0f);
  SV_Target.x = (_74.x);
  SV_Target.y = (_74.y);
  SV_Target.z = (_74.z);
  SV_Target.rgb = LutToneMap(_11.rgb, SrcLUT, TrilinearClamp);
  // SV_Target.rgb = FinalizeLutTonemap(_11.rgb);
  SV_Target.w = 1.0f;
  return SV_Target;
}
