Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> NormalXNormalYRoughnessMiscSRV : register(t1);

Texture2D<float4> SrcTexture : register(t2);

Texture3D<float4> SrcLUT : register(t3);

cbuffer SceneInfo : register(b0) {
  float SceneInfo_022x : packoffset(c022.x);
  float SceneInfo_022y : packoffset(c022.y);
  float SceneInfo_022z : packoffset(c022.z);
  float SceneInfo_023x : packoffset(c023.x);
  float SceneInfo_023y : packoffset(c023.y);
  float SceneInfo_023z : packoffset(c023.z);
  float SceneInfo_023w : packoffset(c023.w);
};

cbuffer CaptureBufferInfo : register(b1) {
  uint CaptureBufferInfo_000x : packoffset(c000.x);
  uint CaptureBufferInfo_000y : packoffset(c000.y);
  float CaptureBufferInfo_000z : packoffset(c000.z);
};

cbuffer ImageSizeInfo : register(b2) {
  float ImageSizeInfo_000x : packoffset(c000.x);
  float ImageSizeInfo_000y : packoffset(c000.y);
};

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _30 = SrcTexture.SampleLevel(PointBorder, float2(((((SceneInfo_023x) + -0.5009999871253967f) * (TEXCOORD.x)) * (SceneInfo_023z)), ((((SceneInfo_023y) + -0.5009999871253967f) * (TEXCOORD.y)) * (SceneInfo_023w))), 0.0f);
  float _48 = -0.35844698548316956f;
  float _63;
  float _78;
  bool _117;
  float _139;
  float _140;
  float _141;
  int _147;
  float _158;
  float _159;
  float _160;
  float _161;
  if ((!((_30.x) <= 0.0f))) {
    if ((((_30.x) < 3.0517578125e-05f))) {
      _48 = (((log2((((_30.x) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _48 = (((log2((_30.x))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _63 = -0.35844698548316956f;
  if ((!((_30.y) <= 0.0f))) {
    if ((((_30.y) < 3.0517578125e-05f))) {
      _63 = (((log2((((_30.y) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _63 = (((log2((_30.y))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _78 = -0.35844698548316956f;
  if ((!((_30.z) <= 0.0f))) {
    if ((((_30.z) < 3.0517578125e-05f))) {
      _78 = (((log2((((_30.z) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _78 = (((log2((_30.z))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  float4 _87 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_48 * 0.984375f) + 0.0078125f), ((_63 * 0.984375f) + 0.0078125f), ((_78 * 0.984375f) + 0.0078125f)), 0.0f);
  bool _105 = (((ReadonlyDepth.Load(int3((int(100)), (int(101)), 0))).x) <= 0.0f);
  _117 = false;
  if ((!((((float4)(NormalXNormalYRoughnessMiscSRV.Load(int3(((uint)(uint((SV_Position.x)))), ((uint)(uint((SV_Position.y)))), 0)))).w) == 0.0f))) {
    _117 = true;
    if (!(((((float4)(NormalXNormalYRoughnessMiscSRV.Load(int3(((uint)(uint((SV_Position.x)))), ((uint)(uint((SV_Position.y)))), 0)))).w) < 0.5f))) {
      _117 = (((((float4)(NormalXNormalYRoughnessMiscSRV.Load(int3(((uint)(uint((SV_Position.x)))), ((uint)(uint((SV_Position.y)))), 0)))).w) == 1.0f));
    }
  }
  _139 = (_87.x);
  _140 = (_87.y);
  _141 = (_87.z);
  if (!((((uint)(CaptureBufferInfo_000y)) == 0))) {
    float _137 = min((max(((SceneInfo_022z) / (((SceneInfo_022x) - ((SceneInfo_022y) * ((ReadonlyDepth.Load(int3((int(122)), (int(123)), 0))).x))) * (CaptureBufferInfo_000z))), 0.0f)), 1.0f);
    _139 = _137;
    _140 = _137;
    _141 = _137;
  }
  _147 = ((uint)(CaptureBufferInfo_000x));
  if (((((uint)(CaptureBufferInfo_000x)) == 1))) {
    _147 = 1;
    _158 = 0.0f;
    _159 = 0.0f;
    _160 = 0.0f;
    _161 = 0.0f;
    if ((_105 || _117)) {
      SV_Target.x = _158;
      SV_Target.y = _159;
      SV_Target.z = _160;
      SV_Target.w = _161;
    }
  }
  bool _151 = ((bool)(_105 || ((bool)(!_117)))) && ((bool)((_147 == 2)));
  _158 = ((_151 ? 0.0f : _139));
  _159 = ((_151 ? 0.0f : _140));
  _160 = ((_151 ? 0.0f : _141));
  _161 = ((((bool)(_105 || _151)) ? 0.0f : 1.0f));
  SV_Target.x = _158;
  SV_Target.y = _159;
  SV_Target.z = _160;
  SV_Target.w = _161;
  return SV_Target;
}
