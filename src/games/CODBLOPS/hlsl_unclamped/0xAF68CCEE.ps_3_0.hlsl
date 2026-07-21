// Mechanically reconstructed from 0xAF68CCEE.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

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
    const float4 c0 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.0009765625f, 0.0f);
    const float4 c2 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c3 = float4(0.125f, 0.25f, 0.0f, 0.0f);
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
    float4 r10 = 0.0f;
    float4 r11 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r2.xyz = (-(v4.xyz)) + (c[21].xyz);
    r7.y = dot(r2.xyz, r2.xyz);
    r1.y = (r0.w) * (c0.w);
    r1.w = rsqrt(r7.y);
    r1.z = (r0.w) * (-(c0.w)) + (c0.z);
    r4.xyz = (r2.xyz) * (r1.www);
    r9.xyz = normalize(v2.xyz);
    r3.xyz = normalize(v4.xyz);
    r3.w = saturate(dot(r9.xyz, r4.xyz));
    r4.w = saturate(dot(r9.xyz, -(r3.xyz)));
    r2.w = (r3.w) * (r1.z) + (r1.y);
    r5.w = (r4.w) * (r1.z) + (r1.y);
    r6.xy = c[24].xy;
    r1.xyz = (r6.yyy) * (c[23].xyz);
    r2.w = (r2.w) * (r5.w) + (c1.z);
    r4.w = (-(r4.w)) + (c0.z);
    r2.w = 1.0f / (r2.w);
    r5.w = (r3.w) * (r2.w);
    r5.xyz = (r2.xyz) * (r1.www) + (-(r3.xyz));
    r11.xy = (r0.ww) * (c2.xy) + (c2.zw);
    r2.xyz = normalize(r5.xyz);
    r5.z = exp2(r11.y);
    r4.z = saturate(dot(r2.xyz, r4.xyz));
    r2.w = (r5.z) * (c3.x) + (c3.y);
    r4.z = (-(r4.z)) + (c0.z);
    r4.y = saturate(dot(r9.xyz, r2.xyz));
    r2.z = (r4.z) * (r4.z);
    r2.y = pow(abs(r4.y), r5.z);
    r2.z = (r2.z) * (r2.z);
    r2.w = (r2.w) * (r2.y);
    r2.z = (r4.z) * (r2.z);
    r10.xyz = (r0.xyz) * (r0.xyz);
    r8.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.zzz);
    r2.w = (r5.w) * (r2.w);
    r0.xyz = (r8.xyz) * (r2.zzz) + (r10.xyz);
    r5.w = 1.0f / (r11.x);
    r0.xyz = (r2.www) * (r0.xyz);
    r7.x = 1.0f / (r1.w);
    r0.xyz = (r0.xyz) * (c[27].www);
    r0.w = (r0.w) * (c0.x);
    r2.xyz = (r1.xyz) * (r0.xyz);
    r0.z = dot(c[25].yz, r7.xy) + (c[25].x);
    r1.xy = saturate((r7.xx) * (c[26].xy) + (c[26].zw));
    r0.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c1.xx) + (c1.yy);
    r1.xy = (r0.xy) * (r1.xy);
    r1.w = max(abs(r9.y), abs(r9.z));
    r1.z = (r0.z) * (r1.x);
    r0.z = max(abs(r9.x), r1.w);
    r1.w = 1.0f / (r0.z);
    r0.xyz = (r9.xyz) * (c[5].xyz);
    r2.w = (r1.y) * (r1.z);
    r0.xyz = (r0.xyz) * (r1.www) + (v5.xyz);
    r1 = tex3D(s11, r0.xyz);
    r2.w = (r2.w) * (r1.w);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1 = tex2D(s0, v1.xy);
    r1.xyz = (r1.xyz) * (v0.xyz);
    r2.xyz = (r2.xyz) * (r2.www);
    r5.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[27].yyy);
    r1.w = dot(r3.xyz, r9.xyz);
    r4.xyz = (r0.xyz) * (c0.yyy);
    r0.z = (r1.w) + (r1.w);
    r1.xyz = (r6.xxx) * (c[22].xyz);
    r0.xyz = (r9.xyz) * (-(r0.zzz)) + (r3.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r3.www) * (r1.xyz);
    r3.xyz = (r0.xyz) * (c0.xxx);
    r0 = tex3D(s11, v5.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r2.www) * (r1.xyz) + (r4.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r6.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r7.xyz = (r0.xyz) * (c0.yyy);
    r4.z = (r4.w) * (r4.w);
    r3 = (-(v4.yyyy)) + (c[7]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[6]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[8]);
    r4.w = (r4.w) * (r4.z);
    r0 = (r1) * (r1) + (r0);
    r5.w = (r5.w) * (r4.w);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r8.xyz = (r8.xyz) * (r5.www) + (r10.xyz);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r3.y = c0.z;
    r0 = saturate((r0) * (c[9]) + (r3.yyyy));
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r2.xyz = (r7.xyz) * (r8.xyz);
    r0 = (r0) * (r1);
    r2.xyz = (r2.xyz) * (c[27].xxx) + (r6.xyz);
    r1.x = dot(c[10], r0);
    r1.y = dot(c[11], r0);
    r1.z = dot(c[20], r0);
    r0.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.w = c0.z;
    r1.x = dot(r0, c[29]);
    r1.y = dot(r0, c[30]);
    r1.z = dot(r0, c[31]);
    r0.xyz = (r1.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}
