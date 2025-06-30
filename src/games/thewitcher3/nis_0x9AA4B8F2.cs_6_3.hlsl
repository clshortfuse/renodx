#include "./shared.h"

cbuffer _16_18 : register(b0, space0)
{
    float4 _18_m0[7] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);
RWTexture2D<float4> _11 : register(u0, space0);
SamplerState _21 : register(s0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

groupshared float _25[1444];

void comp_main()
{
    uint _42 = gl_WorkGroupID.x << 5u;
    uint _44 = gl_WorkGroupID.y << 5u;
    uint _45 = gl_LocalInvocationID.x << 1u;
    //_45 = 10;
    if (int(_45) < int(722u))
    {
        uint _53;
        _53 = _45;
        for (;;)
        {
            uint _55 = _53 % 38u;
            uint _58 = (_53 / 38u) << 1u;
            float _61 = float(_55 + _42) + (-1.5f);
            uint _69 = _58 + _44;
            float _71 = float(_69) + (-1.5f);
            float4 _77 = _8.SampleLevel(_21, float2(_61 * _18_m0[4u].x, _71 * _18_m0[4u].y), 0.0f);
            _25[_55 + (_58 * 38u)] = ((_77.x * 0.2125999927520751953125f) + (_77.y * 0.715200006961822509765625f)) + (_77.z * 0.072200000286102294921875f);
            float _98 = float((_42 | 1u) + _55) + (-1.5f);
            float4 _105 = _8.SampleLevel(_21, float2(_18_m0[4u].x * _98, _18_m0[4u].y * _71), 0.0f);
            uint _115 = _55 + 1u;
            _25[_115 + (_58 * 38u)] = ((_105.x * 0.2125999927520751953125f) + (_105.y * 0.715200006961822509765625f)) + (_105.z * 0.072200000286102294921875f);
            float _125 = float(_69 | 1u) + (-1.5f);
            float4 _128 = _8.SampleLevel(_21, float2(_18_m0[4u].x * _61, _18_m0[4u].y * _125), 0.0f);
            uint _138 = _58 | 1u;
            _25[_55 + (_138 * 38u)] = ((_128.x * 0.2125999927520751953125f) + (_128.y * 0.715200006961822509765625f)) + (_128.z * 0.072200000286102294921875f);
            float4 _148 = _8.SampleLevel(_21, float2(_18_m0[4u].x * _98, _18_m0[4u].y * _125), 0.0f);
            _25[_115 + (_138 * 38u)] = ((_148.x * 0.2125999927520751953125f) + (_148.y * 0.715200006961822509765625f)) + (_148.z * 0.072200000286102294921875f);
            uint _54 = _53 + 256u;
            if (int(_54) < int(722u))
            {
                _53 = _54;
            }
            else
            {
                break;
            }
        }
    }
    GroupMemoryBarrierWithGroupSync();
    if (int(gl_LocalInvocationID.x) < int(1024u))
    {
        float _404;
        float _406;
        float _408;
        float _410;
        uint _163 = gl_LocalInvocationID.x;
        uint _165;
        uint _167;
        float _261;
        float4 _278;
        float _284;
        float _285;
        float _292;
        float _310;
        float _324;
        float _342;
        float _355;
        float _373;
        float _379;
        float _384;
        float _398;
        float _399;
        float _400;
        float _401;
        float _402;
        bool _403;
        for (;;)
        {
            _165 = _163 & 31u;
            _167 = _163 >> 5u;
            uint _168 = _165 + 2u;
            uint _170 = _168 + (_167 * 38u);
            uint _173 = _165 + 1u;
            uint _174 = _167 + 1u;
            uint _176 = _173 + (_174 * 38u);
            uint _180 = _168 + (_174 * 38u);
            uint _183 = _165 + 3u;
            uint _186 = _183 + (_174 * 38u);
            uint _189 = _167 + 2u;
            uint _191 = _165 + (_189 * 38u);
            uint _195 = _173 + (_189 * 38u);
            uint _199 = _168 + (_189 * 38u);
            uint _203 = _183 + (_189 * 38u);
            uint _208 = (_165 + 4u) + (_189 * 38u);
            uint _211 = _167 + 3u;
            uint _213 = _173 + (_211 * 38u);
            uint _217 = _168 + (_211 * 38u);
            uint _221 = _183 + (_211 * 38u);
            uint _226 = _168 + ((_167 + 4u) * 38u);
            float _238 = 1.0f - clamp((_25[_199] - _18_m0[1u].z) * _18_m0[1u].w, 0.0f, 1.0f);

            float _244 = (_18_m0[2u].y * _238) + _18_m0[2u].x;

            if (CUSTOM_SHARPENING_TYPE == 0) {
            _244 *= CUSTOM_SHARPNESS;
            }

            float _249 = ((_18_m0[2u].w * _238) + _18_m0[2u].z) * _25[_199];
            float _252 = _25[_199] * 1.20019996166229248046875f;
            float _258 = (-0.0f) - _249;
            _261 = min(_249, max(_258, _244 * ((_252 - (_25[_180] * 0.600099980831146240234375f)) - (_25[_217] * 0.600099980831146240234375f))));
            float _270 = max(max(_25[_170], _25[_180]), _25[_199]) - min(min(_25[_170], _25[_180]), _25[_199]);
            float _271 = max(max(_25[_199], _25[_217]), _25[_226]) - min(min(_25[_199], _25[_217]), _25[_226]);
            _278 = _18_m0[0u];
            _284 = 1.0f - clamp(((max(_270, _271) / (_18_m0[1u].y + min(_270, _271))) - _278.z) * _278.w, 0.0f, 1.0f);
            _285 = _18_m0[1u].x;
            _292 = min(_249, max(_258, _244 * ((_252 - (_25[_195] * 0.600099980831146240234375f)) - (_25[_203] * 0.600099980831146240234375f))));
            float _301 = max(max(_25[_191], _25[_195]), _25[_199]) - min(min(_25[_191], _25[_195]), _25[_199]);
            float _302 = max(max(_25[_199], _25[_203]), _25[_208]) - min(min(_25[_199], _25[_203]), _25[_208]);
            _310 = 1.0f - clamp(((max(_301, _302) / (_18_m0[1u].y + min(_301, _302))) - _278.z) * _278.w, 0.0f, 1.0f);
            float _314 = ((_25[_180] - _25[_195]) * 0.5f) + _25[_195];
            float _317 = ((_25[_203] - _25[_217]) * 0.5f) + _25[_217];
            _324 = min(_249, max(_258, _244 * ((_252 - (_314 * 0.600099980831146240234375f)) - (_317 * 0.600099980831146240234375f))));
            float _333 = max(max(_25[_176], _314), _25[_199]) - min(min(_25[_176], _314), _25[_199]);
            float _334 = max(max(_25[_199], _317), _25[_221]) - min(min(_25[_199], _317), _25[_221]);
            _342 = 1.0f - clamp(((max(_333, _334) / (_18_m0[1u].y + min(_333, _334))) - _278.z) * _278.w, 0.0f, 1.0f);
            float _345 = ((_25[_195] - _25[_217]) * 0.5f) + _25[_217];
            float _348 = ((_25[_180] - _25[_203]) * 0.5f) + _25[_203];
            _355 = min(_249, max(_258, _244 * ((_252 - (_348 * 0.600099980831146240234375f)) - (_345 * 0.600099980831146240234375f))));
            float _364 = max(max(_25[_213], _345), _25[_199]) - min(min(_25[_213], _345), _25[_199]);
            float _365 = max(max(_25[_199], _348), _25[_186]) - min(min(_25[_199], _348), _25[_186]);
            _373 = 1.0f - clamp(((max(_364, _365) / (_18_m0[1u].y + min(_364, _365))) - _278.z) * _278.w, 0.0f, 1.0f);
            float _374 = _25[_180] + _25[_176];
            _379 = abs((((_374 + _25[_186]) - _25[_213]) - _25[_217]) - _25[_221]);
            _384 = abs((((_374 + _25[_195]) - _25[_203]) - _25[_217]) - _25[_221]);
            float _390 = abs(((((_25[_176] - _25[_186]) + _25[_195]) - _25[_203]) + _25[_213]) - _25[_221]);
            float _397 = abs(((((((-0.0f) - _25[_180]) - _25[_186]) + _25[_195]) - _25[_203]) + _25[_213]) + _25[_217]);
            _398 = max(_379, _390);
            _399 = min(_379, _390);
            _400 = max(_384, _397);
            _401 = min(_384, _397);
            _402 = _400 + _398;
            _403 = _402 == 0.0f;
            float frontier_phi_8_pred;
            float frontier_phi_8_pred_1;
            float frontier_phi_8_pred_2;
            float frontier_phi_8_pred_3;
            if (_403)
            {
                frontier_phi_8_pred = 0.0f;
                frontier_phi_8_pred_1 = 0.0f;
                frontier_phi_8_pred_2 = 0.0f;
                frontier_phi_8_pred_3 = 0.0f;
            }
            else
            {
                float _457 = min(_398 / _402, 1.0f);
                bool _466 = (_398 > _401) && ((_398 > (_278.x * _399)) && (_398 > _278.y));
                bool _472 = (_400 > _399) && ((_400 > (_278.x * _401)) && (_400 > _278.y));
                bool _473 = _398 == _379;
                bool _474 = _400 == _384;
                bool _475 = _466 && _472;
                float _476 = _475 ? _457 : 1.0f;
                float _477 = _475 ? (1.0f - _457) : 1.0f;
                frontier_phi_8_pred = (_473 && _466) ? _476 : 0.0f;
                frontier_phi_8_pred_1 = (_466 && (!_473)) ? _476 : 0.0f;
                frontier_phi_8_pred_2 = (_474 && _472) ? _477 : 0.0f;
                frontier_phi_8_pred_3 = (_472 && (!_474)) ? _477 : 0.0f;
            }
            _404 = frontier_phi_8_pred;
            _406 = frontier_phi_8_pred_1;
            _408 = frontier_phi_8_pred_2;
            _410 = frontier_phi_8_pred_3;
            float _426 = (((((_310 * _292) * _285) * _406) + (((_284 * _261) * _285) * _404)) + (((_342 * _324) * _285) * _408)) + (((_373 * _355) * _285) * _410);
            float _429 = float(int(_165 | _42));
            float _435 = float(int(_167 + _44));
            float4 _440 = _8.SampleLevel(_21, float2(_18_m0[4u].x * (_429 + 0.5f), _18_m0[4u].y * (_435 + 0.5f)), 0.0f);
            _11[uint2(uint(_429), uint(_435))] = float4(_440.x + _426, _440.y + _426, _440.z + _426, _440.w);

            if (CUSTOM_SHARPENING_TYPE != 0) {
              _11[uint2(uint(_429), uint(_435))] = _440;  // disable NIS
            }
                
            uint _164 = _163 + 128u;
            if (int(_164) < int(1024u))
            {
                _163 = _164;
                continue;
            }
            else
            {
                break;
            }
        }
    }
    //_11[uint2(uint(_429), uint(_435))] = _8.SampleLevel(_21, float2(_18_m0[4u].x * (_429 + 0.5f), _18_m0[4u].y * (_435 + 0.5f)), 0.0f);
}

[numthreads(128, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
    //_11[uint2(uint(gl_WorkGroupID.x), uint(gl_WorkGroupID.y))] = _8.SampleLevel(_21, float2(_18_m0[4u].x * (float(int(gl_WorkGroupID.x) + 0.5f)), _18_m0[4u].y * (float(int(gl_WorkGroupID.y) + 0.5f))), 0.0f);
    comp_main();
}
