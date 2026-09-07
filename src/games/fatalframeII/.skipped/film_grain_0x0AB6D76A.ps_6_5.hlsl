Texture2D<float4> sStage0 : register(t0);

Texture2D<float4> sStage1 : register(t1);

cbuffer $Globals : register(b0) {
    int BlendTexture1BlendModeOfColor : packoffset(c000.x);
    int BlendTexture1BlendModeOfAlpha : packoffset(c000.y);
    float SaturationScale : packoffset(c000.z);
    float Gamma : packoffset(c000.w);
    int ContrastValuesOfTexture[3] : packoffset(c001.x);
    float vATest : packoffset(c003.y);
};

SamplerState __smpsStage0 : register(s0);

SamplerState __smpsStage1 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
    return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
    return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    precise noperspective float4 SV_Position : SV_Position,
    linear float4 TEXCOORD : TEXCOORD,
    linear float4 TEXCOORD_1 : TEXCOORD1) : SV_Target {
    float4 SV_Target;
    float4 _12;
    float _34;
    float _35;
    float _36;
    float _81;
    float _82;
    float _83;
    float _111;
    float _112;
    float _113;
    float _50;
    float _67;
    float4 _86;
    float _91;
    float _92;
    float _93;
    float _95;
    float _100;
    _12 = sStage0.Sample(__smpsStage0, float2(TEXCOORD_1.x, TEXCOORD_1.y));
    if (Gamma != 1.0f) {
        _34 = exp2(log2(abs(_12.x)) * Gamma);
        _35 = exp2(log2(abs(_12.y)) * Gamma);
        _36 = exp2(log2(abs(_12.z)) * Gamma);
    } else {
        _34 = _12.x;
        _35 = _12.y;
        _36 = _12.z;
    }
    if (!((ContrastValuesOfTexture[0]) == 0)) {
        if ((int)(ContrastValuesOfTexture[0]) > (int)0) {
            _50 = (exp2(log2(abs(float((int)(ContrastValuesOfTexture[0])) * 0.007874015718698502f)) * 3.0303030014038086f) * 7.0f) + 1.0f;
            _81 = saturate((_50 * (_34 + -0.5f)) + 0.5f);
            _82 = saturate((_50 * (_35 + -0.5f)) + 0.5f);
            _83 = saturate((_50 * (_36 + -0.5f)) + 0.5f);
        } else {
            _67 = 1.0f - (abs(float((int)(ContrastValuesOfTexture[0]))) * 0.007874015718698502f);
            _81 = saturate((_67 * (_34 + -0.5f)) + 0.5f);
            _82 = saturate((_67 * (_35 + -0.5f)) + 0.5f);
            _83 = saturate((_67 * (_36 + -0.5f)) + 0.5f);
        }
    } else {
        _81 = _34;
        _82 = _35;
        _83 = _36;
    }
    _86 = sStage1.Sample(__smpsStage1, float2(TEXCOORD_1.w, TEXCOORD_1.z));
    if (_86.w == 0.0f) {
        if (true) discard;
    }
    _91 = _81 * TEXCOORD.x;
    _92 = _82 * TEXCOORD.y;
    _93 = _83 * TEXCOORD.z;
    _95 = (_12.w * TEXCOORD.w) * _86.w;
    if (SaturationScale != 1.0f) {
        _100 = dot(float3(_91, _92, _93), float3(0.298909991979599f, 0.5866100192070007f, 0.11448000371456146f));
        _111 = (lerp(_100, _91, SaturationScale));
        _112 = (lerp(_100, _92, SaturationScale));
        _113 = (lerp(_100, _93, SaturationScale));
    } else {
        _111 = _91;
        _112 = _92;
        _113 = _93;
    }
    if (_95 < vATest) {
        if (true) discard;
    }
    SV_Target.x = _111;
    SV_Target.y = _112;
    SV_Target.z = _113;
    SV_Target.w = _95;
    return SV_Target;
}