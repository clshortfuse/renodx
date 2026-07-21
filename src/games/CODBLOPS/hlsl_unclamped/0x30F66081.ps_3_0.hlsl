// Mechanically reconstructed from 0x30F66081.ps_3_0.cso.
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
    float4 v6 : TEXCOORD4;
    float4 v7 : TEXCOORD5;
    float4 v8 : TEXCOORD6;
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
    float4 v8 = input.v8;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
    const float4 c2 = float4(0.959999979f, 0.0399999991f, -2.0f, 3.0f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v6.ww) * (c[21].xy) + (v6.xy);
    r0.zw = v6.zw;
    r1 = tex2Dproj(s2, r0);
    r0.xy = (v6.ww) * (-(c[21].xy)) + (v6.xy);
    r0.zw = v6.zw;
    r0 = tex2Dproj(s2, r0);
    r1.y = r0.x;
    r0.xy = (v6.ww) * (c[21].zw) + (v6.xy);
    r0.zw = v6.zw;
    r0 = tex2Dproj(s2, r0);
    r1.z = r0.x;
    r0.xy = (v6.ww) * (-(c[21].zw)) + (v6.xy);
    r0.zw = v6.zw;
    r2 = tex2Dproj(s2, r0);
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = v2;
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r3.xyz = (r3.yyy) * (v4.xyz) + (r0.xyz);
    r0.xyz = normalize(r3.xyz);
    r3.w = max(abs(r0.y), abs(r0.z));
    r1.w = r2.x;
    r2.w = max(abs(r0.x), r3.w);
    r2.w = 1.0f / (r2.w);
    r2.xyz = (r0.xyz) * (c[5].xyz);
    r4.z = dot(r1, c3.zzzz);
    r1.xyz = (r2.xyz) * (r2.www) + (v8.xyz);
    r1 = tex3D(s11, r1.xyz);
    r3.xyz = (-(v7.xyz)) + (c[6].xyz);
    r4.y = dot(r3.xyz, r3.xyz);
    r3.w = rsqrt(r4.y);
    r2.xyz = (r3.xyz) * (r3.www);
    r2.w = dot(r2.xyz, c[9].xyz);
    r2.w = saturate((r2.w) * (c[10].x) + (c[10].y));
    r4.w = (r2.w) * (c[10].w);
    r2.w = lerp(r1.w, r4.z, r4.w);
    r6.xyz = (r1.xyz) * (r1.xyz);
    r4.x = 1.0f / (r3.w);
    r1.w = dot(c[11].yz, r4.xy) + (c[11].x);
    r4.xy = saturate((r4.xx) * (c[20].xy) + (c[20].zw));
    r1.xy = (r4.xy) * (r4.xy);
    r7.xyz = normalize(v7.xyz);
    r4.xy = (r4.xy) * (c2.zz) + (c2.ww);
    r3.xyz = (r3.xyz) * (r3.www) + (-(r7.xyz));
    r4.xy = (r1.xy) * (r4.xy);
    r1.xyz = normalize(r3.xyz);
    r3.w = (r1.w) * (r4.x);
    r1.w = saturate(dot(r1.xyz, r2.xyz));
    r3.w = (r4.y) * (r3.w);
    r1.w = (-(r1.w)) + (c1.z);
    r3.w = (r2.w) * (r3.w);
    r2.w = (r1.w) * (r1.w);
    r4.w = saturate(dot(r0.xyz, r1.xyz));
    r1.z = (r2.w) * (r2.w);
    r2.w = saturate(dot(r0.xyz, r2.xyz));
    r2.z = (r1.w) * (r1.z);
    r1 = tex2D(s3, v1.xy);
    r2.x = (r1.w) * (c1.w);
    r2.y = (r1.w) * (-(c1.w)) + (c1.z);
    r1.x = saturate(dot(r0.xyz, -(r7.xyz)));
    r1.z = (r2.w) * (r2.y) + (r2.x);
    r2.y = (r1.x) * (r2.y) + (r2.x);
    r1.z = (r1.z) * (r2.y) + (c3.x);
    r2.xy = (r1.ww) * (c4.xy) + (c4.zw);
    r3.y = 1.0f / (r1.z);
    r1.z = exp2(r2.y);
    r3.z = pow(abs(r4.w), r1.z);
    r1.z = (r1.z) * (c3.y) + (c3.z);
    r2.y = (r2.w) * (r3.y);
    r1.z = (r3.z) * (r1.z);
    r2.z = (r2.z) * (c2.x) + (c2.y);
    r1.z = (r2.y) * (r1.z);
    r1.x = (-(r1.x)) + (c1.z);
    r1.z = (r2.z) * (r1.z);
    r4.xyz = (r2.www) * (c[7].xyz);
    r2.w = (r1.y) * (r1.z);
    r1.z = 1.0f / (r2.x);
    r3.xyz = (r2.www) * (c[8].xyz);
    r2 = tex2D(s0, v1.xy);
    r2.xyz = (r2.xyz) * (v0.xyz);
    r5.xyz = (r3.www) * (r3.xyz);
    r3.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r6.xyz) * (r1.yyy);
    r2.w = dot(r7.xyz, r0.xyz);
    r6.xyz = (r2.xyz) * (c1.yyy);
    r2.w = (r2.w) + (r2.w);
    r2.xyz = (r0.xyz) * (-(r2.www)) + (r7.xyz);
    r2.w = (r1.w) * (c1.x);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r3.www) * (r4.xyz) + (r6.xyz);
    r6.xyz = (r0.xyz) * (c1.xxx);
    r2 = tex3D(s11, v8.xyz);
    r1.w = (r1.x) * (r1.x);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r1.x) * (r1.w);
    r0.xyz = (r6.xyz) * (r0.xyz);
    r1.w = (r1.z) * (r1.w);
    r0.xyz = (r0.xyz) * (c1.yyy);
    r1.w = (r1.w) * (c2.x) + (c2.y);
    r2.xyz = (r3.xyz) * (r4.xyz) + (r5.xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r0.xyz = (r0.xyz) * (r1.yyy) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.z;

    return oC0;
}
