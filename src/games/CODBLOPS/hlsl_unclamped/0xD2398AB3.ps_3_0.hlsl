// Mechanically reconstructed from 0xD2398AB3.ps_3_0.cso.
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
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 31.875f, 4.0f);
    const float4 c3 = float4(4.0f, -2.0f, 2.0f, 0.25f);
    const float4 c4 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
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
    r0 = tex2Dproj(s2, r3);
    r2.zw = r3.zw;
    r1.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[27].zw)) + (r1.xy);
    r4.zw = r1.zw;
    r4 = tex2Dproj(s2, r4);
    r0.w = r4.x;
    r2.xy = (r3.ww) * (-(c[27].xy)) + (r1.xy);
    r1.xy = (r3.ww) * (c[27].zw) + (r1.xy);
    r2 = tex2Dproj(s2, r2);
    r0.y = r2.x;
    r2 = tex2Dproj(s2, r1);
    r1 = (v4.xyzx) * (c1.yyyz) + (c1.zzzy);
    r0.z = dot(r1, c[20]);
    r2.w = 1.0f / (r0.z);
    r3.x = dot(r1, c[9]);
    r3.y = dot(r1, c[10]);
    r0.z = r2.x;
    r3.xy = (r2.ww) * (r3.xy);
    r2.x = dot(r1, c[11]);
    r1.xy = (r3.xy) * (c1.ww) + (c1.ww);
    r1 = tex2D(s3, r1.xy);
    r2.y = (r2.x) * (r2.x);
    r1.w = dot(c[7].yz, r2.xy) + (c[7].x);
    r2.xy = saturate((r2.xx) * (c[8].xy) + (c[8].zw));
    r2.w = saturate(1.0f / (r1.w));
    r1.w = ((-abs(r1.w)) >= 0.0f ? (c1.z) : (r2.w));
    r4.xy = (r2.xy) * (r2.xy);
    r5.xy = (r2.xy) * (c4.xx) + (c4.yy);
    r3.xyz = (-(v4.xyz)) + (c[5].xyz);
    r3.w = (r4.x) * (r5.x);
    r2.xyz = normalize(r3.xyz);
    r3.z = (r4.y) * (-(r5.y)) + (c1.y);
    r2.w = dot(r2.xyz, c[21].xyz);
    r1.w = (r1.w) * (r3.w);
    r3.w = saturate((r2.w) * (c[22].x) + (c[22].y));
    r2.w = (r3.w) * (r3.w);
    r3.w = (r3.w) * (c4.x) + (c4.y);
    r1.w = (r3.z) * (r1.w);
    r2.w = (r2.w) * (r3.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r2.w);
    r0.w = dot(r0, c3.wwww);
    r0.xyz = (r1.xyz) * (r1.www);
    r5.xyz = (r0.www) * (r0.xyz);
    r1 = tex2D(s0, v1.xy);
    r0 = (r1.xyzx) * (c1.yyyz) + (c1.zzzy);
    r2.w = (r1.w) * (v0.w) + (c1.x);
    r1.xyz = normalize(v2.xyz);
    r0 = float4(((r2.w) >= 0.0f ? (r0.x) : (c1.z)), ((r2.w) >= 0.0f ? (r0.y) : (c1.z)), ((r2.w) >= 0.0f ? (r0.z) : (c1.z)), ((r2.w) >= 0.0f ? (r0.w) : (c1.z)));
    r1.w = saturate(dot(r2.xyz, r1.xyz));
    r0.xyz = (r0.xyz) * (v0.xyz);
    r6.xyz = (r1.www) * (c[6].xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1 = tex2D(s1, v1.xy);
    r2.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r2.z = c1.y;
    r1.xy = (v1.zw) * (c1.yw);
    r1 = tex2D(s13, r1.xy);
    r3.xy = (v1.zw) * (c1.yw) + (c1.zw);
    r3 = tex2D(s13, r3.xy);
    r1.w = r3.y;
    r4.xyz = float3(((r2.w) >= 0.0f ? (r2.x) : (c1.z)), ((r2.w) >= 0.0f ? (r2.y) : (c1.z)), ((r2.w) >= 0.0f ? (r2.z) : (c1.z)));
    r2.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r1.y = dot(r4.xy, r4.xy) + (c1.z);
    r1.w = dot(r2.xy, r2.xy) + (c1.z);
    r1.y = exp2(-(r1.y));
    r1.w = exp2(-(r1.w));
    r3.w = (r1.y) * (c2.x) + (c2.y);
    r1.y = (r1.w) * (c2.x) + (c2.y);
    r1.w = dot(r2.xy, r4.xy) + (c1.z);
    r1.y = (r3.w) * (r1.y);
    r2 = tex2D(s14, v1.zw);
    r4.xy = (r2.xy) * (c2.zz);
    r2.w = saturate((r1.w) * (r1.y) + (r1.y));
    r3.xy = (r3.xz) * (r4.yy);
    r1.w = (r2.y) * (c2.z) + (-(r3.x));
    r7.xz = (r3.xy) * (c2.ww);
    r1.w = (r3.z) * (-(r4.y)) + (r1.w);
    r1.xy = (r1.xz) * (r4.xx);
    r7.y = (r1.w) + (r1.w);
    r1.w = (r2.x) * (c2.z) + (-(r1.x));
    r3.xyz = (r2.www) * (r7.xyz);
    r1.w = (r1.z) * (-(r4.x)) + (r1.w);
    r1.xz = (r3.ww) * (r1.xy);
    r1.y = (r3.w) * (r1.w);
    r2.xyz = (r6.xyz) * (r0.xyz);
    r1.xyz = (r1.xyz) * (c3.xzx) + (r3.xyz);
    r2.xyz = (r5.xyz) * (r2.xyz);
    r1.xyz = (r4.zzz) * (r1.xyz);
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
