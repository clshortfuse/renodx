// Mechanically reconstructed from 0x27140E47.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD4;
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.5f, -0.0f);
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

    r0.xy = (v0.zw) * (c0.yz);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c0.yz) + (c0.wz);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r1.xy = (r2.yw) * (c1.yy) + (c1.zz);
    r0.w = dot(r1.xy, r1.xy) + (c0.w);
    r1 = tex2D(s14, v0.zw);
    r4.xy = (r1.xy) * (c1.xx);
    r0.w = exp2(-(r0.w));
    r2.xy = (r2.xz) * (r4.xx);
    r2.w = saturate((r0.w) * (c2.x) + (c2.y));
    r0.w = (r1.x) * (c1.x) + (-(r2.x));
    r3.xz = (r2.xy) * (c1.yy);
    r0.xy = (r0.xz) * (r4.yy);
    r1.w = (r2.z) * (-(r4.x)) + (r0.w);
    r0.w = (r1.y) * (c1.x) + (-(r0.x));
    r3.y = (r1.w) + (r1.w);
    r0.w = (r0.z) * (-(r4.y)) + (r0.w);
    r2.xz = (r0.xy) * (c1.yy);
    r2.y = (r0.w) + (r0.w);
    r0.xy = (v3.ww) * (c[26].xy) + (v3.xy);
    r0.zw = v3.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v3.ww) * (-(c[26].xy)) + (v3.xy);
    r1.zw = v3.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v3.ww) * (c[26].zw) + (v3.xy);
    r1.zw = v3.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v3.ww) * (-(c[26].zw)) + (v3.xy);
    r1.zw = v3.zw;
    r1 = tex2Dproj(s1, r1);
    r0.w = r1.x;
    r5.xyz = (r2.xyz) * (r2.www) + (r3.xyz);
    r1.w = dot(r0, c1.wwww);
    r0 = tex2D(s12, v0.zw);
    r1.xyz = (-(v4.xyz)) + (c[20].xyz);
    r2.y = dot(r1.xyz, r1.xyz);
    r0.z = rsqrt(r2.y);
    r6.xyz = (r1.xyz) * (r0.zzz);
    r0.w = dot(r6.xyz, c[22].xyz);
    r0.w = saturate((r0.w) * (c[23].x) + (c[23].y));
    r2.x = 1.0f / (r0.z);
    r0.w = (r0.w) * (c[23].w);
    r4.w = lerp(r0.y, r1.w, r0.w);
    r1.xy = saturate((r2.xx) * (c[25].xy) + (c[25].zw));
    r0.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c2.zz) + (c2.ww);
    r0.w = dot(c[24].yz, r2.xy) + (c[24].x);
    r4.xy = (r0.xy) * (r1.xy);
    r4.z = (r0.w) * (r4.x);
    r3 = (-(v4.yyyy)) + (c[6]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[5]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[7]);
    r4.z = (r4.y) * (r4.z);
    r0 = (r1) * (r1) + (r0);
    r5.w = (r4.w) * (r4.z);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r7.xyz = normalize(v1.xyz);
    r3 = (r3) * (r4);
    r3 = (r7.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r7.xxxx) + (r3);
    r3.z = c0.y;
    r0 = saturate((r0) * (c[8]) + (r3.zzzz));
    r1 = saturate((r1) * (r7.zzzz) + (r2));
    r2.w = saturate(dot(r6.xyz, r7.xyz));
    r0 = (r0) * (r1);
    r4.xyz = (r2.www) * (c[21].xyz);
    r3.x = dot(c[9], r0);
    r2 = tex2D(s0, v0.xy);
    r1 = tex2D(s2, v5.zw);
    r1.w = (r1.w) * (v5.y) + (c0.x);
    r3.y = dot(c[10], r0);
    r1.xyz = float3(((r1.w) >= 0.0f ? (r1.x) : (r2.x)), ((r1.w) >= 0.0f ? (r1.y) : (r2.y)), ((r1.w) >= 0.0f ? (r1.z) : (r2.z)));
    r3.z = dot(c[11], r0);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r5.www) * (r4.xyz) + (r5.xyz);
    r2.xyz = (r3.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[27].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
