// Mechanically reconstructed from 0x6F2913B3.ps_3_0.cso.
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
samplerCUBE s15 : register(s15);

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
    const float4 c1 = float4(0.200000003f, 8.0f, 31.875f, 1.0f);
    const float4 c2 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c3 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c4 = float4(0.125f, 0.25f, 0.0f, 0.0f);
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
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1.w = dot(v6.xyz, v6.xyz);
    r0 = v2;
    r0.xyz = (r1.xxx) * (v5.xyz) + (r0.xyz);
    r1.w = rsqrt(r1.w);
    r0.xyz = (r1.yyy) * (v4.xyz) + (r0.xyz);
    r5.xyz = (r1.www) * (v6.xyz);
    r10.xyz = normalize(r0.xyz);
    r0.y = saturate(dot(r10.xyz, -(r5.xyz)));
    r2 = tex2D(s2, v1.xy);
    r1.z = (r2.w) * (c2.x);
    r0.z = (r2.w) * (-(c2.x)) + (c2.y);
    r2.z = saturate(dot(r10.xyz, c[17].xyz));
    r0.x = (r0.y) * (r0.z) + (r1.z);
    r0.z = (r2.z) * (r0.z) + (r1.z);
    r1.xyz = (v6.xyz) * (-(r1.www)) + (c[17].xyz);
    r0.z = (r0.z) * (r0.x) + (c2.z);
    r6.w = (-(r0.y)) + (c1.w);
    r0.z = 1.0f / (r0.z);
    r1.w = (r2.z) * (r0.z);
    r0.xyz = normalize(r1.xyz);
    r3.xyz = (r2.zzz) * (c[18].xyz);
    r3.w = saturate(dot(r10.xyz, r0.xyz));
    r0.z = saturate(dot(r0.xyz, c[17].xyz));
    r0.xy = (r2.ww) * (c3.xy) + (c3.zw);
    r0.y = exp2(r0.y);
    r2.z = 1.0f / (r0.x);
    r1.z = pow(abs(r3.w), r0.y);
    r0.z = (-(r0.z)) + (c1.w);
    r0.x = (r0.y) * (c4.x) + (c4.y);
    r0.y = (r0.z) * (r0.z);
    r0.x = (r1.z) * (r0.x);
    r0.y = (r0.y) * (r0.y);
    r3.w = (r1.w) * (r0.x);
    r4.w = (r0.z) * (r0.y);
    r1 = tex2D(s0, v1.xy);
    r0.xyz = lerp(r1.xyz, c1.xxx, r2.xxx);
    r11.xyz = (r0.xyz) * (r0.xyz);
    r9.xyz = (r0.xyz) * (-(r0.xyz)) + (c1.www);
    r0.xyz = (r2.xxx) * (r1.xyz);
    r1.xyz = (r9.xyz) * (r4.www) + (r11.xyz);
    r1.xyz = (r3.www) * (r1.xyz);
    r2.x = max(abs(r10.y), abs(r10.z));
    r4.xyz = (r2.yyy) * (r1.xyz);
    r1.w = max(abs(r10.x), r2.x);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r10.xyz) * (c[5].xyz);
    r4.xyz = (r4.xyz) * (c[19].xyz);
    r1.xyz = (r1.xyz) * (r1.www) + (v7.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r4.xyz = (r4.xyz) * (r1.www);
    r1.xyz = (r2.yyy) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c1.zzz);
    r2.x = dot(r5.xyz, r10.xyz);
    r3.xyz = (r1.www) * (r3.xyz) + (r1.xyz);
    r1.w = (r2.x) + (r2.x);
    r1.xyz = (r10.xyz) * (-(r1.www)) + (r5.xyz);
    r1.w = (r2.w) * (c1.y);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r5.xyz = (r1.xyz) * (c1.yyy);
    r1 = tex3D(s11, v7.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r5.xyz) * (r1.xyz);
    r7.xyz = (r0.xyz) * (r3.xyz) + (r4.xyz);
    r8.xyz = (r1.xyz) * (c1.zzz);
    r2.w = (r6.w) * (r6.w);
    r5 = (-(v6.yyyy)) + (c[7]);
    r1 = (r5) * (r5);
    r4 = (-(v6.xxxx)) + (c[6]);
    r1 = (r4) * (r4) + (r1);
    r3 = (-(v6.zzzz)) + (c[8]);
    r2.w = (r6.w) * (r2.w);
    r1 = (r3) * (r3) + (r1);
    r2.w = (r2.z) * (r2.w);
    r6.x = rsqrt(r1.x);
    r6.y = rsqrt(r1.y);
    r6.z = rsqrt(r1.z);
    r6.w = rsqrt(r1.w);
    r9.xyz = (r9.xyz) * (r2.www) + (r11.xyz);
    r5 = (r5) * (r6);
    r5 = (r10.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r10.xxxx) + (r5);
    r2.x = c1.w;
    r1 = saturate((r1) * (c[9]) + (r2.xxxx));
    r3 = saturate((r3) * (r10.zzzz) + (r4));
    r4.xyz = (r8.xyz) * (r9.xyz);
    r1 = (r1) * (r3);
    r3.xyz = (r4.xyz) * (r2.yyy) + (r7.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.w;

    return oC0;
}
