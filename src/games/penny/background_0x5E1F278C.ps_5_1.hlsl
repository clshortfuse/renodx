#include "./common.hlsl"

cbuffer CB0_buf : register(b0, space0)
{
    uint2 CB0_m0 : packoffset(c0);
    float2 CB0_m1 : packoffset(c0.z);
    float4 CB0_m2 : packoffset(c1);
};

cbuffer CB1_buf : register(b2, space0)
{
    uint4 CB1_m0 : packoffset(c0);
    uint4 CB1_m1 : packoffset(c1);
    uint4 CB1_m2 : packoffset(c2);
    uint4 CB1_m3 : packoffset(c3);
    uint4 CB1_m4 : packoffset(c4);
    uint4 CB1_m5 : packoffset(c5);
    uint4 CB1_m6 : packoffset(c6);
    uint4 CB1_m7 : packoffset(c7);
    uint4 CB1_m8 : packoffset(c8);
    uint4 CB1_m9 : packoffset(c9);
    float4 CB1_m10 : packoffset(c10);
};

SamplerState S0[256] : register(s0, space0);
Texture2D<float4> T0[256] : register(t0, space0);

static float4 SV_Position0;
static float4 NOISE;
static float2 OFFSET;
static uint2 ID_VALUE;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float4 SV_Position : SV_Position;
    float4 NOISE : NOISE;
    float2 OFFSET : OFFSET;
    nointerpolation uint2 ID_VALUE : ID_VALUE;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target;
};

int cvt_f32_i32(float v)
{
    return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

float dp3_f32(float3 a, float3 b)
{
    precise float _105 = a.x * b.x;
    return mad(a.z, b.z, mad(a.y, b.y, _105));
}

float dp4_f32(float4 a, float4 b)
{
    precise float _88 = a.x * b.x;
    return mad(a.w, b.w, mad(a.z, b.z, mad(a.y, b.y, _88)));
}

float dp2_f32(float2 a, float2 b)
{
    precise float _76 = a.x * b.x;
    return mad(a.y, b.y, _76);
}

void frag_main()
{
    float _152 = CB1_m10.w / (T0[NonUniformResourceIndex(ID_VALUE.y)].Load(int3(uint2(uint(cvt_f32_i32(SV_Position0.x)), uint(cvt_f32_i32(SV_Position0.y))), 0u)).x - CB1_m10.z);
    float _163 = clamp((_152 - CB0_m2.x) * CB0_m2.w, 0.0f, 1.0f) * CB0_m2.z;
    float _171 = dp3_f32(float3(NOISE.x, NOISE.y, NOISE.z), 0.333333313465118408203125f.xxx);
    float _175 = floor(NOISE.z + _171);
    float _176 = floor(NOISE.y + _171);
    float _177 = floor(NOISE.x + _171);
    float _182 = dp3_f32(float3(_177, _176, _175), 0.16666670143604278564453125f.xxx);
    float _183 = (NOISE.x - _177) + _182;
    float _184 = _182 + (NOISE.y - _176);
    float _185 = _182 + (NOISE.z - _175);
    bool _189 = (_185 - _183) >= 0.0f;
    bool _190 = (_184 - _185) >= 0.0f;
    bool _191 = (_183 - _184) >= 0.0f;
    float _192 = _189 ? 0.0f : 1.0f;
    float _193 = _190 ? 0.0f : 1.0f;
    float _194 = _191 ? 0.0f : 1.0f;
    float _195 = float(_190);
    float _196 = float(_191);
    float _197 = float(_189);
    float3 _225 = float3(_183, _184, _185);
    float3 _227 = float3(mad(-_196, _192, _183) + 0.16666670143604278564453125f, mad(-_195, _194, _184) + 0.16666670143604278564453125f, mad(-_193, _197, _185) + 0.16666670143604278564453125f);
    float3 _229 = float3((_183 + mad(_197, _194, -1.0f)) + 0.3333334028720855712890625f, (_184 + mad(_193, _196, -1.0f)) + 0.3333334028720855712890625f, (_185 + mad(_195, _192, -1.0f)) + 0.3333334028720855712890625f);
    float3 _231 = float3(_183 - 0.49999988079071044921875f, _184 - 0.49999988079071044921875f, _185 - 0.49999988079071044921875f);
    float _237 = max(0.60000002384185791015625f - dp3_f32(_225, _225), 0.0f);
    float _238 = max(0.60000002384185791015625f - dp3_f32(_227, _227), 0.0f);
    float _239 = max(0.60000002384185791015625f - dp3_f32(_229, _229), 0.0f);
    float _240 = max(0.60000002384185791015625f - dp3_f32(_231, _231), 0.0f);
    float _244 = frac(_175 * 0.097300000488758087158203125f);
    float _245 = frac(_176 * 0.10300000011920928955078125f);
    float _246 = frac(_177 * 0.103100001811981201171875f);
    float _252 = dp3_f32(float3(_246, _245, _244), float3(_245 + 33.3300018310546875f, _246 + 33.3300018310546875f, _244 + 33.3300018310546875f));
    float _254 = _252 + _245;
    float _255 = _252 + _246;
    float _273 = frac(mad(_193, _197, _175) * 0.097300000488758087158203125f);
    float _274 = frac(mad(_195, _194, _176) * 0.10300000011920928955078125f);
    float _275 = frac(mad(_196, _192, _177) * 0.103100001811981201171875f);
    float _281 = dp3_f32(float3(_275, _274, _273), float3(_274 + 33.3300018310546875f, _275 + 33.3300018310546875f, _273 + 33.3300018310546875f));
    float _283 = _281 + _274;
    float _284 = _281 + _275;
    float _302 = frac((_175 + mad(-_195, _192, 1.0f)) * 0.097300000488758087158203125f);
    float _303 = frac((_176 + mad(-_193, _196, 1.0f)) * 0.10300000011920928955078125f);
    float _304 = frac((_177 + mad(-_197, _194, 1.0f)) * 0.103100001811981201171875f);
    float _310 = dp3_f32(float3(_304, _303, _302), float3(_303 + 33.3300018310546875f, _304 + 33.3300018310546875f, _302 + 33.3300018310546875f));
    float _312 = _310 + _303;
    float _313 = _310 + _304;
    float _331 = frac((_175 + 1.0f) * 0.097300000488758087158203125f);
    float _332 = frac((_176 + 1.0f) * 0.10300000011920928955078125f);
    float _333 = frac((_177 + 1.0f) * 0.103100001811981201171875f);
    float _339 = dp3_f32(float3(_333, _332, _331), float3(_332 + 33.3300018310546875f, _333 + 33.3300018310546875f, _331 + 33.3300018310546875f));
    float _341 = _339 + _332;
    float _342 = _339 + _333;
    float _354 = _237 * _237;
    float _355 = _238 * _238;
    float _356 = _239 * _239;
    float _357 = _240 * _240;
    float _367 = dp4_f32(float4(dp3_f32(float3(frac(mad(_244 + _252, _254, _255)) - 0.5f, frac(mad(_255, _254, _255)) - 0.5f, frac(mad(_255, _255, _254)) - 0.5f), _225) * (_354 * _354), dp3_f32(float3(frac(mad(_273 + _281, _283, _284)) - 0.5f, frac(mad(_284, _283, _284)) - 0.5f, frac(mad(_284, _284, _283)) - 0.5f), _227) * (_355 * _355), dp3_f32(float3(frac(mad(_302 + _310, _312, _313)) - 0.5f, frac(mad(_313, _312, _313)) - 0.5f, frac(mad(_313, _313, _312)) - 0.5f), _229) * (_356 * _356), dp3_f32(float3(frac(mad(_331 + _339, _341, _342)) - 0.5f, frac(mad(_342, _341, _342)) - 0.5f, frac(mad(_342, _342, _341)) - 0.5f), _231) * (_357 * _357)), 52.0f.xxxx);
    float _371 = dp3_f32(float3(NOISE.x, NOISE.y, NOISE.w), 0.333333313465118408203125f.xxx);
    float _375 = floor(NOISE.w + _371);
    float _376 = floor(NOISE.y + _371);
    float _377 = floor(NOISE.x + _371);
    float _382 = dp3_f32(float3(_377, _376, _375), 0.16666670143604278564453125f.xxx);
    float _383 = (NOISE.x - _377) + _382;
    float _384 = _382 + (NOISE.y - _376);
    float _385 = _382 + (NOISE.w - _375);
    bool _389 = (_385 - _383) >= 0.0f;
    bool _390 = (_384 - _385) >= 0.0f;
    bool _391 = (_383 - _384) >= 0.0f;
    float _392 = _389 ? 0.0f : 1.0f;
    float _393 = _390 ? 0.0f : 1.0f;
    float _394 = _391 ? 0.0f : 1.0f;
    float _395 = float(_390);
    float _396 = float(_391);
    float _397 = float(_389);
    float3 _425 = float3(_383, _384, _385);
    float3 _427 = float3(mad(-_396, _392, _383) + 0.16666670143604278564453125f, mad(-_395, _394, _384) + 0.16666670143604278564453125f, mad(-_397, _393, _385) + 0.16666670143604278564453125f);
    float3 _429 = float3((_383 + mad(_397, _394, -1.0f)) + 0.3333334028720855712890625f, (mad(_396, _393, -1.0f) + _384) + 0.3333334028720855712890625f, (mad(_395, _392, -1.0f) + _385) + 0.3333334028720855712890625f);
    float3 _431 = float3(_383 - 0.49999988079071044921875f, _384 - 0.49999988079071044921875f, _385 - 0.49999988079071044921875f);
    float _437 = max(0.60000002384185791015625f - dp3_f32(_425, _425), 0.0f);
    float _438 = max(0.60000002384185791015625f - dp3_f32(_427, _427), 0.0f);
    float _439 = max(0.60000002384185791015625f - dp3_f32(_429, _429), 0.0f);
    float _440 = max(0.60000002384185791015625f - dp3_f32(_431, _431), 0.0f);
    float _444 = frac(_375 * 0.097300000488758087158203125f);
    float _445 = frac(_376 * 0.10300000011920928955078125f);
    float _446 = frac(_377 * 0.103100001811981201171875f);
    float _452 = dp3_f32(float3(_446, _445, _444), float3(_445 + 33.3300018310546875f, _446 + 33.3300018310546875f, _444 + 33.3300018310546875f));
    float _454 = _452 + _445;
    float _455 = _452 + _446;
    float _473 = frac(mad(_397, _393, _375) * 0.097300000488758087158203125f);
    float _474 = frac(mad(_395, _394, _376) * 0.10300000011920928955078125f);
    float _475 = frac(mad(_396, _392, _377) * 0.103100001811981201171875f);
    float _481 = dp3_f32(float3(_475, _474, _473), float3(_474 + 33.3300018310546875f, _475 + 33.3300018310546875f, _473 + 33.3300018310546875f));
    float _483 = _474 + _481;
    float _484 = _475 + _481;
    float _502 = frac((_375 + mad(-_395, _392, 1.0f)) * 0.097300000488758087158203125f);
    float _503 = frac((mad(-_396, _393, 1.0f) + _376) * 0.10300000011920928955078125f);
    float _504 = frac((mad(-_397, _394, 1.0f) + _377) * 0.103100001811981201171875f);
    float _510 = dp3_f32(float3(_504, _503, _502), float3(_503 + 33.3300018310546875f, _504 + 33.3300018310546875f, _502 + 33.3300018310546875f));
    float _512 = _503 + _510;
    float _513 = _504 + _510;
    float _531 = frac((_375 + 1.0f) * 0.097300000488758087158203125f);
    float _532 = frac((_376 + 1.0f) * 0.10300000011920928955078125f);
    float _533 = frac((_377 + 1.0f) * 0.103100001811981201171875f);
    float _539 = dp3_f32(float3(_533, _532, _531), float3(_532 + 33.3300018310546875f, _533 + 33.3300018310546875f, _531 + 33.3300018310546875f));
    float _541 = _532 + _539;
    float _542 = _533 + _539;
    float _554 = _437 * _437;
    float _555 = _438 * _438;
    float _556 = _439 * _439;
    float _557 = _440 * _440;
    float _568 = mad(_163, _367, SV_Position0.x);
    float _569 = mad(_163, dp4_f32(float4(dp3_f32(float3(frac(mad(_444 + _452, _454, _455)) - 0.5f, frac(mad(_455, _454, _455)) - 0.5f, frac(mad(_455, _455, _454)) - 0.5f), _425) * (_554 * _554), (_555 * _555) * dp3_f32(float3(frac(mad(_483, _473 + _481, _484)) - 0.5f, frac(mad(_484, _483, _484)) - 0.5f, frac(mad(_484, _484, _483)) - 0.5f), _427), (_556 * _556) * dp3_f32(float3(frac(mad(_512, _502 + _510, _513)) - 0.5f, frac(mad(_513, _512, _513)) - 0.5f, frac(mad(_513, _513, _512)) - 0.5f), _429), (_557 * _557) * dp3_f32(float3(frac(mad(_541, _531 + _539, _542)) - 0.5f, frac(mad(_542, _541, _542)) - 0.5f, frac(mad(_542, _542, _541)) - 0.5f), _431)), 52.0f.xxxx), SV_Position0.y);
    bool _580 = (CB1_m10.w / (T0[NonUniformResourceIndex(ID_VALUE.y)].Load(int3(uint2(uint(cvt_f32_i32(_568)), uint(cvt_f32_i32(_569))), 0u)).x - CB1_m10.z)) < (_152 - 32.0f);
    float4 _600 = T0[NonUniformResourceIndex(ID_VALUE.x)].Sample(S0[NonUniformResourceIndex(ID_VALUE.x)], float2(CB0_m1.x * (_580 ? SV_Position0.x : _568), CB0_m1.y * (_580 ? SV_Position0.y : _569)));
    float _605 = (_367 - 0.5f) * 0.03125f;
    float2 _610 = float2(OFFSET.x, OFFSET.y);
    float _611 = dp2_f32(_610, _610);
    SV_Target.x = mad(_605, _611, _600.x);
    SV_Target.y = mad(_605, _611, _600.y);
    SV_Target.z = mad(_605, _611, _600.z);
    SV_Target.w = 1.0f;

    float4 preDof = T0[NonUniformResourceIndex(ID_VALUE.x)].Sample(S0[NonUniformResourceIndex(ID_VALUE.x)], float2(CB0_m1.x * SV_Position0.x, CB0_m1.y * SV_Position0.y));

    SV_Target.xyz = lerp(preDof.xyz, SV_Target.xyz, CUSTOM_DOF);
    SV_Target.xyz = CustomTonemap(SV_Target.xyz);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    SV_Position0 = stage_input.SV_Position;
    SV_Position0.w = 1.0 / SV_Position0.w;
    NOISE = stage_input.NOISE;
    OFFSET = stage_input.OFFSET;
    ID_VALUE = stage_input.ID_VALUE;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
