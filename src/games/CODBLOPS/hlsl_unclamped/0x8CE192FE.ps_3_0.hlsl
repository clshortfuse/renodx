// Mechanically reconstructed from 0x8CE192FE.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD4;
    float4 v3 : TEXCOORD5;
    float4 v4 : COLOR0;
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
    const float4 c0 = float4(31.875f, 1.0f, 0.0f, 0.5f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v0.xy);
    r2.xyz = (-(v5.xyz)) + (c[6].xyz);
    r1.xyz = normalize(r2.xyz);
    r0.xyz = (r0.xyz) * (c[24].xyz);
    r1.w = dot(r1.xyz, c[22].xyz);
    r2.z = saturate((r1.w) * (c[23].x) + (c[23].y));
    r1 = (v5.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.w = (r2.z) * (r2.z);
    r2.x = dot(r1, c[20]);
    r2.z = (r2.z) * (c1.x) + (c1.y);
    r2.y = (r2.x) * (r2.x);
    r2.w = (r2.w) * (r2.z);
    r2.z = dot(c[8].yz, r2.xy) + (c[8].x);
    r3.xy = saturate((r2.xx) * (c[9].xy) + (c[9].zw));
    r3.w = saturate(1.0f / (r2.z));
    r2.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c1.xx) + (c1.yy);
    r3.w = ((-abs(r2.z)) >= 0.0f ? (c0.z) : (r3.w));
    r2.x = (r2.x) * (r3.x);
    r3.z = (r2.y) * (-(r3.y)) + (c0.y);
    r2.z = dot(r1, c[21]);
    r3.w = (r3.w) * (r2.x);
    r2.z = 1.0f / (r2.z);
    r2.x = dot(r1, c[10]);
    r2.y = dot(r1, c[11]);
    r1.w = (r3.z) * (r3.w);
    r1.xy = (r2.zz) * (r2.xy);
    r2.w = (r2.w) * (r1.w);
    r1.xy = (r1.xy) * (c0.ww) + (c0.ww);
    r1 = tex2D(s1, r1.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r2.www) * (r1.xyz);
    r3.xyz = normalize(v1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.w = max(abs(r3.y), abs(r3.z));
    r4.xyz = (r0.xyz) * (c[7].xyz);
    r1.w = max(abs(r3.x), r2.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r3.xyz) * (c[5].xyz);
    r2.w = saturate(dot(r3.xyz, c[17].xyz));
    r1.xyz = (r1.xyz) * (r1.www) + (v2.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.w = (r2.w) * (r1.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (c[26].x) + (c[26].y);
    r3.xyz = (r1.xyz) * (v0.zzz);
    r1.xyz = (r1.www) * (c[18].xyz);
    r3.xyz = (r3.xyz) * (c0.xxx);
    r2.xyz = (r2.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (v4.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[25].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = saturate((r0.w) + (r0.w));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
