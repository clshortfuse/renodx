// Mechanically reconstructed from 0x25899002.ps_3_0.cso.
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
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
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v1.xy);
    r1.xy = (v1.xy) * (c[7].xy);
    r1 = tex2D(s3, r1.xy);
    r2.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1 = tex2D(s1, v1.xy);
    r3.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1.xyz = (r0.xyz) * (v0.xyz);
    r2.xy = (c[7].zz) * (r2.xy) + (r3.xy);
    r0 = v2;
    r0.xyz = (r2.xxx) * (v5.xyz) + (r0.xyz);
    r1.w = dot(v6.xyz, v6.xyz);
    r2.xyz = (r2.yyy) * (v4.xyz) + (r0.xyz);
    r4.z = rsqrt(r1.w);
    r0.xyz = normalize(r2.xyz);
    r2.xyz = (r4.zzz) * (v6.xyz);
    r3.xyz = (r1.xyz) * (r1.xyz);
    r4.w = saturate(dot(r0.xyz, -(r2.xyz)));
    r1 = tex2D(s2, v1.xy);
    r4.y = (r1.w) * (c1.w);
    r3.w = (r1.w) * (-(c1.w)) + (c1.z);
    r2.w = saturate(dot(r0.xyz, c[17].xyz));
    r5.w = (r4.w) * (r3.w) + (r4.y);
    r3.w = (r2.w) * (r3.w) + (r4.y);
    r4.xyz = (v6.xyz) * (-(r4.zzz)) + (c[17].xyz);
    r3.w = (r3.w) * (r5.w) + (c2.x);
    r4.w = (-(r4.w)) + (c1.z);
    r3.w = 1.0f / (r3.w);
    r6.w = (r2.w) * (r3.w);
    r5.xyz = normalize(r4.xyz);
    r4.xyz = (r2.www) * (c[18].xyz);
    r6.y = saturate(dot(r0.xyz, r5.xyz));
    r2.w = saturate(dot(r5.xyz, c[17].xyz));
    r5.xy = (r1.ww) * (c3.xy) + (c3.zw);
    r6.z = exp2(r5.y);
    r3.w = 1.0f / (r5.x);
    r5.y = pow(abs(r6.y), r6.z);
    r2.w = (-(r2.w)) + (c1.z);
    r5.w = (r6.z) * (c2.y) + (c2.z);
    r5.z = (r2.w) * (r2.w);
    r5.w = (r5.y) * (r5.w);
    r5.z = (r5.z) * (r5.z);
    r5.w = (r6.w) * (r5.w);
    r5.z = (r2.w) * (r5.z);
    r7.xyz = (r1.xyz) * (r1.xyz);
    r6.xyz = (r1.xyz) * (-(r1.xyz)) + (c1.zzz);
    r2.w = (r1.w) * (c1.x);
    r1.xyz = (r6.xyz) * (r5.zzz) + (r7.xyz);
    r1.xyz = (r5.www) * (r1.xyz);
    r5.w = max(abs(r0.y), abs(r0.z));
    r5.xyz = (r1.xyz) * (c[6].www);
    r1.w = max(abs(r0.x), r5.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r0.xyz) * (c[5].xyz);
    r5.xyz = (r5.xyz) * (c[19].xyz);
    r1.xyz = (r1.xyz) * (r1.www) + (v7.xyz);
    r1 = tex3D(s11, r1.xyz);
    r5.xyz = (r5.xyz) * (r1.www);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r5.w = dot(r2.xyz, r0.xyz);
    r1.xyz = (r1.xyz) * (c[6].yyy);
    r5.w = (r5.w) + (r5.w);
    r1.xyz = (r1.xyz) * (c1.yyy);
    r2.xyz = (r0.xyz) * (-(r5.www)) + (r2.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r1.www) * (r4.xyz) + (r1.xyz);
    r2.xyz = (r0.xyz) * (c1.xxx);
    r1 = tex3D(s11, v7.xyz);
    r1.w = (r4.w) * (r4.w);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r4.w) * (r1.w);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r1.w = (r3.w) * (r1.w);
    r0.xyz = (r0.xyz) * (c1.yyy);
    r2.xyz = (r6.xyz) * (r1.www) + (r7.xyz);
    r1.xyz = (r3.xyz) * (r4.xyz) + (r5.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (c[6].xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.z;

    return oC0;
}
