// Mechanically reconstructed from 0x245A4321.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(1.0f, -0.5f, 0.999999166f, 0.25f);
    const float4 c1 = float4(6.28318548f, -3.14159274f, -2.52398507e-07f, 2.47609005e-05f);
    const float4 c2 = float4(-0.00138883968f, 0.0416666418f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = c[9].x;
    r0.x = (-(r0.x)) + (c[10].x);
    r0.x = 1.0f / (r0.x);
    r0.y = (-(c[9].x)) + (v3.x);
    r0.x = saturate((r0.x) * (r0.y));
    r0.x = (-(r0.x)) + (c0.x);
    r1.xyz = normalize(v2.xyz);
    r0.y = dot(r1.xyz, r1.xyz);
    r0.y = rsqrt(r0.y);
    r0.y = (r1.z) * (r0.y);
    r1.y = c0.y;
    r0.y = (r0.y) * (r1.y) + (c[5].z);
    r0.y = (r0.y) * (c0.z) + (c0.w);
    r0.y = frac(r0.y);
    r0.y = (r0.y) * (c1.x) + (c1.y);
    r0.y = (r0.y) * (r0.y);
    r0.z = (r0.y) * (c1.z) + (c1.w);
    r0.z = (r0.y) * (r0.z) + (c2.x);
    r0.z = (r0.y) * (r0.z) + (c2.y);
    r0.z = (r0.y) * (r0.z) + (c0.y);
    r0.y = (r0.y) * (r0.z) + (c0.x);
    r0.y = (r0.y) * (c0.y) + (-(c0.y));
    r1 = tex2D(s1, v4.xy);
    r0.z = (r0.y) * (r1.w);
    r1.xyz = (r1.xyz) + (-(c0.yyy));
    oC0.w = (r0.x) * (r0.z);
    r2.xyz = c[7].xyz;
    r0.xzw = (-(r2.xyz)) + (c[8].xyz);
    r0.xyz = (r0.yyy) * (r0.xzw) + (c[7].xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v0.xyz));
    r1.xyz = v0.xyz;
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);

    return oC0;
}
