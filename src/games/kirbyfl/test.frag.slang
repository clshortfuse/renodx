struct type_cpost_processing_desc_cb_type {
    int viewport_width;
    int viewport_height;
    int oetf_id;
    float4 src_frame_to_dynamic_scale;
};

[[vk::binding(0, 9)]]
ConstantBuffer<type_cpost_processing_desc_cb_type> cpost_processing_desc_cb : register(b0, space9);

[[vk::binding(1, 0)]]
SamplerState SamplerLinearClamp : register(s1, space0);

[[vk::binding(0, 5)]]
Texture2D<float4> source_sampler : register(t0, space5);

float4 main(float4 fragCoord : SV_Position) : SV_Target0
{
    float2 sourceUv = min(
        (fragCoord.xy / float2(float(cpost_processing_desc_cb.viewport_width), float(cpost_processing_desc_cb.viewport_height)))
            * cpost_processing_desc_cb.src_frame_to_dynamic_scale.xy,
        cpost_processing_desc_cb.src_frame_to_dynamic_scale.zw);
    float4 _87 = source_sampler.SampleLevel(SamplerLinearClamp, sourceUv, 0.0);
    float4 _191;
    if (cpost_processing_desc_cb.oetf_id == 0)
    {
        float3 _95 = clamp(_87.xyz, float3(0.0), float3(1.0));
        float _96 = _95.x;
        float _105;
        if (_96 > 0.003130800090730190277099609375)
        {
            _105 = (1.05499994754791259765625 * pow(_96, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
        }
        else
        {
            _105 = 12.9200000762939453125 * _96;
        }
        float _106 = _95.y;
        float _115;
        if (_106 > 0.003130800090730190277099609375)
        {
            _115 = (1.05499994754791259765625 * pow(_106, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
        }
        else
        {
            _115 = 12.9200000762939453125 * _106;
        }
        float _116 = _95.z;
        float _125;
        if (_116 > 0.003130800090730190277099609375)
        {
            _125 = (1.05499994754791259765625 * pow(_116, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
        }
        else
        {
            _125 = 12.9200000762939453125 * _116;
        }
        float3 _126 = float3(_105, _115, _125);
        _191 = float4(_126.x, _126.y, _126.z, _87.w);
    }
    else
    {
        float4 _190;
        if (cpost_processing_desc_cb.oetf_id == 1)
        {
            float3 m0 = float3(0.6274039745330810546875, 0.329281985759735107421875, 0.043313600122928619384765625);
            float3 m1 = float3(0.06909699738025665283203125, 0.919539988040924072265625, 0.0113612003624439239501953125);
            float3 m2 = float3(0.01639159955084323883056640625, 0.0880132019519805908203125, 0.895595014095306396484375);
            float3 _in = _87.xyz;
            float3 _xform = float3(dot(_in, m0), dot(_in, m1), dot(_in, m2));
            float3 _136 = pow(clamp(_xform * 0.008000000379979610443115234375, float3(0.0), float3(1.0)), float3(0.1593017578125));
            float3 _142 = pow((float3(0.8359375) + (_136 * 18.8515625)) / (float3(1.0) + (_136 * 18.6875)), float3(78.84375));
            _190 = float4(_142.x, _142.y, _142.z, _87.w);
        }
        else
        {
            float4 _189;
            if (cpost_processing_desc_cb.oetf_id == 2)
            {
                _189 = float4(_87.x, _87.y, _87.z, _87.w);
            }
            else
            {
                float4 _188;
                if (cpost_processing_desc_cb.oetf_id == 3)
                {
                    _188 = float4(_87.x, _87.y, _87.z, _87.w);
                }
                else
                {
                    float3 _155 = clamp(_87.xyz, float3(0.0), float3(1.0));
                    float _156 = _155.x;
                    float _165;
                    if (_156 > 0.003130800090730190277099609375)
                    {
                        _165 = (1.05499994754791259765625 * pow(_156, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
                    }
                    else
                    {
                        _165 = 12.9200000762939453125 * _156;
                    }
                    float _166 = _155.y;
                    float _175;
                    if (_166 > 0.003130800090730190277099609375)
                    {
                        _175 = (1.05499994754791259765625 * pow(_166, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
                    }
                    else
                    {
                        _175 = 12.9200000762939453125 * _166;
                    }
                    float _176 = _155.z;
                    float _185;
                    if (_176 > 0.003130800090730190277099609375)
                    {
                        _185 = (1.05499994754791259765625 * pow(_176, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
                    }
                    else
                    {
                        _185 = 12.9200000762939453125 * _176;
                    }
                    float3 _186 = float3(_165, _175, _185);
                    _188 = float4(_186.x, _186.y, _186.z, _87.w);
                }
                _189 = _188;
            }
            _190 = _189;
        }
        _191 = _190;
    }

    return _191;
}

