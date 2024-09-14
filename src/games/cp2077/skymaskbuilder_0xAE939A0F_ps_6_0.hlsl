static float _301;
static uint _315;

cbuffer _27_29 : register(b1, space0)
{
    float4 _29_m0[53] : packoffset(c0);
};

cbuffer _32_34 : register(b12, space0)
{
    float4 _34_m0[99] : packoffset(c0);
};

cbuffer _37_39 : register(b6, space0)
{
    float4 _39_m0[15] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);
Texture2D<float4> _9 : register(t2, space0);
Texture3D<uint4> _13 : register(t5, space0);
Texture3D<uint4> _14 : register(t6, space0);
Texture2D<uint4> _17 : register(t7, space0);
Buffer<uint4> _20 : register(t9, space0);
Buffer<uint4> _21 : register(t10, space0);
Buffer<uint4> _22 : register(t11, space0);
Buffer<uint4> _23 : register(t12, space0);

static float4 gl_FragCoord;
static float3 SV_Target;

struct SPIRV_Cross_Input
{
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float3 SV_Target : SV_Target0;
};

uint spvPackHalf2x16(float2 value)
{
    uint2 Packed = f32tof16(value);
    return Packed.x | (Packed.y << 16);
}

float2 spvUnpackHalf2x16(uint value)
{
    return f16tof32(uint2(value & 0xffff, value >> 16));
}

void frag_main()
{
    uint _66 = uint(gl_FragCoord.y);
    uint _77 = ((asuint(_39_m0[12u]).w ^ _66) & 1u) | (uint(gl_FragCoord.x) << 1u);
    float4 _78 = _8.Load(int3(uint2(_77, _66), 0u));
    float _81 = _78.x;
    float _274;
    float _276;
    float _278;
    if (_81 > 0.0f)
    {
        float _85 = float(_77);
        float _86 = float(_66);
        float _131 = mad(_34_m0[71u].w, _81, mad(_34_m0[70u].w, _86, _34_m0[69u].w * _85)) + _34_m0[72u].w;
        float _132 = (mad(_34_m0[71u].x, _81, mad(_34_m0[70u].x, _86, _34_m0[69u].x * _85)) + _34_m0[72u].x) / _131;
        float _133 = (mad(_34_m0[71u].y, _81, mad(_34_m0[70u].y, _86, _34_m0[69u].y * _85)) + _34_m0[72u].y) / _131;
        float _134 = (mad(_34_m0[71u].z, _81, mad(_34_m0[70u].z, _86, _34_m0[69u].z * _85)) + _34_m0[72u].z) / _131;
        float4 _135 = _9.Load(int3(uint2(_77, _66), 0u));
        float _140 = _135.x + (-0.5f);
        float _142 = _135.y + (-0.5f);
        float _143 = _135.z + (-0.5f);
        float _147 = rsqrt(dot(float3(_140, _142, _143), float3(_140, _142, _143)));
        float _148 = _140 * _147;
        float _149 = _142 * _147;
        float _150 = _143 * _147;
        uint4 _157 = asuint(_39_m0[8u]);
        uint _159 = _157.x;
        uint _187 = min((_17.Load(int3(uint2(_77, _66), 0u)).x >> 1u), 3u);
        float _189 = _39_m0[0u].x * _132;
        float _190 = _39_m0[0u].y * _133;
        float _191 = _39_m0[0u].z * _134;
        float _199 = float(asuint(_39_m0[11u]).w);
        uint _203 = uint(int(clamp(_189 + _39_m0[1u].x, 0.0f, 1.0f) * _199));
        uint _204 = uint(int(clamp(_190 + _39_m0[1u].y, 0.0f, 1.0f) * _199));
        uint _205 = uint(int(clamp(_191 + _39_m0[1u].z, 0.0f, 1.0f) * _199));
        uint4 _206 = _13.Load(int4(uint3(_203, _204, _205), 0u));
        uint _64[2];
        _64[0u] = _206.x;
        _64[1u] = _206.y;
        uint4 _214 = _14.Load(int4(uint3(_203, _204, _205), 0u));
        uint _216 = _214.x;
        uint _219 = _187 >> 1u;
        uint _226 = ((_187 & 1u) == 0u) ? (_64[_219] & 65535u) : uint(int(_64[_219]) >> int(16u));
        float _259 = _132 - _29_m0[36u].x;
        float _260 = _133 - _29_m0[36u].y;
        float _261 = _134 - _29_m0[36u].z;
        float _287;
        float _290;
        float _293;
        if (((_216 < 65535u) && (_226 < 65535u)) && (min(max(clamp(min(min(clamp((0.5f - abs((_39_m0[1u].x + (-0.5f)) + _189)) * _34_m0[46u].y, 0.0f, 1.0f), clamp((0.5f - abs((_39_m0[1u].y + (-0.5f)) + _190)) * _34_m0[46u].y, 0.0f, 1.0f)), clamp((0.5f - abs((_39_m0[1u].z + (-0.5f)) + _191)) * _34_m0[46u].y, 0.0f, 1.0f)), 0.0f, 1.0f), 64.0f - dot(float3(_259, _260, _261), float3(_259, _260, _261))), 1.0f) > 0.0f))
        {
            uint4 _284 = _23.Load(_216);
            uint _285 = _284.x;
            float _299;
            float _302;
            float _304;
            float _306;
            bool _308;
            uint _311;
            uint _313;
            if (int(_159) > int(0u))
            {
                uint _298 = _285 + _226;
                uint _312;
                uint _314;
                uint _314_copy;
                uint _317;
                uint frontier_phi_6_13_ladder;
                uint frontier_phi_6_13_ladder_1;
                bool frontier_phi_6_13_ladder_2;
                float frontier_phi_6_13_ladder_3;
                float frontier_phi_6_13_ladder_4;
                float frontier_phi_6_13_ladder_5;
                float frontier_phi_6_13_ladder_6;
                for (;;)
                {
                    _314 = _298;
                    _317 = 0u;
                    _312 = 0u;
                    uint _316;
                    bool ladder_phi_22;
                    uint frontier_phi_22_pred;
                    uint frontier_phi_22_pred_1;
                    bool frontier_phi_22_pred_2;
                    float frontier_phi_22_pred_3;
                    float frontier_phi_22_pred_4;
                    float frontier_phi_22_pred_5;
                    float frontier_phi_22_pred_6;
                    uint4 _341;
                    uint _342;
                    uint _343;
                    float _412;
                    float _415;
                    float _418;
                    float _421;
                    bool _426;
                    for (;;)
                    {
                        uint _319 = _314 * 16u;
                        uint2 _325 = uint2(_20.Load(_319).x, _20.Load(_319 + 1u).x);
                        uint _326 = _325.x;
                        uint _329 = (_314 * 16u) + 12u;
                        _341 = uint4(_20.Load(_329).x, _20.Load(_329 + 1u).x, _20.Load(_329 + 2u).x, _20.Load(_329 + 3u).x);
                        _342 = _341.z;
                        _343 = _341.w;
                        float _407 = _132 - ((float(_326 & 65535u) + (-32767.0f)) * 0.25f);
                        float _408 = _133 - ((float(_326 >> 16u) + (-32767.0f)) * 0.25f);
                        float _409 = _134 - ((float(_325.y & 65535u) + (-32767.0f)) * 0.25f);
                        _412 = mad(_409, asfloat(_20.Load((_314 * 16u) + 8u).x), mad(_408, asfloat(_20.Load((_314 * 16u) + 5u).x), _407 * asfloat(_20.Load((_314 * 16u) + 2u).x)));
                        _415 = mad(_409, asfloat(_20.Load((_314 * 16u) + 9u).x), mad(_408, asfloat(_20.Load((_314 * 16u) + 6u).x), _407 * asfloat(_20.Load((_314 * 16u) + 3u).x)));
                        _418 = mad(_409, asfloat(_20.Load((_314 * 16u) + 10u).x), mad(_408, asfloat(_20.Load((_314 * 16u) + 7u).x), _407 * asfloat(_20.Load((_314 * 16u) + 4u).x)));
                        _421 = ((1.0f - _412) - _415) - _418;
                        _426 = ((_412 < _415) && (_412 < _418)) && (_412 < _421);
                        uint _464;
                        if (_426)
                        {
                            _464 = _341.x;
                        }
                        else
                        {
                            uint frontier_phi_13_10_ladder;
                            if ((_415 < _418) && (_415 < _421))
                            {
                                frontier_phi_13_10_ladder = _341.y;
                            }
                            else
                            {
                                uint frontier_phi_13_10_ladder_14_ladder;
                                if (_418 < _421)
                                {
                                    frontier_phi_13_10_ladder_14_ladder = _342;
                                }
                                else
                                {
                                    frontier_phi_13_10_ladder_14_ladder = _343;
                                }
                                frontier_phi_13_10_ladder = frontier_phi_13_10_ladder_14_ladder;
                            }
                            _464 = frontier_phi_13_10_ladder;
                        }
                        _316 = _464 + _285;
                        if (((((_412 >= 0.0f) && (_415 >= 0.0f)) && (_418 >= 0.0f)) && (_421 >= 0.0f)) || (_316 == _317))
                        {
                            float _576 = max(_412, 0.0f);
                            float _577 = max(_415, 0.0f);
                            float _578 = max(_418, 0.0f);
                            float _579 = max(_421, 0.0f);
                            float _580 = dot(float4(_576, _577, _578, _579), 1.0f.xxxx);
                            ladder_phi_22 = true;
                            frontier_phi_22_pred = _314;
                            frontier_phi_22_pred_1 = _312;
                            frontier_phi_22_pred_2 = true;
                            frontier_phi_22_pred_3 = _576 / _580;
                            frontier_phi_22_pred_4 = _577 / _580;
                            frontier_phi_22_pred_5 = _578 / _580;
                            frontier_phi_22_pred_6 = _579 / _580;
                            break;
                        }
                        else
                        {
                            uint _318 = _312 + 1u;
                            if (int(_318) < int(_159))
                            {
                                _314_copy = _314;
                                _314 = _316;
                                _317 = _314_copy;
                                _312 = _318;
                                continue;
                            }
                            else
                            {
                                ladder_phi_22 = false;
                                frontier_phi_22_pred = _315;
                                frontier_phi_22_pred_1 = _159;
                                frontier_phi_22_pred_2 = false;
                                frontier_phi_22_pred_3 = _301;
                                frontier_phi_22_pred_4 = _301;
                                frontier_phi_22_pred_5 = _301;
                                frontier_phi_22_pred_6 = _301;
                                break;
                            }
                        }
                    }
                    if (ladder_phi_22)
                    {
                        frontier_phi_6_13_ladder = frontier_phi_22_pred;
                        frontier_phi_6_13_ladder_1 = frontier_phi_22_pred_1;
                        frontier_phi_6_13_ladder_2 = frontier_phi_22_pred_2;
                        frontier_phi_6_13_ladder_3 = frontier_phi_22_pred_3;
                        frontier_phi_6_13_ladder_4 = frontier_phi_22_pred_4;
                        frontier_phi_6_13_ladder_5 = frontier_phi_22_pred_5;
                        frontier_phi_6_13_ladder_6 = frontier_phi_22_pred_6;
                        break;
                    }
                    frontier_phi_6_13_ladder = _315;
                    frontier_phi_6_13_ladder_1 = _159;
                    frontier_phi_6_13_ladder_2 = false;
                    frontier_phi_6_13_ladder_3 = _301;
                    frontier_phi_6_13_ladder_4 = _301;
                    frontier_phi_6_13_ladder_5 = _301;
                    frontier_phi_6_13_ladder_6 = _301;
                    break;
                }
                _299 = frontier_phi_6_13_ladder_6;
                _302 = frontier_phi_6_13_ladder_5;
                _304 = frontier_phi_6_13_ladder_4;
                _306 = frontier_phi_6_13_ladder_3;
                _308 = frontier_phi_6_13_ladder_2;
                _311 = frontier_phi_6_13_ladder_1;
                _313 = frontier_phi_6_13_ladder;
            }
            else
            {
                _299 = _301;
                _302 = _301;
                _304 = _301;
                _306 = _301;
                _308 = false;
                _311 = _159;
                _313 = _315;
            }
            float frontier_phi_4_6_ladder;
            float frontier_phi_4_6_ladder_1;
            float frontier_phi_4_6_ladder_2;
            if (_308)
            {
                float frontier_phi_4_6_ladder_8_ladder;
                float frontier_phi_4_6_ladder_8_ladder_1;
                float frontier_phi_4_6_ladder_8_ladder_2;
                if (_157.y == 0u)
                {
                    uint _435 = (_313 * 20u) + 16u;
                    uint2 _441 = uint2(_22.Load(_435).x, _22.Load(_435 + 1u).x);
                    uint _442 = _441.x;
                    uint _443 = _441.y;
                    uint _448 = _216 << 13u;
                    uint _450 = (_442 & 65535u) + _448;
                    uint _451 = (_442 >> 16u) + _448;
                    uint _452 = (_443 & 65535u) + _448;
                    uint _453 = (_443 >> 16u) + _448;
                    bool _454 = int(_313) > int(4294967295u);
                    float _564;
                    float _565;
                    float _566;
                    float _567;
                    float _568;
                    float _569;
                    float _570;
                    float _571;
                    float _572;
                    float _573;
                    float _574;
                    float _575;
                    if (_454)
                    {
                        uint _477 = (_450 * 14u) + 12u;
                        uint2 _483 = uint2(_21.Load(_477).x, _21.Load(_477 + 1u).x);
                        uint _484 = _483.x;
                        uint _499 = (_451 * 14u) + 12u;
                        uint2 _505 = uint2(_21.Load(_499).x, _21.Load(_499 + 1u).x);
                        uint _506 = _505.x;
                        uint _521 = (_452 * 14u) + 12u;
                        uint2 _527 = uint2(_21.Load(_521).x, _21.Load(_521 + 1u).x);
                        uint _528 = _527.x;
                        uint _543 = (_453 * 14u) + 12u;
                        uint2 _549 = uint2(_21.Load(_543).x, _21.Load(_543 + 1u).x);
                        uint _550 = _549.x;
                        _564 = (float(_484 & 65535u) + (-32767.0f)) * 0.25f;
                        _565 = (float(_484 >> 16u) + (-32767.0f)) * 0.25f;
                        _566 = (float(_483.y & 65535u) + (-32767.0f)) * 0.25f;
                        _567 = (float(_506 & 65535u) + (-32767.0f)) * 0.25f;
                        _568 = (float(_506 >> 16u) + (-32767.0f)) * 0.25f;
                        _569 = (float(_505.y & 65535u) + (-32767.0f)) * 0.25f;
                        _570 = (float(_528 & 65535u) + (-32767.0f)) * 0.25f;
                        _571 = (float(_528 >> 16u) + (-32767.0f)) * 0.25f;
                        _572 = (float(_527.y & 65535u) + (-32767.0f)) * 0.25f;
                        _573 = (float(_550 & 65535u) + (-32767.0f)) * 0.25f;
                        _574 = (float(_550 >> 16u) + (-32767.0f)) * 0.25f;
                        _575 = (float(_549.y & 65535u) + (-32767.0f)) * 0.25f;
                    }
                    else
                    {
                        _564 = _301;
                        _565 = _301;
                        _566 = _301;
                        _567 = _301;
                        _568 = _301;
                        _569 = _301;
                        _570 = _301;
                        _571 = _301;
                        _572 = _301;
                        _573 = _301;
                        _574 = _301;
                        _575 = _301;
                    }
                    float _603;
                    float _605;
                    float _607;
                    float _609;
                    if (_454)
                    {
                        uint _584 = _313 * 20u;
                        uint4 _596 = uint4(_22.Load(_584).x, _22.Load(_584 + 1u).x, _22.Load(_584 + 2u).x, _22.Load(_584 + 3u).x);
                        uint _597 = _596.x;
                        uint _598 = _596.y;
                        uint _599 = _596.z;
                        uint _600 = _596.w;
                        float _604;
                        if (_600 > 16777215u)
                        {
                            _604 = 100.0f;
                        }
                        else
                        {
                            float _1353 = _573 - _567;
                            float _1354 = _574 - _568;
                            float _1355 = _575 - _569;
                            float _1356 = _570 - _567;
                            float _1357 = _571 - _568;
                            float _1358 = _572 - _569;
                            float _1361 = (_1355 * _1357) - (_1354 * _1358);
                            float _1364 = (_1353 * _1358) - (_1355 * _1356);
                            float _1367 = (_1354 * _1356) - (_1353 * _1357);
                            float _1368 = _132 - _564;
                            float _1369 = _133 - _565;
                            float _1370 = _134 - _566;
                            float _1380 = dot(float3(_1361, _1364, _1367), float3(_567 - _564, _568 - _565, _569 - _566)) / dot(float3(_1361, _1364, _1367), float3(_1368, _1369, _1370));
                            float _1384 = (_1380 * _1368) + _564;
                            float _1385 = (_1380 * _1369) + _565;
                            float _1386 = (_1380 * _1370) + _566;
                            float _1387 = _567 - _573;
                            float _1388 = _568 - _574;
                            float _1389 = _569 - _575;
                            float _1390 = _1384 - _573;
                            float _1391 = _1385 - _574;
                            float _1392 = _1386 - _575;
                            float _1395 = (_1392 * _1388) - (_1391 * _1389);
                            float _1398 = (_1390 * _1389) - (_1392 * _1387);
                            float _1401 = (_1391 * _1387) - (_1390 * _1388);
                            float _1405 = _1384 - _567;
                            float _1406 = _1385 - _568;
                            float _1407 = _1386 - _569;
                            float _1410 = (_1407 * _1357) - (_1406 * _1358);
                            float _1413 = (_1405 * _1358) - (_1407 * _1356);
                            float _1416 = (_1406 * _1356) - (_1405 * _1357);
                            float _1420 = dot(float3(_1361, _1364, _1367), float3(_1361, _1364, _1367));
                            float _1425 = sqrt(dot(float3(_1395, _1398, _1401), float3(_1395, _1398, _1401)) / _1420);
                            float _1426 = sqrt(dot(float3(_1410, _1413, _1416), float3(_1410, _1413, _1416)) / _1420);
                            float _1428 = floor(_1426 * 4.0f);
                            float _1430 = floor(_1425 * 4.0f);
                            uint _1437 = uint(int((_1430 + 0.5f) + ((_1428 * 0.5f) * (11.0f - _1428))));
                            uint _1442 = _1437 + 1u;
                            uint _1443 = _1437 + (5u - uint(int(_1428)));
                            bool _1448 = ((((_1426 + _1425) - (_1428 * 0.25f)) - (_1430 * 0.25f)) * 4.0f) > 1.0f;
                            uint _1450 = _1448 ? _1443 : _1442;
                            uint _1451 = _1448 ? _1442 : _1443;
                            uint _1452 = _1448 ? (_1443 + 1u) : _1437;
                            uint _1574;
                            uint _1576;
                            if (_1450 == 0u)
                            {
                                _1574 = 4u;
                                _1576 = 0u;
                            }
                            else
                            {
                                uint frontier_phi_27_28_ladder;
                                uint frontier_phi_27_28_ladder_1;
                                if (_1450 == 14u)
                                {
                                    frontier_phi_27_28_ladder = 4u;
                                    frontier_phi_27_28_ladder_1 = 0u;
                                }
                                else
                                {
                                    uint _1779 = (_1450 << 1u) & 30u;
                                    frontier_phi_27_28_ladder = (262755328u >> _1779) & 3u;
                                    frontier_phi_27_28_ladder_1 = (18377836u >> _1779) & 3u;
                                }
                                _1574 = frontier_phi_27_28_ladder_1;
                                _1576 = frontier_phi_27_28_ladder;
                            }
                            float _1578 = float(_1574);
                            float _1579 = float(_1576);
                            float _1581 = (4.0f - _1578) - _1579;
                            uint _1750;
                            uint _1752;
                            if (_1451 == 0u)
                            {
                                _1750 = 4u;
                                _1752 = 0u;
                            }
                            else
                            {
                                uint frontier_phi_33_34_ladder;
                                uint frontier_phi_33_34_ladder_1;
                                if (_1451 == 14u)
                                {
                                    frontier_phi_33_34_ladder = 4u;
                                    frontier_phi_33_34_ladder_1 = 0u;
                                }
                                else
                                {
                                    uint _2090 = (_1451 << 1u) & 30u;
                                    frontier_phi_33_34_ladder = (262755328u >> _2090) & 3u;
                                    frontier_phi_33_34_ladder_1 = (18377836u >> _2090) & 3u;
                                }
                                _1750 = frontier_phi_33_34_ladder_1;
                                _1752 = frontier_phi_33_34_ladder;
                            }
                            float _1754 = float(_1750);
                            float _1755 = float(_1752);
                            float _1757 = (4.0f - _1754) - _1755;
                            uint _1941;
                            uint _1943;
                            if (_1452 == 0u)
                            {
                                _1941 = 4u;
                                _1943 = 0u;
                            }
                            else
                            {
                                uint frontier_phi_42_43_ladder;
                                uint frontier_phi_42_43_ladder_1;
                                if (_1452 == 14u)
                                {
                                    frontier_phi_42_43_ladder = 4u;
                                    frontier_phi_42_43_ladder_1 = 0u;
                                }
                                else
                                {
                                    uint _2301 = (_1452 << 1u) & 30u;
                                    frontier_phi_42_43_ladder = (262755328u >> _2301) & 3u;
                                    frontier_phi_42_43_ladder_1 = (18377836u >> _2301) & 3u;
                                }
                                _1941 = frontier_phi_42_43_ladder_1;
                                _1943 = frontier_phi_42_43_ladder;
                            }
                            float _1945 = float(_1941);
                            float _1946 = float(_1943);
                            float _1948 = (4.0f - _1945) - _1946;
                            float _1980 = float((((_1450 > 11u) ? _600 : ((_1450 > 7u) ? _599 : ((_1450 > 3u) ? _598 : _597))) >> ((_1450 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _1993 = float((((_1451 > 11u) ? _600 : ((_1451 > 7u) ? _599 : ((_1451 > 3u) ? _598 : _597))) >> ((_1451 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2005 = float((((_1452 > 11u) ? _600 : ((_1452 > 7u) ? _599 : ((_1452 > 3u) ? _598 : _597))) >> ((_1452 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2009 = (((((_1579 * _573) + (_1578 * _567)) + (_1581 * _570)) * 0.25f) - _564) * _1980;
                            float _2010 = (((((_1579 * _574) + (_1578 * _568)) + (_1581 * _571)) * 0.25f) - _565) * _1980;
                            float _2011 = (((((_1579 * _575) + (_1578 * _569)) + (_1581 * _572)) * 0.25f) - _566) * _1980;
                            float _2024 = ((((((_1946 * _573) + (_1945 * _567)) + (_1948 * _570)) * 0.25f) - _564) * _2005) - _2009;
                            float _2025 = ((((((_1946 * _574) + (_1945 * _568)) + (_1948 * _571)) * 0.25f) - _565) * _2005) - _2010;
                            float _2026 = ((((((_1946 * _575) + (_1945 * _569)) + (_1948 * _572)) * 0.25f) - _566) * _2005) - _2011;
                            float _2027 = ((((((_1755 * _573) + (_1754 * _567)) + (_1757 * _570)) * 0.25f) - _564) * _1993) - _2009;
                            float _2028 = ((((((_1755 * _574) + (_1754 * _568)) + (_1757 * _571)) * 0.25f) - _565) * _1993) - _2010;
                            float _2029 = ((((((_1755 * _575) + (_1754 * _569)) + (_1757 * _572)) * 0.25f) - _566) * _1993) - _2011;
                            float _2032 = (_2026 * _2028) - (_2025 * _2029);
                            float _2035 = (_2024 * _2029) - (_2026 * _2027);
                            float _2038 = (_2025 * _2027) - (_2024 * _2028);
                            float _2042 = rsqrt(dot(float3(_2032, _2035, _2038), float3(_2032, _2035, _2038)));
                            float _2043 = _2032 * _2042;
                            float _2044 = _2035 * _2042;
                            float _2045 = _2038 * _2042;
                            float _2052 = dot(float3(_2043, _2044, _2045), float3(_2009, _2010, _2011)) / dot(float3(_2043, _2044, _2045), float3(_1368, _1369, _1370));
                            float _2053 = _2052 * _1368;
                            float _2054 = _2052 * _1369;
                            float _2055 = _2052 * _1370;
                            float _2062 = _564 - _132;
                            float _2063 = _565 - _133;
                            float _2064 = _566 - _134;
                            float _2074 = rsqrt(dot(float3(_2062, _2063, _2064), float3(_2062, _2063, _2064)));
                            _604 = min(max(((_39_m0[7u].z - sqrt(((_2053 * _2053) + (_2054 * _2054)) + (_2055 * _2055))) + sqrt(((_2063 * _2063) + (_2062 * _2062)) + (_2064 * _2064))) - (clamp((-0.0f) - dot(float3(_2043, _2044, _2045), float3(_2074 * _2062, _2074 * _2063, _2074 * _2064)), 0.0f, 1.0f) * _39_m0[7u].z), 0.0f), 100.0f);
                        }
                        uint _1335 = (_313 * 20u) + 4u;
                        uint4 _1347 = uint4(_22.Load(_1335).x, _22.Load(_1335 + 1u).x, _22.Load(_1335 + 2u).x, _22.Load(_1335 + 3u).x);
                        uint _1348 = _1347.x;
                        uint _1349 = _1347.y;
                        uint _1350 = _1347.z;
                        uint _1351 = _1347.w;
                        float _606;
                        if (_1351 > 16777215u)
                        {
                            _606 = 100.0f;
                        }
                        else
                        {
                            float _1474 = _564 - _570;
                            float _1475 = _565 - _571;
                            float _1476 = _566 - _572;
                            float _1477 = _573 - _570;
                            float _1478 = _574 - _571;
                            float _1479 = _575 - _572;
                            float _1482 = (_1478 * _1476) - (_1479 * _1475);
                            float _1485 = (_1479 * _1474) - (_1477 * _1476);
                            float _1488 = (_1477 * _1475) - (_1478 * _1474);
                            float _1489 = _132 - _567;
                            float _1490 = _133 - _568;
                            float _1491 = _134 - _569;
                            float _1501 = dot(float3(_1482, _1485, _1488), float3(_570 - _567, _571 - _568, _572 - _569)) / dot(float3(_1482, _1485, _1488), float3(_1489, _1490, _1491));
                            float _1505 = (_1501 * _1489) + _567;
                            float _1506 = (_1501 * _1490) + _568;
                            float _1507 = (_1501 * _1491) + _569;
                            float _1508 = _570 - _564;
                            float _1509 = _571 - _565;
                            float _1510 = _572 - _566;
                            float _1511 = _1505 - _564;
                            float _1512 = _1506 - _565;
                            float _1513 = _1507 - _566;
                            float _1516 = (_1513 * _1509) - (_1512 * _1510);
                            float _1519 = (_1511 * _1510) - (_1513 * _1508);
                            float _1522 = (_1512 * _1508) - (_1511 * _1509);
                            float _1526 = _1505 - _570;
                            float _1527 = _1506 - _571;
                            float _1528 = _1507 - _572;
                            float _1531 = (_1528 * _1478) - (_1527 * _1479);
                            float _1534 = (_1526 * _1479) - (_1528 * _1477);
                            float _1537 = (_1527 * _1477) - (_1526 * _1478);
                            float _1541 = dot(float3(_1482, _1485, _1488), float3(_1482, _1485, _1488));
                            float _1546 = sqrt(dot(float3(_1516, _1519, _1522), float3(_1516, _1519, _1522)) / _1541);
                            float _1547 = sqrt(dot(float3(_1531, _1534, _1537), float3(_1531, _1534, _1537)) / _1541);
                            float _1549 = floor(_1547 * 4.0f);
                            float _1551 = floor(_1546 * 4.0f);
                            uint _1557 = uint(int((_1551 + 0.5f) + ((_1549 * 0.5f) * (11.0f - _1549))));
                            uint _1562 = _1557 + 1u;
                            uint _1563 = _1557 + (5u - uint(int(_1549)));
                            bool _1568 = ((((_1547 + _1546) - (_1549 * 0.25f)) - (_1551 * 0.25f)) * 4.0f) > 1.0f;
                            uint _1570 = _1568 ? _1563 : _1562;
                            uint _1571 = _1568 ? _1562 : _1563;
                            uint _1572 = _1568 ? (_1563 + 1u) : _1557;
                            uint _1722;
                            uint _1724;
                            if (_1570 == 0u)
                            {
                                _1722 = 4u;
                                _1724 = 0u;
                            }
                            else
                            {
                                uint frontier_phi_31_32_ladder;
                                uint frontier_phi_31_32_ladder_1;
                                if (_1570 == 14u)
                                {
                                    frontier_phi_31_32_ladder = 4u;
                                    frontier_phi_31_32_ladder_1 = 0u;
                                }
                                else
                                {
                                    uint _1938 = (_1570 << 1u) & 30u;
                                    frontier_phi_31_32_ladder = (262755328u >> _1938) & 3u;
                                    frontier_phi_31_32_ladder_1 = (18377836u >> _1938) & 3u;
                                }
                                _1722 = frontier_phi_31_32_ladder_1;
                                _1724 = frontier_phi_31_32_ladder;
                            }
                            float _1726 = float(_1722);
                            float _1727 = float(_1724);
                            float _1729 = (4.0f - _1726) - _1727;
                            float _1911;
                            float _1913;
                            if (_1571 == 0u)
                            {
                                _1911 = 4.0f;
                                _1913 = 0.0f;
                            }
                            else
                            {
                                float frontier_phi_39_40_ladder;
                                float frontier_phi_39_40_ladder_1;
                                if (_1571 == 14u)
                                {
                                    frontier_phi_39_40_ladder = 4.0f;
                                    frontier_phi_39_40_ladder_1 = 0.0f;
                                }
                                else
                                {
                                    uint _2295 = (_1571 << 1u) & 30u;
                                    frontier_phi_39_40_ladder = float((262755328u >> _2295) & 3u);
                                    frontier_phi_39_40_ladder_1 = float((18377836u >> _2295) & 3u);
                                }
                                _1911 = frontier_phi_39_40_ladder_1;
                                _1913 = frontier_phi_39_40_ladder;
                            }
                            float _1916 = (4.0f - _1911) - _1913;
                            float _2151;
                            float _2153;
                            if (_1572 == 0u)
                            {
                                _2151 = 4.0f;
                                _2153 = 0.0f;
                            }
                            else
                            {
                                float frontier_phi_50_51_ladder;
                                float frontier_phi_50_51_ladder_1;
                                if (_1572 == 14u)
                                {
                                    frontier_phi_50_51_ladder = 4.0f;
                                    frontier_phi_50_51_ladder_1 = 0.0f;
                                }
                                else
                                {
                                    uint _2486 = (_1572 << 1u) & 30u;
                                    frontier_phi_50_51_ladder = float((262755328u >> _2486) & 3u);
                                    frontier_phi_50_51_ladder_1 = float((18377836u >> _2486) & 3u);
                                }
                                _2151 = frontier_phi_50_51_ladder_1;
                                _2153 = frontier_phi_50_51_ladder;
                            }
                            float _2156 = (4.0f - _2151) - _2153;
                            float _2186 = float((((_1570 > 11u) ? _1351 : ((_1570 > 7u) ? _1350 : ((_1570 > 3u) ? _1349 : _1348))) >> ((_1570 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2198 = float((((_1571 > 11u) ? _1351 : ((_1571 > 7u) ? _1350 : ((_1571 > 3u) ? _1349 : _1348))) >> ((_1571 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2210 = float((((_1572 > 11u) ? _1351 : ((_1572 > 7u) ? _1350 : ((_1572 > 3u) ? _1349 : _1348))) >> ((_1572 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2214 = (((((_1727 * _564) + (_1726 * _570)) + (_1729 * _573)) * 0.25f) - _567) * _2186;
                            float _2215 = (((((_1727 * _565) + (_1726 * _571)) + (_1729 * _574)) * 0.25f) - _568) * _2186;
                            float _2216 = (((((_1727 * _566) + (_1726 * _572)) + (_1729 * _575)) * 0.25f) - _569) * _2186;
                            float _2229 = ((((((_2153 * _564) + (_2151 * _570)) + (_2156 * _573)) * 0.25f) - _567) * _2210) - _2214;
                            float _2230 = ((((((_2153 * _565) + (_2151 * _571)) + (_2156 * _574)) * 0.25f) - _568) * _2210) - _2215;
                            float _2231 = ((((((_2153 * _566) + (_2151 * _572)) + (_2156 * _575)) * 0.25f) - _569) * _2210) - _2216;
                            float _2232 = ((((((_1913 * _564) + (_1911 * _570)) + (_1916 * _573)) * 0.25f) - _567) * _2198) - _2214;
                            float _2233 = ((((((_1913 * _565) + (_1911 * _571)) + (_1916 * _574)) * 0.25f) - _568) * _2198) - _2215;
                            float _2234 = ((((((_1913 * _566) + (_1911 * _572)) + (_1916 * _575)) * 0.25f) - _569) * _2198) - _2216;
                            float _2237 = (_2231 * _2233) - (_2230 * _2234);
                            float _2240 = (_2229 * _2234) - (_2231 * _2232);
                            float _2243 = (_2230 * _2232) - (_2229 * _2233);
                            float _2247 = rsqrt(dot(float3(_2237, _2240, _2243), float3(_2237, _2240, _2243)));
                            float _2248 = _2237 * _2247;
                            float _2249 = _2240 * _2247;
                            float _2250 = _2243 * _2247;
                            float _2257 = dot(float3(_2248, _2249, _2250), float3(_2214, _2215, _2216)) / dot(float3(_2248, _2249, _2250), float3(_1489, _1490, _1491));
                            float _2258 = _2257 * _1489;
                            float _2259 = _2257 * _1490;
                            float _2260 = _2257 * _1491;
                            float _2267 = _567 - _132;
                            float _2268 = _568 - _133;
                            float _2269 = _569 - _134;
                            float _2279 = rsqrt(dot(float3(_2267, _2268, _2269), float3(_2267, _2268, _2269)));
                            _606 = min(max(((_39_m0[7u].z - sqrt(((_2258 * _2258) + (_2259 * _2259)) + (_2260 * _2260))) + sqrt(((_2268 * _2268) + (_2267 * _2267)) + (_2269 * _2269))) - (clamp((-0.0f) - dot(float3(_2248, _2249, _2250), float3(_2279 * _2267, _2279 * _2268, _2279 * _2269)), 0.0f, 1.0f) * _39_m0[7u].z), 0.0f), 100.0f);
                        }
                        uint _1456 = (_313 * 20u) + 8u;
                        uint4 _1468 = uint4(_22.Load(_1456).x, _22.Load(_1456 + 1u).x, _22.Load(_1456 + 2u).x, _22.Load(_1456 + 3u).x);
                        uint _1469 = _1468.x;
                        uint _1470 = _1468.y;
                        uint _1471 = _1468.z;
                        uint _1472 = _1468.w;
                        float _608;
                        if (_1472 > 16777215u)
                        {
                            _608 = 100.0f;
                        }
                        else
                        {
                            float _1622 = _567 - _573;
                            float _1623 = _568 - _574;
                            float _1624 = _569 - _575;
                            float _1625 = _564 - _573;
                            float _1626 = _565 - _574;
                            float _1627 = _566 - _575;
                            float _1630 = (_1624 * _1626) - (_1627 * _1623);
                            float _1633 = (_1627 * _1622) - (_1624 * _1625);
                            float _1636 = (_1623 * _1625) - (_1626 * _1622);
                            float _1637 = _132 - _570;
                            float _1638 = _133 - _571;
                            float _1639 = _134 - _572;
                            float _1649 = dot(float3(_1630, _1633, _1636), float3(_573 - _570, _574 - _571, _575 - _572)) / dot(float3(_1630, _1633, _1636), float3(_1637, _1638, _1639));
                            float _1653 = (_1649 * _1637) + _570;
                            float _1654 = (_1649 * _1638) + _571;
                            float _1655 = (_1649 * _1639) + _572;
                            float _1656 = _573 - _567;
                            float _1657 = _574 - _568;
                            float _1658 = _575 - _569;
                            float _1659 = _1653 - _567;
                            float _1660 = _1654 - _568;
                            float _1661 = _1655 - _569;
                            float _1664 = (_1661 * _1657) - (_1660 * _1658);
                            float _1667 = (_1659 * _1658) - (_1661 * _1656);
                            float _1670 = (_1660 * _1656) - (_1659 * _1657);
                            float _1674 = _1653 - _573;
                            float _1675 = _1654 - _574;
                            float _1676 = _1655 - _575;
                            float _1679 = (_1676 * _1626) - (_1675 * _1627);
                            float _1682 = (_1674 * _1627) - (_1676 * _1625);
                            float _1685 = (_1675 * _1625) - (_1674 * _1626);
                            float _1689 = dot(float3(_1630, _1633, _1636), float3(_1630, _1633, _1636));
                            float _1694 = sqrt(dot(float3(_1664, _1667, _1670), float3(_1664, _1667, _1670)) / _1689);
                            float _1695 = sqrt(dot(float3(_1679, _1682, _1685), float3(_1679, _1682, _1685)) / _1689);
                            float _1697 = floor(_1695 * 4.0f);
                            float _1699 = floor(_1694 * 4.0f);
                            uint _1705 = uint(int((_1699 + 0.5f) + ((_1697 * 0.5f) * (11.0f - _1697))));
                            uint _1710 = _1705 + 1u;
                            uint _1711 = _1705 + (5u - uint(int(_1697)));
                            bool _1716 = ((((_1695 + _1694) - (_1697 * 0.25f)) - (_1699 * 0.25f)) * 4.0f) > 1.0f;
                            uint _1718 = _1716 ? _1711 : _1710;
                            uint _1719 = _1716 ? _1710 : _1711;
                            uint _1720 = _1716 ? (_1711 + 1u) : _1705;
                            float _1885;
                            float _1887;
                            if (_1718 == 0u)
                            {
                                _1885 = 4.0f;
                                _1887 = 0.0f;
                            }
                            else
                            {
                                float frontier_phi_37_38_ladder;
                                float frontier_phi_37_38_ladder_1;
                                if (_1718 == 14u)
                                {
                                    frontier_phi_37_38_ladder = 4.0f;
                                    frontier_phi_37_38_ladder_1 = 0.0f;
                                }
                                else
                                {
                                    uint _2146 = (_1718 << 1u) & 30u;
                                    frontier_phi_37_38_ladder = float((262755328u >> _2146) & 3u);
                                    frontier_phi_37_38_ladder_1 = float((18377836u >> _2146) & 3u);
                                }
                                _1885 = frontier_phi_37_38_ladder_1;
                                _1887 = frontier_phi_37_38_ladder;
                            }
                            float _1890 = (4.0f - _1885) - _1887;
                            float _2119;
                            float _2121;
                            if (_1719 == 0u)
                            {
                                _2119 = 4.0f;
                                _2121 = 0.0f;
                            }
                            else
                            {
                                float frontier_phi_47_48_ladder;
                                float frontier_phi_47_48_ladder_1;
                                if (_1719 == 14u)
                                {
                                    frontier_phi_47_48_ladder = 4.0f;
                                    frontier_phi_47_48_ladder_1 = 0.0f;
                                }
                                else
                                {
                                    uint _2480 = (_1719 << 1u) & 30u;
                                    frontier_phi_47_48_ladder = float((262755328u >> _2480) & 3u);
                                    frontier_phi_47_48_ladder_1 = float((18377836u >> _2480) & 3u);
                                }
                                _2119 = frontier_phi_47_48_ladder_1;
                                _2121 = frontier_phi_47_48_ladder;
                            }
                            float _2124 = (4.0f - _2119) - _2121;
                            float _2336;
                            float _2338;
                            if (_1720 == 0u)
                            {
                                _2336 = 4.0f;
                                _2338 = 0.0f;
                            }
                            else
                            {
                                float frontier_phi_57_58_ladder;
                                float frontier_phi_57_58_ladder_1;
                                if (_1720 == 14u)
                                {
                                    frontier_phi_57_58_ladder = 4.0f;
                                    frontier_phi_57_58_ladder_1 = 0.0f;
                                }
                                else
                                {
                                    uint _2641 = (_1720 << 1u) & 30u;
                                    frontier_phi_57_58_ladder = float((262755328u >> _2641) & 3u);
                                    frontier_phi_57_58_ladder_1 = float((18377836u >> _2641) & 3u);
                                }
                                _2336 = frontier_phi_57_58_ladder_1;
                                _2338 = frontier_phi_57_58_ladder;
                            }
                            float _2341 = (4.0f - _2336) - _2338;
                            float _2371 = float((((_1718 > 11u) ? _1472 : ((_1718 > 7u) ? _1471 : ((_1718 > 3u) ? _1470 : _1469))) >> ((_1718 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2383 = float((((_1719 > 11u) ? _1472 : ((_1719 > 7u) ? _1471 : ((_1719 > 3u) ? _1470 : _1469))) >> ((_1719 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2395 = float((((_1720 > 11u) ? _1472 : ((_1720 > 7u) ? _1471 : ((_1720 > 3u) ? _1470 : _1469))) >> ((_1720 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2399 = (((((_1887 * _567) + (_1885 * _573)) + (_1890 * _564)) * 0.25f) - _570) * _2371;
                            float _2400 = (((((_1887 * _568) + (_1885 * _574)) + (_1890 * _565)) * 0.25f) - _571) * _2371;
                            float _2401 = (((((_1887 * _569) + (_1885 * _575)) + (_1890 * _566)) * 0.25f) - _572) * _2371;
                            float _2414 = ((((((_2338 * _567) + (_2336 * _573)) + (_2341 * _564)) * 0.25f) - _570) * _2395) - _2399;
                            float _2415 = ((((((_2338 * _568) + (_2336 * _574)) + (_2341 * _565)) * 0.25f) - _571) * _2395) - _2400;
                            float _2416 = ((((((_2338 * _569) + (_2336 * _575)) + (_2341 * _566)) * 0.25f) - _572) * _2395) - _2401;
                            float _2417 = ((((((_2121 * _567) + (_2119 * _573)) + (_2124 * _564)) * 0.25f) - _570) * _2383) - _2399;
                            float _2418 = ((((((_2121 * _568) + (_2119 * _574)) + (_2124 * _565)) * 0.25f) - _571) * _2383) - _2400;
                            float _2419 = ((((((_2121 * _569) + (_2119 * _575)) + (_2124 * _566)) * 0.25f) - _572) * _2383) - _2401;
                            float _2422 = (_2416 * _2418) - (_2415 * _2419);
                            float _2425 = (_2414 * _2419) - (_2416 * _2417);
                            float _2428 = (_2415 * _2417) - (_2414 * _2418);
                            float _2432 = rsqrt(dot(float3(_2422, _2425, _2428), float3(_2422, _2425, _2428)));
                            float _2433 = _2422 * _2432;
                            float _2434 = _2425 * _2432;
                            float _2435 = _2428 * _2432;
                            float _2442 = dot(float3(_2433, _2434, _2435), float3(_2399, _2400, _2401)) / dot(float3(_2433, _2434, _2435), float3(_1637, _1638, _1639));
                            float _2443 = _2442 * _1637;
                            float _2444 = _2442 * _1638;
                            float _2445 = _2442 * _1639;
                            float _2452 = _570 - _132;
                            float _2453 = _571 - _133;
                            float _2454 = _572 - _134;
                            float _2464 = rsqrt(dot(float3(_2452, _2453, _2454), float3(_2452, _2453, _2454)));
                            _608 = min(max(((_39_m0[7u].z - sqrt(((_2443 * _2443) + (_2444 * _2444)) + (_2445 * _2445))) + sqrt(((_2453 * _2453) + (_2452 * _2452)) + (_2454 * _2454))) - (clamp((-0.0f) - dot(float3(_2433, _2434, _2435), float3(_2464 * _2452, _2464 * _2453, _2464 * _2454)), 0.0f, 1.0f) * _39_m0[7u].z), 0.0f), 100.0f);
                        }
                        uint _1604 = (_313 * 20u) + 12u;
                        uint4 _1616 = uint4(_22.Load(_1604).x, _22.Load(_1604 + 1u).x, _22.Load(_1604 + 2u).x, _22.Load(_1604 + 3u).x);
                        uint _1617 = _1616.x;
                        uint _1618 = _1616.y;
                        uint _1619 = _1616.z;
                        uint _1620 = _1616.w;
                        float frontier_phi_21_29_ladder;
                        float frontier_phi_21_29_ladder_1;
                        float frontier_phi_21_29_ladder_2;
                        float frontier_phi_21_29_ladder_3;
                        if (_1620 > 16777215u)
                        {
                            frontier_phi_21_29_ladder = 100.0f;
                            frontier_phi_21_29_ladder_1 = _608;
                            frontier_phi_21_29_ladder_2 = _606;
                            frontier_phi_21_29_ladder_3 = _604;
                        }
                        else
                        {
                            float _1785 = _570 - _564;
                            float _1786 = _571 - _565;
                            float _1787 = _572 - _566;
                            float _1788 = _567 - _564;
                            float _1789 = _568 - _565;
                            float _1790 = _569 - _566;
                            float _1793 = (_1787 * _1789) - (_1786 * _1790);
                            float _1796 = (_1785 * _1790) - (_1787 * _1788);
                            float _1799 = (_1786 * _1788) - (_1785 * _1789);
                            float _1800 = _132 - _573;
                            float _1801 = _133 - _574;
                            float _1802 = _134 - _575;
                            float _1812 = dot(float3(_1793, _1796, _1799), float3(_564 - _573, _565 - _574, _566 - _575)) / dot(float3(_1793, _1796, _1799), float3(_1800, _1801, _1802));
                            float _1816 = (_1812 * _1800) + _573;
                            float _1817 = (_1812 * _1801) + _574;
                            float _1818 = (_1812 * _1802) + _575;
                            float _1819 = _564 - _570;
                            float _1820 = _565 - _571;
                            float _1821 = _566 - _572;
                            float _1822 = _1816 - _570;
                            float _1823 = _1817 - _571;
                            float _1824 = _1818 - _572;
                            float _1827 = (_1824 * _1820) - (_1823 * _1821);
                            float _1830 = (_1822 * _1821) - (_1824 * _1819);
                            float _1833 = (_1823 * _1819) - (_1822 * _1820);
                            float _1837 = _1816 - _564;
                            float _1838 = _1817 - _565;
                            float _1839 = _1818 - _566;
                            float _1842 = (_1839 * _1789) - (_1838 * _1790);
                            float _1845 = (_1837 * _1790) - (_1839 * _1788);
                            float _1848 = (_1838 * _1788) - (_1837 * _1789);
                            float _1852 = dot(float3(_1793, _1796, _1799), float3(_1793, _1796, _1799));
                            float _1857 = sqrt(dot(float3(_1827, _1830, _1833), float3(_1827, _1830, _1833)) / _1852);
                            float _1858 = sqrt(dot(float3(_1842, _1845, _1848), float3(_1842, _1845, _1848)) / _1852);
                            float _1860 = floor(_1858 * 4.0f);
                            float _1862 = floor(_1857 * 4.0f);
                            uint _1868 = uint(int((_1862 + 0.5f) + ((_1860 * 0.5f) * (11.0f - _1860))));
                            uint _1873 = _1868 + 1u;
                            uint _1874 = _1868 + (5u - uint(int(_1860)));
                            bool _1879 = ((((_1858 + _1857) - (_1860 * 0.25f)) - (_1862 * 0.25f)) * 4.0f) > 1.0f;
                            uint _1881 = _1879 ? _1874 : _1873;
                            uint _1882 = _1879 ? _1873 : _1874;
                            uint _1883 = _1879 ? (_1874 + 1u) : _1868;
                            float _2093;
                            float _2095;
                            if (_1881 == 0u)
                            {
                                _2093 = 0.0f;
                                _2095 = 4.0f;
                            }
                            else
                            {
                                float frontier_phi_45_46_ladder;
                                float frontier_phi_45_46_ladder_1;
                                if (_1881 == 14u)
                                {
                                    frontier_phi_45_46_ladder = 0.0f;
                                    frontier_phi_45_46_ladder_1 = 4.0f;
                                }
                                else
                                {
                                    uint _2331 = (_1881 << 1u) & 30u;
                                    frontier_phi_45_46_ladder = float((18377836u >> _2331) & 3u);
                                    frontier_phi_45_46_ladder_1 = float((262755328u >> _2331) & 3u);
                                }
                                _2093 = frontier_phi_45_46_ladder_1;
                                _2095 = frontier_phi_45_46_ladder;
                            }
                            float _2098 = (4.0f - _2095) - _2093;
                            float _2304;
                            float _2306;
                            if (_1882 == 0u)
                            {
                                _2304 = 0.0f;
                                _2306 = 4.0f;
                            }
                            else
                            {
                                float frontier_phi_54_55_ladder;
                                float frontier_phi_54_55_ladder_1;
                                if (_1882 == 14u)
                                {
                                    frontier_phi_54_55_ladder = 0.0f;
                                    frontier_phi_54_55_ladder_1 = 4.0f;
                                }
                                else
                                {
                                    uint _2635 = (_1882 << 1u) & 30u;
                                    frontier_phi_54_55_ladder = float((18377836u >> _2635) & 3u);
                                    frontier_phi_54_55_ladder_1 = float((262755328u >> _2635) & 3u);
                                }
                                _2304 = frontier_phi_54_55_ladder_1;
                                _2306 = frontier_phi_54_55_ladder;
                            }
                            float _2309 = (4.0f - _2306) - _2304;
                            float _2491;
                            float _2493;
                            if (_1883 == 0u)
                            {
                                _2491 = 0.0f;
                                _2493 = 4.0f;
                            }
                            else
                            {
                                float frontier_phi_61_62_ladder;
                                float frontier_phi_61_62_ladder_1;
                                if (_1883 == 14u)
                                {
                                    frontier_phi_61_62_ladder = 0.0f;
                                    frontier_phi_61_62_ladder_1 = 4.0f;
                                }
                                else
                                {
                                    uint _2647 = (_1883 << 1u) & 30u;
                                    frontier_phi_61_62_ladder = float((18377836u >> _2647) & 3u);
                                    frontier_phi_61_62_ladder_1 = float((262755328u >> _2647) & 3u);
                                }
                                _2491 = frontier_phi_61_62_ladder_1;
                                _2493 = frontier_phi_61_62_ladder;
                            }
                            float _2496 = (4.0f - _2493) - _2491;
                            float _2526 = float((((_1881 > 11u) ? _1620 : ((_1881 > 7u) ? _1619 : ((_1881 > 3u) ? _1618 : _1617))) >> ((_1881 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2538 = float((((_1882 > 11u) ? _1620 : ((_1882 > 7u) ? _1619 : ((_1882 > 3u) ? _1618 : _1617))) >> ((_1882 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2550 = float((((_1883 > 11u) ? _1620 : ((_1883 > 7u) ? _1619 : ((_1883 > 3u) ? _1618 : _1617))) >> ((_1883 << 3u) & 24u)) & 255u) * 0.0039215688593685626983642578125f;
                            float _2554 = (((((_2095 * _564) + (_2093 * _570)) + (_2098 * _567)) * 0.25f) - _573) * _2526;
                            float _2555 = (((((_2095 * _565) + (_2093 * _571)) + (_2098 * _568)) * 0.25f) - _574) * _2526;
                            float _2556 = (((((_2095 * _566) + (_2093 * _572)) + (_2098 * _569)) * 0.25f) - _575) * _2526;
                            float _2569 = ((((((_2493 * _564) + (_2491 * _570)) + (_2496 * _567)) * 0.25f) - _573) * _2550) - _2554;
                            float _2570 = ((((((_2493 * _565) + (_2491 * _571)) + (_2496 * _568)) * 0.25f) - _574) * _2550) - _2555;
                            float _2571 = ((((((_2493 * _566) + (_2491 * _572)) + (_2496 * _569)) * 0.25f) - _575) * _2550) - _2556;
                            float _2572 = ((((((_2306 * _564) + (_2304 * _570)) + (_2309 * _567)) * 0.25f) - _573) * _2538) - _2554;
                            float _2573 = ((((((_2306 * _565) + (_2304 * _571)) + (_2309 * _568)) * 0.25f) - _574) * _2538) - _2555;
                            float _2574 = ((((((_2306 * _566) + (_2304 * _572)) + (_2309 * _569)) * 0.25f) - _575) * _2538) - _2556;
                            float _2577 = (_2571 * _2573) - (_2570 * _2574);
                            float _2580 = (_2569 * _2574) - (_2571 * _2572);
                            float _2583 = (_2570 * _2572) - (_2569 * _2573);
                            float _2587 = rsqrt(dot(float3(_2577, _2580, _2583), float3(_2577, _2580, _2583)));
                            float _2588 = _2577 * _2587;
                            float _2589 = _2580 * _2587;
                            float _2590 = _2583 * _2587;
                            float _2597 = dot(float3(_2588, _2589, _2590), float3(_2554, _2555, _2556)) / dot(float3(_2588, _2589, _2590), float3(_1800, _1801, _1802));
                            float _2598 = _2597 * _1800;
                            float _2599 = _2597 * _1801;
                            float _2600 = _2597 * _1802;
                            float _2607 = _573 - _132;
                            float _2608 = _574 - _133;
                            float _2609 = _575 - _134;
                            float _2619 = rsqrt(dot(float3(_2607, _2608, _2609), float3(_2607, _2608, _2609)));
                            frontier_phi_21_29_ladder = min(max(((_39_m0[7u].z - sqrt(((_2598 * _2598) + (_2599 * _2599)) + (_2600 * _2600))) + sqrt(((_2608 * _2608) + (_2607 * _2607)) + (_2609 * _2609))) - (clamp((-0.0f) - dot(float3(_2588, _2589, _2590), float3(_2619 * _2607, _2619 * _2608, _2619 * _2609)), 0.0f, 1.0f) * _39_m0[7u].z), 0.0f), 100.0f);
                            frontier_phi_21_29_ladder_1 = _608;
                            frontier_phi_21_29_ladder_2 = _606;
                            frontier_phi_21_29_ladder_3 = _604;
                        }
                        _603 = frontier_phi_21_29_ladder_3;
                        _605 = frontier_phi_21_29_ladder_2;
                        _607 = frontier_phi_21_29_ladder_1;
                        _609 = frontier_phi_21_29_ladder;
                    }
                    else
                    {
                        _603 = _301;
                        _605 = _301;
                        _607 = _301;
                        _609 = _301;
                    }
                    float _612 = _132 - _564;
                    float _613 = _133 - _565;
                    float _614 = _134 - _566;
                    float _621 = _132 - _567;
                    float _622 = _133 - _568;
                    float _623 = _134 - _569;
                    float _630 = _132 - _570;
                    float _631 = _133 - _571;
                    float _632 = _134 - _572;
                    float _639 = _132 - _573;
                    float _640 = _133 - _574;
                    float _641 = _134 - _575;
                    float _648 = _564 - _132;
                    float _649 = _565 - _133;
                    float _650 = _566 - _134;
                    float _654 = rsqrt(dot(float3(_648, _649, _650), float3(_648, _649, _650)));
                    float _661 = _567 - _132;
                    float _662 = _568 - _133;
                    float _663 = _569 - _134;
                    float _667 = rsqrt(dot(float3(_661, _662, _663), float3(_661, _662, _663)));
                    float _674 = _570 - _132;
                    float _675 = _571 - _133;
                    float _676 = _572 - _134;
                    float _680 = rsqrt(dot(float3(_674, _675, _676), float3(_674, _675, _676)));
                    float _687 = _573 - _132;
                    float _688 = _574 - _133;
                    float _689 = _575 - _134;
                    float _693 = rsqrt(dot(float3(_687, _688, _689), float3(_687, _688, _689)));
                    float _716 = ((_603 * _39_m0[6u].w) - (dot(float3(_148, _149, _150), float3(_654 * _648, _654 * _649, _654 * _650)) * _39_m0[7u].y)) + (sqrt(((_613 * _613) + (_612 * _612)) + (_614 * _614)) * _39_m0[7u].x);
                    float _717 = ((_605 * _39_m0[6u].w) - (dot(float3(_148, _149, _150), float3(_667 * _661, _667 * _662, _667 * _663)) * _39_m0[7u].y)) + (sqrt(((_622 * _622) + (_621 * _621)) + (_623 * _623)) * _39_m0[7u].x);
                    float _718 = ((_607 * _39_m0[6u].w) - (dot(float3(_148, _149, _150), float3(_680 * _674, _680 * _675, _680 * _676)) * _39_m0[7u].y)) + (sqrt(((_631 * _631) + (_630 * _630)) + (_632 * _632)) * _39_m0[7u].x);
                    float _719 = ((_609 * _39_m0[6u].w) - (dot(float3(_148, _149, _150), float3(_693 * _687, _693 * _688, _693 * _689)) * _39_m0[7u].y)) + (sqrt(((_640 * _640) + (_639 * _639)) + (_641 * _641)) * _39_m0[7u].x);
                    float _722 = min(min(_716, _717), min(_718, _719));
                    float _728 = 1.0f / _39_m0[7u].w;
                    float _730 = clamp((clamp(_39_m0[7u].w - abs(_716 - _722), 0.0f, 1.0f) * _306) * _728, 0.0f, 1.0f);
                    float _733 = max(_148, 0.0f);
                    float _734 = max(_149, 0.0f);
                    float _735 = max(_150, 0.0f);
                    float _736 = _733 * _733;
                    float _737 = _734 * _734;
                    float _738 = _735 * _735;
                    float _743 = max((-0.0f) - _148, 0.0f);
                    float _744 = max((-0.0f) - _149, 0.0f);
                    float _745 = max((-0.0f) - _150, 0.0f);
                    float _746 = _743 * _743;
                    float _747 = _744 * _744;
                    float _748 = _745 * _745;
                    uint _749 = _450 * 14u;
                    uint2 _755 = uint2(_21.Load(_749).x, _21.Load(_749 + 1u).x);
                    uint _756 = _755.x;
                    uint _770 = (_450 * 14u) + 2u;
                    uint2 _776 = uint2(_21.Load(_770).x, _21.Load(_770 + 1u).x);
                    uint _777 = _776.x;
                    uint _793 = (_450 * 14u) + 4u;
                    uint2 _799 = uint2(_21.Load(_793).x, _21.Load(_793 + 1u).x);
                    uint _800 = _799.x;
                    uint _816 = (_450 * 14u) + 6u;
                    uint2 _822 = uint2(_21.Load(_816).x, _21.Load(_816 + 1u).x);
                    uint _823 = _822.x;
                    uint _839 = (_450 * 14u) + 8u;
                    uint2 _845 = uint2(_21.Load(_839).x, _21.Load(_839 + 1u).x);
                    uint _846 = _845.x;
                    uint _862 = (_450 * 14u) + 10u;
                    uint2 _868 = uint2(_21.Load(_862).x, _21.Load(_862 + 1u).x);
                    uint _869 = _868.x;
                    float _893 = clamp((clamp(_39_m0[7u].w - abs(_717 - _722), 0.0f, 1.0f) * _304) * _728, 0.0f, 1.0f);
                    uint _895 = _451 * 14u;
                    uint2 _901 = uint2(_21.Load(_895).x, _21.Load(_895 + 1u).x);
                    uint _902 = _901.x;
                    uint _915 = (_451 * 14u) + 2u;
                    uint2 _921 = uint2(_21.Load(_915).x, _21.Load(_915 + 1u).x);
                    uint _922 = _921.x;
                    uint _938 = (_451 * 14u) + 4u;
                    uint2 _944 = uint2(_21.Load(_938).x, _21.Load(_938 + 1u).x);
                    uint _945 = _944.x;
                    uint _961 = (_451 * 14u) + 6u;
                    uint2 _967 = uint2(_21.Load(_961).x, _21.Load(_961 + 1u).x);
                    uint _968 = _967.x;
                    uint _984 = (_451 * 14u) + 8u;
                    uint2 _990 = uint2(_21.Load(_984).x, _21.Load(_984 + 1u).x);
                    uint _991 = _990.x;
                    uint _1007 = (_451 * 14u) + 10u;
                    uint2 _1013 = uint2(_21.Load(_1007).x, _21.Load(_1007 + 1u).x);
                    uint _1014 = _1013.x;
                    float _1041 = clamp((clamp(_39_m0[7u].w - abs(_718 - _722), 0.0f, 1.0f) * _302) * _728, 0.0f, 1.0f);
                    uint _1043 = _452 * 14u;
                    uint2 _1049 = uint2(_21.Load(_1043).x, _21.Load(_1043 + 1u).x);
                    uint _1050 = _1049.x;
                    uint _1063 = (_452 * 14u) + 2u;
                    uint2 _1069 = uint2(_21.Load(_1063).x, _21.Load(_1063 + 1u).x);
                    uint _1070 = _1069.x;
                    uint _1086 = (_452 * 14u) + 4u;
                    uint2 _1092 = uint2(_21.Load(_1086).x, _21.Load(_1086 + 1u).x);
                    uint _1093 = _1092.x;
                    uint _1109 = (_452 * 14u) + 6u;
                    uint2 _1115 = uint2(_21.Load(_1109).x, _21.Load(_1109 + 1u).x);
                    uint _1116 = _1115.x;
                    uint _1132 = (_452 * 14u) + 8u;
                    uint2 _1138 = uint2(_21.Load(_1132).x, _21.Load(_1132 + 1u).x);
                    uint _1139 = _1138.x;
                    uint _1155 = (_452 * 14u) + 10u;
                    uint2 _1161 = uint2(_21.Load(_1155).x, _21.Load(_1155 + 1u).x);
                    uint _1162 = _1161.x;
                    float _1180 = ((((((((spvUnpackHalf2x16(_922).x * _746) + (spvUnpackHalf2x16(_902).x * _736)) + (spvUnpackHalf2x16(_945).x * _737)) + (spvUnpackHalf2x16(_968).x * _747)) + (spvUnpackHalf2x16(_991).x * _738)) + (spvUnpackHalf2x16(_1014).x * _748)) * _893) + (((((((spvUnpackHalf2x16(_777).x * _746) + (spvUnpackHalf2x16(_756).x * _736)) + (spvUnpackHalf2x16(_800).x * _737)) + (spvUnpackHalf2x16(_823).x * _747)) + (spvUnpackHalf2x16(_846).x * _738)) + (spvUnpackHalf2x16(_869).x * _748)) * _730)) + (((((((spvUnpackHalf2x16(_1070).x * _746) + (spvUnpackHalf2x16(_1050).x * _736)) + (spvUnpackHalf2x16(_1093).x * _737)) + (spvUnpackHalf2x16(_1116).x * _747)) + (spvUnpackHalf2x16(_1139).x * _738)) + (spvUnpackHalf2x16(_1162).x * _748)) * _1041);
                    float _1181 = ((((((((spvUnpackHalf2x16(_922 >> 16u).x * _746) + (spvUnpackHalf2x16(_902 >> 16u).x * _736)) + (spvUnpackHalf2x16(_945 >> 16u).x * _737)) + (spvUnpackHalf2x16(_968 >> 16u).x * _747)) + (spvUnpackHalf2x16(_991 >> 16u).x * _738)) + (spvUnpackHalf2x16(_1014 >> 16u).x * _748)) * _893) + (((((((spvUnpackHalf2x16(_777 >> 16u).x * _746) + (spvUnpackHalf2x16(_756 >> 16u).x * _736)) + (spvUnpackHalf2x16(_800 >> 16u).x * _737)) + (spvUnpackHalf2x16(_823 >> 16u).x * _747)) + (spvUnpackHalf2x16(_846 >> 16u).x * _738)) + (spvUnpackHalf2x16(_869 >> 16u).x * _748)) * _730)) + (((((((spvUnpackHalf2x16(_1070 >> 16u).x * _746) + (spvUnpackHalf2x16(_1050 >> 16u).x * _736)) + (spvUnpackHalf2x16(_1093 >> 16u).x * _737)) + (spvUnpackHalf2x16(_1116 >> 16u).x * _747)) + (spvUnpackHalf2x16(_1139 >> 16u).x * _738)) + (spvUnpackHalf2x16(_1162 >> 16u).x * _748)) * _1041);
                    float _1182 = ((((((((spvUnpackHalf2x16(_921.y).x * _746) + (spvUnpackHalf2x16(_901.y).x * _736)) + (spvUnpackHalf2x16(_944.y).x * _737)) + (spvUnpackHalf2x16(_967.y).x * _747)) + (spvUnpackHalf2x16(_990.y).x * _738)) + (spvUnpackHalf2x16(_1013.y).x * _748)) * _893) + (((((((spvUnpackHalf2x16(_776.y).x * _746) + (spvUnpackHalf2x16(_755.y).x * _736)) + (spvUnpackHalf2x16(_799.y).x * _737)) + (spvUnpackHalf2x16(_822.y).x * _747)) + (spvUnpackHalf2x16(_845.y).x * _738)) + (spvUnpackHalf2x16(_868.y).x * _748)) * _730)) + (((((((spvUnpackHalf2x16(_1069.y).x * _746) + (spvUnpackHalf2x16(_1049.y).x * _736)) + (spvUnpackHalf2x16(_1092.y).x * _737)) + (spvUnpackHalf2x16(_1115.y).x * _747)) + (spvUnpackHalf2x16(_1138.y).x * _738)) + (spvUnpackHalf2x16(_1161.y).x * _748)) * _1041);
                    float _1189 = clamp((clamp(_39_m0[7u].w - abs(_719 - _722), 0.0f, 1.0f) * _299) * _728, 0.0f, 1.0f);
                    uint _1191 = _453 * 14u;
                    uint2 _1197 = uint2(_21.Load(_1191).x, _21.Load(_1191 + 1u).x);
                    uint _1198 = _1197.x;
                    uint _1211 = (_453 * 14u) + 2u;
                    uint2 _1217 = uint2(_21.Load(_1211).x, _21.Load(_1211 + 1u).x);
                    uint _1218 = _1217.x;
                    uint _1234 = (_453 * 14u) + 4u;
                    uint2 _1240 = uint2(_21.Load(_1234).x, _21.Load(_1234 + 1u).x);
                    uint _1241 = _1240.x;
                    uint _1257 = (_453 * 14u) + 6u;
                    uint2 _1263 = uint2(_21.Load(_1257).x, _21.Load(_1257 + 1u).x);
                    uint _1264 = _1263.x;
                    uint _1280 = (_453 * 14u) + 8u;
                    uint2 _1286 = uint2(_21.Load(_1280).x, _21.Load(_1280 + 1u).x);
                    uint _1287 = _1286.x;
                    uint _1303 = (_453 * 14u) + 10u;
                    uint2 _1309 = uint2(_21.Load(_1303).x, _21.Load(_1303 + 1u).x);
                    uint _1310 = _1309.x;
                    float _1331 = 1.0f / ((((_730 + 9.9999997473787516355514526367188e-05f) + _893) + _1041) + _1189);
                    precise float _294 = (_1331 * (_1182 + (((((((spvUnpackHalf2x16(_1217.y).x * _746) + (spvUnpackHalf2x16(_1197.y).x * _736)) + (spvUnpackHalf2x16(_1240.y).x * _737)) + (spvUnpackHalf2x16(_1263.y).x * _747)) + (spvUnpackHalf2x16(_1286.y).x * _738)) + (spvUnpackHalf2x16(_1309.y).x * _748)) * _1189))) * 64.0f;
                    frontier_phi_4_6_ladder_8_ladder = _294;
                    frontier_phi_4_6_ladder_8_ladder_1 = (_1181 + (((((((spvUnpackHalf2x16(_1218 >> 16u).x * _746) + (spvUnpackHalf2x16(_1198 >> 16u).x * _736)) + (spvUnpackHalf2x16(_1241 >> 16u).x * _737)) + (spvUnpackHalf2x16(_1264 >> 16u).x * _747)) + (spvUnpackHalf2x16(_1287 >> 16u).x * _738)) + (spvUnpackHalf2x16(_1310 >> 16u).x * _748)) * _1189)) * _1331;
                    frontier_phi_4_6_ladder_8_ladder_2 = (_1180 + (((((((spvUnpackHalf2x16(_1218).x * _746) + (spvUnpackHalf2x16(_1198).x * _736)) + (spvUnpackHalf2x16(_1241).x * _737)) + (spvUnpackHalf2x16(_1264).x * _747)) + (spvUnpackHalf2x16(_1287).x * _738)) + (spvUnpackHalf2x16(_1310).x * _748)) * _1189)) * _1331;
                }
                else
                {
                    float _456 = float(int(_159));
                    float _288 = (min(max(float(int(_311)) * 4.0f, 0.0f), _456) / _456) * 255.0f;
                    frontier_phi_4_6_ladder_8_ladder = 0.0f;
                    frontier_phi_4_6_ladder_8_ladder_1 = 255.0f - _288;
                    frontier_phi_4_6_ladder_8_ladder_2 = _288;
                }
                frontier_phi_4_6_ladder = frontier_phi_4_6_ladder_8_ladder;
                frontier_phi_4_6_ladder_1 = frontier_phi_4_6_ladder_8_ladder_1;
                frontier_phi_4_6_ladder_2 = frontier_phi_4_6_ladder_8_ladder_2;
            }
            else
            {
                frontier_phi_4_6_ladder = 0.0f;
                frontier_phi_4_6_ladder_1 = 0.0f;
                frontier_phi_4_6_ladder_2 = 0.0f;
            }
            _287 = frontier_phi_4_6_ladder_2;
            _290 = frontier_phi_4_6_ladder_1;
            _293 = frontier_phi_4_6_ladder;
        }
        else
        {
            _287 = 0.0f;
            _290 = 0.0f;
            _293 = 0.0f;
        }
        _274 = (_287 * 64.0f) * _39_m0[6u].z;
        _276 = (_290 * 64.0f) * _39_m0[6u].z;
        _278 = _39_m0[6u].z * _293;
    }
    else
    {
        _274 = 0.0f;
        _276 = 0.0f;
        _278 = 0.0f;
    }
    SV_Target.x = min(2.f, _274);
    SV_Target.y = min(2.f, _276);
    SV_Target.z = min(2.f, _278);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
