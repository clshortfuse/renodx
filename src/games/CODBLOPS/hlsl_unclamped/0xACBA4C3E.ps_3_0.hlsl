// Mechanically reconstructed from 0xACBA4C3E.ps_3_0.cso.
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
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    float4 v6 = input.v6;
    float4 v7 = input.v7;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 31.875f);
    const float4 c2 = float4(-2.0f, 3.0f, 0.25f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1.z = c1.y;
    r0 = tex2D(s0, v1.xy);
    r2.z = (r0.w) * (v0.w) + (c1.x);
    r3.xyz = float3(((r2.z) >= 0.0f ? (r1.x) : (c1.z)), ((r2.z) >= 0.0f ? (r1.y) : (c1.z)), ((r2.z) >= 0.0f ? (r1.z) : (c1.z)));
    r1 = v2;
    r1.xyz = (r3.xxx) * (v5.xyz) + (r1.xyz);
    r1.xyz = (r3.yyy) * (v4.xyz) + (r1.xyz);
    r8.xyz = normalize(r1.xyz);
    r2.w = max(abs(r8.y), abs(r8.z));
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1.z = max(abs(r8.x), r2.w);
    r2.w = 1.0f / (r1.z);
    r1.xyz = (r8.xyz) * (c[5].xyz);
    r0 = float4(((r2.z) >= 0.0f ? (r0.x) : (c1.z)), ((r2.z) >= 0.0f ? (r0.y) : (c1.z)), ((r2.z) >= 0.0f ? (r0.z) : (c1.z)), ((r2.z) >= 0.0f ? (r0.w) : (c1.z)));
    r1.xyz = (r1.xyz) * (r2.www) + (v7.xyz);
    r2 = tex3D(s11, r1.xyz);
    r1.xyz = (-(v6.xyz)) + (c[28].xyz);
    r5.y = dot(r1.xyz, r1.xyz);
    r3.w = rsqrt(r5.y);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r5.x = 1.0f / (r3.w);
    r2.xyz = (r3.zzz) * (r2.xyz);
    r4.xy = saturate((r5.xx) * (c[32].xy) + (c[32].zw));
    r3.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c2.xx) + (c2.yy);
    r3.z = dot(c[31].yz, r5.xy) + (c[31].x);
    r3.xy = (r3.xy) * (r4.xy);
    r7.xyz = (r2.xyz) * (c1.www);
    r2.z = (r3.z) * (r3.x);
    r1.xyz = (r1.xyz) * (r3.www);
    r2.z = (r3.y) * (r2.z);
    r7.w = (r2.w) * (r2.z);
    r2 = (v6.yyyy) * (c[25]);
    r3.w = saturate(dot(r1.xyz, r8.xyz));
    r2 = (v6.xxxx) * (c[24]) + (r2);
    r1.xyz = c[29].xyz;
    r1.xyz = (r1.xyz) * (c[30].xxx);
    r2 = (v6.zzzz) * (c[26]) + (r2);
    r1.xyz = (r3.www) * (r1.xyz);
    r2 = (r2) + (c[27]);
    r5.xy = (r2.ww) * (c[33].xy) + (r2.xy);
    r5.zw = r2.zw;
    r3 = tex2Dproj(s2, r5);
    r4.zw = r5.zw;
    r2.zw = r4.zw;
    r6.xy = (r5.ww) * (-(c[33].zw)) + (r2.xy);
    r6.zw = r2.zw;
    r6 = tex2Dproj(s2, r6);
    r3.w = r6.x;
    r4.xy = (r5.ww) * (-(c[33].xy)) + (r2.xy);
    r2.xy = (r5.ww) * (c[33].zw) + (r2.xy);
    r4 = tex2Dproj(s2, r4);
    r3.y = r4.x;
    r4 = tex2Dproj(s2, r2);
    r2 = (v6.xyzx) * (c1.yyyz) + (c1.zzzy);
    r4.w = dot(r2, c[21]);
    r3.z = r4.x;
    r4.w = 1.0f / (r4.w);
    r4.x = dot(r2, c[10]);
    r4.y = dot(r2, c[11]);
    r3.w = dot(r3, c2.zzzz);
    r4.xy = (r4.ww) * (r4.xy);
    r3.x = dot(r2, c[20]);
    r2.xy = (r4.xy) * (-(c1.xx)) + (-(c1.xx));
    r2 = tex2D(s3, r2.xy);
    r3.y = (r3.x) * (r3.x);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.w = dot(c[8].yz, r3.xy) + (c[8].x);
    r3.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r3.z = saturate(1.0f / (r2.w));
    r4.w = ((-abs(r2.w)) >= 0.0f ? (c1.z) : (r3.z));
    r5.xy = (r3.xy) * (r3.xy);
    r6.xy = (r3.xy) * (c2.xx) + (c2.yy);
    r4.xyz = (-(v6.xyz)) + (c[6].xyz);
    r5.w = (r5.x) * (r6.x);
    r3.xyz = normalize(r4.xyz);
    r4.y = (r5.y) * (-(r6.y)) + (c1.y);
    r2.w = dot(r3.xyz, c[22].xyz);
    r4.w = (r4.w) * (r5.w);
    r4.z = saturate((r2.w) * (c[23].x) + (c[23].y));
    r2.w = (r4.z) * (r4.z);
    r4.z = (r4.z) * (c2.x) + (c2.y);
    r4.w = (r4.y) * (r4.w);
    r4.z = (r2.w) * (r4.z);
    r2.w = saturate(dot(r3.xyz, r8.xyz));
    r3.z = (r4.w) * (r4.z);
    r2.xyz = (r2.xyz) * (r3.zzz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r3.xyz = (r2.www) * (c[7].xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r3.www) * (r2.xyz);
    r3.xyz = (r3.xyz) * (r0.xyz);
    r1.xyz = (r7.www) * (r1.xyz) + (r7.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r2.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r2.w = c1.y;
    r0.x = dot(r2, c[35]);
    r0.y = dot(r2, c[36]);
    r0.z = dot(r2, c[37]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[34].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
