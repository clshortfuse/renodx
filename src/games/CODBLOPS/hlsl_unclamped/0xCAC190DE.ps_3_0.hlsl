// Mechanically reconstructed from 0xCAC190DE.ps_3_0.cso.
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
    const float4 c1 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c2 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v4.xyz, v4.xyz);
    r3.y = rsqrt(r0.w);
    r2.xyz = (r3.yyy) * (v4.xyz);
    r1.xyz = normalize(v2.xyz);
    r3.w = saturate(dot(r1.xyz, -(r2.xyz)));
    r0 = tex2D(s1, v1.xy);
    r3.x = (r0.w) * (c0.w);
    r2.w = (r0.w) * (-(c0.w)) + (c0.z);
    r1.w = saturate(dot(r1.xyz, c[17].xyz));
    r3.z = (r3.w) * (r2.w) + (r3.x);
    r2.w = (r1.w) * (r2.w) + (r3.x);
    r4.xyz = (v4.xyz) * (-(r3.yyy)) + (c[17].xyz);
    r2.w = (r2.w) * (r3.z) + (c1.x);
    r3.w = (-(r3.w)) + (c0.z);
    r2.w = 1.0f / (r2.w);
    r4.w = (r1.w) * (r2.w);
    r3.xyz = normalize(r4.xyz);
    r4.xyz = (r1.www) * (c[18].xyz);
    r5.z = saturate(dot(r1.xyz, r3.xyz));
    r1.w = saturate(dot(r3.xyz, c[17].xyz));
    r3.xy = (r0.ww) * (c2.xy) + (c2.zw);
    r5.w = exp2(r3.y);
    r2.w = 1.0f / (r3.x);
    r3.x = pow(abs(r5.z), r5.w);
    r1.w = (-(r1.w)) + (c0.z);
    r3.y = (r5.w) * (c1.y) + (c1.z);
    r3.z = (r1.w) * (r1.w);
    r3.y = (r3.x) * (r3.y);
    r3.z = (r3.z) * (r3.z);
    r4.w = (r4.w) * (r3.y);
    r5.z = (r1.w) * (r3.z);
    r6.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.zzz);
    r1.w = (r0.w) * (c0.x);
    r5.w = max(abs(r1.y), abs(r1.z));
    r5.xyz = (r3.xyz) * (r5.zzz) + (r6.xyz);
    r0.w = max(abs(r1.x), r5.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r1.xyz) * (c[5].xyz);
    r5.xyz = (r4.www) * (r5.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r5.xyz = (r5.xyz) * (c[6].www);
    r0.xyz = (r0.xyz) * (c[6].yyy);
    r5.xyz = (r5.xyz) * (c[19].xyz);
    r0.xyz = (r0.xyz) * (c0.yyy);
    r5.xyz = (r0.www) * (r5.xyz);
    r4.xyz = (r0.www) * (r4.xyz) + (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r4.w = dot(r2.xyz, r1.xyz);
    r4.w = (r4.w) + (r4.w);
    r0 = (r0.wxyz) * (v0.wxyz);
    r1.xyz = (r1.xyz) * (-(r4.www)) + (r2.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r0.yzw) * (r0.yzw);
    r7.xyz = (r1.xyz) * (c0.xxx);
    r1 = tex3D(s11, v5.xyz);
    r0.w = (r3.w) * (r3.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r3.w) * (r0.w);
    r1.xyz = (r7.xyz) * (r1.xyz);
    r0.w = (r2.w) * (r0.w);
    r1.xyz = (r1.xyz) * (c0.yyy);
    r3.xyz = (r3.xyz) * (r0.www) + (r6.xyz);
    r2.xyz = (r2.xyz) * (r4.xyz) + (r5.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (c[6].xxx) + (r2.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.x);
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
