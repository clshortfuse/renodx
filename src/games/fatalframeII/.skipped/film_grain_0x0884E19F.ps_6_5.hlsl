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
    float _108;
    float _109;
    float _110;
    float _155;
    float _156;
    float _157;
    float _268;
    float _269;
    float _270;
    float _277;
    float _296;
    float _297;
    float _298;
    float _50;
    float _67;
    float4 _86;
    float _124;
    float _141;
    float _278;
    float _279;
    float _280;
    float _281;
    float _285;
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
    if (Gamma != 1.0f) {
        _108 = exp2(log2(abs(_86.x)) * Gamma);
        _109 = exp2(log2(abs(_86.y)) * Gamma);
        _110 = exp2(log2(abs(_86.z)) * Gamma);
    } else {
        _108 = _86.x;
        _109 = _86.y;
        _110 = _86.z;
    }
    if (!(($Globals_002x) == 0)) {
        if ((int)($Globals_002x) > (int)0) {
            _124 = (exp2(log2(abs(float((int)($Globals_002x)) * 0.007874015718698502f)) * 3.0303030014038086f) * 7.0f) + 1.0f;
            _155 = saturate((_124 * (_108 + -0.5f)) + 0.5f);
            _156 = saturate((_124 * (_109 + -0.5f)) + 0.5f);
            _157 = saturate((_124 * (_110 + -0.5f)) + 0.5f);
        } else {
            _141 = 1.0f - (abs(float((int)($Globals_002x))) * 0.007874015718698502f);
            _155 = saturate((_141 * (_108 + -0.5f)) + 0.5f);
            _156 = saturate((_141 * (_109 + -0.5f)) + 0.5f);
            _157 = saturate((_141 * (_110 + -0.5f)) + 0.5f);
        }
    } else {
        _155 = _108;
        _156 = _109;
        _157 = _110;
    }
    if (BlendTexture1BlendModeOfColor == 2) {
        _268 = (lerp(_81, _155, _86.w));
        _269 = (lerp(_82, _156, _86.w));
        _270 = (lerp(_83, _157, _86.w));
    } else {
        if (BlendTexture1BlendModeOfColor == 3) {
            _268 = (_155 * _81);
            _269 = (_156 * _82);
            _270 = (_157 * _83);
        } else {
            if (BlendTexture1BlendModeOfColor == 1) {
                _268 = saturate((_155 * _86.w) + (_81 * _12.w));
                _269 = saturate((_156 * _86.w) + (_82 * _12.w));
                _270 = saturate((_157 * _86.w) + (_83 * _12.w));
            } else {
                if (!(BlendTexture1BlendModeOfColor == 4)) {
                    if (BlendTexture1BlendModeOfColor == 5) {
                        _268 = saturate((_81 * _12.w) - (_155 * _86.w));
                        _269 = saturate((_82 * _12.w) - (_156 * _86.w));
                        _270 = saturate((_83 * _12.w) - (_157 * _86.w));
                    } else {
                        if (BlendTexture1BlendModeOfColor == 6) {
                            _268 = saturate((_81 * 2.0f) * _155);
                            _269 = saturate((_82 * 2.0f) * _156);
                            _270 = saturate((_83 * 2.0f) * _157);
                        } else {
                            if (BlendTexture1BlendModeOfColor == 7) {
                                _268 = saturate(_81 / (1.0f - _155));
                                _269 = saturate(_82 / (1.0f - _156));
                                _270 = saturate(_83 / (1.0f - _157));
                            } else {
                                if (BlendTexture1BlendModeOfColor == 8) {
                                    _268 = saturate(1.0f - ((1.0f - _81) / _155));
                                    _269 = saturate(1.0f - ((1.0f - _82) / _156));
                                    _270 = saturate(1.0f - ((1.0f - _83) / _157));
                                } else {
                                    if (BlendTexture1BlendModeOfColor == 9) {
                                        _268 = saturate((_155 + _81) - ((_81 * 2.0f) * _155));
                                        _269 = saturate((_156 + _82) - ((_82 * 2.0f) * _156));
                                        _270 = saturate((_157 + _83) - ((_83 * 2.0f) * _157));
                                    } else {
                                        _268 = _81;
                                        _269 = _82;
                                        _270 = _83;
                                    }
                                }
                            }
                        }
                    }
                } else {
                    _268 = _155;
                    _269 = _156;
                    _270 = _157;
                }
            }
        }
    }
    if (BlendTexture1BlendModeOfAlpha == 0) {
        _277 = max(_12.w, _86.w);
    } else {
        _277 = min(_12.w, _86.w);
    }
    _278 = _268 * TEXCOORD.x;
    _279 = _269 * TEXCOORD.y;
    _280 = _270 * TEXCOORD.z;
    _281 = _277 * TEXCOORD.w;
    if (SaturationScale != 1.0f) {
        _285 = dot(float3(_278, _279, _280), float3(0.298909991979599f, 0.5866100192070007f, 0.11448000371456146f));
        _296 = (lerp(_285, _278, SaturationScale));
        _297 = (lerp(_285, _279, SaturationScale));
        _298 = (lerp(_285, _280, SaturationScale));
    } else {
        _296 = _278;
        _297 = _279;
        _298 = _280;
    }
    if (_281 < vATest) {
        if (true) discard;
    }
    SV_Target.x = _296;
    SV_Target.y = _297;
    SV_Target.z = _298;
    SV_Target.w = _281;
    return SV_Target;
}