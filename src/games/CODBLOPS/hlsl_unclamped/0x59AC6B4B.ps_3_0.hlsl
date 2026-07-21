// Mechanically reconstructed from 0x59AC6B4B.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 8.0f, 31.875f, 1.0f);
    const float4 c1 = float4(0.797884583f, -2.0f, 3.0f, 1.0f);
    const float4 c2 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c3 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0.xy = (v1.xy) * (c[20].xy);
    r0 = tex2D(s2, r0.xy);
    r1.xyz = (r0.xyz) + (c0.xxx);
    r0 = tex2D(s0, v1.xy);
    r4.xyz = (-(v4.xyz)) + (c[6].xyz);
    r0.xyz = saturate((r1.xyz) * (r0.www) + (r0.xyz));
    r10.y = dot(r4.xyz, r4.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r2.w = rsqrt(r10.y);
    r2.xyz = (r4.xyz) * (r2.www);
    r8.xyz = normalize(v2.xyz);
    r3.xyz = (r0.xyz) * (r0.xyz);
    r0.w = saturate(dot(r8.xyz, r2.xyz));
    r1 = tex2D(s1, v1.xy);
    r3.w = (r1.w) * (c1.x);
    r9.xyz = normalize(v4.xyz);
    r0.y = (r1.w) * (-(c1.x)) + (c1.w);
    r0.x = saturate(dot(r8.xyz, -(r9.xyz)));
    r0.z = (r0.w) * (r0.y) + (r3.w);
    r0.y = (r0.x) * (r0.y) + (r3.w);
    r4.w = (-(r0.x)) + (c0.w);
    r0.z = (r0.z) * (r0.y) + (c2.x);
    r0.z = 1.0f / (r0.z);
    r4.xyz = (r4.xyz) * (r2.www) + (-(r9.xyz));
    r3.w = (r0.w) * (r0.z);
    r0.xyz = normalize(r4.xyz);
    r6.xyz = (r0.www) * (c[7].xyz);
    r4.z = saturate(dot(r8.xyz, r0.xyz));
    r0.w = saturate(dot(r0.xyz, r2.xyz));
    r2.xy = (r1.ww) * (c3.xy) + (c3.zw);
    r2.z = exp2(r2.y);
    r0.z = (-(r0.w)) + (c0.w);
    r0.x = pow(abs(r4.z), r2.z);
    r0.y = (r0.z) * (r0.z);
    r0.w = (r2.z) * (c2.y) + (c2.z);
    r0.y = (r0.y) * (r0.y);
    r0.w = (r0.x) * (r0.w);
    r0.z = (r0.z) * (r0.y);
    r7.xyz = (r1.xyz) * (r1.xyz);
    r5.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.www);
    r0.w = (r3.w) * (r0.w);
    r0.xyz = (r5.xyz) * (r0.zzz) + (r7.xyz);
    r10.x = 1.0f / (r2.w);
    r0.xyz = (r0.www) * (r0.xyz);
    r3.w = 1.0f / (r2.x);
    r1.xyz = (r0.xyz) * (c[11].www);
    r0 = tex2D(s3, v1.xy);
    r1.xyz = (r1.xyz) * (r0.www);
    r1.w = (r1.w) * (c0.y);
    r4.xyz = (r1.xyz) * (c[8].xyz);
    r1.z = dot(c[9].yz, r10.xy) + (c[9].x);
    r2.xy = saturate((r10.xx) * (c[10].xy) + (c[10].zw));
    r1.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c1.yy) + (c1.zz);
    r2.xy = (r1.xy) * (r2.xy);
    r2.w = max(abs(r8.y), abs(r8.z));
    r2.z = (r1.z) * (r2.x);
    r1.z = max(abs(r8.x), r2.w);
    r2.w = 1.0f / (r1.z);
    r1.xyz = (r8.xyz) * (c[5].xyz);
    r5.w = (r2.y) * (r2.z);
    r1.xyz = (r1.xyz) * (r2.www) + (v5.xyz);
    r2 = tex3D(s11, r1.xyz);
    r2.w = (r5.w) * (r2.w);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r4.xyz) * (r2.www);
    r2.z = dot(r9.xyz, r8.xyz);
    r1.xyz = (r1.xyz) * (c[11].yyy);
    r5.w = (r2.z) + (r2.z);
    r2.xyz = (r0.www) * (r1.xyz);
    r1.xyz = (r8.xyz) * (-(r5.www)) + (r9.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r2.xyz) * (c0.zzz);
    r8.xyz = (r1.xyz) * (c0.yyy);
    r1 = tex3D(s11, v5.xyz);
    r0.w = (r4.w) * (r4.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r4.w) * (r0.w);
    r1.xyz = (r8.xyz) * (r1.xyz);
    r0.w = (r3.w) * (r0.w);
    r1.xyz = (r1.xyz) * (c0.zzz);
    r5.xyz = (r5.xyz) * (r0.www) + (r7.xyz);
    r2.xyz = (r2.www) * (r6.xyz) + (r2.xyz);
    r1.xyz = (r1.xyz) * (r5.xyz);
    r2.xyz = (r3.xyz) * (r2.xyz) + (r4.xyz);
    r1.xyz = (r1.xyz) * (c[11].xxx);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}
