#version 450
#include "./shared.h"

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

#define METROID_GAMMA fp_c3_1._m0[0].y
#include "./shared.slang"

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_C;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_14;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_12;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 _35;
layout(location = 0) out vec4 _38;

vec3 ApplyTonemap(vec3 hdr, bool useHdrPath = false)
{
    const float kBiasA = 0.589999973773956298828125;
    const float kBiasB = 0.02999999932944774627685546875;
    const float kLumaR = 0.2989999949932098388671875;
    const float kHdrBlendStart = 1.0;
    const float kHdrBlendEnd = 4.0;

    vec3 curve = fma(hdr, fp_c1_1._m0[0].x, kBiasA);
    vec3 toe = fma(hdr, fp_c1_1._m0[0].z, kBiasB);
    vec3 denom = fma(hdr, curve, fp_c1_1._m0[0].y);
    vec3 mappedSdr = saturate((hdr * toe) * (1.0 / denom));

    vec3 toneMapped = mappedSdr;
    if (useHdrPath) {
        vec3 mappedHdr = (hdr * toe) * (1.0 / denom);
        float hdrPeak = renodx::math::Max(hdr);
        float hdrBlend = smoothstep(kHdrBlendStart, kHdrBlendEnd, hdrPeak);
        toneMapped = mix(mappedHdr, hdr, hdrBlend);
    }

    float mixWeight = fma(toneMapped.z, fp_c1_1._m0[1].x, fma(toneMapped.y, fp_c1_1._m0[0].w, toneMapped.x * kLumaR));
    float logMix = log2(mixWeight);

    vec3 blend = fma(mixWeight, -fp_c3_1._m0[2].xyz, toneMapped);
    vec3 add = mixWeight * fp_c3_1._m0[2].xyz;
    float blendAmount = saturate(exp2(logMix * fp_c3_1._m0[2].w));
    return fma(blend, blendAmount, add);
}

void main()
{
    bool useHdrPath = (RENODX_TONE_MAP_TYPE != 0.f);

    vec2 uv = _35.xy;
    float lutBand = floor(uv.x * fp_c3_1._m0[11].x);

    float lutU = saturate(uv.x * fp_c3_1._m0[11].x * fp_c3_1._m0[10].z);
    float lutV = saturate(uv.y * fp_c3_1._m0[11].y * fp_c3_1._m0[10].w);

    vec3 lutA = texture(fp_t_tcb_14, vec2(lutU, lutV)).xyz;
    vec3 lutB = texture(fp_t_tcb_C, vec2(lutU, lutV)).xyz;
    vec3 blendTex = texture(fp_t_tcb_12, uv).xyz;
    vec3 base = texture(fp_t_tcb_8, uv).xyz;

    // Cutscene-only addition: fp_t_tcb_12 modulates LUT contribution before exposure.
    vec3 lutSum = lutA + lutB;
    vec3 hdrInput = fma(lutSum * blendTex, fp_c3_1._m0[3].y, lutSum) + base;

    float exposure = exp2(fp_c3_1._m0[0].x);
    vec3 hdr = exposure * hdrInput;
    vec3 output = ApplyTonemap(hdr, useHdrPath);

    if (useHdrPath) output = MetroidCorrect(output, ApplyTonemap(hdr));

    vec3 offsetFilm = output + fp_c3_1._m0[1].x;
    vec3 postCurveMapped = fma(offsetFilm - vec3(1.5), fp_c3_1._m0[0].w, vec3(0.5));
    vec3 postCurveInput = useHdrPath ? max(postCurveMapped, 0.0) : saturate(postCurveMapped);

    float gammaBase = fp_c3_1._m0[0].y * 0.454545438289642333984375;
    vec3 curved = exp2(gammaBase.xxx * log2(postCurveInput));

    float halfRadius = 0.5 * fp_c3_1._m0[7].z;
    float invHalfRadius = 1.0 / halfRadius;
    vec2 centeredUv = (uv - halfRadius.xx) * invHalfRadius;
    float radial = fma(fp_c3_1._m0[7].y - fp_c3_1._m0[7].x, length(centeredUv), fp_c3_1._m0[7].x);

    float invLift = 1.0 / saturate(1.0 - fp_c3_1._m0[6].y);
    vec3 lifted = (curved - fp_c3_1._m0[6].x) * invLift;

    vec3 radialBlend = lifted * (1.0 - radial);
    vec3 edgeBlend = lifted * (1.0 - fp_c3_1._m0[7].w);
    vec3 gradedSpatial = fma(radialBlend, fp_c3_1._m0[7].w, edgeBlend);

    float vignetteInv = 1.0 / (fp_c3_1._m0[4].y + 9.9999997473787516355514526367188e-05);
    vec3 vignette = gradedSpatial * vignetteInv;

    float phase = fma(uv.y * fp_c3_1._m0[10].y, 1.0 / fp_c3_1._m0[9].x, -(fp_c3_1._m0[8].x * fp_c3_1._m0[9].z * 6.280000209808349609375));
    float scanline = sin(phase) * fp_c3_1._m0[9].y;

    float vignetteMix = clamp(fma(vignette.z, fp_c1_1._m0[1].w, fma(vignette.y, fp_c1_1._m0[1].w, vignette.x * 0.3300000131130218505859375)), 0.0, 1.0);

    float grainSeedY = roundEven(uv.y * 8000.0);
    float grainSeedX = roundEven(uv.x * 8000.0);
    float fracCell = fp_c3_1._m0[8].x - floor(fp_c3_1._m0[8].x);
    float grainHash = fma(fma(grainSeedY, fp_c1_1._m0[1].y, fracCell), fp_c1_1._m0[1].z, fma(grainSeedX, fp_c1_1._m0[1].y, fracCell));
    float noise = sin(grainHash) * 493013.0;
    float noiseFrac = noise - floor(noise);

    float stripeMask = clamp(fma(fma(floor(lutBand * 0.5), -2.0, lutBand), 1.0, fp_c3_1._m0[9].w), 0.0, 1.0);
    float jitterScale = fma(vignetteMix, -fp_c3_1._m0[4].x, fp_c3_1._m0[4].x);

    vec3 jitteredRaw = gradedSpatial - (jitterScale * noiseFrac).xxx;
    vec3 jittered = useHdrPath ? max(jitteredRaw, 0.0) : clamp(jitteredRaw, 0.0, 1.0);
    output = fma(jittered, stripeMask.xxx, scanline.xxx);

    output = ApplyColorGrade(output);
    output = renodx::color::srgb::DecodeSafe(output);
    output = renodx::color::gamma::EncodeSafe(output, METROID_GAMMA);
    
    float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION == 1.f) {
        peak = renodx::color::correct::GammaSafe(peak, true);
    }
    if (RENODX_GAMMA_CORRECTION == 2.f) {
        peak = renodx::color::correct::GammaSafe(peak, true, 2.4);
    }

    output = renodx::tonemap::neutwo::PerChannel(output, peak);
    
    _38.xyz = renodx::draw::RenderIntermediatePass(output);
    _38.w = 0.0;
}

// #version 450

// layout(set = 0, binding = 0, std140) uniform support_buffer
// {
//   uint _m0;
//   uint _m1[8];
//   vec4 _m2;
//   vec4 _m3;
//   int _m4;
//   float _m5[73];
//   ivec4 _m6;
//   int _m7;
// } support_buffer_1;

// layout(set = 0, binding = 22, std140) uniform fp_c3
// {
//   vec4 _m0[4096];
// } fp_c3_1;

// layout(set = 0, binding = 20, std140) uniform fp_c1
// {
//   vec4 _m0[4096];
// } fp_c1_1;

// layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_C;
// layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_14;
// layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_12;
// layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_8;

// layout(location = 0) in vec4 _35;
// layout(location = 0) out vec4 _38;

// void main()
// {
//   float _45 = _35.y;
//   float _47 = _35.x;
//   precise float _502 = _45 * fp_c3_1._m0[11].y;
//   float _49 = _502;
//   precise float _508 = _49 * fp_c3_1._m0[10].w;
//   float _51 = _508;
//   float _53 = clamp(_51, 0.0, 1.0);
//   precise float _517 = _47 * fp_c3_1._m0[11].x;
//   float _55 = _517;
//   precise float _522 = _55 * fp_c3_1._m0[10].z;
//   float _57 = _522;
//   float _59 = clamp(_57, 0.0, 1.0);
//   vec3 _63 = texture(fp_t_tcb_C, vec2(_59, _53)).xyz;
//   float _65 = _63.x;
//   float _67 = _63.y;
//   float _69 = _63.z;
//   vec3 _71 = texture(fp_t_tcb_14, vec2(_59, _53)).xyz;
//   float _73 = _71.x;
//   float _75 = _71.y;
//   float _77 = _71.z;
//   vec3 _79 = texture(fp_t_tcb_12, vec2(_47, _45)).xyz;
//   float _81 = _79.x;
//   float _83 = _79.y;
//   float _85 = _79.z;
//   vec3 _87 = texture(fp_t_tcb_8, vec2(_47, _45)).xyz;
//   float _89 = _87.x;
//   float _91 = _87.y;
//   float _93 = _87.z;
//   float _95 = floor(_55);
//   precise float _578 = _65 + _73;
//   float _97 = _578;
//   precise float _581 = _67 + _75;
//   float _99 = _581;
//   precise float _584 = _69 + _77;
//   float _101 = _584;
//   precise float _587 = _97 * _81;
//   float _103 = _587;
//   precise float _590 = _99 * _83;
//   float _105 = _590;
//   float _107 = exp2(fp_c3_1._m0[0].x);
//   precise float _596 = _101 * _85;
//   float _109 = _596;
//   float _111 = fma(_103, fp_c3_1._m0[3].y, _97);
//   float _113 = fma(_105, fp_c3_1._m0[3].y, _99);
//   float _115 = fma(_109, fp_c3_1._m0[3].y, _101);
//   precise float _614 = _111 + _89;
//   float _117 = _614;
//   precise float _617 = _113 + _91;
//   float _119 = _617;
//   precise float _620 = _115 + _93;
//   float _121 = _620;
//   precise float _623 = _117 * _107;
//   float _123 = _623;
//   precise float _626 = _119 * _107;
//   float _125 = _626;
//   precise float _629 = _121 * _107;
//   float _127 = _629;
//   float _129 = fma(_123, fp_c1_1._m0[0].x, 0.589999973773956298828125);
//   float _131 = fma(_125, fp_c1_1._m0[0].x, 0.589999973773956298828125);
//   float _133 = fma(_123, fp_c1_1._m0[0].z, 0.02999999932944774627685546875);
//   float _135 = fma(_123, _129, fp_c1_1._m0[0].y);
//   float _137 = fma(_127, fp_c1_1._m0[0].x, 0.589999973773956298828125);
//   precise float _654 = 1.0 / _135;
//   float _139 = _654;
//   float _141 = fma(_125, _131, fp_c1_1._m0[0].y);
//   float _143 = fma(_125, fp_c1_1._m0[0].z, 0.02999999932944774627685546875);
//   precise float _665 = 1.0 / _141;
//   float _145 = _665;
//   precise float _668 = _123 * _133;
//   float _147 = _668;
//   float _149 = fma(_127, fp_c1_1._m0[0].z, 0.02999999932944774627685546875);
//   float _151 = fma(_127, _137, fp_c1_1._m0[0].y);
//   precise float _679 = 1.0 / _151;
//   float _153 = _679;
//   precise float _682 = _125 * _143;
//   float _155 = _682;
//   precise float _685 = _127 * _149;
//   float _157 = _685;
//   precise float _688 = _147 * _139;
//   float _159 = _688;
//   float _161 = clamp(_159, 0.0, 1.0);
//   precise float _693 = _155 * _145;
//   float _163 = _693;
//   float _165 = clamp(_163, 0.0, 1.0);
//   precise float _698 = _161 * 0.2989999949932098388671875;
//   float _167 = _698;
//   precise float _701 = _157 * _153;
//   float _169 = _701;
//   float _171 = clamp(_169, 0.0, 1.0);
//   float _173 = fma(_165, fp_c1_1._m0[0].w, _167);
//   float _175 = fma(_171, fp_c1_1._m0[1].x, _173);
//   precise float _718 = 0.5 * fp_c3_1._m0[7].z;
//   float _177 = _718;
//   float _179 = log2(_175);
//   float _181 = -_175;
//   precise float _725 = _161 + _181;
//   float _183 = _725;
//   float _185 = -_175;
//   precise float _730 = _165 + _185;
//   float _187 = _730;
//   float _189 = -_175;
//   precise float _735 = _171 + _189;
//   float _191 = _735;
//   precise float _739 = _175 * fp_c3_1._m0[2].x;
//   float _193 = _739;
//   float _195 = fma(_183, fp_c3_1._m0[0].z, _175);
//   float _197 = clamp(_195, 0.0, 1.0);
//   float _199 = fma(_187, fp_c3_1._m0[0].z, _175);
//   float _201 = clamp(_199, 0.0, 1.0);
//   float _203 = fma(_191, fp_c3_1._m0[0].z, _175);
//   float _205 = clamp(_203, 0.0, 1.0);
//   precise float _764 = _179 * fp_c3_1._m0[2].w;
//   float _207 = _764;
//   precise float _766 = 1.0 / _177;
//   float _209 = _766;
//   float _211 = -_177;
//   precise float _771 = _47 + _211;
//   float _213 = _771;
//   float _215 = -fp_c3_1._m0[2].x;
//   float _217 = fma(_175, _215, _197);
//   float _219 = -fp_c3_1._m0[2].y;
//   float _221 = fma(_175, _219, _201);
//   float _223 = -fp_c3_1._m0[2].z;
//   float _225 = fma(_175, _223, _205);
//   precise float _796 = _175 * fp_c3_1._m0[2].y;
//   float _227 = _796;
//   float _229 = exp2(_207);
//   float _231 = clamp(_229, 0.0, 1.0);
//   precise float _804 = _175 * fp_c3_1._m0[2].z;
//   float _233 = _804;
//   float _235 = -_177;
//   precise float _809 = _45 + _235;
//   float _237 = _809;
//   precise float _812 = _213 * _209;
//   float _239 = _812;
//   precise float _815 = _237 * _209;
//   float _241 = _815;
//   precise float _818 = _239 * _239;
//   float _243 = _818;
//   float _245 = fma(_217, _231, _193);
//   float _247 = fma(_221, _231, _227);
//   float _249 = floor(fp_c3_1._m0[8].x);
//   float _251 = fma(_225, _231, _233);
//   float _253 = fma(_241, _241, _243);
//   float _255 = sqrt(_253);
//   precise float _844 = _245 + fp_c3_1._m0[1].x;
//   float _257 = _844;
//   precise float _848 = _247 + fp_c3_1._m0[1].x;
//   float _259 = _848;
//   precise float _852 = _251 + fp_c3_1._m0[1].x;
//   float _261 = _852;
//   float _263 = -fp_c3_1._m0[7].x;
//   precise float _859 = _263 + fp_c3_1._m0[7].y;
//   float _265 = _859;
//   precise float _863 = fp_c3_1._m0[0].y * 0.454545438289642333984375;
//   float _267 = _863;
//   precise float _866 = _257 + (-1.5);
//   float _269 = _866;
//   precise float _868 = _259 + (-1.5);
//   float _271 = _868;
//   precise float _870 = _261 + (-1.5);
//   float _273 = _870;
//   float _275 = fma(_269, fp_c3_1._m0[0].w, 0.5);
//   float _277 = clamp(_275, 0.0, 1.0);
//   float _279 = fma(_271, fp_c3_1._m0[0].w, 0.5);
//   float _281 = clamp(_279, 0.0, 1.0);
//   float _283 = log2(_277);
//   float _285 = fma(_273, fp_c3_1._m0[0].w, 0.5);
//   float _287 = clamp(_285, 0.0, 1.0);
//   float _289 = log2(_281);
//   float _291 = fma(_265, _255, fp_c3_1._m0[7].x);
//   float _293 = log2(_287);
//   precise float _902 = _45 * 8000.0;
//   float _295 = _902;
//   precise float _905 = _267 * _283;
//   float _297 = _905;
//   precise float _907 = _47 * 8000.0;
//   float _299 = _907;
//   precise float _910 = _267 * _289;
//   float _301 = _910;
//   float _303 = roundEven(_295);
//   float _305 = -_249;
//   precise float _918 = _305 + fp_c3_1._m0[8].x;
//   float _307 = _918;
//   float _309 = roundEven(_299);
//   precise float _923 = _267 * _293;
//   float _311 = _923;
//   float _313 = -fp_c3_1._m0[6].y;
//   precise float _929 = _313 + 1.0;
//   float _315 = _929;
//   float _317 = clamp(_315, 0.0, 1.0);
//   precise float _933 = 1.0 / _317;
//   float _319 = _933;
//   float _321 = exp2(_297);
//   float _323 = exp2(_301);
//   precise float _942 = fp_c3_1._m0[4].y + 9.9999997473787516355514526367188e-05;
//   float _325 = _942;
//   float _327 = exp2(_311);
//   float _329 = fma(_309, fp_c1_1._m0[1].y, _307);
//   float _331 = fma(_303, fp_c1_1._m0[1].y, _307);
//   float _333 = -fp_c3_1._m0[6].x;
//   precise float _960 = _321 + _333;
//   float _335 = _960;
//   float _337 = fma(_331, fp_c1_1._m0[1].z, _329);
//   float _339 = -fp_c3_1._m0[6].x;
//   precise float _971 = _323 + _339;
//   float _341 = _971;
//   float _343 = -fp_c3_1._m0[6].x;
//   precise float _977 = _327 + _343;
//   float _345 = _977;
//   precise float _979 = 1.0 / _325;
//   float _347 = _979;
//   precise float _982 = _335 * _319;
//   float _349 = _982;
//   precise float _985 = _341 * _319;
//   float _351 = _985;
//   float _353 = -fp_c3_1._m0[7].w;
//   float _355 = fma(_349, _353, _349);
//   float _357 = -_291;
//   float _359 = fma(_349, _357, _349);
//   float _361 = -fp_c3_1._m0[7].w;
//   float _363 = fma(_351, _361, _351);
//   float _365 = -_291;
//   float _367 = fma(_351, _365, _351);
//   precise float _1017 = fp_c3_1._m0[8].x * fp_c3_1._m0[9].z;
//   float _369 = _1017;
//   precise float _1020 = _345 * _319;
//   float _371 = _1020;
//   float _373 = fma(_359, fp_c3_1._m0[7].w, _355);
//   float _375 = fma(_367, fp_c3_1._m0[7].w, _363);
//   precise float _1033 = 1.0 / fp_c3_1._m0[9].x;
//   float _377 = _1033;
//   precise float _1037 = _45 * fp_c3_1._m0[10].y;
//   float _379 = _1037;
//   float _381 = sin(_337);
//   float _383 = -_291;
//   float _385 = fma(_371, _383, _371);
//   float _387 = -fp_c3_1._m0[7].w;
//   float _389 = fma(_371, _387, _371);
//   precise float _1055 = _373 * _347;
//   float _391 = _1055;
//   precise float _1058 = _369 * 6.280000209808349609375;
//   float _393 = _1058;
//   precise float _1061 = _375 * _347;
//   float _395 = _1061;
//   float _397 = fma(_385, fp_c3_1._m0[7].w, _389);
//   precise float _1069 = _391 * 0.3300000131130218505859375;
//   float _399 = _1069;
//   precise float _1071 = _95 * 0.5;
//   float _401 = _1071;
//   float _403 = -_393;
//   float _405 = fma(_379, _377, _403);
//   float _407 = floor(_401);
//   precise float _1082 = _381 * 493013.0;
//   float _409 = _1082;
//   precise float _1085 = _397 * _347;
//   float _411 = _1085;
//   float _413 = fma(_395, fp_c1_1._m0[1].w, _399);
//   float _415 = floor(_409);
//   float _417 = sin(_405);
//   float _419 = fma(_411, fp_c1_1._m0[1].w, _413);
//   float _421 = clamp(_419, 0.0, 1.0);
//   float _423 = fma(_407, -2.0, _95);
//   float _425 = -_415;
//   precise float _1110 = _409 + _425;
//   float _427 = _1110;
//   float _429 = -fp_c3_1._m0[4].x;
//   float _431 = fma(_421, _429, fp_c3_1._m0[4].x);
//   precise float _1122 = _423 + fp_c3_1._m0[9].w;
//   float _433 = _1122;
//   float _435 = clamp(_433, 0.0, 1.0);
//   precise float _1128 = 1.0 / fp_c3_1._m0[5].x;
//   float _437 = _1128;
//   precise float _1132 = _417 * fp_c3_1._m0[9].y;
//   float _439 = _1132;
//   float _441 = -_427;
//   float _443 = fma(_431, _441, _373);
//   float _445 = clamp(_443, 0.0, 1.0);
//   float _447 = -_427;
//   float _449 = fma(_431, _447, _375);
//   float _451 = clamp(_449, 0.0, 1.0);
//   float _453 = -_427;
//   float _455 = fma(_431, _453, _397);
//   float _457 = clamp(_455, 0.0, 1.0);
//   float _459 = fma(_445, _435, _439);
//   float _461 = fma(_451, _435, _439);
//   float _463 = abs(_459);
//   float _465 = log2(_463);
//   float _467 = fma(_457, _435, _439);
//   float _469 = abs(_461);
//   float _471 = log2(_469);
//   precise float _1179 = _437 * 2.2000000476837158203125;
//   float _473 = _1179;
//   float _475 = abs(_467);
//   float _477 = log2(_475);
//   precise float _1186 = _473 * _465;
//   float _479 = _1186;
//   precise float _1189 = _473 * _471;
//   float _481 = _1189;
//   precise float _1192 = _473 * _477;
//   float _483 = _1192;
//   float _485 = exp2(_479);
//   float _487 = exp2(_481);
//   float _489 = exp2(_483);
//   _38.x = _485;
//   _38.y = _487;
//   _38.z = _489;
//   _38.w = 0.0;
// }

