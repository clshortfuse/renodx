#include "../shared.h"

cbuffer UniformBufferConstants_ViewUBO : register(b0, space0)
{
    float4 UniformBufferConstants_View_m0[339] : packoffset(c0);
};

/*
DeferredLightUniforms_ShadowMapChannelMask 0.00, 0.00, 0.00, 0.00 0 float4 
DeferredLightUniforms_DistanceFadeMAD 0.00, 0.00 16 float2
DeferredLightUniforms_ContactShadowLength 0.00 24 float
DeferredLightUniforms_ContactShadowCastingIntensity 1.00 28 float
DeferredLightUniforms_ContactShadowNonCastingIntensity 0.00 32 float
DeferredLightUniforms_VolumetricScatteringIntensity 0.00 36 float
DeferredLightUniforms_ShadowedBits 0 40 int
DeferredLightUniforms_LightingChannelMask 2 44 int
DeferredLightUniforms_TranslatedWorldPosition 640.25159, -518.99756, 159.70648 48 float3
DeferredLightUniforms_InvRadius 0.00033 60 float
DeferredLightUniforms_Color 5268.51563, 6912.37305, 8822.00293 64 float3
DeferredLightUniforms_FalloffExponent 2.00 76 float
DeferredLightUniforms_Direction 0.46985, -0.8138, 0.34202 80 float3
DeferredLightUniforms_SpecularScale 1.00 92 float
DeferredLightUniforms_Tangent - 0.17101, 0.2962, 0.93969 96 float3
DeferredLightUniforms_SourceRadius 0.00 108 float
DeferredLightUniforms_SpotAngles 0.17365, 3.06418 112 float2
DeferredLightUniforms_SoftSourceRadius 0.00 120 float
DeferredLightUniforms_SourceLength 0.00 124 float
DeferredLightUniforms_RectLightBarnCosAngle 0.00 128 float
DeferredLightUniforms_RectLightBarnLength - 2.00 132 float
DeferredLightUniforms_RectLightAtlasUVOffset 0.00, 0.00 136 float2
DeferredLightUniforms_RectLightAtlasUVScale 0.00, 0.00 144 float2
DeferredLightUniforms_RectLightAtlasMaxLevel 32.00 152 float
DeferredLightUniforms_IESAtlasIndex - 1.00 156 float
*/                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    cbuffer UniformBufferConstants_DeferredLightUniformsUBO : register(b1, space0)
{
    float4 UniformBufferConstants_DeferredLightUniforms_m0[10] : packoffset(c0);
};

Texture2D<float4> View_PreIntegratedBRDF : register(t0, space0);
Texture3D<float4> View_HairScatteringLUTTexture : register(t1, space0);
Texture2D<float4> View_SSProfilesTexture : register(t2, space0);
Texture2D<float4> SceneTexturesStruct_SceneDepthTexture : register(t3, space0);
Texture2D<float4> SceneTexturesStruct_GBufferATexture : register(t4, space0);
Texture2D<float4> SceneTexturesStruct_GBufferBTexture : register(t5, space0);
Texture2D<float4> SceneTexturesStruct_GBufferCTexture : register(t6, space0);
Texture2D<float4> SceneTexturesStruct_GBufferDTexture : register(t7, space0);
Texture2D<float4> SceneTexturesStruct_GBufferETexture : register(t8, space0);
Texture2D<float4> SceneTexturesStruct_GBufferFTexture : register(t9, space0);
Texture2D<float4> SceneTexturesStruct_ScreenSpaceAOTexture : register(t10, space0);
Texture2D<float4> LightAttenuationTexture : register(t11, space0);
Texture2D<uint4> LightingChannelsTexture : register(t12, space0);
SamplerState View_PreIntegratedBRDFSampler : register(s0, space0);
SamplerState View_HairScatteringLUTSampler : register(s1, space0);
SamplerState SceneTexturesStruct_PointClampSampler : register(s2, space0);
SamplerState LightAttenuationTextureSampler : register(s3, space0);

static float4 gl_FragCoord;
static float4 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float4 TEXCOORD : TEXCOORD0;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
    float _62 = TEXCOORD.x / TEXCOORD.w;
    float _63 = TEXCOORD.y / TEXCOORD.w;
    float _74 = (UniformBufferConstants_View_m0[72u].x * _62) + UniformBufferConstants_View_m0[72u].w;
    float _75 = (UniformBufferConstants_View_m0[72u].y * _63) + UniformBufferConstants_View_m0[72u].z;
    float4 _81 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_74, _75), 0.0f);
    float _84 = _81.x;
    float _98 = ((UniformBufferConstants_View_m0[71u].x * _84) + UniformBufferConstants_View_m0[71u].y) + (1.0f / ((UniformBufferConstants_View_m0[71u].z * _84) - UniformBufferConstants_View_m0[71u].w));
    float4 _101 = SceneTexturesStruct_GBufferFTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_74, _75), 0.0f);
    float _103 = _101.x;
    float _106 = _101.w;
    float4 _109 = SceneTexturesStruct_GBufferATexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_74, _75), 0.0f);
    float4 _116 = SceneTexturesStruct_GBufferBTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_74, _75), 0.0f);
    float _118 = _116.x;
    float _119 = _116.y;
    float _120 = _116.z;
    float4 _124 = SceneTexturesStruct_GBufferCTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_74, _75), 0.0f);
    float _126 = _124.x;
    float _127 = _124.y;
    float _128 = _124.z;
    float4 _131 = SceneTexturesStruct_GBufferDTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_74, _75), 0.0f);
    float4 _139 = SceneTexturesStruct_GBufferETexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_74, _75), 0.0f);
    uint _152 = uint(UniformBufferConstants_View_m0[132u].x * _74);
    uint _153 = uint(UniformBufferConstants_View_m0[132u].y * _75);
    bool _163 = (((_152 + _153) + uint(UniformBufferConstants_View_m0[153u].x)) & 1u) != 0u;
    uint _168 = uint((_116.w * 255.0f) + 0.5f);
    uint _169 = _168 & 15u;
    uint _171 = _168 >> 4u;
    float _177 = (_109.x * 2.0f) + (-1.0f);
    float _179 = (_109.y * 2.0f) + (-1.0f);
    float _180 = (_109.z * 2.0f) + (-1.0f);
    uint _181 = _168 & 14u;
    bool _183 = _181 == 2u;
    bool _192 = _169 == 13u;
    bool _194 = _192 || ((_181 == 8u) || (((_168 & 12u) == 4u) || _183));
    float _195 = _194 ? _131.x : 0.0f;
    float _196 = _194 ? _131.y : 0.0f;
    float _197 = _194 ? _131.z : 0.0f;
    float _198 = _194 ? _131.w : 0.0f;
    float _201;
    float _203;
    float _204;
    float _205;
    if ((_171 & 2u) == 0u)
    {
        _201 = _139.x;
        _203 = _139.y;
        _204 = _139.z;
        _205 = _139.w;
    }
    else
    {
        float _202 = ((_171 & 4u) != 0u) ? 0.0f : 1.0f;
        _201 = _202;
        _203 = _202;
        _204 = _202;
        _205 = _202;
    }
    float _213 = rsqrt(dot(float3(_177, _179, _180), float3(_177, _179, _180)));
    float _214 = _213 * _177;
    float _215 = _213 * _179;
    float _216 = _213 * _180;
    bool _217 = _169 == 9u;
    float _219 = _217 ? 0.0f : _118;
    float _220 = _119 * 0.07999999821186065673828125f;
    float _228 = (_219 * (_126 - _220)) + _220;
    float _229 = (_219 * (_127 - _220)) + _220;
    float _230 = (_219 * (_128 - _220)) + _220;
    bool _233 = (_169 == 5u) || _217;
    float _241;
    float _243;
    float _245;
    float _247;
    float _250;
    float _252;
    float _254;
    if (_233)
    {
        bool _293;
        if (UniformBufferConstants_View_m0[247u].w > 0.0f)
        {
            _293 = UniformBufferConstants_View_m0[228u].z > 0.0f;
        }
        else
        {
            _293 = false;
        }
        bool _295 = UniformBufferConstants_View_m0[247u].w != 0.0f;
        float frontier_phi_4_6_ladder;
        float frontier_phi_4_6_ladder_1;
        float frontier_phi_4_6_ladder_2;
        float frontier_phi_4_6_ladder_3;
        float frontier_phi_4_6_ladder_4;
        float frontier_phi_4_6_ladder_5;
        float frontier_phi_4_6_ladder_6;
        if (_293)
        {
            float _248 = float(_163);
            float _337 = float(!_163);
            frontier_phi_4_6_ladder = _248;
            frontier_phi_4_6_ladder_1 = _337 * _228;
            frontier_phi_4_6_ladder_2 = _337 * _229;
            frontier_phi_4_6_ladder_3 = _337 * _230;
            frontier_phi_4_6_ladder_4 = _248;
            frontier_phi_4_6_ladder_5 = _248;
            frontier_phi_4_6_ladder_6 = _337 * _119;
        }
        else
        {
            frontier_phi_4_6_ladder = _295 ? 1.0f : _126;
            frontier_phi_4_6_ladder_1 = _228;
            frontier_phi_4_6_ladder_2 = _229;
            frontier_phi_4_6_ladder_3 = _230;
            frontier_phi_4_6_ladder_4 = _295 ? 1.0f : _127;
            frontier_phi_4_6_ladder_5 = _295 ? 1.0f : _128;
            frontier_phi_4_6_ladder_6 = _119;
        }
        _241 = frontier_phi_4_6_ladder_1;
        _243 = frontier_phi_4_6_ladder_2;
        _245 = frontier_phi_4_6_ladder_3;
        _247 = frontier_phi_4_6_ladder;
        _250 = frontier_phi_4_6_ladder_4;
        _252 = frontier_phi_4_6_ladder_5;
        _254 = frontier_phi_4_6_ladder_6;
    }
    else
    {
        _241 = _228;
        _243 = _229;
        _245 = _230;
        _247 = _126;
        _250 = _127;
        _252 = _128;
        _254 = _119;
    }
    float _272 = (UniformBufferConstants_View_m0[137u].w * (_247 - (_247 * _219))) + UniformBufferConstants_View_m0[137u].x;
    float _273 = (UniformBufferConstants_View_m0[137u].w * (_250 - (_250 * _219))) + UniformBufferConstants_View_m0[137u].y;
    float _274 = (UniformBufferConstants_View_m0[137u].w * (_252 - (_252 * _219))) + UniformBufferConstants_View_m0[137u].z;
    float _285 = (UniformBufferConstants_View_m0[138u].w * _241) + UniformBufferConstants_View_m0[138u].x;
    float _286 = (UniformBufferConstants_View_m0[138u].w * _243) + UniformBufferConstants_View_m0[138u].y;
    float _287 = (UniformBufferConstants_View_m0[138u].w * _245) + UniformBufferConstants_View_m0[138u].z;
    float _338;
    float _340;
    float _342;
    float _344;
    float _346;
    if (_192)
    {
        float _296 = dot(float3(_103, _101.yz), float3(1.0f, 0.0039215688593685626983642578125f, 1.5378700481960549950599670410156e-05f));
        float _306 = (dot(float3(_195, _196, _197), float3(1.0f, 0.0039215688593685626983642578125f, 1.5378700481960549950599670410156e-05f)) * 6.283185482025146484375f) + (-3.1415927410125732421875f);
        float _310 = cos(_306) * _296;
        float _311 = sin(_306) * _296;
        bool _312 = _198 >= 0.5f;
        float _325 = sqrt(max(1.0f - dot(float2(_310, _311), float2(_310, _311)), 0.0f)) * (_312 ? (-1.0f) : 1.0f);
        float _332 = rsqrt(dot(float3(_310, _311, _325), float3(_310, _311, _325)));
        _338 = _332 * _310;
        _340 = _332 * _311;
        _342 = _332 * _325;
        _344 = ((_312 ? (_198 + (-0.5f)) : _198) * 4.01574802398681640625f) + (-1.0f);
        _346 = _106 * 10.0f;
    }
    else
    {
        float frontier_phi_10_8_ladder;
        float frontier_phi_10_8_ladder_1;
        float frontier_phi_10_8_ladder_2;
        float frontier_phi_10_8_ladder_3;
        float frontier_phi_10_8_ladder_4;
        if ((_171 & 1u) == 0u)
        {
            frontier_phi_10_8_ladder = 0.0f;
            frontier_phi_10_8_ladder_1 = 0.0f;
            frontier_phi_10_8_ladder_2 = 0.0f;
            frontier_phi_10_8_ladder_3 = 0.0f;
            frontier_phi_10_8_ladder_4 = 0.0f;
        }
        else
        {
            float _356 = (_103 * 2.0f) + (-1.0f);
            float _357 = (_101.y * 2.0f) + (-1.0f);
            float _358 = (_101.z * 2.0f) + (-1.0f);
            float _363 = rsqrt(dot(float3(_356, _357, _358), float3(_356, _357, _358)));
            frontier_phi_10_8_ladder = 0.0f;
            frontier_phi_10_8_ladder_1 = (_106 * 2.0f) + (-1.0f);
            frontier_phi_10_8_ladder_2 = _363 * _358;
            frontier_phi_10_8_ladder_3 = _363 * _357;
            frontier_phi_10_8_ladder_4 = _363 * _356;
        }
        _338 = frontier_phi_10_8_ladder_4;
        _340 = frontier_phi_10_8_ladder_3;
        _342 = frontier_phi_10_8_ladder_2;
        _344 = frontier_phi_10_8_ladder_1;
        _346 = frontier_phi_10_8_ladder;
    }
    float _364;
    float _366;
    float _368;
    float _370;
    if (_169 == 0u)
    {
        _364 = 0.0f;
        _366 = 0.0f;
        _368 = 0.0f;
        _370 = 0.0f;
    }
    else
    {
        uint4 _387 = LightingChannelsTexture.Load(int3(uint2(_152, _153), 0u));
        uint _390 = _387.x;
        uint4 _393 = asuint(UniformBufferConstants_DeferredLightUniforms_m0[2u]);
        uint _394 = _393.w;
        float frontier_phi_12_13_ladder;
        float frontier_phi_12_13_ladder_1;
        float frontier_phi_12_13_ladder_2;
        float frontier_phi_12_13_ladder_3;
        if ((_394 & _390) == 0u)
        {
            frontier_phi_12_13_ladder = 0.0f;
            frontier_phi_12_13_ladder_1 = 0.0f;
            frontier_phi_12_13_ladder_2 = 0.0f;
            frontier_phi_12_13_ladder_3 = 0.0f;
        }
        else
        {
            float _402 = (UniformBufferConstants_View_m0[35u].w < 1.0f) ? _98 : 1.0f;
            float _403 = _402 * _62;
            float _404 = _402 * _63;
            float _432 = mad(_98, UniformBufferConstants_View_m0[58u].x, mad(_404, UniformBufferConstants_View_m0[57u].x, _403 * UniformBufferConstants_View_m0[56u].x)) + UniformBufferConstants_View_m0[59u].x;
            float _436 = mad(_98, UniformBufferConstants_View_m0[58u].y, mad(_404, UniformBufferConstants_View_m0[57u].y, _403 * UniformBufferConstants_View_m0[56u].y)) + UniformBufferConstants_View_m0[59u].y;
            float _440 = mad(_98, UniformBufferConstants_View_m0[58u].z, mad(_404, UniformBufferConstants_View_m0[57u].z, _403 * UniformBufferConstants_View_m0[56u].z)) + UniformBufferConstants_View_m0[59u].z;
            float _447 = _432 - UniformBufferConstants_View_m0[74u].x;
            float _448 = _436 - UniformBufferConstants_View_m0[74u].y;
            float _449 = _440 - UniformBufferConstants_View_m0[74u].z;
            float _453 = rsqrt(dot(float3(_447, _448, _449), float3(_447, _448, _449)));
            float _454 = _447 * _453;
            float _455 = _448 * _453;
            float _456 = _449 * _453;
            float _492 = abs(UniformBufferConstants_DeferredLightUniforms_m0[1u].z);
            uint _504 = _393.z;
            bool _505 = UniformBufferConstants_DeferredLightUniforms_m0[4u].w == 0.0f;
            float _520;
            float _521;
            float _522;
            if (((_390 & 2u) != 0u) && ((_394 & 3u) == 3u))
            {
                _520 = UniformBufferConstants_View_m0[285u].x * UniformBufferConstants_DeferredLightUniforms_m0[4u].x;
                _521 = UniformBufferConstants_View_m0[285u].y * UniformBufferConstants_DeferredLightUniforms_m0[4u].y;
                _522 = UniformBufferConstants_View_m0[285u].z * UniformBufferConstants_DeferredLightUniforms_m0[4u].z;
                float3 temp = float3(_520, _521, _522) * CUSTOM_HERO_LIGHT_STRENGTH;
                _520 = temp.r;
                _521 = temp.g;
                _522 = temp.b;
            }
            else
            {
                _520 = UniformBufferConstants_DeferredLightUniforms_m0[4u].x;
                _521 = UniformBufferConstants_DeferredLightUniforms_m0[4u].y;
                _522 = UniformBufferConstants_DeferredLightUniforms_m0[4u].z;
            }
            bool _523 = _169 == 7u;
            float _762;
            float _763;
            float _764;
            uint _765;
            float _767;
            float _768;
            float _769;
            uint _770;
            uint _771;
            if (_523 && (_198 > 0.0f))
            {
                float _526 = (-0.0f) - UniformBufferConstants_DeferredLightUniforms_m0[5u].x;
                float _528 = (-0.0f) - UniformBufferConstants_DeferredLightUniforms_m0[5u].y;
                float _529 = (-0.0f) - UniformBufferConstants_DeferredLightUniforms_m0[5u].z;
                float _530 = max(9.9999997473787516355514526367188e-05f, _247);
                float _532 = max(9.9999997473787516355514526367188e-05f, _250);
                float _533 = max(9.9999997473787516355514526367188e-05f, _252);
                float _541 = clamp(abs(dot(float3(_526, _528, _529), float3(_214, _215, _216))), 0.0f, 1.0f);
                float _542 = clamp(_120, 0.0f, 1.0f);
                float4 _548 = View_HairScatteringLUTTexture.SampleLevel(View_HairScatteringLUTSampler, float3(_541, _542, clamp(sqrt(_530), 0.0f, 1.0f)), 0.0f);
                float4 _553 = View_HairScatteringLUTTexture.SampleLevel(View_HairScatteringLUTSampler, float3(_541, _542, clamp(sqrt(_532), 0.0f, 1.0f)), 0.0f);
                float4 _558 = View_HairScatteringLUTTexture.SampleLevel(View_HairScatteringLUTSampler, float3(_541, _542, clamp(sqrt(_533), 0.0f, 1.0f)), 0.0f);
                uint4 _564 = asuint(UniformBufferConstants_View_m0[247u]);
                uint _565 = _564.z;
                float _576 = min(0.9900000095367431640625f, _548.x);
                float _578 = min(0.9900000095367431640625f, _553.x);
                float _579 = min(0.9900000095367431640625f, _558.x);
                float _580 = _576 * _576;
                float _581 = _578 * _578;
                float _582 = _579 * _579;
                float _583 = min(0.9900000095367431640625f, _548.y);
                float _584 = min(0.9900000095367431640625f, _553.y);
                float _585 = min(0.9900000095367431640625f, _558.y);
                float _586 = _583 * _583;
                float _587 = _584 * _584;
                float _588 = _585 * _585;
                float _589 = 1.0f - _580;
                float _590 = 1.0f - _581;
                float _591 = 1.0f - _582;
                float _592 = _583 * _580;
                float _593 = _584 * _581;
                float _594 = _585 * _582;
                float _601 = _589 * _589;
                float _602 = _590 * _590;
                float _603 = _591 * _591;
                float _604 = _601 * _589;
                float _605 = _602 * _590;
                float _606 = _603 * _591;
                float _615 = min(max(_120, 0.180000007152557373046875f), 0.60000002384185791015625f);
                float _617 = _615 * _615;
                float _618 = _615 * 0.5f;
                float _619 = _618 * _618;
                float _620 = _615 * 2.0f;
                float _621 = _620 * _620;
                float _623 = (_578 + _576) + _579;
                float _624 = _576 / _623;
                float _625 = _578 / _623;
                float _626 = _579 / _623;
                float _627 = dot(float3(_617, _619, _621), float3(_624, _625, _626));
                float _630 = _627 * _627;
                float _634 = (asin(min(max(dot(float3(_214, _215, _216), float3(_454, _455, _456)), -1.0f), 1.0f)) + asin(min(max(dot(float3(_214, _215, _216), float3(_526, _528, _529)), -1.0f), 1.0f))) * 0.5f;
                float _635 = dot(float3(-0.070000000298023223876953125f, 0.0350000001490116119384765625f, 0.14000000059604644775390625f), float3(_624, _625, _626));
                float _663 = _635 * _635;
                float _674 = (_584 + _583) + _585;
                float _678 = dot(float3(_617, _619, _621), float3(_583 / _674, _584 / _674, _585 / _674));
                float _691 = sqrt((_678 * _678) + (_630 * 2.0f));
                float _710 = (_678 * 3.0f) + (_627 * 2.0f);
                float _717 = ((((_580 * 0.699999988079071044921875f) + 1.0f) * _583) * ((_691 * _586) + _691)) / (((_586 * _583) * _710) + _583);
                float _718 = ((((_581 * 0.699999988079071044921875f) + 1.0f) * _584) * ((_691 * _587) + _691)) / (((_587 * _584) * _710) + _584);
                float _719 = ((((_582 * 0.699999988079071044921875f) + 1.0f) * _585) * ((_691 * _588) + _691)) / (((_588 * _585) * _710) + _585);
                float _723 = _634 - (((_663 * (((_580 * 4.0f) * _586) + (_601 * 2.0f))) * (1.0f - ((_586 * 2.0f) / _601))) / _604);
                float _731 = _634 - (((_663 * (((_581 * 4.0f) * _587) + (_602 * 2.0f))) * (1.0f - ((_587 * 2.0f) / _602))) / _605);
                float _738 = _634 - (((_663 * (((_582 * 4.0f) * _588) + (_603 * 2.0f))) * (1.0f - ((_588 * 2.0f) / _603))) / _606);
                bool _755 = (_565 & 8u) != 0u;
                _762 = _530;
                _763 = _532;
                _764 = _533;
                _765 = _565 | 32u;
                _767 = _755 ? (((((_592 * _586) / _604) + (_592 / _589)) * 0.445633828639984130859375f) * exp2((((_723 * _723) * (-0.5f)) / ((_717 * _717) + _630)) * 1.44269502162933349609375f)) : 0.0f;
                _768 = _755 ? (((((_593 * _587) / _605) + (_593 / _590)) * 0.445633828639984130859375f) * exp2((((_731 * _731) * (-0.5f)) / ((_718 * _718) + _630)) * 1.44269502162933349609375f)) : 0.0f;
                _769 = _755 ? (((((_594 * _588) / _606) + (_594 / _591)) * 0.445633828639984130859375f) * exp2((((_738 * _738) * (-0.5f)) / ((_719 * _719) + _630)) * 1.44269502162933349609375f)) : 0.0f;
                _770 = 1u;
                _771 = ((_565 >> 6u) & 1u) ^ 1u;
            }
            else
            {
                _762 = _247;
                _763 = _250;
                _764 = _252;
                _765 = 39u;
                _767 = 0.0f;
                _768 = 0.0f;
                _769 = 0.0f;
                _770 = 0u;
                _771 = 1u;
            }
            float _777 = float(asuint(UniformBufferConstants_View_m0[145u]).x);
            float4 _796 = LightAttenuationTexture.SampleLevel(LightAttenuationTextureSampler, float2(_74, _75), 0.0f);
            float _798 = _796.z;
            float _799 = _796.w;
            float _801 = _799 * _799;
            float _802 = (-0.0f) - _454;
            float _803 = (-0.0f) - _455;
            float _804 = (-0.0f) - _456;
            float _805 = UniformBufferConstants_DeferredLightUniforms_m0[3u].x - _432;
            float _806 = UniformBufferConstants_DeferredLightUniforms_m0[3u].y - _436;
            float _807 = UniformBufferConstants_DeferredLightUniforms_m0[3u].z - _440;
            float _808 = dot(float3(_805, _806, _807), float3(_805, _806, _807));
            float _811 = rsqrt(_808);
            float _812 = _811 * _805;
            float _813 = _811 * _806;
            float _814 = _811 * _807;
            float _832;
            if (_505)
            {
                float _816 = (UniformBufferConstants_DeferredLightUniforms_m0[3u].w * UniformBufferConstants_DeferredLightUniforms_m0[3u].w) * _808;
                float _819 = clamp(1.0f - (_816 * _816), 0.0f, 1.0f);
                _832 = _819 * _819;
            }
            else
            {
                float _821 = _805 * UniformBufferConstants_DeferredLightUniforms_m0[3u].w;
                float _822 = _806 * UniformBufferConstants_DeferredLightUniforms_m0[3u].w;
                float _823 = _807 * UniformBufferConstants_DeferredLightUniforms_m0[3u].w;
                _832 = exp2(log2(1.0f - clamp(dot(float3(_821, _822, _823), float3(_821, _822, _823)), 0.0f, 1.0f)) * UniformBufferConstants_DeferredLightUniforms_m0[4u].w);
            }
            float _838 = clamp((dot(float3(_812, _813, _814), float3(UniformBufferConstants_DeferredLightUniforms_m0[5u].xyz)) - UniformBufferConstants_DeferredLightUniforms_m0[7u].x) * UniformBufferConstants_DeferredLightUniforms_m0[7u].y, 0.0f, 1.0f);
            float _840 = (_838 * _838) * _832;
            float _841 = _840 * _520;
            float _842 = _840 * _521;
            float _843 = _840 * _522;
            float _851;
            float _853;
            float _855;
            float _857;
            float _859;
            float _861;
            float _863;
            if (_840 > 0.0f)
            {
                float _849 = UniformBufferConstants_View_m0[41u].y * _98;
                bool _850 = _504 == 0u;
                float _869;
                float _870;
                float _872;
                float _874;
                if (_850)
                {
                    _869 = 1.0f;
                    _870 = 1.0f;
                    _872 = SceneTexturesStruct_ScreenSpaceAOTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_74, _75), 0.0f).x;
                    _874 = 0.0f;
                }
                else
                {
                    float _891 = ((dot(float4(_201, _203, _204, _205), float4(UniformBufferConstants_DeferredLightUniforms_m0[0u])) + (-1.0f)) * dot(float4(UniformBufferConstants_DeferredLightUniforms_m0[0u]), 1.0f.xxxx)) + 1.0f;
                    float _873 = (_798 * _798) * _891;
                    float _871 = _891 * _801;
                    float frontier_phi_24_25_ladder;
                    float frontier_phi_24_25_ladder_1;
                    float frontier_phi_24_25_ladder_2;
                    float frontier_phi_24_25_ladder_3;
                    if ((_492 > 0.0f) && (_504 > 1u))
                    {
                        frontier_phi_24_25_ladder = ((UniformBufferConstants_DeferredLightUniforms_m0[1u].z < 0.0f) ? 1.0f : _849) * _492;
                        frontier_phi_24_25_ladder_1 = _873;
                        frontier_phi_24_25_ladder_2 = _871;
                        frontier_phi_24_25_ladder_3 = _801;
                    }
                    else
                    {
                        frontier_phi_24_25_ladder = 0.0f;
                        frontier_phi_24_25_ladder_1 = _873;
                        frontier_phi_24_25_ladder_2 = _871;
                        frontier_phi_24_25_ladder_3 = _801;
                    }
                    _869 = frontier_phi_24_25_ladder_3;
                    _870 = frontier_phi_24_25_ladder_2;
                    _872 = frontier_phi_24_25_ladder_1;
                    _874 = frontier_phi_24_25_ladder;
                }
                float _881 = _217 ? 0.5f : ((_523 && (_504 < 2u)) ? (_849 * 0.20000000298023223876953125f) : _874);
                float _1006;
                float _1008;
                if (_881 > 0.0f)
                {
                    bool _896 = _523 && _850;
                    float _924 = mad(_440, UniformBufferConstants_View_m0[2u].x, mad(_436, UniformBufferConstants_View_m0[1u].x, UniformBufferConstants_View_m0[0u].x * _432)) + UniformBufferConstants_View_m0[3u].x;
                    float _928 = mad(_440, UniformBufferConstants_View_m0[2u].y, mad(_436, UniformBufferConstants_View_m0[1u].y, UniformBufferConstants_View_m0[0u].y * _432)) + UniformBufferConstants_View_m0[3u].y;
                    float _932 = mad(_440, UniformBufferConstants_View_m0[2u].z, mad(_436, UniformBufferConstants_View_m0[1u].z, UniformBufferConstants_View_m0[0u].z * _432)) + UniformBufferConstants_View_m0[3u].z;
                    float _936 = mad(_440, UniformBufferConstants_View_m0[2u].w, mad(_436, UniformBufferConstants_View_m0[1u].w, UniformBufferConstants_View_m0[0u].w * _432)) + UniformBufferConstants_View_m0[3u].w;
                    float _937 = _881 * _812;
                    float _938 = _881 * _813;
                    float _939 = _881 * _814;
                    float _955 = mad(_939, UniformBufferConstants_View_m0[2u].w, mad(_938, UniformBufferConstants_View_m0[1u].w, UniformBufferConstants_View_m0[0u].w * _937)) + _936;
                    float _956 = _924 / _936;
                    float _957 = _928 / _936;
                    float _958 = _932 / _936;
                    float _964 = ((mad(_939, UniformBufferConstants_View_m0[2u].z, mad(_938, UniformBufferConstants_View_m0[1u].z, UniformBufferConstants_View_m0[0u].z * _937)) + _932) / _955) - _958;
                    float _967 = (UniformBufferConstants_View_m0[72u].x * _956) + UniformBufferConstants_View_m0[72u].w;
                    float _968 = (UniformBufferConstants_View_m0[72u].y * _957) + UniformBufferConstants_View_m0[72u].z;
                    float _969 = UniformBufferConstants_View_m0[72u].x * (((mad(_939, UniformBufferConstants_View_m0[2u].x, mad(_938, UniformBufferConstants_View_m0[1u].x, UniformBufferConstants_View_m0[0u].x * _937)) + _924) / _955) - _956);
                    float _970 = UniformBufferConstants_View_m0[72u].y * (((mad(_939, UniformBufferConstants_View_m0[2u].y, mad(_938, UniformBufferConstants_View_m0[1u].y, UniformBufferConstants_View_m0[0u].y * _937)) + _928) / _955) - _957);
                    float _983 = abs(((mad(_881, UniformBufferConstants_View_m0[34u].z, 0.0f) + _932) / (mad(_881, UniformBufferConstants_View_m0[34u].w, 0.0f) + _936)) - _958) * 0.25f;
                    float _985 = (frac(frac(dot(float2((_777 * 32.66500091552734375f) + gl_FragCoord.x, (_777 * 11.81499958038330078125f) + gl_FragCoord.y), float2(0.067110560834407806396484375f, 0.005837149918079376220703125f))) * 52.98291778564453125f) + (-0.5f)) * 0.125f;
                    float _987 = _985 + 0.125f;
                    float4 _989 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_967, _968), 0.0f);
                    float _991 = _989.x;
                    float4 _998 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2((_969 * _987) + _967, (_970 * _987) + _968), 0.0f);
                    float _1000 = _998.x;
                    bool _1004 = abs((((_964 * _987) + _958) + _983) - _1000) < _983;
                    uint _1013;
                    if (_896)
                    {
                        _1013 = uint(_1004);
                    }
                    else
                    {
                        _1013 = uint(_1004 && (_1000 != _991));
                    }
                    float _1016 = (_1013 != 0u) ? _987 : (-1.0f);
                    float _1017 = _985 + 0.25f;
                    float4 _1025 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2((_969 * _1017) + _967, (_970 * _1017) + _968), 0.0f);
                    float _1027 = _1025.x;
                    bool _1031 = abs((((_964 * _1017) + _958) + _983) - _1027) < _983;
                    uint _1055;
                    if (_896)
                    {
                        _1055 = uint(_1031);
                    }
                    else
                    {
                        _1055 = uint(_1031 && (_1027 != _991));
                    }
                    float _1060 = ((_1016 < 0.0f) && (_1055 != 0u)) ? _1017 : _1016;
                    float _1061 = _985 + 0.375f;
                    float4 _1070 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2((_969 * _1061) + _967, (_970 * _1061) + _968), 0.0f);
                    float _1072 = _1070.x;
                    bool _1076 = abs((((_964 * _1061) + _958) + _983) - _1072) < _983;
                    uint _1111;
                    if (_896)
                    {
                        _1111 = uint(_1076);
                    }
                    else
                    {
                        _1111 = uint(_1076 && (_1072 != _991));
                    }
                    float _1116 = ((_1060 < 0.0f) && (_1111 != 0u)) ? _1061 : _1060;
                    float _1117 = _985 + 0.5f;
                    float4 _1125 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2((_969 * _1117) + _967, (_970 * _1117) + _968), 0.0f);
                    float _1127 = _1125.x;
                    bool _1131 = abs((((_964 * _1117) + _958) + _983) - _1127) < _983;
                    uint _1139;
                    if (_896)
                    {
                        _1139 = uint(_1131);
                    }
                    else
                    {
                        _1139 = uint(_1131 && (_1127 != _991));
                    }
                    float _1144 = ((_1116 < 0.0f) && (_1139 != 0u)) ? _1117 : _1116;
                    float _1145 = _985 + 0.625f;
                    float4 _1154 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2((_969 * _1145) + _967, (_970 * _1145) + _968), 0.0f);
                    float _1156 = _1154.x;
                    bool _1160 = abs((((_964 * _1145) + _958) + _983) - _1156) < _983;
                    uint _1173;
                    if (_896)
                    {
                        _1173 = uint(_1160);
                    }
                    else
                    {
                        _1173 = uint(_1160 && (_1156 != _991));
                    }
                    float _1178 = ((_1144 < 0.0f) && (_1173 != 0u)) ? _1145 : _1144;
                    float _1179 = _985 + 0.75f;
                    float4 _1188 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2((_969 * _1179) + _967, (_970 * _1179) + _968), 0.0f);
                    float _1190 = _1188.x;
                    bool _1194 = abs((((_964 * _1179) + _958) + _983) - _1190) < _983;
                    uint _1257;
                    if (_896)
                    {
                        _1257 = uint(_1194);
                    }
                    else
                    {
                        _1257 = uint(_1194 && (_1190 != _991));
                    }
                    float _1262 = ((_1178 < 0.0f) && (_1257 != 0u)) ? _1179 : _1178;
                    float _1263 = _985 + 0.875f;
                    float4 _1272 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2((_969 * _1263) + _967, (_970 * _1263) + _968), 0.0f);
                    float _1274 = _1272.x;
                    bool _1278 = abs((((_964 * _1263) + _958) + _983) - _1274) < _983;
                    uint _1725;
                    if (_896)
                    {
                        _1725 = uint(_1278);
                    }
                    else
                    {
                        _1725 = uint(_1278 && (_1274 != _991));
                    }
                    float _1730 = ((_1262 < 0.0f) && (_1725 != 0u)) ? _1263 : _1262;
                    float _1731 = _985 + 1.0f;
                    float4 _1739 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2((_969 * _1731) + _967, (_970 * _1731) + _968), 0.0f);
                    float _1741 = _1739.x;
                    bool _1745 = abs((((_964 * _1731) + _958) + _983) - _1741) < _983;
                    uint _2057;
                    if (_896)
                    {
                        _2057 = uint(_1745);
                    }
                    else
                    {
                        _2057 = uint(_1745 && (_1741 != _991));
                    }
                    float _2062 = ((_1730 < 0.0f) && (_2057 != 0u)) ? _1731 : _1730;
                    float _2787;
                    uint _2788;
                    if (_2062 > 0.0f)
                    {
                        float _2756 = (_2062 * _969) + _967;
                        float _2757 = (_2062 * _970) + _968;
                        _2787 = (((_2756 > 0.0f) && (_2756 < 1.0f)) && ((_2757 > 0.0f) && (_2757 < 1.0f))) ? (_2062 * _881) : (-1.0f);
                        _2788 = uint(((uint(SceneTexturesStruct_GBufferATexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_2756, _2757), 0.0f).w * 3.999000072479248046875f) & 1u) != 0u) && ((uint((SceneTexturesStruct_GBufferBTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_2756, _2757), 0.0f).w * 255.0f) + 0.5f) & 15u) != 9u));
                    }
                    else
                    {
                        _2787 = -1.0f;
                        _2788 = 0u;
                    }
                    float frontier_phi_27_127_ladder;
                    float frontier_phi_27_127_ladder_1;
                    if (_2787 > 0.0f)
                    {
                        float _3150 = (_2788 != 0u) ? UniformBufferConstants_DeferredLightUniforms_m0[1u].w : UniformBufferConstants_DeferredLightUniforms_m0[2u].x;
                        float _3739;
                        if (_3150 > 0.0f)
                        {
                            float frontier_phi_170_169_ladder;
                            if ((_169 != 5u) && ((_169 != 9u) && ((_169 != 7u) && (_217 || (_183 || ((_169 + 4294967291u) < 3u))))))
                            {
                                frontier_phi_170_169_ladder = (1.0f - clamp(exp2((_2787 * 0.0500000007450580596923828125f) * log2(1.0f - min(_198, 0.9900000095367431640625f))), 0.0f, 1.0f)) * _3150;
                            }
                            else
                            {
                                frontier_phi_170_169_ladder = _3150;
                            }
                            _3739 = frontier_phi_170_169_ladder;
                        }
                        else
                        {
                            _3739 = _3150;
                        }
                        float _3741 = 1.0f - _3739;
                        frontier_phi_27_127_ladder = _3741 * _870;
                        frontier_phi_27_127_ladder_1 = _3741 * _872;
                    }
                    else
                    {
                        frontier_phi_27_127_ladder = _870;
                        frontier_phi_27_127_ladder_1 = _872;
                    }
                    _1006 = frontier_phi_27_127_ladder;
                    _1008 = frontier_phi_27_127_ladder_1;
                }
                else
                {
                    _1006 = _870;
                    _1008 = _872;
                }
                float frontier_phi_23_27_ladder;
                float frontier_phi_23_27_ladder_1;
                float frontier_phi_23_27_ladder_2;
                float frontier_phi_23_27_ladder_3;
                float frontier_phi_23_27_ladder_4;
                float frontier_phi_23_27_ladder_5;
                float frontier_phi_23_27_ladder_6;
                if ((_1008 + _1006) > 0.0f)
                {
                    float _1035 = UniformBufferConstants_DeferredLightUniforms_m0[7u].w * 0.5f;
                    float _1036 = _1035 * UniformBufferConstants_DeferredLightUniforms_m0[6u].x;
                    float _1037 = _1035 * UniformBufferConstants_DeferredLightUniforms_m0[6u].y;
                    float _1038 = _1035 * UniformBufferConstants_DeferredLightUniforms_m0[6u].z;
                    float _1039 = _805 - _1036;
                    float _1040 = _806 - _1037;
                    float _1041 = _807 - _1038;
                    float _1042 = _1036 + _805;
                    float _1043 = _1037 + _806;
                    float _1044 = _1038 + _807;
                    float _1049 = max(_120, UniformBufferConstants_View_m0[245u].z);
                    bool _1050 = UniformBufferConstants_DeferredLightUniforms_m0[7u].w > 0.0f;
                    float _1051 = dot(float3(_1039, _1040, _1041), float3(_1039, _1040, _1041));
                    float _1054 = rsqrt(_1051);
                    float _1135;
                    float _1136;
                    float _1137;
                    if (_1050)
                    {
                        float _1083 = rsqrt(dot(float3(_1042, _1043, _1044), float3(_1042, _1043, _1044)));
                        float _1084 = _1083 * _1054;
                        float _1088 = dot(float3(_1039, _1040, _1041), float3(_1042, _1043, _1044)) * _1084;
                        _1135 = ((dot(float3(_214, _215, _216), float3(_1042, _1043, _1044)) * _1083) + (dot(float3(_214, _215, _216), float3(_1039, _1040, _1041)) * _1054)) * 0.5f;
                        _1136 = _1084 / ((_1084 + 0.5f) + (_1088 * 0.5f));
                        _1137 = _1088;
                    }
                    else
                    {
                        _1135 = dot(float3(_214, _215, _216), float3(_1054 * _1039, _1054 * _1040, _1054 * _1041));
                        _1136 = 1.0f / (_1051 + 1.0f);
                        _1137 = 1.0f;
                    }
                    float _1169;
                    if (UniformBufferConstants_DeferredLightUniforms_m0[6u].w > 0.0f)
                    {
                        float _1167 = sqrt(clamp((UniformBufferConstants_DeferredLightUniforms_m0[6u].w * UniformBufferConstants_DeferredLightUniforms_m0[6u].w) * _1136, 0.0f, 1.0f));
                        float frontier_phi_42_41_ladder;
                        if (_1135 < _1167)
                        {
                            float _1200 = max(_1135, (-0.0f) - _1167) + _1167;
                            frontier_phi_42_41_ladder = (_1200 * _1200) / (_1167 * 4.0f);
                        }
                        else
                        {
                            frontier_phi_42_41_ladder = _1135;
                        }
                        _1169 = frontier_phi_42_41_ladder;
                    }
                    else
                    {
                        _1169 = _1135;
                    }
                    float _1171 = clamp(_1169, 0.0f, 1.0f);
                    float _1172 = _505 ? _1136 : 1.0f;
                    float _1239;
                    float _1240;
                    float _1241;
                    if (_1050)
                    {
                        float _1206 = dot(float3(_454, _455, _456), float3(_214, _215, _216)) * 2.0f;
                        float _1210 = _454 - (_1206 * _214);
                        float _1211 = _455 - (_1206 * _215);
                        float _1212 = _456 - (_1206 * _216);
                        float _1213 = UniformBufferConstants_DeferredLightUniforms_m0[7u].w * UniformBufferConstants_DeferredLightUniforms_m0[6u].x;
                        float _1214 = UniformBufferConstants_DeferredLightUniforms_m0[7u].w * UniformBufferConstants_DeferredLightUniforms_m0[6u].y;
                        float _1215 = UniformBufferConstants_DeferredLightUniforms_m0[7u].w * UniformBufferConstants_DeferredLightUniforms_m0[6u].z;
                        float _1217 = dot(float3(_1210, _1211, _1212), float3(_1213, _1214, _1215));
                        float _1232 = clamp(dot(float3(_1039, _1040, _1041), float3((_1210 * _1217) - _1213, (_1211 * _1217) - _1214, (_1212 * _1217) - _1215)) / ((UniformBufferConstants_DeferredLightUniforms_m0[7u].w * UniformBufferConstants_DeferredLightUniforms_m0[7u].w) - (_1217 * _1217)), 0.0f, 1.0f);
                        _1239 = (_1232 * _1213) + _1039;
                        _1240 = (_1232 * _1214) + _1040;
                        _1241 = (_1232 * _1215) + _1041;
                    }
                    else
                    {
                        _1239 = _1039;
                        _1240 = _1040;
                        _1241 = _1041;
                    }
                    float _1245 = rsqrt(dot(float3(_1239, _1240, _1241), float3(_1239, _1240, _1241)));
                    float _1246 = _1245 * _1239;
                    float _1247 = _1245 * _1240;
                    float _1248 = _1245 * _1241;
                    float _1249 = max(_1049, UniformBufferConstants_View_m0[245u].z);
                    float _1254 = clamp((_1245 * UniformBufferConstants_DeferredLightUniforms_m0[6u].w) * (1.0f - (_1249 * _1249)), 0.0f, 1.0f);
                    float _1256 = clamp(_1245 * UniformBufferConstants_DeferredLightUniforms_m0[7u].z, 0.0f, 1.0f);
                    float _1282;
                    float _1288;
                    float _1294;
                    float _1300;
                    float _1310;
                    float _1319;
                    float _1328;
                    float _1337;
                    float _1346;
                    switch (_169)
                    {
                        case 1u:
                        case 10u:
                        case 11u:
                        {
                            float _1358 = dot(float3(_214, _215, _216), float3(_1246, _1247, _1248));
                            float _1361 = dot(float3(_214, _215, _216), float3(_802, _803, _804));
                            float _1364 = dot(float3(_802, _803, _804), float3(_1246, _1247, _1248));
                            float _1369 = rsqrt((_1364 * 2.0f) + 2.0f);
                            bool _1376 = _1254 > 0.0f;
                            float _1771;
                            float _1774;
                            if (_1376)
                            {
                                float _1766 = sqrt(1.0f - (_1254 * _1254));
                                float _1768 = (_1358 * 2.0f) * _1361;
                                float _1769 = _1768 - _1364;
                                float frontier_phi_66_65_ladder;
                                float frontier_phi_66_65_ladder_1;
                                if (_1769 < _1766)
                                {
                                    float _2085 = rsqrt(1.0f - (_1769 * _1769)) * _1254;
                                    float _2088 = _2085 * (_1361 - (_1769 * _1358));
                                    float _2089 = _1361 * _1361;
                                    float _2094 = _2085 * (((_2089 * 2.0f) + (-1.0f)) - (_1769 * _1364));
                                    float _2103 = sqrt(clamp((((1.0f - (_1358 * _1358)) - _2089) - (_1364 * _1364)) + (_1768 * _1364), 0.0f, 1.0f));
                                    float _2104 = _2103 * _2085;
                                    float _2107 = ((_1361 * 2.0f) * _2085) * _2103;
                                    float _2109 = (_1766 * _1358) + _1361;
                                    float _2110 = _2109 + _2088;
                                    float _2111 = _1766 * _1364;
                                    float _2113 = (_2111 + 1.0f) + _2094;
                                    float _2114 = _2104 * _2113;
                                    float _2115 = _2110 * _2113;
                                    float _2116 = _2107 * _2110;
                                    float _2121 = (((_2110 * 0.25f) * _2107) - (_2114 * 0.5f)) * _2115;
                                    float _2135 = (((_2116 - (_2114 * 2.0f)) * _2116) + (_2114 * _2114)) + (((((-0.5f) - ((_2113 + _2111) * 0.5f)) * _2115) + ((_2113 * _2113) * _2109)) * _2110);
                                    float _2140 = (_2121 * 2.0f) / ((_2135 * _2135) + (_2121 * _2121));
                                    float _2141 = _2135 * _2140;
                                    float _2143 = 1.0f - (_2121 * _2140);
                                    float _2149 = ((_2141 * _2107) + _2111) + (_2143 * _2094);
                                    float _2152 = rsqrt((_2149 * 2.0f) + 2.0f);
                                    frontier_phi_66_65_ladder = clamp(((_2109 + (_2141 * _2104)) + (_2143 * _2088)) * _2152, 0.0f, 1.0f);
                                    frontier_phi_66_65_ladder_1 = clamp((_2149 * _2152) + _2152, 0.0f, 1.0f);
                                }
                                else
                                {
                                    frontier_phi_66_65_ladder = 1.0f;
                                    frontier_phi_66_65_ladder_1 = abs(_1361);
                                }
                                _1771 = frontier_phi_66_65_ladder_1;
                                _1774 = frontier_phi_66_65_ladder;
                            }
                            else
                            {
                                _1771 = clamp((_1369 * _1364) + _1369, 0.0f, 1.0f);
                                _1774 = clamp(_1369 * (_1361 + _1358), 0.0f, 1.0f);
                            }
                            float _1778 = clamp(abs(_1361) + 9.9999997473787516355514526367188e-06f, 0.0f, 1.0f);
                            float _1782 = _1171 * _1172;
                            float _1783 = _1049 * _1049;
                            float _1784 = _1783 * _1783;
                            float _2164;
                            if (_1256 > 0.0f)
                            {
                                _2164 = clamp(((_1256 * _1256) / ((_1771 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _1784, 0.0f, 1.0f);
                            }
                            else
                            {
                                _2164 = _1784;
                            }
                            float _2808;
                            float _2809;
                            if (_1376)
                            {
                                float _2806 = (((_1254 * 0.25f) * ((asfloat(uint(int(asuint(_2164)) >> int(1u)) + 532487669u) * 3.0f) + _1254)) / (_1771 + 0.001000000047497451305389404296875f)) + _2164;
                                _2808 = _2806;
                                _2809 = _2164 / _2806;
                            }
                            else
                            {
                                _2808 = _2164;
                                _2809 = 1.0f;
                            }
                            float _3170;
                            if (_1137 < 1.0f)
                            {
                                float _3155 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _3170 = sqrt(_2808 / ((((_3155 * 0.25f) * (_3155 + (asfloat(uint(int(asuint(_2808)) >> int(1u)) + 532487669u) * 3.0f))) / (_1771 + 0.001000000047497451305389404296875f)) + _2808)) * _2809;
                            }
                            else
                            {
                                _3170 = _2809;
                            }
                            float _3174 = (((_2164 * _1774) - _1774) * _1774) + 1.0f;
                            float _3179 = sqrt(_2164);
                            float _3180 = 1.0f - _3179;
                            float _3189 = 1.0f - _1771;
                            float _3190 = _3189 * _3189;
                            float _3192 = (_3190 * _3190) * _3189;
                            float _3195 = clamp(_286 * 50.0f, 0.0f, 1.0f) * _3192;
                            float _3196 = 1.0f - _3192;
                            float _3204 = (((_2164 / ((_3174 * _3174) * 3.1415927410125732421875f)) * _3170) * (0.5f / ((((_3180 * _1778) + _3179) * _1171) + (((_3180 * _1171) + _3179) * _1778)))) * _1782;
                            _1282 = 0.0f;
                            _1288 = 0.0f;
                            _1294 = 0.0f;
                            _1300 = _3204 * (_3195 + (_3196 * _285));
                            _1310 = _3204 * (_3195 + (_3196 * _286));
                            _1319 = _3204 * (_3195 + (_3196 * _287));
                            _1328 = (_272 * 0.3183098733425140380859375f) * _1782;
                            _1337 = (_273 * 0.3183098733425140380859375f) * _1782;
                            _1346 = (_274 * 0.3183098733425140380859375f) * _1782;
                            break;
                        }
                        case 2u:
                        {
                            float _1377 = dot(float3(_214, _215, _216), float3(_1246, _1247, _1248));
                            float _1380 = dot(float3(_214, _215, _216), float3(_802, _803, _804));
                            float _1383 = dot(float3(_802, _803, _804), float3(_1246, _1247, _1248));
                            float _1388 = rsqrt((_1383 * 2.0f) + 2.0f);
                            bool _1395 = _1254 > 0.0f;
                            float _1793;
                            float _1796;
                            if (_1395)
                            {
                                float _1788 = sqrt(1.0f - (_1254 * _1254));
                                float _1790 = (_1377 * 2.0f) * _1380;
                                float _1791 = _1790 - _1383;
                                float frontier_phi_68_67_ladder;
                                float frontier_phi_68_67_ladder_1;
                                if (_1791 < _1788)
                                {
                                    float _2168 = rsqrt(1.0f - (_1791 * _1791)) * _1254;
                                    float _2171 = _2168 * (_1380 - (_1791 * _1377));
                                    float _2172 = _1380 * _1380;
                                    float _2177 = _2168 * (((_2172 * 2.0f) + (-1.0f)) - (_1791 * _1383));
                                    float _2186 = sqrt(clamp((((1.0f - (_1377 * _1377)) - _2172) - (_1383 * _1383)) + (_1790 * _1383), 0.0f, 1.0f));
                                    float _2187 = _2186 * _2168;
                                    float _2190 = ((_1380 * 2.0f) * _2168) * _2186;
                                    float _2192 = (_1788 * _1377) + _1380;
                                    float _2193 = _2192 + _2171;
                                    float _2194 = _1788 * _1383;
                                    float _2196 = (_2194 + 1.0f) + _2177;
                                    float _2197 = _2187 * _2196;
                                    float _2198 = _2193 * _2196;
                                    float _2199 = _2190 * _2193;
                                    float _2204 = (((_2193 * 0.25f) * _2190) - (_2197 * 0.5f)) * _2198;
                                    float _2218 = (((_2199 - (_2197 * 2.0f)) * _2199) + (_2197 * _2197)) + (((((-0.5f) - ((_2196 + _2194) * 0.5f)) * _2198) + ((_2196 * _2196) * _2192)) * _2193);
                                    float _2223 = (_2204 * 2.0f) / ((_2218 * _2218) + (_2204 * _2204));
                                    float _2224 = _2218 * _2223;
                                    float _2226 = 1.0f - (_2204 * _2223);
                                    float _2232 = ((_2224 * _2190) + _2194) + (_2226 * _2177);
                                    float _2235 = rsqrt((_2232 * 2.0f) + 2.0f);
                                    frontier_phi_68_67_ladder = clamp(((_2192 + (_2224 * _2187)) + (_2226 * _2171)) * _2235, 0.0f, 1.0f);
                                    frontier_phi_68_67_ladder_1 = clamp((_2232 * _2235) + _2235, 0.0f, 1.0f);
                                }
                                else
                                {
                                    frontier_phi_68_67_ladder = 1.0f;
                                    frontier_phi_68_67_ladder_1 = abs(_1380);
                                }
                                _1793 = frontier_phi_68_67_ladder_1;
                                _1796 = frontier_phi_68_67_ladder;
                            }
                            else
                            {
                                _1793 = clamp((_1388 * _1383) + _1388, 0.0f, 1.0f);
                                _1796 = clamp(_1388 * (_1380 + _1377), 0.0f, 1.0f);
                            }
                            float _1800 = clamp(abs(_1380) + 9.9999997473787516355514526367188e-06f, 0.0f, 1.0f);
                            float _1804 = _1171 * _1172;
                            float _1805 = _1049 * _1049;
                            float _1806 = _1805 * _1805;
                            float _2247;
                            if (_1256 > 0.0f)
                            {
                                _2247 = clamp(((_1256 * _1256) / ((_1793 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _1806, 0.0f, 1.0f);
                            }
                            else
                            {
                                _2247 = _1806;
                            }
                            float _2823;
                            float _2824;
                            if (_1395)
                            {
                                float _2821 = (((_1254 * 0.25f) * ((asfloat(uint(int(asuint(_2247)) >> int(1u)) + 532487669u) * 3.0f) + _1254)) / (_1793 + 0.001000000047497451305389404296875f)) + _2247;
                                _2823 = _2821;
                                _2824 = _2247 / _2821;
                            }
                            else
                            {
                                _2823 = _2247;
                                _2824 = 1.0f;
                            }
                            float _3223;
                            if (_1137 < 1.0f)
                            {
                                float _3208 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _3223 = sqrt(_2823 / ((((_3208 * 0.25f) * (_3208 + (asfloat(uint(int(asuint(_2823)) >> int(1u)) + 532487669u) * 3.0f))) / (_1793 + 0.001000000047497451305389404296875f)) + _2823)) * _2824;
                            }
                            else
                            {
                                _3223 = _2824;
                            }
                            float _3227 = (((_2247 * _1796) - _1796) * _1796) + 1.0f;
                            float _3232 = sqrt(_2247);
                            float _3233 = 1.0f - _3232;
                            float _3242 = 1.0f - _1793;
                            float _3243 = _3242 * _3242;
                            float _3245 = (_3243 * _3243) * _3242;
                            float _3248 = clamp(_286 * 50.0f, 0.0f, 1.0f) * _3245;
                            float _3249 = 1.0f - _3245;
                            float _3257 = (((_2247 / ((_3227 * _3227) * 3.1415927410125732421875f)) * _3223) * (0.5f / ((((_3233 * _1800) + _3232) * _1171) + (((_3233 * _1171) + _3232) * _1800)))) * _1804;
                            float _3258 = _195 * _195;
                            float _3259 = _196 * _196;
                            float _3260 = _197 * _197;
                            float _3286 = ((((exp2(log2(clamp((_1377 * 0.666666686534881591796875f) + 0.3333333432674407958984375f, 0.0f, 1.0f)) * 1.5f) * 1.66666662693023681640625f) + (-1.0f)) * _198) + 1.0f) * 0.15915493667125701904296875f;
                            float _3306 = max(9.9999999600419720025001879548654e-13f, UniformBufferConstants_View_m0[284u].w);
                            float _3314 = exp2(((log2(min(max(_3258, 9.9999999600419720025001879548654e-13f), 1.0f)) * (-0.693147182464599609375f)) / _3306) * (-1.44269502162933349609375f));
                            float _3315 = exp2(((log2(min(max(_3259, 9.9999999600419720025001879548654e-13f), 1.0f)) * (-0.693147182464599609375f)) / _3306) * (-1.44269502162933349609375f));
                            float _3316 = exp2(((log2(min(max(_3260, 9.9999999600419720025001879548654e-13f), 1.0f)) * (-0.693147182464599609375f)) / _3306) * (-1.44269502162933349609375f));
                            float _3742;
                            float _3743;
                            float _3744;
                            float _3745;
                            if (_3315 < _3316)
                            {
                                _3742 = _3316;
                                _3743 = _3315;
                                _3744 = -1.0f;
                                _3745 = 0.666666686534881591796875f;
                            }
                            else
                            {
                                _3742 = _3315;
                                _3743 = _3316;
                                _3744 = 0.0f;
                                _3745 = -0.3333333432674407958984375f;
                            }
                            bool _3747 = _3314 < _3742;
                            float _3748 = _3747 ? _3742 : _3314;
                            float _3750 = _3747 ? _3314 : _3742;
                            float _3752 = _3748 - min(_3750, _3743);
                            float _3762 = _3752 / (_3748 + 1.0000000133514319600180897396058e-10f);
                            float _3764 = (_3259 < _3260) ? _3260 : _3259;
                            float _3766 = (_3258 < _3764) ? _3764 : _3258;
                            float _3767 = abs(((_3750 - _3743) / ((_3752 * 6.0f) + 1.0000000133514319600180897396058e-10f)) + (_3747 ? _3745 : _3744)) * 6.0f;
                            float _3792 = (((clamp(abs(_3767 + (-3.0f)) + (-1.0f), 0.0f, 1.0f) + (-1.0f)) * _3762) + 1.0f) * _3766;
                            float _3793 = (((clamp(2.0f - abs(_3767 + (-2.0f)), 0.0f, 1.0f) + (-1.0f)) * _3762) + 1.0f) * _3766;
                            float _3794 = (((clamp(2.0f - abs(_3767 + (-4.0f)), 0.0f, 1.0f) + (-1.0f)) * _3762) + 1.0f) * _3766;
                            float _3798 = (((exp2(log2(clamp(dot(float3(_1246, _1247, _1248), float3(_454, _455, _456)), 0.0f, 1.0f)) * 12.0f) * (3.0f - (_198 * 2.900000095367431640625f))) * (1.0f - _3286)) + _3286) * _1172;
                            _1282 = (((_3258 - _3792) * _869) + _3792) * _3798;
                            _1288 = (((_3259 - _3793) * _869) + _3793) * _3798;
                            _1294 = (((_3260 - _3794) * _869) + _3794) * _3798;
                            _1300 = _3257 * (_3248 + (_3249 * _285));
                            _1310 = _3257 * (_3248 + (_3249 * _286));
                            _1319 = _3257 * (_3248 + (_3249 * _287));
                            _1328 = (_272 * 0.3183098733425140380859375f) * _1804;
                            _1337 = (_273 * 0.3183098733425140380859375f) * _1804;
                            _1346 = (_274 * 0.3183098733425140380859375f) * _1804;
                            break;
                        }
                        case 3u:
                        {
                            float _1396 = dot(float3(_214, _215, _216), float3(_1246, _1247, _1248));
                            float _1399 = dot(float3(_214, _215, _216), float3(_802, _803, _804));
                            float _1402 = dot(float3(_802, _803, _804), float3(_1246, _1247, _1248));
                            float _1407 = rsqrt((_1402 * 2.0f) + 2.0f);
                            bool _1414 = _1254 > 0.0f;
                            float _1815;
                            float _1818;
                            if (_1414)
                            {
                                float _1810 = sqrt(1.0f - (_1254 * _1254));
                                float _1812 = (_1396 * 2.0f) * _1399;
                                float _1813 = _1812 - _1402;
                                float frontier_phi_70_69_ladder;
                                float frontier_phi_70_69_ladder_1;
                                if (_1813 < _1810)
                                {
                                    float _2251 = rsqrt(1.0f - (_1813 * _1813)) * _1254;
                                    float _2254 = _2251 * (_1399 - (_1813 * _1396));
                                    float _2255 = _1399 * _1399;
                                    float _2260 = _2251 * (((_2255 * 2.0f) + (-1.0f)) - (_1813 * _1402));
                                    float _2269 = sqrt(clamp((((1.0f - (_1396 * _1396)) - _2255) - (_1402 * _1402)) + (_1812 * _1402), 0.0f, 1.0f));
                                    float _2270 = _2269 * _2251;
                                    float _2273 = ((_1399 * 2.0f) * _2251) * _2269;
                                    float _2275 = (_1810 * _1396) + _1399;
                                    float _2276 = _2275 + _2254;
                                    float _2277 = _1810 * _1402;
                                    float _2279 = (_2277 + 1.0f) + _2260;
                                    float _2280 = _2270 * _2279;
                                    float _2281 = _2276 * _2279;
                                    float _2282 = _2273 * _2276;
                                    float _2287 = (((_2276 * 0.25f) * _2273) - (_2280 * 0.5f)) * _2281;
                                    float _2301 = (((_2282 - (_2280 * 2.0f)) * _2282) + (_2280 * _2280)) + (((((-0.5f) - ((_2279 + _2277) * 0.5f)) * _2281) + ((_2279 * _2279) * _2275)) * _2276);
                                    float _2306 = (_2287 * 2.0f) / ((_2301 * _2301) + (_2287 * _2287));
                                    float _2307 = _2301 * _2306;
                                    float _2309 = 1.0f - (_2287 * _2306);
                                    float _2315 = ((_2307 * _2273) + _2277) + (_2309 * _2260);
                                    float _2318 = rsqrt((_2315 * 2.0f) + 2.0f);
                                    frontier_phi_70_69_ladder = clamp(((_2275 + (_2307 * _2270)) + (_2309 * _2254)) * _2318, 0.0f, 1.0f);
                                    frontier_phi_70_69_ladder_1 = clamp((_2315 * _2318) + _2318, 0.0f, 1.0f);
                                }
                                else
                                {
                                    frontier_phi_70_69_ladder = 1.0f;
                                    frontier_phi_70_69_ladder_1 = abs(_1399);
                                }
                                _1815 = frontier_phi_70_69_ladder_1;
                                _1818 = frontier_phi_70_69_ladder;
                            }
                            else
                            {
                                _1815 = clamp((_1407 * _1402) + _1407, 0.0f, 1.0f);
                                _1818 = clamp(_1407 * (_1399 + _1396), 0.0f, 1.0f);
                            }
                            float _1822 = clamp(abs(_1399) + 9.9999997473787516355514526367188e-06f, 0.0f, 1.0f);
                            float _1826 = _1171 * _1172;
                            float _1827 = _1049 * _1049;
                            float _1828 = _1827 * _1827;
                            float _2330;
                            if (_1256 > 0.0f)
                            {
                                _2330 = clamp(((_1256 * _1256) / ((_1815 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _1828, 0.0f, 1.0f);
                            }
                            else
                            {
                                _2330 = _1828;
                            }
                            float _2838;
                            float _2839;
                            if (_1414)
                            {
                                float _2836 = (((_1254 * 0.25f) * ((asfloat(uint(int(asuint(_2330)) >> int(1u)) + 532487669u) * 3.0f) + _1254)) / (_1815 + 0.001000000047497451305389404296875f)) + _2330;
                                _2838 = _2836;
                                _2839 = _2330 / _2836;
                            }
                            else
                            {
                                _2838 = _2330;
                                _2839 = 1.0f;
                            }
                            float _3336;
                            if (_1137 < 1.0f)
                            {
                                float _3321 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _3336 = sqrt(_2838 / ((((_3321 * 0.25f) * (_3321 + (asfloat(uint(int(asuint(_2838)) >> int(1u)) + 532487669u) * 3.0f))) / (_1815 + 0.001000000047497451305389404296875f)) + _2838)) * _2839;
                            }
                            else
                            {
                                _3336 = _2839;
                            }
                            float _3340 = (((_2330 * _1818) - _1818) * _1818) + 1.0f;
                            float _3345 = sqrt(_2330);
                            float _3346 = 1.0f - _3345;
                            float _3355 = 1.0f - _1815;
                            float _3356 = _3355 * _3355;
                            float _3358 = (_3356 * _3356) * _3355;
                            float _3361 = clamp(_286 * 50.0f, 0.0f, 1.0f) * _3358;
                            float _3362 = 1.0f - _3358;
                            float _3370 = (((_2330 / ((_3340 * _3340) * 3.1415927410125732421875f)) * _3336) * (0.5f / ((((_3346 * _1822) + _3345) * _1171) + (((_3346 * _1171) + _3345) * _1822)))) * _1826;
                            float4 _3378 = View_PreIntegratedBRDF.SampleLevel(View_PreIntegratedBRDFSampler, float2(clamp((_1396 * 0.5f) + 0.5f, 0.0f, 1.0f), 1.0f - _198), 0.0f);
                            _1282 = ((_195 * _195) * _1172) * _3378.x;
                            _1288 = ((_196 * _196) * _1172) * _3378.y;
                            _1294 = ((_197 * _197) * _1172) * _3378.z;
                            _1300 = _3370 * (_3361 + (_3362 * _285));
                            _1310 = _3370 * (_3361 + (_3362 * _286));
                            _1319 = _3370 * (_3361 + (_3362 * _287));
                            _1328 = (_272 * 0.3183098733425140380859375f) * _1826;
                            _1337 = (_273 * 0.3183098733425140380859375f) * _1826;
                            _1346 = (_274 * 0.3183098733425140380859375f) * _1826;
                            break;
                        }
                        case 4u:
                        {
                            float _1415 = max(_196, 0.0199999995529651641845703125f);
                            float _1417 = dot(float3(_214, _215, _216), float3(_1246, _1247, _1248));
                            float _1420 = dot(float3(_214, _215, _216), float3(_802, _803, _804));
                            float _1423 = dot(float3(_802, _803, _804), float3(_1246, _1247, _1248));
                            float _1428 = rsqrt((_1423 * 2.0f) + 2.0f);
                            float _1435 = _1049 * _1049;
                            float _1436 = 1.0f - _1435;
                            float _1437 = _1415 * _1415;
                            float _1443 = clamp(((_1436 > 0.0f) ? ((1.0f - _1437) / _1436) : 0.0f) * _1254, 0.0f, 1.0f);
                            bool _1444 = _1443 > 0.0f;
                            float _1837;
                            float _1840;
                            float _1842;
                            if (_1444)
                            {
                                float _1832 = sqrt(1.0f - (_1443 * _1443));
                                float _1834 = (_1417 * 2.0f) * _1420;
                                float _1835 = _1834 - _1423;
                                float frontier_phi_72_71_ladder;
                                float frontier_phi_72_71_ladder_1;
                                float frontier_phi_72_71_ladder_2;
                                if (_1835 < _1832)
                                {
                                    float _2334 = rsqrt(1.0f - (_1835 * _1835)) * _1443;
                                    float _2337 = _2334 * (_1420 - (_1835 * _1417));
                                    float _2338 = _1420 * _1420;
                                    float _2343 = _2334 * (((_2338 * 2.0f) + (-1.0f)) - (_1835 * _1423));
                                    float _2352 = sqrt(clamp((((1.0f - (_1417 * _1417)) - _2338) - (_1423 * _1423)) + (_1834 * _1423), 0.0f, 1.0f));
                                    float _2353 = _2352 * _2334;
                                    float _2356 = ((_1420 * 2.0f) * _2334) * _2352;
                                    float _2357 = _1832 * _1417;
                                    float _2358 = _2357 + _1420;
                                    float _2359 = _2358 + _2337;
                                    float _2360 = _1832 * _1423;
                                    float _2362 = (_2360 + 1.0f) + _2343;
                                    float _2363 = _2353 * _2362;
                                    float _2364 = _2359 * _2362;
                                    float _2365 = _2356 * _2359;
                                    float _2370 = (((_2359 * 0.25f) * _2356) - (_2363 * 0.5f)) * _2364;
                                    float _2384 = (((_2365 - (_2363 * 2.0f)) * _2365) + (_2363 * _2363)) + (((((-0.5f) - ((_2362 + _2360) * 0.5f)) * _2364) + ((_2362 * _2362) * _2358)) * _2359);
                                    float _2389 = (_2370 * 2.0f) / ((_2384 * _2384) + (_2370 * _2370));
                                    float _2390 = _2384 * _2389;
                                    float _2392 = 1.0f - (_2370 * _2389);
                                    float _1843 = ((_2390 * _2353) + _2357) + (_2392 * _2337);
                                    float _2399 = ((_2390 * _2356) + _2360) + (_2392 * _2343);
                                    float _2402 = rsqrt((_2399 * 2.0f) + 2.0f);
                                    frontier_phi_72_71_ladder = _1843;
                                    frontier_phi_72_71_ladder_1 = clamp((_1843 + _1420) * _2402, 0.0f, 1.0f);
                                    frontier_phi_72_71_ladder_2 = clamp((_2399 * _2402) + _2402, 0.0f, 1.0f);
                                }
                                else
                                {
                                    frontier_phi_72_71_ladder = _1417;
                                    frontier_phi_72_71_ladder_1 = 1.0f;
                                    frontier_phi_72_71_ladder_2 = abs(_1420);
                                }
                                _1837 = frontier_phi_72_71_ladder_2;
                                _1840 = frontier_phi_72_71_ladder_1;
                                _1842 = frontier_phi_72_71_ladder;
                            }
                            else
                            {
                                _1837 = clamp((_1428 * _1423) + _1428, 0.0f, 1.0f);
                                _1840 = clamp(_1428 * (_1420 + _1417), 0.0f, 1.0f);
                                _1842 = _1417;
                            }
                            float _1846 = clamp(abs(_1420) + 9.9999997473787516355514526367188e-06f, 0.0f, 1.0f);
                            float _1847 = 1.0f - _1837;
                            float _1848 = _1847 * _1847;
                            float _1850 = (_1848 * _1848) * _1847;
                            float _1851 = 1.0f - _1850;
                            float _1854 = (_1851 * 0.039999999105930328369140625f) + _1850;
                            float _1855 = _1437 * _1437;
                            bool _1856 = _1256 > 0.0f;
                            float _2413;
                            if (_1856)
                            {
                                _2413 = clamp(((_1256 * _1256) / ((_1837 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _1855, 0.0f, 1.0f);
                            }
                            else
                            {
                                _2413 = _1855;
                            }
                            float _2853;
                            float _2854;
                            if (_1444)
                            {
                                float _2851 = (((_1443 * 0.25f) * ((asfloat(uint(int(asuint(_2413)) >> int(1u)) + 532487669u) * 3.0f) + _1443)) / (_1837 + 0.001000000047497451305389404296875f)) + _2413;
                                _2853 = _2851;
                                _2854 = _2413 / _2851;
                            }
                            else
                            {
                                _2853 = _2413;
                                _2854 = 1.0f;
                            }
                            bool _2855 = _1137 < 1.0f;
                            float _3407;
                            if (_2855)
                            {
                                float _3392 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _3407 = sqrt(_2853 / ((((_3392 * 0.25f) * (_3392 + (asfloat(uint(int(asuint(_2853)) >> int(1u)) + 532487669u) * 3.0f))) / (_1837 + 0.001000000047497451305389404296875f)) + _2853)) * _2854;
                            }
                            else
                            {
                                _3407 = _2854;
                            }
                            float _3408 = sqrt(_2413);
                            float _3409 = 1.0f - _3408;
                            float _3421 = (((_2413 * _1840) - _1840) * _1840) + 1.0f;
                            float _3425 = _1171 * _1172;
                            float _3430 = ((((_3425 * _1854) * _3407) * (0.5f / ((((_3409 * _1846) + _3408) * _1171) + (((_3409 * _1171) + _3408) * _1846)))) * (_2413 / ((_3421 * _3421) * 3.1415927410125732421875f))) * _195;
                            float _3431 = 1.0f - _1854;
                            float _3432 = _3431 * _3431;
                            float _3438 = ((0.62999999523162841796875f - (_1837 * 0.2199999988079071044921875f)) * _1837) + (-0.74500000476837158203125f);
                            float _3440 = _3438 * _1840;
                            float _3444 = min(max((_1846 * 0.666666686534881591796875f) - _3440, 0.001000000047497451305389404296875f), 1.0f);
                            float _3844;
                            float _3845;
                            float _3846;
                            if (_219 > 0.0f)
                            {
                                float _3825 = max(((1.0f / _3444) + (-2.0f)) + (1.0f / min(max((_1842 * 0.666666686534881591796875f) - _3440, 0.001000000047497451305389404296875f), 1.0f)), 0.0f);
                                _3844 = ((exp2((log2(max(_762 * 0.3183098733425140380859375f, 9.9999997473787516355514526367188e-05f)) * 0.5f) * _3825) + (-1.0f)) * _219) + 1.0f;
                                _3845 = ((exp2((log2(max(_763 * 0.3183098733425140380859375f, 9.9999997473787516355514526367188e-05f)) * 0.5f) * _3825) + (-1.0f)) * _219) + 1.0f;
                                _3846 = ((exp2((log2(max(_764 * 0.3183098733425140380859375f, 9.9999997473787516355514526367188e-05f)) * 0.5f) * _3825) + (-1.0f)) * _219) + 1.0f;
                            }
                            else
                            {
                                _3844 = 1.0f;
                                _3845 = 1.0f;
                                _3846 = 1.0f;
                            }
                            float _3850 = (_272 * 0.3183098733425140380859375f) * _3425;
                            float _3851 = (_273 * 0.3183098733425140380859375f) * _3425;
                            float _3852 = (_274 * 0.3183098733425140380859375f) * _3425;
                            float _3865 = _1435 * _1435;
                            float _3866 = sqrt(_3865);
                            float _3867 = 1.0f - _3866;
                            float _3879 = (((_1840 * _3865) - _1840) * _1840) + 1.0f;
                            float _3883 = 1.0f - clamp((_1837 * 0.666666686534881591796875f) - _3438, 0.0f, 1.0f);
                            float _3884 = _3883 * _3883;
                            float _3886 = (_3884 * _3884) * _3883;
                            float _3888 = clamp(_286 * 50.0f, 0.0f, 1.0f);
                            float _3889 = _3888 * _3886;
                            float _3890 = 1.0f - _3886;
                            float _3897 = _3888 * _1850;
                            float _3901 = _3897 + (_1851 * _285);
                            float _3902 = _3897 + (_1851 * _286);
                            float _3903 = _3897 + (_1851 * _287);
                            float _3926;
                            if (_1856)
                            {
                                _3926 = clamp(((_1256 * _1256) / ((_1837 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _3865, 0.0f, 1.0f);
                            }
                            else
                            {
                                _3926 = _3865;
                            }
                            float _3954;
                            float _3955;
                            if (_1254 > 0.0f)
                            {
                                float _3952 = (((_1254 * 0.25f) * ((asfloat(uint(int(asuint(_3926)) >> int(1u)) + 532487669u) * 3.0f) + _1254)) / (_1837 + 0.001000000047497451305389404296875f)) + _3926;
                                _3954 = _3952;
                                _3955 = _3926 / _3952;
                            }
                            else
                            {
                                _3954 = _3926;
                                _3955 = 1.0f;
                            }
                            float _4040;
                            if (_2855)
                            {
                                float _4025 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _4040 = sqrt(_3954 / ((((_4025 * 0.25f) * (_4025 + (asfloat(uint(int(asuint(_3954)) >> int(1u)) + 532487669u) * 3.0f))) / (_1837 + 0.001000000047497451305389404296875f)) + _3954)) * _3955;
                            }
                            else
                            {
                                _4040 = _3955;
                            }
                            float _4043 = ((_3425 * (0.5f / ((((_3867 * _3444) + _3866) * _1171) + (((_3867 * _1171) + _3866) * _3444)))) * (_3865 / ((_3879 * _3879) * 3.1415927410125732421875f))) * _4040;
                            _1282 = 0.0f;
                            _1288 = 0.0f;
                            _1294 = 0.0f;
                            _1300 = (_4043 * (((((_3844 * _3432) * (_3889 + (_3890 * _285))) - _3901) * _195) + _3901)) + _3430;
                            _1310 = (_4043 * (((((_3845 * _3432) * (_3889 + (_3890 * _286))) - _3902) * _195) + _3902)) + _3430;
                            _1319 = (_4043 * (((((_3846 * _3432) * (_3889 + (_3890 * _287))) - _3903) * _195) + _3903)) + _3430;
                            _1328 = ((((_3432 * _3850) * _3844) - _3850) * _195) + _3850;
                            _1337 = ((((_3432 * _3851) * _3845) - _3851) * _195) + _3851;
                            _1346 = ((((_3432 * _3852) * _3846) - _3852) * _195) + _3852;
                            break;
                        }
                        case 5u:
                        {
                            float _1445 = dot(float3(_214, _215, _216), float3(_1246, _1247, _1248));
                            float _1448 = dot(float3(_214, _215, _216), float3(_802, _803, _804));
                            float _1451 = dot(float3(_802, _803, _804), float3(_1246, _1247, _1248));
                            float _1456 = rsqrt((_1451 * 2.0f) + 2.0f);
                            bool _1463 = _1254 > 0.0f;
                            float _1864;
                            float _1867;
                            if (_1463)
                            {
                                float _1859 = sqrt(1.0f - (_1254 * _1254));
                                float _1861 = (_1445 * 2.0f) * _1448;
                                float _1862 = _1861 - _1451;
                                float frontier_phi_74_73_ladder;
                                float frontier_phi_74_73_ladder_1;
                                if (_1862 < _1859)
                                {
                                    float _2417 = rsqrt(1.0f - (_1862 * _1862)) * _1254;
                                    float _2420 = _2417 * (_1448 - (_1862 * _1445));
                                    float _2421 = _1448 * _1448;
                                    float _2426 = _2417 * (((_2421 * 2.0f) + (-1.0f)) - (_1862 * _1451));
                                    float _2435 = sqrt(clamp((((1.0f - (_1445 * _1445)) - _2421) - (_1451 * _1451)) + (_1861 * _1451), 0.0f, 1.0f));
                                    float _2436 = _2435 * _2417;
                                    float _2439 = ((_1448 * 2.0f) * _2417) * _2435;
                                    float _2441 = (_1859 * _1445) + _1448;
                                    float _2442 = _2441 + _2420;
                                    float _2443 = _1859 * _1451;
                                    float _2445 = (_2443 + 1.0f) + _2426;
                                    float _2446 = _2436 * _2445;
                                    float _2447 = _2442 * _2445;
                                    float _2448 = _2439 * _2442;
                                    float _2453 = (((_2442 * 0.25f) * _2439) - (_2446 * 0.5f)) * _2447;
                                    float _2467 = (((_2448 - (_2446 * 2.0f)) * _2448) + (_2446 * _2446)) + (((((-0.5f) - ((_2445 + _2443) * 0.5f)) * _2447) + ((_2445 * _2445) * _2441)) * _2442);
                                    float _2472 = (_2453 * 2.0f) / ((_2467 * _2467) + (_2453 * _2453));
                                    float _2473 = _2467 * _2472;
                                    float _2475 = 1.0f - (_2453 * _2472);
                                    float _2481 = ((_2473 * _2439) + _2443) + (_2475 * _2426);
                                    float _2484 = rsqrt((_2481 * 2.0f) + 2.0f);
                                    frontier_phi_74_73_ladder = clamp(((_2441 + (_2473 * _2436)) + (_2475 * _2420)) * _2484, 0.0f, 1.0f);
                                    frontier_phi_74_73_ladder_1 = clamp((_2481 * _2484) + _2484, 0.0f, 1.0f);
                                }
                                else
                                {
                                    frontier_phi_74_73_ladder = 1.0f;
                                    frontier_phi_74_73_ladder_1 = abs(_1448);
                                }
                                _1864 = frontier_phi_74_73_ladder_1;
                                _1867 = frontier_phi_74_73_ladder;
                            }
                            else
                            {
                                _1864 = clamp((_1456 * _1451) + _1456, 0.0f, 1.0f);
                                _1867 = clamp(_1456 * (_1448 + _1445), 0.0f, 1.0f);
                            }
                            float _1871 = clamp(abs(_1448) + 9.9999997473787516355514526367188e-06f, 0.0f, 1.0f);
                            float4 _1876 = View_SSProfilesTexture.Load(int3(uint2(5u, uint((_195 * 255.0f) + 0.5f)), 0u));
                            float _1880 = _1876.z;
                            float _1884 = clamp((_198 + (-0.100000001490116119384765625f)) * 10.0f, 0.0f, 1.0f);
                            float _1895 = max(clamp(((((_1876.x * 2.0f) + (-1.0f)) * _1884) + 1.0f) * _1049, 0.0f, 1.0f), 0.0199999995529651641845703125f);
                            float _1897 = clamp(((((_1876.y * 2.0f) + (-1.0f)) * _1884) + 1.0f) * _1049, 0.0f, 1.0f);
                            float _1900 = ((_1897 - _1895) * _1880) + _1895;
                            float _1904 = ((_1864 * _1864) * (_1049 * 2.0f)) + (-0.5f);
                            float _1905 = 1.0f - _1871;
                            float _1906 = _1905 * _1905;
                            float _1911 = 1.0f - _1171;
                            float _1912 = _1911 * _1911;
                            float _1918 = (((((_1912 * _1912) * _1911) * _1904) + 1.0f) * 0.3183098733425140380859375f) * (((_1906 * _1906) * (_1904 * _1905)) + 1.0f);
                            float _1919 = _1171 * _1172;
                            float _1923 = _1900 * _1900;
                            float _1925 = _1895 * _1895;
                            float _1926 = _1925 * _1925;
                            float _1927 = _1897 * _1897;
                            float _1928 = _1927 * _1927;
                            bool _1929 = _1256 > 0.0f;
                            float _2496;
                            if (_1929)
                            {
                                _2496 = clamp(((_1256 * _1256) / ((_1864 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _1926, 0.0f, 1.0f);
                            }
                            else
                            {
                                _2496 = _1926;
                            }
                            float _2868;
                            float _2869;
                            if (_1463)
                            {
                                float _2866 = (((_1254 * 0.25f) * ((asfloat(uint(int(asuint(_2496)) >> int(1u)) + 532487669u) * 3.0f) + _1254)) / (_1864 + 0.001000000047497451305389404296875f)) + _2496;
                                _2868 = _2866;
                                _2869 = _2496 / _2866;
                            }
                            else
                            {
                                _2868 = _2496;
                                _2869 = 1.0f;
                            }
                            bool _2870 = _1137 < 1.0f;
                            float _3467;
                            if (_2870)
                            {
                                float _3452 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _3467 = sqrt(_2868 / ((((_3452 * 0.25f) * (_3452 + (asfloat(uint(int(asuint(_2868)) >> int(1u)) + 532487669u) * 3.0f))) / (_1864 + 0.001000000047497451305389404296875f)) + _2868)) * _2869;
                            }
                            else
                            {
                                _3467 = _2869;
                            }
                            float _3910;
                            if (_1929)
                            {
                                _3910 = clamp(((_1256 * _1256) / ((_1864 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _1928, 0.0f, 1.0f);
                            }
                            else
                            {
                                _3910 = _1928;
                            }
                            float _3940;
                            float _3941;
                            if (_1463)
                            {
                                float _3938 = (((_1254 * 0.25f) * ((asfloat(uint(int(asuint(_3910)) >> int(1u)) + 532487669u) * 3.0f) + _1254)) / (_1864 + 0.001000000047497451305389404296875f)) + _3910;
                                _3940 = _3938;
                                _3941 = _3910 / _3938;
                            }
                            else
                            {
                                _3940 = _3910;
                                _3941 = 1.0f;
                            }
                            float _3974;
                            if (_2870)
                            {
                                float _3959 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _3974 = sqrt(_3940 / ((((_3959 * 0.25f) * (_3959 + (asfloat(uint(int(asuint(_3940)) >> int(1u)) + 532487669u) * 3.0f))) / (_1864 + 0.001000000047497451305389404296875f)) + _3940)) * _3941;
                            }
                            else
                            {
                                _3974 = _3941;
                            }
                            float _3978 = (((_3910 * _1867) - _1867) * _1867) + 1.0f;
                            float _3986 = (((_2496 * _1867) - _1867) * _1867) + 1.0f;
                            float _3990 = (_2496 / ((_3986 * _3986) * 3.1415927410125732421875f)) * _3467;
                            float _3994 = sqrt(_1923 * _1923);
                            float _3995 = 1.0f - _3994;
                            float _4004 = 1.0f - _1864;
                            float _4005 = _4004 * _4004;
                            float _4007 = (_4005 * _4005) * _4004;
                            float _4010 = clamp(_286 * 50.0f, 0.0f, 1.0f) * _4007;
                            float _4011 = 1.0f - _4007;
                            float _4018 = (((((_3910 / ((_3978 * _3978) * 3.1415927410125732421875f)) * _3974) - _3990) * _1880) + _3990) * (0.5f / ((((_3995 * _1871) + _3994) * _1171) + (((_3995 * _1171) + _3994) * _1871)));
                            _1282 = 0.0f;
                            _1288 = 0.0f;
                            _1294 = 0.0f;
                            _1300 = ((_4010 + (_4011 * _285)) * _1919) * _4018;
                            _1310 = ((_4010 + (_4011 * _286)) * _1919) * _4018;
                            _1319 = ((_4010 + (_4011 * _287)) * _1919) * _4018;
                            _1328 = (_1919 * _272) * _1918;
                            _1337 = (_1919 * _273) * _1918;
                            _1346 = (_1919 * _274) * _1918;
                            break;
                        }
                        case 6u:
                        {
                            float _1464 = dot(float3(_214, _215, _216), float3(_1246, _1247, _1248));
                            float _1467 = dot(float3(_214, _215, _216), float3(_802, _803, _804));
                            float _1470 = dot(float3(_802, _803, _804), float3(_1246, _1247, _1248));
                            float _1475 = rsqrt((_1470 * 2.0f) + 2.0f);
                            bool _1482 = _1254 > 0.0f;
                            float _1937;
                            float _1940;
                            if (_1482)
                            {
                                float _1932 = sqrt(1.0f - (_1254 * _1254));
                                float _1934 = (_1464 * 2.0f) * _1467;
                                float _1935 = _1934 - _1470;
                                float frontier_phi_76_75_ladder;
                                float frontier_phi_76_75_ladder_1;
                                if (_1935 < _1932)
                                {
                                    float _2500 = rsqrt(1.0f - (_1935 * _1935)) * _1254;
                                    float _2503 = _2500 * (_1467 - (_1935 * _1464));
                                    float _2504 = _1467 * _1467;
                                    float _2509 = _2500 * (((_2504 * 2.0f) + (-1.0f)) - (_1935 * _1470));
                                    float _2518 = sqrt(clamp((((1.0f - (_1464 * _1464)) - _2504) - (_1470 * _1470)) + (_1934 * _1470), 0.0f, 1.0f));
                                    float _2519 = _2518 * _2500;
                                    float _2522 = ((_1467 * 2.0f) * _2500) * _2518;
                                    float _2524 = (_1932 * _1464) + _1467;
                                    float _2525 = _2524 + _2503;
                                    float _2526 = _1932 * _1470;
                                    float _2528 = (_2526 + 1.0f) + _2509;
                                    float _2529 = _2519 * _2528;
                                    float _2530 = _2525 * _2528;
                                    float _2531 = _2522 * _2525;
                                    float _2536 = (((_2525 * 0.25f) * _2522) - (_2529 * 0.5f)) * _2530;
                                    float _2550 = (((_2531 - (_2529 * 2.0f)) * _2531) + (_2529 * _2529)) + (((((-0.5f) - ((_2528 + _2526) * 0.5f)) * _2530) + ((_2528 * _2528) * _2524)) * _2525);
                                    float _2555 = (_2536 * 2.0f) / ((_2550 * _2550) + (_2536 * _2536));
                                    float _2556 = _2550 * _2555;
                                    float _2558 = 1.0f - (_2536 * _2555);
                                    float _2564 = ((_2556 * _2522) + _2526) + (_2558 * _2509);
                                    float _2567 = rsqrt((_2564 * 2.0f) + 2.0f);
                                    frontier_phi_76_75_ladder = clamp(((_2524 + (_2556 * _2519)) + (_2558 * _2503)) * _2567, 0.0f, 1.0f);
                                    frontier_phi_76_75_ladder_1 = clamp((_2564 * _2567) + _2567, 0.0f, 1.0f);
                                }
                                else
                                {
                                    frontier_phi_76_75_ladder = 1.0f;
                                    frontier_phi_76_75_ladder_1 = abs(_1467);
                                }
                                _1937 = frontier_phi_76_75_ladder_1;
                                _1940 = frontier_phi_76_75_ladder;
                            }
                            else
                            {
                                _1937 = clamp((_1475 * _1470) + _1475, 0.0f, 1.0f);
                                _1940 = clamp(_1475 * (_1467 + _1464), 0.0f, 1.0f);
                            }
                            float _1944 = clamp(abs(_1467) + 9.9999997473787516355514526367188e-06f, 0.0f, 1.0f);
                            float _1948 = _1171 * _1172;
                            float _1949 = _1049 * _1049;
                            float _1950 = _1949 * _1949;
                            float _2579;
                            if (_1256 > 0.0f)
                            {
                                _2579 = clamp(((_1256 * _1256) / ((_1937 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _1950, 0.0f, 1.0f);
                            }
                            else
                            {
                                _2579 = _1950;
                            }
                            float _2883;
                            float _2884;
                            if (_1482)
                            {
                                float _2881 = (((_1254 * 0.25f) * ((asfloat(uint(int(asuint(_2579)) >> int(1u)) + 532487669u) * 3.0f) + _1254)) / (_1937 + 0.001000000047497451305389404296875f)) + _2579;
                                _2883 = _2881;
                                _2884 = _2579 / _2881;
                            }
                            else
                            {
                                _2883 = _2579;
                                _2884 = 1.0f;
                            }
                            float _3486;
                            if (_1137 < 1.0f)
                            {
                                float _3471 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _3486 = sqrt(_2883 / ((((_3471 * 0.25f) * (_3471 + (asfloat(uint(int(asuint(_2883)) >> int(1u)) + 532487669u) * 3.0f))) / (_1937 + 0.001000000047497451305389404296875f)) + _2883)) * _2884;
                            }
                            else
                            {
                                _3486 = _2884;
                            }
                            float _3490 = (((_2579 * _1940) - _1940) * _1940) + 1.0f;
                            float _3495 = sqrt(_2579);
                            float _3496 = 1.0f - _3495;
                            float _3505 = 1.0f - _1937;
                            float _3506 = _3505 * _3505;
                            float _3508 = (_3506 * _3506) * _3505;
                            float _3511 = clamp(_286 * 50.0f, 0.0f, 1.0f) * _3508;
                            float _3512 = 1.0f - _3508;
                            float _3520 = (((_2579 / ((_3490 * _3490) * 3.1415927410125732421875f)) * _3486) * (0.5f / ((((_3496 * _1944) + _3495) * _1171) + (((_3496 * _1171) + _3495) * _1944)))) * _1948;
                            float _3529 = clamp((-0.0f) - _1470, 0.0f, 1.0f);
                            float _3530 = _3529 * _3529;
                            float _3540 = (clamp((0.5f - _1464) * 0.4444444477558135986328125f, 0.0f, 1.0f) * _1172) * (0.36000001430511474609375f / ((3.1415927410125732421875f - (_3530 * 2.0106194019317626953125f)) * (1.0f - (_3530 * 0.63999998569488525390625f))));
                            _1282 = (_195 * _195) * _3540;
                            _1288 = (_196 * _196) * _3540;
                            _1294 = (_197 * _197) * _3540;
                            _1300 = _3520 * (_3511 + (_3512 * _285));
                            _1310 = _3520 * (_3511 + (_3512 * _286));
                            _1319 = _3520 * (_3511 + (_3512 * _287));
                            _1328 = (_272 * 0.3183098733425140380859375f) * _1948;
                            _1337 = (_273 * 0.3183098733425140380859375f) * _1948;
                            _1346 = (_274 * 0.3183098733425140380859375f) * _1948;
                            break;
                        }
                        case 7u:
                        {
                            float _1484 = min(max(_1049, 0.0039215688593685626983642578125f), 1.0f);
                            float _1487 = min(1.0f, (_770 != 0u) ? _197 : 1.0f);
                            float _1488 = dot(float3(_802, _803, _804), float3(_1246, _1247, _1248));
                            float _1491 = dot(float3(_214, _215, _216), float3(_1246, _1247, _1248));
                            float _1495 = min(max(_1491, -1.0f), 1.0f);
                            float _1500 = min(max(dot(float3(_214, _215, _216), float3(_802, _803, _804)), -1.0f), 1.0f);
                            float _1501 = abs(_1500);
                            float _1508 = (1.57079637050628662109375f - (_1501 * 0.15658299624919891357421875f)) * sqrt(1.0f - _1501);
                            float _1513 = abs(_1495);
                            float _1518 = (1.57079637050628662109375f - (_1513 * 0.15658299624919891357421875f)) * sqrt(1.0f - _1513);
                            float _1525 = cos(abs(((_1495 >= 0.0f) ? _1518 : (3.1415927410125732421875f - _1518)) - ((_1500 >= 0.0f) ? _1508 : (3.1415927410125732421875f - _1508))) * 0.5f);
                            float _1529 = _1246 - (_1495 * _214);
                            float _1530 = _1247 - (_1495 * _215);
                            float _1531 = _1248 - (_1495 * _216);
                            float _1535 = _802 - (_1500 * _214);
                            float _1536 = _803 - (_1500 * _215);
                            float _1537 = _804 - (_1500 * _216);
                            float _1550 = rsqrt((dot(float3(_1535, _1536, _1537), float3(_1535, _1536, _1537)) * dot(float3(_1529, _1530, _1531), float3(_1529, _1530, _1531))) + 9.9999997473787516355514526367188e-05f) * dot(float3(_1529, _1530, _1531), float3(_1535, _1536, _1537));
                            float _1554 = sqrt(clamp((_1550 * 0.5f) + 0.5f, 0.0f, 1.0f));
                            float _1560 = _1484 * _1484;
                            float _1561 = _1560 * 0.5f;
                            float _1562 = _1560 * 2.0f;
                            float _1952;
                            if ((_765 & 1u) == 0u)
                            {
                                _1952 = 0.0f;
                            }
                            else
                            {
                                float _1968 = (_1500 + _1495) + ((((_1554 * 0.997551023960113525390625f) * sqrt(1.0f - (_1500 * _1500))) - (_1500 * 0.06994284689426422119140625f)) * 0.1398856937885284423828125f);
                                float _1971 = (_1560 * 1.41421353816986083984375f) * _1554;
                                float _1985 = 1.0f - sqrt(clamp((_1488 * 0.5f) + 0.5f, 0.0f, 1.0f));
                                float _1986 = _1985 * _1985;
                                _1952 = ((((_254 * 0.5f) * _1554) * (exp2((((_1968 * _1968) * (-0.5f)) / (_1971 * _1971)) * 1.44269502162933349609375f) / (_1971 * 2.5066282749176025390625f))) * ((clamp((-0.0f) - _1488, 0.0f, 1.0f) * (_1487 + (-1.0f))) + 1.0f)) * (((_1986 * _1986) * (_1985 * 0.95347940921783447265625f)) + 0.0465205647051334381103515625f);
                            }
                            float _2580;
                            float _2582;
                            float _2584;
                            if ((_765 & 2u) == 0u)
                            {
                                _2580 = _1952;
                                _2582 = _1952;
                                _2584 = _1952;
                            }
                            else
                            {
                                float _2593 = (_1495 + (-0.0350000001490116119384765625f)) + _1500;
                                float _2603 = 1.0f / ((1.190000057220458984375f / _1525) + (_1525 * 0.36000001430511474609375f));
                                float _2609 = ((_2603 * (0.60000002384185791015625f - (_1550 * 0.800000011920928955078125f))) + 1.0f) * _1554;
                                float _2615 = 1.0f - (sqrt(clamp(1.0f - (_2609 * _2609), 0.0f, 1.0f)) * _1525);
                                float _2616 = _2615 * _2615;
                                float _2620 = 0.95347940921783447265625f - ((_2616 * _2616) * (_2615 * 0.95347940921783447265625f));
                                float _2622 = _2609 * _2603;
                                float _2623 = _2622 * _2622;
                                float _3541;
                                float _3542;
                                float _3543;
                                if (_771 == 0u)
                                {
                                    float _3013 = log2(_762);
                                    float _3014 = log2(_763);
                                    float _3015 = log2(_764);
                                    float _3018 = abs(1.0f - (_2623 / _1525));
                                    _3541 = ((_3013 * _3013) * (-0.0399814583361148834228515625f)) * _3018;
                                    _3542 = ((_3014 * _3014) * (-0.0399814583361148834228515625f)) * _3018;
                                    _3543 = ((_3015 * _3015) * (-0.0399814583361148834228515625f)) * _3018;
                                }
                                else
                                {
                                    float _3032 = (sqrt(1.0f - _2623) * 0.5f) / _1525;
                                    _3541 = log2(abs(_762)) * _3032;
                                    _3542 = log2(abs(_763)) * _3032;
                                    _3543 = log2(abs(_764)) * _3032;
                                }
                                float _3554 = ((_2620 * _2620) * (exp2((((_2593 * _2593) * (-0.5f)) / (_1561 * _1561)) * 1.44269502162933349609375f) / (_1560 * 1.25331413745880126953125f))) * exp2((-5.7419261932373046875f) - (_1550 * 5.265837192535400390625f));
                                _2580 = ((exp2(_3541) * _1487) * _3554) + _1952;
                                _2582 = ((exp2(_3542) * _1487) * _3554) + _1952;
                                _2584 = ((exp2(_3543) * _1487) * _3554) + _1952;
                            }
                            float _2588 = abs(_762);
                            float _2589 = abs(_763);
                            float _2590 = abs(_764);
                            float _2886;
                            float _2888;
                            float _2890;
                            if ((_765 & 4u) == 0u)
                            {
                                _2886 = _2580;
                                _2888 = _2582;
                                _2890 = _2584;
                            }
                            else
                            {
                                float _2971 = (_1495 + (-0.14000000059604644775390625f)) + _1500;
                                float _2982 = 1.0f - (_1525 * 0.5f);
                                float _2983 = _2982 * _2982;
                                float _2988 = (_2983 * _2983) * (0.95347940921783447265625f - (_1525 * 0.476739704608917236328125f));
                                float _2990 = 0.95347940921783447265625f - _2988;
                                float _2991 = 0.800000011920928955078125f / _1525;
                                float _3009 = (((_2990 * _2990) * (_2988 + 0.0465205647051334381103515625f)) * (exp2((((_2971 * _2971) * (-0.5f)) / (_1562 * _1562)) * 1.44269502162933349609375f) / (_1560 * 5.013256549835205078125f))) * exp2((_1550 * 24.5258159637451171875f) + (-24.208423614501953125f));
                                _2886 = (_3009 * exp2(log2(_2588) * _2991)) + _2580;
                                _2888 = (_3009 * exp2(log2(_2589) * _2991)) + _2582;
                                _2890 = (_3009 * exp2(log2(_2590) * _2991)) + _2584;
                            }
                            float _2900 = dot(float3(_802, _803, _804), float3(_214, _215, _216));
                            float _2906 = _802 - (_2900 * _214);
                            float _2907 = _803 - (_2900 * _215);
                            float _2908 = _804 - (_2900 * _216);
                            float _2912 = rsqrt(dot(float3(_2906, _2907, _2908), float3(_2906, _2907, _2908)));
                            float _2921 = clamp((dot(float3(_2906 * _2912, _2907 * _2912, _2908 * _2912), float3(_1246, _1247, _1248)) + 1.0f) * 0.25f, 0.0f, 1.0f);
                            float _2927 = (_219 * 0.3183098733425140380859375f) * ((((1.0f - abs(_1491)) - _2921) * 0.3300000131130218505859375f) + _2921);
                            float _2931 = 1.0f - _1006;
                            float _2932 = max(dot(float3(_762, _763, _764), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)), 9.9999997473787516355514526367188e-05f);
                            _1282 = (-0.0f) - (_1172 * min((-0.0f) - (((_2886 + _767) * _1008) + ((exp2(log2(abs(_762 / _2932)) * _2931) * _2927) * sqrt(_2588))), 0.0f));
                            _1288 = (-0.0f) - (_1172 * min((-0.0f) - (((_2888 + _768) * _1008) + ((exp2(log2(abs(_763 / _2932)) * _2931) * _2927) * sqrt(_2589))), 0.0f));
                            _1294 = (-0.0f) - (_1172 * min((-0.0f) - (((_2890 + _769) * _1008) + ((exp2(log2(abs(_764 / _2932)) * _2931) * _2927) * sqrt(_2590))), 0.0f));
                            _1300 = 0.0f;
                            _1310 = 0.0f;
                            _1319 = 0.0f;
                            _1328 = 0.0f;
                            _1337 = 0.0f;
                            _1346 = 0.0f;
                            break;
                        }
                        case 8u:
                        {
                            float _1566 = _196 * _196;
                            float _1568 = clamp(_198, 0.0f, 1.0f);
                            float _1569 = dot(float3(_214, _215, _216), float3(_1246, _1247, _1248));
                            float _1572 = dot(float3(_214, _215, _216), float3(_802, _803, _804));
                            float _1575 = dot(float3(_802, _803, _804), float3(_1246, _1247, _1248));
                            float _1580 = rsqrt((_1575 * 2.0f) + 2.0f);
                            bool _1587 = _1254 > 0.0f;
                            float _2009;
                            float _2012;
                            if (_1587)
                            {
                                float _2004 = sqrt(1.0f - (_1254 * _1254));
                                float _2006 = (_1569 * 2.0f) * _1572;
                                float _2007 = _2006 - _1575;
                                float frontier_phi_80_79_ladder;
                                float frontier_phi_80_79_ladder_1;
                                if (_2007 < _2004)
                                {
                                    float _2627 = rsqrt(1.0f - (_2007 * _2007)) * _1254;
                                    float _2630 = _2627 * (_1572 - (_2007 * _1569));
                                    float _2631 = _1572 * _1572;
                                    float _2636 = _2627 * (((_2631 * 2.0f) + (-1.0f)) - (_2007 * _1575));
                                    float _2645 = sqrt(clamp((((1.0f - (_1569 * _1569)) - _2631) - (_1575 * _1575)) + (_2006 * _1575), 0.0f, 1.0f));
                                    float _2646 = _2645 * _2627;
                                    float _2649 = ((_1572 * 2.0f) * _2627) * _2645;
                                    float _2651 = (_2004 * _1569) + _1572;
                                    float _2652 = _2651 + _2630;
                                    float _2653 = _2004 * _1575;
                                    float _2655 = (_2653 + 1.0f) + _2636;
                                    float _2656 = _2646 * _2655;
                                    float _2657 = _2652 * _2655;
                                    float _2658 = _2649 * _2652;
                                    float _2663 = (((_2652 * 0.25f) * _2649) - (_2656 * 0.5f)) * _2657;
                                    float _2677 = (((_2658 - (_2656 * 2.0f)) * _2658) + (_2656 * _2656)) + (((((-0.5f) - ((_2655 + _2653) * 0.5f)) * _2657) + ((_2655 * _2655) * _2651)) * _2652);
                                    float _2682 = (_2663 * 2.0f) / ((_2677 * _2677) + (_2663 * _2663));
                                    float _2683 = _2677 * _2682;
                                    float _2685 = 1.0f - (_2663 * _2682);
                                    float _2691 = ((_2683 * _2649) + _2653) + (_2685 * _2636);
                                    float _2694 = rsqrt((_2691 * 2.0f) + 2.0f);
                                    frontier_phi_80_79_ladder = clamp(((_2651 + (_2683 * _2646)) + (_2685 * _2630)) * _2694, 0.0f, 1.0f);
                                    frontier_phi_80_79_ladder_1 = clamp((_2691 * _2694) + _2694, 0.0f, 1.0f);
                                }
                                else
                                {
                                    frontier_phi_80_79_ladder = 1.0f;
                                    frontier_phi_80_79_ladder_1 = abs(_1572);
                                }
                                _2009 = frontier_phi_80_79_ladder_1;
                                _2012 = frontier_phi_80_79_ladder;
                            }
                            else
                            {
                                _2009 = clamp((_1580 * _1575) + _1580, 0.0f, 1.0f);
                                _2012 = clamp(_1580 * (_1572 + _1569), 0.0f, 1.0f);
                            }
                            float _2016 = clamp(abs(_1572) + 9.9999997473787516355514526367188e-06f, 0.0f, 1.0f);
                            float _2017 = _1171 * _1172;
                            float _2018 = _1049 * _1049;
                            float _2019 = _2018 * _2018;
                            float _2706;
                            if (_1256 > 0.0f)
                            {
                                _2706 = clamp(((_1256 * _1256) / ((_2009 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _2019, 0.0f, 1.0f);
                            }
                            else
                            {
                                _2706 = _2019;
                            }
                            float _3054;
                            float _3055;
                            if (_1587)
                            {
                                float _3052 = (((_1254 * 0.25f) * ((asfloat(uint(int(asuint(_2706)) >> int(1u)) + 532487669u) * 3.0f) + _1254)) / (_2009 + 0.001000000047497451305389404296875f)) + _2706;
                                _3054 = _3052;
                                _3055 = _2706 / _3052;
                            }
                            else
                            {
                                _3054 = _2706;
                                _3055 = 1.0f;
                            }
                            float _3579;
                            if (_1137 < 1.0f)
                            {
                                float _3564 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _3579 = sqrt(_3054 / ((((_3564 * 0.25f) * (_3564 + (asfloat(uint(int(asuint(_3054)) >> int(1u)) + 532487669u) * 3.0f))) / (_2009 + 0.001000000047497451305389404296875f)) + _3054)) * _3055;
                            }
                            else
                            {
                                _3579 = _3055;
                            }
                            float _3583 = (((_2706 * _2012) - _2012) * _2012) + 1.0f;
                            float _3588 = sqrt(_2706);
                            float _3589 = 1.0f - _3588;
                            float _3598 = 1.0f - _2009;
                            float _3599 = _3598 * _3598;
                            float _3601 = (_3599 * _3599) * _3598;
                            float _3604 = clamp(_286 * 50.0f, 0.0f, 1.0f) * _3601;
                            float _3605 = 1.0f - _3601;
                            float _3613 = (((_2706 / ((_3583 * _3583) * 3.1415927410125732421875f)) * _3579) * (0.5f / ((((_3589 * _2016) + _3588) * _1171) + (((_3589 * _1171) + _3588) * _2016)))) * _2017;
                            float _3614 = _3613 * (_3604 + (_3605 * _285));
                            float _3615 = _3613 * (_3604 + (_3605 * _286));
                            float _3616 = _3613 * (_3604 + (_3605 * _287));
                            float _3620 = ((_2012 - (_2012 * _2019)) * _2012) + _2019;
                            float _3637 = clamp(_1566 * 50.0f, 0.0f, 1.0f) * _3601;
                            float _3645 = ((((((_2019 * _2019) * 4.0f) / (_3620 * _3620)) + 1.0f) * (1.0f / ((_2019 * 12.56637096405029296875f) + 3.1415927410125732421875f))) * (0.25f / ((_2016 + _1171) - (_2016 * _1171)))) * _2017;
                            _1282 = 0.0f;
                            _1288 = 0.0f;
                            _1294 = 0.0f;
                            _1300 = (((_3645 * (_3637 + ((_195 * _195) * _3605))) - _3614) * _1568) + _3614;
                            _1310 = (((_3645 * (_3637 + (_3605 * _1566))) - _3615) * _1568) + _3615;
                            _1319 = (((_3645 * (_3637 + ((_197 * _197) * _3605))) - _3616) * _1568) + _3616;
                            _1328 = (_272 * 0.3183098733425140380859375f) * _2017;
                            _1337 = (_273 * 0.3183098733425140380859375f) * _2017;
                            _1346 = (_274 * 0.3183098733425140380859375f) * _2017;
                            break;
                        }
                        case 9u:
                        {
                            float _1590 = (_196 * 2.0f) + (-1.0f);
                            float _1591 = (_197 * 2.0f) + (-1.0f);
                            float _1597 = 1.0f - dot(1.0f.xx, float2(abs(_1590), abs(_1591)));
                            float _1599 = max((-0.0f) - _1597, 0.0f);
                            float _1600 = (-0.0f) - _1599;
                            float _1605 = ((_1590 >= 0.0f) ? _1600 : _1599) + _1590;
                            float _1606 = ((_1591 >= 0.0f) ? _1600 : _1599) + _1591;
                            float _1610 = rsqrt(dot(float3(_1605, _1606, _1597), float3(_1605, _1606, _1597)));
                            float _1611 = _1605 * _1610;
                            float _1612 = _1606 * _1610;
                            float _1613 = _1610 * _1597;
                            float _1614 = 1.0f - _198;
                            float _1615 = _1614 * _118;
                            float _1625 = ((((-0.0f) - _214) - _1611) * _1615) + _1611;
                            float _1626 = ((((-0.0f) - _215) - _1612) * _1615) + _1612;
                            float _1627 = ((((-0.0f) - _216) - _1613) * _1615) + _1613;
                            float _1631 = rsqrt(dot(float3(_1625, _1626, _1627), float3(_1625, _1626, _1627)));
                            float _1635 = dot(float3(_214, _215, _216), float3(_1246, _1247, _1248));
                            float _1638 = dot(float3(_214, _215, _216), float3(_802, _803, _804));
                            float _1641 = dot(float3(_802, _803, _804), float3(_1246, _1247, _1248));
                            float _1646 = rsqrt((_1641 * 2.0f) + 2.0f);
                            bool _1653 = _1254 > 0.0f;
                            float _2028;
                            float _2031;
                            if (_1653)
                            {
                                float _2023 = sqrt(1.0f - (_1254 * _1254));
                                float _2026 = ((_1635 * 2.0f) * _1638) - _1641;
                                float frontier_phi_82_81_ladder;
                                float frontier_phi_82_81_ladder_1;
                                if (_2026 < _2023)
                                {
                                    float _2710 = rsqrt(1.0f - (_2026 * _2026)) * _1254;
                                    float _2722 = (_2710 * ((((_1638 * _1638) * 2.0f) + (-1.0f)) - (_2026 * _1641))) + (_2023 * _1641);
                                    float _2725 = rsqrt((_2722 * 2.0f) + 2.0f);
                                    frontier_phi_82_81_ladder = clamp((((_2023 * _1635) + _1638) + (_2710 * (_1638 - (_2026 * _1635)))) * _2725, 0.0f, 1.0f);
                                    frontier_phi_82_81_ladder_1 = clamp((_2722 * _2725) + _2725, 0.0f, 1.0f);
                                }
                                else
                                {
                                    frontier_phi_82_81_ladder = 1.0f;
                                    frontier_phi_82_81_ladder_1 = abs(_1638);
                                }
                                _2028 = frontier_phi_82_81_ladder_1;
                                _2031 = frontier_phi_82_81_ladder;
                            }
                            else
                            {
                                _2028 = clamp((_1646 * _1641) + _1646, 0.0f, 1.0f);
                                _2031 = clamp(_1646 * (_1638 + _1635), 0.0f, 1.0f);
                            }
                            float _2035 = clamp(abs(_1638) + 9.9999997473787516355514526367188e-06f, 0.0f, 1.0f);
                            float _2037 = 1.0f - _2028;
                            float _2038 = _2037 * _2037;
                            float _2040 = (_2038 * _2038) * _2037;
                            float _2043 = ((_254 * 0.07999999821186065673828125f) * (1.0f - _2040)) + _2040;
                            float _2044 = _1049 * _1049;
                            float _2045 = _2044 * _2044;
                            float _2737;
                            if (_1256 > 0.0f)
                            {
                                _2737 = clamp(((_1256 * _1256) / ((_2028 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _2045, 0.0f, 1.0f);
                            }
                            else
                            {
                                _2737 = _2045;
                            }
                            float _3069;
                            float _3070;
                            if (_1653)
                            {
                                float _3067 = (((_1254 * 0.25f) * ((asfloat(uint(int(asuint(_2737)) >> int(1u)) + 532487669u) * 3.0f) + _1254)) / (_2028 + 0.001000000047497451305389404296875f)) + _2737;
                                _3069 = _3067;
                                _3070 = _2737 / _3067;
                            }
                            else
                            {
                                _3069 = _2737;
                                _3070 = 1.0f;
                            }
                            float _3676;
                            if (_1137 < 1.0f)
                            {
                                float _3661 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _3676 = sqrt(_3069 / ((((_3661 * 0.25f) * (_3661 + (asfloat(uint(int(asuint(_3069)) >> int(1u)) + 532487669u) * 3.0f))) / (_2028 + 0.001000000047497451305389404296875f)) + _3069)) * _3070;
                            }
                            else
                            {
                                _3676 = _3070;
                            }
                            float _3677 = sqrt(_2737);
                            float _3678 = 1.0f - _3677;
                            float _3690 = (((_2737 * _2031) - _2031) * _2031) + 1.0f;
                            float _1302 = ((_2043 * (_1171 * _1172)) * (0.5f / ((((_3678 * _2035) + _3677) * _1171) + (((_3678 * _1171) + _3677) * _2035)))) * ((_2737 / ((_3690 * _3690) * 3.1415927410125732421875f)) * _3676);
                            float _3701 = clamp(dot(float3(_1611, _1612, _1613), float3(_1246, _1247, _1248)), 0.0f, 1.0f);
                            float _3724 = ((1.0f - _2043) * _1172) * ((((((exp2(log2(clamp(dot(float3(_1625 * _1631, _1626 * _1631, _1627 * _1631), float3(_1246, _1247, _1248)), 0.0f, 1.0f)) * (12.0f - (_3701 * 11.0f))) * (2.6000001430511474609375f - (_3701 * 2.2000000476837158203125f))) + 0.800000011920928955078125f) * _3701) - _1171) * _1614) + _1171);
                            _1282 = (_272 * 0.3183098733425140380859375f) * _3724;
                            _1288 = (_273 * 0.3183098733425140380859375f) * _3724;
                            _1294 = (_274 * 0.3183098733425140380859375f) * _3724;
                            _1300 = _1302;
                            _1310 = _1302;
                            _1319 = _1302;
                            _1328 = 0.0f;
                            _1337 = 0.0f;
                            _1346 = 0.0f;
                            break;
                        }
                        case 13u:
                        {
                            float _1656 = (_342 * _215) - (_340 * _216);
                            float _1659 = (_338 * _216) - (_342 * _214);
                            float _1662 = (_340 * _214) - (_338 * _215);
                            float _1666 = rsqrt(dot(float3(_1656, _1659, _1662), float3(_1656, _1659, _1662)));
                            float _1667 = _1666 * _1656;
                            float _1668 = _1666 * _1659;
                            float _1669 = _1666 * _1662;
                            float _1673 = dot(float3(_214, _215, _216), float3(_802, _803, _804));
                            float _1676 = dot(float3(_802, _803, _804), float3(_1246, _1247, _1248));
                            float _1683 = rsqrt(max(0.00200000009499490261077880859375f, (_1676 * 2.0f) + 2.0f));
                            float _1689 = clamp((_1683 * _1676) + _1683, 0.0f, 1.0f);
                            float _1690 = dot(float3(_338, _340, _342), float3(_802, _803, _804));
                            float _1693 = dot(float3(_338, _340, _342), float3(_1246, _1247, _1248));
                            float _1698 = dot(float3(_1667, _1668, _1669), float3(_802, _803, _804));
                            float _1701 = dot(float3(_1667, _1668, _1669), float3(_1246, _1247, _1248));
                            float _1709 = clamp(abs(_1673) + 9.9999997473787516355514526367188e-06f, 0.0f, 1.0f);
                            float _1710 = _1171 * _1172;
                            float _1715 = _1049 * _1049;
                            float _1716 = _1715 * _1715;
                            float _1719 = max(_1715 * (_344 + 1.0f), 0.001000000047497451305389404296875f);
                            float _1723 = max(_1715 * (1.0f - _344), 0.001000000047497451305389404296875f);
                            float _2055;
                            if (_1256 > 0.0f)
                            {
                                _2055 = clamp(((_1256 * _1256) / ((_1689 * 3.599999904632568359375f) + 0.4000000059604644775390625f)) + _1716, 0.0f, 1.0f);
                            }
                            else
                            {
                                _2055 = _1716;
                            }
                            float _2751;
                            float _2752;
                            if (_1254 > 0.0f)
                            {
                                float _2749 = (((_1254 * 0.25f) * ((asfloat(uint(int(asuint(_2055)) >> int(1u)) + 532487669u) * 3.0f) + _1254)) / (_1689 + 0.001000000047497451305389404296875f)) + _2055;
                                _2751 = _2749;
                                _2752 = _2055 / _2749;
                            }
                            else
                            {
                                _2751 = _2055;
                                _2752 = 1.0f;
                            }
                            float _3091;
                            if (_1137 < 1.0f)
                            {
                                float _3076 = sqrt((1.00010001659393310546875f - _1137) / (_1137 + 1.0f));
                                _3091 = sqrt(_2751 / ((((_3076 * 0.25f) * (_3076 + (asfloat(uint(int(asuint(_2751)) >> int(1u)) + 532487669u) * 3.0f))) / (_1689 + 0.001000000047497451305389404296875f)) + _2751)) * _2752;
                            }
                            else
                            {
                                _3091 = _2752;
                            }
                            float _3092 = _1723 * _1719;
                            float _3093 = ((_1693 + _1690) * _1683) * _1723;
                            float _3094 = ((_1701 + _1698) * _1683) * _1719;
                            float _3095 = _3092 * clamp(_1683 * (_1673 + dot(float3(_214, _215, _216), float3(_1246, _1247, _1248))), 0.0f, 1.0f);
                            float _3099 = _3092 / dot(float3(_3093, _3094, _3095), float3(_3093, _3094, _3095));
                            float _3102 = (_3099 * _3099) * (_3092 * 0.3183098733425140380859375f);
                            float _3112 = _1719 * _1690;
                            float _3113 = _1723 * _1698;
                            float _3121 = _1719 * _1693;
                            float _3122 = _1723 * _1701;
                            float _3132 = 1.0f - _1689;
                            float _3133 = _3132 * _3132;
                            float _3135 = (_3133 * _3133) * _3132;
                            float _3139 = clamp(_286 * 50.0f, 0.0f, 1.0f) * _3135;
                            float _3140 = 1.0f - _3135;
                            float _3148 = ((((min(max(exp2(log2(_3102) * 1.5f), 0.0f), 3.0f) * _346) + _3102) * _3091) * (0.5f / ((sqrt(((_3121 * _3121) + (_1171 * _1171)) + (_3122 * _3122)) * _1709) + (sqrt(((_3112 * _3112) + (_1709 * _1709)) + (_3113 * _3113)) * _1171)))) * _1710;
                            _1282 = 0.0f;
                            _1288 = 0.0f;
                            _1294 = 0.0f;
                            _1300 = _3148 * (_3139 + (_3140 * _285));
                            _1310 = _3148 * (_3139 + (_3140 * _286));
                            _1319 = _3148 * (_3139 + (_3140 * _287));
                            _1328 = (_272 * 0.3183098733425140380859375f) * _1710;
                            _1337 = (_273 * 0.3183098733425140380859375f) * _1710;
                            _1346 = (_274 * 0.3183098733425140380859375f) * _1710;
                            break;
                        }
                        default:
                        {
                            _1282 = 0.0f;
                            _1288 = 0.0f;
                            _1294 = 0.0f;
                            _1300 = 0.0f;
                            _1310 = 0.0f;
                            _1319 = 0.0f;
                            _1328 = 0.0f;
                            _1337 = 0.0f;
                            _1346 = 0.0f;
                            break;
                        }
                    }
                    float _1355 = _1008 * _841;
                    float _1356 = _1008 * _842;
                    float _1357 = _1008 * _843;
                    float _1753;
                    if (_233)
                    {
                        float frontier_phi_64_63_ladder;
                        if (UniformBufferConstants_View_m0[228u].z == 0.0f)
                        {
                            frontier_phi_64_63_ladder = dot(float3(_1328 * _1355, _1337 * _1356, _1346 * _1357), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f));
                        }
                        else
                        {
                            frontier_phi_64_63_ladder = 0.0f;
                        }
                        _1753 = frontier_phi_64_63_ladder;
                    }
                    else
                    {
                        _1753 = 0.0f;
                    }
                    float _1761 = _1006 * _841;
                    float _1762 = _1006 * _842;
                    float _1763 = _1006 * _843;
                    float _864;
                    if (_233)
                    {
                        float frontier_phi_89_88_ladder;
                        if (UniformBufferConstants_View_m0[228u].z == 0.0f)
                        {
                            frontier_phi_89_88_ladder = dot(float3(_1282 * _1761, _1288 * _1762, _1294 * _1763), float3(0.300000011920928955078125f, 0.589999973773956298828125f, 0.10999999940395355224609375f)) + _1753;
                        }
                        else
                        {
                            frontier_phi_89_88_ladder = _1753;
                        }
                        _864 = frontier_phi_89_88_ladder;
                    }
                    else
                    {
                        _864 = _1753;
                    }
                    frontier_phi_23_27_ladder = _864;
                    frontier_phi_23_27_ladder_1 = (_1346 * _1357) + (_1294 * _1763);
                    frontier_phi_23_27_ladder_2 = (_1337 * _1356) + (_1288 * _1762);
                    frontier_phi_23_27_ladder_3 = (_1328 * _1355) + (_1282 * _1761);
                    frontier_phi_23_27_ladder_4 = (_1357 * UniformBufferConstants_DeferredLightUniforms_m0[5u].w) * _1319;
                    frontier_phi_23_27_ladder_5 = (_1356 * UniformBufferConstants_DeferredLightUniforms_m0[5u].w) * _1310;
                    frontier_phi_23_27_ladder_6 = (_1355 * UniformBufferConstants_DeferredLightUniforms_m0[5u].w) * _1300;
                }
                else
                {
                    frontier_phi_23_27_ladder = 0.0f;
                    frontier_phi_23_27_ladder_1 = 0.0f;
                    frontier_phi_23_27_ladder_2 = 0.0f;
                    frontier_phi_23_27_ladder_3 = 0.0f;
                    frontier_phi_23_27_ladder_4 = 0.0f;
                    frontier_phi_23_27_ladder_5 = 0.0f;
                    frontier_phi_23_27_ladder_6 = 0.0f;
                }
                _851 = frontier_phi_23_27_ladder_6;
                _853 = frontier_phi_23_27_ladder_5;
                _855 = frontier_phi_23_27_ladder_4;
                _857 = frontier_phi_23_27_ladder_3;
                _859 = frontier_phi_23_27_ladder_2;
                _861 = frontier_phi_23_27_ladder_1;
                _863 = frontier_phi_23_27_ladder;
            }
            else
            {
                _851 = 0.0f;
                _853 = 0.0f;
                _855 = 0.0f;
                _857 = 0.0f;
                _859 = 0.0f;
                _861 = 0.0f;
                _863 = 0.0f;
            }
            frontier_phi_12_13_ladder = _859 + _853;
            frontier_phi_12_13_ladder_1 = _861 + _855;
            frontier_phi_12_13_ladder_2 = (UniformBufferConstants_View_m0[228u].z == 0.0f) ? _863 : 0.0f;
            frontier_phi_12_13_ladder_3 = _857 + _851;
        }
        _364 = frontier_phi_12_13_ladder_3;
        _366 = frontier_phi_12_13_ladder;
        _368 = frontier_phi_12_13_ladder_1;
        _370 = frontier_phi_12_13_ladder_2;
    }
    float preExposure = UniformBufferConstants_View_m0[136u].y;
    preExposure *= CUSTOM_LIGHTS_STRENGTH;
    SV_Target.x = preExposure * _364;
    SV_Target.y = preExposure * _366;
    SV_Target.z = preExposure * _368;
    SV_Target.w = preExposure * _370;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    TEXCOORD = stage_input.TEXCOORD;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
