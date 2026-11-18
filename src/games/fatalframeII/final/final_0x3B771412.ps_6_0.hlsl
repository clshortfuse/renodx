#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
    float4 $Globals_000 : packoffset(c000.x);
    float4 $Globals_016 : packoffset(c001.x);
    float4 $Globals_032 : packoffset(c002.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
    return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
    return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position : SV_Position,
    linear float2 TEXCOORD : TEXCOORD) : SV_Target {
    float4 SV_Target;
    float4 _8;
    float _15;
    float _18;
    float _21;
    float _22;
    float _31;
    float _32;
    float _33;
    float _45;
    float _49;
    float _53;
    float _60;
    float _61;
    float _62;
    float _63;
    float _81;
    float _85;
    float _89;
    float _93;
    float _98;
    float _111;
    float _112;
    float _113;
    float _106;
    float _125;
    float _128;
    float _131;
    _8 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
    SV_Target = renodx::draw::SwapChainPass(_8);
    return SV_Target;
    _15 = mad(0.043299999088048935f, _8.z, mad(0.3292999863624573f, _8.y, (_8.x * 0.6273999810218811f)));
    _18 = mad(0.01140000019222498f, _8.z, mad(0.9194999933242798f, _8.y, (_8.x * 0.06909999996423721f)));
    _21 = mad(0.8956000208854675f, _8.z, mad(0.08799999952316284f, _8.y, (_8.x * 0.01640000008046627f)));
    _22 = dot(float3(_15, _18, _21), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f));
    _31 = (($Globals_000.y) * (_15 - _22)) + _22;
    _32 = (($Globals_000.y) * (_18 - _22)) + _22;
    _33 = (($Globals_000.y) * (_21 - _22)) + _22;
    _45 = select((_31 <= 1.0f), (((float4)(t1.Sample(s1, float2(((_31 * ($Globals_000.z)) + ($Globals_000.w)), 0.5f)))).x), _31);
    _49 = select((_32 <= 1.0f), (((float4)(t1.Sample(s1, float2(((_32 * ($Globals_000.z)) + ($Globals_000.w)), 0.5f)))).y), _32);
    _53 = select((_33 <= 1.0f), (((float4)(t1.Sample(s1, float2(((_33 * ($Globals_000.z)) + ($Globals_000.w)), 0.5f)))).z), _33);
    _60 = max(((($Globals_032.y) * dot(float3(_45, _49, _53), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f))) + ($Globals_032.x)), 1.0f);
    _61 = _60 * _45;
    _62 = _60 * _49;
    _63 = _60 * _53;
    _81 = ($Globals_000.x) + -1.0f;
    _85 = exp2(_81 * log2(saturate(_61 / (max((_61 + -0.5f), 0.0f) + 1.0f)))) * _61;
    _89 = exp2(log2(saturate(_62 / (max((_62 + -0.5f), 0.0f) + 1.0f))) * _81) * _62;
    _93 = exp2(log2(saturate(_63 / (max((_63 + -0.5f), 0.0f) + 1.0f))) * _81) * _63;
    _98 = ((_89 * 0.5866109728813171f) + (_85 * 0.298911988735199f)) + (_93 * 0.11447799950838089f);
    if (_98 > 1.0f) {
        _106 = ((($Globals_016.y) * _98) + ($Globals_016.z)) / _98;
        _111 = (_106 * _85);
        _112 = (_106 * _89);
        _113 = (_106 * _93);
    } else {
        _111 = _85;
        _112 = _89;
        _113 = _93;
    }
    _125 = exp2(log2((_111 * 0.009999999776482582f) * ($Globals_016.x)) * 0.1593019962310791f);
    _128 = exp2(log2((_112 * 0.009999999776482582f) * ($Globals_016.x)) * 0.1593019962310791f);
    _131 = exp2(log2((_113 * 0.009999999776482582f) * ($Globals_016.x)) * 0.1593019962310791f);
    SV_Target.x = exp2(log2(((_125 * 18.851558685302734f) + 0.8359370231628418f) / ((_125 * 18.6875f) + 1.0f)) * 78.84375762939453f);
    SV_Target.y = exp2(log2(((_128 * 18.851558685302734f) + 0.8359370231628418f) / ((_128 * 18.6875f) + 1.0f)) * 78.84375762939453f);
    SV_Target.z = exp2(log2(((_131 * 18.851558685302734f) + 0.8359370231628418f) / ((_131 * 18.6875f) + 1.0f)) * 78.84375762939453f);
    SV_Target.w = (_8.w * 0.009999999776482582f);
    return SV_Target;
}