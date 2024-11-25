#include "./shared.h"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0)
{
    float cb0_005x : packoffset(c005.x);
    float cb0_005y : packoffset(c005.y);
    float cb0_005z : packoffset(c005.z);
    float cb0_007x : packoffset(c007.x);
    float cb0_007y : packoffset(c007.y);
    float cb0_007z : packoffset(c007.z);
    float cb0_007w : packoffset(c007.w);
    float cb0_008x : packoffset(c008.x);
    float cb0_009x : packoffset(c009.x);
    float cb0_009y : packoffset(c009.y);
    float cb0_009z : packoffset(c009.z);
    float cb0_009w : packoffset(c009.w);
    float cb0_010x : packoffset(c010.x);
    float cb0_010y : packoffset(c010.y);
    float cb0_010z : packoffset(c010.z);
    float cb0_010w : packoffset(c010.w);
    float cb0_011x : packoffset(c011.x);
    float cb0_011y : packoffset(c011.y);
    float cb0_011z : packoffset(c011.z);
    float cb0_011w : packoffset(c011.w);
    float cb0_012x : packoffset(c012.x);
    float cb0_012y : packoffset(c012.y);
    float cb0_012z : packoffset(c012.z);
    float cb0_012w : packoffset(c012.w);
    float cb0_013x : packoffset(c013.x);
    float cb0_013y : packoffset(c013.y);
    float cb0_013z : packoffset(c013.z);
    float cb0_014x : packoffset(c014.x);
    float cb0_014y : packoffset(c014.y);
    float cb0_014z : packoffset(c014.z);
    float cb0_014w : packoffset(c014.w);
    float cb0_015x : packoffset(c015.x);
    float cb0_015y : packoffset(c015.y);
    float cb0_015z : packoffset(c015.z);
    float cb0_015w : packoffset(c015.w);
    float cb0_016x : packoffset(c016.x);
    float cb0_016y : packoffset(c016.y);
    float cb0_016z : packoffset(c016.z);
    float cb0_016w : packoffset(c016.w);
    float cb0_017x : packoffset(c017.x);
    float cb0_017y : packoffset(c017.y);
    float cb0_017z : packoffset(c017.z);
    float cb0_017w : packoffset(c017.w);
    float cb0_018x : packoffset(c018.x);
    float cb0_018y : packoffset(c018.y);
    float cb0_018z : packoffset(c018.z);
    float cb0_018w : packoffset(c018.w);
    float cb0_019x : packoffset(c019.x);
    float cb0_019y : packoffset(c019.y);
    float cb0_019z : packoffset(c019.z);
    float cb0_019w : packoffset(c019.w);
    float cb0_020x : packoffset(c020.x);
    float cb0_020y : packoffset(c020.y);
    float cb0_020z : packoffset(c020.z);
    float cb0_020w : packoffset(c020.w);
    float cb0_021x : packoffset(c021.x);
    float cb0_021y : packoffset(c021.y);
    float cb0_021z : packoffset(c021.z);
    float cb0_021w : packoffset(c021.w);
    float cb0_022x : packoffset(c022.x);
    float cb0_022y : packoffset(c022.y);
    float cb0_022z : packoffset(c022.z);
    float cb0_022w : packoffset(c022.w);
    float cb0_023x : packoffset(c023.x);
    float cb0_023y : packoffset(c023.y);
    float cb0_023z : packoffset(c023.z);
    float cb0_023w : packoffset(c023.w);
    float cb0_024x : packoffset(c024.x);
    float cb0_024y : packoffset(c024.y);
    float cb0_024z : packoffset(c024.z);
    float cb0_024w : packoffset(c024.w);
    float cb0_025x : packoffset(c025.x);
    float cb0_025y : packoffset(c025.y);
    float cb0_025z : packoffset(c025.z);
    float cb0_025w : packoffset(c025.w);
    float cb0_026x : packoffset(c026.x);
    float cb0_026y : packoffset(c026.y);
    float cb0_026z : packoffset(c026.z);
    float cb0_026w : packoffset(c026.w);
    float cb0_027x : packoffset(c027.x);
    float cb0_027y : packoffset(c027.y);
    float cb0_027z : packoffset(c027.z);
    float cb0_027w : packoffset(c027.w);
    float cb0_028x : packoffset(c028.x);
    float cb0_028y : packoffset(c028.y);
    float cb0_028z : packoffset(c028.z);
    float cb0_028w : packoffset(c028.w);
    float cb0_029x : packoffset(c029.x);
    float cb0_029y : packoffset(c029.y);
    float cb0_029z : packoffset(c029.z);
    float cb0_029w : packoffset(c029.w);
    float cb0_030x : packoffset(c030.x);
    float cb0_030y : packoffset(c030.y);
    float cb0_030z : packoffset(c030.z);
    float cb0_030w : packoffset(c030.w);
    float cb0_031x : packoffset(c031.x);
    float cb0_031y : packoffset(c031.y);
    float cb0_031z : packoffset(c031.z);
    float cb0_031w : packoffset(c031.w);
    float cb0_032x : packoffset(c032.x);
    float cb0_032y : packoffset(c032.y);
    float cb0_032z : packoffset(c032.z);
    float cb0_032w : packoffset(c032.w);
    float cb0_033x : packoffset(c033.x);
    float cb0_033y : packoffset(c033.y);
    float cb0_033z : packoffset(c033.z);
    float cb0_033w : packoffset(c033.w);
    float cb0_034x : packoffset(c034.x);
    float cb0_034y : packoffset(c034.y);
    float cb0_034z : packoffset(c034.z);
    float cb0_034w : packoffset(c034.w);
    float cb0_035x : packoffset(c035.x);
    float cb0_035y : packoffset(c035.y);
    float cb0_035z : packoffset(c035.z);
    float cb0_035w : packoffset(c035.w);
    float cb0_036x : packoffset(c036.x);
    float cb0_036y : packoffset(c036.y);
    float cb0_036z : packoffset(c036.z);
    float cb0_036w : packoffset(c036.w);
    float cb0_037x : packoffset(c037.x);
    uint cb0_037z : packoffset(c037.z);
    float cb0_038x : packoffset(c038.x);
    float cb0_038y : packoffset(c038.y);
    float cb0_038z : packoffset(c038.z);
    float cb0_039y : packoffset(c039.y);
    float cb0_039z : packoffset(c039.z);
    uint cb0_039w : packoffset(c039.w);
    uint cb0_040x : packoffset(c040.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target
{
    float4 SV_Target;
  // texture _1 = t1;
  // texture _2 = t0;
  // SamplerState _3 = s1;
  // SamplerState _4 = s0;
  // cbuffer _5 = cb0;
  // _6 = _5;
    uint _7 = SV_RenderTargetArrayIndex;
    float _8 = TEXCOORD.x;
    float _9 = TEXCOORD.y;
    float _10[6];
    float _11[6];
    float _12[6];
    float _13[6];
    float _14 = _8 + -0.015625f;
    float _15 = _9 + -0.015625f;
    float _16 = _14 * 1.0322580337524414f;
    float _17 = _15 * 1.0322580337524414f;
    float _18 = float(_7);
    float _19 = _18 * 0.032258063554763794f;
    uint _21 = cb0_040x;
    bool _22 = (_21 == 1);
    float _39 = 1.379158854484558f;
    float _40 = -0.3088507056236267f;
    float _41 = -0.07034677267074585f;
    float _42 = -0.06933528929948807f;
    float _43 = 1.0822921991348267f;
    float _44 = -0.012962047010660172f;
    float _45 = -0.002159259282052517f;
    float _46 = -0.045465391129255295f;
    float _47 = 1.0477596521377563f;
    float _105;
    float _106;
    float _107;
    float _825;
    float _861;
    float _872;
    float _936;
    float _1115;
    float _1126;
    float _1137;
    float _1302;
    float _1313;
    float _1464;
    float _1479;
    float _1494;
    float _1502;
    float _1503;
    float _1504;
    float _1565;
    float _1601;
    float _1612;
    float _1651;
    float _1761;
    float _1835;
    float _1909;
    float _1987;
    float _1988;
    float _1989;
    float _2122;
    float _2137;
    float _2152;
    float _2160;
    float _2161;
    float _2162;
    float _2223;
    float _2259;
    float _2270;
    float _2309;
    float _2419;
    float _2493;
    float _2567;
    float _2645;
    float _2646;
    float _2647;
    float _2800;
    float _2801;
    float _2802;
    if (!_22)
    {
        bool _24 = (_21 == 2);
        _39 = 1.02579927444458f;
        _40 = -0.020052503794431686f;
        _41 = -0.0057713985443115234f;
        _42 = -0.0022350111976265907f;
        _43 = 1.0045825242996216f;
        _44 = -0.002352306619286537f;
        _45 = -0.005014004185795784f;
        _46 = -0.025293385609984398f;
        _47 = 1.0304402112960815f;
        if (!_24)
        {
            bool _26 = (_21 == 3);
            _39 = 0.6954522132873535f;
            _40 = 0.14067870378494263f;
            _41 = 0.16386906802654266f;
            _42 = 0.044794563204050064f;
            _43 = 0.8596711158752441f;
            _44 = 0.0955343171954155f;
            _45 = -0.005525882821530104f;
            _46 = 0.004025210160762072f;
            _47 = 1.0015007257461548f;
            if (!_26)
            {
                bool _28 = (_21 == 4);
                float _29 = _28 ? 1.0f : 1.7050515413284302f;
                float _30 = _28 ? 0.0f : -0.6217905879020691f;
                float _31 = _28 ? 0.0f : -0.0832584798336029f;
                float _32 = _28 ? 0.0f : -0.13025718927383423f;
                float _33 = _28 ? 1.0f : 1.1408027410507202f;
                float _34 = _28 ? 0.0f : -0.010548528283834457f;
                float _35 = _28 ? 0.0f : -0.024003278464078903f;
                float _36 = _28 ? 0.0f : -0.1289687603712082f;
                float _37 = _28 ? 1.0f : 1.152971863746643f;
                _39 = _29;
                _40 = _30;
                _41 = _31;
                _42 = _32;
                _43 = _33;
                _44 = _34;
                _45 = _35;
                _46 = _36;
                _47 = _37;
            }
        }
    }
    uint _49 = cb0_039w;
    bool _50 = (_49 > 2);
    if (_50)
    {
        float _52 = log2(_16);
        float _53 = log2(_17);
        float _54 = log2(_19);
        float _55 = _52 * 0.012683313339948654f;
        float _56 = _53 * 0.012683313339948654f;
        float _57 = _54 * 0.012683313339948654f;
        float _58 = exp2(_55);
        float _59 = exp2(_56);
        float _60 = exp2(_57);
        float _61 = _58 + -0.8359375f;
        float _62 = _59 + -0.8359375f;
        float _63 = _60 + -0.8359375f;
        float _64 = max(0.0f, _61);
        float _65 = max(0.0f, _62);
        float _66 = max(0.0f, _63);
        float _67 = _58 * 18.6875f;
        float _68 = _59 * 18.6875f;
        float _69 = _60 * 18.6875f;
        float _70 = 18.8515625f - _67;
        float _71 = 18.8515625f - _68;
        float _72 = 18.8515625f - _69;
        float _73 = _64 / _70;
        float _74 = _65 / _71;
        float _75 = _66 / _72;
        float _76 = log2(_73);
        float _77 = log2(_74);
        float _78 = log2(_75);
        float _79 = _76 * 6.277394771575928f;
        float _80 = _77 * 6.277394771575928f;
        float _81 = _78 * 6.277394771575928f;
        float _82 = exp2(_79);
        float _83 = exp2(_80);
        float _84 = exp2(_81);
        float _85 = _82 * 100.0f;
        float _86 = _83 * 100.0f;
        float _87 = _84 * 100.0f;
        _105 = _85;
        _106 = _86;
        _107 = _87;
    }
    else
    {
        float _89 = _14 * 14.45161247253418f;
        float _90 = _89 + -6.07624626159668f;
        float _91 = _15 * 14.45161247253418f;
        float _92 = _91 + -6.07624626159668f;
        float _93 = _18 * 0.4516128897666931f;
        float _94 = _93 + -6.07624626159668f;
        float _95 = exp2(_90);
        float _96 = exp2(_92);
        float _97 = exp2(_94);
        float _98 = _95 * 0.18000000715255737f;
        float _99 = _96 * 0.18000000715255737f;
        float _100 = _97 * 0.18000000715255737f;
        float _101 = _98 + -0.002667719265446067f;
        float _102 = _99 + -0.002667719265446067f;
        float _103 = _100 + -0.002667719265446067f;
        _105 = _101;
        _106 = _102;
        _107 = _103;
    }
    float _109 = cb0_034x;
    float _110 = _109 * 1.0005563497543335f;
    float _111 = 0.9994439482688904f / _109;
    bool _112 = (_110 <= 7000.0f);
    float _113 = _111 * 4607000064.0f;
    float _114 = 2967800.0f - _113;
    float _115 = _114 * _111;
    float _116 = _115 + 99.11000061035156f;
    float _117 = _116 * _111;
    float _118 = _117 + 0.24406300485134125f;
    float _119 = _111 * 2006400000.0f;
    float _120 = 1901800.0f - _119;
    float _121 = _120 * _111;
    float _122 = _121 + 247.47999572753906f;
    float _123 = _122 * _111;
    float _124 = _123 + 0.23703999817371368f;
    float _125 = _112 ? _118 : _124;
    float _126 = _125 * _125;
    float _127 = _126 * 3.0f;
    float _128 = _125 * 2.869999885559082f;
    float _129 = _128 + -0.2750000059604645f;
    float _130 = _129 - _127;
    float _131 = _109 * 1.2864121856637212e-07f;
    float _132 = _131 + 0.00015411825734190643f;
    float _133 = _132 * _109;
    float _134 = _133 + 0.8601177334785461f;
    float _135 = _109 * 7.081451371959702e-07f;
    float _136 = _135 + 0.0008424202096648514f;
    float _137 = _136 * _109;
    float _138 = _137 + 1.0f;
    float _139 = _134 / _138;
    float _140 = _109 * 4.204816761443908e-08f;
    float _141 = _140 + 4.228062607580796e-05f;
    float _142 = _141 * _109;
    float _143 = _142 + 0.31739872694015503f;
    float _144 = _109 * 2.8974181986995973e-05f;
    float _145 = 1.0f - _144;
    float _146 = _109 * _109;
    float _147 = _146 * 1.6145605741257896e-07f;
    float _148 = _145 + _147;
    float _149 = _143 / _148;
    float _150 = _139 * 3.0f;
    float _151 = _139 * 2.0f;
    float _152 = _149 * 8.0f;
    float _153 = _151 + 4.0f;
    float _154 = _153 - _152;
    float _155 = _150 / _154;
    float _156 = _149 * 2.0f;
    float _157 = _156 / _154;
    bool _158 = (_109 < 4000.0f);
    float _159 = _158 ? _155 : _125;
    float _160 = _158 ? _157 : _130;
    float _161 = cb0_034y;
    float _162 = _109 * 1916156.25f;
    float _163 = -1137581184.0f - _162;
    float _164 = _146 * 1.5317699909210205f;
    float _165 = _163 - _164;
    float _166 = _109 + 1189.6199951171875f;
    float _167 = _166 * _109;
    float _168 = _167 + 1412139.875f;
    float _169 = _168 * _168;
    float _170 = _165 / _169;
    float _171 = _109 * 705674.0f;
    float _172 = 1974715392.0f - _171;
    float _173 = _146 * 308.60699462890625f;
    float _174 = _172 - _173;
    float _175 = _109 * 179.45599365234375f;
    float _176 = 6193636.0f - _175;
    float _177 = _176 + _146;
    float _178 = _177 * _177;
    float _179 = _174 / _178;
    float _180 = dot(float2(_170, _179), float2(_170, _179));
    float _181 = rsqrt(_180);
    float _182 = _161 * 0.05000000074505806f;
    float _183 = _182 * _179;
    float _184 = _183 * _181;
    float _185 = _184 + _139;
    float _186 = _182 * _170;
    float _187 = _186 * _181;
    float _188 = _149 - _187;
    float _189 = _185 * 3.0f;
    float _190 = _185 * 2.0f;
    float _191 = _188 * 8.0f;
    float _192 = 4.0f - _191;
    float _193 = _192 + _190;
    float _194 = _189 / _193;
    float _195 = _188 * 2.0f;
    float _196 = _195 / _193;
    float _197 = _194 - _155;
    float _198 = _196 - _157;
    float _199 = _197 + _159;
    float _200 = _198 + _160;
    uint _202 = cb0_037z;
    bool _203 = (_202 != 0);
    float _204 = _203 ? _199 : 0.3127000033855438f;
    float _205 = _203 ? _200 : 0.32899999618530273f;
    float _206 = _203 ? 0.3127000033855438f : _199;
    float _207 = _203 ? 0.32899999618530273f : _200;
    float _208 = max(_205, 1.000000013351432e-10f);
    float _209 = _204 / _208;
    float _210 = 1.0f - _204;
    float _211 = _210 - _205;
    float _212 = _211 / _208;
    float _213 = max(_207, 1.000000013351432e-10f);
    float _214 = _206 / _213;
    float _215 = 1.0f - _206;
    float _216 = _215 - _207;
    float _217 = _216 / _213;
    float _218 = _209 * 0.8950999975204468f;
    float _219 = _218 + 0.266400009393692f;
    float _220 = mad(-0.16140000522136688f, _212, _219);
    float _221 = _209 * 0.7501999735832214f;
    float _222 = 1.7135000228881836f - _221;
    float _223 = mad(0.03669999912381172f, _212, _222);
    float _224 = _209 * 0.03889999911189079f;
    float _225 = _224 + -0.06849999725818634f;
    float _226 = mad(1.0296000242233276f, _212, _225);
    float _227 = _214 * 0.8950999975204468f;
    float _228 = _227 + 0.266400009393692f;
    float _229 = mad(-0.16140000522136688f, _217, _228);
    float _230 = _214 * 0.7501999735832214f;
    float _231 = 1.7135000228881836f - _230;
    float _232 = mad(0.03669999912381172f, _217, _231);
    float _233 = _214 * 0.03889999911189079f;
    float _234 = _233 + -0.06849999725818634f;
    float _235 = mad(1.0296000242233276f, _217, _234);
    float _236 = _229 / _220;
    float _237 = _232 / _223;
    float _238 = _235 / _226;
    float _239 = mad(_237, -0.7501999735832214f, 0.0f);
    float _240 = mad(_237, 1.7135000228881836f, 0.0f);
    float _241 = mad(_237, 0.03669999912381172f, -0.0f);
    float _242 = mad(_238, 0.03889999911189079f, 0.0f);
    float _243 = mad(_238, -0.06849999725818634f, 0.0f);
    float _244 = mad(_238, 1.0296000242233276f, 0.0f);
    float _245 = _236 * 0.883457362651825f;
    float _246 = mad(-0.1470542997121811f, _239, _245);
    float _247 = mad(0.1599626988172531f, _242, _246);
    float _248 = _236 * 0.26293492317199707f;
    float _249 = mad(-0.1470542997121811f, _240, _248);
    float _250 = mad(0.1599626988172531f, _243, _249);
    float _251 = _236 * -0.15930065512657166f;
    float _252 = mad(-0.1470542997121811f, _241, _251);
    float _253 = mad(0.1599626988172531f, _244, _252);
    float _254 = _236 * 0.38695648312568665f;
    float _255 = mad(0.5183603167533875f, _239, _254);
    float _256 = mad(0.04929120093584061f, _242, _255);
    float _257 = _236 * 0.11516613513231277f;
    float _258 = mad(0.5183603167533875f, _240, _257);
    float _259 = mad(0.04929120093584061f, _243, _258);
    float _260 = _236 * -0.0697740763425827f;
    float _261 = mad(0.5183603167533875f, _241, _260);
    float _262 = mad(0.04929120093584061f, _244, _261);
    float _263 = _236 * -0.007634039502590895f;
    float _264 = mad(0.04004279896616936f, _239, _263);
    float _265 = mad(0.9684867262840271f, _242, _264);
    float _266 = _236 * -0.0022720457054674625f;
    float _267 = mad(0.04004279896616936f, _240, _266);
    float _268 = mad(0.9684867262840271f, _243, _267);
    float _269 = _236 * 0.0013765322510153055f;
    float _270 = mad(0.04004279896616936f, _241, _269);
    float _271 = mad(0.9684867262840271f, _244, _270);
    float _272 = _247 * 0.4124563932418823f;
    float _273 = mad(_250, 0.2126729041337967f, _272);
    float _274 = mad(_253, 0.01933390088379383f, _273);
    float _275 = _247 * 0.3575761020183563f;
    float _276 = mad(_250, 0.7151522040367126f, _275);
    float _277 = mad(_253, 0.11919199675321579f, _276);
    float _278 = _247 * 0.18043750524520874f;
    float _279 = mad(_250, 0.07217500358819962f, _278);
    float _280 = mad(_253, 0.9503040909767151f, _279);
    float _281 = _256 * 0.4124563932418823f;
    float _282 = mad(_259, 0.2126729041337967f, _281);
    float _283 = mad(_262, 0.01933390088379383f, _282);
    float _284 = _256 * 0.3575761020183563f;
    float _285 = mad(_259, 0.7151522040367126f, _284);
    float _286 = mad(_262, 0.11919199675321579f, _285);
    float _287 = _256 * 0.18043750524520874f;
    float _288 = mad(_259, 0.07217500358819962f, _287);
    float _289 = mad(_262, 0.9503040909767151f, _288);
    float _290 = _265 * 0.4124563932418823f;
    float _291 = mad(_268, 0.2126729041337967f, _290);
    float _292 = mad(_271, 0.01933390088379383f, _291);
    float _293 = _265 * 0.3575761020183563f;
    float _294 = mad(_268, 0.7151522040367126f, _293);
    float _295 = mad(_271, 0.11919199675321579f, _294);
    float _296 = _265 * 0.18043750524520874f;
    float _297 = mad(_268, 0.07217500358819962f, _296);
    float _298 = mad(_271, 0.9503040909767151f, _297);
    float _299 = _274 * 3.2409698963165283f;
    float _300 = mad(-1.5373831987380981f, _283, _299);
    float _301 = mad(-0.4986107647418976f, _292, _300);
    float _302 = _277 * 3.2409698963165283f;
    float _303 = mad(-1.5373831987380981f, _286, _302);
    float _304 = mad(-0.4986107647418976f, _295, _303);
    float _305 = _280 * 3.2409698963165283f;
    float _306 = mad(-1.5373831987380981f, _289, _305);
    float _307 = mad(-0.4986107647418976f, _298, _306);
    float _308 = _274 * -0.9692436456680298f;
    float _309 = mad(1.8759675025939941f, _283, _308);
    float _310 = mad(0.04155505821108818f, _292, _309);
    float _311 = _277 * -0.9692436456680298f;
    float _312 = mad(1.8759675025939941f, _286, _311);
    float _313 = mad(0.04155505821108818f, _295, _312);
    float _314 = _280 * -0.9692436456680298f;
    float _315 = mad(1.8759675025939941f, _289, _314);
    float _316 = mad(0.04155505821108818f, _298, _315);
    float _317 = _274 * 0.05563008040189743f;
    float _318 = mad(-0.20397695899009705f, _283, _317);
    float _319 = mad(1.056971549987793f, _292, _318);
    float _320 = _277 * 0.05563008040189743f;
    float _321 = mad(-0.20397695899009705f, _286, _320);
    float _322 = mad(1.056971549987793f, _295, _321);
    float _323 = _280 * 0.05563008040189743f;
    float _324 = mad(-0.20397695899009705f, _289, _323);
    float _325 = mad(1.056971549987793f, _298, _324);
    float _326 = _301 * _105;
    float _327 = mad(_304, _106, _326);
    float _328 = mad(_307, _107, _327);
    float _329 = _310 * _105;
    float _330 = mad(_313, _106, _329);
    float _331 = mad(_316, _107, _330);
    float _332 = _319 * _105;
    float _333 = mad(_322, _106, _332);
    float _334 = mad(_325, _107, _333);
    float _335 = _328 * 0.613191545009613f;
    float _336 = mad(0.3395121395587921f, _331, _335);
    float _337 = mad(0.04736635088920593f, _334, _336);
    float _338 = _328 * 0.07020691782236099f;
    float _339 = mad(0.9163357615470886f, _331, _338);
    float _340 = mad(0.01345000695437193f, _334, _339);
    float _341 = _328 * 0.020618872717022896f;
    float _342 = mad(0.1095672994852066f, _331, _341);
    float _343 = mad(0.8696067929267883f, _334, _342);
    float _344 = dot(float3(_337, _340, _343), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    float _345 = _337 / _344;
    float _346 = _340 / _344;
    float _347 = _343 / _344;
    float _348 = _345 + -1.0f;
    float _349 = _346 + -1.0f;
    float _350 = _347 + -1.0f;
    float _351 = dot(float3(_348, _349, _350), float3(_348, _349, _350));
    float _352 = _351 * -4.0f;
    float _353 = exp2(_352);
    float _354 = 1.0f - _353;
    float _356 = cb0_035z;
    float _357 = _344 * _344;
    float _358 = _357 * -4.0f;
    float _359 = _358 * _356;
    float _360 = exp2(_359);
    float _361 = 1.0f - _360;
    float _362 = _361 * _354;
    float _363 = _337 * 1.370412826538086f;
    float _364 = mad(-0.32929131388664246f, _340, _363);
    float _365 = mad(-0.06368283927440643f, _343, _364);
    float _366 = _337 * -0.08343426138162613f;
    float _367 = mad(1.0970908403396606f, _340, _366);
    float _368 = mad(-0.010861567221581936f, _343, _367);
    float _369 = _337 * -0.02579325996339321f;
    float _370 = mad(-0.09862564504146576f, _340, _369);
    float _371 = mad(1.203694462776184f, _343, _370);
    float _372 = _365 - _337;
    float _373 = _368 - _340;
    float _374 = _371 - _343;
    float _375 = _372 * _362;
    float _376 = _373 * _362;
    float _377 = _374 * _362;
    float _378 = _375 + _337;
    float _379 = _376 + _340;
    float _380 = _377 + _343;
    float _381 = dot(float3(_378, _379, _380), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    float _383 = cb0_023x;
    float _384 = cb0_023y;
    float _385 = cb0_023z;
    float _386 = cb0_023w;
    float _388 = cb0_018x;
    float _389 = cb0_018y;
    float _390 = cb0_018z;
    float _391 = cb0_018w;
    float _392 = _388 + _383;
    float _393 = _389 + _384;
    float _394 = _390 + _385;
    float _395 = _391 + _386;
    float _397 = cb0_022x;
    float _398 = cb0_022y;
    float _399 = cb0_022z;
    float _400 = cb0_022w;
    float _402 = cb0_017x;
    float _403 = cb0_017y;
    float _404 = cb0_017z;
    float _405 = cb0_017w;
    float _406 = _402 * _397;
    float _407 = _403 * _398;
    float _408 = _404 * _399;
    float _409 = _405 * _400;
    float _411 = cb0_021x;
    float _412 = cb0_021y;
    float _413 = cb0_021z;
    float _414 = cb0_021w;
    float _416 = cb0_016x;
    float _417 = cb0_016y;
    float _418 = cb0_016z;
    float _419 = cb0_016w;
    float _420 = _416 * _411;
    float _421 = _417 * _412;
    float _422 = _418 * _413;
    float _423 = _419 * _414;
    float _425 = cb0_020x;
    float _426 = cb0_020y;
    float _427 = cb0_020z;
    float _428 = cb0_020w;
    float _430 = cb0_015x;
    float _431 = cb0_015y;
    float _432 = cb0_015z;
    float _433 = cb0_015w;
    float _434 = _430 * _425;
    float _435 = _431 * _426;
    float _436 = _432 * _427;
    float _437 = _433 * _428;
    float _439 = cb0_019x;
    float _440 = cb0_019y;
    float _441 = cb0_019z;
    float _442 = cb0_019w;
    float _444 = cb0_014x;
    float _445 = cb0_014y;
    float _446 = cb0_014z;
    float _447 = cb0_014w;
    float _448 = _444 * _439;
    float _449 = _445 * _440;
    float _450 = _446 * _441;
    float _451 = _447 * _442;
    float _452 = _448 * _451;
    float _453 = _449 * _451;
    float _454 = _450 * _451;
    float _455 = _378 - _381;
    float _456 = _379 - _381;
    float _457 = _380 - _381;
    float _458 = _452 * _455;
    float _459 = _453 * _456;
    float _460 = _454 * _457;
    float _461 = _458 + _381;
    float _462 = _459 + _381;
    float _463 = _460 + _381;
    float _464 = max(0.0f, _461);
    float _465 = max(0.0f, _462);
    float _466 = max(0.0f, _463);
    float _467 = _434 * _437;
    float _468 = _435 * _437;
    float _469 = _436 * _437;
    float _470 = _464 * 5.55555534362793f;
    float _471 = _465 * 5.55555534362793f;
    float _472 = _466 * 5.55555534362793f;
    float _473 = log2(_470);
    float _474 = log2(_471);
    float _475 = log2(_472);
    float _476 = _467 * _473;
    float _477 = _468 * _474;
    float _478 = _469 * _475;
    float _479 = exp2(_476);
    float _480 = exp2(_477);
    float _481 = exp2(_478);
    float _482 = _479 * 0.18000000715255737f;
    float _483 = _480 * 0.18000000715255737f;
    float _484 = _481 * 0.18000000715255737f;
    float _485 = _420 * _423;
    float _486 = _421 * _423;
    float _487 = _422 * _423;
    float _488 = 1.0f / _485;
    float _489 = 1.0f / _486;
    float _490 = 1.0f / _487;
    float _491 = log2(_482);
    float _492 = log2(_483);
    float _493 = log2(_484);
    float _494 = _491 * _488;
    float _495 = _492 * _489;
    float _496 = _493 * _490;
    float _497 = exp2(_494);
    float _498 = exp2(_495);
    float _499 = exp2(_496);
    float _500 = _406 * _409;
    float _501 = _407 * _409;
    float _502 = _408 * _409;
    float _503 = _500 * _497;
    float _504 = _501 * _498;
    float _505 = _502 * _499;
    float _506 = _392 + _395;
    float _507 = _393 + _395;
    float _508 = _394 + _395;
    float _509 = _506 + _503;
    float _510 = _507 + _504;
    float _511 = _508 + _505;
    float _512 = cb0_034z;
    float _513 = _381 / _512;
    float _514 = saturate(_513);
    float _515 = _514 * 2.0f;
    float _516 = 3.0f - _515;
    float _517 = _514 * _514;
    float _518 = _517 * _516;
    float _519 = 1.0f - _518;
    float _521 = cb0_033x;
    float _522 = cb0_033y;
    float _523 = cb0_033z;
    float _524 = cb0_033w;
    float _525 = _388 + _521;
    float _526 = _389 + _522;
    float _527 = _390 + _523;
    float _528 = _391 + _524;
    float _530 = cb0_032x;
    float _531 = cb0_032y;
    float _532 = cb0_032z;
    float _533 = cb0_032w;
    float _534 = _402 * _530;
    float _535 = _403 * _531;
    float _536 = _404 * _532;
    float _537 = _405 * _533;
    float _539 = cb0_031x;
    float _540 = cb0_031y;
    float _541 = cb0_031z;
    float _542 = cb0_031w;
    float _543 = _416 * _539;
    float _544 = _417 * _540;
    float _545 = _418 * _541;
    float _546 = _419 * _542;
    float _548 = cb0_030x;
    float _549 = cb0_030y;
    float _550 = cb0_030z;
    float _551 = cb0_030w;
    float _552 = _430 * _548;
    float _553 = _431 * _549;
    float _554 = _432 * _550;
    float _555 = _433 * _551;
    float _557 = cb0_029x;
    float _558 = cb0_029y;
    float _559 = cb0_029z;
    float _560 = cb0_029w;
    float _561 = _444 * _557;
    float _562 = _445 * _558;
    float _563 = _446 * _559;
    float _564 = _447 * _560;
    float _565 = _561 * _564;
    float _566 = _562 * _564;
    float _567 = _563 * _564;
    float _568 = _565 * _455;
    float _569 = _566 * _456;
    float _570 = _567 * _457;
    float _571 = _568 + _381;
    float _572 = _569 + _381;
    float _573 = _570 + _381;
    float _574 = max(0.0f, _571);
    float _575 = max(0.0f, _572);
    float _576 = max(0.0f, _573);
    float _577 = _552 * _555;
    float _578 = _553 * _555;
    float _579 = _554 * _555;
    float _580 = _574 * 5.55555534362793f;
    float _581 = _575 * 5.55555534362793f;
    float _582 = _576 * 5.55555534362793f;
    float _583 = log2(_580);
    float _584 = log2(_581);
    float _585 = log2(_582);
    float _586 = _577 * _583;
    float _587 = _578 * _584;
    float _588 = _579 * _585;
    float _589 = exp2(_586);
    float _590 = exp2(_587);
    float _591 = exp2(_588);
    float _592 = _589 * 0.18000000715255737f;
    float _593 = _590 * 0.18000000715255737f;
    float _594 = _591 * 0.18000000715255737f;
    float _595 = _543 * _546;
    float _596 = _544 * _546;
    float _597 = _545 * _546;
    float _598 = 1.0f / _595;
    float _599 = 1.0f / _596;
    float _600 = 1.0f / _597;
    float _601 = log2(_592);
    float _602 = log2(_593);
    float _603 = log2(_594);
    float _604 = _601 * _598;
    float _605 = _602 * _599;
    float _606 = _603 * _600;
    float _607 = exp2(_604);
    float _608 = exp2(_605);
    float _609 = exp2(_606);
    float _610 = _534 * _537;
    float _611 = _535 * _537;
    float _612 = _536 * _537;
    float _613 = _610 * _607;
    float _614 = _611 * _608;
    float _615 = _612 * _609;
    float _616 = _525 + _528;
    float _617 = _526 + _528;
    float _618 = _527 + _528;
    float _619 = _616 + _613;
    float _620 = _617 + _614;
    float _621 = _618 + _615;
    float _622 = cb0_035x;
    float _624 = cb0_034w;
    float _625 = _622 - _624;
    float _626 = _381 - _624;
    float _627 = _626 / _625;
    float _628 = saturate(_627);
    float _629 = _628 * 2.0f;
    float _630 = 3.0f - _629;
    float _631 = _628 * _628;
    float _632 = _631 * _630;
    float _634 = cb0_028x;
    float _635 = cb0_028y;
    float _636 = cb0_028z;
    float _637 = cb0_028w;
    float _638 = _388 + _634;
    float _639 = _389 + _635;
    float _640 = _390 + _636;
    float _641 = _391 + _637;
    float _643 = cb0_027x;
    float _644 = cb0_027y;
    float _645 = cb0_027z;
    float _646 = cb0_027w;
    float _647 = _402 * _643;
    float _648 = _403 * _644;
    float _649 = _404 * _645;
    float _650 = _405 * _646;
    float _652 = cb0_026x;
    float _653 = cb0_026y;
    float _654 = cb0_026z;
    float _655 = cb0_026w;
    float _656 = _416 * _652;
    float _657 = _417 * _653;
    float _658 = _418 * _654;
    float _659 = _419 * _655;
    float _661 = cb0_025x;
    float _662 = cb0_025y;
    float _663 = cb0_025z;
    float _664 = cb0_025w;
    float _665 = _430 * _661;
    float _666 = _431 * _662;
    float _667 = _432 * _663;
    float _668 = _433 * _664;
    float _670 = cb0_024x;
    float _671 = cb0_024y;
    float _672 = cb0_024z;
    float _673 = cb0_024w;
    float _674 = _444 * _670;
    float _675 = _445 * _671;
    float _676 = _446 * _672;
    float _677 = _447 * _673;
    float _678 = _674 * _677;
    float _679 = _675 * _677;
    float _680 = _676 * _677;
    float _681 = _678 * _455;
    float _682 = _679 * _456;
    float _683 = _680 * _457;
    float _684 = _681 + _381;
    float _685 = _682 + _381;
    float _686 = _683 + _381;
    float _687 = max(0.0f, _684);
    float _688 = max(0.0f, _685);
    float _689 = max(0.0f, _686);
    float _690 = _665 * _668;
    float _691 = _666 * _668;
    float _692 = _667 * _668;
    float _693 = _687 * 5.55555534362793f;
    float _694 = _688 * 5.55555534362793f;
    float _695 = _689 * 5.55555534362793f;
    float _696 = log2(_693);
    float _697 = log2(_694);
    float _698 = log2(_695);
    float _699 = _690 * _696;
    float _700 = _691 * _697;
    float _701 = _692 * _698;
    float _702 = exp2(_699);
    float _703 = exp2(_700);
    float _704 = exp2(_701);
    float _705 = _702 * 0.18000000715255737f;
    float _706 = _703 * 0.18000000715255737f;
    float _707 = _704 * 0.18000000715255737f;
    float _708 = _656 * _659;
    float _709 = _657 * _659;
    float _710 = _658 * _659;
    float _711 = 1.0f / _708;
    float _712 = 1.0f / _709;
    float _713 = 1.0f / _710;
    float _714 = log2(_705);
    float _715 = log2(_706);
    float _716 = log2(_707);
    float _717 = _714 * _711;
    float _718 = _715 * _712;
    float _719 = _716 * _713;
    float _720 = exp2(_717);
    float _721 = exp2(_718);
    float _722 = exp2(_719);
    float _723 = _647 * _650;
    float _724 = _648 * _650;
    float _725 = _649 * _650;
    float _726 = _723 * _720;
    float _727 = _724 * _721;
    float _728 = _725 * _722;
    float _729 = _638 + _641;
    float _730 = _639 + _641;
    float _731 = _640 + _641;
    float _732 = _729 + _726;
    float _733 = _730 + _727;
    float _734 = _731 + _728;
    float _735 = _518 - _632;
    float _736 = _519 * _509;
    float _737 = _519 * _510;
    float _738 = _519 * _511;
    float _739 = _732 * _735;
    float _740 = _733 * _735;
    float _741 = _734 * _735;
    float _742 = _632 * _619;
    float _743 = _632 * _620;
    float _744 = _632 * _621;
    float _745 = _742 + _736;
    float _746 = _745 + _739;
    float _747 = _743 + _737;
    float _748 = _747 + _740;
    float _749 = _744 + _738;
    float _750 = _749 + _741;
  
    float _751 = cb0_035y; // BlueCorrect

    float _752 = _746 * 0.9386394023895264f;
    float _753 = mad(-4.540197551250458e-09f, _748, _752);
    float _754 = mad(0.061360642313957214f, _750, _753);
    float _755 = _746 * 6.775371730327606e-08f;
    float _756 = mad(0.8307942152023315f, _748, _755);
    float _757 = mad(0.169205904006958f, _750, _756);
    float _758 = _746 * -9.313225746154785e-10f;
    float _759 = mad(-2.3283064365386963e-10f, _748, _758);
    float _760 = _754 - _746;
    float _761 = _757 - _748;
    float _762 = _760 * _751;
    float _763 = _761 * _751;
    float _764 = _759 * _751;
    float _765 = _762 + _746;
    float _766 = _763 + _748;
    float _767 = _764 + _750;

    float3 ap1_graded_color = float3(_765, _766, _767);
  // Finished grading in AP1

  // start of FilmToneMap

  // Start (ACES::RRT)

  // AP1 => AP0
    float _768 = _765 * 0.6954522132873535f;
    float _769 = mad(0.14067868888378143f, _766, _768);
    float _770 = mad(0.16386905312538147f, _767, _769);
    float _771 = _765 * 0.044794581830501556f;
    float _772 = mad(0.8596711158752441f, _766, _771);
    float _773 = mad(0.0955343246459961f, _767, _772);
    float _774 = _765 * -0.005525882821530104f;
    float _775 = mad(0.004025210160762072f, _766, _774);
    float _776 = mad(1.0015007257461548f, _767, _775);
    float _777 = min(_770, _773);
    float _778 = min(_777, _776);
    float _779 = max(_770, _773);
    float _780 = max(_779, _776);
    float _781 = max(_780, 1.000000013351432e-10f);
    float _782 = max(_778, 1.000000013351432e-10f);
    float _783 = _781 - _782;
    float _784 = max(_780, 0.009999999776482582f);
    float _785 = _783 / _784;
    float _786 = _776 - _773;
    float _787 = _786 * _776;
    float _788 = _773 - _770;
    float _789 = _788 * _773;
    float _790 = _787 + _789;
    float _791 = _770 - _776;
    float _792 = _791 * _770;
    float _793 = _790 + _792;
    float _794 = sqrt(_793);
    float _795 = _794 * 1.75f;
    float _796 = _773 + _770;
    float _797 = _796 + _776;
    float _798 = _797 + _795;
    float _799 = _798 * 0.3333333432674408f;
    float _800 = _785 + -0.4000000059604645f;
    float _801 = _800 * 5.0f;
    float _802 = _800 * 2.5f;
    float _803 = abs(_802);
    float _804 = 1.0f - _803;
    float _805 = max(_804, 0.0f);
    bool _806 = (_801 > 0.0f);
    bool _807 = (_801 < 0.0f);
    int _808 = int(_806);
    int _809 = int(_807);
    int _810 = _808 - _809;
    float _811 = float(_810);
    float _812 = _805 * _805;
    float _813 = 1.0f - _812;
    float _814 = _811 * _813;
    float _815 = _814 + 1.0f;
    float _816 = _815 * 0.02500000037252903f;
    bool _817 = !(_799 <= 0.0533333346247673f);
    _825 = _816;
    if (_817)
    {
        bool _819 = !(_799 >= 0.1599999964237213f);
        _825 = 0.0f;
        if (_819)
        {
            float _821 = 0.23999999463558197f / _798;
            float _822 = _821 + -0.5f;
            float _823 = _822 * _816;
            _825 = _823;
        }
    }
    float _826 = _825 + 1.0f;
    float _827 = _826 * _770;
    float _828 = _826 * _773;
    float _829 = _826 * _776;
    bool _830 = (_827 == _828);
    bool _831 = (_828 == _829);
    bool _832 = _830 && _831;
    _861 = 0.0f;
    if (!_832)
    {
        float _834 = _827 * 2.0f;
        float _835 = _834 - _828;
        float _836 = _835 - _829;
        float _837 = _773 - _776;
        float _838 = _837 * 1.7320507764816284f;
        float _839 = _838 * _826;
        float _840 = _839 / _836;
        float _841 = atan(_840);
        float _842 = _841 + 3.1415927410125732f;
        float _843 = _841 + -3.1415927410125732f;
        bool _844 = (_836 < 0.0f);
        bool _845 = (_836 == 0.0f);
        bool _846 = (_839 >= 0.0f);
        bool _847 = (_839 < 0.0f);
        bool _848 = _846 && _844;
        float _849 = _848 ? _842 : _841;
        bool _850 = _847 && _844;
        float _851 = _850 ? _843 : _849;
        bool _852 = _847 && _845;
        bool _853 = _846 && _845;
        float _854 = _851 * 57.2957763671875f;
        float _855 = _852 ? -90.0f : _854;
        float _856 = _853 ? 90.0f : _855;
        bool _857 = (_856 < 0.0f);
        _861 = _856;
        if (_857)
        {
            float _859 = _856 + 360.0f;
            _861 = _859;
        }
    }
    float _862 = max(_861, 0.0f);
    float _863 = min(_862, 360.0f);
    bool _864 = (_863 < -180.0f);
    if (_864)
    {
        float _866 = _863 + 360.0f;
        _872 = _866;
    }
    else
    {
        bool _868 = (_863 > 180.0f);
        _872 = _863;
        if (_868)
        {
            float _870 = _863 + -360.0f;
            _872 = _870;
        }
    }
    float _873 = _872 * 0.014814814552664757f;
    float _874 = abs(_873);
    float _875 = 1.0f - _874;
    float _876 = saturate(_875);
    float _877 = _876 * 2.0f;
    float _878 = 3.0f - _877;
    float _879 = _876 * _876;
    float _880 = _879 * _878;
    float _881 = 0.029999999329447746f - _827;
    float _882 = _785 * 0.18000000715255737f;
    float _883 = _882 * _881;
    float _884 = _880 * _880;
    float _885 = _884 * _883;
    float _886 = _885 + _827;
    float _887 = _886 * 1.4514392614364624f;
    float _888 = mad(-0.2365107536315918f, _828, _887);
    float _889 = mad(-0.21492856740951538f, _829, _888);
    float _890 = _886 * -0.07655377686023712f;
    float _891 = mad(1.17622971534729f, _828, _890);
    float _892 = mad(-0.09967592358589172f, _829, _891);
    float _893 = _886 * 0.008316148072481155f;
    float _894 = mad(-0.006032449658960104f, _828, _893);
    float _895 = mad(0.9977163076400757f, _829, _894);
    float _896 = max(0.0f, _889);
    float _897 = max(0.0f, _892);
    float _898 = max(0.0f, _895);
    float _899 = dot(float3(_896, _897, _898), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    float _900 = _896 - _899;
    float _901 = _897 - _899;
    float _902 = _898 - _899;
    float _903 = _900 * 0.9599999785423279f;
    float _904 = _901 * 0.9599999785423279f;
    float _905 = _902 * 0.9599999785423279f;
    float _906 = _903 + _899;
    float _907 = _904 + _899;
    float _908 = _905 + _899;

  // End ACES::RRT

  // Custom
    float3 ap1_aces_colored = float3(_906, _907, _908);

  // Now SDR Tonemapping/Split

  // Early out with cbuffer
  // (Unreal runs the entire SDR process even if discarding)

    uint output_type = cb0_039w;

    float3 sdr_color;
    float3 hdr_color;
    float3 sdr_ap1_color;

    float _910 = cb0_036w;
    float _911 = _910 + 1.0f;
    float _912 = cb0_036y;
    float _913 = _911 - _912;
    float _915 = cb0_037x;
    float _916 = _915 + 1.0f;
    float _917 = cb0_036z;
    float _918 = _916 - _917;

    bool is_hdr = (output_type >= 3u && output_type <= 6u);
    if (injectedData.toneMapType != 0.f && is_hdr)
    {
        renodx::tonemap::Config config = renodx::tonemap::config::Create();

        config.type = injectedData.toneMapType;
        config.peak_nits = injectedData.toneMapPeakNits;
        config.game_nits = injectedData.toneMapGameNits;
        config.gamma_correction = injectedData.toneMapGammaCorrection;
        config.exposure = injectedData.colorGradeExposure;
        config.highlights = injectedData.colorGradeHighlights;
        config.shadows = injectedData.colorGradeShadows;
        config.contrast = injectedData.colorGradeContrast;
        config.saturation = injectedData.colorGradeSaturation;
        config.hue_correction_color = ap1_aces_colored;
    
    // thaumaturge settings
    //config.reno_drt_highlights = 1.20f;
    //config.reno_drt_shadows = 1.0f;
    //config.reno_drt_contrast = 1.80f;
    //config.reno_drt_saturation = 1.80f;
    
        config.reno_drt_highlights = 1.0f;
        config.reno_drt_shadows = 1.0f;
        config.reno_drt_contrast = 1.0f;
        config.reno_drt_saturation = 1.0f;
        config.reno_drt_dechroma = injectedData.colorGradeBlowout;
        config.reno_drt_flare = 0.f;

        float3 config_color = renodx::color::bt709::from::AP1(ap1_graded_color);

        renodx::tonemap::config::DualToneMap dual_tone_map = renodx::tonemap::config::ApplyToneMaps(config_color, config);
        hdr_color = dual_tone_map.color_hdr;
        sdr_color = dual_tone_map.color_sdr;
        sdr_ap1_color = renodx::color::ap1::from::BT709(sdr_color);
    }
    else
    {
        bool _919 = (_912 > 0.800000011920929f);
        float _920 = cb0_036x;
        if (_919)
        {
            float _922 = 0.8199999928474426f - _912;
            float _923 = _922 / _920;
            float _924 = _923 + -0.7447274923324585f;
            _936 = _924;
        }
        else
        {
            float _926 = _910 + 0.18000000715255737f;
            float _927 = _926 / _913;
            float _928 = 2.0f - _927;
            float _929 = _927 / _928;
            float _930 = log2(_929);
            float _931 = _930 * 0.3465735912322998f;
            float _932 = _913 / _920;
            float _933 = _931 * _932;
            float _934 = -0.7447274923324585f - _933;
            _936 = _934;
        }
        float _937 = 1.0f - _912;
        float _938 = _937 / _920;
        float _939 = _938 - _936;
        float _940 = _917 / _920;
        float _941 = _940 - _939;
        float _942 = log2(_906);
        float _943 = log2(_907);
        float _944 = log2(_908);
        float _945 = _942 * 0.3010300099849701f;
        float _946 = _943 * 0.3010300099849701f;
        float _947 = _944 * 0.3010300099849701f;
        float _948 = _945 + _939;
        float _949 = _946 + _939;
        float _950 = _947 + _939;
        float _951 = _920 * _948;
        float _952 = _920 * _949;
        float _953 = _920 * _950;
        float _954 = _913 * 2.0f;
        float _955 = _920 * -2.0f;
        float _956 = _955 / _913;
        float _957 = _945 - _936;
        float _958 = _946 - _936;
        float _959 = _947 - _936;
        float _960 = _957 * 1.4426950216293335f;
        float _961 = _960 * _956;
        float _962 = _958 * 1.4426950216293335f;
        float _963 = _962 * _956;
        float _964 = _959 * 1.4426950216293335f;
        float _965 = _964 * _956;
        float _966 = exp2(_961);
        float _967 = exp2(_963);
        float _968 = exp2(_965);
        float _969 = _966 + 1.0f;
        float _970 = _967 + 1.0f;
        float _971 = _968 + 1.0f;
        float _972 = _954 / _969;
        float _973 = _954 / _970;
        float _974 = _954 / _971;
        float _975 = _972 - _910;
        float _976 = _973 - _910;
        float _977 = _974 - _910;
        float _978 = _918 * 2.0f;
        float _979 = _920 * 2.0f;
        float _980 = _979 / _918;
        float _981 = _945 - _941;
        float _982 = _946 - _941;
        float _983 = _947 - _941;
        float _984 = _981 * 1.4426950216293335f;
        float _985 = _984 * _980;
        float _986 = _982 * 1.4426950216293335f;
        float _987 = _986 * _980;
        float _988 = _983 * 1.4426950216293335f;
        float _989 = _988 * _980;
        float _990 = exp2(_985);
        float _991 = exp2(_987);
        float _992 = exp2(_989);
        float _993 = _990 + 1.0f;
        float _994 = _991 + 1.0f;
        float _995 = _992 + 1.0f;
        float _996 = _978 / _993;
        float _997 = _978 / _994;
        float _998 = _978 / _995;
        float _999 = _916 - _996;
        float _1000 = _916 - _997;
        float _1001 = _916 - _998;
        bool _1002 = (_945 < _936);
        bool _1003 = (_946 < _936);
        bool _1004 = (_947 < _936);
        float _1005 = _1002 ? _975 : _951;
        float _1006 = _1003 ? _976 : _952;
        float _1007 = _1004 ? _977 : _953;
        bool _1008 = (_945 > _941);
        bool _1009 = (_946 > _941);
        bool _1010 = (_947 > _941);
        float _1011 = _1008 ? _999 : _951;
        float _1012 = _1009 ? _1000 : _952;
        float _1013 = _1010 ? _1001 : _953;
        float _1014 = _941 - _936;
        float _1015 = _957 / _1014;
        float _1016 = _958 / _1014;
        float _1017 = _959 / _1014;
        float _1018 = saturate(_1015);
        float _1019 = saturate(_1016);
        float _1020 = saturate(_1017);
        bool _1021 = (_941 < _936);
        float _1022 = 1.0f - _1018;
        float _1023 = 1.0f - _1019;
        float _1024 = 1.0f - _1020;
        float _1025 = _1021 ? _1022 : _1018;
        float _1026 = _1021 ? _1023 : _1019;
        float _1027 = _1021 ? _1024 : _1020;
        float _1028 = _1025 * 2.0f;
        float _1029 = _1026 * 2.0f;
        float _1030 = _1027 * 2.0f;
        float _1031 = 3.0f - _1028;
        float _1032 = 3.0f - _1029;
        float _1033 = 3.0f - _1030;
        float _1034 = _1011 - _1005;
        float _1035 = _1012 - _1006;
        float _1036 = _1013 - _1007;
        float _1037 = _1025 * _1025;
        float _1038 = _1037 * _1034;
        float _1039 = _1038 * _1031;
        float _1040 = _1026 * _1026;
        float _1041 = _1040 * _1035;
        float _1042 = _1041 * _1032;
        float _1043 = _1027 * _1027;
        float _1044 = _1043 * _1036;
        float _1045 = _1044 * _1033;
        float _1046 = _1039 + _1005;
        float _1047 = _1042 + _1006;
        float _1048 = _1045 + _1007;
        float _1049 = dot(float3(_1046, _1047, _1048), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
        float _1050 = _1046 - _1049;
        float _1051 = _1047 - _1049;
        float _1052 = _1048 - _1049;
        float _1053 = _1050 * 0.9300000071525574f;
        float _1054 = _1051 * 0.9300000071525574f;
        float _1055 = _1052 * 0.9300000071525574f;
        float _1056 = _1053 + _1049;
        float _1057 = _1054 + _1049;
        float _1058 = _1055 + _1049;
        float _1059 = max(0.0f, _1056);
        float _1060 = max(0.0f, _1057);
        float _1061 = max(0.0f, _1058);

        sdr_ap1_color = float3(_1059, _1060, _1061);
    // end of FilmToneMap
    }

    float _1062 = cb0_035w;
  //float _1063 = _1059 - _765;
  //float _1064 = _1060 - _766;
  //float _1065 = _1061 - _767;

    float _1063 = sdr_ap1_color.r - _765;
    float _1064 = sdr_ap1_color.g - _766;
    float _1065 = sdr_ap1_color.b - _767;

    float _1066 = _1062 * _1063;
    float _1067 = _1062 * _1064;
    float _1068 = _1062 * _1065;
    float _1069 = _1066 + _765;
    float _1070 = _1067 + _766;
    float _1071 = _1068 + _767;
    float _1072 = _1069 * 1.065374732017517f;
    float _1073 = mad(1.451815478503704e-06f, _1070, _1072);
    float _1074 = mad(-0.06537103652954102f, _1071, _1073);
    float _1075 = _1069 * -2.57161445915699e-07f;
    float _1076 = mad(1.2036634683609009f, _1070, _1075);
    float _1077 = mad(-0.20366770029067993f, _1071, _1076);
    float _1078 = _1069 * 1.862645149230957e-08f;
    float _1079 = mad(2.0954757928848267e-08f, _1070, _1078);
    float _1080 = mad(0.9999996423721313f, _1071, _1079);
    float _1081 = _1074 - _1069;
    float _1082 = _1077 - _1070;
    float _1083 = _1080 - _1071;
    float _1084 = _1081 * _751;
    float _1085 = _1082 * _751;
    float _1086 = _1083 * _751;
    float _1087 = _1084 + _1069;
    float _1088 = _1085 + _1070;
    float _1089 = _1086 + _1071;
    float _1090 = _1087 * 1.7050515413284302f;
    float _1091 = mad(-0.6217905879020691f, _1088, _1090);
    float _1092 = mad(-0.0832584798336029f, _1089, _1091);
    float _1093 = _1087 * -0.13025718927383423f;
    float _1094 = mad(1.1408027410507202f, _1088, _1093);
    float _1095 = mad(-0.010548528283834457f, _1089, _1094);
    float _1096 = _1087 * -0.024003278464078903f;
    float _1097 = mad(-0.1289687603712082f, _1088, _1096);
    float _1098 = mad(1.152971863746643f, _1089, _1097);
    float _1099 = max(0.0f, _1092);
    float _1100 = max(0.0f, _1095);
    float _1101 = max(0.0f, _1098);

    float3 lut_input_color = float3(_1099, _1100, _1101);

    float _1234; // custom branch 
    float _1235; // custom branch
    float _1236;  // custom branch

    if (injectedData.colorGradeLUTStrength != 1.f || injectedData.colorGradeLUTScaling != 0.f)
    {
        renodx::lut::Config lut_config = renodx::lut::config::Create(
        s0,
        injectedData.colorGradeLUTStrength,
        injectedData.colorGradeLUTScaling, renodx::lut::config::type::SRGB, renodx::lut::config::type::SRGB, 16);

        float3 post_lut_color = renodx::lut::Sample(t0, lut_config, lut_input_color);
        _1234 = post_lut_color.r;
        _1235 = post_lut_color.g;
        _1236 = post_lut_color.b;
    }
    else
    {
    // Clip color to target
        float _1102 = saturate(_1099);
        float _1103 = saturate(_1100);
        float _1104 = saturate(_1101);
        bool _1105 = (_1102 < 0.0031306699384003878f);
        if (_1105)
        {
            float _1107 = _1102 * 12.920000076293945f;
            _1115 = _1107;
        }
        else
        {
            float _1109 = log2(_1102);
            float _1110 = _1109 * 0.4166666567325592f;
            float _1111 = exp2(_1110);
            float _1112 = _1111 * 1.0549999475479126f;
            float _1113 = _1112 + -0.054999999701976776f;
            _1115 = _1113;
        }
        bool _1116 = (_1103 < 0.0031306699384003878f);
        if (_1116)
        {
            float _1118 = _1103 * 12.920000076293945f;
            _1126 = _1118;
        }
        else
        {
            float _1120 = log2(_1103);
            float _1121 = _1120 * 0.4166666567325592f;
            float _1122 = exp2(_1121);
            float _1123 = _1122 * 1.0549999475479126f;
            float _1124 = _1123 + -0.054999999701976776f;
            _1126 = _1124;
        }
        bool _1127 = (_1104 < 0.0031306699384003878f);
        if (_1127)
        {
            float _1129 = _1104 * 12.920000076293945f;
            _1137 = _1129;
        }
        else
        {
            float _1131 = log2(_1104);
            float _1132 = _1131 * 0.4166666567325592f;
            float _1133 = exp2(_1132);
            float _1134 = _1133 * 1.0549999475479126f;
            float _1135 = _1134 + -0.054999999701976776f;
            _1137 = _1135;
        }
        float _1138 = _1115 * 0.9375f;
        float _1139 = _1126 * 0.9375f;
        float _1140 = _1138 + 0.03125f;
        float _1141 = _1139 + 0.03125f;
        float _1143 = cb0_005x;
        float _1144 = _1143 * _1115;
        float _1145 = _1143 * _1126;
        float _1146 = _1143 * _1137;
        float _1147 = cb0_005y;
        float _1148 = _1137 * 15.0f;
        float _1149 = floor(_1148);
        float _1150 = _1148 - _1149;
        float _1151 = _1149 + _1140;
        float _1152 = _1151 * 0.0625f;
    // _1153 = _2;
    // _1154 = _4;
        float4 _1155 = t0.Sample(s0, float2(_1152, _1141));
        float _1156 = _1155.x;
        float _1157 = _1155.y;
        float _1158 = _1155.z;
        float _1159 = _1152 + 0.0625f;
    // _1160 = _2;
    // _1161 = _4;
        float4 _1162 = t0.Sample(s0, float2(_1159, _1141));
        float _1163 = _1162.x;
        float _1164 = _1162.y;
        float _1165 = _1162.z;
        float _1166 = _1163 - _1156;
        float _1167 = _1164 - _1157;
        float _1168 = _1165 - _1158;
        float _1169 = _1166 * _1150;
        float _1170 = _1167 * _1150;
        float _1171 = _1168 * _1150;
        float _1172 = _1169 + _1156;
        float _1173 = _1170 + _1157;
        float _1174 = _1171 + _1158;
        float _1175 = _1172 * _1147;
        float _1176 = _1173 * _1147;
        float _1177 = _1174 * _1147;
        float _1178 = _1175 + _1144;
        float _1179 = _1176 + _1145;
        float _1180 = _1177 + _1146;
        float _1182 = cb0_005z;
    // _1183 = _1;
    // _1184 = _3;
        float4 _1185 = t1.Sample(s1, float2(_1152, _1141));
        float _1186 = _1185.x;
        float _1187 = _1185.y;
        float _1188 = _1185.z;
    // _1189 = _1;
    // _1190 = _3;
        float4 _1191 = t1.Sample(s1, float2(_1159, _1141));
        float _1192 = _1191.x;
        float _1193 = _1191.y;
        float _1194 = _1191.z;
        float _1195 = _1192 - _1186;
        float _1196 = _1193 - _1187;
        float _1197 = _1194 - _1188;
        float _1198 = _1195 * _1150;
        float _1199 = _1196 * _1150;
        float _1200 = _1197 * _1150;
        float _1201 = _1198 + _1186;
        float _1202 = _1199 + _1187;
        float _1203 = _1200 + _1188;
        float _1204 = _1201 * _1182;
        float _1205 = _1202 * _1182;
        float _1206 = _1203 * _1182;
        float _1207 = _1178 + _1204;
        float _1208 = _1179 + _1205;
        float _1209 = _1180 + _1206;
        
        // fix elevated blacks
        //float _1210 = max(6.103519990574569e-05f, _1207);
        //float _1211 = max(6.103519990574569e-05f, _1208);
        //float _1212 = max(6.103519990574569e-05f, _1209);
        
        float _1210 = _1207;
        float _1211 = _1208;
        float _1212 = _1209;
        
        float _1213 = _1210 * 0.07739938050508499f;
        float _1214 = _1211 * 0.07739938050508499f;
        float _1215 = _1212 * 0.07739938050508499f;
        float _1216 = _1210 * 0.9478672742843628f;
        float _1217 = _1211 * 0.9478672742843628f;
        float _1218 = _1212 * 0.9478672742843628f;
        float _1219 = _1216 + 0.05213269963860512f;
        float _1220 = _1217 + 0.05213269963860512f;
        float _1221 = _1218 + 0.05213269963860512f;
        float _1222 = log2(_1219);
        float _1223 = log2(_1220);
        float _1224 = log2(_1221);
        float _1225 = _1222 * 2.4000000953674316f;
        float _1226 = _1223 * 2.4000000953674316f;
        float _1227 = _1224 * 2.4000000953674316f;
        float _1228 = exp2(_1225);
        float _1229 = exp2(_1226);
        float _1230 = exp2(_1227);
        bool _1231 = (_1210 > 0.040449999272823334f);
        bool _1232 = (_1211 > 0.040449999272823334f);
        bool _1233 = (_1212 > 0.040449999272823334f);
    //float _1234 = _1231 ? _1228 : _1213;
    //float _1235 = _1232 ? _1229 : _1214;
    //float _1236 = _1233 ? _1230 : _1215;
        _1234 = _1231 ? _1228 : _1213;
        _1235 = _1232 ? _1229 : _1214;
        _1236 = _1233 ? _1230 : _1215;
    }

    float _1238 = cb0_038x;
    float _1239 = _1238 * _1234;
    float _1240 = _1238 * _1235;
    float _1241 = _1238 * _1236;
    float _1242 = cb0_038y;
    float _1243 = cb0_038z;
    float _1244 = _1242 + _1239;
    float _1245 = _1244 * _1234;
    float _1246 = _1245 + _1243;
    float _1247 = _1242 + _1240;
    float _1248 = _1247 * _1235;
    float _1249 = _1248 + _1243;
    float _1250 = _1242 + _1241;
    float _1251 = _1250 * _1236;
    float _1252 = _1251 + _1243;
    float _1254 = cb0_012w;
    float _1255 = cb0_012x;
    float _1256 = cb0_012y;
    float _1257 = cb0_012z;
    float _1259 = cb0_013x;
    float _1260 = cb0_013y;
    float _1261 = cb0_013z;
    float _1262 = _1259 * _1246;
    float _1263 = _1260 * _1249;
    float _1264 = _1261 * _1252;
    float _1265 = _1255 - _1262;
    float _1266 = _1256 - _1263;
    float _1267 = _1257 - _1264;
    float _1268 = _1265 * _1254;
    float _1269 = _1266 * _1254;
    float _1270 = _1267 * _1254;
    float _1271 = _1268 + _1262;
    float _1272 = _1269 + _1263;
    float _1273 = _1270 + _1264;
    float _1275 = cb0_039y;
    float _1276 = max(0.0f, _1271);
    float _1277 = max(0.0f, _1272);
    float _1278 = max(0.0f, _1273);
    float _1279 = log2(_1276);
    float _1280 = log2(_1277);
    float _1281 = log2(_1278);
    float _1282 = _1279 * _1275;
    float _1283 = _1280 * _1275;
    float _1284 = _1281 * _1275;
    float _1285 = exp2(_1282);
    float _1286 = exp2(_1283);
    float _1287 = exp2(_1284);

    float3 film_graded_color = float3(_1285, _1286, _1287);

    if (is_hdr)
    {
        float3 final_color = saturate(film_graded_color);
        if (injectedData.toneMapType != 0.f)
        {
            final_color = renodx::tonemap::UpgradeToneMap(hdr_color, sdr_color, final_color, injectedData.colorGradeLUTStrength);
        }
        if (injectedData.toneMapGammaCorrection == 1.f)
        {
            final_color = renodx::color::correct::GammaSafe(final_color);
        }
        bool is_pq = (output_type == 3u || output_type == 4u);
        if (is_pq)
        {
            final_color = renodx::color::bt2020::from::BT709(final_color);
            final_color = renodx::color::pq::Encode(final_color, injectedData.toneMapGameNits);
        }

        return float4(final_color * 0.9523810148239136f, 0);
    }

  // Start Output
  // TONEMAPPER_OUTPUT_sRGB 0
  // TONEMAPPER_OUTPUT_Rec709 1
  // TONEMAPPER_OUTPUT_ExplicitGammaMapping 2
  // TONEMAPPER_OUTPUT_ACES1000nitST2084 3
  // TONEMAPPER_OUTPUT_ACES2000nitST2084 4
  // TONEMAPPER_OUTPUT_ACES1000nitScRGB 5
  // TONEMAPPER_OUTPUT_ACES2000nitScRGB 6
  // TONEMAPPER_OUTPUT_LinearEXR 7
  // TONEMAPPER_OUTPUT_NoToneCurve 8
  // TONEMAPPER_OUTPUT_WithToneCurve 9
  
    uint _1289 = cb0_039w;
    bool _1290 = (_1289 == 0);
    if (_1290)
    {
        bool _1292 = (_1285 < 0.0031306699384003878f);
        do
        {
            if (_1292)
            {
                float _1294 = _1285 * 12.920000076293945f;
                _1302 = _1294;
            }
            else
            {
                float _1296 = log2(_1285);
                float _1297 = _1296 * 0.4166666567325592f;
                float _1298 = exp2(_1297);
                float _1299 = _1298 * 1.0549999475479126f;
                float _1300 = _1299 + -0.054999999701976776f;
                _1302 = _1300;
            }
            bool _1303 = (_1286 < 0.0031306699384003878f);
            do
            {
                if (_1303)
                {
                    float _1305 = _1286 * 12.920000076293945f;
                    _1313 = _1305;
                }
                else
                {
                    float _1307 = log2(_1286);
                    float _1308 = _1307 * 0.4166666567325592f;
                    float _1309 = exp2(_1308);
                    float _1310 = _1309 * 1.0549999475479126f;
                    float _1311 = _1310 + -0.054999999701976776f;
                    _1313 = _1311;
                }
                bool _1314 = (_1287 < 0.0031306699384003878f);
                if (_1314)
                {
                    float _1316 = _1287 * 12.920000076293945f;
                    _2800 = _1302;
                    _2801 = _1313;
                    _2802 = _1316;
                }
                else
                {
                    float _1318 = log2(_1287);
                    float _1319 = _1318 * 0.4166666567325592f;
                    float _1320 = exp2(_1319);
                    float _1321 = _1320 * 1.0549999475479126f;
                    float _1322 = _1321 + -0.054999999701976776f;
                    _2800 = _1302;
                    _2801 = _1313;
                    _2802 = _1322;
                }
            } while (false);
        } while (false);
    }
    else
    {
        bool _1324 = (_1289 == 1);
        if (_1324)
        {
            float _1326 = _1285 * 0.613191545009613f;
            float _1327 = mad(0.3395121395587921f, _1286, _1326);
            float _1328 = mad(0.04736635088920593f, _1287, _1327);
            float _1329 = _1285 * 0.07020691782236099f;
            float _1330 = mad(0.9163357615470886f, _1286, _1329);
            float _1331 = mad(0.01345000695437193f, _1287, _1330);
            float _1332 = _1285 * 0.020618872717022896f;
            float _1333 = mad(0.1095672994852066f, _1286, _1332);
            float _1334 = mad(0.8696067929267883f, _1287, _1333);
            float _1335 = _1328 * _39;
            float _1336 = mad(_40, _1331, _1335);
            float _1337 = mad(_41, _1334, _1336);
            float _1338 = _1328 * _42;
            float _1339 = mad(_43, _1331, _1338);
            float _1340 = mad(_44, _1334, _1339);
            float _1341 = _1328 * _45;
            float _1342 = mad(_46, _1331, _1341);
            float _1343 = mad(_47, _1334, _1342);
            float _1344 = max(6.103519990574569e-05f, _1337);
            float _1345 = max(6.103519990574569e-05f, _1340);
            float _1346 = max(6.103519990574569e-05f, _1343);
            float _1347 = max(_1344, 0.017999999225139618f);
            float _1348 = max(_1345, 0.017999999225139618f);
            float _1349 = max(_1346, 0.017999999225139618f);
            float _1350 = log2(_1347);
            float _1351 = log2(_1348);
            float _1352 = log2(_1349);
            float _1353 = _1350 * 0.44999998807907104f;
            float _1354 = _1351 * 0.44999998807907104f;
            float _1355 = _1352 * 0.44999998807907104f;
            float _1356 = exp2(_1353);
            float _1357 = exp2(_1354);
            float _1358 = exp2(_1355);
            float _1359 = _1356 * 1.0989999771118164f;
            float _1360 = _1357 * 1.0989999771118164f;
            float _1361 = _1358 * 1.0989999771118164f;
            float _1362 = _1359 + -0.0989999994635582f;
            float _1363 = _1360 + -0.0989999994635582f;
            float _1364 = _1361 + -0.0989999994635582f;
            float _1365 = _1344 * 4.5f;
            float _1366 = _1345 * 4.5f;
            float _1367 = _1346 * 4.5f;
            float _1368 = min(_1365, _1362);
            float _1369 = min(_1366, _1363);
            float _1370 = min(_1367, _1364);
            _2800 = _1368;
            _2801 = _1369;
            _2802 = _1370;
        }
        else
        {
            bool _1372 = (_1289 == 3);
            bool _1373 = (_1289 == 5);
            bool _1374 = _1372 || _1373;
            if (_1374)
            {
        //   %1376 = bitcast [6 x float]* %12 to i8*
        //   %1377 = bitcast [6 x float]* %13 to i8*
                float _1379 = cb0_011w;
                float _1380 = cb0_011z;
                float _1381 = cb0_011y;
                float _1382 = cb0_011x;
                float _1384 = cb0_010x;
                float _1385 = cb0_010y;
                float _1386 = cb0_010z;
                float _1387 = cb0_010w;
                float _1389 = cb0_009x;
                float _1390 = cb0_009y;
                float _1391 = cb0_009z;
                float _1392 = cb0_009w;
                float _1394 = cb0_008x;
                float _1396 = cb0_007x;
                float _1397 = cb0_007y;
                float _1398 = cb0_007z;
                float _1399 = cb0_007w;
                _12[0] = _1389;
                _12[1] = _1390;
                _12[2] = _1391;
                _12[3] = _1392;
                _12[4] = _1382;
                _12[5] = _1382;
                _13[0] = _1384;
                _13[1] = _1385;
                _13[2] = _1386;
                _13[3] = _1387;
                _13[4] = _1381;
                _13[5] = _1381;
                float _1412 = _1380 * _1246;
                float _1413 = _1380 * _1249;
                float _1414 = _1380 * _1252;
                float _1415 = _1412 * 0.43970081210136414f;
                float _1416 = mad(0.38297808170318604f, _1413, _1415);
                float _1417 = mad(0.17733481526374817f, _1414, _1416);
                float _1418 = _1412 * 0.08979231864213943f;
                float _1419 = mad(0.8134231567382812f, _1413, _1418);
                float _1420 = mad(0.09676162153482437f, _1414, _1419);
                float _1421 = _1412 * 0.017543988302350044f;
                float _1422 = mad(0.11154405772686005f, _1413, _1421);
                float _1423 = mad(0.870704174041748f, _1414, _1422);
                float _1424 = _1417 * 1.4514392614364624f;
                float _1425 = mad(-0.2365107536315918f, _1420, _1424);
                float _1426 = mad(-0.21492856740951538f, _1423, _1425);
                float _1427 = _1417 * -0.07655377686023712f;
                float _1428 = mad(1.17622971534729f, _1420, _1427);
                float _1429 = mad(-0.09967592358589172f, _1423, _1428);
                float _1430 = _1417 * 0.008316148072481155f;
                float _1431 = mad(-0.006032449658960104f, _1420, _1430);
                float _1432 = mad(0.9977163076400757f, _1423, _1431);
                float _1433 = max(_1429, _1432);
                float _1434 = max(_1426, _1433);
                bool _1435 = (_1434 < 1.000000013351432e-10f);
                bool _1436 = (_1417 < 0.0f);
                bool _1437 = (_1420 < 0.0f);
                bool _1438 = (_1423 < 0.0f);
                bool _1439 = _1436 || _1437;
                bool _1440 = _1439 || _1438;
                bool _1441 = _1440 || _1435;
                _1502 = _1426;
                _1503 = _1429;
                _1504 = _1432;
                do
                {
                    if (!_1441)
                    {
                        float _1443 = _1434 - _1426;
                        float _1444 = abs(_1434);
                        float _1445 = _1443 / _1444;
                        float _1446 = _1434 - _1429;
                        float _1447 = _1446 / _1444;
                        float _1448 = _1434 - _1432;
                        float _1449 = _1448 / _1444;
                        bool _1450 = (_1445 < 0.8149999976158142f);
                        _1464 = _1445;
                        do
                        {
                            if (!_1450)
                            {
                                float _1452 = _1445 + -0.8149999976158142f;
                                float _1453 = _1452 * 3.0552830696105957f;
                                float _1454 = log2(_1453);
                                float _1455 = _1454 * 1.2000000476837158f;
                                float _1456 = exp2(_1455);
                                float _1457 = _1456 + 1.0f;
                                float _1458 = log2(_1457);
                                float _1459 = _1458 * 0.8333333134651184f;
                                float _1460 = exp2(_1459);
                                float _1461 = _1452 / _1460;
                                float _1462 = _1461 + 0.8149999976158142f;
                                _1464 = _1462;
                            }
                            bool _1465 = (_1447 < 0.8029999732971191f);
                            _1479 = _1447;
                            do
                            {
                                if (!_1465)
                                {
                                    float _1467 = _1447 + -0.8029999732971191f;
                                    float _1468 = _1467 * 3.4972610473632812f;
                                    float _1469 = log2(_1468);
                                    float _1470 = _1469 * 1.2000000476837158f;
                                    float _1471 = exp2(_1470);
                                    float _1472 = _1471 + 1.0f;
                                    float _1473 = log2(_1472);
                                    float _1474 = _1473 * 0.8333333134651184f;
                                    float _1475 = exp2(_1474);
                                    float _1476 = _1467 / _1475;
                                    float _1477 = _1476 + 0.8029999732971191f;
                                    _1479 = _1477;
                                }
                                bool _1480 = (_1449 < 0.8799999952316284f);
                                _1494 = _1449;
                                do
                                {
                                    if (!_1480)
                                    {
                                        float _1482 = _1449 + -0.8799999952316284f;
                                        float _1483 = _1482 * 6.810994625091553f;
                                        float _1484 = log2(_1483);
                                        float _1485 = _1484 * 1.2000000476837158f;
                                        float _1486 = exp2(_1485);
                                        float _1487 = _1486 + 1.0f;
                                        float _1488 = log2(_1487);
                                        float _1489 = _1488 * 0.8333333134651184f;
                                        float _1490 = exp2(_1489);
                                        float _1491 = _1482 / _1490;
                                        float _1492 = _1491 + 0.8799999952316284f;
                                        _1494 = _1492;
                                    }
                                    float _1495 = _1444 * _1464;
                                    float _1496 = _1434 - _1495;
                                    float _1497 = _1444 * _1479;
                                    float _1498 = _1434 - _1497;
                                    float _1499 = _1444 * _1494;
                                    float _1500 = _1434 - _1499;
                                    _1502 = _1496;
                                    _1503 = _1498;
                                    _1504 = _1500;
                                } while (false);
                            } while (false);
                        } while (false);
                    }
                    float _1505 = _1502 * 0.6954522132873535f;
                    float _1506 = mad(0.14067870378494263f, _1503, _1505);
                    float _1507 = mad(0.16386906802654266f, _1504, _1506);
                    float _1508 = _1507 - _1417;
                    float _1509 = _1507 - _1420;
                    float _1510 = _1507 - _1423;
                    float _1511 = _1508 * _1379;
                    float _1512 = _1509 * _1379;
                    float _1513 = _1510 * _1379;
                    float _1514 = _1511 + _1417;
                    float _1515 = _1512 + _1420;
                    float _1516 = _1513 + _1423;
                    float _1517 = min(_1514, _1515);
                    float _1518 = min(_1517, _1516);
                    float _1519 = max(_1514, _1515);
                    float _1520 = max(_1519, _1516);
                    float _1521 = max(_1520, 1.000000013351432e-10f);
                    float _1522 = max(_1518, 1.000000013351432e-10f);
                    float _1523 = _1521 - _1522;
                    float _1524 = max(_1520, 0.009999999776482582f);
                    float _1525 = _1523 / _1524;
                    float _1526 = _1516 - _1515;
                    float _1527 = _1526 * _1516;
                    float _1528 = _1515 - _1514;
                    float _1529 = _1528 * _1515;
                    float _1530 = _1527 + _1529;
                    float _1531 = _1514 - _1516;
                    float _1532 = _1531 * _1514;
                    float _1533 = _1530 + _1532;
                    float _1534 = sqrt(_1533);
                    float _1535 = _1516 + _1515;
                    float _1536 = _1535 + _1514;
                    float _1537 = _1534 * 1.75f;
                    float _1538 = _1536 + _1537;
                    float _1539 = _1538 * 0.3333333432674408f;
                    float _1540 = _1525 + -0.4000000059604645f;
                    float _1541 = _1540 * 5.0f;
                    float _1542 = _1540 * 2.5f;
                    float _1543 = abs(_1542);
                    float _1544 = 1.0f - _1543;
                    float _1545 = max(_1544, 0.0f);
                    bool _1546 = (_1541 > 0.0f);
                    bool _1547 = (_1541 < 0.0f);
                    int _1548 = int(_1546);
                    int _1549 = int(_1547);
                    int _1550 = _1548 - _1549;
                    float _1551 = float(_1550);
                    float _1552 = _1545 * _1545;
                    float _1553 = 1.0f - _1552;
                    float _1554 = _1551 * _1553;
                    float _1555 = _1554 + 1.0f;
                    float _1556 = _1555 * 0.02500000037252903f;
                    bool _1557 = !(_1539 <= 0.0533333346247673f);
                    _1565 = _1556;
                    do
                    {
                        if (_1557)
                        {
                            bool _1559 = !(_1539 >= 0.1599999964237213f);
                            _1565 = 0.0f;
                            if (_1559)
                            {
                                float _1561 = 0.23999999463558197f / _1538;
                                float _1562 = _1561 + -0.5f;
                                float _1563 = _1562 * _1556;
                                _1565 = _1563;
                            }
                        }
                        float _1566 = _1565 + 1.0f;
                        float _1567 = _1566 * _1514;
                        float _1568 = _1566 * _1515;
                        float _1569 = _1566 * _1516;
                        bool _1570 = (_1567 == _1568);
                        bool _1571 = (_1568 == _1569);
                        bool _1572 = _1570 && _1571;
                        _1601 = 0.0f;
                        do
                        {
                            if (!_1572)
                            {
                                float _1574 = _1567 * 2.0f;
                                float _1575 = _1574 - _1568;
                                float _1576 = _1575 - _1569;
                                float _1577 = _1515 - _1516;
                                float _1578 = _1577 * 1.7320507764816284f;
                                float _1579 = _1578 * _1566;
                                float _1580 = _1579 / _1576;
                                float _1581 = atan(_1580);
                                float _1582 = _1581 + 3.1415927410125732f;
                                float _1583 = _1581 + -3.1415927410125732f;
                                bool _1584 = (_1576 < 0.0f);
                                bool _1585 = (_1576 == 0.0f);
                                bool _1586 = (_1579 >= 0.0f);
                                bool _1587 = (_1579 < 0.0f);
                                bool _1588 = _1586 && _1584;
                                float _1589 = _1588 ? _1582 : _1581;
                                bool _1590 = _1587 && _1584;
                                float _1591 = _1590 ? _1583 : _1589;
                                bool _1592 = _1587 && _1585;
                                bool _1593 = _1586 && _1585;
                                float _1594 = _1591 * 57.2957763671875f;
                                float _1595 = _1592 ? -90.0f : _1594;
                                float _1596 = _1593 ? 90.0f : _1595;
                                bool _1597 = (_1596 < 0.0f);
                                _1601 = _1596;
                                if (_1597)
                                {
                                    float _1599 = _1596 + 360.0f;
                                    _1601 = _1599;
                                }
                            }
                            float _1602 = max(_1601, 0.0f);
                            float _1603 = min(_1602, 360.0f);
                            bool _1604 = (_1603 < -180.0f);
                            do
                            {
                                if (_1604)
                                {
                                    float _1606 = _1603 + 360.0f;
                                    _1612 = _1606;
                                }
                                else
                                {
                                    bool _1608 = (_1603 > 180.0f);
                                    _1612 = _1603;
                                    if (_1608)
                                    {
                                        float _1610 = _1603 + -360.0f;
                                        _1612 = _1610;
                                    }
                                }
                                bool _1613 = (_1612 > -67.5f);
                                bool _1614 = (_1612 < 67.5f);
                                bool _1615 = _1613 && _1614;
                                _1651 = 0.0f;
                                do
                                {
                                    if (_1615)
                                    {
                                        float _1617 = _1612 + 67.5f;
                                        float _1618 = _1617 * 0.029629629105329514f;
                                        int _1619 = int(_1618);
                                        float _1620 = float(_1619);
                                        float _1621 = _1618 - _1620;
                                        float _1622 = _1621 * _1621;
                                        float _1623 = _1622 * _1621;
                                        bool _1624 = (_1619 == 3);
                                        if (_1624)
                                        {
                                            float _1626 = _1623 * 0.1666666716337204f;
                                            float _1627 = _1622 * 0.5f;
                                            float _1628 = _1621 * 0.5f;
                                            float _1629 = 0.1666666716337204f - _1628;
                                            float _1630 = _1629 + _1627;
                                            float _1631 = _1630 - _1626;
                                            _1651 = _1631;
                                        }
                                        else
                                        {
                                            bool _1633 = (_1619 == 2);
                                            if (_1633)
                                            {
                                                float _1635 = _1623 * 0.5f;
                                                float _1636 = 0.6666666865348816f - _1622;
                                                float _1637 = _1636 + _1635;
                                                _1651 = _1637;
                                            }
                                            else
                                            {
                                                bool _1639 = (_1619 == 1);
                                                if (_1639)
                                                {
                                                    float _1641 = _1623 * -0.5f;
                                                    float _1642 = _1622 + _1621;
                                                    float _1643 = _1642 * 0.5f;
                                                    float _1644 = _1641 + 0.1666666716337204f;
                                                    float _1645 = _1644 + _1643;
                                                    _1651 = _1645;
                                                }
                                                else
                                                {
                                                    bool _1647 = (_1619 == 0);
                                                    float _1648 = _1623 * 0.1666666716337204f;
                                                    float _1649 = _1647 ? _1648 : 0.0f;
                                                    _1651 = _1649;
                                                }
                                            }
                                        }
                                    }
                                    float _1652 = 0.029999999329447746f - _1567;
                                    float _1653 = _1525 * 0.27000001072883606f;
                                    float _1654 = _1653 * _1652;
                                    float _1655 = _1654 * _1651;
                                    float _1656 = _1655 + _1567;
                                    float _1657 = max(_1656, 0.0f);
                                    float _1658 = max(_1568, 0.0f);
                                    float _1659 = max(_1569, 0.0f);
                                    float _1660 = min(_1657, 65535.0f);
                                    float _1661 = min(_1658, 65535.0f);
                                    float _1662 = min(_1659, 65535.0f);
                                    float _1663 = _1660 * 1.4514392614364624f;
                                    float _1664 = mad(-0.2365107536315918f, _1661, _1663);
                                    float _1665 = mad(-0.21492856740951538f, _1662, _1664);
                                    float _1666 = _1660 * -0.07655377686023712f;
                                    float _1667 = mad(1.17622971534729f, _1661, _1666);
                                    float _1668 = mad(-0.09967592358589172f, _1662, _1667);
                                    float _1669 = _1660 * 0.008316148072481155f;
                                    float _1670 = mad(-0.006032449658960104f, _1661, _1669);
                                    float _1671 = mad(0.9977163076400757f, _1662, _1670);
                                    float _1672 = max(_1665, 0.0f);
                                    float _1673 = max(_1668, 0.0f);
                                    float _1674 = max(_1671, 0.0f);
                                    float _1675 = min(_1672, 65504.0f);
                                    float _1676 = min(_1673, 65504.0f);
                                    float _1677 = min(_1674, 65504.0f);
                                    float _1678 = dot(float3(_1675, _1676, _1677), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                                    float _1679 = _1675 - _1678;
                                    float _1680 = _1676 - _1678;
                                    float _1681 = _1677 - _1678;
                                    float _1682 = _1679 * 0.9599999785423279f;
                                    float _1683 = _1680 * 0.9599999785423279f;
                                    float _1684 = _1681 * 0.9599999785423279f;
                                    float _1685 = _1682 + _1678;
                                    float _1686 = _1683 + _1678;
                                    float _1687 = _1684 + _1678;
                                    float _1688 = max(_1685, 1.000000013351432e-10f);
                                    float _1689 = log2(_1688);
                                    float _1690 = _1689 * 0.3010300099849701f;
                                    float _1691 = log2(_1396);
                                    float _1692 = _1691 * 0.3010300099849701f;
                                    bool _1693 = !(_1690 <= _1692);
                                    do
                                    {
                                        if (!_1693)
                                        {
                                            float _1695 = log2(_1397);
                                            float _1696 = _1695 * 0.3010300099849701f;
                                            _1761 = _1696;
                                        }
                                        else
                                        {
                                            bool _1698 = (_1690 > _1692);
                                            float _1699 = log2(_1394);
                                            float _1700 = _1699 * 0.3010300099849701f;
                                            bool _1701 = (_1690 < _1700);
                                            bool _1702 = _1698 && _1701;
                                            if (_1702)
                                            {
                                                float _1704 = _1689 - _1691;
                                                float _1705 = _1704 * 0.9030900001525879f;
                                                float _1706 = _1699 - _1691;
                                                float _1707 = _1706 * 0.3010300099849701f;
                                                float _1708 = _1705 / _1707;
                                                int _1709 = int(_1708);
                                                float _1710 = float(_1709);
                                                float _1711 = _1708 - _1710;
                                                float _1713 = _12[_1709];
                                                int _1714 = _1709 + 1;
                                                float _1716 = _12[_1714];
                                                int _1717 = _1709 + 2;
                                                float _1719 = _12[_1717];
                                                float _1720 = _1711 * _1711;
                                                float _1721 = _1713 * 0.5f;
                                                float _1722 = mad(_1716, -1.0f, _1721);
                                                float _1723 = mad(_1719, 0.5f, _1722);
                                                float _1724 = _1716 - _1713;
                                                float _1725 = mad(_1716, 0.5f, _1721);
                                                float _1726 = dot(float3(_1720, _1711, 1.0f), float3(_1723, _1724, _1725));
                                                _1761 = _1726;
                                            }
                                            else
                                            {
                                                bool _1728 = (_1690 >= _1700);
                                                float _1729 = log2(_1398);
                                                float _1730 = _1729 * 0.3010300099849701f;
                                                bool _1731 = (_1690 < _1730);
                                                bool _1732 = _1728 && _1731;
                                                if (_1732)
                                                {
                                                    float _1734 = _1689 - _1699;
                                                    float _1735 = _1734 * 0.9030900001525879f;
                                                    float _1736 = _1729 - _1699;
                                                    float _1737 = _1736 * 0.3010300099849701f;
                                                    float _1738 = _1735 / _1737;
                                                    int _1739 = int(_1738);
                                                    float _1740 = float(_1739);
                                                    float _1741 = _1738 - _1740;
                                                    float _1743 = _13[_1739];
                                                    int _1744 = _1739 + 1;
                                                    float _1746 = _13[_1744];
                                                    int _1747 = _1739 + 2;
                                                    float _1749 = _13[_1747];
                                                    float _1750 = _1741 * _1741;
                                                    float _1751 = _1743 * 0.5f;
                                                    float _1752 = mad(_1746, -1.0f, _1751);
                                                    float _1753 = mad(_1749, 0.5f, _1752);
                                                    float _1754 = _1746 - _1743;
                                                    float _1755 = mad(_1746, 0.5f, _1751);
                                                    float _1756 = dot(float3(_1750, _1741, 1.0f), float3(_1753, _1754, _1755));
                                                    _1761 = _1756;
                                                }
                                                else
                                                {
                                                    float _1758 = log2(_1399);
                                                    float _1759 = _1758 * 0.3010300099849701f;
                                                    _1761 = _1759;
                                                }
                                            }
                                        }
                                        float _1762 = _1761 * 3.321928024291992f;
                                        float _1763 = exp2(_1762);
                                        float _1764 = max(_1686, 1.000000013351432e-10f);
                                        float _1765 = log2(_1764);
                                        float _1766 = _1765 * 0.3010300099849701f;
                                        bool _1767 = !(_1766 <= _1692);
                                        do
                                        {
                                            if (!_1767)
                                            {
                                                float _1769 = log2(_1397);
                                                float _1770 = _1769 * 0.3010300099849701f;
                                                _1835 = _1770;
                                            }
                                            else
                                            {
                                                bool _1772 = (_1766 > _1692);
                                                float _1773 = log2(_1394);
                                                float _1774 = _1773 * 0.3010300099849701f;
                                                bool _1775 = (_1766 < _1774);
                                                bool _1776 = _1772 && _1775;
                                                if (_1776)
                                                {
                                                    float _1778 = _1765 - _1691;
                                                    float _1779 = _1778 * 0.9030900001525879f;
                                                    float _1780 = _1773 - _1691;
                                                    float _1781 = _1780 * 0.3010300099849701f;
                                                    float _1782 = _1779 / _1781;
                                                    int _1783 = int(_1782);
                                                    float _1784 = float(_1783);
                                                    float _1785 = _1782 - _1784;
                                                    float _1787 = _12[_1783];
                                                    int _1788 = _1783 + 1;
                                                    float _1790 = _12[_1788];
                                                    int _1791 = _1783 + 2;
                                                    float _1793 = _12[_1791];
                                                    float _1794 = _1785 * _1785;
                                                    float _1795 = _1787 * 0.5f;
                                                    float _1796 = mad(_1790, -1.0f, _1795);
                                                    float _1797 = mad(_1793, 0.5f, _1796);
                                                    float _1798 = _1790 - _1787;
                                                    float _1799 = mad(_1790, 0.5f, _1795);
                                                    float _1800 = dot(float3(_1794, _1785, 1.0f), float3(_1797, _1798, _1799));
                                                    _1835 = _1800;
                                                }
                                                else
                                                {
                                                    bool _1802 = (_1766 >= _1774);
                                                    float _1803 = log2(_1398);
                                                    float _1804 = _1803 * 0.3010300099849701f;
                                                    bool _1805 = (_1766 < _1804);
                                                    bool _1806 = _1802 && _1805;
                                                    if (_1806)
                                                    {
                                                        float _1808 = _1765 - _1773;
                                                        float _1809 = _1808 * 0.9030900001525879f;
                                                        float _1810 = _1803 - _1773;
                                                        float _1811 = _1810 * 0.3010300099849701f;
                                                        float _1812 = _1809 / _1811;
                                                        int _1813 = int(_1812);
                                                        float _1814 = float(_1813);
                                                        float _1815 = _1812 - _1814;
                                                        float _1817 = _13[_1813];
                                                        int _1818 = _1813 + 1;
                                                        float _1820 = _13[_1818];
                                                        int _1821 = _1813 + 2;
                                                        float _1823 = _13[_1821];
                                                        float _1824 = _1815 * _1815;
                                                        float _1825 = _1817 * 0.5f;
                                                        float _1826 = mad(_1820, -1.0f, _1825);
                                                        float _1827 = mad(_1823, 0.5f, _1826);
                                                        float _1828 = _1820 - _1817;
                                                        float _1829 = mad(_1820, 0.5f, _1825);
                                                        float _1830 = dot(float3(_1824, _1815, 1.0f), float3(_1827, _1828, _1829));
                                                        _1835 = _1830;
                                                    }
                                                    else
                                                    {
                                                        float _1832 = log2(_1399);
                                                        float _1833 = _1832 * 0.3010300099849701f;
                                                        _1835 = _1833;
                                                    }
                                                }
                                            }
                                            float _1836 = _1835 * 3.321928024291992f;
                                            float _1837 = exp2(_1836);
                                            float _1838 = max(_1687, 1.000000013351432e-10f);
                                            float _1839 = log2(_1838);
                                            float _1840 = _1839 * 0.3010300099849701f;
                                            bool _1841 = !(_1840 <= _1692);
                                            do
                                            {
                                                if (!_1841)
                                                {
                                                    float _1843 = log2(_1397);
                                                    float _1844 = _1843 * 0.3010300099849701f;
                                                    _1909 = _1844;
                                                }
                                                else
                                                {
                                                    bool _1846 = (_1840 > _1692);
                                                    float _1847 = log2(_1394);
                                                    float _1848 = _1847 * 0.3010300099849701f;
                                                    bool _1849 = (_1840 < _1848);
                                                    bool _1850 = _1846 && _1849;
                                                    if (_1850)
                                                    {
                                                        float _1852 = _1839 - _1691;
                                                        float _1853 = _1852 * 0.9030900001525879f;
                                                        float _1854 = _1847 - _1691;
                                                        float _1855 = _1854 * 0.3010300099849701f;
                                                        float _1856 = _1853 / _1855;
                                                        int _1857 = int(_1856);
                                                        float _1858 = float(_1857);
                                                        float _1859 = _1856 - _1858;
                                                        float _1861 = _12[_1857];
                                                        int _1862 = _1857 + 1;
                                                        float _1864 = _12[_1862];
                                                        int _1865 = _1857 + 2;
                                                        float _1867 = _12[_1865];
                                                        float _1868 = _1859 * _1859;
                                                        float _1869 = _1861 * 0.5f;
                                                        float _1870 = mad(_1864, -1.0f, _1869);
                                                        float _1871 = mad(_1867, 0.5f, _1870);
                                                        float _1872 = _1864 - _1861;
                                                        float _1873 = mad(_1864, 0.5f, _1869);
                                                        float _1874 = dot(float3(_1868, _1859, 1.0f), float3(_1871, _1872, _1873));
                                                        _1909 = _1874;
                                                    }
                                                    else
                                                    {
                                                        bool _1876 = (_1840 >= _1848);
                                                        float _1877 = log2(_1398);
                                                        float _1878 = _1877 * 0.3010300099849701f;
                                                        bool _1879 = (_1840 < _1878);
                                                        bool _1880 = _1876 && _1879;
                                                        if (_1880)
                                                        {
                                                            float _1882 = _1839 - _1847;
                                                            float _1883 = _1882 * 0.9030900001525879f;
                                                            float _1884 = _1877 - _1847;
                                                            float _1885 = _1884 * 0.3010300099849701f;
                                                            float _1886 = _1883 / _1885;
                                                            int _1887 = int(_1886);
                                                            float _1888 = float(_1887);
                                                            float _1889 = _1886 - _1888;
                                                            float _1891 = _13[_1887];
                                                            int _1892 = _1887 + 1;
                                                            float _1894 = _13[_1892];
                                                            int _1895 = _1887 + 2;
                                                            float _1897 = _13[_1895];
                                                            float _1898 = _1889 * _1889;
                                                            float _1899 = _1891 * 0.5f;
                                                            float _1900 = mad(_1894, -1.0f, _1899);
                                                            float _1901 = mad(_1897, 0.5f, _1900);
                                                            float _1902 = _1894 - _1891;
                                                            float _1903 = mad(_1894, 0.5f, _1899);
                                                            float _1904 = dot(float3(_1898, _1889, 1.0f), float3(_1901, _1902, _1903));
                                                            _1909 = _1904;
                                                        }
                                                        else
                                                        {
                                                            float _1906 = log2(_1399);
                                                            float _1907 = _1906 * 0.3010300099849701f;
                                                            _1909 = _1907;
                                                        }
                                                    }
                                                }
                                                float _1910 = _1909 * 3.321928024291992f;
                                                float _1911 = exp2(_1910);
                                                float _1912 = _1763 - _1397;
                                                float _1913 = _1399 - _1397;
                                                float _1914 = _1912 / _1913;
                                                float _1915 = _1837 - _1397;
                                                float _1916 = _1915 / _1913;
                                                float _1917 = _1911 - _1397;
                                                float _1918 = _1917 / _1913;
                                                float _1919 = _1914 * 0.6624541878700256f;
                                                float _1920 = mad(0.13400420546531677f, _1916, _1919);
                                                float _1921 = mad(0.15618768334388733f, _1918, _1920);
                                                float _1922 = _1914 * 0.2722287178039551f;
                                                float _1923 = mad(0.6740817427635193f, _1916, _1922);
                                                float _1924 = mad(0.053689517080783844f, _1918, _1923);
                                                float _1925 = _1914 * -0.005574649665504694f;
                                                float _1926 = mad(0.00406073359772563f, _1916, _1925);
                                                float _1927 = mad(1.0103391408920288f, _1918, _1926);
                                                float _1928 = _1921 * 1.6410233974456787f;
                                                float _1929 = mad(-0.32480329275131226f, _1924, _1928);
                                                float _1930 = mad(-0.23642469942569733f, _1927, _1929);
                                                float _1931 = _1921 * -0.663662850856781f;
                                                float _1932 = mad(1.6153316497802734f, _1924, _1931);
                                                float _1933 = mad(0.016756348311901093f, _1927, _1932);
                                                float _1934 = _1921 * 0.011721894145011902f;
                                                float _1935 = mad(-0.008284442126750946f, _1924, _1934);
                                                float _1936 = mad(0.9883948564529419f, _1927, _1935);
                                                float _1937 = max(_1930, 0.0f);
                                                float _1938 = max(_1933, 0.0f);
                                                float _1939 = max(_1936, 0.0f);
                                                float _1940 = min(_1937, 1.0f);
                                                float _1941 = min(_1938, 1.0f);
                                                float _1942 = min(_1939, 1.0f);
                                                float _1943 = _1940 * 0.6624541878700256f;
                                                float _1944 = mad(0.13400420546531677f, _1941, _1943);
                                                float _1945 = mad(0.15618768334388733f, _1942, _1944);
                                                float _1946 = _1940 * 0.2722287178039551f;
                                                float _1947 = mad(0.6740817427635193f, _1941, _1946);
                                                float _1948 = mad(0.053689517080783844f, _1942, _1947);
                                                float _1949 = _1940 * -0.005574649665504694f;
                                                float _1950 = mad(0.00406073359772563f, _1941, _1949);
                                                float _1951 = mad(1.0103391408920288f, _1942, _1950);
                                                float _1952 = _1945 * 1.6410233974456787f;
                                                float _1953 = mad(-0.32480329275131226f, _1948, _1952);
                                                float _1954 = mad(-0.23642469942569733f, _1951, _1953);
                                                float _1955 = _1945 * -0.663662850856781f;
                                                float _1956 = mad(1.6153316497802734f, _1948, _1955);
                                                float _1957 = mad(0.016756348311901093f, _1951, _1956);
                                                float _1958 = _1945 * 0.011721894145011902f;
                                                float _1959 = mad(-0.008284442126750946f, _1948, _1958);
                                                float _1960 = mad(0.9883948564529419f, _1951, _1959);
                                                float _1961 = max(_1954, 0.0f);
                                                float _1962 = max(_1957, 0.0f);
                                                float _1963 = max(_1960, 0.0f);
                                                float _1964 = min(_1961, 65535.0f);
                                                float _1965 = min(_1962, 65535.0f);
                                                float _1966 = min(_1963, 65535.0f);
                                                float _1967 = _1964 * _1399;
                                                float _1968 = _1965 * _1399;
                                                float _1969 = _1966 * _1399;
                                                float _1970 = max(_1967, 0.0f);
                                                float _1971 = max(_1968, 0.0f);
                                                float _1972 = max(_1969, 0.0f);
                                                float _1973 = min(_1970, 65535.0f);
                                                float _1974 = min(_1971, 65535.0f);
                                                float _1975 = min(_1972, 65535.0f);
                                                _1987 = _1973;
                                                _1988 = _1974;
                                                _1989 = _1975;
                                                do
                                                {
                                                    if (!_1373)
                                                    {
                                                        float _1977 = _1973 * _39;
                                                        float _1978 = mad(_40, _1974, _1977);
                                                        float _1979 = mad(_41, _1975, _1978);
                                                        float _1980 = _1973 * _42;
                                                        float _1981 = mad(_43, _1974, _1980);
                                                        float _1982 = mad(_44, _1975, _1981);
                                                        float _1983 = _1973 * _45;
                                                        float _1984 = mad(_46, _1974, _1983);
                                                        float _1985 = mad(_47, _1975, _1984);
                                                        _1987 = _1979;
                                                        _1988 = _1982;
                                                        _1989 = _1985;
                                                    }
                                                    float _1990 = _1987 * 9.999999747378752e-05f;
                                                    float _1991 = _1988 * 9.999999747378752e-05f;
                                                    float _1992 = _1989 * 9.999999747378752e-05f;
                                                    float _1993 = log2(_1990);
                                                    float _1994 = log2(_1991);
                                                    float _1995 = log2(_1992);
                                                    float _1996 = _1993 * 0.1593017578125f;
                                                    float _1997 = _1994 * 0.1593017578125f;
                                                    float _1998 = _1995 * 0.1593017578125f;
                                                    float _1999 = exp2(_1996);
                                                    float _2000 = exp2(_1997);
                                                    float _2001 = exp2(_1998);
                                                    float _2002 = _1999 * 18.8515625f;
                                                    float _2003 = _2000 * 18.8515625f;
                                                    float _2004 = _2001 * 18.8515625f;
                                                    float _2005 = _2002 + 0.8359375f;
                                                    float _2006 = _2003 + 0.8359375f;
                                                    float _2007 = _2004 + 0.8359375f;
                                                    float _2008 = _1999 * 18.6875f;
                                                    float _2009 = _2000 * 18.6875f;
                                                    float _2010 = _2001 * 18.6875f;
                                                    float _2011 = _2008 + 1.0f;
                                                    float _2012 = _2009 + 1.0f;
                                                    float _2013 = _2010 + 1.0f;
                                                    float _2014 = 1.0f / _2011;
                                                    float _2015 = 1.0f / _2012;
                                                    float _2016 = 1.0f / _2013;
                                                    float _2017 = _2014 * _2005;
                                                    float _2018 = _2015 * _2006;
                                                    float _2019 = _2016 * _2007;
                                                    float _2020 = log2(_2017);
                                                    float _2021 = log2(_2018);
                                                    float _2022 = log2(_2019);
                                                    float _2023 = _2020 * 78.84375f;
                                                    float _2024 = _2021 * 78.84375f;
                                                    float _2025 = _2022 * 78.84375f;
                                                    float _2026 = exp2(_2023);
                                                    float _2027 = exp2(_2024);
                                                    float _2028 = exp2(_2025);
                                                    _2800 = _2026;
                                                    _2801 = _2027;
                                                    _2802 = _2028;
                                                } while (false);
                                            } while (false);
                                        } while (false);
                                    } while (false);
                                } while (false);
                            } while (false);
                        } while (false);
                    } while (false);
                } while (false);
            }
            else
            {
                bool _2030 = (_1289 == 6);
                int _2031 = _1289 & -3;
                bool _2032 = (_2031 == 4);
                if (_2032)
                {
          //   %2034 = bitcast [6 x float]* %10 to i8*
          //   %2035 = bitcast [6 x float]* %11 to i8*
                    float _2037 = cb0_011w;
                    float _2038 = cb0_011z;
                    float _2039 = cb0_011y;
                    float _2040 = cb0_011x;
                    float _2042 = cb0_010x;
                    float _2043 = cb0_010y;
                    float _2044 = cb0_010z;
                    float _2045 = cb0_010w;
                    float _2047 = cb0_009x;
                    float _2048 = cb0_009y;
                    float _2049 = cb0_009z;
                    float _2050 = cb0_009w;
                    float _2052 = cb0_008x;
                    float _2054 = cb0_007x;
                    float _2055 = cb0_007y;
                    float _2056 = cb0_007z;
                    float _2057 = cb0_007w;
                    _10[0] = _2047;
                    _10[1] = _2048;
                    _10[2] = _2049;
                    _10[3] = _2050;
                    _10[4] = _2040;
                    _10[5] = _2040;
                    _11[0] = _2042;
                    _11[1] = _2043;
                    _11[2] = _2044;
                    _11[3] = _2045;
                    _11[4] = _2039;
                    _11[5] = _2039;
                    float _2070 = _2038 * _1246;
                    float _2071 = _2038 * _1249;
                    float _2072 = _2038 * _1252;
                    float _2073 = _2070 * 0.43970081210136414f;
                    float _2074 = mad(0.38297808170318604f, _2071, _2073);
                    float _2075 = mad(0.17733481526374817f, _2072, _2074);
                    float _2076 = _2070 * 0.08979231864213943f;
                    float _2077 = mad(0.8134231567382812f, _2071, _2076);
                    float _2078 = mad(0.09676162153482437f, _2072, _2077);
                    float _2079 = _2070 * 0.017543988302350044f;
                    float _2080 = mad(0.11154405772686005f, _2071, _2079);
                    float _2081 = mad(0.870704174041748f, _2072, _2080);
                    float _2082 = _2075 * 1.4514392614364624f;
                    float _2083 = mad(-0.2365107536315918f, _2078, _2082);
                    float _2084 = mad(-0.21492856740951538f, _2081, _2083);
                    float _2085 = _2075 * -0.07655377686023712f;
                    float _2086 = mad(1.17622971534729f, _2078, _2085);
                    float _2087 = mad(-0.09967592358589172f, _2081, _2086);
                    float _2088 = _2075 * 0.008316148072481155f;
                    float _2089 = mad(-0.006032449658960104f, _2078, _2088);
                    float _2090 = mad(0.9977163076400757f, _2081, _2089);
                    float _2091 = max(_2087, _2090);
                    float _2092 = max(_2084, _2091);
                    bool _2093 = (_2092 < 1.000000013351432e-10f);
                    bool _2094 = (_2075 < 0.0f);
                    bool _2095 = (_2078 < 0.0f);
                    bool _2096 = (_2081 < 0.0f);
                    bool _2097 = _2094 || _2095;
                    bool _2098 = _2097 || _2096;
                    bool _2099 = _2098 || _2093;
                    _2160 = _2084;
                    _2161 = _2087;
                    _2162 = _2090;
                    do
                    {
                        if (!_2099)
                        {
                            float _2101 = _2092 - _2084;
                            float _2102 = abs(_2092);
                            float _2103 = _2101 / _2102;
                            float _2104 = _2092 - _2087;
                            float _2105 = _2104 / _2102;
                            float _2106 = _2092 - _2090;
                            float _2107 = _2106 / _2102;
                            bool _2108 = (_2103 < 0.8149999976158142f);
                            _2122 = _2103;
                            do
                            {
                                if (!_2108)
                                {
                                    float _2110 = _2103 + -0.8149999976158142f;
                                    float _2111 = _2110 * 3.0552830696105957f;
                                    float _2112 = log2(_2111);
                                    float _2113 = _2112 * 1.2000000476837158f;
                                    float _2114 = exp2(_2113);
                                    float _2115 = _2114 + 1.0f;
                                    float _2116 = log2(_2115);
                                    float _2117 = _2116 * 0.8333333134651184f;
                                    float _2118 = exp2(_2117);
                                    float _2119 = _2110 / _2118;
                                    float _2120 = _2119 + 0.8149999976158142f;
                                    _2122 = _2120;
                                }
                                bool _2123 = (_2105 < 0.8029999732971191f);
                                _2137 = _2105;
                                do
                                {
                                    if (!_2123)
                                    {
                                        float _2125 = _2105 + -0.8029999732971191f;
                                        float _2126 = _2125 * 3.4972610473632812f;
                                        float _2127 = log2(_2126);
                                        float _2128 = _2127 * 1.2000000476837158f;
                                        float _2129 = exp2(_2128);
                                        float _2130 = _2129 + 1.0f;
                                        float _2131 = log2(_2130);
                                        float _2132 = _2131 * 0.8333333134651184f;
                                        float _2133 = exp2(_2132);
                                        float _2134 = _2125 / _2133;
                                        float _2135 = _2134 + 0.8029999732971191f;
                                        _2137 = _2135;
                                    }
                                    bool _2138 = (_2107 < 0.8799999952316284f);
                                    _2152 = _2107;
                                    do
                                    {
                                        if (!_2138)
                                        {
                                            float _2140 = _2107 + -0.8799999952316284f;
                                            float _2141 = _2140 * 6.810994625091553f;
                                            float _2142 = log2(_2141);
                                            float _2143 = _2142 * 1.2000000476837158f;
                                            float _2144 = exp2(_2143);
                                            float _2145 = _2144 + 1.0f;
                                            float _2146 = log2(_2145);
                                            float _2147 = _2146 * 0.8333333134651184f;
                                            float _2148 = exp2(_2147);
                                            float _2149 = _2140 / _2148;
                                            float _2150 = _2149 + 0.8799999952316284f;
                                            _2152 = _2150;
                                        }
                                        float _2153 = _2102 * _2122;
                                        float _2154 = _2092 - _2153;
                                        float _2155 = _2102 * _2137;
                                        float _2156 = _2092 - _2155;
                                        float _2157 = _2102 * _2152;
                                        float _2158 = _2092 - _2157;
                                        _2160 = _2154;
                                        _2161 = _2156;
                                        _2162 = _2158;
                                    } while (false);
                                } while (false);
                            } while (false);
                        }
                        float _2163 = _2160 * 0.6954522132873535f;
                        float _2164 = mad(0.14067870378494263f, _2161, _2163);
                        float _2165 = mad(0.16386906802654266f, _2162, _2164);
                        float _2166 = _2165 - _2075;
                        float _2167 = _2165 - _2078;
                        float _2168 = _2165 - _2081;
                        float _2169 = _2166 * _2037;
                        float _2170 = _2167 * _2037;
                        float _2171 = _2168 * _2037;
                        float _2172 = _2169 + _2075;
                        float _2173 = _2170 + _2078;
                        float _2174 = _2171 + _2081;
                        float _2175 = min(_2172, _2173);
                        float _2176 = min(_2175, _2174);
                        float _2177 = max(_2172, _2173);
                        float _2178 = max(_2177, _2174);
                        float _2179 = max(_2178, 1.000000013351432e-10f);
                        float _2180 = max(_2176, 1.000000013351432e-10f);
                        float _2181 = _2179 - _2180;
                        float _2182 = max(_2178, 0.009999999776482582f);
                        float _2183 = _2181 / _2182;
                        float _2184 = _2174 - _2173;
                        float _2185 = _2184 * _2174;
                        float _2186 = _2173 - _2172;
                        float _2187 = _2186 * _2173;
                        float _2188 = _2185 + _2187;
                        float _2189 = _2172 - _2174;
                        float _2190 = _2189 * _2172;
                        float _2191 = _2188 + _2190;
                        float _2192 = sqrt(_2191);
                        float _2193 = _2174 + _2173;
                        float _2194 = _2193 + _2172;
                        float _2195 = _2192 * 1.75f;
                        float _2196 = _2194 + _2195;
                        float _2197 = _2196 * 0.3333333432674408f;
                        float _2198 = _2183 + -0.4000000059604645f;
                        float _2199 = _2198 * 5.0f;
                        float _2200 = _2198 * 2.5f;
                        float _2201 = abs(_2200);
                        float _2202 = 1.0f - _2201;
                        float _2203 = max(_2202, 0.0f);
                        bool _2204 = (_2199 > 0.0f);
                        bool _2205 = (_2199 < 0.0f);
                        int _2206 = int(_2204);
                        int _2207 = int(_2205);
                        int _2208 = _2206 - _2207;
                        float _2209 = float(_2208);
                        float _2210 = _2203 * _2203;
                        float _2211 = 1.0f - _2210;
                        float _2212 = _2209 * _2211;
                        float _2213 = _2212 + 1.0f;
                        float _2214 = _2213 * 0.02500000037252903f;
                        bool _2215 = !(_2197 <= 0.0533333346247673f);
                        _2223 = _2214;
                        do
                        {
                            if (_2215)
                            {
                                bool _2217 = !(_2197 >= 0.1599999964237213f);
                                _2223 = 0.0f;
                                if (_2217)
                                {
                                    float _2219 = 0.23999999463558197f / _2196;
                                    float _2220 = _2219 + -0.5f;
                                    float _2221 = _2220 * _2214;
                                    _2223 = _2221;
                                }
                            }
                            float _2224 = _2223 + 1.0f;
                            float _2225 = _2224 * _2172;
                            float _2226 = _2224 * _2173;
                            float _2227 = _2224 * _2174;
                            bool _2228 = (_2225 == _2226);
                            bool _2229 = (_2226 == _2227);
                            bool _2230 = _2228 && _2229;
                            _2259 = 0.0f;
                            do
                            {
                                if (!_2230)
                                {
                                    float _2232 = _2225 * 2.0f;
                                    float _2233 = _2232 - _2226;
                                    float _2234 = _2233 - _2227;
                                    float _2235 = _2173 - _2174;
                                    float _2236 = _2235 * 1.7320507764816284f;
                                    float _2237 = _2236 * _2224;
                                    float _2238 = _2237 / _2234;
                                    float _2239 = atan(_2238);
                                    float _2240 = _2239 + 3.1415927410125732f;
                                    float _2241 = _2239 + -3.1415927410125732f;
                                    bool _2242 = (_2234 < 0.0f);
                                    bool _2243 = (_2234 == 0.0f);
                                    bool _2244 = (_2237 >= 0.0f);
                                    bool _2245 = (_2237 < 0.0f);
                                    bool _2246 = _2244 && _2242;
                                    float _2247 = _2246 ? _2240 : _2239;
                                    bool _2248 = _2245 && _2242;
                                    float _2249 = _2248 ? _2241 : _2247;
                                    bool _2250 = _2245 && _2243;
                                    bool _2251 = _2244 && _2243;
                                    float _2252 = _2249 * 57.2957763671875f;
                                    float _2253 = _2250 ? -90.0f : _2252;
                                    float _2254 = _2251 ? 90.0f : _2253;
                                    bool _2255 = (_2254 < 0.0f);
                                    _2259 = _2254;
                                    if (_2255)
                                    {
                                        float _2257 = _2254 + 360.0f;
                                        _2259 = _2257;
                                    }
                                }
                                float _2260 = max(_2259, 0.0f);
                                float _2261 = min(_2260, 360.0f);
                                bool _2262 = (_2261 < -180.0f);
                                do
                                {
                                    if (_2262)
                                    {
                                        float _2264 = _2261 + 360.0f;
                                        _2270 = _2264;
                                    }
                                    else
                                    {
                                        bool _2266 = (_2261 > 180.0f);
                                        _2270 = _2261;
                                        if (_2266)
                                        {
                                            float _2268 = _2261 + -360.0f;
                                            _2270 = _2268;
                                        }
                                    }
                                    bool _2271 = (_2270 > -67.5f);
                                    bool _2272 = (_2270 < 67.5f);
                                    bool _2273 = _2271 && _2272;
                                    _2309 = 0.0f;
                                    do
                                    {
                                        if (_2273)
                                        {
                                            float _2275 = _2270 + 67.5f;
                                            float _2276 = _2275 * 0.029629629105329514f;
                                            int _2277 = int(_2276);
                                            float _2278 = float(_2277);
                                            float _2279 = _2276 - _2278;
                                            float _2280 = _2279 * _2279;
                                            float _2281 = _2280 * _2279;
                                            bool _2282 = (_2277 == 3);
                                            if (_2282)
                                            {
                                                float _2284 = _2281 * 0.1666666716337204f;
                                                float _2285 = _2280 * 0.5f;
                                                float _2286 = _2279 * 0.5f;
                                                float _2287 = 0.1666666716337204f - _2286;
                                                float _2288 = _2287 + _2285;
                                                float _2289 = _2288 - _2284;
                                                _2309 = _2289;
                                            }
                                            else
                                            {
                                                bool _2291 = (_2277 == 2);
                                                if (_2291)
                                                {
                                                    float _2293 = _2281 * 0.5f;
                                                    float _2294 = 0.6666666865348816f - _2280;
                                                    float _2295 = _2294 + _2293;
                                                    _2309 = _2295;
                                                }
                                                else
                                                {
                                                    bool _2297 = (_2277 == 1);
                                                    if (_2297)
                                                    {
                                                        float _2299 = _2281 * -0.5f;
                                                        float _2300 = _2280 + _2279;
                                                        float _2301 = _2300 * 0.5f;
                                                        float _2302 = _2299 + 0.1666666716337204f;
                                                        float _2303 = _2302 + _2301;
                                                        _2309 = _2303;
                                                    }
                                                    else
                                                    {
                                                        bool _2305 = (_2277 == 0);
                                                        float _2306 = _2281 * 0.1666666716337204f;
                                                        float _2307 = _2305 ? _2306 : 0.0f;
                                                        _2309 = _2307;
                                                    }
                                                }
                                            }
                                        }
                                        float _2310 = 0.029999999329447746f - _2225;
                                        float _2311 = _2183 * 0.27000001072883606f;
                                        float _2312 = _2311 * _2310;
                                        float _2313 = _2312 * _2309;
                                        float _2314 = _2313 + _2225;
                                        float _2315 = max(_2314, 0.0f);
                                        float _2316 = max(_2226, 0.0f);
                                        float _2317 = max(_2227, 0.0f);
                                        float _2318 = min(_2315, 65535.0f);
                                        float _2319 = min(_2316, 65535.0f);
                                        float _2320 = min(_2317, 65535.0f);
                                        float _2321 = _2318 * 1.4514392614364624f;
                                        float _2322 = mad(-0.2365107536315918f, _2319, _2321);
                                        float _2323 = mad(-0.21492856740951538f, _2320, _2322);
                                        float _2324 = _2318 * -0.07655377686023712f;
                                        float _2325 = mad(1.17622971534729f, _2319, _2324);
                                        float _2326 = mad(-0.09967592358589172f, _2320, _2325);
                                        float _2327 = _2318 * 0.008316148072481155f;
                                        float _2328 = mad(-0.006032449658960104f, _2319, _2327);
                                        float _2329 = mad(0.9977163076400757f, _2320, _2328);
                                        float _2330 = max(_2323, 0.0f);
                                        float _2331 = max(_2326, 0.0f);
                                        float _2332 = max(_2329, 0.0f);
                                        float _2333 = min(_2330, 65504.0f);
                                        float _2334 = min(_2331, 65504.0f);
                                        float _2335 = min(_2332, 65504.0f);
                                        float _2336 = dot(float3(_2333, _2334, _2335), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                                        float _2337 = _2333 - _2336;
                                        float _2338 = _2334 - _2336;
                                        float _2339 = _2335 - _2336;
                                        float _2340 = _2337 * 0.9599999785423279f;
                                        float _2341 = _2338 * 0.9599999785423279f;
                                        float _2342 = _2339 * 0.9599999785423279f;
                                        float _2343 = _2340 + _2336;
                                        float _2344 = _2341 + _2336;
                                        float _2345 = _2342 + _2336;
                                        float _2346 = max(_2343, 1.000000013351432e-10f);
                                        float _2347 = log2(_2346);
                                        float _2348 = _2347 * 0.3010300099849701f;
                                        float _2349 = log2(_2054);
                                        float _2350 = _2349 * 0.3010300099849701f;
                                        bool _2351 = !(_2348 <= _2350);
                                        do
                                        {
                                            if (!_2351)
                                            {
                                                float _2353 = log2(_2055);
                                                float _2354 = _2353 * 0.3010300099849701f;
                                                _2419 = _2354;
                                            }
                                            else
                                            {
                                                bool _2356 = (_2348 > _2350);
                                                float _2357 = log2(_2052);
                                                float _2358 = _2357 * 0.3010300099849701f;
                                                bool _2359 = (_2348 < _2358);
                                                bool _2360 = _2356 && _2359;
                                                if (_2360)
                                                {
                                                    float _2362 = _2347 - _2349;
                                                    float _2363 = _2362 * 0.9030900001525879f;
                                                    float _2364 = _2357 - _2349;
                                                    float _2365 = _2364 * 0.3010300099849701f;
                                                    float _2366 = _2363 / _2365;
                                                    int _2367 = int(_2366);
                                                    float _2368 = float(_2367);
                                                    float _2369 = _2366 - _2368;
                                                    float _2371 = _10[_2367];
                                                    int _2372 = _2367 + 1;
                                                    float _2374 = _10[_2372];
                                                    int _2375 = _2367 + 2;
                                                    float _2377 = _10[_2375];
                                                    float _2378 = _2369 * _2369;
                                                    float _2379 = _2371 * 0.5f;
                                                    float _2380 = mad(_2374, -1.0f, _2379);
                                                    float _2381 = mad(_2377, 0.5f, _2380);
                                                    float _2382 = _2374 - _2371;
                                                    float _2383 = mad(_2374, 0.5f, _2379);
                                                    float _2384 = dot(float3(_2378, _2369, 1.0f), float3(_2381, _2382, _2383));
                                                    _2419 = _2384;
                                                }
                                                else
                                                {
                                                    bool _2386 = (_2348 >= _2358);
                                                    float _2387 = log2(_2056);
                                                    float _2388 = _2387 * 0.3010300099849701f;
                                                    bool _2389 = (_2348 < _2388);
                                                    bool _2390 = _2386 && _2389;
                                                    if (_2390)
                                                    {
                                                        float _2392 = _2347 - _2357;
                                                        float _2393 = _2392 * 0.9030900001525879f;
                                                        float _2394 = _2387 - _2357;
                                                        float _2395 = _2394 * 0.3010300099849701f;
                                                        float _2396 = _2393 / _2395;
                                                        int _2397 = int(_2396);
                                                        float _2398 = float(_2397);
                                                        float _2399 = _2396 - _2398;
                                                        float _2401 = _11[_2397];
                                                        int _2402 = _2397 + 1;
                                                        float _2404 = _11[_2402];
                                                        int _2405 = _2397 + 2;
                                                        float _2407 = _11[_2405];
                                                        float _2408 = _2399 * _2399;
                                                        float _2409 = _2401 * 0.5f;
                                                        float _2410 = mad(_2404, -1.0f, _2409);
                                                        float _2411 = mad(_2407, 0.5f, _2410);
                                                        float _2412 = _2404 - _2401;
                                                        float _2413 = mad(_2404, 0.5f, _2409);
                                                        float _2414 = dot(float3(_2408, _2399, 1.0f), float3(_2411, _2412, _2413));
                                                        _2419 = _2414;
                                                    }
                                                    else
                                                    {
                                                        float _2416 = log2(_2057);
                                                        float _2417 = _2416 * 0.3010300099849701f;
                                                        _2419 = _2417;
                                                    }
                                                }
                                            }
                                            float _2420 = _2419 * 3.321928024291992f;
                                            float _2421 = exp2(_2420);
                                            float _2422 = max(_2344, 1.000000013351432e-10f);
                                            float _2423 = log2(_2422);
                                            float _2424 = _2423 * 0.3010300099849701f;
                                            bool _2425 = !(_2424 <= _2350);
                                            do
                                            {
                                                if (!_2425)
                                                {
                                                    float _2427 = log2(_2055);
                                                    float _2428 = _2427 * 0.3010300099849701f;
                                                    _2493 = _2428;
                                                }
                                                else
                                                {
                                                    bool _2430 = (_2424 > _2350);
                                                    float _2431 = log2(_2052);
                                                    float _2432 = _2431 * 0.3010300099849701f;
                                                    bool _2433 = (_2424 < _2432);
                                                    bool _2434 = _2430 && _2433;
                                                    if (_2434)
                                                    {
                                                        float _2436 = _2423 - _2349;
                                                        float _2437 = _2436 * 0.9030900001525879f;
                                                        float _2438 = _2431 - _2349;
                                                        float _2439 = _2438 * 0.3010300099849701f;
                                                        float _2440 = _2437 / _2439;
                                                        int _2441 = int(_2440);
                                                        float _2442 = float(_2441);
                                                        float _2443 = _2440 - _2442;
                                                        float _2445 = _10[_2441];
                                                        int _2446 = _2441 + 1;
                                                        float _2448 = _10[_2446];
                                                        int _2449 = _2441 + 2;
                                                        float _2451 = _10[_2449];
                                                        float _2452 = _2443 * _2443;
                                                        float _2453 = _2445 * 0.5f;
                                                        float _2454 = mad(_2448, -1.0f, _2453);
                                                        float _2455 = mad(_2451, 0.5f, _2454);
                                                        float _2456 = _2448 - _2445;
                                                        float _2457 = mad(_2448, 0.5f, _2453);
                                                        float _2458 = dot(float3(_2452, _2443, 1.0f), float3(_2455, _2456, _2457));
                                                        _2493 = _2458;
                                                    }
                                                    else
                                                    {
                                                        bool _2460 = (_2424 >= _2432);
                                                        float _2461 = log2(_2056);
                                                        float _2462 = _2461 * 0.3010300099849701f;
                                                        bool _2463 = (_2424 < _2462);
                                                        bool _2464 = _2460 && _2463;
                                                        if (_2464)
                                                        {
                                                            float _2466 = _2423 - _2431;
                                                            float _2467 = _2466 * 0.9030900001525879f;
                                                            float _2468 = _2461 - _2431;
                                                            float _2469 = _2468 * 0.3010300099849701f;
                                                            float _2470 = _2467 / _2469;
                                                            int _2471 = int(_2470);
                                                            float _2472 = float(_2471);
                                                            float _2473 = _2470 - _2472;
                                                            float _2475 = _11[_2471];
                                                            int _2476 = _2471 + 1;
                                                            float _2478 = _11[_2476];
                                                            int _2479 = _2471 + 2;
                                                            float _2481 = _11[_2479];
                                                            float _2482 = _2473 * _2473;
                                                            float _2483 = _2475 * 0.5f;
                                                            float _2484 = mad(_2478, -1.0f, _2483);
                                                            float _2485 = mad(_2481, 0.5f, _2484);
                                                            float _2486 = _2478 - _2475;
                                                            float _2487 = mad(_2478, 0.5f, _2483);
                                                            float _2488 = dot(float3(_2482, _2473, 1.0f), float3(_2485, _2486, _2487));
                                                            _2493 = _2488;
                                                        }
                                                        else
                                                        {
                                                            float _2490 = log2(_2057);
                                                            float _2491 = _2490 * 0.3010300099849701f;
                                                            _2493 = _2491;
                                                        }
                                                    }
                                                }
                                                float _2494 = _2493 * 3.321928024291992f;
                                                float _2495 = exp2(_2494);
                                                float _2496 = max(_2345, 1.000000013351432e-10f);
                                                float _2497 = log2(_2496);
                                                float _2498 = _2497 * 0.3010300099849701f;
                                                bool _2499 = !(_2498 <= _2350);
                                                do
                                                {
                                                    if (!_2499)
                                                    {
                                                        float _2501 = log2(_2055);
                                                        float _2502 = _2501 * 0.3010300099849701f;
                                                        _2567 = _2502;
                                                    }
                                                    else
                                                    {
                                                        bool _2504 = (_2498 > _2350);
                                                        float _2505 = log2(_2052);
                                                        float _2506 = _2505 * 0.3010300099849701f;
                                                        bool _2507 = (_2498 < _2506);
                                                        bool _2508 = _2504 && _2507;
                                                        if (_2508)
                                                        {
                                                            float _2510 = _2497 - _2349;
                                                            float _2511 = _2510 * 0.9030900001525879f;
                                                            float _2512 = _2505 - _2349;
                                                            float _2513 = _2512 * 0.3010300099849701f;
                                                            float _2514 = _2511 / _2513;
                                                            int _2515 = int(_2514);
                                                            float _2516 = float(_2515);
                                                            float _2517 = _2514 - _2516;
                                                            float _2519 = _10[_2515];
                                                            int _2520 = _2515 + 1;
                                                            float _2522 = _10[_2520];
                                                            int _2523 = _2515 + 2;
                                                            float _2525 = _10[_2523];
                                                            float _2526 = _2517 * _2517;
                                                            float _2527 = _2519 * 0.5f;
                                                            float _2528 = mad(_2522, -1.0f, _2527);
                                                            float _2529 = mad(_2525, 0.5f, _2528);
                                                            float _2530 = _2522 - _2519;
                                                            float _2531 = mad(_2522, 0.5f, _2527);
                                                            float _2532 = dot(float3(_2526, _2517, 1.0f), float3(_2529, _2530, _2531));
                                                            _2567 = _2532;
                                                        }
                                                        else
                                                        {
                                                            bool _2534 = (_2498 >= _2506);
                                                            float _2535 = log2(_2056);
                                                            float _2536 = _2535 * 0.3010300099849701f;
                                                            bool _2537 = (_2498 < _2536);
                                                            bool _2538 = _2534 && _2537;
                                                            if (_2538)
                                                            {
                                                                float _2540 = _2497 - _2505;
                                                                float _2541 = _2540 * 0.9030900001525879f;
                                                                float _2542 = _2535 - _2505;
                                                                float _2543 = _2542 * 0.3010300099849701f;
                                                                float _2544 = _2541 / _2543;
                                                                int _2545 = int(_2544);
                                                                float _2546 = float(_2545);
                                                                float _2547 = _2544 - _2546;
                                                                float _2549 = _11[_2545];
                                                                int _2550 = _2545 + 1;
                                                                float _2552 = _11[_2550];
                                                                int _2553 = _2545 + 2;
                                                                float _2555 = _11[_2553];
                                                                float _2556 = _2547 * _2547;
                                                                float _2557 = _2549 * 0.5f;
                                                                float _2558 = mad(_2552, -1.0f, _2557);
                                                                float _2559 = mad(_2555, 0.5f, _2558);
                                                                float _2560 = _2552 - _2549;
                                                                float _2561 = mad(_2552, 0.5f, _2557);
                                                                float _2562 = dot(float3(_2556, _2547, 1.0f), float3(_2559, _2560, _2561));
                                                                _2567 = _2562;
                                                            }
                                                            else
                                                            {
                                                                float _2564 = log2(_2057);
                                                                float _2565 = _2564 * 0.3010300099849701f;
                                                                _2567 = _2565;
                                                            }
                                                        }
                                                    }
                                                    float _2568 = _2567 * 3.321928024291992f;
                                                    float _2569 = exp2(_2568);
                                                    float _2570 = _2421 - _2055;
                                                    float _2571 = _2057 - _2055;
                                                    float _2572 = _2570 / _2571;
                                                    float _2573 = _2495 - _2055;
                                                    float _2574 = _2573 / _2571;
                                                    float _2575 = _2569 - _2055;
                                                    float _2576 = _2575 / _2571;
                                                    float _2577 = _2572 * 0.6624541878700256f;
                                                    float _2578 = mad(0.13400420546531677f, _2574, _2577);
                                                    float _2579 = mad(0.15618768334388733f, _2576, _2578);
                                                    float _2580 = _2572 * 0.2722287178039551f;
                                                    float _2581 = mad(0.6740817427635193f, _2574, _2580);
                                                    float _2582 = mad(0.053689517080783844f, _2576, _2581);
                                                    float _2583 = _2572 * -0.005574649665504694f;
                                                    float _2584 = mad(0.00406073359772563f, _2574, _2583);
                                                    float _2585 = mad(1.0103391408920288f, _2576, _2584);
                                                    float _2586 = _2579 * 1.6410233974456787f;
                                                    float _2587 = mad(-0.32480329275131226f, _2582, _2586);
                                                    float _2588 = mad(-0.23642469942569733f, _2585, _2587);
                                                    float _2589 = _2579 * -0.663662850856781f;
                                                    float _2590 = mad(1.6153316497802734f, _2582, _2589);
                                                    float _2591 = mad(0.016756348311901093f, _2585, _2590);
                                                    float _2592 = _2579 * 0.011721894145011902f;
                                                    float _2593 = mad(-0.008284442126750946f, _2582, _2592);
                                                    float _2594 = mad(0.9883948564529419f, _2585, _2593);
                                                    float _2595 = max(_2588, 0.0f);
                                                    float _2596 = max(_2591, 0.0f);
                                                    float _2597 = max(_2594, 0.0f);
                                                    float _2598 = min(_2595, 1.0f);
                                                    float _2599 = min(_2596, 1.0f);
                                                    float _2600 = min(_2597, 1.0f);
                                                    float _2601 = _2598 * 0.6624541878700256f;
                                                    float _2602 = mad(0.13400420546531677f, _2599, _2601);
                                                    float _2603 = mad(0.15618768334388733f, _2600, _2602);
                                                    float _2604 = _2598 * 0.2722287178039551f;
                                                    float _2605 = mad(0.6740817427635193f, _2599, _2604);
                                                    float _2606 = mad(0.053689517080783844f, _2600, _2605);
                                                    float _2607 = _2598 * -0.005574649665504694f;
                                                    float _2608 = mad(0.00406073359772563f, _2599, _2607);
                                                    float _2609 = mad(1.0103391408920288f, _2600, _2608);
                                                    float _2610 = _2603 * 1.6410233974456787f;
                                                    float _2611 = mad(-0.32480329275131226f, _2606, _2610);
                                                    float _2612 = mad(-0.23642469942569733f, _2609, _2611);
                                                    float _2613 = _2603 * -0.663662850856781f;
                                                    float _2614 = mad(1.6153316497802734f, _2606, _2613);
                                                    float _2615 = mad(0.016756348311901093f, _2609, _2614);
                                                    float _2616 = _2603 * 0.011721894145011902f;
                                                    float _2617 = mad(-0.008284442126750946f, _2606, _2616);
                                                    float _2618 = mad(0.9883948564529419f, _2609, _2617);
                                                    float _2619 = max(_2612, 0.0f);
                                                    float _2620 = max(_2615, 0.0f);
                                                    float _2621 = max(_2618, 0.0f);
                                                    float _2622 = min(_2619, 65535.0f);
                                                    float _2623 = min(_2620, 65535.0f);
                                                    float _2624 = min(_2621, 65535.0f);
                                                    float _2625 = _2622 * _2057;
                                                    float _2626 = _2623 * _2057;
                                                    float _2627 = _2624 * _2057;
                                                    float _2628 = max(_2625, 0.0f);
                                                    float _2629 = max(_2626, 0.0f);
                                                    float _2630 = max(_2627, 0.0f);
                                                    float _2631 = min(_2628, 65535.0f);
                                                    float _2632 = min(_2629, 65535.0f);
                                                    float _2633 = min(_2630, 65535.0f);
                                                    _2645 = _2631;
                                                    _2646 = _2632;
                                                    _2647 = _2633;
                                                    do
                                                    {
                                                        if (!_2030)
                                                        {
                                                            float _2635 = _2631 * _39;
                                                            float _2636 = mad(_40, _2632, _2635);
                                                            float _2637 = mad(_41, _2633, _2636);
                                                            float _2638 = _2631 * _42;
                                                            float _2639 = mad(_43, _2632, _2638);
                                                            float _2640 = mad(_44, _2633, _2639);
                                                            float _2641 = _2631 * _45;
                                                            float _2642 = mad(_46, _2632, _2641);
                                                            float _2643 = mad(_47, _2633, _2642);
                                                            _2645 = _2637;
                                                            _2646 = _2640;
                                                            _2647 = _2643;
                                                        }
                                                        float _2648 = _2645 * 9.999999747378752e-05f;
                                                        float _2649 = _2646 * 9.999999747378752e-05f;
                                                        float _2650 = _2647 * 9.999999747378752e-05f;
                                                        float _2651 = log2(_2648);
                                                        float _2652 = log2(_2649);
                                                        float _2653 = log2(_2650);
                                                        float _2654 = _2651 * 0.1593017578125f;
                                                        float _2655 = _2652 * 0.1593017578125f;
                                                        float _2656 = _2653 * 0.1593017578125f;
                                                        float _2657 = exp2(_2654);
                                                        float _2658 = exp2(_2655);
                                                        float _2659 = exp2(_2656);
                                                        float _2660 = _2657 * 18.8515625f;
                                                        float _2661 = _2658 * 18.8515625f;
                                                        float _2662 = _2659 * 18.8515625f;
                                                        float _2663 = _2660 + 0.8359375f;
                                                        float _2664 = _2661 + 0.8359375f;
                                                        float _2665 = _2662 + 0.8359375f;
                                                        float _2666 = _2657 * 18.6875f;
                                                        float _2667 = _2658 * 18.6875f;
                                                        float _2668 = _2659 * 18.6875f;
                                                        float _2669 = _2666 + 1.0f;
                                                        float _2670 = _2667 + 1.0f;
                                                        float _2671 = _2668 + 1.0f;
                                                        float _2672 = 1.0f / _2669;
                                                        float _2673 = 1.0f / _2670;
                                                        float _2674 = 1.0f / _2671;
                                                        float _2675 = _2672 * _2663;
                                                        float _2676 = _2673 * _2664;
                                                        float _2677 = _2674 * _2665;
                                                        float _2678 = log2(_2675);
                                                        float _2679 = log2(_2676);
                                                        float _2680 = log2(_2677);
                                                        float _2681 = _2678 * 78.84375f;
                                                        float _2682 = _2679 * 78.84375f;
                                                        float _2683 = _2680 * 78.84375f;
                                                        float _2684 = exp2(_2681);
                                                        float _2685 = exp2(_2682);
                                                        float _2686 = exp2(_2683);
                                                        _2800 = _2684;
                                                        _2801 = _2685;
                                                        _2802 = _2686;
                                                    } while (false);
                                                } while (false);
                                            } while (false);
                                        } while (false);
                                    } while (false);
                                } while (false);
                            } while (false);
                        } while (false);
                    } while (false);
                }
                else
                {
                    bool _2688 = (_1289 == 7);
                    if (_2688)
                    {
                        float _2690 = _1246 * 0.613191545009613f;
                        float _2691 = mad(0.3395121395587921f, _1249, _2690);
                        float _2692 = mad(0.04736635088920593f, _1252, _2691);
                        float _2693 = _1246 * 0.07020691782236099f;
                        float _2694 = mad(0.9163357615470886f, _1249, _2693);
                        float _2695 = mad(0.01345000695437193f, _1252, _2694);
                        float _2696 = _1246 * 0.020618872717022896f;
                        float _2697 = mad(0.1095672994852066f, _1249, _2696);
                        float _2698 = mad(0.8696067929267883f, _1252, _2697);
                        float _2699 = _2692 * _39;
                        float _2700 = mad(_40, _2695, _2699);
                        float _2701 = mad(_41, _2698, _2700);
                        float _2702 = _2692 * _42;
                        float _2703 = mad(_43, _2695, _2702);
                        float _2704 = mad(_44, _2698, _2703);
                        float _2705 = _2692 * _45;
                        float _2706 = mad(_46, _2695, _2705);
                        float _2707 = mad(_47, _2698, _2706);
                        float _2708 = _2701 * 9.999999747378752e-05f;
                        float _2709 = _2704 * 9.999999747378752e-05f;
                        float _2710 = _2707 * 9.999999747378752e-05f;
                        float _2711 = log2(_2708);
                        float _2712 = log2(_2709);
                        float _2713 = log2(_2710);
                        float _2714 = _2711 * 0.1593017578125f;
                        float _2715 = _2712 * 0.1593017578125f;
                        float _2716 = _2713 * 0.1593017578125f;
                        float _2717 = exp2(_2714);
                        float _2718 = exp2(_2715);
                        float _2719 = exp2(_2716);
                        float _2720 = _2717 * 18.8515625f;
                        float _2721 = _2718 * 18.8515625f;
                        float _2722 = _2719 * 18.8515625f;
                        float _2723 = _2720 + 0.8359375f;
                        float _2724 = _2721 + 0.8359375f;
                        float _2725 = _2722 + 0.8359375f;
                        float _2726 = _2717 * 18.6875f;
                        float _2727 = _2718 * 18.6875f;
                        float _2728 = _2719 * 18.6875f;
                        float _2729 = _2726 + 1.0f;
                        float _2730 = _2727 + 1.0f;
                        float _2731 = _2728 + 1.0f;
                        float _2732 = 1.0f / _2729;
                        float _2733 = 1.0f / _2730;
                        float _2734 = 1.0f / _2731;
                        float _2735 = _2732 * _2723;
                        float _2736 = _2733 * _2724;
                        float _2737 = _2734 * _2725;
                        float _2738 = log2(_2735);
                        float _2739 = log2(_2736);
                        float _2740 = log2(_2737);
                        float _2741 = _2738 * 78.84375f;
                        float _2742 = _2739 * 78.84375f;
                        float _2743 = _2740 * 78.84375f;
                        float _2744 = exp2(_2741);
                        float _2745 = exp2(_2742);
                        float _2746 = exp2(_2743);
                        _2800 = _2744;
                        _2801 = _2745;
                        _2802 = _2746;
                    }
                    else
                    {
                        bool _2748 = (_1289 == 8);
                        _2800 = _1246;
                        _2801 = _1249;
                        _2802 = _1252;
                        if (!_2748)
                        {
                            bool _2750 = (_1289 == 9);
                            if (_2750)
                            {
                                float _2752 = _1271 * 0.613191545009613f;
                                float _2753 = mad(0.3395121395587921f, _1272, _2752);
                                float _2754 = mad(0.04736635088920593f, _1273, _2753);
                                float _2755 = _1271 * 0.07020691782236099f;
                                float _2756 = mad(0.9163357615470886f, _1272, _2755);
                                float _2757 = mad(0.01345000695437193f, _1273, _2756);
                                float _2758 = _1271 * 0.020618872717022896f;
                                float _2759 = mad(0.1095672994852066f, _1272, _2758);
                                float _2760 = mad(0.8696067929267883f, _1273, _2759);
                                float _2761 = _2754 * _39;
                                float _2762 = mad(_40, _2757, _2761);
                                float _2763 = mad(_41, _2760, _2762);
                                float _2764 = _2754 * _42;
                                float _2765 = mad(_43, _2757, _2764);
                                float _2766 = mad(_44, _2760, _2765);
                                float _2767 = _2754 * _45;
                                float _2768 = mad(_46, _2757, _2767);
                                float _2769 = mad(_47, _2760, _2768);
                                _2800 = _2763;
                                _2801 = _2766;
                                _2802 = _2769;
                            }
                            else
                            {
                                float _2771 = _1285 * 0.613191545009613f;
                                float _2772 = mad(0.3395121395587921f, _1286, _2771);
                                float _2773 = mad(0.04736635088920593f, _1287, _2772);
                                float _2774 = _1285 * 0.07020691782236099f;
                                float _2775 = mad(0.9163357615470886f, _1286, _2774);
                                float _2776 = mad(0.01345000695437193f, _1287, _2775);
                                float _2777 = _1285 * 0.020618872717022896f;
                                float _2778 = mad(0.1095672994852066f, _1286, _2777);
                                float _2779 = mad(0.8696067929267883f, _1287, _2778);
                                float _2780 = _2773 * _39;
                                float _2781 = mad(_40, _2776, _2780);
                                float _2782 = mad(_41, _2779, _2781);
                                float _2783 = _2773 * _42;
                                float _2784 = mad(_43, _2776, _2783);
                                float _2785 = mad(_44, _2779, _2784);
                                float _2786 = _2773 * _45;
                                float _2787 = mad(_46, _2776, _2786);
                                float _2788 = mad(_47, _2779, _2787);
                                float _2789 = cb0_039z;
                                float _2790 = log2(_2782);
                                float _2791 = log2(_2785);
                                float _2792 = log2(_2788);
                                float _2793 = _2790 * _2789;
                                float _2794 = _2791 * _2789;
                                float _2795 = _2792 * _2789;
                                float _2796 = exp2(_2793);
                                float _2797 = exp2(_2794);
                                float _2798 = exp2(_2795);
                                _2800 = _2796;
                                _2801 = _2797;
                                _2802 = _2798;
                            }
                        }
                    }
                }
            }
        }
    }
    float _2803 = _2800 * 0.9523810148239136f;
    float _2804 = _2801 * 0.9523810148239136f;
    float _2805 = _2802 * 0.9523810148239136f;
    SV_Target.x = _2803;
    SV_Target.y = _2804;
    SV_Target.z = _2805;
    SV_Target.w = 0.0f;
    return SV_Target;
}
