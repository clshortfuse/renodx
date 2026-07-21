// Mechanically reconstructed from 0xEFF7166E.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-2.0f, 3.0f, 31.875f, 0.25f);
    const float4 c1 = float4(1.0f, 0.0f, 0.5f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (-(v3.xyz)) + (c[28].xyz);
    r3.y = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r3.y);
    r3.x = 1.0f / (r0.w);
    r1.xyz = (r0.xyz) * (r0.www);
    r2.xy = saturate((r3.xx) * (c[31].xy) + (c[31].zw));
    r0.w = dot(c[30].yz, r3.xy) + (c[30].x);
    r0.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c0.xx) + (c0.yy);
    r7.xyz = normalize(v1.xyz);
    r2.xy = (r0.xy) * (r2.xy);
    r2.w = max(abs(r7.y), abs(r7.z));
    r1.w = (r0.w) * (r2.x);
    r0.w = max(abs(r7.x), r2.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r7.xyz) * (c[5].xyz);
    r1.w = (r2.y) * (r1.w);
    r0.xyz = (r0.xyz) * (r0.www) + (v4.xyz);
    r0 = tex3D(s11, r0.xyz);
    r5.w = (r1.w) * (r0.w);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0 = (v3.yyyy) * (c[25]);
    r6.xyz = (r2.xyz) * (c0.zzz);
    r0 = (v3.xxxx) * (c[24]) + (r0);
    r1.w = saturate(dot(r1.xyz, r7.xyz));
    r0 = (v3.zzzz) * (c[26]) + (r0);
    r5.xyz = (r1.www) * (c[29].xyz);
    r0 = (r0) + (c[27]);
    r3.xy = (r0.ww) * (c[32].xy) + (r0.xy);
    r3.zw = r0.zw;
    r1 = tex2Dproj(s1, r3);
    r2.zw = r3.zw;
    r0.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[32].zw)) + (r0.xy);
    r4.zw = r0.zw;
    r4 = tex2Dproj(s1, r4);
    r1.w = r4.x;
    r2.xy = (r3.ww) * (-(c[32].xy)) + (r0.xy);
    r0.xy = (r3.ww) * (c[32].zw) + (r0.xy);
    r2 = tex2Dproj(s1, r2);
    r1.y = r2.x;
    r2 = tex2Dproj(s1, r0);
    r0 = (v3.xyzx) * (c1.xxxy) + (c1.yyyx);
    r2.w = dot(r0, c[21]);
    r1.z = r2.x;
    r2.w = 1.0f / (r2.w);
    r2.x = dot(r0, c[10]);
    r2.y = dot(r0, c[11]);
    r1.w = dot(r1, c0.wwww);
    r2.xy = (r2.ww) * (r2.xy);
    r1.x = dot(r0, c[20]);
    r0.xy = (r2.xy) * (c1.zz) + (c1.zz);
    r0 = tex2D(s2, r0.xy);
    r1.y = (r1.x) * (r1.x);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(c[8].yz, r1.xy) + (c[8].x);
    r1.xy = saturate((r1.xx) * (c[9].xy) + (c[9].zw));
    r1.z = saturate(1.0f / (r0.w));
    r2.w = ((-abs(r0.w)) >= 0.0f ? (c1.y) : (r1.z));
    r3.xy = (r1.xy) * (r1.xy);
    r4.xy = (r1.xy) * (c0.xx) + (c0.yy);
    r2.xyz = (-(v3.xyz)) + (c[6].xyz);
    r3.w = (r3.x) * (r4.x);
    r1.xyz = normalize(r2.xyz);
    r2.y = (r3.y) * (-(r4.y)) + (c1.x);
    r0.w = dot(r1.xyz, c[22].xyz);
    r2.w = (r2.w) * (r3.w);
    r2.z = saturate((r0.w) * (c[23].x) + (c[23].y));
    r0.w = (r2.z) * (r2.z);
    r2.z = (r2.z) * (c0.x) + (c0.y);
    r2.w = (r2.y) * (r2.w);
    r2.z = (r0.w) * (r2.z);
    r0.w = saturate(dot(r1.xyz, r7.xyz));
    r1.z = (r2.w) * (r2.z);
    r2.xyz = (r0.xyz) * (r1.zzz);
    r1.xyz = (r0.www) * (c[7].xyz);
    r0 = tex2D(s0, v0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r1.www) * (r2.xyz);
    r3.xyz = (r1.xyz) * (r0.xyz);
    r1.xyz = (r5.www) * (r5.xyz) + (r6.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[33].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}
