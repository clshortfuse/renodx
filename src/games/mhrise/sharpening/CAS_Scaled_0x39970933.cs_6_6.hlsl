#include "sharpening.hlsli"

Texture2D<float4> SrcImage : register(t0);

RWTexture2D<float4> OutputImage : register(u0);

cbuffer cbCAS : register(b0) {
  uint4 const0 : packoffset(c000.x);
  uint4 const1 : packoffset(c001.x);
};

float3 SampleScaledSource(Texture2D<float4> src_image, int2 output_coord, int2 tex_max, uint4 uv_scale_offset) {
  float2 scale = float2(asfloat(uv_scale_offset.xy));
  float2 offset = float2(asfloat(uv_scale_offset.zw));

  float2 src = scale * float2(output_coord) + offset;
  float2 base = floor(src);
  float2 frac = src - base;
  int2 base_int = int2(base);

  int2 p00 = clamp(base_int, int2(0, 0), tex_max);
  int2 p10 = clamp(base_int + int2(1, 0), int2(0, 0), tex_max);
  int2 p01 = clamp(base_int + int2(0, 1), int2(0, 0), tex_max);
  int2 p11 = clamp(base_int + int2(1, 1), int2(0, 0), tex_max);

  float3 c00 = src_image.Load(int3(p00, 0)).rgb;
  float3 c10 = src_image.Load(int3(p10, 0)).rgb;
  float3 c01 = src_image.Load(int3(p01, 0)).rgb;
  float3 c11 = src_image.Load(int3(p11, 0)).rgb;

  float3 top = lerp(c00, c10, frac.x);
  float3 bottom = lerp(c01, c11, frac.x);
  return lerp(top, bottom, frac.y);
}

[numthreads(64, 1, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int _16 = (((uint)(SV_GroupThreadID.x) >> 1) & 7) | ((uint)((uint)(SV_GroupID.x) << 4));
  int _17 = ((((uint)(SV_GroupThreadID.x) >> 3) & 6) | ((uint)(SV_GroupThreadID.x) & 1)) | ((uint)((uint)(SV_GroupID.y) << 4));
  if (CUSTOM_SHARPENING == 1.f) {  // Lilium RCAS
    const float sharpness_strength = CUSTOM_SHARPENING_STRENGTH;
    uint2 tex_dim;
    SrcImage.GetDimensions(tex_dim.x, tex_dim.y);
    int2 tex_max = int2(tex_dim) - 1;
    uint4 uv_scale_offset = const0;  //

    float3 pixel0 = ApplyLiliumRCASFromSamples(
        SampleScaledSource(SrcImage, int2(_16, _17) + int2(0, -1), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16, _17) + int2(-1, 0), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16, _17), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16, _17) + int2(1, 0), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16, _17) + int2(0, 1), tex_max, uv_scale_offset),
        sharpness_strength);
    float3 pixel1 = ApplyLiliumRCASFromSamples(
        SampleScaledSource(SrcImage, int2(_16 | 8, _17) + int2(0, -1), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16 | 8, _17) + int2(-1, 0), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16 | 8, _17), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16 | 8, _17) + int2(1, 0), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16 | 8, _17) + int2(0, 1), tex_max, uv_scale_offset),
        sharpness_strength);
    float3 pixel2 = ApplyLiliumRCASFromSamples(
        SampleScaledSource(SrcImage, int2(_16 | 8, _17 | 8) + int2(0, -1), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16 | 8, _17 | 8) + int2(-1, 0), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16 | 8, _17 | 8), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16 | 8, _17 | 8) + int2(1, 0), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16 | 8, _17 | 8) + int2(0, 1), tex_max, uv_scale_offset),
        sharpness_strength);
    float3 pixel3 = ApplyLiliumRCASFromSamples(
        SampleScaledSource(SrcImage, int2(_16, _17 | 8) + int2(0, -1), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16, _17 | 8) + int2(-1, 0), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16, _17 | 8), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16, _17 | 8) + int2(1, 0), tex_max, uv_scale_offset),
        SampleScaledSource(SrcImage, int2(_16, _17 | 8) + int2(0, 1), tex_max, uv_scale_offset),
        sharpness_strength);

    if (CUSTOM_FILM_GRAIN != 0.f)
    {
      float ref_white = RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS;
      pixel0 = renodx::effects::ApplyFilmGrain(pixel0, float2(_16, _17) / float2(tex_dim), CUSTOM_RANDOM, CUSTOM_FILM_GRAIN * 0.03f, ref_white);
      pixel1 = renodx::effects::ApplyFilmGrain(pixel1, float2(_16 | 8, _17) / float2(tex_dim), CUSTOM_RANDOM, CUSTOM_FILM_GRAIN * 0.03f, ref_white);
      pixel2 = renodx::effects::ApplyFilmGrain(pixel2, float2(_16 | 8, _17 | 8) / float2(tex_dim), CUSTOM_RANDOM, CUSTOM_FILM_GRAIN* 0.03f, ref_white);
      pixel3 = renodx::effects::ApplyFilmGrain(pixel3, float2(_16, _17 | 8) / float2(tex_dim), CUSTOM_RANDOM, CUSTOM_FILM_GRAIN * 0.03f, ref_white);
    }
    OutputImage[int2(_16, _17)] = float4(pixel0, 1.f);
    OutputImage[int2(_16 | 8, _17)] = float4(pixel1, 1.f);
    OutputImage[int2(_16 | 8, _17 | 8)] = float4(pixel2, 1.f);
    OutputImage[int2(_16, _17 | 8)] = float4(pixel3, 1.f);
    return;
  } else
  {

    float _25 = float((uint)_16);
    float _26 = float((uint)_17);
    float _33 = (asfloat((uint)(const0.x)) * _25) + asfloat((uint)(const0.z));
    float _34 = (asfloat((uint)(const0.y)) * _26) + asfloat((uint)(const0.w));
    float _35 = floor(_33);
    float _36 = floor(_34);
    float _37 = _33 - _35;
    float _38 = _34 - _36;
    int _39 = int(_35);
    int _40 = int(_36);
    uint _41 = _40 + -1u;
    float4 _43 = SrcImage.Load(int3(_39, _41, 0));
    float _48 = max(0.0f, _43.y);
    float _50 = _48 * 0.0078125f;
    uint _51 = _39 + -1u;
    float4 _52 = SrcImage.Load(int3(_51, _40, 0));
    float _57 = max(0.0f, _52.y);
    float _59 = _57 * 0.0078125f;
    float4 _60 = SrcImage.Load(int3(_39, _40, 0));
    float _67 = max(0.0f, _60.y) * 0.0078125f;
    uint _68 = _39 + 1u;
    float4 _69 = SrcImage.Load(int3(_68, _41, 0));
    float _74 = max(0.0f, _69.y);
    float _76 = _74 * 0.0078125f;
    float4 _77 = SrcImage.Load(int3(_68, _40, 0));
    float _84 = max(0.0f, _77.y) * 0.0078125f;
    uint _85 = _39 + 2u;
    float4 _86 = SrcImage.Load(int3(_85, _40, 0));
    float _91 = max(0.0f, _86.y);
    float _93 = _91 * 0.0078125f;
    uint _94 = _40 + 1u;
    float4 _95 = SrcImage.Load(int3(_51, _94, 0));
    float _100 = max(0.0f, _95.y);
    float _102 = _100 * 0.0078125f;
    float4 _103 = SrcImage.Load(int3(_39, _94, 0));
    float _110 = max(0.0f, _103.y) * 0.0078125f;
    uint _111 = _40 + 2u;
    float4 _112 = SrcImage.Load(int3(_39, _111, 0));
    float _117 = max(0.0f, _112.y);
    float _119 = _117 * 0.0078125f;
    float4 _120 = SrcImage.Load(int3(_68, _94, 0));
    float _127 = max(0.0f, _120.y) * 0.0078125f;
    float4 _128 = SrcImage.Load(int3(_85, _94, 0));
    float _133 = max(0.0f, _128.y);
    float _135 = _133 * 0.0078125f;
    float4 _136 = SrcImage.Load(int3(_68, _111, 0));
    float _141 = max(0.0f, _136.y);
    float _143 = _141 * 0.0078125f;
    float _147 = min(min(min(min(_50, _59), _67), _84), _110);
    float _151 = max(max(max(max(_50, _59), _67), _84), _110);
    float _155 = min(min(min(min(_76, _67), _84), _93), _127);
    float _159 = max(max(max(max(_76, _67), _84), _93), _127);
    float _163 = min(min(min(min(_67, _102), _110), _127), _119);
    float _167 = max(max(max(max(_67, _102), _110), _127), _119);
    float _171 = min(min(min(min(_84, _110), _127), _135), _143);
    float _175 = max(max(max(max(_84, _110), _127), _135), _143);
    float _220 = asfloat((uint)(const1.x));
    float _225 = 1.0f - _37;
    float _226 = 1.0f - _38;
    float _236 = (_225 * _226) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _147) + _151))))));
    float _242 = (_226 * _37) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _155) + _159))))));
    float _248 = (_225 * _38) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _163) + _167))))));
    float _254 = (_37 * _38) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _171) + _175))))));
    float _255 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_147, (1.0f - _151)) * asfloat(((uint)(2129690299u - (int)(asint(_151))))))))) >> 1)) + 532432441u))) * _220) * _236;
    float _256 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_155, (1.0f - _159)) * asfloat(((uint)(2129690299u - (int)(asint(_159))))))))) >> 1)) + 532432441u))) * _220) * _242;
    float _257 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_163, (1.0f - _167)) * asfloat(((uint)(2129690299u - (int)(asint(_167))))))))) >> 1)) + 532432441u))) * _220) * _248;
    float _259 = (_256 + _236) + _257;
    float _260 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_171, (1.0f - _175)) * asfloat(((uint)(2129690299u - (int)(asint(_175))))))))) >> 1)) + 532432441u))) * _220) * _254;
    float _262 = (_255 + _242) + _260;
    float _264 = (_255 + _248) + _260;
    float _266 = (_256 + _254) + _257;
    float _274 = (((_266 + _259) + ((((_256 + _255) + _257) + _260) * 2.0f)) + _262) + _264;
    float _277 = asfloat(((uint)(2129764351u - (int)(asint(_274)))));
    float _280 = (2.0f - (_277 * _274)) * _277;
    float _300 = _280 * 0.0078125f;
    OutputImage[int2(_16, _17)] = float4((saturate(_300 * ((((((((_266 * max(0.0f, _120.x)) + (_255 * (max(0.0f, _52.x) + max(0.0f, _43.x)))) + (_259 * max(0.0f, _60.x))) + (_262 * max(0.0f, _77.x))) + (_264 * max(0.0f, _103.x))) + (_260 * (max(0.0f, _136.x) + max(0.0f, _128.x)))) + (_257 * (max(0.0f, _112.x) + max(0.0f, _95.x)))) + (_256 * (max(0.0f, _86.x) + max(0.0f, _69.x))))) * 128.0f), (saturate(_280 * ((((((((_259 * _67) + (((_57 + _48) * 0.0078125f) * _255)) + (_266 * _127)) + (_262 * _84)) + (_264 * _110)) + (_260 * ((_141 + _133) * 0.0078125f))) + (_257 * ((_117 + _100) * 0.0078125f))) + (_256 * ((_91 + _74) * 0.0078125f)))) * 128.0f), (saturate(_300 * ((((((((_266 * max(0.0f, _120.z)) + (_255 * (max(0.0f, _52.z) + max(0.0f, _43.z)))) + (_259 * max(0.0f, _60.z))) + (_262 * max(0.0f, _77.z))) + (_264 * max(0.0f, _103.z))) + (_260 * (max(0.0f, _136.z) + max(0.0f, _128.z)))) + (_257 * (max(0.0f, _112.z) + max(0.0f, _95.z)))) + (_256 * (max(0.0f, _86.z) + max(0.0f, _69.z))))) * 128.0f), 1.0f);
    int _353 = _16 | 8;
    float _361 = float((uint)_353);
    float _368 = (asfloat((uint)(const0.x)) * _361) + asfloat((uint)(const0.z));
    float _369 = (asfloat((uint)(const0.y)) * _26) + asfloat((uint)(const0.w));
    float _370 = floor(_368);
    float _371 = floor(_369);
    float _372 = _368 - _370;
    float _373 = _369 - _371;
    int _374 = int(_370);
    int _375 = int(_371);
    uint _376 = _375 + -1u;
    float4 _378 = SrcImage.Load(int3(_374, _376, 0));
    float _383 = max(0.0f, _378.y);
    float _385 = _383 * 0.0078125f;
    uint _386 = _374 + -1u;
    float4 _387 = SrcImage.Load(int3(_386, _375, 0));
    float _392 = max(0.0f, _387.y);
    float _394 = _392 * 0.0078125f;
    float4 _395 = SrcImage.Load(int3(_374, _375, 0));
    float _402 = max(0.0f, _395.y) * 0.0078125f;
    uint _403 = _374 + 1u;
    float4 _404 = SrcImage.Load(int3(_403, _376, 0));
    float _409 = max(0.0f, _404.y);
    float _411 = _409 * 0.0078125f;
    float4 _412 = SrcImage.Load(int3(_403, _375, 0));
    float _419 = max(0.0f, _412.y) * 0.0078125f;
    uint _420 = _374 + 2u;
    float4 _421 = SrcImage.Load(int3(_420, _375, 0));
    float _426 = max(0.0f, _421.y);
    float _428 = _426 * 0.0078125f;
    uint _429 = _375 + 1u;
    float4 _430 = SrcImage.Load(int3(_386, _429, 0));
    float _435 = max(0.0f, _430.y);
    float _437 = _435 * 0.0078125f;
    float4 _438 = SrcImage.Load(int3(_374, _429, 0));
    float _445 = max(0.0f, _438.y) * 0.0078125f;
    uint _446 = _375 + 2u;
    float4 _447 = SrcImage.Load(int3(_374, _446, 0));
    float _452 = max(0.0f, _447.y);
    float _454 = _452 * 0.0078125f;
    float4 _455 = SrcImage.Load(int3(_403, _429, 0));
    float _462 = max(0.0f, _455.y) * 0.0078125f;
    float4 _463 = SrcImage.Load(int3(_420, _429, 0));
    float _468 = max(0.0f, _463.y);
    float _470 = _468 * 0.0078125f;
    float4 _471 = SrcImage.Load(int3(_403, _446, 0));
    float _476 = max(0.0f, _471.y);
    float _478 = _476 * 0.0078125f;
    float _482 = min(min(min(min(_385, _394), _402), _419), _445);
    float _486 = max(max(max(max(_385, _394), _402), _419), _445);
    float _490 = min(min(min(min(_411, _402), _419), _428), _462);
    float _494 = max(max(max(max(_411, _402), _419), _428), _462);
    float _498 = min(min(min(min(_402, _437), _445), _462), _454);
    float _502 = max(max(max(max(_402, _437), _445), _462), _454);
    float _506 = min(min(min(min(_419, _445), _462), _470), _478);
    float _510 = max(max(max(max(_419, _445), _462), _470), _478);
    float _555 = asfloat((uint)(const1.x));
    float _560 = 1.0f - _372;
    float _561 = 1.0f - _373;
    float _571 = (_560 * _561) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _482) + _486))))));
    float _577 = (_561 * _372) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _490) + _494))))));
    float _583 = (_560 * _373) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _498) + _502))))));
    float _589 = (_372 * _373) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _506) + _510))))));
    float _590 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_482, (1.0f - _486)) * asfloat(((uint)(2129690299u - (int)(asint(_486))))))))) >> 1)) + 532432441u))) * _555) * _571;
    float _591 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_490, (1.0f - _494)) * asfloat(((uint)(2129690299u - (int)(asint(_494))))))))) >> 1)) + 532432441u))) * _555) * _577;
    float _592 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_498, (1.0f - _502)) * asfloat(((uint)(2129690299u - (int)(asint(_502))))))))) >> 1)) + 532432441u))) * _555) * _583;
    float _594 = (_591 + _571) + _592;
    float _595 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_506, (1.0f - _510)) * asfloat(((uint)(2129690299u - (int)(asint(_510))))))))) >> 1)) + 532432441u))) * _555) * _589;
    float _597 = (_590 + _577) + _595;
    float _599 = (_590 + _583) + _595;
    float _601 = (_591 + _589) + _592;
    float _609 = (((_601 + _594) + ((((_591 + _590) + _592) + _595) * 2.0f)) + _597) + _599;
    float _612 = asfloat(((uint)(2129764351u - (int)(asint(_609)))));
    float _615 = (2.0f - (_612 * _609)) * _612;
    float _635 = _615 * 0.0078125f;
    OutputImage[int2(_353, _17)] = float4((saturate(_635 * ((((((((_601 * max(0.0f, _455.x)) + (_590 * (max(0.0f, _387.x) + max(0.0f, _378.x)))) + (_594 * max(0.0f, _395.x))) + (_597 * max(0.0f, _412.x))) + (_599 * max(0.0f, _438.x))) + (_595 * (max(0.0f, _471.x) + max(0.0f, _463.x)))) + (_592 * (max(0.0f, _447.x) + max(0.0f, _430.x)))) + (_591 * (max(0.0f, _421.x) + max(0.0f, _404.x))))) * 128.0f), (saturate(_615 * ((((((((_594 * _402) + (((_392 + _383) * 0.0078125f) * _590)) + (_601 * _462)) + (_597 * _419)) + (_599 * _445)) + (_595 * ((_476 + _468) * 0.0078125f))) + (_592 * ((_452 + _435) * 0.0078125f))) + (_591 * ((_426 + _409) * 0.0078125f)))) * 128.0f), (saturate(_635 * ((((((((_601 * max(0.0f, _455.z)) + (_590 * (max(0.0f, _387.z) + max(0.0f, _378.z)))) + (_594 * max(0.0f, _395.z))) + (_597 * max(0.0f, _412.z))) + (_599 * max(0.0f, _438.z))) + (_595 * (max(0.0f, _471.z) + max(0.0f, _463.z)))) + (_592 * (max(0.0f, _447.z) + max(0.0f, _430.z)))) + (_591 * (max(0.0f, _421.z) + max(0.0f, _404.z))))) * 128.0f), 1.0f);
    int _688 = _17 | 8;
    float _696 = float((uint)_688);
    float _703 = (asfloat((uint)(const0.x)) * _361) + asfloat((uint)(const0.z));
    float _704 = (asfloat((uint)(const0.y)) * _696) + asfloat((uint)(const0.w));
    float _705 = floor(_703);
    float _706 = floor(_704);
    float _707 = _703 - _705;
    float _708 = _704 - _706;
    int _709 = int(_705);
    int _710 = int(_706);
    uint _711 = _710 + -1u;
    float4 _713 = SrcImage.Load(int3(_709, _711, 0));
    float _718 = max(0.0f, _713.y);
    float _720 = _718 * 0.0078125f;
    uint _721 = _709 + -1u;
    float4 _722 = SrcImage.Load(int3(_721, _710, 0));
    float _727 = max(0.0f, _722.y);
    float _729 = _727 * 0.0078125f;
    float4 _730 = SrcImage.Load(int3(_709, _710, 0));
    float _737 = max(0.0f, _730.y) * 0.0078125f;
    uint _738 = _709 + 1u;
    float4 _739 = SrcImage.Load(int3(_738, _711, 0));
    float _744 = max(0.0f, _739.y);
    float _746 = _744 * 0.0078125f;
    float4 _747 = SrcImage.Load(int3(_738, _710, 0));
    float _754 = max(0.0f, _747.y) * 0.0078125f;
    uint _755 = _709 + 2u;
    float4 _756 = SrcImage.Load(int3(_755, _710, 0));
    float _761 = max(0.0f, _756.y);
    float _763 = _761 * 0.0078125f;
    uint _764 = _710 + 1u;
    float4 _765 = SrcImage.Load(int3(_721, _764, 0));
    float _770 = max(0.0f, _765.y);
    float _772 = _770 * 0.0078125f;
    float4 _773 = SrcImage.Load(int3(_709, _764, 0));
    float _780 = max(0.0f, _773.y) * 0.0078125f;
    uint _781 = _710 + 2u;
    float4 _782 = SrcImage.Load(int3(_709, _781, 0));
    float _787 = max(0.0f, _782.y);
    float _789 = _787 * 0.0078125f;
    float4 _790 = SrcImage.Load(int3(_738, _764, 0));
    float _797 = max(0.0f, _790.y) * 0.0078125f;
    float4 _798 = SrcImage.Load(int3(_755, _764, 0));
    float _803 = max(0.0f, _798.y);
    float _805 = _803 * 0.0078125f;
    float4 _806 = SrcImage.Load(int3(_738, _781, 0));
    float _811 = max(0.0f, _806.y);
    float _813 = _811 * 0.0078125f;
    float _817 = min(min(min(min(_720, _729), _737), _754), _780);
    float _821 = max(max(max(max(_720, _729), _737), _754), _780);
    float _825 = min(min(min(min(_746, _737), _754), _763), _797);
    float _829 = max(max(max(max(_746, _737), _754), _763), _797);
    float _833 = min(min(min(min(_737, _772), _780), _797), _789);
    float _837 = max(max(max(max(_737, _772), _780), _797), _789);
    float _841 = min(min(min(min(_754, _780), _797), _805), _813);
    float _845 = max(max(max(max(_754, _780), _797), _805), _813);
    float _890 = asfloat((uint)(const1.x));
    float _895 = 1.0f - _707;
    float _896 = 1.0f - _708;
    float _906 = (_895 * _896) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _817) + _821))))));
    float _912 = (_896 * _707) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _825) + _829))))));
    float _918 = (_895 * _708) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _833) + _837))))));
    float _924 = (_707 * _708) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _841) + _845))))));
    float _925 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_817, (1.0f - _821)) * asfloat(((uint)(2129690299u - (int)(asint(_821))))))))) >> 1)) + 532432441u))) * _890) * _906;
    float _926 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_825, (1.0f - _829)) * asfloat(((uint)(2129690299u - (int)(asint(_829))))))))) >> 1)) + 532432441u))) * _890) * _912;
    float _927 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_833, (1.0f - _837)) * asfloat(((uint)(2129690299u - (int)(asint(_837))))))))) >> 1)) + 532432441u))) * _890) * _918;
    float _929 = (_926 + _906) + _927;
    float _930 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_841, (1.0f - _845)) * asfloat(((uint)(2129690299u - (int)(asint(_845))))))))) >> 1)) + 532432441u))) * _890) * _924;
    float _932 = (_925 + _912) + _930;
    float _934 = (_925 + _918) + _930;
    float _936 = (_926 + _924) + _927;
    float _944 = (((_936 + _929) + ((((_926 + _925) + _927) + _930) * 2.0f)) + _932) + _934;
    float _947 = asfloat(((uint)(2129764351u - (int)(asint(_944)))));
    float _950 = (2.0f - (_947 * _944)) * _947;
    float _970 = _950 * 0.0078125f;
    OutputImage[int2(_353, _688)] = float4((saturate(_970 * ((((((((_936 * max(0.0f, _790.x)) + (_925 * (max(0.0f, _722.x) + max(0.0f, _713.x)))) + (_929 * max(0.0f, _730.x))) + (_932 * max(0.0f, _747.x))) + (_934 * max(0.0f, _773.x))) + (_930 * (max(0.0f, _806.x) + max(0.0f, _798.x)))) + (_927 * (max(0.0f, _782.x) + max(0.0f, _765.x)))) + (_926 * (max(0.0f, _756.x) + max(0.0f, _739.x))))) * 128.0f), (saturate(_950 * ((((((((_929 * _737) + (((_727 + _718) * 0.0078125f) * _925)) + (_936 * _797)) + (_932 * _754)) + (_934 * _780)) + (_930 * ((_811 + _803) * 0.0078125f))) + (_927 * ((_787 + _770) * 0.0078125f))) + (_926 * ((_761 + _744) * 0.0078125f)))) * 128.0f), (saturate(_970 * ((((((((_936 * max(0.0f, _790.z)) + (_925 * (max(0.0f, _722.z) + max(0.0f, _713.z)))) + (_929 * max(0.0f, _730.z))) + (_932 * max(0.0f, _747.z))) + (_934 * max(0.0f, _773.z))) + (_930 * (max(0.0f, _806.z) + max(0.0f, _798.z)))) + (_927 * (max(0.0f, _782.z) + max(0.0f, _765.z)))) + (_926 * (max(0.0f, _756.z) + max(0.0f, _739.z))))) * 128.0f), 1.0f);
    float _1036 = (asfloat((uint)(const0.x)) * _25) + asfloat((uint)(const0.z));
    float _1037 = (asfloat((uint)(const0.y)) * _696) + asfloat((uint)(const0.w));
    float _1038 = floor(_1036);
    float _1039 = floor(_1037);
    float _1040 = _1036 - _1038;
    float _1041 = _1037 - _1039;
    int _1042 = int(_1038);
    int _1043 = int(_1039);
    uint _1044 = _1043 + -1u;
    float4 _1046 = SrcImage.Load(int3(_1042, _1044, 0));
    float _1051 = max(0.0f, _1046.y);
    float _1053 = _1051 * 0.0078125f;
    uint _1054 = _1042 + -1u;
    float4 _1055 = SrcImage.Load(int3(_1054, _1043, 0));
    float _1060 = max(0.0f, _1055.y);
    float _1062 = _1060 * 0.0078125f;
    float4 _1063 = SrcImage.Load(int3(_1042, _1043, 0));
    float _1070 = max(0.0f, _1063.y) * 0.0078125f;
    uint _1071 = _1042 + 1u;
    float4 _1072 = SrcImage.Load(int3(_1071, _1044, 0));
    float _1077 = max(0.0f, _1072.y);
    float _1079 = _1077 * 0.0078125f;
    float4 _1080 = SrcImage.Load(int3(_1071, _1043, 0));
    float _1087 = max(0.0f, _1080.y) * 0.0078125f;
    uint _1088 = _1042 + 2u;
    float4 _1089 = SrcImage.Load(int3(_1088, _1043, 0));
    float _1094 = max(0.0f, _1089.y);
    float _1096 = _1094 * 0.0078125f;
    uint _1097 = _1043 + 1u;
    float4 _1098 = SrcImage.Load(int3(_1054, _1097, 0));
    float _1103 = max(0.0f, _1098.y);
    float _1105 = _1103 * 0.0078125f;
    float4 _1106 = SrcImage.Load(int3(_1042, _1097, 0));
    float _1113 = max(0.0f, _1106.y) * 0.0078125f;
    uint _1114 = _1043 + 2u;
    float4 _1115 = SrcImage.Load(int3(_1042, _1114, 0));
    float _1120 = max(0.0f, _1115.y);
    float _1122 = _1120 * 0.0078125f;
    float4 _1123 = SrcImage.Load(int3(_1071, _1097, 0));
    float _1130 = max(0.0f, _1123.y) * 0.0078125f;
    float4 _1131 = SrcImage.Load(int3(_1088, _1097, 0));
    float _1136 = max(0.0f, _1131.y);
    float _1138 = _1136 * 0.0078125f;
    float4 _1139 = SrcImage.Load(int3(_1071, _1114, 0));
    float _1144 = max(0.0f, _1139.y);
    float _1146 = _1144 * 0.0078125f;
    float _1150 = min(min(min(min(_1053, _1062), _1070), _1087), _1113);
    float _1154 = max(max(max(max(_1053, _1062), _1070), _1087), _1113);
    float _1158 = min(min(min(min(_1079, _1070), _1087), _1096), _1130);
    float _1162 = max(max(max(max(_1079, _1070), _1087), _1096), _1130);
    float _1166 = min(min(min(min(_1070, _1105), _1113), _1130), _1122);
    float _1170 = max(max(max(max(_1070, _1105), _1113), _1130), _1122);
    float _1174 = min(min(min(min(_1087, _1113), _1130), _1138), _1146);
    float _1178 = max(max(max(max(_1087, _1113), _1130), _1138), _1146);
    float _1223 = asfloat((uint)(const1.x));
    float _1228 = 1.0f - _1040;
    float _1229 = 1.0f - _1041;
    float _1239 = (_1228 * _1229) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _1150) + _1154))))));
    float _1245 = (_1229 * _1040) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _1158) + _1162))))));
    float _1251 = (_1228 * _1041) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _1166) + _1170))))));
    float _1257 = (_1040 * _1041) * asfloat(((uint)(2129690299u - (int)(asint(((0.03125f - _1174) + _1178))))));
    float _1258 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_1150, (1.0f - _1154)) * asfloat(((uint)(2129690299u - (int)(asint(_1154))))))))) >> 1)) + 532432441u))) * _1223) * _1239;
    float _1259 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_1158, (1.0f - _1162)) * asfloat(((uint)(2129690299u - (int)(asint(_1162))))))))) >> 1)) + 532432441u))) * _1223) * _1245;
    float _1260 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_1166, (1.0f - _1170)) * asfloat(((uint)(2129690299u - (int)(asint(_1170))))))))) >> 1)) + 532432441u))) * _1223) * _1251;
    float _1262 = (_1259 + _1239) + _1260;
    float _1263 = (asfloat(((uint)(((int)((uint)((int)(asint(saturate(min(_1174, (1.0f - _1178)) * asfloat(((uint)(2129690299u - (int)(asint(_1178))))))))) >> 1)) + 532432441u))) * _1223) * _1257;
    float _1265 = (_1258 + _1245) + _1263;
    float _1267 = (_1258 + _1251) + _1263;
    float _1269 = (_1259 + _1257) + _1260;
    float _1277 = (((_1269 + _1262) + ((((_1259 + _1258) + _1260) + _1263) * 2.0f)) + _1265) + _1267;
    float _1280 = asfloat(((uint)(2129764351u - (int)(asint(_1277)))));
    float _1283 = (2.0f - (_1280 * _1277)) * _1280;
    float _1303 = _1283 * 0.0078125f;
    OutputImage[int2(_16, _688)] = float4((saturate(_1303 * ((((((((_1269 * max(0.0f, _1123.x)) + (_1258 * (max(0.0f, _1055.x) + max(0.0f, _1046.x)))) + (_1262 * max(0.0f, _1063.x))) + (_1265 * max(0.0f, _1080.x))) + (_1267 * max(0.0f, _1106.x))) + (_1263 * (max(0.0f, _1139.x) + max(0.0f, _1131.x)))) + (_1260 * (max(0.0f, _1115.x) + max(0.0f, _1098.x)))) + (_1259 * (max(0.0f, _1089.x) + max(0.0f, _1072.x))))) * 128.0f), (saturate(_1283 * ((((((((_1262 * _1070) + (((_1060 + _1051) * 0.0078125f) * _1258)) + (_1269 * _1130)) + (_1265 * _1087)) + (_1267 * _1113)) + (_1263 * ((_1144 + _1136) * 0.0078125f))) + (_1260 * ((_1120 + _1103) * 0.0078125f))) + (_1259 * ((_1094 + _1077) * 0.0078125f)))) * 128.0f), (saturate(_1303 * ((((((((_1269 * max(0.0f, _1123.z)) + (_1258 * (max(0.0f, _1055.z) + max(0.0f, _1046.z)))) + (_1262 * max(0.0f, _1063.z))) + (_1265 * max(0.0f, _1080.z))) + (_1267 * max(0.0f, _1106.z))) + (_1263 * (max(0.0f, _1139.z) + max(0.0f, _1131.z)))) + (_1260 * (max(0.0f, _1115.z) + max(0.0f, _1098.z)))) + (_1259 * (max(0.0f, _1089.z) + max(0.0f, _1072.z))))) * 128.0f), 1.0f);
  }
}
