// Mechanically reconstructed from 0xA25F4B0F.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 0.200000003f, 8.0f, 31.875f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(1.0f, 3.5f, 0.0f, 0.0f);
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

    r0.xy = (v1.xy) * (c[21].xy);
    r0 = tex2D(s3, r0.xy);
    r1.xyz = (r0.xyz) + (c0.xxx);
    r0 = tex2D(s0, v1.xy);
    r3.xyz = saturate((r1.xyz) * (r0.www) + (r0.xyz));
    r5 = tex2D(s2, v1.xy);
    r0 = tex2D(s1, v1.xy);
    r4.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r2.xyz = lerp(r3.xyz, c0.yyy, r5.xxx);
    r0 = v2;
    r1.xyz = (r4.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r3.xyz) * (r5.xxx);
    r3.xyz = (r4.yyy) * (v4.xyz) + (r1.xyz);
    r1.xyz = normalize(v6.xyz);
    r8.xyz = normalize(r3.xyz);
    r3.xyz = (r2.xyz) * (-(r2.xyz)) + (c2.xxx);
    r1.w = saturate(dot(r8.xyz, -(r1.xyz)));
    r2.w = (r5.w) * (c2.y) + (c2.x);
    r1.w = (-(r1.w)) + (c2.x);
    r3.w = 1.0f / (r2.w);
    r2.w = (r1.w) * (r1.w);
    r2.w = (r1.w) * (r2.w);
    r1.w = dot(r1.xyz, r8.xyz);
    r2.w = (r3.w) * (r2.w);
    r1.w = (r1.w) + (r1.w);
    r1.xyz = (r8.xyz) * (-(r1.www)) + (r1.xyz);
    r1.w = (r5.w) * (c0.z);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r4.xyz = (r3.xyz) * (r2.www);
    r3.xyz = (r1.xyz) * (c0.zzz);
    r1 = tex3D(s11, v7.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz) + (r4.xyz);
    r1.xyz = (r3.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c0.www);
    r2.w = max(abs(r8.y), abs(r8.z));
    r2.xyz = (r2.xyz) * (r1.xyz);
    r1.w = max(abs(r8.x), r2.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r8.xyz) * (c[5].xyz);
    r6.xyz = (r5.yyy) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.www) + (v7.xyz);
    r1 = tex3D(s11, r1.xyz);
    r7.xyz = (r1.xyz) * (r1.xyz);
    r4 = (-(v6.yyyy)) + (c[7]);
    r1 = (r4) * (r4);
    r3 = (-(v6.xxxx)) + (c[6]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v6.zzzz)) + (c[8]);
    r7.xyz = (r5.yyy) * (r7.xyz);
    r1 = (r2) * (r2) + (r1);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r4 = (r4) * (r5);
    r4 = (r8.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r8.xxxx) + (r4);
    r4.w = c2.x;
    r1 = saturate((r1) * (c[9]) + (r4.wwww));
    r2 = saturate((r2) * (r8.zzzz) + (r3));
    r3.xyz = (r7.xyz) * (r0.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r3.xyz) * (c0.www) + (r6.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r1.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r1.w = c2.x;
    r0.x = dot(r1, c[23]);
    r0.y = dot(r1, c[24]);
    r0.z = dot(r1, c[25]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c2.x;

    return oC0;
}
