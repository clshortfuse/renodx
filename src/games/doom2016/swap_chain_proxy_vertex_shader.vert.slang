#version 450

layout(location = 0) out vec2 uv;

void main()
{
    // Use Vulkan's core VertexIndex directly. Slang's SV_VertexID lowering
    // also reads BaseVertex and declares DrawParameters, but DOOM does not
    // enable shaderDrawParameters on its Vulkan 1.1 device.
    uint id = uint(gl_VertexIndex);
    uv.x = (id == 1u) ? 2.0 : 0.0;
    uv.y = (id == 2u) ? 2.0 : 0.0;
    gl_Position = vec4(
        uv * vec2(2.0, -2.0) + vec2(-1.0, 1.0),
        0.0,
        1.0);
}
