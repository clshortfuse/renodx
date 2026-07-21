// Mechanically reconstructed from 0x9DA0B0D5.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
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
    const float4 c1 = float4(-0.0f, 0.600000024f, 0.400000006f, 31.875f);
    const float4 c2 = float4(1.0f, 0.5f, -0.0f, 4.0f);
    const float4 c3 = float4(4.0f, -2.0f, 2.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c2.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r2 = tex2D(s13, r0.xy);
    r1.w = r2.y;
    r3.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r0 = tex2D(s1, v1.xy);
    r5.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.z = dot(r3.xy, r3.xy) + (c1.x);
    r0.w = dot(r5.xy, r5.xy) + (c1.x);
    r0.z = exp2(-(r0.z));
    r0.w = exp2(-(r0.w));
    r1.y = (r0.z) * (c1.y) + (c1.z);
    r1.w = (r0.w) * (c1.y) + (c1.z);
    r0 = tex2D(s14, v1.zw);
    r4.xy = (r0.xy) * (c1.ww);
    r1.y = (r1.y) * (r1.w);
    r2.xy = (r2.xz) * (r4.yy);
    r0.w = dot(r3.xy, r5.xy) + (c1.x);
    r0.z = (r0.y) * (c1.w) + (-(r2.x));
    r0.w = saturate((r0.w) * (r1.y) + (r1.y));
    r0.z = (r2.z) * (-(r4.y)) + (r0.z);
    r2.xz = (r2.xy) * (c2.ww);
    r2.y = (r0.z) + (r0.z);
    r2.xyz = (r0.www) * (r2.xyz);
    r1.xy = (r1.xz) * (r4.xx);
    r2.w = (r0.x) * (c1.w) + (-(r1.x));
    r0 = v2;
    r3.xyz = (r5.xxx) * (v5.xyz) + (r0.xyz);
    r0.xz = (r1.ww) * (r1.xy);
    r3.xyz = (r5.yyy) * (v4.xyz) + (r3.xyz);
    r0.y = (r1.z) * (-(r4.x)) + (r2.w);
    r1.xyz = normalize(r3.xyz);
    r0.y = (r1.w) * (r0.y);
    r1.w = saturate(dot(c[17].xyz, r1.xyz));
    r4.xyz = (r0.xyz) * (c3.xzx) + (r2.xyz);
    r3.xyz = (r1.www) * (c[18].xyz);
    r1 = tex2D(s12, v1.zw);
    r2 = tex2D(s0, v1.xy);
    r0.xyz = (r2.xyz) * (v0.xyz);
    r1.xyz = (r1.yyy) * (r3.xyz) + (r4.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[5].w;

    return oC0;
}
