#include "./shared.h"

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0)
{
    float cb0_05x : packoffset(c05.x);
    float cb0_05y : packoffset(c05.y);
    float cb0_07w : packoffset(c07.w);
    float cb0_07x : packoffset(c07.x);
    float cb0_07y : packoffset(c07.y);
    float cb0_07z : packoffset(c07.z);
    float cb0_08x : packoffset(c08.x);
    float cb0_09w : packoffset(c09.w);
    float cb0_09x : packoffset(c09.x);
    float cb0_09y : packoffset(c09.y);
    float cb0_09z : packoffset(c09.z);
    float cb0_10w : packoffset(c10.w);
    float cb0_10x : packoffset(c10.x);
    float cb0_10y : packoffset(c10.y);
    float cb0_10z : packoffset(c10.z);
    float cb0_11w : packoffset(c11.w);
    float cb0_11x : packoffset(c11.x);
    float cb0_11y : packoffset(c11.y);
    float cb0_11z : packoffset(c11.z);
    float cb0_12w : packoffset(c12.w);
    float cb0_12x : packoffset(c12.x);
    float cb0_12y : packoffset(c12.y);
    float cb0_12z : packoffset(c12.z);
    float cb0_13x : packoffset(c13.x);
    float cb0_13y : packoffset(c13.y);
    float cb0_13z : packoffset(c13.z);
    float cb0_14w : packoffset(c14.w);
    float cb0_14x : packoffset(c14.x);
    float cb0_14y : packoffset(c14.y);
    float cb0_14z : packoffset(c14.z);
    float cb0_15w : packoffset(c15.w);
    float cb0_15x : packoffset(c15.x);
    float cb0_15y : packoffset(c15.y);
    float cb0_15z : packoffset(c15.z);
    float cb0_16w : packoffset(c16.w);
    float cb0_16x : packoffset(c16.x);
    float cb0_16y : packoffset(c16.y);
    float cb0_16z : packoffset(c16.z);
    float cb0_17w : packoffset(c17.w);
    float cb0_17x : packoffset(c17.x);
    float cb0_17y : packoffset(c17.y);
    float cb0_17z : packoffset(c17.z);
    float cb0_18w : packoffset(c18.w);
    float cb0_18x : packoffset(c18.x);
    float cb0_18y : packoffset(c18.y);
    float cb0_18z : packoffset(c18.z);
    float cb0_19w : packoffset(c19.w);
    float cb0_19x : packoffset(c19.x);
    float cb0_19y : packoffset(c19.y);
    float cb0_19z : packoffset(c19.z);
    float cb0_20w : packoffset(c20.w);
    float cb0_20x : packoffset(c20.x);
    float cb0_20y : packoffset(c20.y);
    float cb0_20z : packoffset(c20.z);
    float cb0_21w : packoffset(c21.w);
    float cb0_21x : packoffset(c21.x);
    float cb0_21y : packoffset(c21.y);
    float cb0_21z : packoffset(c21.z);
    float cb0_22w : packoffset(c22.w);
    float cb0_22x : packoffset(c22.x);
    float cb0_22y : packoffset(c22.y);
    float cb0_22z : packoffset(c22.z);
    float cb0_23w : packoffset(c23.w);
    float cb0_23x : packoffset(c23.x);
    float cb0_23y : packoffset(c23.y);
    float cb0_23z : packoffset(c23.z);
    float cb0_24w : packoffset(c24.w);
    float cb0_24x : packoffset(c24.x);
    float cb0_24y : packoffset(c24.y);
    float cb0_24z : packoffset(c24.z);
    float cb0_25w : packoffset(c25.w);
    float cb0_25x : packoffset(c25.x);
    float cb0_25y : packoffset(c25.y);
    float cb0_25z : packoffset(c25.z);
    float cb0_26w : packoffset(c26.w);
    float cb0_26x : packoffset(c26.x);
    float cb0_26y : packoffset(c26.y);
    float cb0_26z : packoffset(c26.z);
    float cb0_27w : packoffset(c27.w);
    float cb0_27x : packoffset(c27.x);
    float cb0_27y : packoffset(c27.y);
    float cb0_27z : packoffset(c27.z);
    float cb0_28w : packoffset(c28.w);
    float cb0_28x : packoffset(c28.x);
    float cb0_28y : packoffset(c28.y);
    float cb0_28z : packoffset(c28.z);
    float cb0_29w : packoffset(c29.w);
    float cb0_29x : packoffset(c29.x);
    float cb0_29y : packoffset(c29.y);
    float cb0_29z : packoffset(c29.z);
    float cb0_30w : packoffset(c30.w);
    float cb0_30x : packoffset(c30.x);
    float cb0_30y : packoffset(c30.y);
    float cb0_30z : packoffset(c30.z);
    float cb0_31w : packoffset(c31.w);
    float cb0_31x : packoffset(c31.x);
    float cb0_31y : packoffset(c31.y);
    float cb0_31z : packoffset(c31.z);
    float cb0_32w : packoffset(c32.w);
    float cb0_32x : packoffset(c32.x);
    float cb0_32y : packoffset(c32.y);
    float cb0_32z : packoffset(c32.z);
    float cb0_33w : packoffset(c33.w);
    float cb0_33x : packoffset(c33.x);
    float cb0_33y : packoffset(c33.y);
    float cb0_33z : packoffset(c33.z);
    float cb0_34w : packoffset(c34.w);
    float cb0_34x : packoffset(c34.x);
    float cb0_34y : packoffset(c34.y);
    float cb0_34z : packoffset(c34.z);
    float cb0_35w : packoffset(c35.w);
    float cb0_35x : packoffset(c35.x);
    float cb0_35y : packoffset(c35.y);
    float cb0_35z : packoffset(c35.z);
    float cb0_36w : packoffset(c36.w);
    float cb0_36x : packoffset(c36.x);
    float cb0_36y : packoffset(c36.y);
    float cb0_36z : packoffset(c36.z);
    float cb0_37x : packoffset(c37.x);
    uint cb0_37z : packoffset(c37.z);
    float cb0_38x : packoffset(c38.x);
    float cb0_38y : packoffset(c38.y);
    float cb0_38z : packoffset(c38.z);
    uint cb0_39w : packoffset(c39.w);
    float cb0_39y : packoffset(c39.y);
    float cb0_39z : packoffset(c39.z);
    uint cb0_40x : packoffset(c40.x);
};

SamplerState s0 : register(s0);

//cbuffer cb1 : register(b1)
//{
//    ShaderInjectData injectedData : packoffset(c0);
//}

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target
{
    float4 SV_Target;
  // texture _1 = t0;
  // SamplerState _2 = s0;
  // cbuffer _3 = cb0; // index=0
  // _4 = _3;
    uint _5 = SV_RenderTargetArrayIndex;
    float _6 = TEXCOORD.x;
    float _7 = TEXCOORD.y;
    float _8[6];
    float _9[6];
    float _10[6];
    float _11[6];
    float _12 = _6 + -0.015625f;
    float _13 = _7 + -0.015625f;
    float _14 = _12 * 1.0322580337524414f;
    float _15 = _13 * 1.0322580337524414f;
    float _16 = float(_5);
    float _17 = _16 * 0.032258063554763794f;
  // int4 _18 = cb0[40u];
    uint _19 = cb0_40x;
    bool _20 = (_19 == 1);
    float _37 = 1.379158854484558f;
    float _38 = -0.3088507056236267f;
    float _39 = -0.07034677267074585f;
    float _40 = -0.06933528929948807f;
    float _41 = 1.0822921991348267f;
    float _42 = -0.012962047010660172f;
    float _43 = -0.002159259282052517f;
    float _44 = -0.045465391129255295f;
    float _45 = 1.0477596521377563f;
    float _103;
    float _104;
    float _105;
    float _823;
    float _859;
    float _870;
    float _934;
    float _1113;
    float _1124;
    float _1135;
    float _1271;
    float _1282;
    float _1433;
    float _1448;
    float _1463;
    float _1471;
    float _1472;
    float _1473;
    float _1534;
    float _1570;
    float _1581;
    float _1620;
    float _1730;
    float _1804;
    float _1878;
    float _1956;
    float _1957;
    float _1958;
    float _2091;
    float _2106;
    float _2121;
    float _2129;
    float _2130;
    float _2131;
    float _2192;
    float _2228;
    float _2239;
    float _2278;
    float _2388;
    float _2462;
    float _2536;
    float _2614;
    float _2615;
    float _2616;
    float _2769;
    float _2770;
    float _2771;
    if (!_20)
    {
        bool _22 = (_19 == 2);
        _37 = 1.02579927444458f;
        _38 = -0.020052503794431686f;
        _39 = -0.0057713985443115234f;
        _40 = -0.0022350111976265907f;
        _41 = 1.0045825242996216f;
        _42 = -0.002352306619286537f;
        _43 = -0.005014004185795784f;
        _44 = -0.025293385609984398f;
        _45 = 1.0304402112960815f;
        if (!_22)
        {
            bool _24 = (_19 == 3);
            _37 = 0.6954522132873535f;
            _38 = 0.14067870378494263f;
            _39 = 0.16386906802654266f;
            _40 = 0.044794563204050064f;
            _41 = 0.8596711158752441f;
            _42 = 0.0955343171954155f;
            _43 = -0.005525882821530104f;
            _44 = 0.004025210160762072f;
            _45 = 1.0015007257461548f;
            if (!_24)
            {
                bool _26 = (_19 == 4);
                float _27 = _26 ? 1.0f : 1.7050515413284302f;
                float _28 = _26 ? 0.0f : -0.6217905879020691f;
                float _29 = _26 ? 0.0f : -0.0832584798336029f;
                float _30 = _26 ? 0.0f : -0.13025718927383423f;
                float _31 = _26 ? 1.0f : 1.1408027410507202f;
                float _32 = _26 ? 0.0f : -0.010548528283834457f;
                float _33 = _26 ? 0.0f : -0.024003278464078903f;
                float _34 = _26 ? 0.0f : -0.1289687603712082f;
                float _35 = _26 ? 1.0f : 1.152971863746643f;
                _37 = _27;
                _38 = _28;
                _39 = _29;
                _40 = _30;
                _41 = _31;
                _42 = _32;
                _43 = _33;
                _44 = _34;
                _45 = _35;
            }
        }
    }
  // int4 _46 = cb0[39u];
    uint _47 = cb0_39w;
    bool _48 = (_47 > 2);
    if (_48)
    {
        float _50 = log2(_14);
        float _51 = log2(_15);
        float _52 = log2(_17);
        float _53 = _50 * 0.012683313339948654f;
        float _54 = _51 * 0.012683313339948654f;
        float _55 = _52 * 0.012683313339948654f;
        float _56 = exp2(_53);
        float _57 = exp2(_54);
        float _58 = exp2(_55);
        float _59 = _56 + -0.8359375f;
        float _60 = _57 + -0.8359375f;
        float _61 = _58 + -0.8359375f;
        float _62 = max(0.0f, _59);
        float _63 = max(0.0f, _60);
        float _64 = max(0.0f, _61);
        float _65 = _56 * 18.6875f;
        float _66 = _57 * 18.6875f;
        float _67 = _58 * 18.6875f;
        float _68 = 18.8515625f - _65;
        float _69 = 18.8515625f - _66;
        float _70 = 18.8515625f - _67;
        float _71 = _62 / _68;
        float _72 = _63 / _69;
        float _73 = _64 / _70;
        float _74 = log2(_71);
        float _75 = log2(_72);
        float _76 = log2(_73);
        float _77 = _74 * 6.277394771575928f;
        float _78 = _75 * 6.277394771575928f;
        float _79 = _76 * 6.277394771575928f;
        float _80 = exp2(_77);
        float _81 = exp2(_78);
        float _82 = exp2(_79);
        float _83 = _80 * 100.0f;
        float _84 = _81 * 100.0f;
        float _85 = _82 * 100.0f;
        _103 = _83;
        _104 = _84;
        _105 = _85;
    }
    else
    {
        float _87 = _12 * 14.45161247253418f;
        float _88 = _87 + -6.07624626159668f;
        float _89 = _13 * 14.45161247253418f;
        float _90 = _89 + -6.07624626159668f;
        float _91 = _16 * 0.4516128897666931f;
        float _92 = _91 + -6.07624626159668f;
        float _93 = exp2(_88);
        float _94 = exp2(_90);
        float _95 = exp2(_92);
        float _96 = _93 * 0.18000000715255737f;
        float _97 = _94 * 0.18000000715255737f;
        float _98 = _95 * 0.18000000715255737f;
        float _99 = _96 + -0.002667719265446067f;
        float _100 = _97 + -0.002667719265446067f;
        float _101 = _98 + -0.002667719265446067f;
        _103 = _99;
        _104 = _100;
        _105 = _101;
    }
  // float4 _106 = cb0[34u];
    float _107 = cb0_34x;
    float _108 = _107 * 1.0005563497543335f;
    float _109 = 0.9994439482688904f / _107;
    bool _110 = (_108 <= 7000.0f);
    float _111 = _109 * 4607000064.0f;
    float _112 = 2967800.0f - _111;
    float _113 = _112 * _109;
    float _114 = _113 + 99.11000061035156f;
    float _115 = _114 * _109;
    float _116 = _115 + 0.24406300485134125f;
    float _117 = _109 * 2006400000.0f;
    float _118 = 1901800.0f - _117;
    float _119 = _118 * _109;
    float _120 = _119 + 247.47999572753906f;
    float _121 = _120 * _109;
    float _122 = _121 + 0.23703999817371368f;
    float _123 = _110 ? _116 : _122;
    float _124 = _123 * _123;
    float _125 = _124 * 3.0f;
    float _126 = _123 * 2.869999885559082f;
    float _127 = _126 + -0.2750000059604645f;
    float _128 = _127 - _125;
    float _129 = _107 * 1.2864121856637212e-07f;
    float _130 = _129 + 0.00015411825734190643f;
    float _131 = _130 * _107;
    float _132 = _131 + 0.8601177334785461f;
    float _133 = _107 * 7.081451371959702e-07f;
    float _134 = _133 + 0.0008424202096648514f;
    float _135 = _134 * _107;
    float _136 = _135 + 1.0f;
    float _137 = _132 / _136;
    float _138 = _107 * 4.204816761443908e-08f;
    float _139 = _138 + 4.228062607580796e-05f;
    float _140 = _139 * _107;
    float _141 = _140 + 0.31739872694015503f;
    float _142 = _107 * 2.8974181986995973e-05f;
    float _143 = 1.0f - _142;
    float _144 = _107 * _107;
    float _145 = _144 * 1.6145605741257896e-07f;
    float _146 = _143 + _145;
    float _147 = _141 / _146;
    float _148 = _137 * 3.0f;
    float _149 = _137 * 2.0f;
    float _150 = _147 * 8.0f;
    float _151 = _149 + 4.0f;
    float _152 = _151 - _150;
    float _153 = _148 / _152;
    float _154 = _147 * 2.0f;
    float _155 = _154 / _152;
    bool _156 = (_107 < 4000.0f);
    float _157 = _156 ? _153 : _123;
    float _158 = _156 ? _155 : _128;
    float _159 = cb0_34y;
    float _160 = _107 * 1916156.25f;
    float _161 = -1137581184.0f - _160;
    float _162 = _144 * 1.5317699909210205f;
    float _163 = _161 - _162;
    float _164 = _107 + 1189.6199951171875f;
    float _165 = _164 * _107;
    float _166 = _165 + 1412139.875f;
    float _167 = _166 * _166;
    float _168 = _163 / _167;
    float _169 = _107 * 705674.0f;
    float _170 = 1974715392.0f - _169;
    float _171 = _144 * 308.60699462890625f;
    float _172 = _170 - _171;
    float _173 = _107 * 179.45599365234375f;
    float _174 = 6193636.0f - _173;
    float _175 = _174 + _144;
    float _176 = _175 * _175;
    float _177 = _172 / _176;
    float _178 = dot(float2(_168, _177), float2(_168, _177));
    float _179 = rsqrt(_178);
    float _180 = _159 * 0.05000000074505806f;
    float _181 = _180 * _177;
    float _182 = _181 * _179;
    float _183 = _182 + _137;
    float _184 = _180 * _168;
    float _185 = _184 * _179;
    float _186 = _147 - _185;
    float _187 = _183 * 3.0f;
    float _188 = _183 * 2.0f;
    float _189 = _186 * 8.0f;
    float _190 = 4.0f - _189;
    float _191 = _190 + _188;
    float _192 = _187 / _191;
    float _193 = _186 * 2.0f;
    float _194 = _193 / _191;
    float _195 = _192 - _153;
    float _196 = _194 - _155;
    float _197 = _195 + _157;
    float _198 = _196 + _158;
  // int4 _199 = cb0[37u];
    uint _200 = cb0_37z;
    bool _201 = (_200 != 0);
    float _202 = _201 ? _197 : 0.3127000033855438f;
    float _203 = _201 ? _198 : 0.32899999618530273f;
    float _204 = _201 ? 0.3127000033855438f : _197;
    float _205 = _201 ? 0.32899999618530273f : _198;
    float _206 = max(_203, 1.000000013351432e-10f);
    float _207 = _202 / _206;
    float _208 = 1.0f - _202;
    float _209 = _208 - _203;
    float _210 = _209 / _206;
    float _211 = max(_205, 1.000000013351432e-10f);
    float _212 = _204 / _211;
    float _213 = 1.0f - _204;
    float _214 = _213 - _205;
    float _215 = _214 / _211;
    float _216 = _207 * 0.8950999975204468f;
    float _217 = _216 + 0.266400009393692f;
    float _218 = mad(-0.16140000522136688f, _210, _217);
    float _219 = _207 * 0.7501999735832214f;
    float _220 = 1.7135000228881836f - _219;
    float _221 = mad(0.03669999912381172f, _210, _220);
    float _222 = _207 * 0.03889999911189079f;
    float _223 = _222 + -0.06849999725818634f;
    float _224 = mad(1.0296000242233276f, _210, _223);
    float _225 = _212 * 0.8950999975204468f;
    float _226 = _225 + 0.266400009393692f;
    float _227 = mad(-0.16140000522136688f, _215, _226);
    float _228 = _212 * 0.7501999735832214f;
    float _229 = 1.7135000228881836f - _228;
    float _230 = mad(0.03669999912381172f, _215, _229);
    float _231 = _212 * 0.03889999911189079f;
    float _232 = _231 + -0.06849999725818634f;
    float _233 = mad(1.0296000242233276f, _215, _232);
    float _234 = _227 / _218;
    float _235 = _230 / _221;
    float _236 = _233 / _224;
    float _237 = mad(_235, -0.7501999735832214f, 0.0f);
    float _238 = mad(_235, 1.7135000228881836f, 0.0f);
    float _239 = mad(_235, 0.03669999912381172f, -0.0f);
    float _240 = mad(_236, 0.03889999911189079f, 0.0f);
    float _241 = mad(_236, -0.06849999725818634f, 0.0f);
    float _242 = mad(_236, 1.0296000242233276f, 0.0f);
    float _243 = _234 * 0.883457362651825f;
    float _244 = mad(-0.1470542997121811f, _237, _243);
    float _245 = mad(0.1599626988172531f, _240, _244);
    float _246 = _234 * 0.26293492317199707f;
    float _247 = mad(-0.1470542997121811f, _238, _246);
    float _248 = mad(0.1599626988172531f, _241, _247);
    float _249 = _234 * -0.15930065512657166f;
    float _250 = mad(-0.1470542997121811f, _239, _249);
    float _251 = mad(0.1599626988172531f, _242, _250);
    float _252 = _234 * 0.38695648312568665f;
    float _253 = mad(0.5183603167533875f, _237, _252);
    float _254 = mad(0.04929120093584061f, _240, _253);
    float _255 = _234 * 0.11516613513231277f;
    float _256 = mad(0.5183603167533875f, _238, _255);
    float _257 = mad(0.04929120093584061f, _241, _256);
    float _258 = _234 * -0.0697740763425827f;
    float _259 = mad(0.5183603167533875f, _239, _258);
    float _260 = mad(0.04929120093584061f, _242, _259);
    float _261 = _234 * -0.007634039502590895f;
    float _262 = mad(0.04004279896616936f, _237, _261);
    float _263 = mad(0.9684867262840271f, _240, _262);
    float _264 = _234 * -0.0022720457054674625f;
    float _265 = mad(0.04004279896616936f, _238, _264);
    float _266 = mad(0.9684867262840271f, _241, _265);
    float _267 = _234 * 0.0013765322510153055f;
    float _268 = mad(0.04004279896616936f, _239, _267);
    float _269 = mad(0.9684867262840271f, _242, _268);
    float _270 = _245 * 0.4124563932418823f;
    float _271 = mad(_248, 0.2126729041337967f, _270);
    float _272 = mad(_251, 0.01933390088379383f, _271);
    float _273 = _245 * 0.3575761020183563f;
    float _274 = mad(_248, 0.7151522040367126f, _273);
    float _275 = mad(_251, 0.11919199675321579f, _274);
    float _276 = _245 * 0.18043750524520874f;
    float _277 = mad(_248, 0.07217500358819962f, _276);
    float _278 = mad(_251, 0.9503040909767151f, _277);
    float _279 = _254 * 0.4124563932418823f;
    float _280 = mad(_257, 0.2126729041337967f, _279);
    float _281 = mad(_260, 0.01933390088379383f, _280);
    float _282 = _254 * 0.3575761020183563f;
    float _283 = mad(_257, 0.7151522040367126f, _282);
    float _284 = mad(_260, 0.11919199675321579f, _283);
    float _285 = _254 * 0.18043750524520874f;
    float _286 = mad(_257, 0.07217500358819962f, _285);
    float _287 = mad(_260, 0.9503040909767151f, _286);
    float _288 = _263 * 0.4124563932418823f;
    float _289 = mad(_266, 0.2126729041337967f, _288);
    float _290 = mad(_269, 0.01933390088379383f, _289);
    float _291 = _263 * 0.3575761020183563f;
    float _292 = mad(_266, 0.7151522040367126f, _291);
    float _293 = mad(_269, 0.11919199675321579f, _292);
    float _294 = _263 * 0.18043750524520874f;
    float _295 = mad(_266, 0.07217500358819962f, _294);
    float _296 = mad(_269, 0.9503040909767151f, _295);
    float _297 = _272 * 3.2409698963165283f;
    float _298 = mad(-1.5373831987380981f, _281, _297);
    float _299 = mad(-0.4986107647418976f, _290, _298);
    float _300 = _275 * 3.2409698963165283f;
    float _301 = mad(-1.5373831987380981f, _284, _300);
    float _302 = mad(-0.4986107647418976f, _293, _301);
    float _303 = _278 * 3.2409698963165283f;
    float _304 = mad(-1.5373831987380981f, _287, _303);
    float _305 = mad(-0.4986107647418976f, _296, _304);
    float _306 = _272 * -0.9692436456680298f;
    float _307 = mad(1.8759675025939941f, _281, _306);
    float _308 = mad(0.04155505821108818f, _290, _307);
    float _309 = _275 * -0.9692436456680298f;
    float _310 = mad(1.8759675025939941f, _284, _309);
    float _311 = mad(0.04155505821108818f, _293, _310);
    float _312 = _278 * -0.9692436456680298f;
    float _313 = mad(1.8759675025939941f, _287, _312);
    float _314 = mad(0.04155505821108818f, _296, _313);
    float _315 = _272 * 0.05563008040189743f;
    float _316 = mad(-0.20397695899009705f, _281, _315);
    float _317 = mad(1.056971549987793f, _290, _316);
    float _318 = _275 * 0.05563008040189743f;
    float _319 = mad(-0.20397695899009705f, _284, _318);
    float _320 = mad(1.056971549987793f, _293, _319);
    float _321 = _278 * 0.05563008040189743f;
    float _322 = mad(-0.20397695899009705f, _287, _321);
    float _323 = mad(1.056971549987793f, _296, _322);
    float _324 = _299 * _103;
    float _325 = mad(_302, _104, _324);
    float _326 = mad(_305, _105, _325);
    float _327 = _308 * _103;
    float _328 = mad(_311, _104, _327);
    float _329 = mad(_314, _105, _328);
    float _330 = _317 * _103;
    float _331 = mad(_320, _104, _330);
    float _332 = mad(_323, _105, _331);
    float _333 = _326 * 0.613191545009613f;
    float _334 = mad(0.3395121395587921f, _329, _333);
    float _335 = mad(0.04736635088920593f, _332, _334);
    float _336 = _326 * 0.07020691782236099f;
    float _337 = mad(0.9163357615470886f, _329, _336);
    float _338 = mad(0.01345000695437193f, _332, _337);
    float _339 = _326 * 0.020618872717022896f;
    float _340 = mad(0.1095672994852066f, _329, _339);
    float _341 = mad(0.8696067929267883f, _332, _340);
    float _342 = dot(float3(_335, _338, _341), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    float _343 = _335 / _342;
    float _344 = _338 / _342;
    float _345 = _341 / _342;
    float _346 = _343 + -1.0f;
    float _347 = _344 + -1.0f;
    float _348 = _345 + -1.0f;
    float _349 = dot(float3(_346, _347, _348), float3(_346, _347, _348));
    float _350 = _349 * -4.0f;
    float _351 = exp2(_350);
    float _352 = 1.0f - _351;
  // float4 _353 = cb0[35u];
    float _354 = cb0_35z;
    float _355 = _342 * _342;
    float _356 = _355 * -4.0f;
    float _357 = _356 * _354;
    float _358 = exp2(_357);
    float _359 = 1.0f - _358;
    float _360 = _359 * _352;
    float _361 = _335 * 1.370412826538086f;
    float _362 = mad(-0.32929131388664246f, _338, _361);
    float _363 = mad(-0.06368283927440643f, _341, _362);
    float _364 = _335 * -0.08343426138162613f;
    float _365 = mad(1.0970908403396606f, _338, _364);
    float _366 = mad(-0.010861567221581936f, _341, _365);
    float _367 = _335 * -0.02579325996339321f;
    float _368 = mad(-0.09862564504146576f, _338, _367);
    float _369 = mad(1.203694462776184f, _341, _368);
    float _370 = _363 - _335;
    float _371 = _366 - _338;
    float _372 = _369 - _341;
    float _373 = _370 * _360;
    float _374 = _371 * _360;
    float _375 = _372 * _360;
    float _376 = _373 + _335;
    float _377 = _374 + _338;
    float _378 = _375 + _341;
    float _379 = dot(float3(_376, _377, _378), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  // float4 _380 = cb0[23u];
    float _381 = cb0_23x;
    float _382 = cb0_23y;
    float _383 = cb0_23z;
    float _384 = cb0_23w;
  // float4 _385 = cb0[18u];
    float _386 = cb0_18x;
    float _387 = cb0_18y;
    float _388 = cb0_18z;
    float _389 = cb0_18w;
    float _390 = _386 + _381;
    float _391 = _387 + _382;
    float _392 = _388 + _383;
    float _393 = _389 + _384;
  // float4 _394 = cb0[22u];
    float _395 = cb0_22x;
    float _396 = cb0_22y;
    float _397 = cb0_22z;
    float _398 = cb0_22w;
  // float4 _399 = cb0[17u];
    float _400 = cb0_17x;
    float _401 = cb0_17y;
    float _402 = cb0_17z;
    float _403 = cb0_17w;
    float _404 = _400 * _395;
    float _405 = _401 * _396;
    float _406 = _402 * _397;
    float _407 = _403 * _398;
  // float4 _408 = cb0[21u];
    float _409 = cb0_21x;
    float _410 = cb0_21y;
    float _411 = cb0_21z;
    float _412 = cb0_21w;
  // float4 _413 = cb0[16u];
    float _414 = cb0_16x;
    float _415 = cb0_16y;
    float _416 = cb0_16z;
    float _417 = cb0_16w;
    float _418 = _414 * _409;
    float _419 = _415 * _410;
    float _420 = _416 * _411;
    float _421 = _417 * _412;
  // float4 _422 = cb0[20u];
    float _423 = cb0_20x;
    float _424 = cb0_20y;
    float _425 = cb0_20z;
    float _426 = cb0_20w;
  // float4 _427 = cb0[15u];
    float _428 = cb0_15x;
    float _429 = cb0_15y;
    float _430 = cb0_15z;
    float _431 = cb0_15w;
    float _432 = _428 * _423;
    float _433 = _429 * _424;
    float _434 = _430 * _425;
    float _435 = _431 * _426;
  // float4 _436 = cb0[19u];
    float _437 = cb0_19x;
    float _438 = cb0_19y;
    float _439 = cb0_19z;
    float _440 = cb0_19w;
  // float4 _441 = cb0[14u];
    float _442 = cb0_14x;
    float _443 = cb0_14y;
    float _444 = cb0_14z;
    float _445 = cb0_14w;
    float _446 = _442 * _437;
    float _447 = _443 * _438;
    float _448 = _444 * _439;
    float _449 = _445 * _440;
    float _450 = _446 * _449;
    float _451 = _447 * _449;
    float _452 = _448 * _449;
    float _453 = _376 - _379;
    float _454 = _377 - _379;
    float _455 = _378 - _379;
    float _456 = _450 * _453;
    float _457 = _451 * _454;
    float _458 = _452 * _455;
    float _459 = _456 + _379;
    float _460 = _457 + _379;
    float _461 = _458 + _379;
    float _462 = max(0.0f, _459);
    float _463 = max(0.0f, _460);
    float _464 = max(0.0f, _461);
    float _465 = _432 * _435;
    float _466 = _433 * _435;
    float _467 = _434 * _435;
    float _468 = _462 * 5.55555534362793f;
    float _469 = _463 * 5.55555534362793f;
    float _470 = _464 * 5.55555534362793f;
    float _471 = log2(_468);
    float _472 = log2(_469);
    float _473 = log2(_470);
    float _474 = _465 * _471;
    float _475 = _466 * _472;
    float _476 = _467 * _473;
    float _477 = exp2(_474);
    float _478 = exp2(_475);
    float _479 = exp2(_476);
    float _480 = _477 * 0.18000000715255737f;
    float _481 = _478 * 0.18000000715255737f;
    float _482 = _479 * 0.18000000715255737f;
    float _483 = _418 * _421;
    float _484 = _419 * _421;
    float _485 = _420 * _421;
    float _486 = 1.0f / _483;
    float _487 = 1.0f / _484;
    float _488 = 1.0f / _485;
    float _489 = log2(_480);
    float _490 = log2(_481);
    float _491 = log2(_482);
    float _492 = _489 * _486;
    float _493 = _490 * _487;
    float _494 = _491 * _488;
    float _495 = exp2(_492);
    float _496 = exp2(_493);
    float _497 = exp2(_494);
    float _498 = _404 * _407;
    float _499 = _405 * _407;
    float _500 = _406 * _407;
    float _501 = _498 * _495;
    float _502 = _499 * _496;
    float _503 = _500 * _497;
    float _504 = _390 + _393;
    float _505 = _391 + _393;
    float _506 = _392 + _393;
    float _507 = _504 + _501;
    float _508 = _505 + _502;
    float _509 = _506 + _503;
    float _510 = cb0_34z;
    float _511 = _379 / _510;
    float _512 = saturate(_511);
    float _513 = _512 * 2.0f;
    float _514 = 3.0f - _513;
    float _515 = _512 * _512;
    float _516 = _515 * _514;
    float _517 = 1.0f - _516;
  // float4 _518 = cb0[33u];
    float _519 = cb0_33x;
    float _520 = cb0_33y;
    float _521 = cb0_33z;
    float _522 = cb0_33w;
    float _523 = _386 + _519;
    float _524 = _387 + _520;
    float _525 = _388 + _521;
    float _526 = _389 + _522;
  // float4 _527 = cb0[32u];
    float _528 = cb0_32x;
    float _529 = cb0_32y;
    float _530 = cb0_32z;
    float _531 = cb0_32w;
    float _532 = _400 * _528;
    float _533 = _401 * _529;
    float _534 = _402 * _530;
    float _535 = _403 * _531;
  // float4 _536 = cb0[31u];
    float _537 = cb0_31x;
    float _538 = cb0_31y;
    float _539 = cb0_31z;
    float _540 = cb0_31w;
    float _541 = _414 * _537;
    float _542 = _415 * _538;
    float _543 = _416 * _539;
    float _544 = _417 * _540;
  // float4 _545 = cb0[30u];
    float _546 = cb0_30x;
    float _547 = cb0_30y;
    float _548 = cb0_30z;
    float _549 = cb0_30w;
    float _550 = _428 * _546;
    float _551 = _429 * _547;
    float _552 = _430 * _548;
    float _553 = _431 * _549;
  // float4 _554 = cb0[29u];
    float _555 = cb0_29x;
    float _556 = cb0_29y;
    float _557 = cb0_29z;
    float _558 = cb0_29w;
    float _559 = _442 * _555;
    float _560 = _443 * _556;
    float _561 = _444 * _557;
    float _562 = _445 * _558;
    float _563 = _559 * _562;
    float _564 = _560 * _562;
    float _565 = _561 * _562;
    float _566 = _563 * _453;
    float _567 = _564 * _454;
    float _568 = _565 * _455;
    float _569 = _566 + _379;
    float _570 = _567 + _379;
    float _571 = _568 + _379;
    float _572 = max(0.0f, _569);
    float _573 = max(0.0f, _570);
    float _574 = max(0.0f, _571);
    float _575 = _550 * _553;
    float _576 = _551 * _553;
    float _577 = _552 * _553;
    float _578 = _572 * 5.55555534362793f;
    float _579 = _573 * 5.55555534362793f;
    float _580 = _574 * 5.55555534362793f;
    float _581 = log2(_578);
    float _582 = log2(_579);
    float _583 = log2(_580);
    float _584 = _575 * _581;
    float _585 = _576 * _582;
    float _586 = _577 * _583;
    float _587 = exp2(_584);
    float _588 = exp2(_585);
    float _589 = exp2(_586);
    float _590 = _587 * 0.18000000715255737f;
    float _591 = _588 * 0.18000000715255737f;
    float _592 = _589 * 0.18000000715255737f;
    float _593 = _541 * _544;
    float _594 = _542 * _544;
    float _595 = _543 * _544;
    float _596 = 1.0f / _593;
    float _597 = 1.0f / _594;
    float _598 = 1.0f / _595;
    float _599 = log2(_590);
    float _600 = log2(_591);
    float _601 = log2(_592);
    float _602 = _599 * _596;
    float _603 = _600 * _597;
    float _604 = _601 * _598;
    float _605 = exp2(_602);
    float _606 = exp2(_603);
    float _607 = exp2(_604);
    float _608 = _532 * _535;
    float _609 = _533 * _535;
    float _610 = _534 * _535;
    float _611 = _608 * _605;
    float _612 = _609 * _606;
    float _613 = _610 * _607;
    float _614 = _523 + _526;
    float _615 = _524 + _526;
    float _616 = _525 + _526;
    float _617 = _614 + _611;
    float _618 = _615 + _612;
    float _619 = _616 + _613;
    float _620 = cb0_35x;
  // float4 _621 = cb0[34u];
    float _622 = cb0_34w;
    float _623 = _620 - _622;
    float _624 = _379 - _622;
    float _625 = _624 / _623;
    float _626 = saturate(_625);
    float _627 = _626 * 2.0f;
    float _628 = 3.0f - _627;
    float _629 = _626 * _626;
    float _630 = _629 * _628;
  // float4 _631 = cb0[28u];
    float _632 = cb0_28x;
    float _633 = cb0_28y;
    float _634 = cb0_28z;
    float _635 = cb0_28w;
    float _636 = _386 + _632;
    float _637 = _387 + _633;
    float _638 = _388 + _634;
    float _639 = _389 + _635;
  // float4 _640 = cb0[27u];
    float _641 = cb0_27x;
    float _642 = cb0_27y;
    float _643 = cb0_27z;
    float _644 = cb0_27w;
    float _645 = _400 * _641;
    float _646 = _401 * _642;
    float _647 = _402 * _643;
    float _648 = _403 * _644;
  // float4 _649 = cb0[26u];
    float _650 = cb0_26x;
    float _651 = cb0_26y;
    float _652 = cb0_26z;
    float _653 = cb0_26w;
    float _654 = _414 * _650;
    float _655 = _415 * _651;
    float _656 = _416 * _652;
    float _657 = _417 * _653;
  // float4 _658 = cb0[25u];
    float _659 = cb0_25x;
    float _660 = cb0_25y;
    float _661 = cb0_25z;
    float _662 = cb0_25w;
    float _663 = _428 * _659;
    float _664 = _429 * _660;
    float _665 = _430 * _661;
    float _666 = _431 * _662;
  // float4 _667 = cb0[24u];
    float _668 = cb0_24x;
    float _669 = cb0_24y;
    float _670 = cb0_24z;
    float _671 = cb0_24w;
    float _672 = _442 * _668;
    float _673 = _443 * _669;
    float _674 = _444 * _670;
    float _675 = _445 * _671;
    float _676 = _672 * _675;
    float _677 = _673 * _675;
    float _678 = _674 * _675;
    float _679 = _676 * _453;
    float _680 = _677 * _454;
    float _681 = _678 * _455;
    float _682 = _679 + _379;
    float _683 = _680 + _379;
    float _684 = _681 + _379;
    float _685 = max(0.0f, _682);
    float _686 = max(0.0f, _683);
    float _687 = max(0.0f, _684);
    float _688 = _663 * _666;
    float _689 = _664 * _666;
    float _690 = _665 * _666;
    float _691 = _685 * 5.55555534362793f;
    float _692 = _686 * 5.55555534362793f;
    float _693 = _687 * 5.55555534362793f;
    float _694 = log2(_691);
    float _695 = log2(_692);
    float _696 = log2(_693);
    float _697 = _688 * _694;
    float _698 = _689 * _695;
    float _699 = _690 * _696;
    float _700 = exp2(_697);
    float _701 = exp2(_698);
    float _702 = exp2(_699);
    float _703 = _700 * 0.18000000715255737f;
    float _704 = _701 * 0.18000000715255737f;
    float _705 = _702 * 0.18000000715255737f;
    float _706 = _654 * _657;
    float _707 = _655 * _657;
    float _708 = _656 * _657;
    float _709 = 1.0f / _706;
    float _710 = 1.0f / _707;
    float _711 = 1.0f / _708;
    float _712 = log2(_703);
    float _713 = log2(_704);
    float _714 = log2(_705);
    float _715 = _712 * _709;
    float _716 = _713 * _710;
    float _717 = _714 * _711;
    float _718 = exp2(_715);
    float _719 = exp2(_716);
    float _720 = exp2(_717);
    float _721 = _645 * _648;
    float _722 = _646 * _648;
    float _723 = _647 * _648;
    float _724 = _721 * _718;
    float _725 = _722 * _719;
    float _726 = _723 * _720;
    float _727 = _636 + _639;
    float _728 = _637 + _639;
    float _729 = _638 + _639;
    float _730 = _727 + _724;
    float _731 = _728 + _725;
    float _732 = _729 + _726;
    float _733 = _516 - _630;
    float _734 = _517 * _507;
    float _735 = _517 * _508;
    float _736 = _517 * _509;
    float _737 = _730 * _733;
    float _738 = _731 * _733;
    float _739 = _732 * _733;
    float _740 = _630 * _617;
    float _741 = _630 * _618;
    float _742 = _630 * _619;
    float _743 = _740 + _734;
    float _744 = _743 + _737;
    float _745 = _741 + _735;
    float _746 = _745 + _738;
    float _747 = _742 + _736;
    float _748 = _747 + _739;
    float _749 = cb0_35y;
    float _750 = _744 * 0.9386394023895264f;
    float _751 = mad(-4.540197551250458e-09f, _746, _750);
    float _752 = mad(0.061360642313957214f, _748, _751);
    float _753 = _744 * 6.775371730327606e-08f;
    float _754 = mad(0.8307942152023315f, _746, _753);
    float _755 = mad(0.169205904006958f, _748, _754);
    float _756 = _744 * -9.313225746154785e-10f;
    float _757 = mad(-2.3283064365386963e-10f, _746, _756);
    float _758 = _752 - _744;
    float _759 = _755 - _746;
    float _760 = _758 * _749;
    float _761 = _759 * _749;
    float _762 = _757 * _749;
    float _763 = _760 + _744;
    float _764 = _761 + _746;
    float _765 = _762 + _748;
  
    float3 ap1_graded_color = float3(_763, _764, _765);
  // Finished grading in AP1
  
    // Finished grading in AP1

  // Early out with cbuffer
  // (Unreal runs the entire SDR process even if discarding)
    uint output_type = cb0_39w;
  
    float3 sdr_color;
    float3 hdr_color;
    float3 sdr_ap1_color;
  
    bool is_hdr = (output_type >= 3u && output_type <= 6u);
    if (injectedData.toneMapType != 0.f && is_hdr)
    {
    // bool is_2000_nits = (output_type == 4u || output_type == 6u);

        renodx::tonemap::Config config = renodx::tonemap::config::Create();
        config.type = injectedData.toneMapType; // ACES
        config.peak_nits = injectedData.toneMapPeakNits;
        config.game_nits = injectedData.toneMapGameNits;
        config.exposure = injectedData.colorGradeExposure;
        config.highlights = injectedData.colorGradeHighlights;
        config.shadows = injectedData.colorGradeShadows;
        config.contrast = injectedData.colorGradeContrast;
        config.saturation = injectedData.colorGradeSaturation;
        
        config.reno_drt_highlights = 1.0f;
        config.reno_drt_shadows = 1.0f;
        config.reno_drt_contrast = 1.0f;
        config.reno_drt_saturation = 1.0f;
        config.reno_drt_flare = 0.01f;
        
        // good settings
        //config.type = 2.f; // ACES
        //config.peak_nits = is_2000_nits ? 2000.f : 1000.f;
        //config.game_nits = 203.f;
        //config.contrast = 0.75f;
        //config.saturation = 0.75f;
        //config.exposure = 1.f;
        //config.shadows = 1.2f;
        //config.highlights = 0.75f;
	
        float3 config_color = renodx::color::bt709::from::AP1(ap1_graded_color);
	
	    //config_color = renodx::color::correct::Hue(config_color, renodx::tonemap::ACESFittedAP1(config_color));
	
        renodx::tonemap::config::DualToneMap dual_tone_map =
            renodx::tonemap::config::ApplyToneMaps(config_color, config);
        hdr_color = dual_tone_map.color_hdr;
        sdr_color = dual_tone_map.color_sdr;
        sdr_ap1_color = renodx::color::ap1::from::BT709(sdr_color);
    }
    else
    {
  
        float _766 = _763 * 0.6954522132873535f;
        float _767 = mad(0.14067868888378143f, _764, _766);
        float _768 = mad(0.16386905312538147f, _765, _767);
        float _769 = _763 * 0.044794581830501556f;
        float _770 = mad(0.8596711158752441f, _764, _769);
        float _771 = mad(0.0955343246459961f, _765, _770);
        float _772 = _763 * -0.005525882821530104f;
        float _773 = mad(0.004025210160762072f, _764, _772);
        float _774 = mad(1.0015007257461548f, _765, _773);
        float _775 = min(_768, _771);
        float _776 = min(_775, _774);
        float _777 = max(_768, _771);
        float _778 = max(_777, _774);
        float _779 = max(_778, 1.000000013351432e-10f);
        float _780 = max(_776, 1.000000013351432e-10f);
        float _781 = _779 - _780;
        float _782 = max(_778, 0.009999999776482582f);
        float _783 = _781 / _782;
        float _784 = _774 - _771;
        float _785 = _784 * _774;
        float _786 = _771 - _768;
        float _787 = _786 * _771;
        float _788 = _785 + _787;
        float _789 = _768 - _774;
        float _790 = _789 * _768;
        float _791 = _788 + _790;
        float _792 = sqrt(_791);
        float _793 = _792 * 1.75f;
        float _794 = _771 + _768;
        float _795 = _794 + _774;
        float _796 = _795 + _793;
        float _797 = _796 * 0.3333333432674408f;
        float _798 = _783 + -0.4000000059604645f;
        float _799 = _798 * 5.0f;
        float _800 = _798 * 2.5f;
        float _801 = abs(_800);
        float _802 = 1.0f - _801;
        float _803 = max(_802, 0.0f);
        bool _804 = (_799 > 0.0f);
        bool _805 = (_799 < 0.0f);
        int _806 = int(_804);
        int _807 = int(_805);
        int _808 = _806 - _807;
        float _809 = float(_808);
        float _810 = _803 * _803;
        float _811 = 1.0f - _810;
        float _812 = _809 * _811;
        float _813 = _812 + 1.0f;
        float _814 = _813 * 0.02500000037252903f;
        bool _815 = !(_797 <= 0.0533333346247673f);
        _823 = _814;
        if (_815)
        {
            bool _817 = !(_797 >= 0.1599999964237213f);
            _823 = 0.0f;
            if (_817)
            {
                float _819 = 0.23999999463558197f / _796;
                float _820 = _819 + -0.5f;
                float _821 = _820 * _814;
                _823 = _821;
            }
        }
        float _824 = _823 + 1.0f;
        float _825 = _824 * _768;
        float _826 = _824 * _771;
        float _827 = _824 * _774;
        bool _828 = (_825 == _826);
        bool _829 = (_826 == _827);
        bool _830 = _828 && _829;
        _859 = 0.0f;
        if (!_830)
        {
            float _832 = _825 * 2.0f;
            float _833 = _832 - _826;
            float _834 = _833 - _827;
            float _835 = _771 - _774;
            float _836 = _835 * 1.7320507764816284f;
            float _837 = _836 * _824;
            float _838 = _837 / _834;
            float _839 = atan(_838);
            float _840 = _839 + 3.1415927410125732f;
            float _841 = _839 + -3.1415927410125732f;
            bool _842 = (_834 < 0.0f);
            bool _843 = (_834 == 0.0f);
            bool _844 = (_837 >= 0.0f);
            bool _845 = (_837 < 0.0f);
            bool _846 = _844 && _842;
            float _847 = _846 ? _840 : _839;
            bool _848 = _845 && _842;
            float _849 = _848 ? _841 : _847;
            bool _850 = _845 && _843;
            bool _851 = _844 && _843;
            float _852 = _849 * 57.2957763671875f;
            float _853 = _850 ? -90.0f : _852;
            float _854 = _851 ? 90.0f : _853;
            bool _855 = (_854 < 0.0f);
            _859 = _854;
            if (_855)
            {
                float _857 = _854 + 360.0f;
                _859 = _857;
            }
        }
        float _860 = max(_859, 0.0f);
        float _861 = min(_860, 360.0f);
        bool _862 = (_861 < -180.0f);
        if (_862)
        {
            float _864 = _861 + 360.0f;
            _870 = _864;
        }
        else
        {
            bool _866 = (_861 > 180.0f);
            _870 = _861;
            if (_866)
            {
                float _868 = _861 + -360.0f;
                _870 = _868;
            }
        }
        float _871 = _870 * 0.014814814552664757f;
        float _872 = abs(_871);
        float _873 = 1.0f - _872;
        float _874 = saturate(_873);
        float _875 = _874 * 2.0f;
        float _876 = 3.0f - _875;
        float _877 = _874 * _874;
        float _878 = _877 * _876;
        float _879 = 0.029999999329447746f - _825;
        float _880 = _783 * 0.18000000715255737f;
        float _881 = _880 * _879;
        float _882 = _878 * _878;
        float _883 = _882 * _881;
        float _884 = _883 + _825;
        float _885 = _884 * 1.4514392614364624f;
        float _886 = mad(-0.2365107536315918f, _826, _885);
        float _887 = mad(-0.21492856740951538f, _827, _886);
        float _888 = _884 * -0.07655377686023712f;
        float _889 = mad(1.17622971534729f, _826, _888);
        float _890 = mad(-0.09967592358589172f, _827, _889);
        float _891 = _884 * 0.008316148072481155f;
        float _892 = mad(-0.006032449658960104f, _826, _891);
        float _893 = mad(0.9977163076400757f, _827, _892);
        float _894 = max(0.0f, _887);
        float _895 = max(0.0f, _890);
        float _896 = max(0.0f, _893);
        float _897 = dot(float3(_894, _895, _896), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
        float _898 = _894 - _897;
        float _899 = _895 - _897;
        float _900 = _896 - _897;
        float _901 = _898 * 0.9599999785423279f;
        float _902 = _899 * 0.9599999785423279f;
        float _903 = _900 * 0.9599999785423279f;
        float _904 = _901 + _897;
        float _905 = _902 + _897;
        float _906 = _903 + _897;
  
  // custom
        sdr_ap1_color = float3(_904, _905, _906);
    }
   
  // float4 _907 = cb0[36u];
    float _908 = cb0_36w;
    float _909 = _908 + 1.0f;
    float _910 = cb0_36y;
    float _911 = _909 - _910;
  // float4 _912 = cb0[37u];
    float _913 = cb0_37x;
    float _914 = _913 + 1.0f;
    float _915 = cb0_36z;
    float _916 = _914 - _915;
    bool _917 = (_910 > 0.800000011920929f);
    float _918 = cb0_36x;
    if (_917)
    {
        float _920 = 0.8199999928474426f - _910;
        float _921 = _920 / _918;
        float _922 = _921 + -0.7447274923324585f;
        _934 = _922;
    }
    else
    {
        float _924 = _908 + 0.18000000715255737f;
        float _925 = _924 / _911;
        float _926 = 2.0f - _925;
        float _927 = _925 / _926;
        float _928 = log2(_927);
        float _929 = _928 * 0.3465735912322998f;
        float _930 = _911 / _918;
        float _931 = _929 * _930;
        float _932 = -0.7447274923324585f - _931;
        _934 = _932;
    }
    float _935 = 1.0f - _910;
    float _936 = _935 / _918;
    float _937 = _936 - _934;
    float _938 = _915 / _918;
    float _939 = _938 - _937;
  
  //float _940 = log2(_904);
  //float _941 = log2(_905);
  //float _942 = log2(_906);
  
    float _940 = log2(sdr_ap1_color.r);
    float _941 = log2(sdr_ap1_color.g);
    float _942 = log2(sdr_ap1_color.b);
  
    float _943 = _940 * 0.3010300099849701f;
    float _944 = _941 * 0.3010300099849701f;
    float _945 = _942 * 0.3010300099849701f;
    float _946 = _943 + _937;
    float _947 = _944 + _937;
    float _948 = _945 + _937;
    float _949 = _918 * _946;
    float _950 = _918 * _947;
    float _951 = _918 * _948;
    float _952 = _911 * 2.0f;
    float _953 = _918 * -2.0f;
    float _954 = _953 / _911;
    float _955 = _943 - _934;
    float _956 = _944 - _934;
    float _957 = _945 - _934;
    float _958 = _955 * 1.4426950216293335f;
    float _959 = _958 * _954;
    float _960 = _956 * 1.4426950216293335f;
    float _961 = _960 * _954;
    float _962 = _957 * 1.4426950216293335f;
    float _963 = _962 * _954;
    float _964 = exp2(_959);
    float _965 = exp2(_961);
    float _966 = exp2(_963);
    float _967 = _964 + 1.0f;
    float _968 = _965 + 1.0f;
    float _969 = _966 + 1.0f;
    float _970 = _952 / _967;
    float _971 = _952 / _968;
    float _972 = _952 / _969;
    float _973 = _970 - _908;
    float _974 = _971 - _908;
    float _975 = _972 - _908;
    float _976 = _916 * 2.0f;
    float _977 = _918 * 2.0f;
    float _978 = _977 / _916;
    float _979 = _943 - _939;
    float _980 = _944 - _939;
    float _981 = _945 - _939;
    float _982 = _979 * 1.4426950216293335f;
    float _983 = _982 * _978;
    float _984 = _980 * 1.4426950216293335f;
    float _985 = _984 * _978;
    float _986 = _981 * 1.4426950216293335f;
    float _987 = _986 * _978;
    float _988 = exp2(_983);
    float _989 = exp2(_985);
    float _990 = exp2(_987);
    float _991 = _988 + 1.0f;
    float _992 = _989 + 1.0f;
    float _993 = _990 + 1.0f;
    float _994 = _976 / _991;
    float _995 = _976 / _992;
    float _996 = _976 / _993;
    float _997 = _914 - _994;
    float _998 = _914 - _995;
    float _999 = _914 - _996;
    bool _1000 = (_943 < _934);
    bool _1001 = (_944 < _934);
    bool _1002 = (_945 < _934);
    float _1003 = _1000 ? _973 : _949;
    float _1004 = _1001 ? _974 : _950;
    float _1005 = _1002 ? _975 : _951;
    bool _1006 = (_943 > _939);
    bool _1007 = (_944 > _939);
    bool _1008 = (_945 > _939);
    float _1009 = _1006 ? _997 : _949;
    float _1010 = _1007 ? _998 : _950;
    float _1011 = _1008 ? _999 : _951;
    float _1012 = _939 - _934;
    float _1013 = _955 / _1012;
    float _1014 = _956 / _1012;
    float _1015 = _957 / _1012;
    float _1016 = saturate(_1013);
    float _1017 = saturate(_1014);
    float _1018 = saturate(_1015);
    bool _1019 = (_939 < _934);
    float _1020 = 1.0f - _1016;
    float _1021 = 1.0f - _1017;
    float _1022 = 1.0f - _1018;
    float _1023 = _1019 ? _1020 : _1016;
    float _1024 = _1019 ? _1021 : _1017;
    float _1025 = _1019 ? _1022 : _1018;
    float _1026 = _1023 * 2.0f;
    float _1027 = _1024 * 2.0f;
    float _1028 = _1025 * 2.0f;
    float _1029 = 3.0f - _1026;
    float _1030 = 3.0f - _1027;
    float _1031 = 3.0f - _1028;
    float _1032 = _1009 - _1003;
    float _1033 = _1010 - _1004;
    float _1034 = _1011 - _1005;
    float _1035 = _1023 * _1023;
    float _1036 = _1035 * _1032;
    float _1037 = _1036 * _1029;
    float _1038 = _1024 * _1024;
    float _1039 = _1038 * _1033;
    float _1040 = _1039 * _1030;
    float _1041 = _1025 * _1025;
    float _1042 = _1041 * _1034;
    float _1043 = _1042 * _1031;
    float _1044 = _1037 + _1003;
    float _1045 = _1040 + _1004;
    float _1046 = _1043 + _1005;
    float _1047 = dot(float3(_1044, _1045, _1046), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    float _1048 = _1044 - _1047;
    float _1049 = _1045 - _1047;
    float _1050 = _1046 - _1047;
    float _1051 = _1048 * 0.9300000071525574f;
    float _1052 = _1049 * 0.9300000071525574f;
    float _1053 = _1050 * 0.9300000071525574f;
    float _1054 = _1051 + _1047;
    float _1055 = _1052 + _1047;
    float _1056 = _1053 + _1047;
    float _1057 = max(0.0f, _1054);
    float _1058 = max(0.0f, _1055);
    float _1059 = max(0.0f, _1056);
    float _1060 = cb0_35w;
    float _1061 = _1057 - _763;
    float _1062 = _1058 - _764;
    float _1063 = _1059 - _765;
    float _1064 = _1060 * _1061;
    float _1065 = _1060 * _1062;
    float _1066 = _1060 * _1063;
    float _1067 = _1064 + _763;
    float _1068 = _1065 + _764;
    float _1069 = _1066 + _765;
    float _1070 = _1067 * 1.065374732017517f;
    float _1071 = mad(1.451815478503704e-06f, _1068, _1070);
    float _1072 = mad(-0.06537103652954102f, _1069, _1071);
    float _1073 = _1067 * -2.57161445915699e-07f;
    float _1074 = mad(1.2036634683609009f, _1068, _1073);
    float _1075 = mad(-0.20366770029067993f, _1069, _1074);
    float _1076 = _1067 * 1.862645149230957e-08f;
    float _1077 = mad(2.0954757928848267e-08f, _1068, _1076);
    float _1078 = mad(0.9999996423721313f, _1069, _1077);
    float _1079 = _1072 - _1067;
    float _1080 = _1075 - _1068;
    float _1081 = _1078 - _1069;
    float _1082 = _1079 * _749;
    float _1083 = _1080 * _749;
    float _1084 = _1081 * _749;
    float _1085 = _1082 + _1067;
    float _1086 = _1083 + _1068;
    float _1087 = _1084 + _1069;
    float _1088 = _1085 * 1.7050515413284302f;
    float _1089 = mad(-0.6217905879020691f, _1086, _1088);
    float _1090 = mad(-0.0832584798336029f, _1087, _1089);
    float _1091 = _1085 * -0.13025718927383423f;
    float _1092 = mad(1.1408027410507202f, _1086, _1091);
    float _1093 = mad(-0.010548528283834457f, _1087, _1092);
    float _1094 = _1085 * -0.024003278464078903f;
    float _1095 = mad(-0.1289687603712082f, _1086, _1094);
    float _1096 = mad(1.152971863746643f, _1087, _1095);
    float _1097 = max(0.0f, _1090);
    float _1098 = max(0.0f, _1093);
    float _1099 = max(0.0f, _1096);
    float _1100 = saturate(_1097);
    float _1101 = saturate(_1098);
    float _1102 = saturate(_1099);
    bool _1103 = (_1100 < 0.0031306699384003878f);
    if (_1103)
    {
        float _1105 = _1100 * 12.920000076293945f;
        _1113 = _1105;
    }
    else
    {
        float _1107 = log2(_1100);
        float _1108 = _1107 * 0.4166666567325592f;
        float _1109 = exp2(_1108);
        float _1110 = _1109 * 1.0549999475479126f;
        float _1111 = _1110 + -0.054999999701976776f;
        _1113 = _1111;
    }
    bool _1114 = (_1101 < 0.0031306699384003878f);
    if (_1114)
    {
        float _1116 = _1101 * 12.920000076293945f;
        _1124 = _1116;
    }
    else
    {
        float _1118 = log2(_1101);
        float _1119 = _1118 * 0.4166666567325592f;
        float _1120 = exp2(_1119);
        float _1121 = _1120 * 1.0549999475479126f;
        float _1122 = _1121 + -0.054999999701976776f;
        _1124 = _1122;
    }
    bool _1125 = (_1102 < 0.0031306699384003878f);
    if (_1125)
    {
        float _1127 = _1102 * 12.920000076293945f;
        _1135 = _1127;
    }
    else
    {
        float _1129 = log2(_1102);
        float _1130 = _1129 * 0.4166666567325592f;
        float _1131 = exp2(_1130);
        float _1132 = _1131 * 1.0549999475479126f;
        float _1133 = _1132 + -0.054999999701976776f;
        _1135 = _1133;
    }
    float _1136 = _1113 * 0.9375f;
    float _1137 = _1124 * 0.9375f;
    float _1138 = _1136 + 0.03125f;
    float _1139 = _1137 + 0.03125f;
  // float4 _1140 = cb0[5u];
    float _1141 = cb0_05x;
    float _1142 = _1141 * _1113;
    float _1143 = _1141 * _1124;
    float _1144 = _1141 * _1135;
    float _1145 = cb0_05y;
    float _1146 = _1135 * 15.0f;
    float _1147 = floor(_1146);
    float _1148 = _1146 - _1147;
    float _1149 = _1138 + _1147;
    float _1150 = _1149 * 0.0625f;
  // _1151 = _1;
  // _1152 = _2;
    float4 _1153 = t0.Sample(s0, float2(_1150, _1139));
    float _1154 = _1153.x;
    float _1155 = _1153.y;
    float _1156 = _1153.z;
    float _1157 = _1150 + 0.0625f;
  // _1158 = _1;
  // _1159 = _2;
    float4 _1160 = t0.Sample(s0, float2(_1157, _1139));
    float _1161 = _1160.x;
    float _1162 = _1160.y;
    float _1163 = _1160.z;
    float _1164 = _1161 - _1154;
    float _1165 = _1162 - _1155;
    float _1166 = _1163 - _1156;
    float _1167 = _1164 * _1148;
    float _1168 = _1165 * _1148;
    float _1169 = _1166 * _1148;
    float _1170 = _1167 + _1154;
    float _1171 = _1168 + _1155;
    float _1172 = _1169 + _1156;
    float _1173 = _1170 * _1145;
    float _1174 = _1171 * _1145;
    float _1175 = _1172 * _1145;
    float _1176 = _1173 + _1142;
    float _1177 = _1174 + _1143;
    float _1178 = _1175 + _1144;
    float _1179 = max(6.103519990574569e-05f, _1176);
    float _1180 = max(6.103519990574569e-05f, _1177);
    float _1181 = max(6.103519990574569e-05f, _1178);
    float _1182 = _1179 * 0.07739938050508499f;
    float _1183 = _1180 * 0.07739938050508499f;
    float _1184 = _1181 * 0.07739938050508499f;
    float _1185 = _1179 * 0.9478672742843628f;
    float _1186 = _1180 * 0.9478672742843628f;
    float _1187 = _1181 * 0.9478672742843628f;
    float _1188 = _1185 + 0.05213269963860512f;
    float _1189 = _1186 + 0.05213269963860512f;
    float _1190 = _1187 + 0.05213269963860512f;
    float _1191 = log2(_1188);
    float _1192 = log2(_1189);
    float _1193 = log2(_1190);
    float _1194 = _1191 * 2.4000000953674316f;
    float _1195 = _1192 * 2.4000000953674316f;
    float _1196 = _1193 * 2.4000000953674316f;
    float _1197 = exp2(_1194);
    float _1198 = exp2(_1195);
    float _1199 = exp2(_1196);
    bool _1200 = (_1179 > 0.040449999272823334f);
    bool _1201 = (_1180 > 0.040449999272823334f);
    bool _1202 = (_1181 > 0.040449999272823334f);
    float _1203 = _1200 ? _1197 : _1182;
    float _1204 = _1201 ? _1198 : _1183;
    float _1205 = _1202 ? _1199 : _1184;
  // float4 _1206 = cb0[38u];
    float _1207 = cb0_38x;
    float _1208 = _1207 * _1203;
    float _1209 = _1207 * _1204;
    float _1210 = _1207 * _1205;
    float _1211 = cb0_38y;
    float _1212 = cb0_38z;
    float _1213 = _1211 + _1208;
    float _1214 = _1213 * _1203;
    float _1215 = _1214 + _1212;
    float _1216 = _1211 + _1209;
    float _1217 = _1216 * _1204;
    float _1218 = _1217 + _1212;
    float _1219 = _1211 + _1210;
    float _1220 = _1219 * _1205;
    float _1221 = _1220 + _1212;
  // float4 _1222 = cb0[12u];
    float _1223 = cb0_12w;
    float _1224 = cb0_12x;
    float _1225 = cb0_12y;
    float _1226 = cb0_12z;
  // float4 _1227 = cb0[13u];
    float _1228 = cb0_13x;
    float _1229 = cb0_13y;
    float _1230 = cb0_13z;
    float _1231 = _1228 * _1215;
    float _1232 = _1229 * _1218;
    float _1233 = _1230 * _1221;
    float _1234 = _1224 - _1231;
    float _1235 = _1225 - _1232;
    float _1236 = _1226 - _1233;
    float _1237 = _1234 * _1223;
    float _1238 = _1235 * _1223;
    float _1239 = _1236 * _1223;
    float _1240 = _1237 + _1231;
    float _1241 = _1238 + _1232;
    float _1242 = _1239 + _1233;
  // float4 _1243 = cb0[39u];
    float _1244 = cb0_39y;
    float _1245 = max(0.0f, _1240);
    float _1246 = max(0.0f, _1241);
    float _1247 = max(0.0f, _1242);
    float _1248 = log2(_1245);
    float _1249 = log2(_1246);
    float _1250 = log2(_1247);
    float _1251 = _1248 * _1244;
    float _1252 = _1249 * _1244;
    float _1253 = _1250 * _1244;
    float _1254 = exp2(_1251);
    float _1255 = exp2(_1252);
    float _1256 = exp2(_1253);
  
    float3 film_graded_color = float3(_1254, _1255, _1256);

    if (is_hdr)
    {
        float3 post_process_color = saturate(film_graded_color);

        float3 final_color = renodx::tonemap::UpgradeToneMap(
        hdr_color, sdr_color, post_process_color, 1.f);
		
        final_color *= injectedData.toneMapGameNits / 80.f; // game brightness
        bool is_pq = (output_type == 3u || output_type == 4u);
        if (is_pq)
        {
            final_color = renodx::color::bt2020::from::BT709(final_color);
            final_color = renodx::color::pq::from::BT2020(final_color, 100.f);
        }
	
        return float4(final_color * 0.9523810148239136f, 0);
    }
  
  // int4 _1257 = cb0[39u]; 
    uint _1258 = cb0_39w;
    bool _1259 = (_1258 == 0);
    if (_1259)
    {
        bool _1261 = (_1254 < 0.0031306699384003878f);
        do
        {
            if (_1261)
            {
                float _1263 = _1254 * 12.920000076293945f;
                _1271 = _1263;
            }
            else
            {
                float _1265 = log2(_1254);
                float _1266 = _1265 * 0.4166666567325592f;
                float _1267 = exp2(_1266);
                float _1268 = _1267 * 1.0549999475479126f;
                float _1269 = _1268 + -0.054999999701976776f;
                _1271 = _1269;
            }
            bool _1272 = (_1255 < 0.0031306699384003878f);
            do
            {
                if (_1272)
                {
                    float _1274 = _1255 * 12.920000076293945f;
                    _1282 = _1274;
                }
                else
                {
                    float _1276 = log2(_1255);
                    float _1277 = _1276 * 0.4166666567325592f;
                    float _1278 = exp2(_1277);
                    float _1279 = _1278 * 1.0549999475479126f;
                    float _1280 = _1279 + -0.054999999701976776f;
                    _1282 = _1280;
                }
                bool _1283 = (_1256 < 0.0031306699384003878f);
                if (_1283)
                {
                    float _1285 = _1256 * 12.920000076293945f;
                    _2769 = _1271;
                    _2770 = _1282;
                    _2771 = _1285;
                }
                else
                {
                    float _1287 = log2(_1256);
                    float _1288 = _1287 * 0.4166666567325592f;
                    float _1289 = exp2(_1288);
                    float _1290 = _1289 * 1.0549999475479126f;
                    float _1291 = _1290 + -0.054999999701976776f;
                    _2769 = _1271;
                    _2770 = _1282;
                    _2771 = _1291;
                }
            } while (false);
        } while (false);
    }
    else
    {
        bool _1293 = (_1258 == 1);
        if (_1293)
        {
            float _1295 = _1254 * 0.613191545009613f;
            float _1296 = mad(0.3395121395587921f, _1255, _1295);
            float _1297 = mad(0.04736635088920593f, _1256, _1296);
            float _1298 = _1254 * 0.07020691782236099f;
            float _1299 = mad(0.9163357615470886f, _1255, _1298);
            float _1300 = mad(0.01345000695437193f, _1256, _1299);
            float _1301 = _1254 * 0.020618872717022896f;
            float _1302 = mad(0.1095672994852066f, _1255, _1301);
            float _1303 = mad(0.8696067929267883f, _1256, _1302);
            float _1304 = _1297 * _37;
            float _1305 = mad(_38, _1300, _1304);
            float _1306 = mad(_39, _1303, _1305);
            float _1307 = _1297 * _40;
            float _1308 = mad(_41, _1300, _1307);
            float _1309 = mad(_42, _1303, _1308);
            float _1310 = _1297 * _43;
            float _1311 = mad(_44, _1300, _1310);
            float _1312 = mad(_45, _1303, _1311);
            float _1313 = max(6.103519990574569e-05f, _1306);
            float _1314 = max(6.103519990574569e-05f, _1309);
            float _1315 = max(6.103519990574569e-05f, _1312);
            float _1316 = max(_1313, 0.017999999225139618f);
            float _1317 = max(_1314, 0.017999999225139618f);
            float _1318 = max(_1315, 0.017999999225139618f);
            float _1319 = log2(_1316);
            float _1320 = log2(_1317);
            float _1321 = log2(_1318);
            float _1322 = _1319 * 0.44999998807907104f;
            float _1323 = _1320 * 0.44999998807907104f;
            float _1324 = _1321 * 0.44999998807907104f;
            float _1325 = exp2(_1322);
            float _1326 = exp2(_1323);
            float _1327 = exp2(_1324);
            float _1328 = _1325 * 1.0989999771118164f;
            float _1329 = _1326 * 1.0989999771118164f;
            float _1330 = _1327 * 1.0989999771118164f;
            float _1331 = _1328 + -0.0989999994635582f;
            float _1332 = _1329 + -0.0989999994635582f;
            float _1333 = _1330 + -0.0989999994635582f;
            float _1334 = _1313 * 4.5f;
            float _1335 = _1314 * 4.5f;
            float _1336 = _1315 * 4.5f;
            float _1337 = min(_1334, _1331);
            float _1338 = min(_1335, _1332);
            float _1339 = min(_1336, _1333);
            _2769 = _1337;
            _2770 = _1338;
            _2771 = _1339;
        }
        else
        {
            bool _1341 = (_1258 == 3);
            bool _1342 = (_1258 == 5);
            bool _1343 = _1341 || _1342;
            if (_1343)
            {
        //   %1345 = bitcast [6 x float]* %10 to i8*
        //   %1346 = bitcast [6 x float]* %11 to i8*
        // float4 _1347 = cb0[11u];
                float _1348 = cb0_11w;
                float _1349 = cb0_11z;
                float _1350 = cb0_11y;
                float _1351 = cb0_11x;
        // float4 _1352 = cb0[10u];
                float _1353 = cb0_10x;
                float _1354 = cb0_10y;
                float _1355 = cb0_10z;
                float _1356 = cb0_10w;
        // float4 _1357 = cb0[9u];
                float _1358 = cb0_09x;
                float _1359 = cb0_09y;
                float _1360 = cb0_09z;
                float _1361 = cb0_09w;
        // float4 _1362 = cb0[8u];
                float _1363 = cb0_08x;
        // float4 _1364 = cb0[7u];
                float _1365 = cb0_07x;
                float _1366 = cb0_07y;
                float _1367 = cb0_07z;
                float _1368 = cb0_07w;
                _10[0] = _1358;
                _10[1] = _1359;
                _10[2] = _1360;
                _10[3] = _1361;
                _10[4] = _1351;
                _10[5] = _1351;
                _11[0] = _1353;
                _11[1] = _1354;
                _11[2] = _1355;
                _11[3] = _1356;
                _11[4] = _1350;
                _11[5] = _1350;
                float _1381 = _1349 * _1215;
                float _1382 = _1349 * _1218;
                float _1383 = _1349 * _1221;
                float _1384 = _1381 * 0.43970081210136414f;
                float _1385 = mad(0.38297808170318604f, _1382, _1384);
                float _1386 = mad(0.17733481526374817f, _1383, _1385);
                float _1387 = _1381 * 0.08979231864213943f;
                float _1388 = mad(0.8134231567382812f, _1382, _1387);
                float _1389 = mad(0.09676162153482437f, _1383, _1388);
                float _1390 = _1381 * 0.017543988302350044f;
                float _1391 = mad(0.11154405772686005f, _1382, _1390);
                float _1392 = mad(0.870704174041748f, _1383, _1391);
                float _1393 = _1386 * 1.4514392614364624f;
                float _1394 = mad(-0.2365107536315918f, _1389, _1393);
                float _1395 = mad(-0.21492856740951538f, _1392, _1394);
                float _1396 = _1386 * -0.07655377686023712f;
                float _1397 = mad(1.17622971534729f, _1389, _1396);
                float _1398 = mad(-0.09967592358589172f, _1392, _1397);
                float _1399 = _1386 * 0.008316148072481155f;
                float _1400 = mad(-0.006032449658960104f, _1389, _1399);
                float _1401 = mad(0.9977163076400757f, _1392, _1400);
                float _1402 = max(_1398, _1401);
                float _1403 = max(_1395, _1402);
                bool _1404 = (_1403 < 1.000000013351432e-10f);
                bool _1405 = (_1386 < 0.0f);
                bool _1406 = (_1389 < 0.0f);
                bool _1407 = (_1392 < 0.0f);
                bool _1408 = _1405 || _1406;
                bool _1409 = _1408 || _1407;
                bool _1410 = _1409 || _1404;
                _1471 = _1395;
                _1472 = _1398;
                _1473 = _1401;
                do
                {
                    if (!_1410)
                    {
                        float _1412 = _1403 - _1395;
                        float _1413 = abs(_1403);
                        float _1414 = _1412 / _1413;
                        float _1415 = _1403 - _1398;
                        float _1416 = _1415 / _1413;
                        float _1417 = _1403 - _1401;
                        float _1418 = _1417 / _1413;
                        bool _1419 = (_1414 < 0.8149999976158142f);
                        _1433 = _1414;
                        do
                        {
                            if (!_1419)
                            {
                                float _1421 = _1414 + -0.8149999976158142f;
                                float _1422 = _1421 * 3.0552830696105957f;
                                float _1423 = log2(_1422);
                                float _1424 = _1423 * 1.2000000476837158f;
                                float _1425 = exp2(_1424);
                                float _1426 = _1425 + 1.0f;
                                float _1427 = log2(_1426);
                                float _1428 = _1427 * 0.8333333134651184f;
                                float _1429 = exp2(_1428);
                                float _1430 = _1421 / _1429;
                                float _1431 = _1430 + 0.8149999976158142f;
                                _1433 = _1431;
                            }
                            bool _1434 = (_1416 < 0.8029999732971191f);
                            _1448 = _1416;
                            do
                            {
                                if (!_1434)
                                {
                                    float _1436 = _1416 + -0.8029999732971191f;
                                    float _1437 = _1436 * 3.4972610473632812f;
                                    float _1438 = log2(_1437);
                                    float _1439 = _1438 * 1.2000000476837158f;
                                    float _1440 = exp2(_1439);
                                    float _1441 = _1440 + 1.0f;
                                    float _1442 = log2(_1441);
                                    float _1443 = _1442 * 0.8333333134651184f;
                                    float _1444 = exp2(_1443);
                                    float _1445 = _1436 / _1444;
                                    float _1446 = _1445 + 0.8029999732971191f;
                                    _1448 = _1446;
                                }
                                bool _1449 = (_1418 < 0.8799999952316284f);
                                _1463 = _1418;
                                do
                                {
                                    if (!_1449)
                                    {
                                        float _1451 = _1418 + -0.8799999952316284f;
                                        float _1452 = _1451 * 6.810994625091553f;
                                        float _1453 = log2(_1452);
                                        float _1454 = _1453 * 1.2000000476837158f;
                                        float _1455 = exp2(_1454);
                                        float _1456 = _1455 + 1.0f;
                                        float _1457 = log2(_1456);
                                        float _1458 = _1457 * 0.8333333134651184f;
                                        float _1459 = exp2(_1458);
                                        float _1460 = _1451 / _1459;
                                        float _1461 = _1460 + 0.8799999952316284f;
                                        _1463 = _1461;
                                    }
                                    float _1464 = _1413 * _1433;
                                    float _1465 = _1403 - _1464;
                                    float _1466 = _1413 * _1448;
                                    float _1467 = _1403 - _1466;
                                    float _1468 = _1413 * _1463;
                                    float _1469 = _1403 - _1468;
                                    _1471 = _1465;
                                    _1472 = _1467;
                                    _1473 = _1469;
                                } while (false);
                            } while (false);
                        } while (false);
                    }
                    float _1474 = _1471 * 0.6954522132873535f;
                    float _1475 = mad(0.14067870378494263f, _1472, _1474);
                    float _1476 = mad(0.16386906802654266f, _1473, _1475);
                    float _1477 = _1476 - _1386;
                    float _1478 = _1476 - _1389;
                    float _1479 = _1476 - _1392;
                    float _1480 = _1477 * _1348;
                    float _1481 = _1478 * _1348;
                    float _1482 = _1479 * _1348;
                    float _1483 = _1480 + _1386;
                    float _1484 = _1481 + _1389;
                    float _1485 = _1482 + _1392;
                    float _1486 = min(_1483, _1484);
                    float _1487 = min(_1486, _1485);
                    float _1488 = max(_1483, _1484);
                    float _1489 = max(_1488, _1485);
                    float _1490 = max(_1489, 1.000000013351432e-10f);
                    float _1491 = max(_1487, 1.000000013351432e-10f);
                    float _1492 = _1490 - _1491;
                    float _1493 = max(_1489, 0.009999999776482582f);
                    float _1494 = _1492 / _1493;
                    float _1495 = _1485 - _1484;
                    float _1496 = _1495 * _1485;
                    float _1497 = _1484 - _1483;
                    float _1498 = _1497 * _1484;
                    float _1499 = _1496 + _1498;
                    float _1500 = _1483 - _1485;
                    float _1501 = _1500 * _1483;
                    float _1502 = _1499 + _1501;
                    float _1503 = sqrt(_1502);
                    float _1504 = _1485 + _1484;
                    float _1505 = _1504 + _1483;
                    float _1506 = _1503 * 1.75f;
                    float _1507 = _1505 + _1506;
                    float _1508 = _1507 * 0.3333333432674408f;
                    float _1509 = _1494 + -0.4000000059604645f;
                    float _1510 = _1509 * 5.0f;
                    float _1511 = _1509 * 2.5f;
                    float _1512 = abs(_1511);
                    float _1513 = 1.0f - _1512;
                    float _1514 = max(_1513, 0.0f);
                    bool _1515 = (_1510 > 0.0f);
                    bool _1516 = (_1510 < 0.0f);
                    int _1517 = int(_1515);
                    int _1518 = int(_1516);
                    int _1519 = _1517 - _1518;
                    float _1520 = float(_1519);
                    float _1521 = _1514 * _1514;
                    float _1522 = 1.0f - _1521;
                    float _1523 = _1520 * _1522;
                    float _1524 = _1523 + 1.0f;
                    float _1525 = _1524 * 0.02500000037252903f;
                    bool _1526 = !(_1508 <= 0.0533333346247673f);
                    _1534 = _1525;
                    do
                    {
                        if (_1526)
                        {
                            bool _1528 = !(_1508 >= 0.1599999964237213f);
                            _1534 = 0.0f;
                            if (_1528)
                            {
                                float _1530 = 0.23999999463558197f / _1507;
                                float _1531 = _1530 + -0.5f;
                                float _1532 = _1531 * _1525;
                                _1534 = _1532;
                            }
                        }
                        float _1535 = _1534 + 1.0f;
                        float _1536 = _1535 * _1483;
                        float _1537 = _1535 * _1484;
                        float _1538 = _1535 * _1485;
                        bool _1539 = (_1536 == _1537);
                        bool _1540 = (_1537 == _1538);
                        bool _1541 = _1539 && _1540;
                        _1570 = 0.0f;
                        do
                        {
                            if (!_1541)
                            {
                                float _1543 = _1536 * 2.0f;
                                float _1544 = _1543 - _1537;
                                float _1545 = _1544 - _1538;
                                float _1546 = _1484 - _1485;
                                float _1547 = _1546 * 1.7320507764816284f;
                                float _1548 = _1547 * _1535;
                                float _1549 = _1548 / _1545;
                                float _1550 = atan(_1549);
                                float _1551 = _1550 + 3.1415927410125732f;
                                float _1552 = _1550 + -3.1415927410125732f;
                                bool _1553 = (_1545 < 0.0f);
                                bool _1554 = (_1545 == 0.0f);
                                bool _1555 = (_1548 >= 0.0f);
                                bool _1556 = (_1548 < 0.0f);
                                bool _1557 = _1555 && _1553;
                                float _1558 = _1557 ? _1551 : _1550;
                                bool _1559 = _1556 && _1553;
                                float _1560 = _1559 ? _1552 : _1558;
                                bool _1561 = _1556 && _1554;
                                bool _1562 = _1555 && _1554;
                                float _1563 = _1560 * 57.2957763671875f;
                                float _1564 = _1561 ? -90.0f : _1563;
                                float _1565 = _1562 ? 90.0f : _1564;
                                bool _1566 = (_1565 < 0.0f);
                                _1570 = _1565;
                                if (_1566)
                                {
                                    float _1568 = _1565 + 360.0f;
                                    _1570 = _1568;
                                }
                            }
                            float _1571 = max(_1570, 0.0f);
                            float _1572 = min(_1571, 360.0f);
                            bool _1573 = (_1572 < -180.0f);
                            do
                            {
                                if (_1573)
                                {
                                    float _1575 = _1572 + 360.0f;
                                    _1581 = _1575;
                                }
                                else
                                {
                                    bool _1577 = (_1572 > 180.0f);
                                    _1581 = _1572;
                                    if (_1577)
                                    {
                                        float _1579 = _1572 + -360.0f;
                                        _1581 = _1579;
                                    }
                                }
                                bool _1582 = (_1581 > -67.5f);
                                bool _1583 = (_1581 < 67.5f);
                                bool _1584 = _1582 && _1583;
                                _1620 = 0.0f;
                                do
                                {
                                    if (_1584)
                                    {
                                        float _1586 = _1581 + 67.5f;
                                        float _1587 = _1586 * 0.029629629105329514f;
                                        int _1588 = int(_1587);
                                        float _1589 = float(_1588);
                                        float _1590 = _1587 - _1589;
                                        float _1591 = _1590 * _1590;
                                        float _1592 = _1591 * _1590;
                                        bool _1593 = (_1588 == 3);
                                        if (_1593)
                                        {
                                            float _1595 = _1592 * 0.1666666716337204f;
                                            float _1596 = _1591 * 0.5f;
                                            float _1597 = _1590 * 0.5f;
                                            float _1598 = 0.1666666716337204f - _1597;
                                            float _1599 = _1598 + _1596;
                                            float _1600 = _1599 - _1595;
                                            _1620 = _1600;
                                        }
                                        else
                                        {
                                            bool _1602 = (_1588 == 2);
                                            if (_1602)
                                            {
                                                float _1604 = _1592 * 0.5f;
                                                float _1605 = 0.6666666865348816f - _1591;
                                                float _1606 = _1605 + _1604;
                                                _1620 = _1606;
                                            }
                                            else
                                            {
                                                bool _1608 = (_1588 == 1);
                                                if (_1608)
                                                {
                                                    float _1610 = _1592 * -0.5f;
                                                    float _1611 = _1591 + _1590;
                                                    float _1612 = _1611 * 0.5f;
                                                    float _1613 = _1610 + 0.1666666716337204f;
                                                    float _1614 = _1613 + _1612;
                                                    _1620 = _1614;
                                                }
                                                else
                                                {
                                                    bool _1616 = (_1588 == 0);
                                                    float _1617 = _1592 * 0.1666666716337204f;
                                                    float _1618 = _1616 ? _1617 : 0.0f;
                                                    _1620 = _1618;
                                                }
                                            }
                                        }
                                    }
                                    float _1621 = 0.029999999329447746f - _1536;
                                    float _1622 = _1494 * 0.27000001072883606f;
                                    float _1623 = _1622 * _1621;
                                    float _1624 = _1623 * _1620;
                                    float _1625 = _1624 + _1536;
                                    float _1626 = max(_1625, 0.0f);
                                    float _1627 = max(_1537, 0.0f);
                                    float _1628 = max(_1538, 0.0f);
                                    float _1629 = min(_1626, 65535.0f);
                                    float _1630 = min(_1627, 65535.0f);
                                    float _1631 = min(_1628, 65535.0f);
                                    float _1632 = _1629 * 1.4514392614364624f;
                                    float _1633 = mad(-0.2365107536315918f, _1630, _1632);
                                    float _1634 = mad(-0.21492856740951538f, _1631, _1633);
                                    float _1635 = _1629 * -0.07655377686023712f;
                                    float _1636 = mad(1.17622971534729f, _1630, _1635);
                                    float _1637 = mad(-0.09967592358589172f, _1631, _1636);
                                    float _1638 = _1629 * 0.008316148072481155f;
                                    float _1639 = mad(-0.006032449658960104f, _1630, _1638);
                                    float _1640 = mad(0.9977163076400757f, _1631, _1639);
                                    float _1641 = max(_1634, 0.0f);
                                    float _1642 = max(_1637, 0.0f);
                                    float _1643 = max(_1640, 0.0f);
                                    float _1644 = min(_1641, 65504.0f);
                                    float _1645 = min(_1642, 65504.0f);
                                    float _1646 = min(_1643, 65504.0f);
                                    float _1647 = dot(float3(_1644, _1645, _1646), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                                    float _1648 = _1644 - _1647;
                                    float _1649 = _1645 - _1647;
                                    float _1650 = _1646 - _1647;
                                    float _1651 = _1648 * 0.9599999785423279f;
                                    float _1652 = _1649 * 0.9599999785423279f;
                                    float _1653 = _1650 * 0.9599999785423279f;
                                    float _1654 = _1651 + _1647;
                                    float _1655 = _1652 + _1647;
                                    float _1656 = _1653 + _1647;
                                    float _1657 = max(_1654, 1.000000013351432e-10f);
                                    float _1658 = log2(_1657);
                                    float _1659 = _1658 * 0.3010300099849701f;
                                    float _1660 = log2(_1365);
                                    float _1661 = _1660 * 0.3010300099849701f;
                                    bool _1662 = !(_1659 <= _1661);
                                    do
                                    {
                                        if (!_1662)
                                        {
                                            float _1664 = log2(_1366);
                                            float _1665 = _1664 * 0.3010300099849701f;
                                            _1730 = _1665;
                                        }
                                        else
                                        {
                                            bool _1667 = (_1659 > _1661);
                                            float _1668 = log2(_1363);
                                            float _1669 = _1668 * 0.3010300099849701f;
                                            bool _1670 = (_1659 < _1669);
                                            bool _1671 = _1667 && _1670;
                                            if (_1671)
                                            {
                                                float _1673 = _1658 - _1660;
                                                float _1674 = _1673 * 0.9030900001525879f;
                                                float _1675 = _1668 - _1660;
                                                float _1676 = _1675 * 0.3010300099849701f;
                                                float _1677 = _1674 / _1676;
                                                int _1678 = int(_1677);
                                                float _1679 = float(_1678);
                                                float _1680 = _1677 - _1679;
                                                float _1682 = _10[_1678];
                                                int _1683 = _1678 + 1;
                                                float _1685 = _10[_1683];
                                                int _1686 = _1678 + 2;
                                                float _1688 = _10[_1686];
                                                float _1689 = _1680 * _1680;
                                                float _1690 = _1682 * 0.5f;
                                                float _1691 = mad(_1685, -1.0f, _1690);
                                                float _1692 = mad(_1688, 0.5f, _1691);
                                                float _1693 = _1685 - _1682;
                                                float _1694 = mad(_1685, 0.5f, _1690);
                                                float _1695 = dot(float3(_1689, _1680, 1.0f), float3(_1692, _1693, _1694));
                                                _1730 = _1695;
                                            }
                                            else
                                            {
                                                bool _1697 = (_1659 >= _1669);
                                                float _1698 = log2(_1367);
                                                float _1699 = _1698 * 0.3010300099849701f;
                                                bool _1700 = (_1659 < _1699);
                                                bool _1701 = _1697 && _1700;
                                                if (_1701)
                                                {
                                                    float _1703 = _1658 - _1668;
                                                    float _1704 = _1703 * 0.9030900001525879f;
                                                    float _1705 = _1698 - _1668;
                                                    float _1706 = _1705 * 0.3010300099849701f;
                                                    float _1707 = _1704 / _1706;
                                                    int _1708 = int(_1707);
                                                    float _1709 = float(_1708);
                                                    float _1710 = _1707 - _1709;
                                                    float _1712 = _11[_1708];
                                                    int _1713 = _1708 + 1;
                                                    float _1715 = _11[_1713];
                                                    int _1716 = _1708 + 2;
                                                    float _1718 = _11[_1716];
                                                    float _1719 = _1710 * _1710;
                                                    float _1720 = _1712 * 0.5f;
                                                    float _1721 = mad(_1715, -1.0f, _1720);
                                                    float _1722 = mad(_1718, 0.5f, _1721);
                                                    float _1723 = _1715 - _1712;
                                                    float _1724 = mad(_1715, 0.5f, _1720);
                                                    float _1725 = dot(float3(_1719, _1710, 1.0f), float3(_1722, _1723, _1724));
                                                    _1730 = _1725;
                                                }
                                                else
                                                {
                                                    float _1727 = log2(_1368);
                                                    float _1728 = _1727 * 0.3010300099849701f;
                                                    _1730 = _1728;
                                                }
                                            }
                                        }
                                        float _1731 = _1730 * 3.321928024291992f;
                                        float _1732 = exp2(_1731);
                                        float _1733 = max(_1655, 1.000000013351432e-10f);
                                        float _1734 = log2(_1733);
                                        float _1735 = _1734 * 0.3010300099849701f;
                                        bool _1736 = !(_1735 <= _1661);
                                        do
                                        {
                                            if (!_1736)
                                            {
                                                float _1738 = log2(_1366);
                                                float _1739 = _1738 * 0.3010300099849701f;
                                                _1804 = _1739;
                                            }
                                            else
                                            {
                                                bool _1741 = (_1735 > _1661);
                                                float _1742 = log2(_1363);
                                                float _1743 = _1742 * 0.3010300099849701f;
                                                bool _1744 = (_1735 < _1743);
                                                bool _1745 = _1741 && _1744;
                                                if (_1745)
                                                {
                                                    float _1747 = _1734 - _1660;
                                                    float _1748 = _1747 * 0.9030900001525879f;
                                                    float _1749 = _1742 - _1660;
                                                    float _1750 = _1749 * 0.3010300099849701f;
                                                    float _1751 = _1748 / _1750;
                                                    int _1752 = int(_1751);
                                                    float _1753 = float(_1752);
                                                    float _1754 = _1751 - _1753;
                                                    float _1756 = _10[_1752];
                                                    int _1757 = _1752 + 1;
                                                    float _1759 = _10[_1757];
                                                    int _1760 = _1752 + 2;
                                                    float _1762 = _10[_1760];
                                                    float _1763 = _1754 * _1754;
                                                    float _1764 = _1756 * 0.5f;
                                                    float _1765 = mad(_1759, -1.0f, _1764);
                                                    float _1766 = mad(_1762, 0.5f, _1765);
                                                    float _1767 = _1759 - _1756;
                                                    float _1768 = mad(_1759, 0.5f, _1764);
                                                    float _1769 = dot(float3(_1763, _1754, 1.0f), float3(_1766, _1767, _1768));
                                                    _1804 = _1769;
                                                }
                                                else
                                                {
                                                    bool _1771 = (_1735 >= _1743);
                                                    float _1772 = log2(_1367);
                                                    float _1773 = _1772 * 0.3010300099849701f;
                                                    bool _1774 = (_1735 < _1773);
                                                    bool _1775 = _1771 && _1774;
                                                    if (_1775)
                                                    {
                                                        float _1777 = _1734 - _1742;
                                                        float _1778 = _1777 * 0.9030900001525879f;
                                                        float _1779 = _1772 - _1742;
                                                        float _1780 = _1779 * 0.3010300099849701f;
                                                        float _1781 = _1778 / _1780;
                                                        int _1782 = int(_1781);
                                                        float _1783 = float(_1782);
                                                        float _1784 = _1781 - _1783;
                                                        float _1786 = _11[_1782];
                                                        int _1787 = _1782 + 1;
                                                        float _1789 = _11[_1787];
                                                        int _1790 = _1782 + 2;
                                                        float _1792 = _11[_1790];
                                                        float _1793 = _1784 * _1784;
                                                        float _1794 = _1786 * 0.5f;
                                                        float _1795 = mad(_1789, -1.0f, _1794);
                                                        float _1796 = mad(_1792, 0.5f, _1795);
                                                        float _1797 = _1789 - _1786;
                                                        float _1798 = mad(_1789, 0.5f, _1794);
                                                        float _1799 = dot(float3(_1793, _1784, 1.0f), float3(_1796, _1797, _1798));
                                                        _1804 = _1799;
                                                    }
                                                    else
                                                    {
                                                        float _1801 = log2(_1368);
                                                        float _1802 = _1801 * 0.3010300099849701f;
                                                        _1804 = _1802;
                                                    }
                                                }
                                            }
                                            float _1805 = _1804 * 3.321928024291992f;
                                            float _1806 = exp2(_1805);
                                            float _1807 = max(_1656, 1.000000013351432e-10f);
                                            float _1808 = log2(_1807);
                                            float _1809 = _1808 * 0.3010300099849701f;
                                            bool _1810 = !(_1809 <= _1661);
                                            do
                                            {
                                                if (!_1810)
                                                {
                                                    float _1812 = log2(_1366);
                                                    float _1813 = _1812 * 0.3010300099849701f;
                                                    _1878 = _1813;
                                                }
                                                else
                                                {
                                                    bool _1815 = (_1809 > _1661);
                                                    float _1816 = log2(_1363);
                                                    float _1817 = _1816 * 0.3010300099849701f;
                                                    bool _1818 = (_1809 < _1817);
                                                    bool _1819 = _1815 && _1818;
                                                    if (_1819)
                                                    {
                                                        float _1821 = _1808 - _1660;
                                                        float _1822 = _1821 * 0.9030900001525879f;
                                                        float _1823 = _1816 - _1660;
                                                        float _1824 = _1823 * 0.3010300099849701f;
                                                        float _1825 = _1822 / _1824;
                                                        int _1826 = int(_1825);
                                                        float _1827 = float(_1826);
                                                        float _1828 = _1825 - _1827;
                                                        float _1830 = _10[_1826];
                                                        int _1831 = _1826 + 1;
                                                        float _1833 = _10[_1831];
                                                        int _1834 = _1826 + 2;
                                                        float _1836 = _10[_1834];
                                                        float _1837 = _1828 * _1828;
                                                        float _1838 = _1830 * 0.5f;
                                                        float _1839 = mad(_1833, -1.0f, _1838);
                                                        float _1840 = mad(_1836, 0.5f, _1839);
                                                        float _1841 = _1833 - _1830;
                                                        float _1842 = mad(_1833, 0.5f, _1838);
                                                        float _1843 = dot(float3(_1837, _1828, 1.0f), float3(_1840, _1841, _1842));
                                                        _1878 = _1843;
                                                    }
                                                    else
                                                    {
                                                        bool _1845 = (_1809 >= _1817);
                                                        float _1846 = log2(_1367);
                                                        float _1847 = _1846 * 0.3010300099849701f;
                                                        bool _1848 = (_1809 < _1847);
                                                        bool _1849 = _1845 && _1848;
                                                        if (_1849)
                                                        {
                                                            float _1851 = _1808 - _1816;
                                                            float _1852 = _1851 * 0.9030900001525879f;
                                                            float _1853 = _1846 - _1816;
                                                            float _1854 = _1853 * 0.3010300099849701f;
                                                            float _1855 = _1852 / _1854;
                                                            int _1856 = int(_1855);
                                                            float _1857 = float(_1856);
                                                            float _1858 = _1855 - _1857;
                                                            float _1860 = _11[_1856];
                                                            int _1861 = _1856 + 1;
                                                            float _1863 = _11[_1861];
                                                            int _1864 = _1856 + 2;
                                                            float _1866 = _11[_1864];
                                                            float _1867 = _1858 * _1858;
                                                            float _1868 = _1860 * 0.5f;
                                                            float _1869 = mad(_1863, -1.0f, _1868);
                                                            float _1870 = mad(_1866, 0.5f, _1869);
                                                            float _1871 = _1863 - _1860;
                                                            float _1872 = mad(_1863, 0.5f, _1868);
                                                            float _1873 = dot(float3(_1867, _1858, 1.0f), float3(_1870, _1871, _1872));
                                                            _1878 = _1873;
                                                        }
                                                        else
                                                        {
                                                            float _1875 = log2(_1368);
                                                            float _1876 = _1875 * 0.3010300099849701f;
                                                            _1878 = _1876;
                                                        }
                                                    }
                                                }
                                                float _1879 = _1878 * 3.321928024291992f;
                                                float _1880 = exp2(_1879);
                                                float _1881 = _1732 - _1366;
                                                float _1882 = _1368 - _1366;
                                                float _1883 = _1881 / _1882;
                                                float _1884 = _1806 - _1366;
                                                float _1885 = _1884 / _1882;
                                                float _1886 = _1880 - _1366;
                                                float _1887 = _1886 / _1882;
                                                float _1888 = _1883 * 0.6624541878700256f;
                                                float _1889 = mad(0.13400420546531677f, _1885, _1888);
                                                float _1890 = mad(0.15618768334388733f, _1887, _1889);
                                                float _1891 = _1883 * 0.2722287178039551f;
                                                float _1892 = mad(0.6740817427635193f, _1885, _1891);
                                                float _1893 = mad(0.053689517080783844f, _1887, _1892);
                                                float _1894 = _1883 * -0.005574649665504694f;
                                                float _1895 = mad(0.00406073359772563f, _1885, _1894);
                                                float _1896 = mad(1.0103391408920288f, _1887, _1895);
                                                float _1897 = _1890 * 1.6410233974456787f;
                                                float _1898 = mad(-0.32480329275131226f, _1893, _1897);
                                                float _1899 = mad(-0.23642469942569733f, _1896, _1898);
                                                float _1900 = _1890 * -0.663662850856781f;
                                                float _1901 = mad(1.6153316497802734f, _1893, _1900);
                                                float _1902 = mad(0.016756348311901093f, _1896, _1901);
                                                float _1903 = _1890 * 0.011721894145011902f;
                                                float _1904 = mad(-0.008284442126750946f, _1893, _1903);
                                                float _1905 = mad(0.9883948564529419f, _1896, _1904);
                                                float _1906 = max(_1899, 0.0f);
                                                float _1907 = max(_1902, 0.0f);
                                                float _1908 = max(_1905, 0.0f);
                                                float _1909 = min(_1906, 1.0f);
                                                float _1910 = min(_1907, 1.0f);
                                                float _1911 = min(_1908, 1.0f);
                                                float _1912 = _1909 * 0.6624541878700256f;
                                                float _1913 = mad(0.13400420546531677f, _1910, _1912);
                                                float _1914 = mad(0.15618768334388733f, _1911, _1913);
                                                float _1915 = _1909 * 0.2722287178039551f;
                                                float _1916 = mad(0.6740817427635193f, _1910, _1915);
                                                float _1917 = mad(0.053689517080783844f, _1911, _1916);
                                                float _1918 = _1909 * -0.005574649665504694f;
                                                float _1919 = mad(0.00406073359772563f, _1910, _1918);
                                                float _1920 = mad(1.0103391408920288f, _1911, _1919);
                                                float _1921 = _1914 * 1.6410233974456787f;
                                                float _1922 = mad(-0.32480329275131226f, _1917, _1921);
                                                float _1923 = mad(-0.23642469942569733f, _1920, _1922);
                                                float _1924 = _1914 * -0.663662850856781f;
                                                float _1925 = mad(1.6153316497802734f, _1917, _1924);
                                                float _1926 = mad(0.016756348311901093f, _1920, _1925);
                                                float _1927 = _1914 * 0.011721894145011902f;
                                                float _1928 = mad(-0.008284442126750946f, _1917, _1927);
                                                float _1929 = mad(0.9883948564529419f, _1920, _1928);
                                                float _1930 = max(_1923, 0.0f);
                                                float _1931 = max(_1926, 0.0f);
                                                float _1932 = max(_1929, 0.0f);
                                                float _1933 = min(_1930, 65535.0f);
                                                float _1934 = min(_1931, 65535.0f);
                                                float _1935 = min(_1932, 65535.0f);
                                                float _1936 = _1933 * _1368;
                                                float _1937 = _1934 * _1368;
                                                float _1938 = _1935 * _1368;
                                                float _1939 = max(_1936, 0.0f);
                                                float _1940 = max(_1937, 0.0f);
                                                float _1941 = max(_1938, 0.0f);
                                                float _1942 = min(_1939, 65535.0f);
                                                float _1943 = min(_1940, 65535.0f);
                                                float _1944 = min(_1941, 65535.0f);
                                                _1956 = _1942;
                                                _1957 = _1943;
                                                _1958 = _1944;
                                                do
                                                {
                                                    if (!_1342)
                                                    {
                                                        float _1946 = _1942 * _37;
                                                        float _1947 = mad(_38, _1943, _1946);
                                                        float _1948 = mad(_39, _1944, _1947);
                                                        float _1949 = _1942 * _40;
                                                        float _1950 = mad(_41, _1943, _1949);
                                                        float _1951 = mad(_42, _1944, _1950);
                                                        float _1952 = _1942 * _43;
                                                        float _1953 = mad(_44, _1943, _1952);
                                                        float _1954 = mad(_45, _1944, _1953);
                                                        _1956 = _1948;
                                                        _1957 = _1951;
                                                        _1958 = _1954;
                                                    }
                                                    float _1959 = _1956 * 9.999999747378752e-05f;
                                                    float _1960 = _1957 * 9.999999747378752e-05f;
                                                    float _1961 = _1958 * 9.999999747378752e-05f;
                                                    float _1962 = log2(_1959);
                                                    float _1963 = log2(_1960);
                                                    float _1964 = log2(_1961);
                                                    float _1965 = _1962 * 0.1593017578125f;
                                                    float _1966 = _1963 * 0.1593017578125f;
                                                    float _1967 = _1964 * 0.1593017578125f;
                                                    float _1968 = exp2(_1965);
                                                    float _1969 = exp2(_1966);
                                                    float _1970 = exp2(_1967);
                                                    float _1971 = _1968 * 18.8515625f;
                                                    float _1972 = _1969 * 18.8515625f;
                                                    float _1973 = _1970 * 18.8515625f;
                                                    float _1974 = _1971 + 0.8359375f;
                                                    float _1975 = _1972 + 0.8359375f;
                                                    float _1976 = _1973 + 0.8359375f;
                                                    float _1977 = _1968 * 18.6875f;
                                                    float _1978 = _1969 * 18.6875f;
                                                    float _1979 = _1970 * 18.6875f;
                                                    float _1980 = _1977 + 1.0f;
                                                    float _1981 = _1978 + 1.0f;
                                                    float _1982 = _1979 + 1.0f;
                                                    float _1983 = 1.0f / _1980;
                                                    float _1984 = 1.0f / _1981;
                                                    float _1985 = 1.0f / _1982;
                                                    float _1986 = _1983 * _1974;
                                                    float _1987 = _1984 * _1975;
                                                    float _1988 = _1985 * _1976;
                                                    float _1989 = log2(_1986);
                                                    float _1990 = log2(_1987);
                                                    float _1991 = log2(_1988);
                                                    float _1992 = _1989 * 78.84375f;
                                                    float _1993 = _1990 * 78.84375f;
                                                    float _1994 = _1991 * 78.84375f;
                                                    float _1995 = exp2(_1992);
                                                    float _1996 = exp2(_1993);
                                                    float _1997 = exp2(_1994);
                                                    _2769 = _1995;
                                                    _2770 = _1996;
                                                    _2771 = _1997;
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
                bool _1999 = (_1258 == 6);
                int _2000 = _1258 & -3;
                bool _2001 = (_2000 == 4);
                if (_2001)
                {
          //   %2003 = bitcast [6 x float]* %8 to i8*
          //   %2004 = bitcast [6 x float]* %9 to i8*
          // float4 _2005 = cb0[11u];
                    float _2006 = cb0_11w;
                    float _2007 = cb0_11z;
                    float _2008 = cb0_11y;
                    float _2009 = cb0_11x;
          // float4 _2010 = cb0[10u];
                    float _2011 = cb0_10x;
                    float _2012 = cb0_10y;
                    float _2013 = cb0_10z;
                    float _2014 = cb0_10w;
          // float4 _2015 = cb0[9u];
                    float _2016 = cb0_09x;
                    float _2017 = cb0_09y;
                    float _2018 = cb0_09z;
                    float _2019 = cb0_09w;
          // float4 _2020 = cb0[8u];
                    float _2021 = cb0_08x;
          // float4 _2022 = cb0[7u];
                    float _2023 = cb0_07x;
                    float _2024 = cb0_07y;
                    float _2025 = cb0_07z;
                    float _2026 = cb0_07w;
                    _8[0] = _2016;
                    _8[1] = _2017;
                    _8[2] = _2018;
                    _8[3] = _2019;
                    _8[4] = _2009;
                    _8[5] = _2009;
                    _9[0] = _2011;
                    _9[1] = _2012;
                    _9[2] = _2013;
                    _9[3] = _2014;
                    _9[4] = _2008;
                    _9[5] = _2008;
                    float _2039 = _2007 * _1215;
                    float _2040 = _2007 * _1218;
                    float _2041 = _2007 * _1221;
                    float _2042 = _2039 * 0.43970081210136414f;
                    float _2043 = mad(0.38297808170318604f, _2040, _2042);
                    float _2044 = mad(0.17733481526374817f, _2041, _2043);
                    float _2045 = _2039 * 0.08979231864213943f;
                    float _2046 = mad(0.8134231567382812f, _2040, _2045);
                    float _2047 = mad(0.09676162153482437f, _2041, _2046);
                    float _2048 = _2039 * 0.017543988302350044f;
                    float _2049 = mad(0.11154405772686005f, _2040, _2048);
                    float _2050 = mad(0.870704174041748f, _2041, _2049);
                    float _2051 = _2044 * 1.4514392614364624f;
                    float _2052 = mad(-0.2365107536315918f, _2047, _2051);
                    float _2053 = mad(-0.21492856740951538f, _2050, _2052);
                    float _2054 = _2044 * -0.07655377686023712f;
                    float _2055 = mad(1.17622971534729f, _2047, _2054);
                    float _2056 = mad(-0.09967592358589172f, _2050, _2055);
                    float _2057 = _2044 * 0.008316148072481155f;
                    float _2058 = mad(-0.006032449658960104f, _2047, _2057);
                    float _2059 = mad(0.9977163076400757f, _2050, _2058);
                    float _2060 = max(_2056, _2059);
                    float _2061 = max(_2053, _2060);
                    bool _2062 = (_2061 < 1.000000013351432e-10f);
                    bool _2063 = (_2044 < 0.0f);
                    bool _2064 = (_2047 < 0.0f);
                    bool _2065 = (_2050 < 0.0f);
                    bool _2066 = _2063 || _2064;
                    bool _2067 = _2066 || _2065;
                    bool _2068 = _2067 || _2062;
                    _2129 = _2053;
                    _2130 = _2056;
                    _2131 = _2059;
                    do
                    {
                        if (!_2068)
                        {
                            float _2070 = _2061 - _2053;
                            float _2071 = abs(_2061);
                            float _2072 = _2070 / _2071;
                            float _2073 = _2061 - _2056;
                            float _2074 = _2073 / _2071;
                            float _2075 = _2061 - _2059;
                            float _2076 = _2075 / _2071;
                            bool _2077 = (_2072 < 0.8149999976158142f);
                            _2091 = _2072;
                            do
                            {
                                if (!_2077)
                                {
                                    float _2079 = _2072 + -0.8149999976158142f;
                                    float _2080 = _2079 * 3.0552830696105957f;
                                    float _2081 = log2(_2080);
                                    float _2082 = _2081 * 1.2000000476837158f;
                                    float _2083 = exp2(_2082);
                                    float _2084 = _2083 + 1.0f;
                                    float _2085 = log2(_2084);
                                    float _2086 = _2085 * 0.8333333134651184f;
                                    float _2087 = exp2(_2086);
                                    float _2088 = _2079 / _2087;
                                    float _2089 = _2088 + 0.8149999976158142f;
                                    _2091 = _2089;
                                }
                                bool _2092 = (_2074 < 0.8029999732971191f);
                                _2106 = _2074;
                                do
                                {
                                    if (!_2092)
                                    {
                                        float _2094 = _2074 + -0.8029999732971191f;
                                        float _2095 = _2094 * 3.4972610473632812f;
                                        float _2096 = log2(_2095);
                                        float _2097 = _2096 * 1.2000000476837158f;
                                        float _2098 = exp2(_2097);
                                        float _2099 = _2098 + 1.0f;
                                        float _2100 = log2(_2099);
                                        float _2101 = _2100 * 0.8333333134651184f;
                                        float _2102 = exp2(_2101);
                                        float _2103 = _2094 / _2102;
                                        float _2104 = _2103 + 0.8029999732971191f;
                                        _2106 = _2104;
                                    }
                                    bool _2107 = (_2076 < 0.8799999952316284f);
                                    _2121 = _2076;
                                    do
                                    {
                                        if (!_2107)
                                        {
                                            float _2109 = _2076 + -0.8799999952316284f;
                                            float _2110 = _2109 * 6.810994625091553f;
                                            float _2111 = log2(_2110);
                                            float _2112 = _2111 * 1.2000000476837158f;
                                            float _2113 = exp2(_2112);
                                            float _2114 = _2113 + 1.0f;
                                            float _2115 = log2(_2114);
                                            float _2116 = _2115 * 0.8333333134651184f;
                                            float _2117 = exp2(_2116);
                                            float _2118 = _2109 / _2117;
                                            float _2119 = _2118 + 0.8799999952316284f;
                                            _2121 = _2119;
                                        }
                                        float _2122 = _2071 * _2091;
                                        float _2123 = _2061 - _2122;
                                        float _2124 = _2071 * _2106;
                                        float _2125 = _2061 - _2124;
                                        float _2126 = _2071 * _2121;
                                        float _2127 = _2061 - _2126;
                                        _2129 = _2123;
                                        _2130 = _2125;
                                        _2131 = _2127;
                                    } while (false);
                                } while (false);
                            } while (false);
                        }
                        float _2132 = _2129 * 0.6954522132873535f;
                        float _2133 = mad(0.14067870378494263f, _2130, _2132);
                        float _2134 = mad(0.16386906802654266f, _2131, _2133);
                        float _2135 = _2134 - _2044;
                        float _2136 = _2134 - _2047;
                        float _2137 = _2134 - _2050;
                        float _2138 = _2135 * _2006;
                        float _2139 = _2136 * _2006;
                        float _2140 = _2137 * _2006;
                        float _2141 = _2138 + _2044;
                        float _2142 = _2139 + _2047;
                        float _2143 = _2140 + _2050;
                        float _2144 = min(_2141, _2142);
                        float _2145 = min(_2144, _2143);
                        float _2146 = max(_2141, _2142);
                        float _2147 = max(_2146, _2143);
                        float _2148 = max(_2147, 1.000000013351432e-10f);
                        float _2149 = max(_2145, 1.000000013351432e-10f);
                        float _2150 = _2148 - _2149;
                        float _2151 = max(_2147, 0.009999999776482582f);
                        float _2152 = _2150 / _2151;
                        float _2153 = _2143 - _2142;
                        float _2154 = _2153 * _2143;
                        float _2155 = _2142 - _2141;
                        float _2156 = _2155 * _2142;
                        float _2157 = _2154 + _2156;
                        float _2158 = _2141 - _2143;
                        float _2159 = _2158 * _2141;
                        float _2160 = _2157 + _2159;
                        float _2161 = sqrt(_2160);
                        float _2162 = _2143 + _2142;
                        float _2163 = _2162 + _2141;
                        float _2164 = _2161 * 1.75f;
                        float _2165 = _2163 + _2164;
                        float _2166 = _2165 * 0.3333333432674408f;
                        float _2167 = _2152 + -0.4000000059604645f;
                        float _2168 = _2167 * 5.0f;
                        float _2169 = _2167 * 2.5f;
                        float _2170 = abs(_2169);
                        float _2171 = 1.0f - _2170;
                        float _2172 = max(_2171, 0.0f);
                        bool _2173 = (_2168 > 0.0f);
                        bool _2174 = (_2168 < 0.0f);
                        int _2175 = int(_2173);
                        int _2176 = int(_2174);
                        int _2177 = _2175 - _2176;
                        float _2178 = float(_2177);
                        float _2179 = _2172 * _2172;
                        float _2180 = 1.0f - _2179;
                        float _2181 = _2178 * _2180;
                        float _2182 = _2181 + 1.0f;
                        float _2183 = _2182 * 0.02500000037252903f;
                        bool _2184 = !(_2166 <= 0.0533333346247673f);
                        _2192 = _2183;
                        do
                        {
                            if (_2184)
                            {
                                bool _2186 = !(_2166 >= 0.1599999964237213f);
                                _2192 = 0.0f;
                                if (_2186)
                                {
                                    float _2188 = 0.23999999463558197f / _2165;
                                    float _2189 = _2188 + -0.5f;
                                    float _2190 = _2189 * _2183;
                                    _2192 = _2190;
                                }
                            }
                            float _2193 = _2192 + 1.0f;
                            float _2194 = _2193 * _2141;
                            float _2195 = _2193 * _2142;
                            float _2196 = _2193 * _2143;
                            bool _2197 = (_2194 == _2195);
                            bool _2198 = (_2195 == _2196);
                            bool _2199 = _2197 && _2198;
                            _2228 = 0.0f;
                            do
                            {
                                if (!_2199)
                                {
                                    float _2201 = _2194 * 2.0f;
                                    float _2202 = _2201 - _2195;
                                    float _2203 = _2202 - _2196;
                                    float _2204 = _2142 - _2143;
                                    float _2205 = _2204 * 1.7320507764816284f;
                                    float _2206 = _2205 * _2193;
                                    float _2207 = _2206 / _2203;
                                    float _2208 = atan(_2207);
                                    float _2209 = _2208 + 3.1415927410125732f;
                                    float _2210 = _2208 + -3.1415927410125732f;
                                    bool _2211 = (_2203 < 0.0f);
                                    bool _2212 = (_2203 == 0.0f);
                                    bool _2213 = (_2206 >= 0.0f);
                                    bool _2214 = (_2206 < 0.0f);
                                    bool _2215 = _2213 && _2211;
                                    float _2216 = _2215 ? _2209 : _2208;
                                    bool _2217 = _2214 && _2211;
                                    float _2218 = _2217 ? _2210 : _2216;
                                    bool _2219 = _2214 && _2212;
                                    bool _2220 = _2213 && _2212;
                                    float _2221 = _2218 * 57.2957763671875f;
                                    float _2222 = _2219 ? -90.0f : _2221;
                                    float _2223 = _2220 ? 90.0f : _2222;
                                    bool _2224 = (_2223 < 0.0f);
                                    _2228 = _2223;
                                    if (_2224)
                                    {
                                        float _2226 = _2223 + 360.0f;
                                        _2228 = _2226;
                                    }
                                }
                                float _2229 = max(_2228, 0.0f);
                                float _2230 = min(_2229, 360.0f);
                                bool _2231 = (_2230 < -180.0f);
                                do
                                {
                                    if (_2231)
                                    {
                                        float _2233 = _2230 + 360.0f;
                                        _2239 = _2233;
                                    }
                                    else
                                    {
                                        bool _2235 = (_2230 > 180.0f);
                                        _2239 = _2230;
                                        if (_2235)
                                        {
                                            float _2237 = _2230 + -360.0f;
                                            _2239 = _2237;
                                        }
                                    }
                                    bool _2240 = (_2239 > -67.5f);
                                    bool _2241 = (_2239 < 67.5f);
                                    bool _2242 = _2240 && _2241;
                                    _2278 = 0.0f;
                                    do
                                    {
                                        if (_2242)
                                        {
                                            float _2244 = _2239 + 67.5f;
                                            float _2245 = _2244 * 0.029629629105329514f;
                                            int _2246 = int(_2245);
                                            float _2247 = float(_2246);
                                            float _2248 = _2245 - _2247;
                                            float _2249 = _2248 * _2248;
                                            float _2250 = _2249 * _2248;
                                            bool _2251 = (_2246 == 3);
                                            if (_2251)
                                            {
                                                float _2253 = _2250 * 0.1666666716337204f;
                                                float _2254 = _2249 * 0.5f;
                                                float _2255 = _2248 * 0.5f;
                                                float _2256 = 0.1666666716337204f - _2255;
                                                float _2257 = _2256 + _2254;
                                                float _2258 = _2257 - _2253;
                                                _2278 = _2258;
                                            }
                                            else
                                            {
                                                bool _2260 = (_2246 == 2);
                                                if (_2260)
                                                {
                                                    float _2262 = _2250 * 0.5f;
                                                    float _2263 = 0.6666666865348816f - _2249;
                                                    float _2264 = _2263 + _2262;
                                                    _2278 = _2264;
                                                }
                                                else
                                                {
                                                    bool _2266 = (_2246 == 1);
                                                    if (_2266)
                                                    {
                                                        float _2268 = _2250 * -0.5f;
                                                        float _2269 = _2249 + _2248;
                                                        float _2270 = _2269 * 0.5f;
                                                        float _2271 = _2268 + 0.1666666716337204f;
                                                        float _2272 = _2271 + _2270;
                                                        _2278 = _2272;
                                                    }
                                                    else
                                                    {
                                                        bool _2274 = (_2246 == 0);
                                                        float _2275 = _2250 * 0.1666666716337204f;
                                                        float _2276 = _2274 ? _2275 : 0.0f;
                                                        _2278 = _2276;
                                                    }
                                                }
                                            }
                                        }
                                        float _2279 = 0.029999999329447746f - _2194;
                                        float _2280 = _2152 * 0.27000001072883606f;
                                        float _2281 = _2280 * _2279;
                                        float _2282 = _2281 * _2278;
                                        float _2283 = _2282 + _2194;
                                        float _2284 = max(_2283, 0.0f);
                                        float _2285 = max(_2195, 0.0f);
                                        float _2286 = max(_2196, 0.0f);
                                        float _2287 = min(_2284, 65535.0f);
                                        float _2288 = min(_2285, 65535.0f);
                                        float _2289 = min(_2286, 65535.0f);
                                        float _2290 = _2287 * 1.4514392614364624f;
                                        float _2291 = mad(-0.2365107536315918f, _2288, _2290);
                                        float _2292 = mad(-0.21492856740951538f, _2289, _2291);
                                        float _2293 = _2287 * -0.07655377686023712f;
                                        float _2294 = mad(1.17622971534729f, _2288, _2293);
                                        float _2295 = mad(-0.09967592358589172f, _2289, _2294);
                                        float _2296 = _2287 * 0.008316148072481155f;
                                        float _2297 = mad(-0.006032449658960104f, _2288, _2296);
                                        float _2298 = mad(0.9977163076400757f, _2289, _2297);
                                        float _2299 = max(_2292, 0.0f);
                                        float _2300 = max(_2295, 0.0f);
                                        float _2301 = max(_2298, 0.0f);
                                        float _2302 = min(_2299, 65504.0f);
                                        float _2303 = min(_2300, 65504.0f);
                                        float _2304 = min(_2301, 65504.0f);
                                        float _2305 = dot(float3(_2302, _2303, _2304), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                                        float _2306 = _2302 - _2305;
                                        float _2307 = _2303 - _2305;
                                        float _2308 = _2304 - _2305;
                                        float _2309 = _2306 * 0.9599999785423279f;
                                        float _2310 = _2307 * 0.9599999785423279f;
                                        float _2311 = _2308 * 0.9599999785423279f;
                                        float _2312 = _2309 + _2305;
                                        float _2313 = _2310 + _2305;
                                        float _2314 = _2311 + _2305;
                                        float _2315 = max(_2312, 1.000000013351432e-10f);
                                        float _2316 = log2(_2315);
                                        float _2317 = _2316 * 0.3010300099849701f;
                                        float _2318 = log2(_2023);
                                        float _2319 = _2318 * 0.3010300099849701f;
                                        bool _2320 = !(_2317 <= _2319);
                                        do
                                        {
                                            if (!_2320)
                                            {
                                                float _2322 = log2(_2024);
                                                float _2323 = _2322 * 0.3010300099849701f;
                                                _2388 = _2323;
                                            }
                                            else
                                            {
                                                bool _2325 = (_2317 > _2319);
                                                float _2326 = log2(_2021);
                                                float _2327 = _2326 * 0.3010300099849701f;
                                                bool _2328 = (_2317 < _2327);
                                                bool _2329 = _2325 && _2328;
                                                if (_2329)
                                                {
                                                    float _2331 = _2316 - _2318;
                                                    float _2332 = _2331 * 0.9030900001525879f;
                                                    float _2333 = _2326 - _2318;
                                                    float _2334 = _2333 * 0.3010300099849701f;
                                                    float _2335 = _2332 / _2334;
                                                    int _2336 = int(_2335);
                                                    float _2337 = float(_2336);
                                                    float _2338 = _2335 - _2337;
                                                    float _2340 = _8[_2336];
                                                    int _2341 = _2336 + 1;
                                                    float _2343 = _8[_2341];
                                                    int _2344 = _2336 + 2;
                                                    float _2346 = _8[_2344];
                                                    float _2347 = _2338 * _2338;
                                                    float _2348 = _2340 * 0.5f;
                                                    float _2349 = mad(_2343, -1.0f, _2348);
                                                    float _2350 = mad(_2346, 0.5f, _2349);
                                                    float _2351 = _2343 - _2340;
                                                    float _2352 = mad(_2343, 0.5f, _2348);
                                                    float _2353 = dot(float3(_2347, _2338, 1.0f), float3(_2350, _2351, _2352));
                                                    _2388 = _2353;
                                                }
                                                else
                                                {
                                                    bool _2355 = (_2317 >= _2327);
                                                    float _2356 = log2(_2025);
                                                    float _2357 = _2356 * 0.3010300099849701f;
                                                    bool _2358 = (_2317 < _2357);
                                                    bool _2359 = _2355 && _2358;
                                                    if (_2359)
                                                    {
                                                        float _2361 = _2316 - _2326;
                                                        float _2362 = _2361 * 0.9030900001525879f;
                                                        float _2363 = _2356 - _2326;
                                                        float _2364 = _2363 * 0.3010300099849701f;
                                                        float _2365 = _2362 / _2364;
                                                        int _2366 = int(_2365);
                                                        float _2367 = float(_2366);
                                                        float _2368 = _2365 - _2367;
                                                        float _2370 = _9[_2366];
                                                        int _2371 = _2366 + 1;
                                                        float _2373 = _9[_2371];
                                                        int _2374 = _2366 + 2;
                                                        float _2376 = _9[_2374];
                                                        float _2377 = _2368 * _2368;
                                                        float _2378 = _2370 * 0.5f;
                                                        float _2379 = mad(_2373, -1.0f, _2378);
                                                        float _2380 = mad(_2376, 0.5f, _2379);
                                                        float _2381 = _2373 - _2370;
                                                        float _2382 = mad(_2373, 0.5f, _2378);
                                                        float _2383 = dot(float3(_2377, _2368, 1.0f), float3(_2380, _2381, _2382));
                                                        _2388 = _2383;
                                                    }
                                                    else
                                                    {
                                                        float _2385 = log2(_2026);
                                                        float _2386 = _2385 * 0.3010300099849701f;
                                                        _2388 = _2386;
                                                    }
                                                }
                                            }
                                            float _2389 = _2388 * 3.321928024291992f;
                                            float _2390 = exp2(_2389);
                                            float _2391 = max(_2313, 1.000000013351432e-10f);
                                            float _2392 = log2(_2391);
                                            float _2393 = _2392 * 0.3010300099849701f;
                                            bool _2394 = !(_2393 <= _2319);
                                            do
                                            {
                                                if (!_2394)
                                                {
                                                    float _2396 = log2(_2024);
                                                    float _2397 = _2396 * 0.3010300099849701f;
                                                    _2462 = _2397;
                                                }
                                                else
                                                {
                                                    bool _2399 = (_2393 > _2319);
                                                    float _2400 = log2(_2021);
                                                    float _2401 = _2400 * 0.3010300099849701f;
                                                    bool _2402 = (_2393 < _2401);
                                                    bool _2403 = _2399 && _2402;
                                                    if (_2403)
                                                    {
                                                        float _2405 = _2392 - _2318;
                                                        float _2406 = _2405 * 0.9030900001525879f;
                                                        float _2407 = _2400 - _2318;
                                                        float _2408 = _2407 * 0.3010300099849701f;
                                                        float _2409 = _2406 / _2408;
                                                        int _2410 = int(_2409);
                                                        float _2411 = float(_2410);
                                                        float _2412 = _2409 - _2411;
                                                        float _2414 = _8[_2410];
                                                        int _2415 = _2410 + 1;
                                                        float _2417 = _8[_2415];
                                                        int _2418 = _2410 + 2;
                                                        float _2420 = _8[_2418];
                                                        float _2421 = _2412 * _2412;
                                                        float _2422 = _2414 * 0.5f;
                                                        float _2423 = mad(_2417, -1.0f, _2422);
                                                        float _2424 = mad(_2420, 0.5f, _2423);
                                                        float _2425 = _2417 - _2414;
                                                        float _2426 = mad(_2417, 0.5f, _2422);
                                                        float _2427 = dot(float3(_2421, _2412, 1.0f), float3(_2424, _2425, _2426));
                                                        _2462 = _2427;
                                                    }
                                                    else
                                                    {
                                                        bool _2429 = (_2393 >= _2401);
                                                        float _2430 = log2(_2025);
                                                        float _2431 = _2430 * 0.3010300099849701f;
                                                        bool _2432 = (_2393 < _2431);
                                                        bool _2433 = _2429 && _2432;
                                                        if (_2433)
                                                        {
                                                            float _2435 = _2392 - _2400;
                                                            float _2436 = _2435 * 0.9030900001525879f;
                                                            float _2437 = _2430 - _2400;
                                                            float _2438 = _2437 * 0.3010300099849701f;
                                                            float _2439 = _2436 / _2438;
                                                            int _2440 = int(_2439);
                                                            float _2441 = float(_2440);
                                                            float _2442 = _2439 - _2441;
                                                            float _2444 = _9[_2440];
                                                            int _2445 = _2440 + 1;
                                                            float _2447 = _9[_2445];
                                                            int _2448 = _2440 + 2;
                                                            float _2450 = _9[_2448];
                                                            float _2451 = _2442 * _2442;
                                                            float _2452 = _2444 * 0.5f;
                                                            float _2453 = mad(_2447, -1.0f, _2452);
                                                            float _2454 = mad(_2450, 0.5f, _2453);
                                                            float _2455 = _2447 - _2444;
                                                            float _2456 = mad(_2447, 0.5f, _2452);
                                                            float _2457 = dot(float3(_2451, _2442, 1.0f), float3(_2454, _2455, _2456));
                                                            _2462 = _2457;
                                                        }
                                                        else
                                                        {
                                                            float _2459 = log2(_2026);
                                                            float _2460 = _2459 * 0.3010300099849701f;
                                                            _2462 = _2460;
                                                        }
                                                    }
                                                }
                                                float _2463 = _2462 * 3.321928024291992f;
                                                float _2464 = exp2(_2463);
                                                float _2465 = max(_2314, 1.000000013351432e-10f);
                                                float _2466 = log2(_2465);
                                                float _2467 = _2466 * 0.3010300099849701f;
                                                bool _2468 = !(_2467 <= _2319);
                                                do
                                                {
                                                    if (!_2468)
                                                    {
                                                        float _2470 = log2(_2024);
                                                        float _2471 = _2470 * 0.3010300099849701f;
                                                        _2536 = _2471;
                                                    }
                                                    else
                                                    {
                                                        bool _2473 = (_2467 > _2319);
                                                        float _2474 = log2(_2021);
                                                        float _2475 = _2474 * 0.3010300099849701f;
                                                        bool _2476 = (_2467 < _2475);
                                                        bool _2477 = _2473 && _2476;
                                                        if (_2477)
                                                        {
                                                            float _2479 = _2466 - _2318;
                                                            float _2480 = _2479 * 0.9030900001525879f;
                                                            float _2481 = _2474 - _2318;
                                                            float _2482 = _2481 * 0.3010300099849701f;
                                                            float _2483 = _2480 / _2482;
                                                            int _2484 = int(_2483);
                                                            float _2485 = float(_2484);
                                                            float _2486 = _2483 - _2485;
                                                            float _2488 = _8[_2484];
                                                            int _2489 = _2484 + 1;
                                                            float _2491 = _8[_2489];
                                                            int _2492 = _2484 + 2;
                                                            float _2494 = _8[_2492];
                                                            float _2495 = _2486 * _2486;
                                                            float _2496 = _2488 * 0.5f;
                                                            float _2497 = mad(_2491, -1.0f, _2496);
                                                            float _2498 = mad(_2494, 0.5f, _2497);
                                                            float _2499 = _2491 - _2488;
                                                            float _2500 = mad(_2491, 0.5f, _2496);
                                                            float _2501 = dot(float3(_2495, _2486, 1.0f), float3(_2498, _2499, _2500));
                                                            _2536 = _2501;
                                                        }
                                                        else
                                                        {
                                                            bool _2503 = (_2467 >= _2475);
                                                            float _2504 = log2(_2025);
                                                            float _2505 = _2504 * 0.3010300099849701f;
                                                            bool _2506 = (_2467 < _2505);
                                                            bool _2507 = _2503 && _2506;
                                                            if (_2507)
                                                            {
                                                                float _2509 = _2466 - _2474;
                                                                float _2510 = _2509 * 0.9030900001525879f;
                                                                float _2511 = _2504 - _2474;
                                                                float _2512 = _2511 * 0.3010300099849701f;
                                                                float _2513 = _2510 / _2512;
                                                                int _2514 = int(_2513);
                                                                float _2515 = float(_2514);
                                                                float _2516 = _2513 - _2515;
                                                                float _2518 = _9[_2514];
                                                                int _2519 = _2514 + 1;
                                                                float _2521 = _9[_2519];
                                                                int _2522 = _2514 + 2;
                                                                float _2524 = _9[_2522];
                                                                float _2525 = _2516 * _2516;
                                                                float _2526 = _2518 * 0.5f;
                                                                float _2527 = mad(_2521, -1.0f, _2526);
                                                                float _2528 = mad(_2524, 0.5f, _2527);
                                                                float _2529 = _2521 - _2518;
                                                                float _2530 = mad(_2521, 0.5f, _2526);
                                                                float _2531 = dot(float3(_2525, _2516, 1.0f), float3(_2528, _2529, _2530));
                                                                _2536 = _2531;
                                                            }
                                                            else
                                                            {
                                                                float _2533 = log2(_2026);
                                                                float _2534 = _2533 * 0.3010300099849701f;
                                                                _2536 = _2534;
                                                            }
                                                        }
                                                    }
                                                    float _2537 = _2536 * 3.321928024291992f;
                                                    float _2538 = exp2(_2537);
                                                    float _2539 = _2390 - _2024;
                                                    float _2540 = _2026 - _2024;
                                                    float _2541 = _2539 / _2540;
                                                    float _2542 = _2464 - _2024;
                                                    float _2543 = _2542 / _2540;
                                                    float _2544 = _2538 - _2024;
                                                    float _2545 = _2544 / _2540;
                                                    float _2546 = _2541 * 0.6624541878700256f;
                                                    float _2547 = mad(0.13400420546531677f, _2543, _2546);
                                                    float _2548 = mad(0.15618768334388733f, _2545, _2547);
                                                    float _2549 = _2541 * 0.2722287178039551f;
                                                    float _2550 = mad(0.6740817427635193f, _2543, _2549);
                                                    float _2551 = mad(0.053689517080783844f, _2545, _2550);
                                                    float _2552 = _2541 * -0.005574649665504694f;
                                                    float _2553 = mad(0.00406073359772563f, _2543, _2552);
                                                    float _2554 = mad(1.0103391408920288f, _2545, _2553);
                                                    float _2555 = _2548 * 1.6410233974456787f;
                                                    float _2556 = mad(-0.32480329275131226f, _2551, _2555);
                                                    float _2557 = mad(-0.23642469942569733f, _2554, _2556);
                                                    float _2558 = _2548 * -0.663662850856781f;
                                                    float _2559 = mad(1.6153316497802734f, _2551, _2558);
                                                    float _2560 = mad(0.016756348311901093f, _2554, _2559);
                                                    float _2561 = _2548 * 0.011721894145011902f;
                                                    float _2562 = mad(-0.008284442126750946f, _2551, _2561);
                                                    float _2563 = mad(0.9883948564529419f, _2554, _2562);
                                                    float _2564 = max(_2557, 0.0f);
                                                    float _2565 = max(_2560, 0.0f);
                                                    float _2566 = max(_2563, 0.0f);
                                                    float _2567 = min(_2564, 1.0f);
                                                    float _2568 = min(_2565, 1.0f);
                                                    float _2569 = min(_2566, 1.0f);
                                                    float _2570 = _2567 * 0.6624541878700256f;
                                                    float _2571 = mad(0.13400420546531677f, _2568, _2570);
                                                    float _2572 = mad(0.15618768334388733f, _2569, _2571);
                                                    float _2573 = _2567 * 0.2722287178039551f;
                                                    float _2574 = mad(0.6740817427635193f, _2568, _2573);
                                                    float _2575 = mad(0.053689517080783844f, _2569, _2574);
                                                    float _2576 = _2567 * -0.005574649665504694f;
                                                    float _2577 = mad(0.00406073359772563f, _2568, _2576);
                                                    float _2578 = mad(1.0103391408920288f, _2569, _2577);
                                                    float _2579 = _2572 * 1.6410233974456787f;
                                                    float _2580 = mad(-0.32480329275131226f, _2575, _2579);
                                                    float _2581 = mad(-0.23642469942569733f, _2578, _2580);
                                                    float _2582 = _2572 * -0.663662850856781f;
                                                    float _2583 = mad(1.6153316497802734f, _2575, _2582);
                                                    float _2584 = mad(0.016756348311901093f, _2578, _2583);
                                                    float _2585 = _2572 * 0.011721894145011902f;
                                                    float _2586 = mad(-0.008284442126750946f, _2575, _2585);
                                                    float _2587 = mad(0.9883948564529419f, _2578, _2586);
                                                    float _2588 = max(_2581, 0.0f);
                                                    float _2589 = max(_2584, 0.0f);
                                                    float _2590 = max(_2587, 0.0f);
                                                    float _2591 = min(_2588, 65535.0f);
                                                    float _2592 = min(_2589, 65535.0f);
                                                    float _2593 = min(_2590, 65535.0f);
                                                    float _2594 = _2591 * _2026;
                                                    float _2595 = _2592 * _2026;
                                                    float _2596 = _2593 * _2026;
                                                    float _2597 = max(_2594, 0.0f);
                                                    float _2598 = max(_2595, 0.0f);
                                                    float _2599 = max(_2596, 0.0f);
                                                    float _2600 = min(_2597, 65535.0f);
                                                    float _2601 = min(_2598, 65535.0f);
                                                    float _2602 = min(_2599, 65535.0f);
                                                    _2614 = _2600;
                                                    _2615 = _2601;
                                                    _2616 = _2602;
                                                    do
                                                    {
                                                        if (!_1999)
                                                        {
                                                            float _2604 = _2600 * _37;
                                                            float _2605 = mad(_38, _2601, _2604);
                                                            float _2606 = mad(_39, _2602, _2605);
                                                            float _2607 = _2600 * _40;
                                                            float _2608 = mad(_41, _2601, _2607);
                                                            float _2609 = mad(_42, _2602, _2608);
                                                            float _2610 = _2600 * _43;
                                                            float _2611 = mad(_44, _2601, _2610);
                                                            float _2612 = mad(_45, _2602, _2611);
                                                            _2614 = _2606;
                                                            _2615 = _2609;
                                                            _2616 = _2612;
                                                        }
                                                        float _2617 = _2614 * 9.999999747378752e-05f;
                                                        float _2618 = _2615 * 9.999999747378752e-05f;
                                                        float _2619 = _2616 * 9.999999747378752e-05f;
                                                        float _2620 = log2(_2617);
                                                        float _2621 = log2(_2618);
                                                        float _2622 = log2(_2619);
                                                        float _2623 = _2620 * 0.1593017578125f;
                                                        float _2624 = _2621 * 0.1593017578125f;
                                                        float _2625 = _2622 * 0.1593017578125f;
                                                        float _2626 = exp2(_2623);
                                                        float _2627 = exp2(_2624);
                                                        float _2628 = exp2(_2625);
                                                        float _2629 = _2626 * 18.8515625f;
                                                        float _2630 = _2627 * 18.8515625f;
                                                        float _2631 = _2628 * 18.8515625f;
                                                        float _2632 = _2629 + 0.8359375f;
                                                        float _2633 = _2630 + 0.8359375f;
                                                        float _2634 = _2631 + 0.8359375f;
                                                        float _2635 = _2626 * 18.6875f;
                                                        float _2636 = _2627 * 18.6875f;
                                                        float _2637 = _2628 * 18.6875f;
                                                        float _2638 = _2635 + 1.0f;
                                                        float _2639 = _2636 + 1.0f;
                                                        float _2640 = _2637 + 1.0f;
                                                        float _2641 = 1.0f / _2638;
                                                        float _2642 = 1.0f / _2639;
                                                        float _2643 = 1.0f / _2640;
                                                        float _2644 = _2641 * _2632;
                                                        float _2645 = _2642 * _2633;
                                                        float _2646 = _2643 * _2634;
                                                        float _2647 = log2(_2644);
                                                        float _2648 = log2(_2645);
                                                        float _2649 = log2(_2646);
                                                        float _2650 = _2647 * 78.84375f;
                                                        float _2651 = _2648 * 78.84375f;
                                                        float _2652 = _2649 * 78.84375f;
                                                        float _2653 = exp2(_2650);
                                                        float _2654 = exp2(_2651);
                                                        float _2655 = exp2(_2652);
                                                        _2769 = _2653;
                                                        _2770 = _2654;
                                                        _2771 = _2655;
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
                    bool _2657 = (_1258 == 7);
                    if (_2657)
                    {
                        float _2659 = _1215 * 0.613191545009613f;
                        float _2660 = mad(0.3395121395587921f, _1218, _2659);
                        float _2661 = mad(0.04736635088920593f, _1221, _2660);
                        float _2662 = _1215 * 0.07020691782236099f;
                        float _2663 = mad(0.9163357615470886f, _1218, _2662);
                        float _2664 = mad(0.01345000695437193f, _1221, _2663);
                        float _2665 = _1215 * 0.020618872717022896f;
                        float _2666 = mad(0.1095672994852066f, _1218, _2665);
                        float _2667 = mad(0.8696067929267883f, _1221, _2666);
                        float _2668 = _2661 * _37;
                        float _2669 = mad(_38, _2664, _2668);
                        float _2670 = mad(_39, _2667, _2669);
                        float _2671 = _2661 * _40;
                        float _2672 = mad(_41, _2664, _2671);
                        float _2673 = mad(_42, _2667, _2672);
                        float _2674 = _2661 * _43;
                        float _2675 = mad(_44, _2664, _2674);
                        float _2676 = mad(_45, _2667, _2675);
                        float _2677 = _2670 * 9.999999747378752e-05f;
                        float _2678 = _2673 * 9.999999747378752e-05f;
                        float _2679 = _2676 * 9.999999747378752e-05f;
                        float _2680 = log2(_2677);
                        float _2681 = log2(_2678);
                        float _2682 = log2(_2679);
                        float _2683 = _2680 * 0.1593017578125f;
                        float _2684 = _2681 * 0.1593017578125f;
                        float _2685 = _2682 * 0.1593017578125f;
                        float _2686 = exp2(_2683);
                        float _2687 = exp2(_2684);
                        float _2688 = exp2(_2685);
                        float _2689 = _2686 * 18.8515625f;
                        float _2690 = _2687 * 18.8515625f;
                        float _2691 = _2688 * 18.8515625f;
                        float _2692 = _2689 + 0.8359375f;
                        float _2693 = _2690 + 0.8359375f;
                        float _2694 = _2691 + 0.8359375f;
                        float _2695 = _2686 * 18.6875f;
                        float _2696 = _2687 * 18.6875f;
                        float _2697 = _2688 * 18.6875f;
                        float _2698 = _2695 + 1.0f;
                        float _2699 = _2696 + 1.0f;
                        float _2700 = _2697 + 1.0f;
                        float _2701 = 1.0f / _2698;
                        float _2702 = 1.0f / _2699;
                        float _2703 = 1.0f / _2700;
                        float _2704 = _2701 * _2692;
                        float _2705 = _2702 * _2693;
                        float _2706 = _2703 * _2694;
                        float _2707 = log2(_2704);
                        float _2708 = log2(_2705);
                        float _2709 = log2(_2706);
                        float _2710 = _2707 * 78.84375f;
                        float _2711 = _2708 * 78.84375f;
                        float _2712 = _2709 * 78.84375f;
                        float _2713 = exp2(_2710);
                        float _2714 = exp2(_2711);
                        float _2715 = exp2(_2712);
                        _2769 = _2713;
                        _2770 = _2714;
                        _2771 = _2715;
                    }
                    else
                    {
                        bool _2717 = (_1258 == 8);
                        _2769 = _1215;
                        _2770 = _1218;
                        _2771 = _1221;
                        if (!_2717)
                        {
                            bool _2719 = (_1258 == 9);
                            if (_2719)
                            {
                                float _2721 = _1240 * 0.613191545009613f;
                                float _2722 = mad(0.3395121395587921f, _1241, _2721);
                                float _2723 = mad(0.04736635088920593f, _1242, _2722);
                                float _2724 = _1240 * 0.07020691782236099f;
                                float _2725 = mad(0.9163357615470886f, _1241, _2724);
                                float _2726 = mad(0.01345000695437193f, _1242, _2725);
                                float _2727 = _1240 * 0.020618872717022896f;
                                float _2728 = mad(0.1095672994852066f, _1241, _2727);
                                float _2729 = mad(0.8696067929267883f, _1242, _2728);
                                float _2730 = _2723 * _37;
                                float _2731 = mad(_38, _2726, _2730);
                                float _2732 = mad(_39, _2729, _2731);
                                float _2733 = _2723 * _40;
                                float _2734 = mad(_41, _2726, _2733);
                                float _2735 = mad(_42, _2729, _2734);
                                float _2736 = _2723 * _43;
                                float _2737 = mad(_44, _2726, _2736);
                                float _2738 = mad(_45, _2729, _2737);
                                _2769 = _2732;
                                _2770 = _2735;
                                _2771 = _2738;
                            }
                            else
                            {
                                float _2740 = _1254 * 0.613191545009613f;
                                float _2741 = mad(0.3395121395587921f, _1255, _2740);
                                float _2742 = mad(0.04736635088920593f, _1256, _2741);
                                float _2743 = _1254 * 0.07020691782236099f;
                                float _2744 = mad(0.9163357615470886f, _1255, _2743);
                                float _2745 = mad(0.01345000695437193f, _1256, _2744);
                                float _2746 = _1254 * 0.020618872717022896f;
                                float _2747 = mad(0.1095672994852066f, _1255, _2746);
                                float _2748 = mad(0.8696067929267883f, _1256, _2747);
                                float _2749 = _2742 * _37;
                                float _2750 = mad(_38, _2745, _2749);
                                float _2751 = mad(_39, _2748, _2750);
                                float _2752 = _2742 * _40;
                                float _2753 = mad(_41, _2745, _2752);
                                float _2754 = mad(_42, _2748, _2753);
                                float _2755 = _2742 * _43;
                                float _2756 = mad(_44, _2745, _2755);
                                float _2757 = mad(_45, _2748, _2756);
                                float _2758 = cb0_39z;
                                float _2759 = log2(_2751);
                                float _2760 = log2(_2754);
                                float _2761 = log2(_2757);
                                float _2762 = _2759 * _2758;
                                float _2763 = _2760 * _2758;
                                float _2764 = _2761 * _2758;
                                float _2765 = exp2(_2762);
                                float _2766 = exp2(_2763);
                                float _2767 = exp2(_2764);
                                _2769 = _2765;
                                _2770 = _2766;
                                _2771 = _2767;
                            }
                        }
                    }
                }
            }
        }
    }
    float _2772 = _2769 * 0.9523810148239136f;
    float _2773 = _2770 * 0.9523810148239136f;
    float _2774 = _2771 * 0.9523810148239136f;
    SV_Target.x = _2772;
    SV_Target.y = _2773;
    SV_Target.z = _2774;
    SV_Target.w = 0.0f;
  
    return SV_Target;
}
