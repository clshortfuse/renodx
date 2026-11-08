// Call of Duty: Black Ops Cold War
// RenoDX hash: 0xEAF106A3
// Shader Model: ps_6_1
//
// Generic 2D UI image quad (texture * vertex colour, clip-rect alpha, UI colour
// matrix). The game also uses it for full-screen black fades, e.g. the black
// screen at mission/cutscene start.
//
// HDR fade fix (custom tone-map modes only; Vanilla is untouched):
// The fade quad is drawn with alpha just below 1 (measured 2026-10-20: about
// 0.04% of the scene transmitted). Designed for SDR, where the scene underneath
// is at most ~1.0, that remainder is invisible. With an HDR scene of up to
// ~2500 nits it leaves ~1 nit, and the late output LUT's shadow lift raises it
// further (0.001 -> ~0.013 nits, 0.1 -> ~0.25), so the scene shows through.
// For black quads only, the last 5% of transmission is eased to zero:
//     t' = t * smoothstep(0, FADE_BLACK_EASE, t),  t = 1 - alpha
// Continuous and monotonic; t >= 5% is unchanged, so fades keep their timing
// and coloured / textured UI is unaffected.
// LIVE TEST COPY: ungated (the running add-on does not inject settings for this hash)

Texture2D<float4> colorMapSampler : register(t0);

cbuffer GenericsCBuffer : register(b4) {
  float4 scriptVector0 : packoffset(c000.x);
  float4 scriptVector1 : packoffset(c001.x);
  float4 scriptVector2 : packoffset(c002.x);
  float4 scriptVector3 : packoffset(c003.x);
  float4 scriptVector4 : packoffset(c004.x);
};

cbuffer PerSceneConsts : register(b2) {
  float4 ui2dColorMatrixR : packoffset(c108.x);
  float4 ui2dColorMatrixG : packoffset(c109.x);
  float4 ui2dColorMatrixB : packoffset(c110.x);
};

SamplerState colorSampler : register(s0);

static const float FADE_BLACK_EASE = 0.05f;    // transmission below which it eases to 0
static const float FADE_BLACK_LEVEL = 0.00001f; // max channel treated as black

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 COLOR : COLOR,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _11 = colorMapSampler.Sample(colorSampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _16 = _11.x * COLOR.x;
  float _17 = _11.y * COLOR.y;
  float _18 = _11.z * COLOR.z;
  float _19 = _11.w * COLOR.w;
  bool _26 = (scriptVector0.x > scriptVector0.y);
  float _27 = select(_26, scriptVector0.x, scriptVector0.y);
  float _28 = select(_26, scriptVector0.y, scriptVector0.x);
  bool _29 = (scriptVector2.x > scriptVector2.y);
  float _30 = select(_29, scriptVector2.x, scriptVector2.y);
  float _31 = select(_29, scriptVector2.y, scriptVector2.x);
  float _36 = max(scriptVector1.x, 9.999999747378752e-05f);
  float _37 = max(scriptVector3.x, 9.999999747378752e-05f);
  float _40 = max(scriptVector1.y, 9.999999747378752e-05f);
  float _41 = max(scriptVector3.y, 9.999999747378752e-05f);
  float _44 = max(scriptVector1.z, 0.0f);
  float _45 = max(scriptVector3.z, 0.0f);
  float _155;
  float _162;
  float _168;
  float _174;
  float _211;
  float _248;
  float _249;
  float _250;
  [branch]
  if ((bool)(scriptVector4.x > 1.0f) || (bool)(scriptVector4.z > 1.0f)) {
    float _57 = (scriptVector4.y + 1.0f) / scriptVector4.x;
    float _58 = (scriptVector4.w + 1.0f) / scriptVector4.z;
    float _59 = _57 - scriptVector4.y;
    float _60 = _58 - scriptVector4.w;
    float _65 = scriptVector4.x * _27;
    float _66 = scriptVector4.z * _30;
    float _79 = saturate((TEXCOORD.x - _28) / _36);
    float _80 = saturate((TEXCOORD.y - _31) / _37);
    float _93 = saturate((((_40 + TEXCOORD.x) - (floor(_65) * _57)) - (frac(_65) * _59)) / _40);
    float _94 = saturate((((_41 + TEXCOORD.y) - (floor(_66) * _58)) - (frac(_66) * _60)) / _41);
    float _107 = TEXCOORD.x - (floor(TEXCOORD.x / _57) * _57);
    float _108 = TEXCOORD.y - (floor(TEXCOORD.y / _58) * _58);
    float _111 = saturate(_107 * 999.9999389648438f);
    float _112 = saturate(_108 * 999.9999389648438f);
    float _123 = saturate(((0.0010000000474974513f - _59) + _107) * 999.9999389648438f);
    float _124 = saturate(((0.0010000000474974513f - _60) + _108) * 999.9999389648438f);
    float _137 = ((_79 * _80) * _111) * _112;
    _211 = ((((((((((3.0f - (_79 * 2.0f)) * _19) * (3.0f - (_80 * 2.0f))) * (1.0f - ((_93 * _93) * (3.0f - (_93 * 2.0f))))) * (3.0f - (_111 * 2.0f))) * (1.0f - ((_94 * _94) * (3.0f - (_94 * 2.0f))))) * (3.0f - (_112 * 2.0f))) * (_137 * _137)) * (1.0f - ((_123 * _123) * (3.0f - (_123 * 2.0f))))) * (1.0f - ((_124 * _124) * (3.0f - (_124 * 2.0f)))));
  } else {
    bool _149 = (_44 > 0.0f);
    [branch]
    if (_149) {
      _155 = (ceil(_44 * _28) / _44);
    } else {
      _155 = _28;
    }
    bool _156 = (_45 > 0.0f);
    [branch]
    if (_156) {
      _162 = (ceil(_45 * _31) / _45);
    } else {
      _162 = _31;
    }
    [branch]
    if (_149) {
      _168 = (ceil(_44 * _27) / _44);
    } else {
      _168 = _27;
    }
    [branch]
    if (_156) {
      _174 = (ceil(_45 * _30) / _45);
    } else {
      _174 = _30;
    }
    float _179 = saturate((TEXCOORD.x - _155) / _36);
    float _180 = saturate((TEXCOORD.y - _162) / _37);
    float _191 = saturate(((_40 + TEXCOORD.x) - _168) / _40);
    float _192 = saturate(((_41 + TEXCOORD.y) - _174) / _41);
    float _203 = _179 * _180;
    _211 = ((((((3.0f - (_179 * 2.0f)) * _19) * (3.0f - (_180 * 2.0f))) * (_203 * _203)) * (1.0f - ((_191 * _191) * (3.0f - (_191 * 2.0f))))) * (1.0f - ((_192 * _192) * (3.0f - (_192 * 2.0f)))));
  }
  [branch]
  if (ui2dColorMatrixR.w == 1.0f) {
    _248 = (exp2(log2(_16 * 5.55555534362793f) * ui2dColorMatrixG.w) * 0.18000000715255737f);
    _249 = (exp2(log2(_17 * 5.55555534362793f) * ui2dColorMatrixG.w) * 0.18000000715255737f);
    _250 = (exp2(log2(_18 * 5.55555534362793f) * ui2dColorMatrixG.w) * 0.18000000715255737f);
  } else {
    [branch]
    if (ui2dColorMatrixR.w == 2.0f) {
      _248 = (pow(_16, ui2dColorMatrixG.w));
      _249 = (pow(_17, ui2dColorMatrixG.w));
      _250 = (pow(_18, ui2dColorMatrixG.w));
    } else {
      _248 = _16;
      _249 = _17;
      _250 = _18;
    }
  }
  SV_Target.x = dot(float3(_248, _249, _250), float3(ui2dColorMatrixR.x, ui2dColorMatrixR.y, ui2dColorMatrixR.z));
  SV_Target.y = dot(float3(_248, _249, _250), float3(ui2dColorMatrixG.x, ui2dColorMatrixG.y, ui2dColorMatrixG.z));
  SV_Target.z = dot(float3(_248, _249, _250), float3(ui2dColorMatrixB.x, ui2dColorMatrixB.y, ui2dColorMatrixB.z));
  SV_Target.w = _211;

  // RenoDX: ease near-opaque black fades to true black (see header).
  if (max(_16, max(_17, _18)) <= FADE_BLACK_LEVEL)
  {
    float transmission = saturate(1.0f - SV_Target.w);
    SV_Target.w = 1.0f - transmission * smoothstep(0.0f, FADE_BLACK_EASE, transmission);
  }
  return SV_Target;
}
