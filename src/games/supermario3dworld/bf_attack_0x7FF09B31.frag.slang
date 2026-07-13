// #version 450

// layout(set = 0, binding = 0, std140) uniform support_buffer
// {
//     uint _m0;
//     uint _m1[8];
//     vec4 _m2;
//     vec4 _m3;
//     int _m4;
//     float _m5[73];
//     ivec4 _m6;
//     int _m7;
// } support_buffer_1;

// layout(set = 0, binding = 23, std140) uniform fp_c4
// {
//     vec4 _m0[4096];
// } fp_c4_1;

// layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_16;
// layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_14;
// layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_8;
// layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_10;
// layout(set = 2, binding = 132) uniform sampler3D fp_t_tcb_C;

// layout(location = 2) in vec4 _38;
// layout(location = 1) in vec4 _40;
// layout(location = 0) in vec4 _42;
// layout(location = 3) in vec4 _44;
// layout(location = 5) in vec4 _46;
// layout(location = 4) in vec4 _48;
// layout(location = 6) in vec4 _50;
// layout(location = 0) out vec4 _53;

// void main()
// {
//     float _60 = _38.x;
//     float _62 = _38.y;
//     vec2 _66 = texture(fp_t_tcb_16, vec2(_60, _62)).xy;
//     float _68 = _66.x;
//     float _70 = _66.y;
//     float _72 = _40.x;
//     float _74 = _40.y;
//     precise float _275 = _68 + (-0.501960813999176025390625);
//     float _76 = _275;
//     precise float _277 = _70 + (-0.501960813999176025390625);
//     float _78 = _277;
//     float _80 = fma(_76, fp_c4_1._m0[2].x, _72);
//     float _82 = fma(_78, fp_c4_1._m0[2].x, _74);
//     vec2 _84 = texture(fp_t_tcb_14, vec2(_80, _82)).xy;
//     float _86 = _84.x;
//     float _88 = _84.y;
//     float _90 = _42.x;
//     float _92 = _42.y;
//     precise float _306 = _86 + (-0.501960813999176025390625);
//     float _94 = _306;
//     precise float _308 = _88 + (-0.501960813999176025390625);
//     float _96 = _308;
//     precise float _313 = _94 * fp_c4_1._m0[1].w;
//     float _98 = _313;
//     precise float _317 = _96 * fp_c4_1._m0[1].w;
//     float _100 = _317;
//     precise float _320 = _98 + _90;
//     float _102 = _320;
//     precise float _323 = _100 + _92;
//     float _104 = _323;
//     vec4 _107 = texture(fp_t_tcb_8, vec2(_102, _104)).xyzw;
//     float _109 = _107.x;
//     float _111 = _107.y;
//     float _113 = _107.z;
//     float _115 = _107.w;
//     bool _119 = _100 != 0.0;
//     bool _121 = isnan(_100);
//     bool _123 = _119 || _121;
//     bool _125 = isnan(0.0);
//     bool _127 = _123 || _125;
//     bool _129 = _98 != 0.0;
//     bool _131 = isnan(_98);
//     bool _133 = _129 || _131;
//     bool _135 = isnan(0.0);
//     bool _137 = _133 || _135;
//     bool _139 = _137 || _127;
//     float _141 = _109;
//     float _143 = _111;
//     if (_139)
//     {
//         precise float _371 = _98 * fp_c4_1._m0[2].y;
//         float _145 = _371;
//         precise float _375 = _100 * fp_c4_1._m0[2].y;
//         float _147 = _375;
//         float _149 = fma(_98, fp_c4_1._m0[2].y, _102);
//         float _151 = fma(_100, fp_c4_1._m0[2].y, _104);
//         float _153 = fma(_145, 2.0, _102);
//         float _155 = texture(fp_t_tcb_8, vec2(_149, _151)).y;
//         float _157 = fma(_147, 2.0, _104);
//         float _159 = texture(fp_t_tcb_8, vec2(_153, _157)).x;
//         _141 = _159;
//         _143 = _155;
//     }
//     float _161 = _141;
//     float _163 = _143;
//     vec3 _167 = texture(fp_t_tcb_10, vec2(_102, _104)).xyz;
//     float _169 = _167.x;
//     float _171 = _167.y;
//     float _173 = _167.z;
//     float _175 = _44.w;
//     float _177 = fma(_113, _175, _173);
//     float _179 = fma(_161, _175, _169);
//     float _181 = fma(_163, _175, _171);
//     float _183 = fma(_177, fp_c4_1._m0[4].z, fp_c4_1._m0[4].w);
//     float _185 = fma(_179, fp_c4_1._m0[4].z, fp_c4_1._m0[4].w);
//     float _187 = fma(_181, fp_c4_1._m0[4].z, fp_c4_1._m0[4].w);
//     vec3 _189 = texture(fp_t_tcb_C, vec3(_185, _187, _183)).xyz;
//     float _191 = _189.x;
//     float _193 = _189.y;
//     float _195 = _189.z;
//     precise float _470 = _102 + (-0.5);
//     float _197 = _470;
//     float _199 = _46.x;
//     precise float _474 = _104 + (-0.5);
//     float _201 = _474;
//     float _203 = _46.y;
//     precise float _479 = _197 * _197;
//     float _205 = _479;
//     float _207 = _48.x;
//     float _209 = fma(_201, _201, _205);
//     float _211 = _48.y;
//     float _213 = abs(_209);
//     float _215 = log2(_213);
//     float _217 = _48.z;
//     float _219 = _50.x;
//     precise float _498 = _215 * 4.0;
//     float _221 = _498;
//     float _223 = exp2(_221);
//     float _225 = clamp(_223, 0.0, 1.0);
//     precise float _506 = _197 * _199;
//     float _227 = _506;
//     float _229 = -_203;
//     float _231 = fma(_201, _229, _227);
//     float _233 = clamp(_231, 0.0, 1.0);
//     precise float _517 = _225 * _207;
//     float _235 = _517;
//     precise float _520 = _225 * _211;
//     float _237 = _520;
//     precise float _523 = _225 * _217;
//     float _239 = _523;
//     precise float _526 = _233 * _235;
//     float _241 = _526;
//     precise float _529 = _233 * _237;
//     float _243 = _529;
//     precise float _532 = _233 * _239;
//     float _245 = _532;
//     float _247 = fma(_241, _219, _191);
//     float _249 = fma(_243, _219, _193);
//     float _251 = fma(_245, _219, _195);
//     _53.x = _247;
//     _53.y = _249;
//     _53.z = _251;
//     _53.w = _115;
// }

#define BF_ATTACK
#include "./common.slang"