// Mechanically reconstructed from 0x2086B870.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
samplerCUBE s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-0.0f, 0.00999999978f, 0.513724983f, 1.0f);
    const float4 c1 = float4(0.159999996f, -0.150000006f, 0.0599999987f, -0.5f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(1.69000006f, 1.0f, -1.0f, 1.29999995f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = c1;
    r0.xyz = (r1.xyz) * (c[5].www);
    r1.xy = (v4.xy) * (c[8].xx) + (r0.yz);
    r2.xy = (r1.xy) + (c1.ww);
    r1.x = (v4.x) * (c[8].x) + (r0.x);
    r0.xy = (r2.xy) * (c[9].xx) + (-(r1.ww));
    r0 = tex2D(s1, r0.xy);
    r0.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r1.yz = (v4.xy) * (c[8].xx);
    r4.xy = (r0.xy) * (c[10].xx);
    r2.xy = (r1.xz) + (c1.ww);
    r0 = tex2D(s2, r1.yz);
    r1.xy = (r2.xy) * (c[9].xx) + (-(r1.ww));
    r1 = tex2D(s1, r1.xy);
    r3.xy = (r1.wy) * (c2.xy) + (c2.zw);
    r1.xyz = v2.xyz;
    r2.xyz = (r1.zxy) * (v0.yzx);
    r3.xy = (c[10].xx) * (r3.xy) + (r4.xy);
    r1.xyz = (r1.yzx) * (v0.zxy) + (-(r2.xyz));
    r1.xyz = (r3.yyy) * (-(r1.xyz));
    r1.xyz = (r3.xxx) * (v0.xyz) + (r1.xyz);
    r2.xyz = (r1.xyz) + (v2.xyz);
    r1.xyz = normalize(r2.xyz);
    r2.xyz = normalize(-(v1.xyz));
    r0.w = dot(-(r2.xyz), r1.xyz);
    r1.w = (r0.w) * (-(r0.w)) + (c0.w);
    r2.w = (r1.w) * (-(c3.x)) + (c3.y);
    r1.w = max(r2.w, c0.x);
    r1.w = rsqrt(r1.w);
    r2.w = 1.0f / (r1.w);
    r1.w = ((r0.w) >= 0.0f ? (c3.y) : (c3.z));
    r2.w = (r2.w) * (r1.w);
    r1.w = (r0.w) * (c3.w) + (r2.w);
    r3.z = 1.0f / (r1.w);
    r1.w = (r0.w) + (r0.w);
    r2.xyz = (r1.xyz) * (-(r1.www)) + (-(r2.xyz));
    r1.xyz = normalize(v2.xyz);
    r3.w = (r0.w) * (c3.w) + (-(r2.w));
    r1.w = dot(r2.xyz, r1.xyz);
    r3.w = (r3.z) * (r3.w);
    r1.w = ((-(r1.w)) >= 0.0f ? (r1.w) : (c0.x));
    r3.z = (r2.w) * (c3.w) + (r0.w);
    r1.w = (r1.w) + (r1.w);
    r2.w = (r2.w) * (-(c3.w)) + (r0.w);
    r1.xyz = (r1.www) * (-(r1.xyz)) + (r2.xyz);
    r1 = texCUBE(s0, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c[7].xxx);
    r0.xyz = (r0.xyz) * (c0.yyy);
    r1.w = 1.0f / (r3.z);
    r0.xyz = (r1.xyz) * (c0.zzz) + (r0.xyz);
    r1.w = (r2.w) * (r1.w) + (r3.w);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.w = (abs(r1.w)) * (-(c1.w));
    r1.x = v0.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c0.w) : (r1.w));
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r1.x = c0.w;
    r1.w = (r1.x) + (-(c[11].x));
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (r1.w) + (c[11].x);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
