// Mechanically reconstructed from 0x15D13171.ps_3_0.cso.
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
    r0.w = dot(v6.xyz, v6.xyz);
    r0.xyz = v2.xyz;
    r0.xyz = (r1.xxx) * (v5.xyz) + (r0.xyz);
    r2.w = rsqrt(r0.w);
    r0.xyz = (r1.yyy) * (v4.xyz) + (r0.xyz);
    r5.xyz = (r2.www) * (v6.xyz);
    r10.xyz = normalize(r0.xyz);
    r0.y = saturate(dot(r10.xyz, -(r5.xyz)));
    r1 = tex2D(s2, v1.xy);
    r1.z = (r1.w) * (c2.x);
    r0.z = (r1.w) * (-(c2.x)) + (c2.y);
    r0.w = saturate(dot(r10.xyz, c[17].xyz));
    r0.x = (r0.y) * (r0.z) + (r1.z);
    r0.z = (r0.w) * (r0.z) + (r1.z);
    r0.z = (r0.z) * (r0.x) + (c2.z);
    r2.xyz = (v6.xyz) * (-(r2.www)) + (c[17].xyz);
    r0.z = 1.0f / (r0.z);
    r5.w = (-(r0.y)) + (c1.w);
    r3.w = (r0.w) * (r0.z);
    r4.xyz = (r0.www) * (c[18].xyz);
    r0.xyz = normalize(r2.xyz);
    r2.z = saturate(dot(r10.xyz, r0.xyz));
    r2.xy = (r1.ww) * (c3.xy) + (c3.zw);
    r0.y = saturate(dot(r0.xyz, c[17].xyz));
    r2.w = exp2(r2.y);
    r1.z = 1.0f / (r2.x);
    r0.z = pow(abs(r2.z), r2.w);
    r0.w = (r2.w) * (c4.x) + (c4.y);
    r2.w = (-(r0.y)) + (c1.w);
    r0.z = (r0.z) * (r0.w);
    r0.w = (r2.w) * (r2.w);
    r3.w = (r3.w) * (r0.z);
    r3.z = (r0.w) * (r0.w);
    r0 = tex2D(s0, v1.xy);
    r2.xyz = lerp(r0.xyz, c1.xxx, r1.xxx);
    r2.w = (r2.w) * (r3.z);
    r11.xyz = (r2.xyz) * (r2.xyz);
    r9.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.www);
    r4.w = max(abs(r10.y), abs(r10.z));
    r3.xyz = (r9.xyz) * (r2.www) + (r11.xyz);
    r2.w = max(abs(r10.x), r4.w);
    r2.w = 1.0f / (r2.w);
    r2.xyz = (r10.xyz) * (c[5].xyz);
    r3.xyz = (r3.www) * (r3.xyz);
    r2.xyz = (r2.xyz) * (r2.www) + (v7.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r1.yyy) * (r3.xyz);
    r2.xyz = (r1.yyy) * (r2.xyz);
    r3.xyz = (r3.xyz) * (c[19].xyz);
    r2.xyz = (r2.xyz) * (c1.zzz);
    r3.xyz = (r2.www) * (r3.xyz);
    r2.xyz = (r2.www) * (r4.xyz) + (r2.xyz);
    r4.xyz = (r1.xxx) * (r0.xyz);
    r0.z = dot(r5.xyz, r10.xyz);
    r6.w = (r0.w) * (v0.w);
    r0.w = (r0.z) + (r0.z);
    r0.xyz = (r10.xyz) * (-(r0.www)) + (r5.xyz);
    r0.w = (r1.w) * (c1.y);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r5.xyz = (r4.xyz) * (v0.xyz);
    r4.xyz = (r0.xyz) * (c1.yyy);
    r0 = tex3D(s11, v7.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r6.xyz = (r5.xyz) * (r5.xyz);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r7.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r8.xyz = (r0.xyz) * (c1.zzz);
    r1.w = (r5.w) * (r5.w);
    r4 = (-(v6.yyyy)) + (c[7]);
    r0 = (r4) * (r4);
    r3 = (-(v6.xxxx)) + (c[6]);
    r0 = (r3) * (r3) + (r0);
    r2 = (-(v6.zzzz)) + (c[8]);
    r1.w = (r5.w) * (r1.w);
    r0 = (r2) * (r2) + (r0);
    r1.w = (r1.z) * (r1.w);
    r5.x = rsqrt(r0.x);
    r5.y = rsqrt(r0.y);
    r5.z = rsqrt(r0.z);
    r5.w = rsqrt(r0.w);
    r9.xyz = (r9.xyz) * (r1.www) + (r11.xyz);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r1.x = c1.w;
    r0 = saturate((r0) * (c[9]) + (r1.xxxx));
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r3.xyz = (r8.xyz) * (r9.xyz);
    r0 = (r0) * (r2);
    r2.xyz = (r3.xyz) * (r1.yyy) + (r7.xyz);
    r1.x = dot(c[10], r0);
    r1.y = dot(c[11], r0);
    r1.z = dot(c[20], r0);
    r0.xyz = (r6.xyz) * (r1.xyz) + (r2.xyz);
    r1.xyz = (r6.www) * (v3.xyz);
    r0.xyz = (r0.xyz) * (r6.www) + (-(r1.xyz));
    r0.xyz = (v2.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r6.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
