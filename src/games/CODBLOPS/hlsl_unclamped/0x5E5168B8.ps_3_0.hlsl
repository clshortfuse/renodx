// Mechanically reconstructed from 0x5E5168B8.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);

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
    const float4 c0 = float4(0.25f, 1.0f, -0.0f, 0.5f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = (v4.yyyy) * (c[31]);
    r0 = (v4.xxxx) * (c[30]) + (r0);
    r0 = (v4.zzzz) * (c[32]) + (r0);
    r0 = (r0) + (c[33]);
    r3.xy = (r0.ww) * (c[34].xy) + (r0.xy);
    r3.zw = r0.zw;
    r1 = tex2Dproj(s1, r3);
    r2.zw = r3.zw;
    r0.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[34].zw)) + (r0.xy);
    r4.zw = r0.zw;
    r4 = tex2Dproj(s1, r4);
    r1.w = r4.x;
    r2.xy = (r3.ww) * (-(c[34].xy)) + (r0.xy);
    r0.xy = (r3.ww) * (c[34].zw) + (r0.xy);
    r2 = tex2Dproj(s1, r2);
    r1.y = r2.x;
    r2 = tex2Dproj(s1, r0);
    r0 = (v4.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.w = dot(r0, c[27]);
    r1.z = r2.x;
    r2.w = 1.0f / (r2.w);
    r2.x = dot(r0, c[24]);
    r2.y = dot(r0, c[25]);
    r5.w = dot(r1, c0.xxxx);
    r2.xy = (r2.ww) * (r2.xy);
    r1.x = dot(r0, c[26]);
    r0.xy = (r2.xy) * (c0.ww) + (c0.ww);
    r0 = tex2D(s2, r0.xy);
    r1.y = (r1.x) * (r1.x);
    r0.w = dot(c[22].yz, r1.xy) + (c[22].x);
    r4.xyz = (r0.xyz) * (r0.xyz);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r1.xx) * (c[23].xy) + (c[23].zw));
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c0.z) : (r0.z));
    r1.xy = (r0.xy) * (r0.xy);
    r2.xy = (r0.xy) * (c1.xx) + (c1.yy);
    r1.z = (r1.x) * (r2.x);
    r0.xyz = (-(v4.xyz)) + (c[20].xyz);
    r1.w = (r1.y) * (-(r2.y)) + (c0.y);
    r5.xyz = normalize(r0.xyz);
    r0.z = (r0.w) * (r1.z);
    r0.w = dot(r5.xyz, c[28].xyz);
    r4.w = (r1.w) * (r0.z);
    r0.z = saturate((r0.w) * (c[29].x) + (c[29].y));
    r0.w = (r0.z) * (r0.z);
    r0.z = (r0.z) * (c1.x) + (c1.y);
    r6.w = (r0.w) * (r0.z);
    r3 = (-(v4.yyyy)) + (c[6]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[5]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[7]);
    r4.w = (r4.w) * (r6.w);
    r0 = (r1) * (r1) + (r0);
    r7.xyz = (r4.xyz) * (r4.www);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r3 = (r3) * (r4);
    r6.xyz = normalize(v2.xyz);
    r2 = (r2) * (r4);
    r3 = (r3) * (r6.yyyy);
    r1 = (r1) * (r4);
    r2 = (r2) * (r6.xxxx) + (r3);
    r3.z = c0.y;
    r0 = saturate((r0) * (c[8]) + (r3.zzzz));
    r1 = saturate((r1) * (r6.zzzz) + (r2));
    r2.xyz = (r5.www) * (r7.xyz);
    r0 = (r0) * (r1);
    r2.w = saturate(dot(r5.xyz, r6.xyz));
    r4.x = dot(c[9], r0);
    r1 = tex2D(s0, v1.xy);
    r1.xyz = (r1.xyz) * (v0.www);
    r4.y = dot(c[10], r0);
    r1.xyz = (r1.www) * (r1.xyz);
    r4.z = dot(c[11], r0);
    r0.xyz = (r1.xyz) * (v0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r2.www) * (c[21].xyz);
    r1.xyz = (r4.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[35].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}
