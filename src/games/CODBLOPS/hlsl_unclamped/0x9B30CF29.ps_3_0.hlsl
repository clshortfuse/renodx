// Mechanically reconstructed from 0x9B30CF29.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.25f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, -2.0f, 3.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = (v4.yyyy) * (c[24]);
    r0 = (v4.xxxx) * (c[23]) + (r0);
    r0 = (v4.zzzz) * (c[25]) + (r0);
    r1 = (r0) + (c[26]);
    r3.xy = (r1.ww) * (c[27].xy) + (r1.xy);
    r3.zw = r1.zw;
    r0 = tex2Dproj(s1, r3);
    r2.zw = r3.zw;
    r1.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[27].zw)) + (r1.xy);
    r4.zw = r1.zw;
    r4 = tex2Dproj(s1, r4);
    r0.w = r4.x;
    r2.xy = (r3.ww) * (-(c[27].xy)) + (r1.xy);
    r1.xy = (r3.ww) * (c[27].zw) + (r1.xy);
    r2 = tex2Dproj(s1, r2);
    r0.y = r2.x;
    r2 = tex2Dproj(s1, r1);
    r1 = (v4.xyzx) * (c0.yyyz) + (c0.zzzy);
    r0.z = dot(r1, c[20]);
    r2.w = 1.0f / (r0.z);
    r3.x = dot(r1, c[9]);
    r3.y = dot(r1, c[10]);
    r0.z = r2.x;
    r3.xy = (r2.ww) * (r3.xy);
    r2.x = dot(r1, c[11]);
    r1.xy = (r3.xy) * (c0.ww) + (c0.ww);
    r1 = tex2D(s2, r1.xy);
    r2.y = (r2.x) * (r2.x);
    r1.w = dot(c[7].yz, r2.xy) + (c[7].x);
    r2.xy = saturate((r2.xx) * (c[8].xy) + (c[8].zw));
    r2.w = saturate(1.0f / (r1.w));
    r1.w = ((-abs(r1.w)) >= 0.0f ? (c0.z) : (r2.w));
    r4.xy = (r2.xy) * (r2.xy);
    r5.xy = (r2.xy) * (c2.zz) + (c2.ww);
    r3.xyz = (-(v4.xyz)) + (c[5].xyz);
    r3.w = (r4.x) * (r5.x);
    r2.xyz = normalize(r3.xyz);
    r3.z = (r4.y) * (-(r5.y)) + (c0.y);
    r2.w = dot(r2.xyz, c[21].xyz);
    r1.w = (r1.w) * (r3.w);
    r3.w = saturate((r2.w) * (c[22].x) + (c[22].y));
    r2.w = (r3.w) * (r3.w);
    r3.w = (r3.w) * (c2.z) + (c2.w);
    r1.w = (r3.z) * (r1.w);
    r2.w = (r2.w) * (r3.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r2.w);
    r0.w = dot(r0, c1.wwww);
    r0.xyz = (r1.xyz) * (r1.www);
    r4.xyz = (r0.www) * (r0.xyz);
    r1.xyz = normalize(v2.xyz);
    r0 = tex2D(s0, v1.xy);
    r1.w = (r0.w) * (v0.x) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.z = saturate(dot(r2.xyz, r1.xyz));
    r1 = float4(((r1.w) >= 0.0f ? (r0.x) : (c0.z)), ((r1.w) >= 0.0f ? (r0.y) : (c0.z)), ((r1.w) >= 0.0f ? (r0.z) : (c0.z)), ((r1.w) >= 0.0f ? (r0.w) : (c0.z)));
    r0 = tex2D(s3, v5.xy);
    r2.w = (r0.w) * (v0.y) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r6.xyz = (r2.zzz) * (c[6].xyz);
    r2 = float4(((r2.w) >= 0.0f ? (r0.x) : (r1.x)), ((r2.w) >= 0.0f ? (r0.y) : (r1.y)), ((r2.w) >= 0.0f ? (r0.z) : (r1.z)), ((r2.w) >= 0.0f ? (r0.w) : (r1.w)));
    r0 = tex2D(s4, v5.zw);
    r4.w = (r0.w) * (v0.z) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1.xy = (v1.zw) * (c0.yw);
    r3 = tex2D(s13, r1.xy);
    r1.xy = (v1.zw) * (c0.yw) + (c0.zw);
    r1 = tex2D(s13, r1.xy);
    r3.w = r1.y;
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (r2.x)), ((r4.w) >= 0.0f ? (r0.y) : (r2.y)), ((r4.w) >= 0.0f ? (r0.z) : (r2.z)), ((r4.w) >= 0.0f ? (r0.w) : (r2.w)));
    r2.xy = (r3.yw) * (c1.yy) + (c1.zz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = dot(r2.xy, r2.xy) + (c0.z);
    r2 = tex2D(s14, v1.zw);
    r7.xy = (r2.xy) * (c1.xx);
    r1.w = exp2(-(r1.w));
    r3.xy = (r3.xz) * (r7.xx);
    r1.w = saturate((r1.w) * (c2.x) + (c2.y));
    r2.w = (r2.x) * (c1.x) + (-(r3.x));
    r5.xz = (r3.xy) * (c1.yy);
    r1.xy = (r1.xz) * (r7.yy);
    r2.z = (r3.z) * (-(r7.x)) + (r2.w);
    r2.w = (r2.y) * (c1.x) + (-(r1.x));
    r5.y = (r2.z) + (r2.z);
    r2.w = (r1.z) * (-(r7.y)) + (r2.w);
    r1.xz = (r1.xy) * (c1.yy);
    r1.y = (r2.w) + (r2.w);
    r2.xyz = (r6.xyz) * (r0.xyz);
    r1.xyz = (r1.xyz) * (r1.www) + (r5.xyz);
    r2.xyz = (r4.xyz) * (r2.xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
