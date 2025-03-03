Texture2D<float4> tTex : register(t0);

Texture3D<float4> SrcLUT : register(t1);

cbuffer CBImagePlane : register(b0) {
  float CBImagePlane_000x : packoffset(c000.x);
  float CBImagePlane_000y : packoffset(c000.y);
  float CBImagePlane_000z : packoffset(c000.z);
  float CBImagePlane_002x : packoffset(c002.x);
  float CBImagePlane_002y : packoffset(c002.y);
  float CBImagePlane_002z : packoffset(c002.z);
  float CBImagePlane_002w : packoffset(c002.w);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _20 = tTex.Sample(BilinearClamp, float2((((CBImagePlane_002z) * (TEXCOORD.x)) + (CBImagePlane_002x)), (((CBImagePlane_002w) * (TEXCOORD.y)) + (CBImagePlane_002y))));
  float _28 = (CBImagePlane_000x) * (_20.x);
  float _29 = (CBImagePlane_000y) * (_20.y);
  float _30 = (CBImagePlane_000z) * (_20.z);
  float _45 = -0.35844698548316956f;
  float _60;
  float _75;
  if ((!(_28 <= 0.0f))) {
    if (((_28 < 3.0517578125e-05f))) {
      _45 = (((log2(((_28 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _45 = (((log2(_28)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _60 = -0.35844698548316956f;
  if ((!(_29 <= 0.0f))) {
    if (((_29 < 3.0517578125e-05f))) {
      _60 = (((log2(((_29 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _60 = (((log2(_29)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _75 = -0.35844698548316956f;
  if ((!(_30 <= 0.0f))) {
    if (((_30 < 3.0517578125e-05f))) {
      _75 = (((log2(((_30 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _75 = (((log2(_30)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  float4 _84 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_45 * 0.984375f) + 0.0078125f), ((_60 * 0.984375f) + 0.0078125f), ((_75 * 0.984375f) + 0.0078125f)), 0.0f);
  SV_Target.x = (_84.x);
  SV_Target.y = (_84.y);
  SV_Target.z = (_84.z);
  SV_Target.w = 1.0f;
  return SV_Target;
}
