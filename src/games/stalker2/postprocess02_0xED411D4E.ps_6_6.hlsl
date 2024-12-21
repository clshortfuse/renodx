#include "./shared.h"
#include "./common.hlsl"

Texture2D<float4> SceneTexturesStruct_SceneDepthTexture : register(t0);

Texture2D<float4> Material_Texture2D_0 : register(t1);

Texture2D<float4> Material_Texture2D_1 : register(t2);

Texture2D<float4> Material_Texture2D_2 : register(t3);

Texture2D<float4> PostProcessInput_0_Texture : register(t4);

Texture2D<float4> PostProcessInput_7_Texture : register(t5);

cbuffer $Globals : register(b0) {
  float $Globals_004x : packoffset(c004.x);
  float $Globals_004y : packoffset(c004.y);
  float $Globals_005x : packoffset(c005.x);
  float $Globals_005y : packoffset(c005.y);
  float $Globals_006x : packoffset(c006.x);
  float $Globals_006y : packoffset(c006.y);
  float $Globals_006z : packoffset(c006.z);
  float $Globals_006w : packoffset(c006.w);
  float $Globals_053x : packoffset(c053.x);
  float $Globals_053y : packoffset(c053.y);
  float $Globals_054x : packoffset(c054.x);
  float $Globals_054y : packoffset(c054.y);
  float $Globals_055x : packoffset(c055.x);
  float $Globals_055y : packoffset(c055.y);
  float $Globals_055z : packoffset(c055.z);
  float $Globals_055w : packoffset(c055.w);
  uint $Globals_072x : packoffset(c072.x);
  uint $Globals_072y : packoffset(c072.y);
  float $Globals_073z : packoffset(c073.z);
  float $Globals_073w : packoffset(c073.w);
};

cbuffer UniformBufferConstants_View : register(b1) {
  float UniformBufferConstants_View_026x : packoffset(c026.x);
  float UniformBufferConstants_View_026z : packoffset(c026.z);
  float UniformBufferConstants_View_068z : packoffset(c068.z);
  float UniformBufferConstants_View_075x : packoffset(c075.x);
  float UniformBufferConstants_View_075y : packoffset(c075.y);
  float UniformBufferConstants_View_075z : packoffset(c075.z);
  float UniformBufferConstants_View_075w : packoffset(c075.w);
  float UniformBufferConstants_View_077z : packoffset(c077.z);
  float UniformBufferConstants_View_132x : packoffset(c132.x);
  float UniformBufferConstants_View_132y : packoffset(c132.y);
  float UniformBufferConstants_View_133x : packoffset(c133.x);
  float UniformBufferConstants_View_133y : packoffset(c133.y);
  float UniformBufferConstants_View_136z : packoffset(c136.z);
  float UniformBufferConstants_View_136w : packoffset(c136.w);
  float UniformBufferConstants_View_137x : packoffset(c137.x);
  float UniformBufferConstants_View_137y : packoffset(c137.y);
  float UniformBufferConstants_View_137z : packoffset(c137.z);
  float UniformBufferConstants_View_137w : packoffset(c137.w);
  float UniformBufferConstants_View_147y : packoffset(c147.y);
};

cbuffer UniformBufferConstants_MaterialCollection0 : register(b2) {
  float UniformBufferConstants_MaterialCollection0_015z : packoffset(c015.z);
  float UniformBufferConstants_MaterialCollection0_015w : packoffset(c015.w);
};

cbuffer UniformBufferConstants_Material : register(b3) {
  float UniformBufferConstants_Material_003x : packoffset(c003.x);
  float UniformBufferConstants_Material_003y : packoffset(c003.y);
  float UniformBufferConstants_Material_006x : packoffset(c006.x);
  float UniformBufferConstants_Material_006y : packoffset(c006.y);
  float UniformBufferConstants_Material_006z : packoffset(c006.z);
  float UniformBufferConstants_Material_007x : packoffset(c007.x);
  float UniformBufferConstants_Material_007y : packoffset(c007.y);
  float UniformBufferConstants_Material_007z : packoffset(c007.z);
  float UniformBufferConstants_Material_007w : packoffset(c007.w);
  float UniformBufferConstants_Material_008x : packoffset(c008.x);
  float UniformBufferConstants_Material_008y : packoffset(c008.y);
  float UniformBufferConstants_Material_008z : packoffset(c008.z);
  float UniformBufferConstants_Material_008w : packoffset(c008.w);
  float UniformBufferConstants_Material_009x : packoffset(c009.x);
  float UniformBufferConstants_Material_009z : packoffset(c009.z);
  float UniformBufferConstants_Material_009w : packoffset(c009.w);
  float UniformBufferConstants_Material_010x : packoffset(c010.x);
  float UniformBufferConstants_Material_010y : packoffset(c010.y);
  float UniformBufferConstants_Material_010z : packoffset(c010.z);
  float UniformBufferConstants_Material_010w : packoffset(c010.w);
  float UniformBufferConstants_Material_011x : packoffset(c011.x);
  float UniformBufferConstants_Material_011y : packoffset(c011.y);
  float UniformBufferConstants_Material_011z : packoffset(c011.z);
  float UniformBufferConstants_Material_011w : packoffset(c011.w);
  float UniformBufferConstants_Material_012x : packoffset(c012.x);
  float UniformBufferConstants_Material_012y : packoffset(c012.y);
  float UniformBufferConstants_Material_012z : packoffset(c012.z);
  float UniformBufferConstants_Material_012w : packoffset(c012.w);
  float UniformBufferConstants_Material_013x : packoffset(c013.x);
  float UniformBufferConstants_Material_013y : packoffset(c013.y);
  float UniformBufferConstants_Material_013z : packoffset(c013.z);
  float UniformBufferConstants_Material_013w : packoffset(c013.w);
};

SamplerState SceneTexturesStruct_PointClampSampler : register(s0);

SamplerState Material_Wrap_WorldGroupSettings : register(s1);

SamplerState PostProcessInput_0_Sampler : register(s2);

SamplerState PostProcessInput_BilinearSampler : register(s3);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float3 tonemappedRender, post_srgb, output, srgb_input;
  // texture _1 = PostProcessInput_7_Texture;
  // texture _2 = PostProcessInput_0_Texture;
  // texture _3 = Material_Texture2D_2;
  // texture _4 = Material_Texture2D_1;
  // texture _5 = Material_Texture2D_0;
  // texture _6 = SceneTexturesStruct_SceneDepthTexture;
  // SamplerState _7 = PostProcessInput_BilinearSampler;
  // SamplerState _8 = PostProcessInput_0_Sampler;
  // SamplerState _9 = Material_Wrap_WorldGroupSettings;
  // SamplerState _10 = SceneTexturesStruct_PointClampSampler;
  // cbuffer _11 = UniformBufferConstants_Material;
  // cbuffer _12 = UniformBufferConstants_MaterialCollection0;
  // cbuffer _13 = UniformBufferConstants_View;
  // cbuffer _14 = $Globals;
  // _15 = _11;
  // _16 = _12;
  // _17 = _13;
  // _18 = _14;
  float _19 = SV_Position.x;
  float _20 = SV_Position.y;
  float _22 = UniformBufferConstants_View_026x;
  float _23 = UniformBufferConstants_View_026z;
  float _25 = UniformBufferConstants_View_068z;
  float _27 = UniformBufferConstants_View_077z;
  uint _29 = $Globals_072x;
  uint _30 = $Globals_072y;
  float _31 = float(_29);
  float _32 = float(_30);
  float _33 = _19 - _31;
  float _34 = _20 - _32;
  float _36 = $Globals_073z;
  float _37 = $Globals_073w;
  float _38 = _33 * _36;
  float _39 = _34 * _37;
  float _41 = UniformBufferConstants_MaterialCollection0_015z;
  float _42 = UniformBufferConstants_MaterialCollection0_015w;
  float _43 = 1.0f - _39;
  float _44 = _38 * 2.0f;
  float _45 = _43 * 2.0f;
  float _46 = _44 + -1.0f;
  float _47 = _46 * _41;
  float _48 = _42 + 1.0f;
  float _49 = _48 - _45;
  float _50 = _49 + _47;
  float _51 = saturate(_50);
  float _52 = ceil(_51);
  bool _53 = !(_52 == 0.0f);
  float _356;
  float _357;
  float _358;
  if (/* _53 */ false) {
    float _56 = UniformBufferConstants_View_133x;
    float _57 = UniformBufferConstants_View_133y;
    float _58 = _57 / _56;
    float _59 = _58 * _39;
    float _60 = _59 + 0.5f;
    float _61 = _58 * 0.5f;
    float _62 = _60 - _61;
    float _64 = UniformBufferConstants_View_147y;
    float _65 = _64 * -0.02500000037252903f;
    float _67 = UniformBufferConstants_Material_003x;
    float _68 = _67 * _38;
    float _69 = _62 * _67;
    float _70 = _68 + _65;
    float _71 = _69 + _65;
    // _72 = _5;
    // _73 = _9;
    float4 _74 = Material_Texture2D_0.Sample(Material_Wrap_WorldGroupSettings, float2(_70, _71));
    float _75 = _74.x;
    float _76 = _75 + -0.5f;
    float _77 = _76 * 2.0f;
    float _78 = UniformBufferConstants_Material_003y;
    float _79 = _77 * _78;
    float _80 = saturate(_79);
    float _81 = _80 + _38;
    float _82 = _80 + _62;
    float _84 = $Globals_054x;
    float _85 = $Globals_054y;
    float _86 = _84 * _81;
    float _87 = _85 * _82;
    float _89 = $Globals_053x;
    float _90 = $Globals_053y;
    float _91 = _86 + _89;
    float _92 = _87 + _90;
    float _94 = $Globals_055x;
    float _95 = $Globals_055y;
    float _96 = $Globals_055z;
    float _97 = $Globals_055w;
    float _98 = max(_91, _94);
    float _99 = max(_92, _95);
    float _100 = min(_98, _96);
    float _101 = min(_99, _97);
    // _102 = _1;
    // _103 = _7;
    /* This is not in PQ
    also not actual render */
    float4 _104 = PostProcessInput_7_Texture.Sample(PostProcessInput_BilinearSampler, float2(_100, _101));

    float _105 = _104.x;
    float _106 = _104.y;
    float _107 = _104.z;

    float _109 = UniformBufferConstants_Material_006x;
    float _110 = UniformBufferConstants_Material_006y;
    float _111 = UniformBufferConstants_Material_006z;
    float _112 = _109 * _105;
    float _113 = _110 * _106;
    float _114 = _111 * _107;
    float _115 = _56 * _81;
    float _116 = _57 * _82;
    float _118 = UniformBufferConstants_View_132x;
    float _119 = UniformBufferConstants_View_132y;
    float _120 = _115 + _118;
    float _121 = _116 + _119;
    float _123 = UniformBufferConstants_View_136z;
    float _124 = UniformBufferConstants_View_136w;
    float _125 = _120 * _123;
    float _126 = _121 * _124;
    float _128 = UniformBufferConstants_View_137x;
    float _129 = UniformBufferConstants_View_137y;
    float _130 = max(_125, _128);
    float _131 = max(_126, _129);
    float _132 = UniformBufferConstants_View_137z;
    float _133 = UniformBufferConstants_View_137w;
    float _134 = min(_130, _132);
    float _135 = min(_131, _133);
    // _136 = _6;
    // _137 = _10;
    float4 _138 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_134, _135), 0.0f);
    float _139 = _138.x;
    float _141 = UniformBufferConstants_View_075x;
    float _142 = _141 * _139;
    float _143 = UniformBufferConstants_View_075y;
    float _144 = _142 + _143;
    float _145 = UniformBufferConstants_View_075z;
    float _146 = _145 * _139;
    float _147 = UniformBufferConstants_View_075w;
    float _148 = _146 - _147;
    float _149 = 1.0f / _148;
    float _150 = _144 + _149;
    float _152 = UniformBufferConstants_Material_007x;
    float _153 = _152 * _150;
    float _154 = _153 * _153;
    float _155 = _154 * 1.442695140838623f;
    float _156 = exp2(_155);
    float _157 = 1.0f / _156;
    float _158 = abs(_150);
    bool _159 = (_158 > 9.999999747378752e-06f);
    bool _160 = (_150 >= 0.0f);
    bool _161 = _160 && _159;
    float _162 = _161 ? _157 : 1.0f;
    float _163 = UniformBufferConstants_Material_007y;
    float _164 = UniformBufferConstants_Material_007z;
    float _165 = UniformBufferConstants_Material_007w;
    float _166 = _112 - _163;
    float _167 = _113 - _164;
    float _168 = _114 - _165;
    float _169 = _162 * _166;
    float _170 = _162 * _167;
    float _171 = _162 * _168;
    float _172 = _169 + _163;
    float _173 = _170 + _164;
    float _174 = _171 + _165;
    float _176 = UniformBufferConstants_Material_008x;
    float _177 = _172 * _176;
    float _178 = _173 * _176;
    float _179 = _174 * _176;
    float _180 = dot(float3(_177, _178, _179), float3(1.0f, 1.0f, 1.0f));
    float _181 = UniformBufferConstants_Material_008y;
    float _182 = _180 - _177;
    float _183 = _180 - _178;
    float _184 = _180 - _179;
    float _185 = _182 * _181;
    float _186 = _183 * _181;
    float _187 = _184 * _181;
    float _188 = _185 + _177;
    float _189 = _186 + _178;
    float _190 = _187 + _179;
    float _191 = UniformBufferConstants_Material_008z;
    float _192 = _191 * _81;
    float _193 = _191 * _82;
    float _194 = _22 / _23;
    float _195 = atan(_194);
    float _196 = _195 + 3.1415927410125732f;
    float _197 = _195 + -3.1415927410125732f;
    bool _198 = (_23 < 0.0f);
    bool _199 = (_23 == 0.0f);
    bool _200 = (_22 >= 0.0f);
    bool _201 = (_22 < 0.0f);
    bool _202 = _200 && _198;
    float _203 = _202 ? _196 : _195;
    bool _204 = _201 && _198;
    float _205 = _204 ? _197 : _203;
    bool _206 = _201 && _199;
    bool _207 = _200 && _199;
    float _208 = _205 * 0.15923567116260529f;
    float _209 = _208 + 0.5f;
    float _210 = _206 ? 0.24987319111824036f : _209;
    float _211 = _207 ? 0.750126838684082f : _210;
    float _212 = UniformBufferConstants_Material_008w;
    float _213 = _211 * _212;
    float _215 = UniformBufferConstants_Material_009x;
    float _216 = _211 * _215;
    float _217 = UniformBufferConstants_Material_009z;
    float _218 = _217 * _27;
    float _219 = _217 * _25;
    float _220 = -0.0f - _218;
    float _221 = -0.0f - _219;
    float _222 = _219 * 50800.0f;
    bool _223 = (_222 < _220);
    float _224 = _223 ? _220 : _218;
    float _225 = _223 ? _221 : _219;
    float _226 = _62 - _224;
    float _227 = _216 - _226;
    float _228 = _192 - _213;
    float _229 = _64 * 0.6283185482025146f;
    float _230 = sin(_229);
    float _231 = UniformBufferConstants_Material_009w;
    float _232 = _231 * _230;
    float _234 = UniformBufferConstants_Material_010x;
    float _235 = _234 * _64;
    float _236 = _228 + _232;
    float _237 = _225 * -50800.0f;
    float _238 = frac(_237);
    float _239 = _238 + _193;
    float _240 = _239 - _227;
    float _241 = _240 + _235;
    // _242 = _4;
    float4 _243 = Material_Texture2D_1.Sample(Material_Wrap_WorldGroupSettings, float2(_236, _241));
    float _244 = _243.x;
    float _245 = _243.y;
    float _246 = _243.z;
    float _247 = UniformBufferConstants_Material_010y;
    float _248 = _247 * _81;
    float _249 = _247 * _82;
    float _250 = _248 - _213;
    float _251 = _249 - _227;
    float _252 = UniformBufferConstants_Material_010z;
    float _253 = _252 * _230;
    float _254 = UniformBufferConstants_Material_010w;
    float _255 = _254 * _64;
    float _256 = _250 + _253;
    float _257 = _251 + _238;
    float _258 = _257 + _255;
    float4 _259 = Material_Texture2D_1.Sample(Material_Wrap_WorldGroupSettings, float2(_256, _258));
    float _260 = _259.x;
    float _261 = _259.y;
    float _262 = _259.z;
    float _263 = _260 + _244;
    float _264 = _261 + _245;
    float _265 = _262 + _246;
    float _267 = UniformBufferConstants_Material_011x;
    float _268 = _267 * _81;
    float _269 = _267 * _82;
    float _270 = _268 - _213;
    float _271 = _269 - _227;
    float _272 = UniformBufferConstants_Material_011y;
    float _273 = _272 * _230;
    float _274 = UniformBufferConstants_Material_011z;
    float _275 = _274 * _64;
    float _276 = _270 + _273;
    float _277 = _271 + _238;
    float _278 = _277 + _275;
    // _279 = _3;
    float4 _280 = Material_Texture2D_2.Sample(Material_Wrap_WorldGroupSettings, float2(_276, _278));
    float _281 = _280.x;
    float _282 = UniformBufferConstants_Material_011w;
    float _283 = _282 * _81;
    float _284 = _282 * _82;
    float _285 = _283 - _213;
    float _286 = _284 - _227;
    float _288 = UniformBufferConstants_Material_012x;
    float _289 = _288 * _230;
    float _290 = UniformBufferConstants_Material_012y;
    float _291 = _290 * _64;
    float _292 = _285 + _289;
    float _293 = _286 + _238;
    float _294 = _293 + _291;
    float4 _295 = Material_Texture2D_2.Sample(Material_Wrap_WorldGroupSettings, float2(_292, _294));
    float _296 = _295.x;
    float _297 = _296 + _281;
    float _298 = _263 + _297;
    float _299 = _264 + _297;
    float _300 = _265 + _297;
    float _301 = _298 * _43;
    float _302 = _299 * _43;
    float _303 = _300 * _43;
    float _304 = _301 + _188;
    float _305 = _302 + _189;
    float _306 = _303 + _190;
    float _307 = UniformBufferConstants_Material_012z;
    float _308 = _307 * _39;
    float _309 = UniformBufferConstants_Material_012w;
    bool _310 = (_308 <= 0.0f);
    float _311 = log2(_308);
    float _312 = _311 * _309;
    float _313 = exp2(_312);
    float _314 = _310 ? 0.0f : _313;
    float _315 = _50 + 1.0f;
    float _316 = _315 * 0.5f;
    float _317 = _316 + -1.0f;
    float _318 = _317 + _314;
    float _319 = saturate(_318);
    float _320 = _172 - _188;
    float _321 = _173 - _189;
    float _322 = _174 - _190;
    float _323 = _319 * _320;
    float _324 = _319 * _321;
    float _325 = _319 * _322;
    float _326 = _304 + _323;
    float _327 = _305 + _324;
    float _328 = _306 + _325;
    _356 = _326;
    _357 = _327;
    _358 = _328;
  } else {
    float _331 = $Globals_005x;
    float _332 = $Globals_005y;
    float _333 = _331 * _38;
    float _334 = _332 * _39;
    float _336 = $Globals_004x;
    float _337 = $Globals_004y;
    float _338 = _333 + _336;
    float _339 = _334 + _337;
    float _341 = $Globals_006x;
    float _342 = $Globals_006y;
    float _343 = $Globals_006z;
    float _344 = $Globals_006w;
    float _345 = max(_338, _341);
    float _346 = max(_339, _342);
    float _347 = min(_345, _343);
    float _348 = min(_346, _344);
    // _349 = _2;
    // _350 = _8;
    float4 _351 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(_347, _348));  // This is in PQ
    // We decode before they attempt to blend
    if (injectedData.toneMapType > 0.f) {
      // We decode before they attempt to blend
      tonemappedRender = PQToDecoded(_351.rgb);
      srgb_input = DecodedTosRGB(tonemappedRender);
      _351.rgb = srgb_input;
    }

    float _352 = _351.x;
    float _353 = _351.y;
    float _354 = _351.z;
    _356 = _352;
    _357 = _353;
    _358 = _354;
  }
  float _360 = UniformBufferConstants_Material_013x;
  float _361 = UniformBufferConstants_Material_013y;
  float _362 = UniformBufferConstants_Material_013z;
  float _363 = UniformBufferConstants_Material_013w;
  float _364 = _361 - _356;
  float _365 = _362 - _357;
  float _366 = _363 - _358;
  float _367 = _364 * _360;
  float _368 = _365 * _360;
  float _369 = _366 * _360;
  float _370 = _367 + _356;
  float _371 = _368 + _357;
  float _372 = _369 + _358;
  float _373 = max(_370, 0.0f);
  float _374 = max(_371, 0.0f);
  float _375 = max(_372, 0.0f);

  post_srgb = float3(_373, _374, _375);

  if (injectedData.toneMapType > 0.f) {
    output = UpgradePostProcess(tonemappedRender, post_srgb);
    return float4(output, 0.f);
  }

  SV_Target.x = _373;
  SV_Target.y = _374;
  SV_Target.z = _375;
  SV_Target.w = 0.0f;
  return SV_Target;
}
