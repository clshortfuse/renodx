#include "./shared.h"

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0)
{
    float cb0_005x : packoffset(c005.x);
    float cb0_005y : packoffset(c005.y);
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
    float cb0_038x : packoffset(c038.x);
    float cb0_038y : packoffset(c038.y);
    float cb0_038z : packoffset(c038.z);
    float cb0_039y : packoffset(c039.y);
    float cb0_039z : packoffset(c039.z);
    uint cb0_039w : packoffset(c039.w);
    uint cb0_040x : packoffset(c040.x);
};

SamplerState s0 : register(s0);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target
{
    float4 SV_Target;
  // texture _1 = t0;
  // SamplerState _2 = s0;
  // cbuffer _3 = cb0;
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
    uint _19 = cb0_040x;
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
    float _596;
    float _632;
    float _643;
    float _707;
    float _886;
    float _897;
    float _908;
    float _1044;
    float _1055;
    float _1206;
    float _1221;
    float _1236;
    float _1244;
    float _1245;
    float _1246;
    float _1307;
    float _1343;
    float _1354;
    float _1393;
    float _1503;
    float _1577;
    float _1651;
    float _1729;
    float _1730;
    float _1731;
    float _1864;
    float _1879;
    float _1894;
    float _1902;
    float _1903;
    float _1904;
    float _1965;
    float _2001;
    float _2012;
    float _2051;
    float _2161;
    float _2235;
    float _2309;
    float _2387;
    float _2388;
    float _2389;
    float _2542;
    float _2543;
    float _2544;
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
    uint _47 = cb0_039w;
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
    float _106 = _103 * 0.613191545009613f;
    float _107 = mad(0.3395121395587921f, _104, _106);
    float _108 = mad(0.04736635088920593f, _105, _107);
    float _109 = _103 * 0.07020691782236099f;
    float _110 = mad(0.9163357615470886f, _104, _109);
    float _111 = mad(0.01345000695437193f, _105, _110);
    float _112 = _103 * 0.020618872717022896f;
    float _113 = mad(0.1095672994852066f, _104, _112);
    float _114 = mad(0.8696067929267883f, _105, _113);
    float _115 = dot(float3(_108, _111, _114), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    float _116 = _108 / _115;
    float _117 = _111 / _115;
    float _118 = _114 / _115;
    float _119 = _116 + -1.0f;
    float _120 = _117 + -1.0f;
    float _121 = _118 + -1.0f;
    float _122 = dot(float3(_119, _120, _121), float3(_119, _120, _121));
    float _123 = _122 * -4.0f;
    float _124 = exp2(_123);
    float _125 = 1.0f - _124;
    float _127 = cb0_035z;
    float _128 = _115 * _115;
    float _129 = _128 * -4.0f;
    float _130 = _129 * _127;
    float _131 = exp2(_130);
    float _132 = 1.0f - _131;
    float _133 = _132 * _125;
    float _134 = _108 * 1.370412826538086f;
    float _135 = mad(-0.32929131388664246f, _111, _134);
    float _136 = mad(-0.06368283927440643f, _114, _135);
    float _137 = _108 * -0.08343426138162613f;
    float _138 = mad(1.0970908403396606f, _111, _137);
    float _139 = mad(-0.010861567221581936f, _114, _138);
    float _140 = _108 * -0.02579325996339321f;
    float _141 = mad(-0.09862564504146576f, _111, _140);
    float _142 = mad(1.203694462776184f, _114, _141);
    float _143 = _136 - _108;
    float _144 = _139 - _111;
    float _145 = _142 - _114;
    float _146 = _143 * _133;
    float _147 = _144 * _133;
    float _148 = _145 * _133;
    float _149 = _146 + _108;
    float _150 = _147 + _111;
    float _151 = _148 + _114;
    float _152 = dot(float3(_149, _150, _151), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    float _154 = cb0_023x;
    float _155 = cb0_023y;
    float _156 = cb0_023z;
    float _157 = cb0_023w;
    float _159 = cb0_018x;
    float _160 = cb0_018y;
    float _161 = cb0_018z;
    float _162 = cb0_018w;
    float _163 = _159 + _154;
    float _164 = _160 + _155;
    float _165 = _161 + _156;
    float _166 = _162 + _157;
    float _168 = cb0_022x;
    float _169 = cb0_022y;
    float _170 = cb0_022z;
    float _171 = cb0_022w;
    float _173 = cb0_017x;
    float _174 = cb0_017y;
    float _175 = cb0_017z;
    float _176 = cb0_017w;
    float _177 = _173 * _168;
    float _178 = _174 * _169;
    float _179 = _175 * _170;
    float _180 = _176 * _171;
    float _182 = cb0_021x;
    float _183 = cb0_021y;
    float _184 = cb0_021z;
    float _185 = cb0_021w;
    float _187 = cb0_016x;
    float _188 = cb0_016y;
    float _189 = cb0_016z;
    float _190 = cb0_016w;
    float _191 = _187 * _182;
    float _192 = _188 * _183;
    float _193 = _189 * _184;
    float _194 = _190 * _185;
    float _196 = cb0_020x;
    float _197 = cb0_020y;
    float _198 = cb0_020z;
    float _199 = cb0_020w;
    float _201 = cb0_015x;
    float _202 = cb0_015y;
    float _203 = cb0_015z;
    float _204 = cb0_015w;
    float _205 = _201 * _196;
    float _206 = _202 * _197;
    float _207 = _203 * _198;
    float _208 = _204 * _199;
    float _210 = cb0_019x;
    float _211 = cb0_019y;
    float _212 = cb0_019z;
    float _213 = cb0_019w;
    float _215 = cb0_014x;
    float _216 = cb0_014y;
    float _217 = cb0_014z;
    float _218 = cb0_014w;
    float _219 = _215 * _210;
    float _220 = _216 * _211;
    float _221 = _217 * _212;
    float _222 = _218 * _213;
    float _223 = _219 * _222;
    float _224 = _220 * _222;
    float _225 = _221 * _222;
    float _226 = _149 - _152;
    float _227 = _150 - _152;
    float _228 = _151 - _152;
    float _229 = _223 * _226;
    float _230 = _224 * _227;
    float _231 = _225 * _228;
    float _232 = _229 + _152;
    float _233 = _230 + _152;
    float _234 = _231 + _152;
    float _235 = max(0.0f, _232);
    float _236 = max(0.0f, _233);
    float _237 = max(0.0f, _234);
    float _238 = _205 * _208;
    float _239 = _206 * _208;
    float _240 = _207 * _208;
    float _241 = _235 * 5.55555534362793f;
    float _242 = _236 * 5.55555534362793f;
    float _243 = _237 * 5.55555534362793f;
    float _244 = log2(_241);
    float _245 = log2(_242);
    float _246 = log2(_243);
    float _247 = _238 * _244;
    float _248 = _239 * _245;
    float _249 = _240 * _246;
    float _250 = exp2(_247);
    float _251 = exp2(_248);
    float _252 = exp2(_249);
    float _253 = _250 * 0.18000000715255737f;
    float _254 = _251 * 0.18000000715255737f;
    float _255 = _252 * 0.18000000715255737f;
    float _256 = _191 * _194;
    float _257 = _192 * _194;
    float _258 = _193 * _194;
    float _259 = 1.0f / _256;
    float _260 = 1.0f / _257;
    float _261 = 1.0f / _258;
    float _262 = log2(_253);
    float _263 = log2(_254);
    float _264 = log2(_255);
    float _265 = _262 * _259;
    float _266 = _263 * _260;
    float _267 = _264 * _261;
    float _268 = exp2(_265);
    float _269 = exp2(_266);
    float _270 = exp2(_267);
    float _271 = _177 * _180;
    float _272 = _178 * _180;
    float _273 = _179 * _180;
    float _274 = _271 * _268;
    float _275 = _272 * _269;
    float _276 = _273 * _270;
    float _277 = _163 + _166;
    float _278 = _164 + _166;
    float _279 = _165 + _166;
    float _280 = _277 + _274;
    float _281 = _278 + _275;
    float _282 = _279 + _276;
    float _284 = cb0_034z;
    float _285 = _152 / _284;
    float _286 = saturate(_285);
    float _287 = _286 * 2.0f;
    float _288 = 3.0f - _287;
    float _289 = _286 * _286;
    float _290 = _289 * _288;
    float _291 = 1.0f - _290;
    float _293 = cb0_033x;
    float _294 = cb0_033y;
    float _295 = cb0_033z;
    float _296 = cb0_033w;
    float _297 = _159 + _293;
    float _298 = _160 + _294;
    float _299 = _161 + _295;
    float _300 = _162 + _296;
    float _302 = cb0_032x;
    float _303 = cb0_032y;
    float _304 = cb0_032z;
    float _305 = cb0_032w;
    float _306 = _173 * _302;
    float _307 = _174 * _303;
    float _308 = _175 * _304;
    float _309 = _176 * _305;
    float _311 = cb0_031x;
    float _312 = cb0_031y;
    float _313 = cb0_031z;
    float _314 = cb0_031w;
    float _315 = _187 * _311;
    float _316 = _188 * _312;
    float _317 = _189 * _313;
    float _318 = _190 * _314;
    float _320 = cb0_030x;
    float _321 = cb0_030y;
    float _322 = cb0_030z;
    float _323 = cb0_030w;
    float _324 = _201 * _320;
    float _325 = _202 * _321;
    float _326 = _203 * _322;
    float _327 = _204 * _323;
    float _329 = cb0_029x;
    float _330 = cb0_029y;
    float _331 = cb0_029z;
    float _332 = cb0_029w;
    float _333 = _215 * _329;
    float _334 = _216 * _330;
    float _335 = _217 * _331;
    float _336 = _218 * _332;
    float _337 = _333 * _336;
    float _338 = _334 * _336;
    float _339 = _335 * _336;
    float _340 = _337 * _226;
    float _341 = _338 * _227;
    float _342 = _339 * _228;
    float _343 = _340 + _152;
    float _344 = _341 + _152;
    float _345 = _342 + _152;
    float _346 = max(0.0f, _343);
    float _347 = max(0.0f, _344);
    float _348 = max(0.0f, _345);
    float _349 = _324 * _327;
    float _350 = _325 * _327;
    float _351 = _326 * _327;
    float _352 = _346 * 5.55555534362793f;
    float _353 = _347 * 5.55555534362793f;
    float _354 = _348 * 5.55555534362793f;
    float _355 = log2(_352);
    float _356 = log2(_353);
    float _357 = log2(_354);
    float _358 = _349 * _355;
    float _359 = _350 * _356;
    float _360 = _351 * _357;
    float _361 = exp2(_358);
    float _362 = exp2(_359);
    float _363 = exp2(_360);
    float _364 = _361 * 0.18000000715255737f;
    float _365 = _362 * 0.18000000715255737f;
    float _366 = _363 * 0.18000000715255737f;
    float _367 = _315 * _318;
    float _368 = _316 * _318;
    float _369 = _317 * _318;
    float _370 = 1.0f / _367;
    float _371 = 1.0f / _368;
    float _372 = 1.0f / _369;
    float _373 = log2(_364);
    float _374 = log2(_365);
    float _375 = log2(_366);
    float _376 = _373 * _370;
    float _377 = _374 * _371;
    float _378 = _375 * _372;
    float _379 = exp2(_376);
    float _380 = exp2(_377);
    float _381 = exp2(_378);
    float _382 = _306 * _309;
    float _383 = _307 * _309;
    float _384 = _308 * _309;
    float _385 = _382 * _379;
    float _386 = _383 * _380;
    float _387 = _384 * _381;
    float _388 = _297 + _300;
    float _389 = _298 + _300;
    float _390 = _299 + _300;
    float _391 = _388 + _385;
    float _392 = _389 + _386;
    float _393 = _390 + _387;
    float _394 = cb0_035x;
    float _395 = cb0_034w;
    float _396 = _394 - _395;
    float _397 = _152 - _395;
    float _398 = _397 / _396;
    float _399 = saturate(_398);
    float _400 = _399 * 2.0f;
    float _401 = 3.0f - _400;
    float _402 = _399 * _399;
    float _403 = _402 * _401;
    float _405 = cb0_028x;
    float _406 = cb0_028y;
    float _407 = cb0_028z;
    float _408 = cb0_028w;
    float _409 = _159 + _405;
    float _410 = _160 + _406;
    float _411 = _161 + _407;
    float _412 = _162 + _408;
    float _414 = cb0_027x;
    float _415 = cb0_027y;
    float _416 = cb0_027z;
    float _417 = cb0_027w;
    float _418 = _173 * _414;
    float _419 = _174 * _415;
    float _420 = _175 * _416;
    float _421 = _176 * _417;
    float _423 = cb0_026x;
    float _424 = cb0_026y;
    float _425 = cb0_026z;
    float _426 = cb0_026w;
    float _427 = _187 * _423;
    float _428 = _188 * _424;
    float _429 = _189 * _425;
    float _430 = _190 * _426;
    float _432 = cb0_025x;
    float _433 = cb0_025y;
    float _434 = cb0_025z;
    float _435 = cb0_025w;
    float _436 = _201 * _432;
    float _437 = _202 * _433;
    float _438 = _203 * _434;
    float _439 = _204 * _435;
    float _441 = cb0_024x;
    float _442 = cb0_024y;
    float _443 = cb0_024z;
    float _444 = cb0_024w;
    float _445 = _215 * _441;
    float _446 = _216 * _442;
    float _447 = _217 * _443;
    float _448 = _218 * _444;
    float _449 = _445 * _448;
    float _450 = _446 * _448;
    float _451 = _447 * _448;
    float _452 = _449 * _226;
    float _453 = _450 * _227;
    float _454 = _451 * _228;
    float _455 = _452 + _152;
    float _456 = _453 + _152;
    float _457 = _454 + _152;
    float _458 = max(0.0f, _455);
    float _459 = max(0.0f, _456);
    float _460 = max(0.0f, _457);
    float _461 = _436 * _439;
    float _462 = _437 * _439;
    float _463 = _438 * _439;
    float _464 = _458 * 5.55555534362793f;
    float _465 = _459 * 5.55555534362793f;
    float _466 = _460 * 5.55555534362793f;
    float _467 = log2(_464);
    float _468 = log2(_465);
    float _469 = log2(_466);
    float _470 = _461 * _467;
    float _471 = _462 * _468;
    float _472 = _463 * _469;
    float _473 = exp2(_470);
    float _474 = exp2(_471);
    float _475 = exp2(_472);
    float _476 = _473 * 0.18000000715255737f;
    float _477 = _474 * 0.18000000715255737f;
    float _478 = _475 * 0.18000000715255737f;
    float _479 = _427 * _430;
    float _480 = _428 * _430;
    float _481 = _429 * _430;
    float _482 = 1.0f / _479;
    float _483 = 1.0f / _480;
    float _484 = 1.0f / _481;
    float _485 = log2(_476);
    float _486 = log2(_477);
    float _487 = log2(_478);
    float _488 = _485 * _482;
    float _489 = _486 * _483;
    float _490 = _487 * _484;
    float _491 = exp2(_488);
    float _492 = exp2(_489);
    float _493 = exp2(_490);
    float _494 = _418 * _421;
    float _495 = _419 * _421;
    float _496 = _420 * _421;
    float _497 = _494 * _491;
    float _498 = _495 * _492;
    float _499 = _496 * _493;
    float _500 = _409 + _412;
    float _501 = _410 + _412;
    float _502 = _411 + _412;
    float _503 = _500 + _497;
    float _504 = _501 + _498;
    float _505 = _502 + _499;
    float _506 = _290 - _403;
    float _507 = _291 * _280;
    float _508 = _291 * _281;
    float _509 = _291 * _282;
    float _510 = _503 * _506;
    float _511 = _504 * _506;
    float _512 = _505 * _506;
    float _513 = _403 * _391;
    float _514 = _403 * _392;
    float _515 = _403 * _393;
    float _516 = _513 + _507;
    float _517 = _516 + _510;
    float _518 = _514 + _508;
    float _519 = _518 + _511;
    float _520 = _515 + _509;
    float _521 = _520 + _512;
    float _522 = cb0_035y; // BlueCorrect
    float _523 = _517 * 0.9386394023895264f;
    float _524 = mad(-4.540197551250458e-09f, _519, _523);
    float _525 = mad(0.061360642313957214f, _521, _524);
    float _526 = _517 * 6.775371730327606e-08f;
    float _527 = mad(0.8307942152023315f, _519, _526);
    float _528 = mad(0.169205904006958f, _521, _527);
    float _529 = _517 * -9.313225746154785e-10f;
    float _530 = mad(-2.3283064365386963e-10f, _519, _529);
    float _531 = _525 - _517;
    float _532 = _528 - _519;
    float _533 = _531 * _522;
    float _534 = _532 * _522;
    float _535 = _530 * _522;
    float _536 = _533 + _517;
    float _537 = _534 + _519;
    float _538 = _535 + _521;

    float3 ap1_graded_color = float3(_536, _537, _538);
  // Finished grading in AP1

  // start of FilmToneMap

  // Start (ACES::RRT)

  // AP1 => AP0
    float _539 = _536 * 0.6954522132873535f;
    float _540 = mad(0.14067868888378143f, _537, _539);
    float _541 = mad(0.16386905312538147f, _538, _540);
    float _542 = _536 * 0.044794581830501556f;
    float _543 = mad(0.8596711158752441f, _537, _542);
    float _544 = mad(0.0955343246459961f, _538, _543);
    float _545 = _536 * -0.005525882821530104f;
    float _546 = mad(0.004025210160762072f, _537, _545);
    float _547 = mad(1.0015007257461548f, _538, _546);
    float _548 = min(_541, _544);
    float _549 = min(_548, _547);
    float _550 = max(_541, _544);
    float _551 = max(_550, _547);
    float _552 = max(_551, 1.000000013351432e-10f);
    float _553 = max(_549, 1.000000013351432e-10f);
    float _554 = _552 - _553;
    float _555 = max(_551, 0.009999999776482582f);
    float _556 = _554 / _555;
    float _557 = _547 - _544;
    float _558 = _557 * _547;
    float _559 = _544 - _541;
    float _560 = _559 * _544;
    float _561 = _558 + _560;
    float _562 = _541 - _547;
    float _563 = _562 * _541;
    float _564 = _561 + _563;
    float _565 = sqrt(_564);
    float _566 = _565 * 1.75f;
    float _567 = _544 + _541;
    float _568 = _567 + _547;
    float _569 = _568 + _566;
    float _570 = _569 * 0.3333333432674408f;
    float _571 = _556 + -0.4000000059604645f;
    float _572 = _571 * 5.0f;
    float _573 = _571 * 2.5f;
    float _574 = abs(_573);
    float _575 = 1.0f - _574;
    float _576 = max(_575, 0.0f);
    bool _577 = (_572 > 0.0f);
    bool _578 = (_572 < 0.0f);
    int _579 = int(_577);
    int _580 = int(_578);
    int _581 = _579 - _580;
    float _582 = float(_581);
    float _583 = _576 * _576;
    float _584 = 1.0f - _583;
    float _585 = _582 * _584;
    float _586 = _585 + 1.0f;
    float _587 = _586 * 0.02500000037252903f;
    bool _588 = !(_570 <= 0.0533333346247673f);
    _596 = _587;
    if (_588)
    {
        bool _590 = !(_570 >= 0.1599999964237213f);
        _596 = 0.0f;
        if (_590)
        {
            float _592 = 0.23999999463558197f / _569;
            float _593 = _592 + -0.5f;
            float _594 = _593 * _587;
            _596 = _594;
        }
    }
    float _597 = _596 + 1.0f;
    float _598 = _597 * _541;
    float _599 = _597 * _544;
    float _600 = _597 * _547;
    bool _601 = (_598 == _599);
    bool _602 = (_599 == _600);
    bool _603 = _601 && _602;
    _632 = 0.0f;
    if (!_603)
    {
        float _605 = _598 * 2.0f;
        float _606 = _605 - _599;
        float _607 = _606 - _600;
        float _608 = _544 - _547;
        float _609 = _608 * 1.7320507764816284f;
        float _610 = _609 * _597;
        float _611 = _610 / _607;
        float _612 = atan(_611);
        float _613 = _612 + 3.1415927410125732f;
        float _614 = _612 + -3.1415927410125732f;
        bool _615 = (_607 < 0.0f);
        bool _616 = (_607 == 0.0f);
        bool _617 = (_610 >= 0.0f);
        bool _618 = (_610 < 0.0f);
        bool _619 = _617 && _615;
        float _620 = _619 ? _613 : _612;
        bool _621 = _618 && _615;
        float _622 = _621 ? _614 : _620;
        bool _623 = _618 && _616;
        bool _624 = _617 && _616;
        float _625 = _622 * 57.2957763671875f;
        float _626 = _623 ? -90.0f : _625;
        float _627 = _624 ? 90.0f : _626;
        bool _628 = (_627 < 0.0f);
        _632 = _627;
        if (_628)
        {
            float _630 = _627 + 360.0f;
            _632 = _630;
        }
    }
    float _633 = max(_632, 0.0f);
    float _634 = min(_633, 360.0f);
    bool _635 = (_634 < -180.0f);
    if (_635)
    {
        float _637 = _634 + 360.0f;
        _643 = _637;
    }
    else
    {
        bool _639 = (_634 > 180.0f);
        _643 = _634;
        if (_639)
        {
            float _641 = _634 + -360.0f;
            _643 = _641;
        }
    }
    float _644 = _643 * 0.014814814552664757f;
    float _645 = abs(_644);
    float _646 = 1.0f - _645;
    float _647 = saturate(_646);
    float _648 = _647 * 2.0f;
    float _649 = 3.0f - _648;
    float _650 = _647 * _647;
    float _651 = _650 * _649;
    float _652 = 0.029999999329447746f - _598;
    float _653 = _556 * 0.18000000715255737f;
    float _654 = _653 * _652;
    float _655 = _651 * _651;
    float _656 = _655 * _654;
    float _657 = _656 + _598;
    float _658 = _657 * 1.4514392614364624f;
    float _659 = mad(-0.2365107536315918f, _599, _658);
    float _660 = mad(-0.21492856740951538f, _600, _659);
    float _661 = _657 * -0.07655377686023712f;
    float _662 = mad(1.17622971534729f, _599, _661);
    float _663 = mad(-0.09967592358589172f, _600, _662);
    float _664 = _657 * 0.008316148072481155f;
    float _665 = mad(-0.006032449658960104f, _599, _664);
    float _666 = mad(0.9977163076400757f, _600, _665);
    float _667 = max(0.0f, _660);
    float _668 = max(0.0f, _663);
    float _669 = max(0.0f, _666);
    float _670 = dot(float3(_667, _668, _669), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    float _671 = _667 - _670;
    float _672 = _668 - _670;
    float _673 = _669 - _670;
    float _674 = _671 * 0.9599999785423279f;
    float _675 = _672 * 0.9599999785423279f;
    float _676 = _673 * 0.9599999785423279f;
    float _677 = _674 + _670;
    float _678 = _675 + _670;
    float _679 = _676 + _670;

  // End ACES::RRT

  // Custom
    float3 ap1_aces_colored = float3(_677, _678, _679);

  // Now SDR Tonemapping/Split

  // Early out with cbuffer
  // (Unreal runs the entire SDR process even if discarding)

    uint output_type = cb0_039w;

    float3 sdr_color;
    float3 hdr_color;
    float3 sdr_ap1_color;

    float _681 = cb0_036w;
    float _682 = _681 + 1.0f;
    float _683 = cb0_036y;
    float _684 = _682 - _683;
    float _686 = cb0_037x;
    float _687 = _686 + 1.0f;
    float _688 = cb0_036z;
    float _689 = _687 - _688;

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

        bool _690 = (_683 > 0.800000011920929f);
        float _691 = cb0_036x;
        if (_690)
        {
            float _693 = 0.8199999928474426f - _683;
            float _694 = _693 / _691;
            float _695 = _694 + -0.7447274923324585f;
            _707 = _695;
        }
        else
        {
            float _697 = _681 + 0.18000000715255737f;
            float _698 = _697 / _684;
            float _699 = 2.0f - _698;
            float _700 = _698 / _699;
            float _701 = log2(_700);
            float _702 = _701 * 0.3465735912322998f;
            float _703 = _684 / _691;
            float _704 = _702 * _703;
            float _705 = -0.7447274923324585f - _704;
            _707 = _705;
        }
        float _708 = 1.0f - _683;
        float _709 = _708 / _691;
        float _710 = _709 - _707;
        float _711 = _688 / _691;
        float _712 = _711 - _710;
        float _713 = log2(_677);
        float _714 = log2(_678);
        float _715 = log2(_679);
        float _716 = _713 * 0.3010300099849701f;
        float _717 = _714 * 0.3010300099849701f;
        float _718 = _715 * 0.3010300099849701f;
        float _719 = _716 + _710;
        float _720 = _717 + _710;
        float _721 = _718 + _710;
        float _722 = _691 * _719;
        float _723 = _691 * _720;
        float _724 = _691 * _721;
        float _725 = _684 * 2.0f;
        float _726 = _691 * -2.0f;
        float _727 = _726 / _684;
        float _728 = _716 - _707;
        float _729 = _717 - _707;
        float _730 = _718 - _707;
        float _731 = _728 * 1.4426950216293335f;
        float _732 = _731 * _727;
        float _733 = _729 * 1.4426950216293335f;
        float _734 = _733 * _727;
        float _735 = _730 * 1.4426950216293335f;
        float _736 = _735 * _727;
        float _737 = exp2(_732);
        float _738 = exp2(_734);
        float _739 = exp2(_736);
        float _740 = _737 + 1.0f;
        float _741 = _738 + 1.0f;
        float _742 = _739 + 1.0f;
        float _743 = _725 / _740;
        float _744 = _725 / _741;
        float _745 = _725 / _742;
        float _746 = _743 - _681;
        float _747 = _744 - _681;
        float _748 = _745 - _681;
        float _749 = _689 * 2.0f;
        float _750 = _691 * 2.0f;
        float _751 = _750 / _689;
        float _752 = _716 - _712;
        float _753 = _717 - _712;
        float _754 = _718 - _712;
        float _755 = _752 * 1.4426950216293335f;
        float _756 = _755 * _751;
        float _757 = _753 * 1.4426950216293335f;
        float _758 = _757 * _751;
        float _759 = _754 * 1.4426950216293335f;
        float _760 = _759 * _751;
        float _761 = exp2(_756);
        float _762 = exp2(_758);
        float _763 = exp2(_760);
        float _764 = _761 + 1.0f;
        float _765 = _762 + 1.0f;
        float _766 = _763 + 1.0f;
        float _767 = _749 / _764;
        float _768 = _749 / _765;
        float _769 = _749 / _766;
        float _770 = _687 - _767;
        float _771 = _687 - _768;
        float _772 = _687 - _769;
        bool _773 = (_716 < _707);
        bool _774 = (_717 < _707);
        bool _775 = (_718 < _707);
        float _776 = _773 ? _746 : _722;
        float _777 = _774 ? _747 : _723;
        float _778 = _775 ? _748 : _724;
        bool _779 = (_716 > _712);
        bool _780 = (_717 > _712);
        bool _781 = (_718 > _712);
        float _782 = _779 ? _770 : _722;
        float _783 = _780 ? _771 : _723;
        float _784 = _781 ? _772 : _724;
        float _785 = _712 - _707;
        float _786 = _728 / _785;
        float _787 = _729 / _785;
        float _788 = _730 / _785;
        float _789 = saturate(_786);
        float _790 = saturate(_787);
        float _791 = saturate(_788);
        bool _792 = (_712 < _707);
        float _793 = 1.0f - _789;
        float _794 = 1.0f - _790;
        float _795 = 1.0f - _791;
        float _796 = _792 ? _793 : _789;
        float _797 = _792 ? _794 : _790;
        float _798 = _792 ? _795 : _791;
        float _799 = _796 * 2.0f;
        float _800 = _797 * 2.0f;
        float _801 = _798 * 2.0f;
        float _802 = 3.0f - _799;
        float _803 = 3.0f - _800;
        float _804 = 3.0f - _801;
        float _805 = _782 - _776;
        float _806 = _783 - _777;
        float _807 = _784 - _778;
        float _808 = _796 * _796;
        float _809 = _808 * _805;
        float _810 = _809 * _802;
        float _811 = _797 * _797;
        float _812 = _811 * _806;
        float _813 = _812 * _803;
        float _814 = _798 * _798;
        float _815 = _814 * _807;
        float _816 = _815 * _804;
        float _817 = _810 + _776;
        float _818 = _813 + _777;
        float _819 = _816 + _778;
        float _820 = dot(float3(_817, _818, _819), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
        float _821 = _817 - _820;
        float _822 = _818 - _820;
        float _823 = _819 - _820;
        float _824 = _821 * 0.9300000071525574f;
        float _825 = _822 * 0.9300000071525574f;
        float _826 = _823 * 0.9300000071525574f;
        float _827 = _824 + _820;
        float _828 = _825 + _820;
        float _829 = _826 + _820;
        float _830 = max(0.0f, _827);
        float _831 = max(0.0f, _828);
        float _832 = max(0.0f, _829);
        sdr_ap1_color = float3(_830, _831, _832);
      // end of FilmToneMap
    }

    float _833 = cb0_035w;
    //float _834 = _830 - _536;
    //float _835 = _831 - _537;
    //float _836 = _832 - _538;
    float _834 = sdr_ap1_color.r - _536;
    float _835 = sdr_ap1_color.g - _537;
    float _836 = sdr_ap1_color.b - _538;
    float _837 = _833 * _834;
    float _838 = _833 * _835;
    float _839 = _833 * _836;
    float _840 = _837 + _536;
    float _841 = _838 + _537;
    float _842 = _839 + _538;
    float _843 = _840 * 1.065374732017517f;
    float _844 = mad(1.451815478503704e-06f, _841, _843);
    float _845 = mad(-0.06537103652954102f, _842, _844);
    float _846 = _840 * -2.57161445915699e-07f;
    float _847 = mad(1.2036634683609009f, _841, _846);
    float _848 = mad(-0.20366770029067993f, _842, _847);
    float _849 = _840 * 1.862645149230957e-08f;
    float _850 = mad(2.0954757928848267e-08f, _841, _849);
    float _851 = mad(0.9999996423721313f, _842, _850);
    float _852 = _845 - _840;
    float _853 = _848 - _841;
    float _854 = _851 - _842;
    float _855 = _852 * _522;
    float _856 = _853 * _522;
    float _857 = _854 * _522;
    float _858 = _855 + _840;
    float _859 = _856 + _841;
    float _860 = _857 + _842;
    float _861 = _858 * 1.7050515413284302f;
    float _862 = mad(-0.6217905879020691f, _859, _861);
    float _863 = mad(-0.0832584798336029f, _860, _862);
    float _864 = _858 * -0.13025718927383423f;
    float _865 = mad(1.1408027410507202f, _859, _864);
    float _866 = mad(-0.010548528283834457f, _860, _865);
    float _867 = _858 * -0.024003278464078903f;
    float _868 = mad(-0.1289687603712082f, _859, _867);
    float _869 = mad(1.152971863746643f, _860, _868);
    float _870 = max(0.0f, _863);
    float _871 = max(0.0f, _866);
    float _872 = max(0.0f, _869);

    float3 lut_input_color = float3(_870, _871, _872);

    float _976; // custom branch
    float _977; // custom branch
    float _978; // custom branch

    if (injectedData.colorGradeLUTStrength != 1.f || injectedData.colorGradeLUTScaling != 0.f)
    {
        renodx::lut::Config lut_config = renodx::lut::config::Create(
        s0,
        injectedData.colorGradeLUTStrength,
        injectedData.colorGradeLUTScaling, renodx::lut::config::type::SRGB, renodx::lut::config::type::SRGB, 16);

        float3 post_lut_color = renodx::lut::Sample(t0, lut_config, lut_input_color);
        _976 = post_lut_color.r;
        _977 = post_lut_color.g;
        _978 = post_lut_color.b;
    }
    else
    {
    // Clip color to target
        float _873 = saturate(_870);
        float _874 = saturate(_871);
        float _875 = saturate(_872);
        bool _876 = (_873 < 0.0031306699384003878f);
        if (_876)
        {
            float _878 = _873 * 12.920000076293945f;
            _886 = _878;
        }
        else
        {
            float _880 = log2(_873);
            float _881 = _880 * 0.4166666567325592f;
            float _882 = exp2(_881);
            float _883 = _882 * 1.0549999475479126f;
            float _884 = _883 + -0.054999999701976776f;
            _886 = _884;
        }
        bool _887 = (_874 < 0.0031306699384003878f);
        if (_887)
        {
            float _889 = _874 * 12.920000076293945f;
            _897 = _889;
        }
        else
        {
            float _891 = log2(_874);
            float _892 = _891 * 0.4166666567325592f;
            float _893 = exp2(_892);
            float _894 = _893 * 1.0549999475479126f;
            float _895 = _894 + -0.054999999701976776f;
            _897 = _895;
        }
        bool _898 = (_875 < 0.0031306699384003878f);
        if (_898)
        {
            float _900 = _875 * 12.920000076293945f;
            _908 = _900;
        }
        else
        {
            float _902 = log2(_875);
            float _903 = _902 * 0.4166666567325592f;
            float _904 = exp2(_903);
            float _905 = _904 * 1.0549999475479126f;
            float _906 = _905 + -0.054999999701976776f;
            _908 = _906;
        }
        float _909 = _886 * 0.9375f;
        float _910 = _897 * 0.9375f;
        float _911 = _909 + 0.03125f;
        float _912 = _910 + 0.03125f;
        float _914 = cb0_005x;
        float _915 = _914 * _886;
        float _916 = _914 * _897;
        float _917 = _914 * _908;
        float _918 = cb0_005y;
        float _919 = _908 * 15.0f;
        float _920 = floor(_919);
        float _921 = _919 - _920;
        float _922 = _911 + _920;
        float _923 = _922 * 0.0625f;
  // _924 = _1;
  // _925 = _2;
        float4 _926 = t0.Sample(s0, float2(_923, _912));
        float _927 = _926.x;
        float _928 = _926.y;
        float _929 = _926.z;
        float _930 = _923 + 0.0625f;
  // _931 = _1;
  // _932 = _2;
        float4 _933 = t0.Sample(s0, float2(_930, _912));
        float _934 = _933.x;
        float _935 = _933.y;
        float _936 = _933.z;
        float _937 = _934 - _927;
        float _938 = _935 - _928;
        float _939 = _936 - _929;
        float _940 = _937 * _921;
        float _941 = _938 * _921;
        float _942 = _939 * _921;
        float _943 = _940 + _927;
        float _944 = _941 + _928;
        float _945 = _942 + _929;
        float _946 = _943 * _918;
        float _947 = _944 * _918;
        float _948 = _945 * _918;
        float _949 = _946 + _915;
        float _950 = _947 + _916;
        float _951 = _948 + _917;
        float _952 = max(6.103519990574569e-05f, _949);
        float _953 = max(6.103519990574569e-05f, _950);
        float _954 = max(6.103519990574569e-05f, _951);
        float _955 = _952 * 0.07739938050508499f;
        float _956 = _953 * 0.07739938050508499f;
        float _957 = _954 * 0.07739938050508499f;
        float _958 = _952 * 0.9478672742843628f;
        float _959 = _953 * 0.9478672742843628f;
        float _960 = _954 * 0.9478672742843628f;
        float _961 = _958 + 0.05213269963860512f;
        float _962 = _959 + 0.05213269963860512f;
        float _963 = _960 + 0.05213269963860512f;
        float _964 = log2(_961);
        float _965 = log2(_962);
        float _966 = log2(_963);
        float _967 = _964 * 2.4000000953674316f;
        float _968 = _965 * 2.4000000953674316f;
        float _969 = _966 * 2.4000000953674316f;
        float _970 = exp2(_967);
        float _971 = exp2(_968);
        float _972 = exp2(_969);
        bool _973 = (_952 > 0.040449999272823334f);
        bool _974 = (_953 > 0.040449999272823334f);
        bool _975 = (_954 > 0.040449999272823334f);
  //float _976 = _973 ? _970 : _955;
  //float _977 = _974 ? _971 : _956;
  //float _978 = _975 ? _972 : _957;
        _976 = _973 ? _970 : _955;
        _977 = _974 ? _971 : _956;
        _978 = _975 ? _972 : _957;
    }

    float _980 = cb0_038x;
    float _981 = _980 * _976;
    float _982 = _980 * _977;
    float _983 = _980 * _978;
    float _984 = cb0_038y;
    float _985 = cb0_038z;
    float _986 = _984 + _981;
    float _987 = _986 * _976;
    float _988 = _987 + _985;
    float _989 = _984 + _982;
    float _990 = _989 * _977;
    float _991 = _990 + _985;
    float _992 = _984 + _983;
    float _993 = _992 * _978;
    float _994 = _993 + _985;
    float _996 = cb0_012w;
    float _997 = cb0_012x;
    float _998 = cb0_012y;
    float _999 = cb0_012z;
    float _1001 = cb0_013x;
    float _1002 = cb0_013y;
    float _1003 = cb0_013z;
    float _1004 = _1001 * _988;
    float _1005 = _1002 * _991;
    float _1006 = _1003 * _994;
    float _1007 = _997 - _1004;
    float _1008 = _998 - _1005;
    float _1009 = _999 - _1006;
    float _1010 = _1007 * _996;
    float _1011 = _1008 * _996;
    float _1012 = _1009 * _996;
    float _1013 = _1010 + _1004;
    float _1014 = _1011 + _1005;
    float _1015 = _1012 + _1006;
    float _1017 = cb0_039y;
    float _1018 = max(0.0f, _1013);
    float _1019 = max(0.0f, _1014);
    float _1020 = max(0.0f, _1015);
    float _1021 = log2(_1018);
    float _1022 = log2(_1019);
    float _1023 = log2(_1020);
    float _1024 = _1021 * _1017;
    float _1025 = _1022 * _1017;
    float _1026 = _1023 * _1017;
    float _1027 = exp2(_1024);
    float _1028 = exp2(_1025);
    float _1029 = exp2(_1026);

    float3 film_graded_color = float3(_1027, _1028, _1029);

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

    uint _1031 = cb0_039w;
    bool _1032 = (_1031 == 0);
    if (_1032)
    {
        bool _1034 = (_1027 < 0.0031306699384003878f);
        do
        {
            if (_1034)
            {
                float _1036 = _1027 * 12.920000076293945f;
                _1044 = _1036;
            }
            else
            {
                float _1038 = log2(_1027);
                float _1039 = _1038 * 0.4166666567325592f;
                float _1040 = exp2(_1039);
                float _1041 = _1040 * 1.0549999475479126f;
                float _1042 = _1041 + -0.054999999701976776f;
                _1044 = _1042;
            }
            bool _1045 = (_1028 < 0.0031306699384003878f);
            do
            {
                if (_1045)
                {
                    float _1047 = _1028 * 12.920000076293945f;
                    _1055 = _1047;
                }
                else
                {
                    float _1049 = log2(_1028);
                    float _1050 = _1049 * 0.4166666567325592f;
                    float _1051 = exp2(_1050);
                    float _1052 = _1051 * 1.0549999475479126f;
                    float _1053 = _1052 + -0.054999999701976776f;
                    _1055 = _1053;
                }
                bool _1056 = (_1029 < 0.0031306699384003878f);
                if (_1056)
                {
                    float _1058 = _1029 * 12.920000076293945f;
                    _2542 = _1044;
                    _2543 = _1055;
                    _2544 = _1058;
                }
                else
                {
                    float _1060 = log2(_1029);
                    float _1061 = _1060 * 0.4166666567325592f;
                    float _1062 = exp2(_1061);
                    float _1063 = _1062 * 1.0549999475479126f;
                    float _1064 = _1063 + -0.054999999701976776f;
                    _2542 = _1044;
                    _2543 = _1055;
                    _2544 = _1064;
                }
            } while (false);
        } while (false);
    }
    else
    {
        bool _1066 = (_1031 == 1);
        if (_1066)
        {
            float _1068 = _1027 * 0.613191545009613f;
            float _1069 = mad(0.3395121395587921f, _1028, _1068);
            float _1070 = mad(0.04736635088920593f, _1029, _1069);
            float _1071 = _1027 * 0.07020691782236099f;
            float _1072 = mad(0.9163357615470886f, _1028, _1071);
            float _1073 = mad(0.01345000695437193f, _1029, _1072);
            float _1074 = _1027 * 0.020618872717022896f;
            float _1075 = mad(0.1095672994852066f, _1028, _1074);
            float _1076 = mad(0.8696067929267883f, _1029, _1075);
            float _1077 = _1070 * _37;
            float _1078 = mad(_38, _1073, _1077);
            float _1079 = mad(_39, _1076, _1078);
            float _1080 = _1070 * _40;
            float _1081 = mad(_41, _1073, _1080);
            float _1082 = mad(_42, _1076, _1081);
            float _1083 = _1070 * _43;
            float _1084 = mad(_44, _1073, _1083);
            float _1085 = mad(_45, _1076, _1084);
            float _1086 = max(6.103519990574569e-05f, _1079);
            float _1087 = max(6.103519990574569e-05f, _1082);
            float _1088 = max(6.103519990574569e-05f, _1085);
            float _1089 = max(_1086, 0.017999999225139618f);
            float _1090 = max(_1087, 0.017999999225139618f);
            float _1091 = max(_1088, 0.017999999225139618f);
            float _1092 = log2(_1089);
            float _1093 = log2(_1090);
            float _1094 = log2(_1091);
            float _1095 = _1092 * 0.44999998807907104f;
            float _1096 = _1093 * 0.44999998807907104f;
            float _1097 = _1094 * 0.44999998807907104f;
            float _1098 = exp2(_1095);
            float _1099 = exp2(_1096);
            float _1100 = exp2(_1097);
            float _1101 = _1098 * 1.0989999771118164f;
            float _1102 = _1099 * 1.0989999771118164f;
            float _1103 = _1100 * 1.0989999771118164f;
            float _1104 = _1101 + -0.0989999994635582f;
            float _1105 = _1102 + -0.0989999994635582f;
            float _1106 = _1103 + -0.0989999994635582f;
            float _1107 = _1086 * 4.5f;
            float _1108 = _1087 * 4.5f;
            float _1109 = _1088 * 4.5f;
            float _1110 = min(_1107, _1104);
            float _1111 = min(_1108, _1105);
            float _1112 = min(_1109, _1106);
            _2542 = _1110;
            _2543 = _1111;
            _2544 = _1112;
        }
        else
        {
            bool _1114 = (_1031 == 3);
            bool _1115 = (_1031 == 5);
            bool _1116 = _1114 || _1115;
            if (_1116)
            {
        //   %1118 = bitcast [6 x float]* %10 to i8*
        //   %1119 = bitcast [6 x float]* %11 to i8*
                float _1121 = cb0_011w;
                float _1122 = cb0_011z;
                float _1123 = cb0_011y;
                float _1124 = cb0_011x;
                float _1126 = cb0_010x;
                float _1127 = cb0_010y;
                float _1128 = cb0_010z;
                float _1129 = cb0_010w;
                float _1131 = cb0_009x;
                float _1132 = cb0_009y;
                float _1133 = cb0_009z;
                float _1134 = cb0_009w;
                float _1136 = cb0_008x;
                float _1138 = cb0_007x;
                float _1139 = cb0_007y;
                float _1140 = cb0_007z;
                float _1141 = cb0_007w;
                _10[0] = _1131;
                _10[1] = _1132;
                _10[2] = _1133;
                _10[3] = _1134;
                _10[4] = _1124;
                _10[5] = _1124;
                _11[0] = _1126;
                _11[1] = _1127;
                _11[2] = _1128;
                _11[3] = _1129;
                _11[4] = _1123;
                _11[5] = _1123;
                float _1154 = _1122 * _988;
                float _1155 = _1122 * _991;
                float _1156 = _1122 * _994;
                float _1157 = _1154 * 0.43970081210136414f;
                float _1158 = mad(0.38297808170318604f, _1155, _1157);
                float _1159 = mad(0.17733481526374817f, _1156, _1158);
                float _1160 = _1154 * 0.08979231864213943f;
                float _1161 = mad(0.8134231567382812f, _1155, _1160);
                float _1162 = mad(0.09676162153482437f, _1156, _1161);
                float _1163 = _1154 * 0.017543988302350044f;
                float _1164 = mad(0.11154405772686005f, _1155, _1163);
                float _1165 = mad(0.870704174041748f, _1156, _1164);
                float _1166 = _1159 * 1.4514392614364624f;
                float _1167 = mad(-0.2365107536315918f, _1162, _1166);
                float _1168 = mad(-0.21492856740951538f, _1165, _1167);
                float _1169 = _1159 * -0.07655377686023712f;
                float _1170 = mad(1.17622971534729f, _1162, _1169);
                float _1171 = mad(-0.09967592358589172f, _1165, _1170);
                float _1172 = _1159 * 0.008316148072481155f;
                float _1173 = mad(-0.006032449658960104f, _1162, _1172);
                float _1174 = mad(0.9977163076400757f, _1165, _1173);
                float _1175 = max(_1171, _1174);
                float _1176 = max(_1168, _1175);
                bool _1177 = (_1176 < 1.000000013351432e-10f);
                bool _1178 = (_1159 < 0.0f);
                bool _1179 = (_1162 < 0.0f);
                bool _1180 = (_1165 < 0.0f);
                bool _1181 = _1178 || _1179;
                bool _1182 = _1181 || _1180;
                bool _1183 = _1182 || _1177;
                _1244 = _1168;
                _1245 = _1171;
                _1246 = _1174;
                do
                {
                    if (!_1183)
                    {
                        float _1185 = _1176 - _1168;
                        float _1186 = abs(_1176);
                        float _1187 = _1185 / _1186;
                        float _1188 = _1176 - _1171;
                        float _1189 = _1188 / _1186;
                        float _1190 = _1176 - _1174;
                        float _1191 = _1190 / _1186;
                        bool _1192 = (_1187 < 0.8149999976158142f);
                        _1206 = _1187;
                        do
                        {
                            if (!_1192)
                            {
                                float _1194 = _1187 + -0.8149999976158142f;
                                float _1195 = _1194 * 3.0552830696105957f;
                                float _1196 = log2(_1195);
                                float _1197 = _1196 * 1.2000000476837158f;
                                float _1198 = exp2(_1197);
                                float _1199 = _1198 + 1.0f;
                                float _1200 = log2(_1199);
                                float _1201 = _1200 * 0.8333333134651184f;
                                float _1202 = exp2(_1201);
                                float _1203 = _1194 / _1202;
                                float _1204 = _1203 + 0.8149999976158142f;
                                _1206 = _1204;
                            }
                            bool _1207 = (_1189 < 0.8029999732971191f);
                            _1221 = _1189;
                            do
                            {
                                if (!_1207)
                                {
                                    float _1209 = _1189 + -0.8029999732971191f;
                                    float _1210 = _1209 * 3.4972610473632812f;
                                    float _1211 = log2(_1210);
                                    float _1212 = _1211 * 1.2000000476837158f;
                                    float _1213 = exp2(_1212);
                                    float _1214 = _1213 + 1.0f;
                                    float _1215 = log2(_1214);
                                    float _1216 = _1215 * 0.8333333134651184f;
                                    float _1217 = exp2(_1216);
                                    float _1218 = _1209 / _1217;
                                    float _1219 = _1218 + 0.8029999732971191f;
                                    _1221 = _1219;
                                }
                                bool _1222 = (_1191 < 0.8799999952316284f);
                                _1236 = _1191;
                                do
                                {
                                    if (!_1222)
                                    {
                                        float _1224 = _1191 + -0.8799999952316284f;
                                        float _1225 = _1224 * 6.810994625091553f;
                                        float _1226 = log2(_1225);
                                        float _1227 = _1226 * 1.2000000476837158f;
                                        float _1228 = exp2(_1227);
                                        float _1229 = _1228 + 1.0f;
                                        float _1230 = log2(_1229);
                                        float _1231 = _1230 * 0.8333333134651184f;
                                        float _1232 = exp2(_1231);
                                        float _1233 = _1224 / _1232;
                                        float _1234 = _1233 + 0.8799999952316284f;
                                        _1236 = _1234;
                                    }
                                    float _1237 = _1186 * _1206;
                                    float _1238 = _1176 - _1237;
                                    float _1239 = _1186 * _1221;
                                    float _1240 = _1176 - _1239;
                                    float _1241 = _1186 * _1236;
                                    float _1242 = _1176 - _1241;
                                    _1244 = _1238;
                                    _1245 = _1240;
                                    _1246 = _1242;
                                } while (false);
                            } while (false);
                        } while (false);
                    }
                    float _1247 = _1244 * 0.6954522132873535f;
                    float _1248 = mad(0.14067870378494263f, _1245, _1247);
                    float _1249 = mad(0.16386906802654266f, _1246, _1248);
                    float _1250 = _1249 - _1159;
                    float _1251 = _1249 - _1162;
                    float _1252 = _1249 - _1165;
                    float _1253 = _1250 * _1121;
                    float _1254 = _1251 * _1121;
                    float _1255 = _1252 * _1121;
                    float _1256 = _1253 + _1159;
                    float _1257 = _1254 + _1162;
                    float _1258 = _1255 + _1165;
                    float _1259 = min(_1256, _1257);
                    float _1260 = min(_1259, _1258);
                    float _1261 = max(_1256, _1257);
                    float _1262 = max(_1261, _1258);
                    float _1263 = max(_1262, 1.000000013351432e-10f);
                    float _1264 = max(_1260, 1.000000013351432e-10f);
                    float _1265 = _1263 - _1264;
                    float _1266 = max(_1262, 0.009999999776482582f);
                    float _1267 = _1265 / _1266;
                    float _1268 = _1258 - _1257;
                    float _1269 = _1268 * _1258;
                    float _1270 = _1257 - _1256;
                    float _1271 = _1270 * _1257;
                    float _1272 = _1269 + _1271;
                    float _1273 = _1256 - _1258;
                    float _1274 = _1273 * _1256;
                    float _1275 = _1272 + _1274;
                    float _1276 = sqrt(_1275);
                    float _1277 = _1258 + _1257;
                    float _1278 = _1277 + _1256;
                    float _1279 = _1276 * 1.75f;
                    float _1280 = _1278 + _1279;
                    float _1281 = _1280 * 0.3333333432674408f;
                    float _1282 = _1267 + -0.4000000059604645f;
                    float _1283 = _1282 * 5.0f;
                    float _1284 = _1282 * 2.5f;
                    float _1285 = abs(_1284);
                    float _1286 = 1.0f - _1285;
                    float _1287 = max(_1286, 0.0f);
                    bool _1288 = (_1283 > 0.0f);
                    bool _1289 = (_1283 < 0.0f);
                    int _1290 = int(_1288);
                    int _1291 = int(_1289);
                    int _1292 = _1290 - _1291;
                    float _1293 = float(_1292);
                    float _1294 = _1287 * _1287;
                    float _1295 = 1.0f - _1294;
                    float _1296 = _1293 * _1295;
                    float _1297 = _1296 + 1.0f;
                    float _1298 = _1297 * 0.02500000037252903f;
                    bool _1299 = !(_1281 <= 0.0533333346247673f);
                    _1307 = _1298;
                    do
                    {
                        if (_1299)
                        {
                            bool _1301 = !(_1281 >= 0.1599999964237213f);
                            _1307 = 0.0f;
                            if (_1301)
                            {
                                float _1303 = 0.23999999463558197f / _1280;
                                float _1304 = _1303 + -0.5f;
                                float _1305 = _1304 * _1298;
                                _1307 = _1305;
                            }
                        }
                        float _1308 = _1307 + 1.0f;
                        float _1309 = _1308 * _1256;
                        float _1310 = _1308 * _1257;
                        float _1311 = _1308 * _1258;
                        bool _1312 = (_1309 == _1310);
                        bool _1313 = (_1310 == _1311);
                        bool _1314 = _1312 && _1313;
                        _1343 = 0.0f;
                        do
                        {
                            if (!_1314)
                            {
                                float _1316 = _1309 * 2.0f;
                                float _1317 = _1316 - _1310;
                                float _1318 = _1317 - _1311;
                                float _1319 = _1257 - _1258;
                                float _1320 = _1319 * 1.7320507764816284f;
                                float _1321 = _1320 * _1308;
                                float _1322 = _1321 / _1318;
                                float _1323 = atan(_1322);
                                float _1324 = _1323 + 3.1415927410125732f;
                                float _1325 = _1323 + -3.1415927410125732f;
                                bool _1326 = (_1318 < 0.0f);
                                bool _1327 = (_1318 == 0.0f);
                                bool _1328 = (_1321 >= 0.0f);
                                bool _1329 = (_1321 < 0.0f);
                                bool _1330 = _1328 && _1326;
                                float _1331 = _1330 ? _1324 : _1323;
                                bool _1332 = _1329 && _1326;
                                float _1333 = _1332 ? _1325 : _1331;
                                bool _1334 = _1329 && _1327;
                                bool _1335 = _1328 && _1327;
                                float _1336 = _1333 * 57.2957763671875f;
                                float _1337 = _1334 ? -90.0f : _1336;
                                float _1338 = _1335 ? 90.0f : _1337;
                                bool _1339 = (_1338 < 0.0f);
                                _1343 = _1338;
                                if (_1339)
                                {
                                    float _1341 = _1338 + 360.0f;
                                    _1343 = _1341;
                                }
                            }
                            float _1344 = max(_1343, 0.0f);
                            float _1345 = min(_1344, 360.0f);
                            bool _1346 = (_1345 < -180.0f);
                            do
                            {
                                if (_1346)
                                {
                                    float _1348 = _1345 + 360.0f;
                                    _1354 = _1348;
                                }
                                else
                                {
                                    bool _1350 = (_1345 > 180.0f);
                                    _1354 = _1345;
                                    if (_1350)
                                    {
                                        float _1352 = _1345 + -360.0f;
                                        _1354 = _1352;
                                    }
                                }
                                bool _1355 = (_1354 > -67.5f);
                                bool _1356 = (_1354 < 67.5f);
                                bool _1357 = _1355 && _1356;
                                _1393 = 0.0f;
                                do
                                {
                                    if (_1357)
                                    {
                                        float _1359 = _1354 + 67.5f;
                                        float _1360 = _1359 * 0.029629629105329514f;
                                        int _1361 = int(_1360);
                                        float _1362 = float(_1361);
                                        float _1363 = _1360 - _1362;
                                        float _1364 = _1363 * _1363;
                                        float _1365 = _1364 * _1363;
                                        bool _1366 = (_1361 == 3);
                                        if (_1366)
                                        {
                                            float _1368 = _1365 * 0.1666666716337204f;
                                            float _1369 = _1364 * 0.5f;
                                            float _1370 = _1363 * 0.5f;
                                            float _1371 = 0.1666666716337204f - _1370;
                                            float _1372 = _1371 + _1369;
                                            float _1373 = _1372 - _1368;
                                            _1393 = _1373;
                                        }
                                        else
                                        {
                                            bool _1375 = (_1361 == 2);
                                            if (_1375)
                                            {
                                                float _1377 = _1365 * 0.5f;
                                                float _1378 = 0.6666666865348816f - _1364;
                                                float _1379 = _1378 + _1377;
                                                _1393 = _1379;
                                            }
                                            else
                                            {
                                                bool _1381 = (_1361 == 1);
                                                if (_1381)
                                                {
                                                    float _1383 = _1365 * -0.5f;
                                                    float _1384 = _1364 + _1363;
                                                    float _1385 = _1384 * 0.5f;
                                                    float _1386 = _1383 + 0.1666666716337204f;
                                                    float _1387 = _1386 + _1385;
                                                    _1393 = _1387;
                                                }
                                                else
                                                {
                                                    bool _1389 = (_1361 == 0);
                                                    float _1390 = _1365 * 0.1666666716337204f;
                                                    float _1391 = _1389 ? _1390 : 0.0f;
                                                    _1393 = _1391;
                                                }
                                            }
                                        }
                                    }
                                    float _1394 = 0.029999999329447746f - _1309;
                                    float _1395 = _1267 * 0.27000001072883606f;
                                    float _1396 = _1395 * _1394;
                                    float _1397 = _1396 * _1393;
                                    float _1398 = _1397 + _1309;
                                    float _1399 = max(_1398, 0.0f);
                                    float _1400 = max(_1310, 0.0f);
                                    float _1401 = max(_1311, 0.0f);
                                    float _1402 = min(_1399, 65535.0f);
                                    float _1403 = min(_1400, 65535.0f);
                                    float _1404 = min(_1401, 65535.0f);
                                    float _1405 = _1402 * 1.4514392614364624f;
                                    float _1406 = mad(-0.2365107536315918f, _1403, _1405);
                                    float _1407 = mad(-0.21492856740951538f, _1404, _1406);
                                    float _1408 = _1402 * -0.07655377686023712f;
                                    float _1409 = mad(1.17622971534729f, _1403, _1408);
                                    float _1410 = mad(-0.09967592358589172f, _1404, _1409);
                                    float _1411 = _1402 * 0.008316148072481155f;
                                    float _1412 = mad(-0.006032449658960104f, _1403, _1411);
                                    float _1413 = mad(0.9977163076400757f, _1404, _1412);
                                    float _1414 = max(_1407, 0.0f);
                                    float _1415 = max(_1410, 0.0f);
                                    float _1416 = max(_1413, 0.0f);
                                    float _1417 = min(_1414, 65504.0f);
                                    float _1418 = min(_1415, 65504.0f);
                                    float _1419 = min(_1416, 65504.0f);
                                    float _1420 = dot(float3(_1417, _1418, _1419), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                                    float _1421 = _1417 - _1420;
                                    float _1422 = _1418 - _1420;
                                    float _1423 = _1419 - _1420;
                                    float _1424 = _1421 * 0.9599999785423279f;
                                    float _1425 = _1422 * 0.9599999785423279f;
                                    float _1426 = _1423 * 0.9599999785423279f;
                                    float _1427 = _1424 + _1420;
                                    float _1428 = _1425 + _1420;
                                    float _1429 = _1426 + _1420;
                                    float _1430 = max(_1427, 1.000000013351432e-10f);
                                    float _1431 = log2(_1430);
                                    float _1432 = _1431 * 0.3010300099849701f;
                                    float _1433 = log2(_1138);
                                    float _1434 = _1433 * 0.3010300099849701f;
                                    bool _1435 = !(_1432 <= _1434);
                                    do
                                    {
                                        if (!_1435)
                                        {
                                            float _1437 = log2(_1139);
                                            float _1438 = _1437 * 0.3010300099849701f;
                                            _1503 = _1438;
                                        }
                                        else
                                        {
                                            bool _1440 = (_1432 > _1434);
                                            float _1441 = log2(_1136);
                                            float _1442 = _1441 * 0.3010300099849701f;
                                            bool _1443 = (_1432 < _1442);
                                            bool _1444 = _1440 && _1443;
                                            if (_1444)
                                            {
                                                float _1446 = _1431 - _1433;
                                                float _1447 = _1446 * 0.9030900001525879f;
                                                float _1448 = _1441 - _1433;
                                                float _1449 = _1448 * 0.3010300099849701f;
                                                float _1450 = _1447 / _1449;
                                                int _1451 = int(_1450);
                                                float _1452 = float(_1451);
                                                float _1453 = _1450 - _1452;
                                                float _1455 = _10[_1451];
                                                int _1456 = _1451 + 1;
                                                float _1458 = _10[_1456];
                                                int _1459 = _1451 + 2;
                                                float _1461 = _10[_1459];
                                                float _1462 = _1453 * _1453;
                                                float _1463 = _1455 * 0.5f;
                                                float _1464 = mad(_1458, -1.0f, _1463);
                                                float _1465 = mad(_1461, 0.5f, _1464);
                                                float _1466 = _1458 - _1455;
                                                float _1467 = mad(_1458, 0.5f, _1463);
                                                float _1468 = dot(float3(_1462, _1453, 1.0f), float3(_1465, _1466, _1467));
                                                _1503 = _1468;
                                            }
                                            else
                                            {
                                                bool _1470 = (_1432 >= _1442);
                                                float _1471 = log2(_1140);
                                                float _1472 = _1471 * 0.3010300099849701f;
                                                bool _1473 = (_1432 < _1472);
                                                bool _1474 = _1470 && _1473;
                                                if (_1474)
                                                {
                                                    float _1476 = _1431 - _1441;
                                                    float _1477 = _1476 * 0.9030900001525879f;
                                                    float _1478 = _1471 - _1441;
                                                    float _1479 = _1478 * 0.3010300099849701f;
                                                    float _1480 = _1477 / _1479;
                                                    int _1481 = int(_1480);
                                                    float _1482 = float(_1481);
                                                    float _1483 = _1480 - _1482;
                                                    float _1485 = _11[_1481];
                                                    int _1486 = _1481 + 1;
                                                    float _1488 = _11[_1486];
                                                    int _1489 = _1481 + 2;
                                                    float _1491 = _11[_1489];
                                                    float _1492 = _1483 * _1483;
                                                    float _1493 = _1485 * 0.5f;
                                                    float _1494 = mad(_1488, -1.0f, _1493);
                                                    float _1495 = mad(_1491, 0.5f, _1494);
                                                    float _1496 = _1488 - _1485;
                                                    float _1497 = mad(_1488, 0.5f, _1493);
                                                    float _1498 = dot(float3(_1492, _1483, 1.0f), float3(_1495, _1496, _1497));
                                                    _1503 = _1498;
                                                }
                                                else
                                                {
                                                    float _1500 = log2(_1141);
                                                    float _1501 = _1500 * 0.3010300099849701f;
                                                    _1503 = _1501;
                                                }
                                            }
                                        }
                                        float _1504 = _1503 * 3.321928024291992f;
                                        float _1505 = exp2(_1504);
                                        float _1506 = max(_1428, 1.000000013351432e-10f);
                                        float _1507 = log2(_1506);
                                        float _1508 = _1507 * 0.3010300099849701f;
                                        bool _1509 = !(_1508 <= _1434);
                                        do
                                        {
                                            if (!_1509)
                                            {
                                                float _1511 = log2(_1139);
                                                float _1512 = _1511 * 0.3010300099849701f;
                                                _1577 = _1512;
                                            }
                                            else
                                            {
                                                bool _1514 = (_1508 > _1434);
                                                float _1515 = log2(_1136);
                                                float _1516 = _1515 * 0.3010300099849701f;
                                                bool _1517 = (_1508 < _1516);
                                                bool _1518 = _1514 && _1517;
                                                if (_1518)
                                                {
                                                    float _1520 = _1507 - _1433;
                                                    float _1521 = _1520 * 0.9030900001525879f;
                                                    float _1522 = _1515 - _1433;
                                                    float _1523 = _1522 * 0.3010300099849701f;
                                                    float _1524 = _1521 / _1523;
                                                    int _1525 = int(_1524);
                                                    float _1526 = float(_1525);
                                                    float _1527 = _1524 - _1526;
                                                    float _1529 = _10[_1525];
                                                    int _1530 = _1525 + 1;
                                                    float _1532 = _10[_1530];
                                                    int _1533 = _1525 + 2;
                                                    float _1535 = _10[_1533];
                                                    float _1536 = _1527 * _1527;
                                                    float _1537 = _1529 * 0.5f;
                                                    float _1538 = mad(_1532, -1.0f, _1537);
                                                    float _1539 = mad(_1535, 0.5f, _1538);
                                                    float _1540 = _1532 - _1529;
                                                    float _1541 = mad(_1532, 0.5f, _1537);
                                                    float _1542 = dot(float3(_1536, _1527, 1.0f), float3(_1539, _1540, _1541));
                                                    _1577 = _1542;
                                                }
                                                else
                                                {
                                                    bool _1544 = (_1508 >= _1516);
                                                    float _1545 = log2(_1140);
                                                    float _1546 = _1545 * 0.3010300099849701f;
                                                    bool _1547 = (_1508 < _1546);
                                                    bool _1548 = _1544 && _1547;
                                                    if (_1548)
                                                    {
                                                        float _1550 = _1507 - _1515;
                                                        float _1551 = _1550 * 0.9030900001525879f;
                                                        float _1552 = _1545 - _1515;
                                                        float _1553 = _1552 * 0.3010300099849701f;
                                                        float _1554 = _1551 / _1553;
                                                        int _1555 = int(_1554);
                                                        float _1556 = float(_1555);
                                                        float _1557 = _1554 - _1556;
                                                        float _1559 = _11[_1555];
                                                        int _1560 = _1555 + 1;
                                                        float _1562 = _11[_1560];
                                                        int _1563 = _1555 + 2;
                                                        float _1565 = _11[_1563];
                                                        float _1566 = _1557 * _1557;
                                                        float _1567 = _1559 * 0.5f;
                                                        float _1568 = mad(_1562, -1.0f, _1567);
                                                        float _1569 = mad(_1565, 0.5f, _1568);
                                                        float _1570 = _1562 - _1559;
                                                        float _1571 = mad(_1562, 0.5f, _1567);
                                                        float _1572 = dot(float3(_1566, _1557, 1.0f), float3(_1569, _1570, _1571));
                                                        _1577 = _1572;
                                                    }
                                                    else
                                                    {
                                                        float _1574 = log2(_1141);
                                                        float _1575 = _1574 * 0.3010300099849701f;
                                                        _1577 = _1575;
                                                    }
                                                }
                                            }
                                            float _1578 = _1577 * 3.321928024291992f;
                                            float _1579 = exp2(_1578);
                                            float _1580 = max(_1429, 1.000000013351432e-10f);
                                            float _1581 = log2(_1580);
                                            float _1582 = _1581 * 0.3010300099849701f;
                                            bool _1583 = !(_1582 <= _1434);
                                            do
                                            {
                                                if (!_1583)
                                                {
                                                    float _1585 = log2(_1139);
                                                    float _1586 = _1585 * 0.3010300099849701f;
                                                    _1651 = _1586;
                                                }
                                                else
                                                {
                                                    bool _1588 = (_1582 > _1434);
                                                    float _1589 = log2(_1136);
                                                    float _1590 = _1589 * 0.3010300099849701f;
                                                    bool _1591 = (_1582 < _1590);
                                                    bool _1592 = _1588 && _1591;
                                                    if (_1592)
                                                    {
                                                        float _1594 = _1581 - _1433;
                                                        float _1595 = _1594 * 0.9030900001525879f;
                                                        float _1596 = _1589 - _1433;
                                                        float _1597 = _1596 * 0.3010300099849701f;
                                                        float _1598 = _1595 / _1597;
                                                        int _1599 = int(_1598);
                                                        float _1600 = float(_1599);
                                                        float _1601 = _1598 - _1600;
                                                        float _1603 = _10[_1599];
                                                        int _1604 = _1599 + 1;
                                                        float _1606 = _10[_1604];
                                                        int _1607 = _1599 + 2;
                                                        float _1609 = _10[_1607];
                                                        float _1610 = _1601 * _1601;
                                                        float _1611 = _1603 * 0.5f;
                                                        float _1612 = mad(_1606, -1.0f, _1611);
                                                        float _1613 = mad(_1609, 0.5f, _1612);
                                                        float _1614 = _1606 - _1603;
                                                        float _1615 = mad(_1606, 0.5f, _1611);
                                                        float _1616 = dot(float3(_1610, _1601, 1.0f), float3(_1613, _1614, _1615));
                                                        _1651 = _1616;
                                                    }
                                                    else
                                                    {
                                                        bool _1618 = (_1582 >= _1590);
                                                        float _1619 = log2(_1140);
                                                        float _1620 = _1619 * 0.3010300099849701f;
                                                        bool _1621 = (_1582 < _1620);
                                                        bool _1622 = _1618 && _1621;
                                                        if (_1622)
                                                        {
                                                            float _1624 = _1581 - _1589;
                                                            float _1625 = _1624 * 0.9030900001525879f;
                                                            float _1626 = _1619 - _1589;
                                                            float _1627 = _1626 * 0.3010300099849701f;
                                                            float _1628 = _1625 / _1627;
                                                            int _1629 = int(_1628);
                                                            float _1630 = float(_1629);
                                                            float _1631 = _1628 - _1630;
                                                            float _1633 = _11[_1629];
                                                            int _1634 = _1629 + 1;
                                                            float _1636 = _11[_1634];
                                                            int _1637 = _1629 + 2;
                                                            float _1639 = _11[_1637];
                                                            float _1640 = _1631 * _1631;
                                                            float _1641 = _1633 * 0.5f;
                                                            float _1642 = mad(_1636, -1.0f, _1641);
                                                            float _1643 = mad(_1639, 0.5f, _1642);
                                                            float _1644 = _1636 - _1633;
                                                            float _1645 = mad(_1636, 0.5f, _1641);
                                                            float _1646 = dot(float3(_1640, _1631, 1.0f), float3(_1643, _1644, _1645));
                                                            _1651 = _1646;
                                                        }
                                                        else
                                                        {
                                                            float _1648 = log2(_1141);
                                                            float _1649 = _1648 * 0.3010300099849701f;
                                                            _1651 = _1649;
                                                        }
                                                    }
                                                }
                                                float _1652 = _1651 * 3.321928024291992f;
                                                float _1653 = exp2(_1652);
                                                float _1654 = _1505 - _1139;
                                                float _1655 = _1141 - _1139;
                                                float _1656 = _1654 / _1655;
                                                float _1657 = _1579 - _1139;
                                                float _1658 = _1657 / _1655;
                                                float _1659 = _1653 - _1139;
                                                float _1660 = _1659 / _1655;
                                                float _1661 = _1656 * 0.6624541878700256f;
                                                float _1662 = mad(0.13400420546531677f, _1658, _1661);
                                                float _1663 = mad(0.15618768334388733f, _1660, _1662);
                                                float _1664 = _1656 * 0.2722287178039551f;
                                                float _1665 = mad(0.6740817427635193f, _1658, _1664);
                                                float _1666 = mad(0.053689517080783844f, _1660, _1665);
                                                float _1667 = _1656 * -0.005574649665504694f;
                                                float _1668 = mad(0.00406073359772563f, _1658, _1667);
                                                float _1669 = mad(1.0103391408920288f, _1660, _1668);
                                                float _1670 = _1663 * 1.6410233974456787f;
                                                float _1671 = mad(-0.32480329275131226f, _1666, _1670);
                                                float _1672 = mad(-0.23642469942569733f, _1669, _1671);
                                                float _1673 = _1663 * -0.663662850856781f;
                                                float _1674 = mad(1.6153316497802734f, _1666, _1673);
                                                float _1675 = mad(0.016756348311901093f, _1669, _1674);
                                                float _1676 = _1663 * 0.011721894145011902f;
                                                float _1677 = mad(-0.008284442126750946f, _1666, _1676);
                                                float _1678 = mad(0.9883948564529419f, _1669, _1677);
                                                float _1679 = max(_1672, 0.0f);
                                                float _1680 = max(_1675, 0.0f);
                                                float _1681 = max(_1678, 0.0f);
                                                float _1682 = min(_1679, 1.0f);
                                                float _1683 = min(_1680, 1.0f);
                                                float _1684 = min(_1681, 1.0f);
                                                float _1685 = _1682 * 0.6624541878700256f;
                                                float _1686 = mad(0.13400420546531677f, _1683, _1685);
                                                float _1687 = mad(0.15618768334388733f, _1684, _1686);
                                                float _1688 = _1682 * 0.2722287178039551f;
                                                float _1689 = mad(0.6740817427635193f, _1683, _1688);
                                                float _1690 = mad(0.053689517080783844f, _1684, _1689);
                                                float _1691 = _1682 * -0.005574649665504694f;
                                                float _1692 = mad(0.00406073359772563f, _1683, _1691);
                                                float _1693 = mad(1.0103391408920288f, _1684, _1692);
                                                float _1694 = _1687 * 1.6410233974456787f;
                                                float _1695 = mad(-0.32480329275131226f, _1690, _1694);
                                                float _1696 = mad(-0.23642469942569733f, _1693, _1695);
                                                float _1697 = _1687 * -0.663662850856781f;
                                                float _1698 = mad(1.6153316497802734f, _1690, _1697);
                                                float _1699 = mad(0.016756348311901093f, _1693, _1698);
                                                float _1700 = _1687 * 0.011721894145011902f;
                                                float _1701 = mad(-0.008284442126750946f, _1690, _1700);
                                                float _1702 = mad(0.9883948564529419f, _1693, _1701);
                                                float _1703 = max(_1696, 0.0f);
                                                float _1704 = max(_1699, 0.0f);
                                                float _1705 = max(_1702, 0.0f);
                                                float _1706 = min(_1703, 65535.0f);
                                                float _1707 = min(_1704, 65535.0f);
                                                float _1708 = min(_1705, 65535.0f);
                                                float _1709 = _1706 * _1141;
                                                float _1710 = _1707 * _1141;
                                                float _1711 = _1708 * _1141;
                                                float _1712 = max(_1709, 0.0f);
                                                float _1713 = max(_1710, 0.0f);
                                                float _1714 = max(_1711, 0.0f);
                                                float _1715 = min(_1712, 65535.0f);
                                                float _1716 = min(_1713, 65535.0f);
                                                float _1717 = min(_1714, 65535.0f);
                                                _1729 = _1715;
                                                _1730 = _1716;
                                                _1731 = _1717;
                                                do
                                                {
                                                    if (!_1115)
                                                    {
                                                        float _1719 = _1715 * _37;
                                                        float _1720 = mad(_38, _1716, _1719);
                                                        float _1721 = mad(_39, _1717, _1720);
                                                        float _1722 = _1715 * _40;
                                                        float _1723 = mad(_41, _1716, _1722);
                                                        float _1724 = mad(_42, _1717, _1723);
                                                        float _1725 = _1715 * _43;
                                                        float _1726 = mad(_44, _1716, _1725);
                                                        float _1727 = mad(_45, _1717, _1726);
                                                        _1729 = _1721;
                                                        _1730 = _1724;
                                                        _1731 = _1727;
                                                    }
                                                    float _1732 = _1729 * 9.999999747378752e-05f;
                                                    float _1733 = _1730 * 9.999999747378752e-05f;
                                                    float _1734 = _1731 * 9.999999747378752e-05f;
                                                    float _1735 = log2(_1732);
                                                    float _1736 = log2(_1733);
                                                    float _1737 = log2(_1734);
                                                    float _1738 = _1735 * 0.1593017578125f;
                                                    float _1739 = _1736 * 0.1593017578125f;
                                                    float _1740 = _1737 * 0.1593017578125f;
                                                    float _1741 = exp2(_1738);
                                                    float _1742 = exp2(_1739);
                                                    float _1743 = exp2(_1740);
                                                    float _1744 = _1741 * 18.8515625f;
                                                    float _1745 = _1742 * 18.8515625f;
                                                    float _1746 = _1743 * 18.8515625f;
                                                    float _1747 = _1744 + 0.8359375f;
                                                    float _1748 = _1745 + 0.8359375f;
                                                    float _1749 = _1746 + 0.8359375f;
                                                    float _1750 = _1741 * 18.6875f;
                                                    float _1751 = _1742 * 18.6875f;
                                                    float _1752 = _1743 * 18.6875f;
                                                    float _1753 = _1750 + 1.0f;
                                                    float _1754 = _1751 + 1.0f;
                                                    float _1755 = _1752 + 1.0f;
                                                    float _1756 = 1.0f / _1753;
                                                    float _1757 = 1.0f / _1754;
                                                    float _1758 = 1.0f / _1755;
                                                    float _1759 = _1756 * _1747;
                                                    float _1760 = _1757 * _1748;
                                                    float _1761 = _1758 * _1749;
                                                    float _1762 = log2(_1759);
                                                    float _1763 = log2(_1760);
                                                    float _1764 = log2(_1761);
                                                    float _1765 = _1762 * 78.84375f;
                                                    float _1766 = _1763 * 78.84375f;
                                                    float _1767 = _1764 * 78.84375f;
                                                    float _1768 = exp2(_1765);
                                                    float _1769 = exp2(_1766);
                                                    float _1770 = exp2(_1767);
                                                    _2542 = _1768;
                                                    _2543 = _1769;
                                                    _2544 = _1770;
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
                bool _1772 = (_1031 == 6);
                int _1773 = _1031 & -3;
                bool _1774 = (_1773 == 4);
                if (_1774)
                {
          //   %1776 = bitcast [6 x float]* %8 to i8*
          //   %1777 = bitcast [6 x float]* %9 to i8*
                    float _1779 = cb0_011w;
                    float _1780 = cb0_011z;
                    float _1781 = cb0_011y;
                    float _1782 = cb0_011x;
                    float _1784 = cb0_010x;
                    float _1785 = cb0_010y;
                    float _1786 = cb0_010z;
                    float _1787 = cb0_010w;
                    float _1789 = cb0_009x;
                    float _1790 = cb0_009y;
                    float _1791 = cb0_009z;
                    float _1792 = cb0_009w;
                    float _1794 = cb0_008x;
                    float _1796 = cb0_007x;
                    float _1797 = cb0_007y;
                    float _1798 = cb0_007z;
                    float _1799 = cb0_007w;
                    _8[0] = _1789;
                    _8[1] = _1790;
                    _8[2] = _1791;
                    _8[3] = _1792;
                    _8[4] = _1782;
                    _8[5] = _1782;
                    _9[0] = _1784;
                    _9[1] = _1785;
                    _9[2] = _1786;
                    _9[3] = _1787;
                    _9[4] = _1781;
                    _9[5] = _1781;
                    float _1812 = _1780 * _988;
                    float _1813 = _1780 * _991;
                    float _1814 = _1780 * _994;
                    float _1815 = _1812 * 0.43970081210136414f;
                    float _1816 = mad(0.38297808170318604f, _1813, _1815);
                    float _1817 = mad(0.17733481526374817f, _1814, _1816);
                    float _1818 = _1812 * 0.08979231864213943f;
                    float _1819 = mad(0.8134231567382812f, _1813, _1818);
                    float _1820 = mad(0.09676162153482437f, _1814, _1819);
                    float _1821 = _1812 * 0.017543988302350044f;
                    float _1822 = mad(0.11154405772686005f, _1813, _1821);
                    float _1823 = mad(0.870704174041748f, _1814, _1822);
                    float _1824 = _1817 * 1.4514392614364624f;
                    float _1825 = mad(-0.2365107536315918f, _1820, _1824);
                    float _1826 = mad(-0.21492856740951538f, _1823, _1825);
                    float _1827 = _1817 * -0.07655377686023712f;
                    float _1828 = mad(1.17622971534729f, _1820, _1827);
                    float _1829 = mad(-0.09967592358589172f, _1823, _1828);
                    float _1830 = _1817 * 0.008316148072481155f;
                    float _1831 = mad(-0.006032449658960104f, _1820, _1830);
                    float _1832 = mad(0.9977163076400757f, _1823, _1831);
                    float _1833 = max(_1829, _1832);
                    float _1834 = max(_1826, _1833);
                    bool _1835 = (_1834 < 1.000000013351432e-10f);
                    bool _1836 = (_1817 < 0.0f);
                    bool _1837 = (_1820 < 0.0f);
                    bool _1838 = (_1823 < 0.0f);
                    bool _1839 = _1836 || _1837;
                    bool _1840 = _1839 || _1838;
                    bool _1841 = _1840 || _1835;
                    _1902 = _1826;
                    _1903 = _1829;
                    _1904 = _1832;
                    do
                    {
                        if (!_1841)
                        {
                            float _1843 = _1834 - _1826;
                            float _1844 = abs(_1834);
                            float _1845 = _1843 / _1844;
                            float _1846 = _1834 - _1829;
                            float _1847 = _1846 / _1844;
                            float _1848 = _1834 - _1832;
                            float _1849 = _1848 / _1844;
                            bool _1850 = (_1845 < 0.8149999976158142f);
                            _1864 = _1845;
                            do
                            {
                                if (!_1850)
                                {
                                    float _1852 = _1845 + -0.8149999976158142f;
                                    float _1853 = _1852 * 3.0552830696105957f;
                                    float _1854 = log2(_1853);
                                    float _1855 = _1854 * 1.2000000476837158f;
                                    float _1856 = exp2(_1855);
                                    float _1857 = _1856 + 1.0f;
                                    float _1858 = log2(_1857);
                                    float _1859 = _1858 * 0.8333333134651184f;
                                    float _1860 = exp2(_1859);
                                    float _1861 = _1852 / _1860;
                                    float _1862 = _1861 + 0.8149999976158142f;
                                    _1864 = _1862;
                                }
                                bool _1865 = (_1847 < 0.8029999732971191f);
                                _1879 = _1847;
                                do
                                {
                                    if (!_1865)
                                    {
                                        float _1867 = _1847 + -0.8029999732971191f;
                                        float _1868 = _1867 * 3.4972610473632812f;
                                        float _1869 = log2(_1868);
                                        float _1870 = _1869 * 1.2000000476837158f;
                                        float _1871 = exp2(_1870);
                                        float _1872 = _1871 + 1.0f;
                                        float _1873 = log2(_1872);
                                        float _1874 = _1873 * 0.8333333134651184f;
                                        float _1875 = exp2(_1874);
                                        float _1876 = _1867 / _1875;
                                        float _1877 = _1876 + 0.8029999732971191f;
                                        _1879 = _1877;
                                    }
                                    bool _1880 = (_1849 < 0.8799999952316284f);
                                    _1894 = _1849;
                                    do
                                    {
                                        if (!_1880)
                                        {
                                            float _1882 = _1849 + -0.8799999952316284f;
                                            float _1883 = _1882 * 6.810994625091553f;
                                            float _1884 = log2(_1883);
                                            float _1885 = _1884 * 1.2000000476837158f;
                                            float _1886 = exp2(_1885);
                                            float _1887 = _1886 + 1.0f;
                                            float _1888 = log2(_1887);
                                            float _1889 = _1888 * 0.8333333134651184f;
                                            float _1890 = exp2(_1889);
                                            float _1891 = _1882 / _1890;
                                            float _1892 = _1891 + 0.8799999952316284f;
                                            _1894 = _1892;
                                        }
                                        float _1895 = _1844 * _1864;
                                        float _1896 = _1834 - _1895;
                                        float _1897 = _1844 * _1879;
                                        float _1898 = _1834 - _1897;
                                        float _1899 = _1844 * _1894;
                                        float _1900 = _1834 - _1899;
                                        _1902 = _1896;
                                        _1903 = _1898;
                                        _1904 = _1900;
                                    } while (false);
                                } while (false);
                            } while (false);
                        }
                        float _1905 = _1902 * 0.6954522132873535f;
                        float _1906 = mad(0.14067870378494263f, _1903, _1905);
                        float _1907 = mad(0.16386906802654266f, _1904, _1906);
                        float _1908 = _1907 - _1817;
                        float _1909 = _1907 - _1820;
                        float _1910 = _1907 - _1823;
                        float _1911 = _1908 * _1779;
                        float _1912 = _1909 * _1779;
                        float _1913 = _1910 * _1779;
                        float _1914 = _1911 + _1817;
                        float _1915 = _1912 + _1820;
                        float _1916 = _1913 + _1823;
                        float _1917 = min(_1914, _1915);
                        float _1918 = min(_1917, _1916);
                        float _1919 = max(_1914, _1915);
                        float _1920 = max(_1919, _1916);
                        float _1921 = max(_1920, 1.000000013351432e-10f);
                        float _1922 = max(_1918, 1.000000013351432e-10f);
                        float _1923 = _1921 - _1922;
                        float _1924 = max(_1920, 0.009999999776482582f);
                        float _1925 = _1923 / _1924;
                        float _1926 = _1916 - _1915;
                        float _1927 = _1926 * _1916;
                        float _1928 = _1915 - _1914;
                        float _1929 = _1928 * _1915;
                        float _1930 = _1927 + _1929;
                        float _1931 = _1914 - _1916;
                        float _1932 = _1931 * _1914;
                        float _1933 = _1930 + _1932;
                        float _1934 = sqrt(_1933);
                        float _1935 = _1916 + _1915;
                        float _1936 = _1935 + _1914;
                        float _1937 = _1934 * 1.75f;
                        float _1938 = _1936 + _1937;
                        float _1939 = _1938 * 0.3333333432674408f;
                        float _1940 = _1925 + -0.4000000059604645f;
                        float _1941 = _1940 * 5.0f;
                        float _1942 = _1940 * 2.5f;
                        float _1943 = abs(_1942);
                        float _1944 = 1.0f - _1943;
                        float _1945 = max(_1944, 0.0f);
                        bool _1946 = (_1941 > 0.0f);
                        bool _1947 = (_1941 < 0.0f);
                        int _1948 = int(_1946);
                        int _1949 = int(_1947);
                        int _1950 = _1948 - _1949;
                        float _1951 = float(_1950);
                        float _1952 = _1945 * _1945;
                        float _1953 = 1.0f - _1952;
                        float _1954 = _1951 * _1953;
                        float _1955 = _1954 + 1.0f;
                        float _1956 = _1955 * 0.02500000037252903f;
                        bool _1957 = !(_1939 <= 0.0533333346247673f);
                        _1965 = _1956;
                        do
                        {
                            if (_1957)
                            {
                                bool _1959 = !(_1939 >= 0.1599999964237213f);
                                _1965 = 0.0f;
                                if (_1959)
                                {
                                    float _1961 = 0.23999999463558197f / _1938;
                                    float _1962 = _1961 + -0.5f;
                                    float _1963 = _1962 * _1956;
                                    _1965 = _1963;
                                }
                            }
                            float _1966 = _1965 + 1.0f;
                            float _1967 = _1966 * _1914;
                            float _1968 = _1966 * _1915;
                            float _1969 = _1966 * _1916;
                            bool _1970 = (_1967 == _1968);
                            bool _1971 = (_1968 == _1969);
                            bool _1972 = _1970 && _1971;
                            _2001 = 0.0f;
                            do
                            {
                                if (!_1972)
                                {
                                    float _1974 = _1967 * 2.0f;
                                    float _1975 = _1974 - _1968;
                                    float _1976 = _1975 - _1969;
                                    float _1977 = _1915 - _1916;
                                    float _1978 = _1977 * 1.7320507764816284f;
                                    float _1979 = _1978 * _1966;
                                    float _1980 = _1979 / _1976;
                                    float _1981 = atan(_1980);
                                    float _1982 = _1981 + 3.1415927410125732f;
                                    float _1983 = _1981 + -3.1415927410125732f;
                                    bool _1984 = (_1976 < 0.0f);
                                    bool _1985 = (_1976 == 0.0f);
                                    bool _1986 = (_1979 >= 0.0f);
                                    bool _1987 = (_1979 < 0.0f);
                                    bool _1988 = _1986 && _1984;
                                    float _1989 = _1988 ? _1982 : _1981;
                                    bool _1990 = _1987 && _1984;
                                    float _1991 = _1990 ? _1983 : _1989;
                                    bool _1992 = _1987 && _1985;
                                    bool _1993 = _1986 && _1985;
                                    float _1994 = _1991 * 57.2957763671875f;
                                    float _1995 = _1992 ? -90.0f : _1994;
                                    float _1996 = _1993 ? 90.0f : _1995;
                                    bool _1997 = (_1996 < 0.0f);
                                    _2001 = _1996;
                                    if (_1997)
                                    {
                                        float _1999 = _1996 + 360.0f;
                                        _2001 = _1999;
                                    }
                                }
                                float _2002 = max(_2001, 0.0f);
                                float _2003 = min(_2002, 360.0f);
                                bool _2004 = (_2003 < -180.0f);
                                do
                                {
                                    if (_2004)
                                    {
                                        float _2006 = _2003 + 360.0f;
                                        _2012 = _2006;
                                    }
                                    else
                                    {
                                        bool _2008 = (_2003 > 180.0f);
                                        _2012 = _2003;
                                        if (_2008)
                                        {
                                            float _2010 = _2003 + -360.0f;
                                            _2012 = _2010;
                                        }
                                    }
                                    bool _2013 = (_2012 > -67.5f);
                                    bool _2014 = (_2012 < 67.5f);
                                    bool _2015 = _2013 && _2014;
                                    _2051 = 0.0f;
                                    do
                                    {
                                        if (_2015)
                                        {
                                            float _2017 = _2012 + 67.5f;
                                            float _2018 = _2017 * 0.029629629105329514f;
                                            int _2019 = int(_2018);
                                            float _2020 = float(_2019);
                                            float _2021 = _2018 - _2020;
                                            float _2022 = _2021 * _2021;
                                            float _2023 = _2022 * _2021;
                                            bool _2024 = (_2019 == 3);
                                            if (_2024)
                                            {
                                                float _2026 = _2023 * 0.1666666716337204f;
                                                float _2027 = _2022 * 0.5f;
                                                float _2028 = _2021 * 0.5f;
                                                float _2029 = 0.1666666716337204f - _2028;
                                                float _2030 = _2029 + _2027;
                                                float _2031 = _2030 - _2026;
                                                _2051 = _2031;
                                            }
                                            else
                                            {
                                                bool _2033 = (_2019 == 2);
                                                if (_2033)
                                                {
                                                    float _2035 = _2023 * 0.5f;
                                                    float _2036 = 0.6666666865348816f - _2022;
                                                    float _2037 = _2036 + _2035;
                                                    _2051 = _2037;
                                                }
                                                else
                                                {
                                                    bool _2039 = (_2019 == 1);
                                                    if (_2039)
                                                    {
                                                        float _2041 = _2023 * -0.5f;
                                                        float _2042 = _2022 + _2021;
                                                        float _2043 = _2042 * 0.5f;
                                                        float _2044 = _2041 + 0.1666666716337204f;
                                                        float _2045 = _2044 + _2043;
                                                        _2051 = _2045;
                                                    }
                                                    else
                                                    {
                                                        bool _2047 = (_2019 == 0);
                                                        float _2048 = _2023 * 0.1666666716337204f;
                                                        float _2049 = _2047 ? _2048 : 0.0f;
                                                        _2051 = _2049;
                                                    }
                                                }
                                            }
                                        }
                                        float _2052 = 0.029999999329447746f - _1967;
                                        float _2053 = _1925 * 0.27000001072883606f;
                                        float _2054 = _2053 * _2052;
                                        float _2055 = _2054 * _2051;
                                        float _2056 = _2055 + _1967;
                                        float _2057 = max(_2056, 0.0f);
                                        float _2058 = max(_1968, 0.0f);
                                        float _2059 = max(_1969, 0.0f);
                                        float _2060 = min(_2057, 65535.0f);
                                        float _2061 = min(_2058, 65535.0f);
                                        float _2062 = min(_2059, 65535.0f);
                                        float _2063 = _2060 * 1.4514392614364624f;
                                        float _2064 = mad(-0.2365107536315918f, _2061, _2063);
                                        float _2065 = mad(-0.21492856740951538f, _2062, _2064);
                                        float _2066 = _2060 * -0.07655377686023712f;
                                        float _2067 = mad(1.17622971534729f, _2061, _2066);
                                        float _2068 = mad(-0.09967592358589172f, _2062, _2067);
                                        float _2069 = _2060 * 0.008316148072481155f;
                                        float _2070 = mad(-0.006032449658960104f, _2061, _2069);
                                        float _2071 = mad(0.9977163076400757f, _2062, _2070);
                                        float _2072 = max(_2065, 0.0f);
                                        float _2073 = max(_2068, 0.0f);
                                        float _2074 = max(_2071, 0.0f);
                                        float _2075 = min(_2072, 65504.0f);
                                        float _2076 = min(_2073, 65504.0f);
                                        float _2077 = min(_2074, 65504.0f);
                                        float _2078 = dot(float3(_2075, _2076, _2077), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                                        float _2079 = _2075 - _2078;
                                        float _2080 = _2076 - _2078;
                                        float _2081 = _2077 - _2078;
                                        float _2082 = _2079 * 0.9599999785423279f;
                                        float _2083 = _2080 * 0.9599999785423279f;
                                        float _2084 = _2081 * 0.9599999785423279f;
                                        float _2085 = _2082 + _2078;
                                        float _2086 = _2083 + _2078;
                                        float _2087 = _2084 + _2078;
                                        float _2088 = max(_2085, 1.000000013351432e-10f);
                                        float _2089 = log2(_2088);
                                        float _2090 = _2089 * 0.3010300099849701f;
                                        float _2091 = log2(_1796);
                                        float _2092 = _2091 * 0.3010300099849701f;
                                        bool _2093 = !(_2090 <= _2092);
                                        do
                                        {
                                            if (!_2093)
                                            {
                                                float _2095 = log2(_1797);
                                                float _2096 = _2095 * 0.3010300099849701f;
                                                _2161 = _2096;
                                            }
                                            else
                                            {
                                                bool _2098 = (_2090 > _2092);
                                                float _2099 = log2(_1794);
                                                float _2100 = _2099 * 0.3010300099849701f;
                                                bool _2101 = (_2090 < _2100);
                                                bool _2102 = _2098 && _2101;
                                                if (_2102)
                                                {
                                                    float _2104 = _2089 - _2091;
                                                    float _2105 = _2104 * 0.9030900001525879f;
                                                    float _2106 = _2099 - _2091;
                                                    float _2107 = _2106 * 0.3010300099849701f;
                                                    float _2108 = _2105 / _2107;
                                                    int _2109 = int(_2108);
                                                    float _2110 = float(_2109);
                                                    float _2111 = _2108 - _2110;
                                                    float _2113 = _8[_2109];
                                                    int _2114 = _2109 + 1;
                                                    float _2116 = _8[_2114];
                                                    int _2117 = _2109 + 2;
                                                    float _2119 = _8[_2117];
                                                    float _2120 = _2111 * _2111;
                                                    float _2121 = _2113 * 0.5f;
                                                    float _2122 = mad(_2116, -1.0f, _2121);
                                                    float _2123 = mad(_2119, 0.5f, _2122);
                                                    float _2124 = _2116 - _2113;
                                                    float _2125 = mad(_2116, 0.5f, _2121);
                                                    float _2126 = dot(float3(_2120, _2111, 1.0f), float3(_2123, _2124, _2125));
                                                    _2161 = _2126;
                                                }
                                                else
                                                {
                                                    bool _2128 = (_2090 >= _2100);
                                                    float _2129 = log2(_1798);
                                                    float _2130 = _2129 * 0.3010300099849701f;
                                                    bool _2131 = (_2090 < _2130);
                                                    bool _2132 = _2128 && _2131;
                                                    if (_2132)
                                                    {
                                                        float _2134 = _2089 - _2099;
                                                        float _2135 = _2134 * 0.9030900001525879f;
                                                        float _2136 = _2129 - _2099;
                                                        float _2137 = _2136 * 0.3010300099849701f;
                                                        float _2138 = _2135 / _2137;
                                                        int _2139 = int(_2138);
                                                        float _2140 = float(_2139);
                                                        float _2141 = _2138 - _2140;
                                                        float _2143 = _9[_2139];
                                                        int _2144 = _2139 + 1;
                                                        float _2146 = _9[_2144];
                                                        int _2147 = _2139 + 2;
                                                        float _2149 = _9[_2147];
                                                        float _2150 = _2141 * _2141;
                                                        float _2151 = _2143 * 0.5f;
                                                        float _2152 = mad(_2146, -1.0f, _2151);
                                                        float _2153 = mad(_2149, 0.5f, _2152);
                                                        float _2154 = _2146 - _2143;
                                                        float _2155 = mad(_2146, 0.5f, _2151);
                                                        float _2156 = dot(float3(_2150, _2141, 1.0f), float3(_2153, _2154, _2155));
                                                        _2161 = _2156;
                                                    }
                                                    else
                                                    {
                                                        float _2158 = log2(_1799);
                                                        float _2159 = _2158 * 0.3010300099849701f;
                                                        _2161 = _2159;
                                                    }
                                                }
                                            }
                                            float _2162 = _2161 * 3.321928024291992f;
                                            float _2163 = exp2(_2162);
                                            float _2164 = max(_2086, 1.000000013351432e-10f);
                                            float _2165 = log2(_2164);
                                            float _2166 = _2165 * 0.3010300099849701f;
                                            bool _2167 = !(_2166 <= _2092);
                                            do
                                            {
                                                if (!_2167)
                                                {
                                                    float _2169 = log2(_1797);
                                                    float _2170 = _2169 * 0.3010300099849701f;
                                                    _2235 = _2170;
                                                }
                                                else
                                                {
                                                    bool _2172 = (_2166 > _2092);
                                                    float _2173 = log2(_1794);
                                                    float _2174 = _2173 * 0.3010300099849701f;
                                                    bool _2175 = (_2166 < _2174);
                                                    bool _2176 = _2172 && _2175;
                                                    if (_2176)
                                                    {
                                                        float _2178 = _2165 - _2091;
                                                        float _2179 = _2178 * 0.9030900001525879f;
                                                        float _2180 = _2173 - _2091;
                                                        float _2181 = _2180 * 0.3010300099849701f;
                                                        float _2182 = _2179 / _2181;
                                                        int _2183 = int(_2182);
                                                        float _2184 = float(_2183);
                                                        float _2185 = _2182 - _2184;
                                                        float _2187 = _8[_2183];
                                                        int _2188 = _2183 + 1;
                                                        float _2190 = _8[_2188];
                                                        int _2191 = _2183 + 2;
                                                        float _2193 = _8[_2191];
                                                        float _2194 = _2185 * _2185;
                                                        float _2195 = _2187 * 0.5f;
                                                        float _2196 = mad(_2190, -1.0f, _2195);
                                                        float _2197 = mad(_2193, 0.5f, _2196);
                                                        float _2198 = _2190 - _2187;
                                                        float _2199 = mad(_2190, 0.5f, _2195);
                                                        float _2200 = dot(float3(_2194, _2185, 1.0f), float3(_2197, _2198, _2199));
                                                        _2235 = _2200;
                                                    }
                                                    else
                                                    {
                                                        bool _2202 = (_2166 >= _2174);
                                                        float _2203 = log2(_1798);
                                                        float _2204 = _2203 * 0.3010300099849701f;
                                                        bool _2205 = (_2166 < _2204);
                                                        bool _2206 = _2202 && _2205;
                                                        if (_2206)
                                                        {
                                                            float _2208 = _2165 - _2173;
                                                            float _2209 = _2208 * 0.9030900001525879f;
                                                            float _2210 = _2203 - _2173;
                                                            float _2211 = _2210 * 0.3010300099849701f;
                                                            float _2212 = _2209 / _2211;
                                                            int _2213 = int(_2212);
                                                            float _2214 = float(_2213);
                                                            float _2215 = _2212 - _2214;
                                                            float _2217 = _9[_2213];
                                                            int _2218 = _2213 + 1;
                                                            float _2220 = _9[_2218];
                                                            int _2221 = _2213 + 2;
                                                            float _2223 = _9[_2221];
                                                            float _2224 = _2215 * _2215;
                                                            float _2225 = _2217 * 0.5f;
                                                            float _2226 = mad(_2220, -1.0f, _2225);
                                                            float _2227 = mad(_2223, 0.5f, _2226);
                                                            float _2228 = _2220 - _2217;
                                                            float _2229 = mad(_2220, 0.5f, _2225);
                                                            float _2230 = dot(float3(_2224, _2215, 1.0f), float3(_2227, _2228, _2229));
                                                            _2235 = _2230;
                                                        }
                                                        else
                                                        {
                                                            float _2232 = log2(_1799);
                                                            float _2233 = _2232 * 0.3010300099849701f;
                                                            _2235 = _2233;
                                                        }
                                                    }
                                                }
                                                float _2236 = _2235 * 3.321928024291992f;
                                                float _2237 = exp2(_2236);
                                                float _2238 = max(_2087, 1.000000013351432e-10f);
                                                float _2239 = log2(_2238);
                                                float _2240 = _2239 * 0.3010300099849701f;
                                                bool _2241 = !(_2240 <= _2092);
                                                do
                                                {
                                                    if (!_2241)
                                                    {
                                                        float _2243 = log2(_1797);
                                                        float _2244 = _2243 * 0.3010300099849701f;
                                                        _2309 = _2244;
                                                    }
                                                    else
                                                    {
                                                        bool _2246 = (_2240 > _2092);
                                                        float _2247 = log2(_1794);
                                                        float _2248 = _2247 * 0.3010300099849701f;
                                                        bool _2249 = (_2240 < _2248);
                                                        bool _2250 = _2246 && _2249;
                                                        if (_2250)
                                                        {
                                                            float _2252 = _2239 - _2091;
                                                            float _2253 = _2252 * 0.9030900001525879f;
                                                            float _2254 = _2247 - _2091;
                                                            float _2255 = _2254 * 0.3010300099849701f;
                                                            float _2256 = _2253 / _2255;
                                                            int _2257 = int(_2256);
                                                            float _2258 = float(_2257);
                                                            float _2259 = _2256 - _2258;
                                                            float _2261 = _8[_2257];
                                                            int _2262 = _2257 + 1;
                                                            float _2264 = _8[_2262];
                                                            int _2265 = _2257 + 2;
                                                            float _2267 = _8[_2265];
                                                            float _2268 = _2259 * _2259;
                                                            float _2269 = _2261 * 0.5f;
                                                            float _2270 = mad(_2264, -1.0f, _2269);
                                                            float _2271 = mad(_2267, 0.5f, _2270);
                                                            float _2272 = _2264 - _2261;
                                                            float _2273 = mad(_2264, 0.5f, _2269);
                                                            float _2274 = dot(float3(_2268, _2259, 1.0f), float3(_2271, _2272, _2273));
                                                            _2309 = _2274;
                                                        }
                                                        else
                                                        {
                                                            bool _2276 = (_2240 >= _2248);
                                                            float _2277 = log2(_1798);
                                                            float _2278 = _2277 * 0.3010300099849701f;
                                                            bool _2279 = (_2240 < _2278);
                                                            bool _2280 = _2276 && _2279;
                                                            if (_2280)
                                                            {
                                                                float _2282 = _2239 - _2247;
                                                                float _2283 = _2282 * 0.9030900001525879f;
                                                                float _2284 = _2277 - _2247;
                                                                float _2285 = _2284 * 0.3010300099849701f;
                                                                float _2286 = _2283 / _2285;
                                                                int _2287 = int(_2286);
                                                                float _2288 = float(_2287);
                                                                float _2289 = _2286 - _2288;
                                                                float _2291 = _9[_2287];
                                                                int _2292 = _2287 + 1;
                                                                float _2294 = _9[_2292];
                                                                int _2295 = _2287 + 2;
                                                                float _2297 = _9[_2295];
                                                                float _2298 = _2289 * _2289;
                                                                float _2299 = _2291 * 0.5f;
                                                                float _2300 = mad(_2294, -1.0f, _2299);
                                                                float _2301 = mad(_2297, 0.5f, _2300);
                                                                float _2302 = _2294 - _2291;
                                                                float _2303 = mad(_2294, 0.5f, _2299);
                                                                float _2304 = dot(float3(_2298, _2289, 1.0f), float3(_2301, _2302, _2303));
                                                                _2309 = _2304;
                                                            }
                                                            else
                                                            {
                                                                float _2306 = log2(_1799);
                                                                float _2307 = _2306 * 0.3010300099849701f;
                                                                _2309 = _2307;
                                                            }
                                                        }
                                                    }
                                                    float _2310 = _2309 * 3.321928024291992f;
                                                    float _2311 = exp2(_2310);
                                                    float _2312 = _2163 - _1797;
                                                    float _2313 = _1799 - _1797;
                                                    float _2314 = _2312 / _2313;
                                                    float _2315 = _2237 - _1797;
                                                    float _2316 = _2315 / _2313;
                                                    float _2317 = _2311 - _1797;
                                                    float _2318 = _2317 / _2313;
                                                    float _2319 = _2314 * 0.6624541878700256f;
                                                    float _2320 = mad(0.13400420546531677f, _2316, _2319);
                                                    float _2321 = mad(0.15618768334388733f, _2318, _2320);
                                                    float _2322 = _2314 * 0.2722287178039551f;
                                                    float _2323 = mad(0.6740817427635193f, _2316, _2322);
                                                    float _2324 = mad(0.053689517080783844f, _2318, _2323);
                                                    float _2325 = _2314 * -0.005574649665504694f;
                                                    float _2326 = mad(0.00406073359772563f, _2316, _2325);
                                                    float _2327 = mad(1.0103391408920288f, _2318, _2326);
                                                    float _2328 = _2321 * 1.6410233974456787f;
                                                    float _2329 = mad(-0.32480329275131226f, _2324, _2328);
                                                    float _2330 = mad(-0.23642469942569733f, _2327, _2329);
                                                    float _2331 = _2321 * -0.663662850856781f;
                                                    float _2332 = mad(1.6153316497802734f, _2324, _2331);
                                                    float _2333 = mad(0.016756348311901093f, _2327, _2332);
                                                    float _2334 = _2321 * 0.011721894145011902f;
                                                    float _2335 = mad(-0.008284442126750946f, _2324, _2334);
                                                    float _2336 = mad(0.9883948564529419f, _2327, _2335);
                                                    float _2337 = max(_2330, 0.0f);
                                                    float _2338 = max(_2333, 0.0f);
                                                    float _2339 = max(_2336, 0.0f);
                                                    float _2340 = min(_2337, 1.0f);
                                                    float _2341 = min(_2338, 1.0f);
                                                    float _2342 = min(_2339, 1.0f);
                                                    float _2343 = _2340 * 0.6624541878700256f;
                                                    float _2344 = mad(0.13400420546531677f, _2341, _2343);
                                                    float _2345 = mad(0.15618768334388733f, _2342, _2344);
                                                    float _2346 = _2340 * 0.2722287178039551f;
                                                    float _2347 = mad(0.6740817427635193f, _2341, _2346);
                                                    float _2348 = mad(0.053689517080783844f, _2342, _2347);
                                                    float _2349 = _2340 * -0.005574649665504694f;
                                                    float _2350 = mad(0.00406073359772563f, _2341, _2349);
                                                    float _2351 = mad(1.0103391408920288f, _2342, _2350);
                                                    float _2352 = _2345 * 1.6410233974456787f;
                                                    float _2353 = mad(-0.32480329275131226f, _2348, _2352);
                                                    float _2354 = mad(-0.23642469942569733f, _2351, _2353);
                                                    float _2355 = _2345 * -0.663662850856781f;
                                                    float _2356 = mad(1.6153316497802734f, _2348, _2355);
                                                    float _2357 = mad(0.016756348311901093f, _2351, _2356);
                                                    float _2358 = _2345 * 0.011721894145011902f;
                                                    float _2359 = mad(-0.008284442126750946f, _2348, _2358);
                                                    float _2360 = mad(0.9883948564529419f, _2351, _2359);
                                                    float _2361 = max(_2354, 0.0f);
                                                    float _2362 = max(_2357, 0.0f);
                                                    float _2363 = max(_2360, 0.0f);
                                                    float _2364 = min(_2361, 65535.0f);
                                                    float _2365 = min(_2362, 65535.0f);
                                                    float _2366 = min(_2363, 65535.0f);
                                                    float _2367 = _2364 * _1799;
                                                    float _2368 = _2365 * _1799;
                                                    float _2369 = _2366 * _1799;
                                                    float _2370 = max(_2367, 0.0f);
                                                    float _2371 = max(_2368, 0.0f);
                                                    float _2372 = max(_2369, 0.0f);
                                                    float _2373 = min(_2370, 65535.0f);
                                                    float _2374 = min(_2371, 65535.0f);
                                                    float _2375 = min(_2372, 65535.0f);
                                                    _2387 = _2373;
                                                    _2388 = _2374;
                                                    _2389 = _2375;
                                                    do
                                                    {
                                                        if (!_1772)
                                                        {
                                                            float _2377 = _2373 * _37;
                                                            float _2378 = mad(_38, _2374, _2377);
                                                            float _2379 = mad(_39, _2375, _2378);
                                                            float _2380 = _2373 * _40;
                                                            float _2381 = mad(_41, _2374, _2380);
                                                            float _2382 = mad(_42, _2375, _2381);
                                                            float _2383 = _2373 * _43;
                                                            float _2384 = mad(_44, _2374, _2383);
                                                            float _2385 = mad(_45, _2375, _2384);
                                                            _2387 = _2379;
                                                            _2388 = _2382;
                                                            _2389 = _2385;
                                                        }
                                                        float _2390 = _2387 * 9.999999747378752e-05f;
                                                        float _2391 = _2388 * 9.999999747378752e-05f;
                                                        float _2392 = _2389 * 9.999999747378752e-05f;
                                                        float _2393 = log2(_2390);
                                                        float _2394 = log2(_2391);
                                                        float _2395 = log2(_2392);
                                                        float _2396 = _2393 * 0.1593017578125f;
                                                        float _2397 = _2394 * 0.1593017578125f;
                                                        float _2398 = _2395 * 0.1593017578125f;
                                                        float _2399 = exp2(_2396);
                                                        float _2400 = exp2(_2397);
                                                        float _2401 = exp2(_2398);
                                                        float _2402 = _2399 * 18.8515625f;
                                                        float _2403 = _2400 * 18.8515625f;
                                                        float _2404 = _2401 * 18.8515625f;
                                                        float _2405 = _2402 + 0.8359375f;
                                                        float _2406 = _2403 + 0.8359375f;
                                                        float _2407 = _2404 + 0.8359375f;
                                                        float _2408 = _2399 * 18.6875f;
                                                        float _2409 = _2400 * 18.6875f;
                                                        float _2410 = _2401 * 18.6875f;
                                                        float _2411 = _2408 + 1.0f;
                                                        float _2412 = _2409 + 1.0f;
                                                        float _2413 = _2410 + 1.0f;
                                                        float _2414 = 1.0f / _2411;
                                                        float _2415 = 1.0f / _2412;
                                                        float _2416 = 1.0f / _2413;
                                                        float _2417 = _2414 * _2405;
                                                        float _2418 = _2415 * _2406;
                                                        float _2419 = _2416 * _2407;
                                                        float _2420 = log2(_2417);
                                                        float _2421 = log2(_2418);
                                                        float _2422 = log2(_2419);
                                                        float _2423 = _2420 * 78.84375f;
                                                        float _2424 = _2421 * 78.84375f;
                                                        float _2425 = _2422 * 78.84375f;
                                                        float _2426 = exp2(_2423);
                                                        float _2427 = exp2(_2424);
                                                        float _2428 = exp2(_2425);
                                                        _2542 = _2426;
                                                        _2543 = _2427;
                                                        _2544 = _2428;
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
                    bool _2430 = (_1031 == 7);
                    if (_2430)
                    {
                        float _2432 = _988 * 0.613191545009613f;
                        float _2433 = mad(0.3395121395587921f, _991, _2432);
                        float _2434 = mad(0.04736635088920593f, _994, _2433);
                        float _2435 = _988 * 0.07020691782236099f;
                        float _2436 = mad(0.9163357615470886f, _991, _2435);
                        float _2437 = mad(0.01345000695437193f, _994, _2436);
                        float _2438 = _988 * 0.020618872717022896f;
                        float _2439 = mad(0.1095672994852066f, _991, _2438);
                        float _2440 = mad(0.8696067929267883f, _994, _2439);
                        float _2441 = _2434 * _37;
                        float _2442 = mad(_38, _2437, _2441);
                        float _2443 = mad(_39, _2440, _2442);
                        float _2444 = _2434 * _40;
                        float _2445 = mad(_41, _2437, _2444);
                        float _2446 = mad(_42, _2440, _2445);
                        float _2447 = _2434 * _43;
                        float _2448 = mad(_44, _2437, _2447);
                        float _2449 = mad(_45, _2440, _2448);
                        float _2450 = _2443 * 9.999999747378752e-05f;
                        float _2451 = _2446 * 9.999999747378752e-05f;
                        float _2452 = _2449 * 9.999999747378752e-05f;
                        float _2453 = log2(_2450);
                        float _2454 = log2(_2451);
                        float _2455 = log2(_2452);
                        float _2456 = _2453 * 0.1593017578125f;
                        float _2457 = _2454 * 0.1593017578125f;
                        float _2458 = _2455 * 0.1593017578125f;
                        float _2459 = exp2(_2456);
                        float _2460 = exp2(_2457);
                        float _2461 = exp2(_2458);
                        float _2462 = _2459 * 18.8515625f;
                        float _2463 = _2460 * 18.8515625f;
                        float _2464 = _2461 * 18.8515625f;
                        float _2465 = _2462 + 0.8359375f;
                        float _2466 = _2463 + 0.8359375f;
                        float _2467 = _2464 + 0.8359375f;
                        float _2468 = _2459 * 18.6875f;
                        float _2469 = _2460 * 18.6875f;
                        float _2470 = _2461 * 18.6875f;
                        float _2471 = _2468 + 1.0f;
                        float _2472 = _2469 + 1.0f;
                        float _2473 = _2470 + 1.0f;
                        float _2474 = 1.0f / _2471;
                        float _2475 = 1.0f / _2472;
                        float _2476 = 1.0f / _2473;
                        float _2477 = _2474 * _2465;
                        float _2478 = _2475 * _2466;
                        float _2479 = _2476 * _2467;
                        float _2480 = log2(_2477);
                        float _2481 = log2(_2478);
                        float _2482 = log2(_2479);
                        float _2483 = _2480 * 78.84375f;
                        float _2484 = _2481 * 78.84375f;
                        float _2485 = _2482 * 78.84375f;
                        float _2486 = exp2(_2483);
                        float _2487 = exp2(_2484);
                        float _2488 = exp2(_2485);
                        _2542 = _2486;
                        _2543 = _2487;
                        _2544 = _2488;
                    }
                    else
                    {
                        bool _2490 = (_1031 == 8);
                        _2542 = _988;
                        _2543 = _991;
                        _2544 = _994;
                        if (!_2490)
                        {
                            bool _2492 = (_1031 == 9);
                            if (_2492)
                            {
                                float _2494 = _1013 * 0.613191545009613f;
                                float _2495 = mad(0.3395121395587921f, _1014, _2494);
                                float _2496 = mad(0.04736635088920593f, _1015, _2495);
                                float _2497 = _1013 * 0.07020691782236099f;
                                float _2498 = mad(0.9163357615470886f, _1014, _2497);
                                float _2499 = mad(0.01345000695437193f, _1015, _2498);
                                float _2500 = _1013 * 0.020618872717022896f;
                                float _2501 = mad(0.1095672994852066f, _1014, _2500);
                                float _2502 = mad(0.8696067929267883f, _1015, _2501);
                                float _2503 = _2496 * _37;
                                float _2504 = mad(_38, _2499, _2503);
                                float _2505 = mad(_39, _2502, _2504);
                                float _2506 = _2496 * _40;
                                float _2507 = mad(_41, _2499, _2506);
                                float _2508 = mad(_42, _2502, _2507);
                                float _2509 = _2496 * _43;
                                float _2510 = mad(_44, _2499, _2509);
                                float _2511 = mad(_45, _2502, _2510);
                                _2542 = _2505;
                                _2543 = _2508;
                                _2544 = _2511;
                            }
                            else
                            {
                                float _2513 = _1027 * 0.613191545009613f;
                                float _2514 = mad(0.3395121395587921f, _1028, _2513);
                                float _2515 = mad(0.04736635088920593f, _1029, _2514);
                                float _2516 = _1027 * 0.07020691782236099f;
                                float _2517 = mad(0.9163357615470886f, _1028, _2516);
                                float _2518 = mad(0.01345000695437193f, _1029, _2517);
                                float _2519 = _1027 * 0.020618872717022896f;
                                float _2520 = mad(0.1095672994852066f, _1028, _2519);
                                float _2521 = mad(0.8696067929267883f, _1029, _2520);
                                float _2522 = _2515 * _37;
                                float _2523 = mad(_38, _2518, _2522);
                                float _2524 = mad(_39, _2521, _2523);
                                float _2525 = _2515 * _40;
                                float _2526 = mad(_41, _2518, _2525);
                                float _2527 = mad(_42, _2521, _2526);
                                float _2528 = _2515 * _43;
                                float _2529 = mad(_44, _2518, _2528);
                                float _2530 = mad(_45, _2521, _2529);
                                float _2531 = cb0_039z;
                                float _2532 = log2(_2524);
                                float _2533 = log2(_2527);
                                float _2534 = log2(_2530);
                                float _2535 = _2532 * _2531;
                                float _2536 = _2533 * _2531;
                                float _2537 = _2534 * _2531;
                                float _2538 = exp2(_2535);
                                float _2539 = exp2(_2536);
                                float _2540 = exp2(_2537);
                                _2542 = _2538;
                                _2543 = _2539;
                                _2544 = _2540;
                            }
                        }
                    }
                }
            }
        }
    }
    float _2545 = _2542 * 0.9523810148239136f;
    float _2546 = _2543 * 0.9523810148239136f;
    float _2547 = _2544 * 0.9523810148239136f;
    SV_Target.x = _2545;
    SV_Target.y = _2546;
    SV_Target.z = _2547;
    SV_Target.w = 0.0f;
    return SV_Target;
}
