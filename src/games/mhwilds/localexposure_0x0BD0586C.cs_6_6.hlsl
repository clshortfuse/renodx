cbuffer RangeCompressInfoUBO : register(b0, space0)
{
    float4 RangeCompressInfo_m0[2] : packoffset(c0);
};

cbuffer TonemapUBO : register(b1, space0)
{
    float4 Tonemap_m0[6] : packoffset(c0);
};

Texture2D<float4> RE_POSTPROCESS_Color : register(t0, space0);
Buffer<uint4> WhitePtSrv : register(t1, space0);
RWTexture2DArray<float4> imgDst0 : register(u0, space0);
RWTexture2DArray<float4> imgDst1 : register(u1, space0);
RWTexture2DArray<float4> imgDst2 : register(u2, space0);
RWTexture2DArray<float4> imgDst3 : register(u3, space0);
RWTexture2DArray<float4> imgDst4 : register(u4, space0);
RWTexture2DArray<float4> imgDst5 : register(u5, space0);
RWTexture2D<float4> LuminanceUAV : register(u6, space0);

static uint3 gl_WorkGroupID;
static uint gl_LocalInvocationIndex;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint gl_LocalInvocationIndex : SV_GroupIndex;
};

groupshared float _38[256];
groupshared float _39[256];
groupshared float _40[256];

void comp_main()
{
    uint _53 = gl_LocalInvocationIndex >> 2u;
    uint _57 = gl_LocalInvocationIndex >> 1u;
    uint _60 = gl_LocalInvocationIndex >> 3u;
    uint _66 = ((_53 & 6u) | (gl_LocalInvocationIndex & 1u)) | (_60 & 8u);
    uint _70 = ((_57 & 3u) | (_60 & 4u)) | ((gl_LocalInvocationIndex >> 7u) << 3u);
    uint _72 = gl_WorkGroupID.y << 6u;
    uint _73 = _66 << 1u;
    uint _74 = _70 << 1u;
    uint _75 = _73 | (gl_WorkGroupID.x << 6u);
    uint _79 = gl_WorkGroupID.y << 5u;
    uint _80 = _66 | (gl_WorkGroupID.x << 5u);
    uint _81 = _70 + _79;
    uint _87 = uint(float(int(_75)) * 0.5f);
    uint _88 = uint(float(int(_74 + _72)) * 0.5f);
    float4 _90 = RE_POSTPROCESS_Color.Load(int3(uint2(_87, _88), 0u));
    float _93 = _90.x;
    float _94 = _90.y;
    float _95 = _90.z;
    imgDst0[uint3(_80, _81, 0u)] = float4(_93, _94, _95, _93);
    if (asuint(Tonemap_m0[5u]).y == 0u)
    {
        float _140;
        if (asuint(Tonemap_m0[1u]).y == 0u)
        {
            _140 = 1.0f;
        }
        else
        {
            _140 = asfloat(WhitePtSrv.Load(0u).x);
        }
        float _143 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _140;
        LuminanceUAV[uint2(_80, _81)] = log2(dot(float3(_143 * _93, _143 * _94, _143 * _95), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
    }
    uint _121 = _80 | 16u;
    uint _125 = uint(float(int(_75 | 32u)) * 0.5f);
    float4 _127 = RE_POSTPROCESS_Color.Load(int3(uint2(_125, _88), 0u));
    float _129 = _127.x;
    float _130 = _127.y;
    float _131 = _127.z;
    imgDst0[uint3(_121, _81, 0u)] = float4(_129, _130, _131, _129);
    if (asuint(Tonemap_m0[5u]).y == 0u)
    {
        float _195;
        if (asuint(Tonemap_m0[1u]).y == 0u)
        {
            _195 = 1.0f;
        }
        else
        {
            _195 = asfloat(WhitePtSrv.Load(0u).x);
        }
        float _197 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _195;
        LuminanceUAV[uint2(_121, _81)] = log2(dot(float3(_197 * _129, _197 * _130, _197 * _131), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
    }
    uint _177 = (_79 | 16u) + _70;
    uint _180 = uint(float(int((_72 | 32u) + _74)) * 0.5f);
    float4 _182 = RE_POSTPROCESS_Color.Load(int3(uint2(_87, _180), 0u));
    float _184 = _182.x;
    float _185 = _182.y;
    float _186 = _182.z;
    imgDst0[uint3(_80, _177, 0u)] = float4(_184, _185, _186, _184);
    if (asuint(Tonemap_m0[5u]).y == 0u)
    {
        float _238;
        if (asuint(Tonemap_m0[1u]).y == 0u)
        {
            _238 = 1.0f;
        }
        else
        {
            _238 = asfloat(WhitePtSrv.Load(0u).x);
        }
        float _240 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _238;
        LuminanceUAV[uint2(_80, _177)] = log2(dot(float3(_240 * _184, _240 * _185, _240 * _186), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
    }
    float4 _225 = RE_POSTPROCESS_Color.Load(int3(uint2(_125, _180), 0u));
    float _227 = _225.x;
    float _228 = _225.y;
    float _229 = _225.z;
    imgDst0[uint3(_121, _177, 0u)] = float4(_227, _228, _229, _227);
    if (asuint(Tonemap_m0[5u]).y == 0u)
    {
        float _325;
        if (asuint(Tonemap_m0[1u]).y == 0u)
        {
            _325 = 1.0f;
        }
        else
        {
            _325 = asfloat(WhitePtSrv.Load(0u).x);
        }
        float _327 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _325;
        LuminanceUAV[uint2(_121, _177)] = log2(dot(float3(_327 * _227, _327 * _228, _327 * _229), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
    }
    uint _269 = WaveGetLaneIndex() & 4294967292u;
    float _272 = QuadReadLaneAt(_93, 1u);
    float _273 = QuadReadLaneAt(_94, 1u);
    float _274 = QuadReadLaneAt(_95, 1u);
    float _278 = QuadReadLaneAt(_93, 2u);
    float _279 = QuadReadLaneAt(_94, 2u);
    float _280 = QuadReadLaneAt(_95, 2u);
    float _283 = QuadReadLaneAt(_93, 3u);
    float _284 = QuadReadLaneAt(_94, 3u);
    float _285 = QuadReadLaneAt(_95, 3u);
    float _287 = QuadReadLaneAt(_129, 1u);
    float _288 = QuadReadLaneAt(_130, 1u);
    float _289 = QuadReadLaneAt(_131, 1u);
    float _291 = QuadReadLaneAt(_129, 2u);
    float _292 = QuadReadLaneAt(_130, 2u);
    float _293 = QuadReadLaneAt(_131, 2u);
    float _295 = QuadReadLaneAt(_129, 3u);
    float _296 = QuadReadLaneAt(_130, 3u);
    float _297 = QuadReadLaneAt(_131, 3u);
    float _299 = QuadReadLaneAt(_184, 1u);
    float _300 = QuadReadLaneAt(_185, 1u);
    float _301 = QuadReadLaneAt(_186, 1u);
    float _303 = QuadReadLaneAt(_184, 2u);
    float _304 = QuadReadLaneAt(_185, 2u);
    float _305 = QuadReadLaneAt(_186, 2u);
    float _307 = QuadReadLaneAt(_184, 3u);
    float _308 = QuadReadLaneAt(_185, 3u);
    float _309 = QuadReadLaneAt(_186, 3u);
    float _311 = QuadReadLaneAt(_227, 1u);
    float _312 = QuadReadLaneAt(_228, 1u);
    float _313 = QuadReadLaneAt(_229, 1u);
    float _315 = QuadReadLaneAt(_227, 2u);
    float _316 = QuadReadLaneAt(_228, 2u);
    float _317 = QuadReadLaneAt(_229, 2u);
    float _319 = QuadReadLaneAt(_227, 3u);
    float _320 = QuadReadLaneAt(_228, 3u);
    float _321 = QuadReadLaneAt(_229, 3u);
    bool _324 = (gl_LocalInvocationIndex & 3u) == 0u;
    if (_324)
    {
        uint _390 = _70 >> 1u;
        uint _391 = _66 >> 1u;
        _38[_390 + (_391 * 16u)] = (((_272 + _93) + _278) + _283) * 0.25f;
        _39[_390 + (_391 * 16u)] = (((_273 + _94) + _279) + _284) * 0.25f;
        _40[_390 + (_391 * 16u)] = (((_274 + _95) + _280) + _285) * 0.25f;
        uint _402 = _391 | 8u;
        _38[_390 + (_402 * 16u)] = (((_287 + _129) + _291) + _295) * 0.25f;
        _39[_390 + (_402 * 16u)] = (((_288 + _130) + _292) + _296) * 0.25f;
        _40[_390 + (_402 * 16u)] = (((_289 + _131) + _293) + _297) * 0.25f;
        uint _412 = _390 + 8u;
        _38[_412 + (_391 * 16u)] = (((_299 + _184) + _303) + _307) * 0.25f;
        _39[_412 + (_391 * 16u)] = (((_300 + _185) + _304) + _308) * 0.25f;
        _40[_412 + (_391 * 16u)] = (((_301 + _186) + _305) + _309) * 0.25f;
        _38[_412 + (_402 * 16u)] = (((_311 + _227) + _315) + _319) * 0.25f;
        _39[_412 + (_402 * 16u)] = (((_312 + _228) + _316) + _320) * 0.25f;
        _40[_412 + (_402 * 16u)] = (((_313 + _229) + _317) + _321) * 0.25f;
        GroupMemoryBarrierWithGroupSync();
        uint _433 = _70 + (_66 * 16u);
        uint _437 = _70 + (_66 * 16u);
        uint _441 = _70 + (_66 * 16u);
        uint _444 = gl_WorkGroupID.x << 4u;
        uint _445 = gl_WorkGroupID.y << 4u;
        uint _446 = _66 | _444;
        uint _447 = _70 + _445;
        imgDst1[uint3(_446, _447, 0u)] = float4(_38[_433], _39[_437], _40[_441], _38[_433]);
        if (asuint(Tonemap_m0[5u]).y == 1u)
        {
            float _543;
            if (asuint(Tonemap_m0[1u]).y == 0u)
            {
                _543 = 1.0f;
            }
            else
            {
                _543 = asfloat(WhitePtSrv.Load(0u).x);
            }
            float _545 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _543;
            LuminanceUAV[uint2(_446, _447)] = log2(dot(float3(_545 * _38[_433], _545 * _39[_437], _545 * _40[_441]), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
        }
        uint _504 = _66 + 1u;
        uint _506 = _70 + (_504 * 16u);
        uint _510 = _70 + (_504 * 16u);
        uint _514 = _70 + (_504 * 16u);
        uint _518 = (_444 | 1u) + _66;
        imgDst1[uint3(_518, _447, 0u)] = float4(_38[_506], _39[_510], _40[_514], _38[_506]);
        if (asuint(Tonemap_m0[5u]).y == 1u)
        {
            float _657;
            if (asuint(Tonemap_m0[1u]).y == 0u)
            {
                _657 = 1.0f;
            }
            else
            {
                _657 = asfloat(WhitePtSrv.Load(0u).x);
            }
            float _659 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _657;
            LuminanceUAV[uint2(_518, _447)] = log2(dot(float3(_659 * _38[_506], _659 * _39[_510], _659 * _40[_514]), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
        }
        uint _572 = _70 + 1u;
        uint _574 = _572 + (_66 * 16u);
        uint _578 = _572 + (_66 * 16u);
        uint _582 = _572 + (_66 * 16u);
        uint _586 = (_445 | 1u) + _70;
        imgDst1[uint3(_446, _586, 0u)] = float4(_38[_574], _39[_578], _40[_582], _38[_574]);
        if (asuint(Tonemap_m0[5u]).y == 1u)
        {
            float _777;
            if (asuint(Tonemap_m0[1u]).y == 0u)
            {
                _777 = 1.0f;
            }
            else
            {
                _777 = asfloat(WhitePtSrv.Load(0u).x);
            }
            float _779 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _777;
            LuminanceUAV[uint2(_446, _586)] = log2(dot(float3(_779 * _38[_574], _779 * _39[_578], _779 * _40[_582]), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
        }
        uint _687 = _572 + (_504 * 16u);
        uint _691 = _572 + (_504 * 16u);
        uint _695 = _572 + (_504 * 16u);
        imgDst1[uint3(_518, _586, 0u)] = float4(_38[_687], _39[_691], _40[_695], _38[_687]);
        if (asuint(Tonemap_m0[5u]).y == 1u)
        {
            float _878;
            if (asuint(Tonemap_m0[1u]).y == 0u)
            {
                _878 = 1.0f;
            }
            else
            {
                _878 = asfloat(WhitePtSrv.Load(0u).x);
            }
            float _880 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _878;
            LuminanceUAV[uint2(_518, _586)] = log2(dot(float3(_880 * _38[_687], _880 * _39[_691], _880 * _40[_695]), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
        }
    }
    GroupMemoryBarrierWithGroupSync();
    uint _457 = _70 + (_66 * 16u);
    uint _461 = _70 + (_66 * 16u);
    uint _465 = _70 + (_66 * 16u);
    float _468 = QuadReadLaneAt(_38[_457], 1u);
    float _469 = QuadReadLaneAt(_39[_461], 1u);
    float _470 = QuadReadLaneAt(_40[_465], 1u);
    float _472 = QuadReadLaneAt(_38[_457], 2u);
    float _473 = QuadReadLaneAt(_39[_461], 2u);
    float _474 = QuadReadLaneAt(_40[_465], 2u);
    float _476 = QuadReadLaneAt(_38[_457], 3u);
    float _477 = QuadReadLaneAt(_39[_461], 3u);
    float _478 = QuadReadLaneAt(_40[_465], 3u);
    float _489 = (((_468 + _38[_457]) + _472) + _476) * 0.25f;
    float _490 = (((_469 + _39[_461]) + _473) + _477) * 0.25f;
    float _491 = (((_470 + _40[_465]) + _474) + _478) * 0.25f;
    if (_324)
    {
        uint _531 = (_66 >> 1u) | (gl_WorkGroupID.x << 3u);
        uint _532 = (_70 >> 1u) + (gl_WorkGroupID.y << 3u);
        imgDst2[uint3(_531, _532, 0u)] = float4(_489, _490, _491, _489);
        if (asuint(Tonemap_m0[5u]).y == 2u)
        {
            float _706;
            if (asuint(Tonemap_m0[1u]).y == 0u)
            {
                _706 = 1.0f;
            }
            else
            {
                _706 = asfloat(WhitePtSrv.Load(0u).x);
            }
            float _708 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _706;
            LuminanceUAV[uint2(_531, _532)] = log2(dot(float3(_708 * _489, _708 * _490, _708 * _491), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
        }
        uint _608 = _66 + (_53 & 1u);
        _38[_70 + (_608 * 16u)] = _489;
        _39[_70 + (_608 * 16u)] = _490;
        _40[_70 + (_608 * 16u)] = _491;
    }
    GroupMemoryBarrierWithGroupSync();
    if (gl_LocalInvocationIndex < 64u)
    {
        uint _619 = _73 | (_57 & 1u);
        uint _621 = _74 + (_619 * 16u);
        uint _625 = _74 + (_619 * 16u);
        uint _629 = _74 + (_619 * 16u);
        float _632 = QuadReadLaneAt(_38[_621], 1u);
        float _633 = QuadReadLaneAt(_39[_625], 1u);
        float _634 = QuadReadLaneAt(_40[_629], 1u);
        float _636 = QuadReadLaneAt(_38[_621], 2u);
        float _637 = QuadReadLaneAt(_39[_625], 2u);
        float _638 = QuadReadLaneAt(_40[_629], 2u);
        float _640 = QuadReadLaneAt(_38[_621], 3u);
        float _641 = QuadReadLaneAt(_39[_625], 3u);
        float _642 = QuadReadLaneAt(_40[_629], 3u);
        float _653 = (((_632 + _38[_621]) + _636) + _640) * 0.25f;
        float _654 = (((_633 + _39[_625]) + _637) + _641) * 0.25f;
        float _655 = (((_634 + _40[_629]) + _638) + _642) * 0.25f;
        if (_324)
        {
            uint _726 = _70 >> 1u;
            uint _727 = (_66 >> 1u) + (gl_WorkGroupID.x << 2u);
            uint _728 = _726 + (gl_WorkGroupID.y << 2u);
            imgDst3[uint3(_727, _728, 0u)] = float4(_653, _654, _655, _653);
            if (asuint(Tonemap_m0[5u]).y == 3u)
            {
                float _895;
                if (asuint(Tonemap_m0[1u]).y == 0u)
                {
                    _895 = 1.0f;
                }
                else
                {
                    _895 = asfloat(WhitePtSrv.Load(0u).x);
                }
                float _897 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _895;
                LuminanceUAV[uint2(_727, _728)] = log2(dot(float3(_897 * _653, _897 * _654, _897 * _655), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
            }
            uint _818 = _73 + _726;
            _38[_74 + (_818 * 16u)] = _653;
            _39[_74 + (_818 * 16u)] = _654;
            _40[_74 + (_818 * 16u)] = _655;
        }
    }
    GroupMemoryBarrierWithGroupSync();
    if (gl_LocalInvocationIndex < 16u)
    {
        uint _737 = _70 << 2u;
        uint _739 = (_66 << 2u) + _70;
        uint _741 = _737 + (_739 * 16u);
        uint _745 = _737 + (_739 * 16u);
        uint _749 = _737 + (_739 * 16u);
        float _752 = QuadReadLaneAt(_38[_741], 1u);
        float _753 = QuadReadLaneAt(_39[_745], 1u);
        float _754 = QuadReadLaneAt(_40[_749], 1u);
        float _756 = QuadReadLaneAt(_38[_741], 2u);
        float _757 = QuadReadLaneAt(_39[_745], 2u);
        float _758 = QuadReadLaneAt(_40[_749], 2u);
        float _760 = QuadReadLaneAt(_38[_741], 3u);
        float _761 = QuadReadLaneAt(_39[_745], 3u);
        float _762 = QuadReadLaneAt(_40[_749], 3u);
        float _773 = (((_752 + _38[_741]) + _756) + _760) * 0.25f;
        float _774 = (((_753 + _39[_745]) + _757) + _761) * 0.25f;
        float _775 = (((_754 + _40[_749]) + _758) + _762) * 0.25f;
        if (_324)
        {
            uint _830 = _66 >> 1u;
            uint _832 = _830 + (gl_WorkGroupID.x << 1u);
            uint _833 = (_70 >> 1u) + (gl_WorkGroupID.y << 1u);
            imgDst4[uint3(_832, _833, 0u)] = float4(_773, _774, _775, _773);
            if (asuint(Tonemap_m0[5u]).y == 4u)
            {
                float _942;
                if (asuint(Tonemap_m0[1u]).y == 0u)
                {
                    _942 = 1.0f;
                }
                else
                {
                    _942 = asfloat(WhitePtSrv.Load(0u).x);
                }
                float _944 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _942;
                LuminanceUAV[uint2(_832, _833)] = log2(dot(float3(_944 * _773, _944 * _774, _944 * _775), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
            }
            uint _924 = _830 + _70;
            _38[0u + (_924 * 16u)] = _773;
            _39[0u + (_924 * 16u)] = _774;
            _40[0u + (_924 * 16u)] = _775;
        }
    }
    GroupMemoryBarrierWithGroupSync();
    if (gl_LocalInvocationIndex < 4u)
    {
        uint _843 = 0u + (gl_LocalInvocationIndex * 16u);
        uint _847 = 0u + (gl_LocalInvocationIndex * 16u);
        uint _851 = 0u + (gl_LocalInvocationIndex * 16u);
        float _854 = QuadReadLaneAt(_38[_843], 1u);
        float _855 = QuadReadLaneAt(_39[_847], 1u);
        float _856 = QuadReadLaneAt(_40[_851], 1u);
        float _858 = QuadReadLaneAt(_38[_843], 2u);
        float _859 = QuadReadLaneAt(_39[_847], 2u);
        float _860 = QuadReadLaneAt(_40[_851], 2u);
        float _862 = QuadReadLaneAt(_38[_843], 3u);
        float _863 = QuadReadLaneAt(_39[_847], 3u);
        float _864 = QuadReadLaneAt(_40[_851], 3u);
        float _875 = (((_854 + _38[_843]) + _858) + _862) * 0.25f;
        float _876 = (((_855 + _39[_847]) + _859) + _863) * 0.25f;
        float _877 = (((_856 + _40[_851]) + _860) + _864) * 0.25f;
        if (_324)
        {
            imgDst5[uint3(gl_WorkGroupID.x, gl_WorkGroupID.y, 0u)] = float4(_875, _876, _877, _875);
            if (asuint(Tonemap_m0[5u]).y == 5u)
            {
                float _971;
                if (asuint(Tonemap_m0[1u]).y == 0u)
                {
                    _971 = 1.0f;
                }
                else
                {
                    _971 = asfloat(WhitePtSrv.Load(0u).x);
                }
                float _973 = (RangeCompressInfo_m0[0u].y * Tonemap_m0[0u].x) * _971;
                LuminanceUAV[uint2(gl_WorkGroupID.x, gl_WorkGroupID.y)] = log2(dot(float3(_973 * _875, _973 * _876, _973 * _877), float3(0.25f, 0.5f, 0.25f)) + 9.9999997473787516355514526367188e-06f).xxxx;
            }
        }
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationIndex = stage_input.gl_LocalInvocationIndex;
    comp_main();
}
