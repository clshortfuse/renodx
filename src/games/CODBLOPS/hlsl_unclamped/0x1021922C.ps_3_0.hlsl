// Mechanically reconstructed from 0x1021922C.ps_3_0.cso.
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
    const float4 c0 = float4(-2.0f, 3.0f, 0.25f, 0.0f);
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

    r0 = (v4.yyyy) * (c[24]);
    r0 = (v4.xxxx) * (c[23]) + (r0);
    r0 = (v4.zzzz) * (c[25]) + (r0);
    r0 = (r0) + (c[26]);
    r3.xy = (r0.ww) * (c[31].xy) + (r0.xy);
    r3.zw = r0.zw;
    r1 = tex2Dproj(s1, r3);
    r2.zw = r3.zw;
    r0.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[31].zw)) + (r0.xy);
    r4.zw = r0.zw;
    r4 = tex2Dproj(s1, r4);
    r1.w = r4.x;
    r2.xy = (r3.ww) * (-(c[31].xy)) + (r0.xy);
    r0.xy = (r3.ww) * (c[31].zw) + (r0.xy);
    r2 = tex2Dproj(s1, r2);
    r1.y = r2.x;
    r2 = tex2Dproj(s1, r0);
    r0 = (v4.xyzx) * (c1.xxxy) + (c1.yyyx);
    r2.w = dot(r0, c[20]);
    r1.z = r2.x;
    r2.w = 1.0f / (r2.w);
    r2.x = dot(r0, c[9]);
    r2.y = dot(r0, c[10]);
    r1.w = dot(r1, c0.zzzz);
    r2.xy = (r2.ww) * (r2.xy);
    r1.x = dot(r0, c[11]);
    r0.xy = (r2.xy) * (c1.zz) + (c1.zz);
    r0 = tex2D(s2, r0.xy);
    r1.y = (r1.x) * (r1.x);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(c[7].yz, r1.xy) + (c[7].x);
    r1.xy = saturate((r1.xx) * (c[8].xy) + (c[8].zw));
    r1.z = saturate(1.0f / (r0.w));
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c0.w) : (r1.z));
    r3.xy = (r1.xy) * (r1.xy);
    r4.xy = (r1.xy) * (c0.xx) + (c0.yy);
    r2.xyz = (-(v4.xyz)) + (c[5].xyz);
    r3.w = (r3.x) * (r4.x);
    r1.xyz = normalize(r2.xyz);
    r2.y = (r3.y) * (-(r4.y)) + (c1.x);
    r2.w = dot(r1.xyz, c[21].xyz);
    r0.w = (r0.w) * (r3.w);
    r2.z = saturate((r2.w) * (c[22].x) + (c[22].y));
    r2.w = (r2.z) * (r2.z);
    r2.z = (r2.z) * (c0.x) + (c0.y);
    r0.w = (r2.y) * (r0.w);
    r2.w = (r2.w) * (r2.z);
    r0.w = (r0.w) * (r2.w);
    r5.xyz = normalize(v2.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r0.w = saturate(dot(r1.xyz, r5.xyz));
    r2.xyz = (r1.www) * (r0.xyz);
    r3.xyz = (r0.www) * (c[6].xyz);
    r0 = tex2D(s0, v1.xy);
    r4.xyz = (-(v4.xyz)) + (c[27].xyz);
    r0.xyz = (r0.xyz) * (v0.www);
    r7.y = dot(r4.xyz, r4.xyz);
    r0.xyz = (r0.www) * (r0.xyz);
    r1.w = rsqrt(r7.y);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r7.x = 1.0f / (r1.w);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r6.xy = saturate((r7.xx) * (c[30].xy) + (c[30].zw));
    r0.xy = (r6.xy) * (r6.xy);
    r6.xy = (r6.xy) * (c0.xx) + (c0.yy);
    r0.w = dot(c[29].yz, r7.xy) + (c[29].x);
    r0.xy = (r0.xy) * (r6.xy);
    r3.xyz = (r3.xyz) * (r1.xyz);
    r0.w = (r0.w) * (r0.x);
    r4.xyz = (r4.xyz) * (r1.www);
    r1.w = (r0.y) * (r0.w);
    r0 = tex2D(s12, v1.zw);
    r0.z = saturate(dot(r4.xyz, r5.xyz));
    r0.w = (r1.w) * (r0.y);
    r0.xyz = (r0.zzz) * (c[28].xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}
