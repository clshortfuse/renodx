// Mechanically reconstructed from 0x236E1061.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);

struct PS_INPUT
{
    float4 v0 : TEXCOORD2;
    float4 v1 : TEXCOORD3;
    float4 v2 : TEXCOORD5;
    float4 v3 : TEXCOORD6;
    float4 v4 : TEXCOORD7;
    float4 v5 : TEXCOORD8;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-2.0f, 3.0f, 1.0f, 0.25f);
    const float4 c2 = float4(0.75f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v5.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.xyz = (r1.yyy) * (v1.xyz);
    r0.xyz = (r1.xxx) * (v0.xyz) + (r0.xyz);
    r0.xyz = (r0.xyz) + (v3.xyz);
    r1.xyz = normalize(r0.xyz);
    r3.xyz = normalize(-(v2.xyz));
    r0.xyz = (-(v2.xyz)) + (c[5].xyz);
    r0.w = dot(r3.xyz, r1.xyz);
    r5.y = dot(r0.xyz, r0.xyz);
    r0.w = (r0.w) * (-(r0.w)) + (c1.z);
    r2.w = rsqrt(r5.y);
    r0.w = rsqrt(r0.w);
    r5.x = 1.0f / (r2.w);
    r0.w = 1.0f / (r0.w);
    r4.xy = saturate((r5.xx) * (c[8].xy) + (c[8].zw));
    r2.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c1.xx) + (c1.yy);
    r1.w = dot(c[7].yz, r5.xy) + (c[7].x);
    r4.xy = (r2.xy) * (r4.xy);
    r0.w = saturate((r0.w) * (c1.w));
    r1.w = (r1.w) * (r4.x);
    r2.xyz = (r0.xyz) * (r2.www);
    r0.z = (r4.y) * (r1.w);
    r0.xyz = (r0.zzz) * (c[6].xyz);
    r2.w = saturate(dot(r3.xyz, r2.xyz));
    r1.w = saturate(dot(r1.xyz, r2.xyz));
    r1.xyz = (r0.xyz) * (r2.www);
    r0.xyz = (r0.xyz) * (r1.www);
    r1.xyz = (r0.www) * (r1.xyz);
    r1.xyz = (r0.xyz) * (c2.xxx) + (r1.xyz);
    r0 = tex2D(s1, v5.xy);
    r0.xyz = saturate((r1.xyz) * (r0.xyz));
    r1.w = (-(r0.w)) + (c1.z);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.w = (-(r1.w)) + (c1.z);
    r0.xyz = (r0.xyz) * (r0.www) + (-(v4.xyz));
    r1.x = v0.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v4.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
