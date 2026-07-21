// Mechanically reconstructed from 0xBB4504E2.ps_3_0.cso.
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
sampler2D s4 : register(s4);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
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
    float4 oC0 = 0.0f;

    r0.xy = (v1.xy) * (c[23].xy);
    r0 = tex2D(s3, r0.xy);
    r1.xyz = (r0.xyz) + (c0.xxx);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = saturate((r1.xyz) * (r0.www) + (r0.xyz));
    r0.xyz = (r0.xyz) * (v0.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.xy = (v4.ww) * (c[21].xy) + (v4.xy);
    r0.zw = v4.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v4.ww) * (-(c[21].xy)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v4.ww) * (c[21].zw) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v4.ww) * (-(c[21].zw)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r8.xyz = normalize(v2.xyz);
    r2.w = max(abs(r8.y), abs(r8.z));
    r0.w = r1.x;
    r1.w = max(abs(r8.x), r2.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r8.xyz) * (c[5].xyz);
    r3.w = dot(r0, c2.zzzz);
    r0.xyz = (r1.xyz) * (r1.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r4.xyz = (-(v5.xyz)) + (c[6].xyz);
    r6.y = dot(r4.xyz, r4.xyz);
    r5.w = rsqrt(r6.y);
    r3.xyz = (r4.xyz) * (r5.www);
    r1.w = dot(r3.xyz, c[9].xyz);
    r1.w = saturate((r1.w) * (c[10].x) + (c[10].y));
    r6.x = 1.0f / (r5.w);
    r2.w = (r1.w) * (c[10].w);
    r5.xy = saturate((r6.xx) * (c[20].xy) + (c[20].zw));
    r1.xy = (r5.xy) * (r5.xy);
    r5.xy = (r5.xy) * (c1.yy) + (c1.zz);
    r1.z = dot(c[11].yz, r6.xy) + (c[11].x);
    r1.xy = (r1.xy) * (r5.xy);
    r1.w = lerp(r0.w, r3.w, r2.w);
    r0.w = (r1.z) * (r1.x);
    r6.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r1.y) * (r0.w);
    r2.w = (r1.w) * (r0.w);
    r3.w = saturate(dot(r8.xyz, r3.xyz));
    r1 = tex2D(s2, v1.xy);
    r0.x = (r1.w) * (c1.x);
    r0.z = (r1.w) * (-(c1.x)) + (c1.w);
    r9.xyz = normalize(v5.xyz);
    r0.w = (r3.w) * (r0.z) + (r0.x);
    r0.y = saturate(dot(r8.xyz, -(r9.xyz)));
    r0.z = (r0.y) * (r0.z) + (r0.x);
    r4.w = (-(r0.y)) + (c0.w);
    r0.w = (r0.w) * (r0.z) + (c2.x);
    r4.xyz = (r4.xyz) * (r5.www) + (-(r9.xyz));
    r0.w = 1.0f / (r0.w);
    r0.xyz = normalize(r4.xyz);
    r4.z = (r3.w) * (r0.w);
    r5.w = saturate(dot(r8.xyz, r0.xyz));
    r0.w = saturate(dot(r0.xyz, r3.xyz));
    r4.xy = (r1.ww) * (c3.xy) + (c3.zw);
    r3.z = exp2(r4.y);
    r0.z = (-(r0.w)) + (c0.w);
    r0.x = pow(abs(r5.w), r3.z);
    r0.y = (r0.z) * (r0.z);
    r0.w = (r3.z) * (c2.y) + (c2.z);
    r0.y = (r0.y) * (r0.y);
    r0.w = (r0.x) * (r0.w);
    r0.z = (r0.z) * (r0.y);
    r7.xyz = (r1.xyz) * (r1.xyz);
    r5.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.www);
    r0.w = (r4.z) * (r0.w);
    r0.xyz = (r5.xyz) * (r0.zzz) + (r7.xyz);
    r3.xyz = (r3.www) * (c[7].xyz);
    r0.xyz = (r0.www) * (r0.xyz);
    r3.w = 1.0f / (r4.x);
    r1.xyz = (r0.xyz) * (c[22].www);
    r0 = tex2D(s4, v1.xy);
    r1.xyz = (r1.xyz) * (r0.www);
    r1.w = (r1.w) * (c0.y);
    r1.xyz = (r1.xyz) * (c[8].xyz);
    r4.xyz = (r2.www) * (r1.xyz);
    r5.w = dot(r9.xyz, r8.xyz);
    r1.xyz = (r6.xyz) * (c[22].yyy);
    r5.w = (r5.w) + (r5.w);
    r6.xyz = (r0.www) * (r1.xyz);
    r1.xyz = (r8.xyz) * (-(r5.www)) + (r9.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r6.xyz = (r6.xyz) * (c0.zzz);
    r8.xyz = (r1.xyz) * (c0.yyy);
    r1 = tex3D(s11, v6.xyz);
    r0.w = (r4.w) * (r4.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r4.w) * (r0.w);
    r1.xyz = (r8.xyz) * (r1.xyz);
    r0.w = (r3.w) * (r0.w);
    r1.xyz = (r1.xyz) * (c0.zzz);
    r5.xyz = (r5.xyz) * (r0.www) + (r7.xyz);
    r3.xyz = (r2.www) * (r3.xyz) + (r6.xyz);
    r1.xyz = (r1.xyz) * (r5.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz) + (r4.xyz);
    r1.xyz = (r1.xyz) * (c[22].xxx);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}
