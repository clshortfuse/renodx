// Mechanically reconstructed from 0xE1662E34.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(0.25f, 1.0f, 0.0f, 0.5f);
    const float4 c1 = float4(-2.0f, 3.0f, 31.875f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = (v4.yyyy) * (c[25]);
    r0 = (v4.xxxx) * (c[24]) + (r0);
    r0 = (v4.zzzz) * (c[26]) + (r0);
    r1 = (r0) + (c[27]);
    r3.xy = (r1.ww) * (c[28].xy) + (r1.xy);
    r3.zw = r1.zw;
    r0 = tex2Dproj(s1, r3);
    r2.zw = r3.zw;
    r1.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[28].zw)) + (r1.xy);
    r4.zw = r1.zw;
    r4 = tex2Dproj(s1, r4);
    r0.w = r4.x;
    r2.xy = (r3.ww) * (-(c[28].xy)) + (r1.xy);
    r1.xy = (r3.ww) * (c[28].zw) + (r1.xy);
    r2 = tex2Dproj(s1, r2);
    r0.y = r2.x;
    r2 = tex2Dproj(s1, r1);
    r1 = (v4.xyzx) * (c0.yyyz) + (c0.zzzy);
    r0.z = dot(r1, c[21]);
    r2.w = 1.0f / (r0.z);
    r3.x = dot(r1, c[10]);
    r3.y = dot(r1, c[11]);
    r0.z = r2.x;
    r3.xy = (r2.ww) * (r3.xy);
    r2.x = dot(r1, c[20]);
    r1.xy = (r3.xy) * (c0.ww) + (c0.ww);
    r1 = tex2D(s2, r1.xy);
    r2.y = (r2.x) * (r2.x);
    r1.w = dot(c[8].yz, r2.xy) + (c[8].x);
    r2.xy = saturate((r2.xx) * (c[9].xy) + (c[9].zw));
    r2.w = saturate(1.0f / (r1.w));
    r1.w = ((-abs(r1.w)) >= 0.0f ? (c0.z) : (r2.w));
    r4.xy = (r2.xy) * (r2.xy);
    r5.xy = (r2.xy) * (c1.xx) + (c1.yy);
    r2.xyz = (-(v4.xyz)) + (c[6].xyz);
    r3.w = (r4.x) * (r5.x);
    r3.xyz = normalize(r2.xyz);
    r2.y = (r4.y) * (-(r5.y)) + (c0.y);
    r2.w = dot(r3.xyz, c[22].xyz);
    r1.w = (r1.w) * (r3.w);
    r2.z = saturate((r2.w) * (c[23].x) + (c[23].y));
    r2.w = (r2.z) * (r2.z);
    r2.z = (r2.z) * (c1.x) + (c1.y);
    r1.w = (r2.y) * (r1.w);
    r2.w = (r2.w) * (r2.z);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r2.w);
    r0.w = dot(r0, c0.xxxx);
    r0.xyz = (r1.xyz) * (r1.www);
    r1.xyz = (r0.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = normalize(v2.xyz);
    r0.w = saturate(dot(r3.xyz, r0.xyz));
    r2.w = max(abs(r0.y), abs(r0.z));
    r3.xyz = (r0.www) * (c[7].xyz);
    r1.w = max(abs(r0.x), r2.w);
    r0.xyz = (r0.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.w);
    r3.xyz = (r2.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.zzz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
