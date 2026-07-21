// Mechanically reconstructed from 0xFF5D97A5.ps_3_0.cso.
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
    float4 r8 = 0.0f;
    float4 r9 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c0.yw);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c0.yw) + (c0.zw);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r1.xy = (r2.yw) * (c1.yy) + (c1.zz);
    r0.w = dot(r1.xy, r1.xy) + (c0.z);
    r0.w = exp2(-(r0.w));
    r1 = tex2D(s14, v1.zw);
    r4.xy = (r1.xy) * (c1.xx);
    r3.w = saturate((r0.w) * (c2.x) + (c2.y));
    r2.xy = (r2.xz) * (r4.xx);
    r0.w = (r1.x) * (c1.x) + (-(r2.x));
    r3.xz = (r2.xy) * (c1.yy);
    r0.w = (r2.z) * (-(r4.x)) + (r0.w);
    r0.xy = (r0.xz) * (r4.yy);
    r3.y = (r0.w) + (r0.w);
    r0.w = (r1.y) * (c1.x) + (-(r0.x));
    r2.xz = (r0.xy) * (c1.yy);
    r1.z = (r0.z) * (-(r4.y)) + (r0.w);
    r0 = tex2D(s0, v1.xy);
    r1.w = (r0.w) * (v0.x) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.y = (r1.z) + (r1.z);
    r1 = float4(((r1.w) >= 0.0f ? (r0.x) : (c0.z)), ((r1.w) >= 0.0f ? (r0.y) : (c0.z)), ((r1.w) >= 0.0f ? (r0.z) : (c0.z)), ((r1.w) >= 0.0f ? (r0.w) : (c0.z)));
    r0 = tex2D(s3, v5.xy);
    r2.w = (r0.w) * (v0.y) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r3.xyz = (r2.xyz) * (r3.www) + (r3.xyz);
    r2 = float4(((r2.w) >= 0.0f ? (r0.x) : (r1.x)), ((r2.w) >= 0.0f ? (r0.y) : (r1.y)), ((r2.w) >= 0.0f ? (r0.z) : (r1.z)), ((r2.w) >= 0.0f ? (r0.w) : (r1.w)));
    r0 = tex2D(s4, v5.zw);
    r3.w = (r0.w) * (v0.z) + (c0.x);
    r1 = (v4.yyyy) * (c[31]);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1 = (v4.xxxx) * (c[30]) + (r1);
    r0 = float4(((r3.w) >= 0.0f ? (r0.x) : (r2.x)), ((r3.w) >= 0.0f ? (r0.y) : (r2.y)), ((r3.w) >= 0.0f ? (r0.z) : (r2.z)), ((r3.w) >= 0.0f ? (r0.w) : (r2.w)));
    r1 = (v4.zzzz) * (c[32]) + (r1);
    r6.xyz = (r3.xyz) * (r0.www);
    r2 = (r1) + (c[33]);
    r4.xy = (r2.ww) * (c[34].xy) + (r2.xy);
    r4.zw = r2.zw;
    r1 = tex2Dproj(s1, r4);
    r3.zw = r4.zw;
    r2.zw = r3.zw;
    r5.xy = (r4.ww) * (-(c[34].zw)) + (r2.xy);
    r5.zw = r2.zw;
    r5 = tex2Dproj(s1, r5);
    r1.w = r5.x;
    r3.xy = (r4.ww) * (-(c[34].xy)) + (r2.xy);
    r2.xy = (r4.ww) * (c[34].zw) + (r2.xy);
    r3 = tex2Dproj(s1, r3);
    r1.y = r3.x;
    r3 = tex2Dproj(s1, r2);
    r2 = (v4.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1.z = dot(r2, c[27]);
    r3.w = 1.0f / (r1.z);
    r4.x = dot(r2, c[24]);
    r4.y = dot(r2, c[25]);
    r1.z = r3.x;
    r4.xy = (r3.ww) * (r4.xy);
    r3.x = dot(r2, c[26]);
    r2.xy = (r4.xy) * (c0.ww) + (c0.ww);
    r2 = tex2D(s2, r2.xy);
    r3.y = (r3.x) * (r3.x);
    r2.w = dot(c[22].yz, r3.xy) + (c[22].x);
    r3.xy = saturate((r3.xx) * (c[23].xy) + (c[23].zw));
    r3.w = saturate(1.0f / (r2.w));
    r2.w = ((-abs(r2.w)) >= 0.0f ? (c0.z) : (r3.w));
    r4.xy = (r3.xy) * (r3.xy);
    r7.xy = (r3.xy) * (c2.zz) + (c2.ww);
    r3.xyz = (-(v4.xyz)) + (c[20].xyz);
    r4.w = (r4.x) * (r7.x);
    r5.xyz = normalize(r3.xyz);
    r3.y = (r4.y) * (-(r7.y)) + (c0.y);
    r3.w = dot(r5.xyz, c[28].xyz);
    r2.w = (r2.w) * (r4.w);
    r3.z = saturate((r3.w) * (c[29].x) + (c[29].y));
    r3.w = (r3.z) * (r3.z);
    r3.z = (r3.z) * (c2.z) + (c2.w);
    r2.w = (r3.y) * (r2.w);
    r3.w = (r3.w) * (r3.z);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.w = (r2.w) * (r3.w);
    r1.w = dot(r1, c1.wwww);
    r1.xyz = (r2.xyz) * (r2.www);
    r7.xyz = (r1.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r9.xyz = normalize(v2.xyz);
    r4 = (-(v4.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v4.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v4.zzzz)) + (c[7]);
    r5.w = saturate(dot(r5.xyz, r9.xyz));
    r1 = (r2) * (r2) + (r1);
    r8.xyz = (r5.www) * (c[21].xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r8.xyz = (r0.xyz) * (r8.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r4.z = c0.y;
    r1 = saturate((r1) * (c[8]) + (r4.zzzz));
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r3.xyz = (r7.xyz) * (r8.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r0.xyz) * (r6.xyz) + (r3.xyz);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[35].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
