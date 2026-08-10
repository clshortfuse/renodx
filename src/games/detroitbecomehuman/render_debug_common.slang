#ifndef SRC_DETROITBECOMEHUMAN_RENDER_DEBUG_COMMON_SLANG_
#define SRC_DETROITBECOMEHUMAN_RENDER_DEBUG_COMMON_SLANG_

// Keep these values synchronized with render_debug.hpp.
const uint RENDER_DEBUG_MODE_OFF = 0u;
const uint RENDER_DEBUG_MODE_SINGLE = 1u;
const uint RENDER_DEBUG_MODE_DASHBOARD = 2u;

const uint RENDER_DEBUG_SOURCE_NONE = 0u;
const uint RENDER_DEBUG_SOURCE_DOF_COARSE_COC = 1u;
const uint RENDER_DEBUG_SOURCE_DOF_FULL_COC = 2u;
const uint RENDER_DEBUG_SOURCE_DOF_NEAR = 3u;
const uint RENDER_DEBUG_SOURCE_DOF_FAR = 4u;
const uint RENDER_DEBUG_SOURCE_DOF_GATHER_FILL = 5u;
const uint RENDER_DEBUG_SOURCE_TAA_DEPTH = 6u;
const uint RENDER_DEBUG_SOURCE_TAA_MOTION = 7u;
const uint RENDER_DEBUG_SOURCE_TAA_HISTORY = 8u;
const uint RENDER_DEBUG_SOURCE_SCENE_BEFORE_GRADE = 9u;
const uint RENDER_DEBUG_SOURCE_SCENE_AFTER_GRADE = 10u;
const uint RENDER_DEBUG_SOURCE_SCENE_LUMINANCE = 11u;
const uint RENDER_DEBUG_SOURCE_GTAO = 12u;
const uint RENDER_DEBUG_SOURCE_LIGHTING_DIFFUSE = 13u;
const uint RENDER_DEBUG_SOURCE_LIGHTING_SPECULAR = 14u;
const uint RENDER_DEBUG_SOURCE_RETINAL_FIXATION = 15u;
const uint RENDER_DEBUG_SOURCE_RETINAL_ECCENTRICITY = 16u;
const uint RENDER_DEBUG_SOURCE_RETINAL_NYQUIST = 17u;
const uint RENDER_DEBUG_SOURCE_RETINAL_RADIUS = 18u;
const uint RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTROL = 19u;
const uint RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTRIBUTION = 20u;

const uint RENDER_DEBUG_CHANNEL_AUTO = 0u;
const uint RENDER_DEBUG_CHANNEL_RGB = 1u;
const uint RENDER_DEBUG_CHANNEL_RED = 2u;
const uint RENDER_DEBUG_CHANNEL_GREEN = 3u;
const uint RENDER_DEBUG_CHANNEL_BLUE = 4u;
const uint RENDER_DEBUG_CHANNEL_ALPHA = 5u;
const uint RENDER_DEBUG_CHANNEL_LUMINANCE = 6u;
const uint RENDER_DEBUG_CHANNEL_VECTOR = 7u;

const uint RENDER_DEBUG_MAPPING_AUTO = 0u;
const uint RENDER_DEBUG_MAPPING_LINEAR = 1u;
const uint RENDER_DEBUG_MAPPING_SIGNED = 2u;
const uint RENDER_DEBUG_MAPPING_LOG2 = 3u;

const uint RENDER_DEBUG_PASS_TEMPORAL = 1u;
const uint RENDER_DEBUG_PASS_DOF = 2u;
const uint RENDER_DEBUG_PASS_SCENE = 4u;

uint RenderDebugBits()
{
    return floatBitsToUint(shader_injection.scene_path_active);
}

uint RenderDebugMode()
{
    return RenderDebugBits() & 0x3u;
}

bool RenderDebugActive()
{
    return RenderDebugMode() != RENDER_DEBUG_MODE_OFF;
}

uint RenderDebugPanelCount()
{
    return RenderDebugMode() == RENDER_DEBUG_MODE_SINGLE ? 1u
        : RenderDebugMode() == RENDER_DEBUG_MODE_DASHBOARD ? 3u
        : 0u;
}

uint RenderDebugPanelIndex(ivec2 pixel, ivec2 outputSize)
{
    if (RenderDebugPanelCount() <= 1u || outputSize.x <= 0)
    {
        return 0u;
    }
    return min(uint((pixel.x * 3) / outputSize.x), 2u);
}

uint RenderDebugSource(uint panelIndex)
{
    uint shift = 2u + min(panelIndex, 2u) * 5u;
    return (RenderDebugBits() >> shift) & 0x1Fu;
}

uint RenderDebugSourceAtPixel(ivec2 pixel, ivec2 outputSize)
{
    return RenderDebugSource(RenderDebugPanelIndex(pixel, outputSize));
}

uint RenderDebugChannel()
{
    return (RenderDebugBits() >> 17u) & 0x7u;
}

uint RenderDebugMapping()
{
    return (RenderDebugBits() >> 20u) & 0x3u;
}

float RenderDebugOpacity()
{
    return float((RenderDebugBits() >> 22u) & 0x3Fu) / 63.0;
}

bool RenderDebugTemporalUnavailable()
{
    return ((RenderDebugBits() >> 28u) & 0x1u) != 0u;
}

bool RenderDebugShowFixation()
{
    return ((RenderDebugBits() >> 29u) & 0x1u) != 0u;
}

uint RenderDebugProducerPass(uint source)
{
    if (source >= RENDER_DEBUG_SOURCE_TAA_DEPTH
        && source <= RENDER_DEBUG_SOURCE_TAA_HISTORY)
    {
        return RENDER_DEBUG_PASS_TEMPORAL;
    }
    if ((source >= RENDER_DEBUG_SOURCE_DOF_COARSE_COC
         && source <= RENDER_DEBUG_SOURCE_DOF_GATHER_FILL)
        || source == RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTROL
        || source == RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTRIBUTION)
    {
        return RENDER_DEBUG_PASS_DOF;
    }
    return RENDER_DEBUG_PASS_SCENE;
}

bool RenderDebugSourceAvailable(uint source)
{
    return (source >= RENDER_DEBUG_SOURCE_DOF_COARSE_COC
            && source <= RENDER_DEBUG_SOURCE_SCENE_LUMINANCE)
        || source == RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTROL
        || source == RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTRIBUTION;
}

bool RenderDebugGenerateAtPass(uint source, uint pass)
{
    return RenderDebugActive()
        && RenderDebugSourceAvailable(source)
        && RenderDebugProducerPass(source) == pass;
}

bool RenderDebugAnySourceAtPass(uint pass)
{
    uint panelCount = RenderDebugPanelCount();
    for (uint panel = 0u; panel < panelCount; ++panel)
    {
        if (RenderDebugGenerateAtPass(RenderDebugSource(panel), pass))
        {
            return true;
        }
    }
    return false;
}

bool RenderDebugPreserveAtPass(uint source, uint pass)
{
    return RenderDebugActive()
        && RenderDebugSourceAvailable(source)
        && RenderDebugProducerPass(source) < pass;
}

bool RenderDebugShowUnavailableAtScene(uint source, uint pass)
{
    return RenderDebugActive()
        && pass == RENDER_DEBUG_PASS_SCENE
        && source != RENDER_DEBUG_SOURCE_NONE
        && !RenderDebugSourceAvailable(source);
}

uint RenderDebugDefaultChannel(uint source)
{
    if (source == RENDER_DEBUG_SOURCE_DOF_NEAR
        || source == RENDER_DEBUG_SOURCE_DOF_FAR)
    {
        return RENDER_DEBUG_CHANNEL_ALPHA;
    }
    if (source == RENDER_DEBUG_SOURCE_TAA_MOTION)
    {
        return RENDER_DEBUG_CHANNEL_VECTOR;
    }
    if (source == RENDER_DEBUG_SOURCE_SCENE_LUMINANCE)
    {
        return RENDER_DEBUG_CHANNEL_LUMINANCE;
    }
    if (source == RENDER_DEBUG_SOURCE_TAA_DEPTH)
    {
        return RENDER_DEBUG_CHANNEL_RED;
    }
    if (source == RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTROL
        || source == RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTRIBUTION)
    {
        return RENDER_DEBUG_CHANNEL_RED;
    }
    return RENDER_DEBUG_CHANNEL_RGB;
}

uint RenderDebugResolvedChannel(uint source)
{
    uint channel = RenderDebugChannel();
    return channel == RENDER_DEBUG_CHANNEL_AUTO
        ? RenderDebugDefaultChannel(source)
        : channel;
}

uint RenderDebugDefaultMapping(uint source)
{
    if (source == RENDER_DEBUG_SOURCE_DOF_COARSE_COC
        || source == RENDER_DEBUG_SOURCE_DOF_FULL_COC
        || source == RENDER_DEBUG_SOURCE_TAA_MOTION)
    {
        return RENDER_DEBUG_MAPPING_SIGNED;
    }
    if (source == RENDER_DEBUG_SOURCE_TAA_DEPTH
        || source == RENDER_DEBUG_SOURCE_SCENE_LUMINANCE)
    {
        return RENDER_DEBUG_MAPPING_LOG2;
    }
    return RENDER_DEBUG_MAPPING_LINEAR;
}

uint RenderDebugResolvedMapping(uint source)
{
    uint mapping = RenderDebugMapping();
    return mapping == RENDER_DEBUG_MAPPING_AUTO
        ? RenderDebugDefaultMapping(source)
        : mapping;
}

vec2 RenderDebugDefaultRange(uint source)
{
    if (source == RENDER_DEBUG_SOURCE_DOF_COARSE_COC
        || source == RENDER_DEBUG_SOURCE_DOF_FULL_COC)
    {
        return vec2(-16.0, 16.0);
    }
    if (source == RENDER_DEBUG_SOURCE_TAA_DEPTH)
    {
        return vec2(-4.0, 12.0);
    }
    if (source == RENDER_DEBUG_SOURCE_TAA_MOTION)
    {
        return vec2(-1.0, 1.0);
    }
    if (source == RENDER_DEBUG_SOURCE_SCENE_LUMINANCE)
    {
        return vec2(-10.0, 6.0);
    }
    if (source == RENDER_DEBUG_SOURCE_DOF_VANILLA_TRANSITION_CONTROL)
    {
        return vec2(0.0, 1.0);
    }
    return vec2(0.0, 1.0);
}

float RenderDebugLuminance(vec3 color)
{
    return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

float RenderDebugScalar(vec4 value, uint channel)
{
    if (channel == RENDER_DEBUG_CHANNEL_GREEN) return value.y;
    if (channel == RENDER_DEBUG_CHANNEL_BLUE) return value.z;
    if (channel == RENDER_DEBUG_CHANNEL_ALPHA) return value.w;
    if (channel == RENDER_DEBUG_CHANNEL_LUMINANCE)
    {
        return RenderDebugLuminance(value.xyz);
    }
    return value.x;
}

vec3 RenderDebugHeat(float value)
{
    float t = clamp(value, 0.0, 1.0);
    return clamp(
        vec3(
            1.5 - abs(4.0 * t - 3.0),
            1.5 - abs(4.0 * t - 2.0),
            1.5 - abs(4.0 * t - 1.0)),
        vec3(0.0),
        vec3(1.0));
}

vec3 RenderDebugSigned(float value, float extent)
{
    float normalized = clamp(value / max(abs(extent), 1e-6), -1.0, 1.0);
    vec3 negative = vec3(0.05, 0.25, 1.0);
    vec3 neutral = vec3(0.08);
    vec3 positive = vec3(1.0, 0.2, 0.05);
    return normalized < 0.0
        ? mix(neutral, negative, vec3(-normalized))
        : mix(neutral, positive, vec3(normalized));
}

vec3 RenderDebugHsvToRgb(vec3 hsv)
{
    vec3 p = abs(fract(hsv.xxx + vec3(0.0, 2.0 / 3.0, 1.0 / 3.0))
        * 6.0 - 3.0);
    return hsv.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), hsv.y);
}

vec3 RenderDebugMotion(vec2 motion)
{
    float angle = atan(motion.y, motion.x) / 6.283185307179586 + 0.5;
    float magnitude = clamp(length(motion), 0.0, 1.0);
    return RenderDebugHsvToRgb(vec3(angle, magnitude > 0.0 ? 1.0 : 0.0,
        sqrt(magnitude)));
}

vec3 RenderDebugUnavailable(ivec2 pixel)
{
    bool alternate = (((pixel.x >> 4) ^ (pixel.y >> 4)) & 1) != 0;
    return alternate ? vec3(1.0, 0.0, 1.0) : vec3(0.08, 0.0, 0.08);
}

vec3 RenderDebugMap(vec4 value, uint source)
{
    if (source == RENDER_DEBUG_SOURCE_DOF_GATHER_FILL)
    {
        // Near coverage is blue, far coverage is red. Their overlap is
        // magenta, making the exact composite inputs visible at a glance.
        return clamp(vec3(value.y, 0.0, value.x), vec3(0.0), vec3(1.0));
    }
    uint channel = RenderDebugResolvedChannel(source);
    uint mapping = RenderDebugResolvedMapping(source);
    vec2 range = RenderDebugDefaultRange(source);

    if (channel == RENDER_DEBUG_CHANNEL_RGB
        && mapping == RENDER_DEBUG_MAPPING_LINEAR)
    {
        return clamp(value.xyz, vec3(range.x), vec3(range.y));
    }
    if (channel == RENDER_DEBUG_CHANNEL_VECTOR)
    {
        return RenderDebugMotion(value.xy);
    }

    float scalar = RenderDebugScalar(value, channel);
    if (source == RENDER_DEBUG_SOURCE_DOF_COARSE_COC)
    {
        // Detroit stores near and far maxima in x and y respectively.
        scalar = value.y * 16.0 - value.x * 16.0;
    }
    if (mapping == RENDER_DEBUG_MAPPING_LOG2)
    {
        scalar = log2(max(abs(scalar), exp2(range.x)));
    }
    if (mapping == RENDER_DEBUG_MAPPING_SIGNED)
    {
        return RenderDebugSigned(scalar, max(abs(range.x), abs(range.y)));
    }
    return RenderDebugHeat((scalar - range.x) / max(range.y - range.x, 1e-6));
}

vec3 RenderDebugBlend(vec3 baseColor, vec3 diagnosticColor)
{
    return mix(baseColor, diagnosticColor, vec3(RenderDebugOpacity()));
}

bool RenderDebugSeparatorPixel(ivec2 pixel, ivec2 outputSize)
{
    if (RenderDebugPanelCount() != 3u || outputSize.x <= 0) return false;
    int first = outputSize.x / 3;
    int second = (outputSize.x * 2) / 3;
    return abs(pixel.x - first) <= 1 || abs(pixel.x - second) <= 1;
}

#endif  // SRC_DETROITBECOMEHUMAN_RENDER_DEBUG_COMMON_SLANG_
