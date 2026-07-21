// Mechanically reconstructed from 0x4178D4F8.ps_3_0.cso.
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
    const float4 c0 = float4(0.159999996f, -0.150000006f, 0.0599999987f, -0.5f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(0.00999999978f, 1.0f, 1.69000006f, -1.0f);
    const float4 c3 = float4(0.0f, 1.29999995f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = c0;
    r0.xyz = (r0.xyz) * (c[5].www);
    r1.xy = (v4.xy) * (c[7].xx) + (r0.yz);
    r1.xy = (r1.xy) + (c0.ww);
    r0.x = (v4.x) * (c[7].x) + (r0.x);
    r1.xy = (r1.xy) * (c[8].xx) + (-(r0.ww));
    r1 = tex2D(s0, r1.xy);
    r1.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r0.yz = (v4.xy) * (c[7].xx);
    r4.xy = (r1.xy) * (c[9].xx);
    r2.xy = (r0.xz) + (c0.ww);
    r1 = tex2D(s1, r0.yz);
    r0.xy = (r2.xy) * (c[8].xx) + (-(r0.ww));
    r0 = tex2D(s0, r0.xy);
    r3.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = v0;
    r2.xyz = (r0.yzx) * (v2.zxy);
    r3.xy = (c[9].xx) * (r3.xy) + (r4.xy);
    r0.xyz = (v2.yzx) * (r0.zxy) + (-(r2.xyz));
    r0.xyz = (r3.yyy) * (-(r0.xyz));
    r0.xyz = (r3.xxx) * (v0.xyz) + (r0.xyz);
    r2.xyz = (r0.xyz) + (v2.xyz);
    r0.xyz = normalize(r2.xyz);
    r2.xyz = normalize(-(v1.xyz));
    r0.z = dot(r0.xyz, -(r2.xyz));
    r0.y = (r0.z) * (-(r0.z)) + (c2.y);
    r1.w = (r0.y) * (-(c2.z)) + (c2.y);
    r0.y = max(r1.w, c3.x);
    r0.y = rsqrt(r0.y);
    r0.x = 1.0f / (r0.y);
    r0.y = ((r0.z) >= 0.0f ? (c2.y) : (c2.w));
    r0.y = (r0.x) * (r0.y);
    r0.x = (r0.z) * (c3.y) + (r0.y);
    r1.w = 1.0f / (r0.x);
    r0.x = (r0.z) * (c3.y) + (-(r0.y));
    r1.w = (r1.w) * (r0.x);
    r0.x = (r0.y) * (c3.y) + (r0.z);
    r0.y = (r0.y) * (-(c3.y)) + (r0.z);
    r0.x = 1.0f / (r0.x);
    r0.y = (r0.y) * (r0.x) + (r1.w);
    r0.y = (abs(r0.y)) * (-(c0.w));
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c2.y) : (r0.y));
    r0.y = c2.y;
    r0.y = (r0.y) + (-(c[10].x));
    r1.w = (r0.z) * (r0.y) + (c[10].x);
    r0.xyz = (r1.xyz) * (c2.xxx);
    r0.xyz = (r0.xyz) * (r1.www) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r1.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
