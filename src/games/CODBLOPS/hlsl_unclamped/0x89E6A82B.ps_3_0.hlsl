// Mechanically reconstructed from 0x89E6A82B.ps_3_0.cso.
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
sampler2D s5 : register(s5);
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
    const float4 c1 = float4(-0.5f, 0.5f, 1.10000002f, 10.0f);
    const float4 c2 = float4(1.0f, 0.0f, 8.0f, 31.875f);
    const float4 c3 = float4(3.5f, 1.0f, 0.0f, 0.0f);
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

    r0 = tex3D(s11, v7.xyz);
    r1 = tex2D(s1, v1.xy);
    r3.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1 = tex2D(s5, v1.xy);
    r4.xy = (v1.xy) + (c1.xx);
    r3.w = c1.y;
    r2.xy = (r4.xy) * (c[26].xx) + (r3.ww);
    r2 = tex2D(s3, r2.xy);
    r7.w = (v7.w) * (c1.z) + (-(r2.x));
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r8.w = saturate((r7.w) * (c1.w));
    r2.xy = lerp(r3.xy, r1.xy, r8.ww);
    r1.xyz = v2.xyz;
    r1.xyz = (r2.xxx) * (v5.xyz) + (r1.xyz);
    r1.xyz = (r2.yyy) * (v4.xyz) + (r1.xyz);
    r9.xyz = normalize(r1.xyz);
    r3.xyz = normalize(v6.xyz);
    r0.w = dot(r3.xyz, r9.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r9.xyz) * (-(r0.www)) + (r3.xyz);
    r0 = tex2D(s2, v1.xy);
    r1.w = (r0.w) * (c2.z);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r4.xy = (r4.xy) * (c[27].xx) + (r3.ww);
    r1.xyz = (r1.xyz) * (c2.zzz);
    r1.w = saturate(dot(r9.xyz, -(r3.xyz)));
    r1.xyz = (r2.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c2.www);
    r2.w = (-(r1.w)) + (c2.x);
    r2.z = (r2.w) * (r2.w);
    r1.w = (r0.w) * (c3.x) + (c3.y);
    r0.w = (r2.w) * (r2.z);
    r1.w = 1.0f / (r1.w);
    r0.w = (r0.w) * (r1.w);
    r2.xyz = (r0.xyz) * (-(r0.xyz)) + (c2.xxx);
    r2.xyz = (r0.www) * (r2.xyz);
    r1.w = max(abs(r9.y), abs(r9.z));
    r2.xyz = (r0.xyz) * (r0.xyz) + (r2.xyz);
    r0.w = max(abs(r9.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r9.xyz) * (c[5].xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v7.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r7.xyz = (r1.xyz) * (c[21].xxx);
    r8.xyz = (r0.xyz) * (c[21].yyy);
    r5 = tex2D(s4, r4.xy);
    r0 = tex2D(s0, v1.xy);
    r1.xyz = (r0.xyz) * (v0.xyz);
    r6.w = (r0.w) * (v0.w);
    r4 = (-(v6.yyyy)) + (c[7]);
    r0 = (r4) * (r4);
    r3 = (-(v6.xxxx)) + (c[6]);
    r0 = (r3) * (r3) + (r0);
    r2 = (-(v6.zzzz)) + (c[8]);
    r6.xyz = (r1.xyz) * (r1.xyz);
    r1 = (r2) * (r2) + (r0);
    r0 = lerp(r6, r5, r8.wwww);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r6.w = (-(r8.w)) + (c2.x);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r4.w = c2.x;
    r1 = saturate((r1) * (c[9]) + (r4.wwww));
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r3.xyz = (r8.xyz) * (r0.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r3.xyz) * (c2.www) + (r7.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.w = ((r7.w) >= 0.0f ? (r6.w) : (c2.y));
    r2.z = dot(c[20], r1);
    r1.w = (r2.w) * (r2.w);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r1.w = (r1.w) * (c[28].w);
    r0.xyz = (c[28].xyz) * (r1.www) + (r0.xyz);
    r1.xyz = (r0.www) * (r0.xyz);
    r1.w = c2.x;
    r0.x = dot(r1, c[23]);
    r0.y = dot(r1, c[24]);
    r0.z = dot(r1, c[25]);
    r0.xyz = (v3.xyz) * (-(r0.www)) + (r0.xyz);
    r0.xyz = (r0.xyz) * (v2.www);
    r0.xyz = (v3.xyz) * (r0.www) + (r0.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
