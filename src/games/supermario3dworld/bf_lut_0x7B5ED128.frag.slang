// #version 450

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
// layout(location = 0) out vec4 _47;

// void main()
// {
//     const float flowBias = 0.501960813999176025390625;

//     vec2 uv16 = _38.xy;
//     vec2 flow16 = texture(fp_t_tcb_16, uv16).xy;
//     vec2 uv14 = fma(flow16 - vec2(flowBias), vec2(fp_c4_1._m0[2].x), _40.xy);

//     vec2 flow14 = texture(fp_t_tcb_14, uv14).xy;
//     vec2 flow = (flow14 - vec2(flowBias)) * fp_c4_1._m0[1].w;
//     vec2 uv = flow + _42.xy;

//     vec4 scene = texture(fp_t_tcb_8, uv);

//     bool hasFlow = (flow.x != 0.0) || isnan(flow.x) || (flow.y != 0.0) || isnan(flow.y);
//     if (hasFlow)
//     {
//         vec2 tapOffset = flow * fp_c4_1._m0[2].y;
//         scene.y = texture(fp_t_tcb_8, uv + tapOffset).y;
//         scene.x = texture(fp_t_tcb_8, uv + tapOffset * 2.0).x;
//     }

//     vec3 bloom = texture(fp_t_tcb_10, uv).xyz;
//     float strength = _44.w;

//     vec3 combined = scene.xyz * strength + bloom;

//     vec3 lutCoord = fma(combined, vec3(fp_c4_1._m0[4].z), vec3(fp_c4_1._m0[4].w));
//     vec3 lutColor = texture(fp_t_tcb_C, lutCoord).xyz;
//     _47 = vec4(lutColor, scene.w);
// }

#define BF_LUT_FLOW
#define LUT
#include "./common.slang"