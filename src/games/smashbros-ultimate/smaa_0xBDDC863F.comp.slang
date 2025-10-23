#version 430
layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

layout(constant_id = 4) const float METRIC_WIDTH = 1920.0;
layout(constant_id = 5) const float METRIC_HEIGHT = 1080.0;
layout(constant_id = 0) const int SMAA_PRESET_LOW = 0;
layout(constant_id = 1) const int SMAA_PRESET_MEDIUM = 0;
layout(constant_id = 2) const int SMAA_PRESET_HIGH = 0;
layout(constant_id = 3) const int SMAA_PRESET_ULTRA = 0;

layout(set = 0, binding = 2, std140) uniform invResolution
{
    vec2 invResolution_data;
} _294;

layout(set = 2, binding = 1) uniform sampler2D inputImg;
layout(set = 2, binding = 3) uniform sampler2D samplerBlend;
layout(set = 3, binding = 0, rgba8) uniform writeonly image2D imgOutput;

void SMAANeighborhoodBlendingVS(vec2 texcoord, out vec4 offset)
{
    float _96 = 1.0 / METRIC_WIDTH;
    float _98 = 1.0 / METRIC_HEIGHT;
    offset = fma(vec4(_96, _98, METRIC_WIDTH, METRIC_HEIGHT).xyxy, vec4(1.0, 0.0, 0.0, 1.0), texcoord.xyxy);
}

void SMAAMovc(bvec2 cond, inout vec2 variable, vec2 value)
{
    if (cond.x)
    {
        variable.x = value.x;
    }
    if (cond.y)
    {
        variable.y = value.y;
    }
}

void SMAAMovc(bvec4 cond, inout vec4 variable, vec4 value)
{
    bvec2 param = cond.xy;
    vec2 param_1 = variable.xy;
    vec2 param_2 = value.xy;
    SMAAMovc(param, param_1, param_2);
    variable.x = param_1.x;
    variable.y = param_1.y;
    bvec2 param_3 = cond.zw;
    vec2 param_4 = variable.zw;
    vec2 param_5 = value.zw;
    SMAAMovc(param_3, param_4, param_5);
    variable.z = param_4.x;
    variable.w = param_4.y;
}

vec4 SMAANeighborhoodBlendingPS(vec2 texcoord, vec4 offset, sampler2D colorTex, sampler2D blendTex)
{
    vec4 a;
    a.x = textureLod(blendTex, offset.xy, 0.0).w;
    a.y = textureLod(blendTex, offset.zw, 0.0).y;
    vec2 _122 = textureLod(blendTex, texcoord, 0.0).xz;
    a.w = _122.x;
    a.z = _122.y;
    if (dot(a, vec4(1.0)) < 9.9999997473787516355514526367188e-06)
    {
        vec4 color = textureLod(colorTex, texcoord, 0.0);
        return color;
    }
    else
    {
        bool h = max(a.x, a.z) > max(a.y, a.w);
        vec4 blendingOffset = vec4(0.0, a.y, 0.0, a.w);
        vec2 blendingWeight = a.yw;
        bvec4 param = bvec4(h, h, h, h);
        vec4 param_1 = blendingOffset;
        vec4 param_2 = vec4(a.x, 0.0, a.z, 0.0);
        SMAAMovc(param, param_1, param_2);
        blendingOffset = param_1;
        bvec2 param_3 = bvec2(h, h);
        vec2 param_4 = blendingWeight;
        vec2 param_5 = a.xz;
        SMAAMovc(param_3, param_4, param_5);
        blendingWeight = param_4;
        blendingWeight /= vec2(dot(blendingWeight, vec2(1.0)));
        float _197 = 1.0 / METRIC_WIDTH;
        float _198 = 1.0 / METRIC_HEIGHT;
        float _201 = 1.0 / METRIC_WIDTH;
        float _202 = 1.0 / METRIC_HEIGHT;
        vec4 blendingCoord = fma(blendingOffset, vec4(vec4(_197, _198, METRIC_WIDTH, METRIC_HEIGHT).xy, -vec4(_201, _202, METRIC_WIDTH, METRIC_HEIGHT).xy), texcoord.xyxy);
        vec4 color_1 = textureLod(colorTex, blendingCoord.xy, 0.0) * blendingWeight.x;
        color_1 += (textureLod(colorTex, blendingCoord.zw, 0.0) * blendingWeight.y);
        return color_1;
    }
}

void main()
{
    vec2 loc = vec2(ivec2(int(gl_GlobalInvocationID.x * 4u), int(gl_GlobalInvocationID.y * 4u)));
    vec4 param_1;
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            ivec2 texelCoord = ivec2(int(loc.x + float(i)), int(loc.y + float(j)));
            vec2 coord = (vec2(texelCoord) + vec2(0.5)) / _294.invResolution_data;
            vec2 param = coord;
            SMAANeighborhoodBlendingVS(param, param_1);
            vec4 offset = param_1;
            vec2 param_2 = coord;
            vec4 param_3 = offset;
            vec4 oColor = SMAANeighborhoodBlendingPS(param_2, param_3, inputImg, samplerBlend);
            imageStore(imgOutput, texelCoord, oColor);
        }
    }
}

