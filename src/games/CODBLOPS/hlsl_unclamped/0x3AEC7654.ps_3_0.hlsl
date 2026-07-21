// Mechanically reconstructed from 0x3AEC7654.ps_3_0.cso.
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
    const float4 c1 = float4(0.959999979f, 0.0399999991f, -2.0f, 3.0f);
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
    r1.xyz = (-(v4.xyz)) + (c[6].xyz);
    r5.y = dot(r1.xyz, r1.xyz);
    r1.w = rsqrt(r5.y);
    r7.xyz = normalize(v4.xyz);
    r2.xyz = (r0.xyz) * (v0.xyz);
    r3.xyz = (r1.xyz) * (r1.www) + (-(r7.xyz));
    r0.xyz = (r1.xyz) * (r1.www);
    r1.xyz = normalize(r3.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.w = saturate(dot(r1.xyz, r0.xyz));
    r5.x = 1.0f / (r1.w);
    r2.w = (-(r0.w)) + (c0.z);
    r0.w = (r2.w) * (r2.w);
    r6.xyz = normalize(v2.xyz);
    r3.z = (r0.w) * (r0.w);
    r1.w = saturate(dot(r6.xyz, r0.xyz));
    r0 = tex2D(s1, v1.xy);
    r3.y = (r0.w) * (c0.w);
    r3.w = (r0.w) * (-(c0.w)) + (c0.z);
    r0.x = saturate(dot(r6.xyz, -(r7.xyz)));
    r0.z = (r1.w) * (r3.w) + (r3.y);
    r3.w = (r0.x) * (r3.w) + (r3.y);
    r2.w = (r2.w) * (r3.z);
    r0.z = (r0.z) * (r3.w) + (c2.x);
    r3.w = 1.0f / (r0.z);
    r4.xy = (r0.ww) * (c3.xy) + (c3.zw);
    r3.z = saturate(dot(r6.xyz, r1.xyz));
    r0.z = exp2(r4.y);
    r1.z = pow(abs(r3.z), r0.z);
    r0.z = (r0.z) * (c2.y) + (c2.z);
    r1.y = (r1.w) * (r3.w);
    r0.z = (r1.z) * (r0.z);
    r1.z = (r2.w) * (c1.x) + (c1.y);
    r0.z = (r1.y) * (r0.z);
    r0.x = (-(r0.x)) + (c0.z);
    r0.z = (r1.z) * (r0.z);
    r3.xyz = (r1.www) * (c[7].xyz);
    r1.w = (r0.y) * (r0.z);
    r0.z = 1.0f / (r4.x);
    r4.xyz = (r1.www) * (c[8].xyz);
    r1.w = dot(c[9].yz, r5.xy) + (c[9].x);
    r5.xy = saturate((r5.xx) * (c[10].xy) + (c[10].zw));
    r1.xy = (r5.xy) * (r5.xy);
    r5.xy = (r5.xy) * (c1.zz) + (c1.ww);
    r5.xy = (r1.xy) * (r5.xy);
    r3.w = max(abs(r6.y), abs(r6.z));
    r2.w = (r1.w) * (r5.x);
    r1.w = max(abs(r6.x), r3.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r6.xyz) * (c[5].xyz);
    r2.w = (r5.y) * (r2.w);
    r1.xyz = (r1.xyz) * (r1.www) + (v5.xyz);
    r1 = tex3D(s11, r1.xyz);
    r2.w = (r2.w) * (r1.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r4.xyz = (r4.xyz) * (r2.www);
    r1.xyz = (r0.yyy) * (r1.xyz);
    r1.w = dot(r7.xyz, r6.xyz);
    r5.xyz = (r1.xyz) * (c0.yyy);
    r1.w = (r1.w) + (r1.w);
    r1.xyz = (r6.xyz) * (-(r1.www)) + (r7.xyz);
    r1.w = (r0.w) * (c0.x);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r3.xyz = (r2.www) * (r3.xyz) + (r5.xyz);
    r5.xyz = (r1.xyz) * (c0.xxx);
    r1 = tex3D(s11, v5.xyz);
    r0.w = (r0.x) * (r0.x);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r0.x) * (r0.w);
    r1.xyz = (r5.xyz) * (r1.xyz);
    r0.w = (r0.z) * (r0.w);
    r1.xyz = (r1.xyz) * (c0.yyy);
    r0.w = (r0.w) * (c1.x) + (c1.y);
    r2.xyz = (r2.xyz) * (r3.xyz) + (r4.xyz);
    r1.xyz = (r1.xyz) * (r0.www);
    r0.xyz = (r1.xyz) * (r0.yyy) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}
