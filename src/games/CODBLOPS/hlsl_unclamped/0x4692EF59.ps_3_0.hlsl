// Mechanically reconstructed from 0x4692EF59.ps_3_0.cso.
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
    float4 v4 : TEXCOORD8;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(1.0f, 0.0f, -2.0f, 3.0f);
    const float4 c1 = float4(0.5f, 31.875f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v0.xy);
    r2.xyz = (-(v4.xyz)) + (c[21].xyz);
    r1.xyz = normalize(r2.xyz);
    r0.xyz = (r0.xyz) * (c[31].xyz);
    r1.w = dot(r1.xyz, c[29].xyz);
    r2.z = saturate((r1.w) * (c[30].x) + (c[30].y));
    r1 = (v4.xyzx) * (c0.xxxy) + (c0.yyyx);
    r2.w = (r2.z) * (r2.z);
    r2.x = dot(r1, c[27]);
    r2.z = (r2.z) * (c0.z) + (c0.w);
    r2.y = (r2.x) * (r2.x);
    r2.w = (r2.w) * (r2.z);
    r2.z = dot(c[23].yz, r2.xy) + (c[23].x);
    r3.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r3.w = saturate(1.0f / (r2.z));
    r2.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c0.zz) + (c0.ww);
    r3.w = ((-abs(r2.z)) >= 0.0f ? (c0.y) : (r3.w));
    r2.x = (r2.x) * (r3.x);
    r3.z = (r2.y) * (-(r3.y)) + (c0.x);
    r2.z = dot(r1, c[28]);
    r3.w = (r3.w) * (r2.x);
    r2.z = 1.0f / (r2.z);
    r2.x = dot(r1, c[25]);
    r2.y = dot(r1, c[26]);
    r1.w = (r3.z) * (r3.w);
    r1.xy = (r2.zz) * (r2.xy);
    r2.w = (r2.w) * (r1.w);
    r1.xy = (r1.xy) * (c1.xx) + (c1.xx);
    r1 = tex2D(s1, r1.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r2.www) * (r1.xyz);
    r1.xyz = normalize(v1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.w = max(abs(r1.y), abs(r1.z));
    r3.xyz = (r0.xyz) * (c[22].xyz);
    r2.w = max(abs(r1.x), r3.w);
    r1.xyz = (r1.xyz) * (c[5].xyz);
    r1.w = 1.0f / (r2.w);
    r3.xyz = (r2.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (r1.www) + (v2.xyz);
    r1 = tex3D(s11, r1.xyz);
    r4.xyz = (r1.xyz) * (r1.xyz);
    r1 = (-(v4.yyyy)) + (c[7]);
    r2 = (r1) * (r1);
    r1 = (-(v4.xxxx)) + (c[6]);
    r2 = (r1) * (r1) + (r2);
    r1 = (-(v4.zzzz)) + (c[8]);
    r4.xyz = (r4.xyz) * (v0.zzz);
    r1 = (r1) * (r1) + (r2);
    r2.xyz = (r0.xyz) * (r4.xyz);
    r2.w = c0.x;
    r1 = saturate((r1) * (c[9]) + (r2.wwww));
    r3.xyz = (r2.xyz) * (c1.yyy) + (r3.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = saturate((r0.w) + (r0.w));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
