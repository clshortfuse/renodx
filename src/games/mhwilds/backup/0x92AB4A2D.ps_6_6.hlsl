Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> tTex : register(t1);

Texture3D<float4> SrcLUT : register(t2);

cbuffer CBImagePlane : register(b0) {
  float CBImagePlane_000x : packoffset(c000.x);
  float CBImagePlane_000y : packoffset(c000.y);
  float CBImagePlane_000z : packoffset(c000.z);
  float CBImagePlane_001x : packoffset(c001.x);
  float CBImagePlane_001y : packoffset(c001.y);
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
  float4 _23 = tTex.Sample(BilinearClamp, float2((((CBImagePlane_002z) * (TEXCOORD.x)) + (CBImagePlane_002x)), (((CBImagePlane_002w) * (TEXCOORD.y)) + (CBImagePlane_002y))));
  float _31 = (CBImagePlane_000x) * (_23.x);
  float _32 = (CBImagePlane_000y) * (_23.y);
  float _33 = (CBImagePlane_000z) * (_23.z);
  float _48 = -0.35844698548316956f;
  float _63;
  float _78;
  if ((!(_31 <= 0.0f))) {
    if (((_31 < 3.0517578125e-05f))) {
      _48 = (((log2(((_31 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _48 = (((log2(_31)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _63 = -0.35844698548316956f;
  if ((!(_32 <= 0.0f))) {
    if (((_32 < 3.0517578125e-05f))) {
      _63 = (((log2(((_32 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _63 = (((log2(_32)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _78 = -0.35844698548316956f;
  if ((!(_33 <= 0.0f))) {
    if (((_33 < 3.0517578125e-05f))) {
      _78 = (((log2(((_33 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _78 = (((log2(_33)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  float4 _87 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_48 * 0.984375f) + 0.0078125f), ((_63 * 0.984375f) + 0.0078125f), ((_78 * 0.984375f) + 0.0078125f)), 0.0f);
  uint2 _92; ReadonlyDepth.GetDimensions(_92.x, _92.y);
  SV_Target.x = (_87.x);
  SV_Target.y = (_87.y);
  SV_Target.z = (_87.z);
  SV_Target.w = ((((bool)((((ReadonlyDepth.Load(int3((int(104)), (int(105)), 0))).x) <= 0.0f))) ? 0.0f : 1.0f));
  return SV_Target;
}
