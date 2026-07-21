// Mechanically reconstructed from 0x4D12BF6B.ps_3_0.cso.
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
    const float4 c2 = float4(1.0f, 0.797884583f, -2.0f, 3.0f);
    const float4 c3 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    float4 oC0 = 0.0f;

    r2.xyz = (-(v6.xyz)) + (c[6].xyz);
    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r10.y = dot(r2.xyz, r2.xyz);
    r0 = v2;
    r0.xyz = (r1.xxx) * (v5.xyz) + (r0.xyz);
    r2.w = rsqrt(r10.y);
    r1.xyz = (r1.yyy) * (v4.xyz) + (r0.xyz);
    r3.xyz = (r2.xyz) * (r2.www);
    r0.xyz = normalize(r1.xyz);
    r4.w = saturate(dot(r0.xyz, r3.xyz));
    r1 = tex2D(s2, v1.xy);
    r4.y = (r1.w) * (c2.y);
    r8.xyz = normalize(v6.xyz);
    r4.z = (r1.w) * (-(c2.y)) + (c2.x);
    r3.w = saturate(dot(r0.xyz, -(r8.xyz)));
    r1.z = (r4.w) * (r4.z) + (r4.y);
    r4.z = (r3.w) * (r4.z) + (r4.y);
    r1.z = (r1.z) * (r4.z) + (c3.x);
    r1.z = 1.0f / (r1.z);
    r3.w = (-(r3.w)) + (c2.x);
    r5.z = (r4.w) * (r1.z);
    r4.xyz = (r2.xyz) * (r2.www) + (-(r8.xyz));
    r10.x = 1.0f / (r2.w);
    r2.xyz = normalize(r4.xyz);
    r5.xy = (r1.ww) * (c4.xy) + (c4.zw);
    r4.y = saturate(dot(r0.xyz, r2.xyz));
    r4.z = exp2(r5.y);
    r1.z = saturate(dot(r2.xyz, r3.xyz));
    r2.z = pow(abs(r4.y), r4.z);
    r2.w = (r4.z) * (c3.y) + (c3.z);
    r1.z = (-(r1.z)) + (c2.x);
    r5.w = (r2.z) * (r2.w);
    r2.w = (r1.z) * (r1.z);
    r5.y = (r2.w) * (r2.w);
    r2.xy = (v1.xy) * (c[20].xy);
    r2 = tex2D(s3, r2.xy);
    r3.xyz = (r2.xyz) + (c0.xxx);
    r2 = tex2D(s0, v1.xy);
    r4.xyz = saturate((r3.xyz) * (r2.www) + (r2.xyz));
    r1.z = (r1.z) * (r5.y);
    r2.xyz = lerp(r4.xyz, c0.yyy, r1.xxx);
    r7.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r2.xyz) * (-(r2.xyz)) + (c2.xxx);
    r2.w = (r5.z) * (r5.w);
    r2.xyz = (r3.xyz) * (r1.zzz) + (r7.xyz);
    r1.z = 1.0f / (r5.x);
    r2.xyz = (r2.www) * (r2.xyz);
    r2.xyz = (r1.yyy) * (r2.xyz);
    r9.xy = c[9].xy;
    r5.xyz = (r9.yyy) * (c[8].xyz);
    r4.xyz = (r1.xxx) * (r4.xyz);
    r6.xyz = (r2.xyz) * (r5.xyz);
    r1.x = dot(c[10].yz, r10.xy) + (c[10].x);
    r5.xy = saturate((r10.xx) * (c[11].xy) + (c[11].zw));
    r2.xy = (r5.xy) * (r5.xy);
    r5.xy = (r5.xy) * (c2.zz) + (c2.ww);
    r5.xy = (r2.xy) * (r5.xy);
    r5.w = max(abs(r0.y), abs(r0.z));
    r1.x = (r1.x) * (r5.x);
    r2.w = max(abs(r0.x), r5.w);
    r2.w = 1.0f / (r2.w);
    r2.xyz = (r0.xyz) * (c[5].xyz);
    r1.x = (r5.y) * (r1.x);
    r2.xyz = (r2.xyz) * (r2.www) + (v7.xyz);
    r2 = tex3D(s11, r2.xyz);
    r1.x = (r1.x) * (r2.w);
    r5.xyz = (r2.xyz) * (r2.xyz);
    r6.xyz = (r6.xyz) * (r1.xxx);
    r2.xyz = (r9.xxx) * (c[7].xyz);
    r5.xyz = (r1.yyy) * (r5.xyz);
    r2.xyz = (r4.www) * (r2.xyz);
    r5.xyz = (r5.xyz) * (c0.www);
    r5.xyz = (r1.xxx) * (r2.xyz) + (r5.xyz);
    r1.x = dot(r8.xyz, r0.xyz);
    r4.xyz = (r4.xyz) * (v0.xyz);
    r1.x = (r1.x) + (r1.x);
    r2.xyz = (r0.xyz) * (-(r1.xxx)) + (r8.xyz);
    r2.w = (r1.w) * (c0.z);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r8.xyz = (r0.xyz) * (c0.zzz);
    r2 = tex3D(s11, v7.xyz);
    r1.w = (r3.w) * (r3.w);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r3.w) * (r1.w);
    r0.xyz = (r8.xyz) * (r0.xyz);
    r1.w = (r1.z) * (r1.w);
    r0.xyz = (r0.xyz) * (c0.www);
    r3.xyz = (r3.xyz) * (r1.www) + (r7.xyz);
    r2.xyz = (r4.xyz) * (r5.xyz) + (r6.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r0.xyz) * (r1.yyy) + (r2.xyz);
    r1.w = c2.x;
    r0.x = dot(r1, c[22]);
    r0.y = dot(r1, c[23]);
    r0.z = dot(r1, c[24]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c2.x;

    return oC0;
}
