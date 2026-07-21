// Mechanically reconstructed from 0xC65EA222.ps_3_0.cso.
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
sampler2D s6 : register(s6);
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
    const float4 c2 = float4(1.0f, -0.0f, -1.0f, 8.0f);
    const float4 c3 = float4(31.875f, 3.5f, 1.0f, 0.0f);
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

    r2 = tex3D(s11, v7.xyz);
    r0.xy = (v1.xy) * (c[22].xy);
    r0 = tex2D(s3, r0.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s1, v1.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r4.xy = (c[22].zz) * (r1.xy) + (r0.xy);
    r1 = tex2D(s6, v1.xy);
    r5.xy = (v1.xy) + (c1.xx);
    r5.z = c1.y;
    r0.xy = (r5.xy) * (c[27].xx) + (r5.zz);
    r0 = tex2D(s4, r0.xy);
    r7.w = (v7.w) * (c1.z) + (-(r0.x));
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r4.w = saturate((r7.w) * (c1.w));
    r3.xy = lerp(r4.xy, r1.xy, r4.ww);
    r1 = v2;
    r1.xyz = (r3.xxx) * (v5.xyz) + (r1.xyz);
    r1.xyz = (r3.yyy) * (v4.xyz) + (r1.xyz);
    r8.xyz = normalize(r1.xyz);
    r4.xyz = normalize(v6.xyz);
    r0.w = dot(r4.xyz, r8.xyz);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r0.w = (r0.w) + (r0.w);
    r3.xyz = (r8.xyz) * (-(r0.www)) + (r4.xyz);
    r0.w = saturate(dot(r8.xyz, -(r4.xyz)));
    r2 = tex2D(s2, v1.xy);
    r3.w = (r2.w) * (c2.w);
    r3 = texCUBElod(s15, r3);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4.xyz = (r3.xyz) * (c2.www);
    r0.w = (-(r0.w)) + (c2.x);
    r0.x = (r0.w) * (r0.w);
    r0.z = (r2.w) * (c3.y) + (c3.z);
    r0.w = (r0.w) * (r0.x);
    r0.z = 1.0f / (r0.z);
    r0.w = (r0.w) * (r0.z);
    r3.xyz = (r2.xyz) * (-(r2.xyz)) + (c2.xxx);
    r1.xyz = (r1.xyz) * (r4.xyz);
    r3.xyz = (r0.www) * (r3.xyz);
    r1.xyz = (r1.xyz) * (c3.xxx);
    r2.xyz = (r2.xyz) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r2.xy = (r5.xy) * (c[28].xx) + (r5.zz);
    r7.xyz = (r1.xyz) * (c[21].xxx);
    r2 = tex2D(s5, r2.xy);
    r3 = tex2D(s0, v1.xy);
    r3.xyz = (r3.xyz) * (v0.xyz);
    r1.xyz = (r3.xyz) * (-(r3.xyz)) + (r2.xyz);
    r0.w = (r2.w) + (c2.z);
    r2.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r0.yyy) * (r1.xyz);
    r2.w = c2.x;
    r3.w = max(abs(r8.y), abs(r8.z));
    r0 = (r4.wwww) * (r0) + (r2);
    r1.z = max(abs(r8.x), r3.w);
    r2.w = 1.0f / (r1.z);
    r1.xyz = (r8.xyz) * (c[5].xyz);
    r8.w = (-(r4.w)) + (c2.x);
    r1.xyz = (r1.xyz) * (r2.www) + (v7.xyz);
    r6 = tex3D(s11, r1.xyz);
    r5 = (-(v6.yyyy)) + (c[7]);
    r2 = (r5) * (r5);
    r4 = (-(v6.xxxx)) + (c[6]);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v6.zzzz)) + (c[8]);
    r2 = (r3) * (r3) + (r2);
    r1.xyz = (r6.xyz) * (r6.xyz);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r1.xyz = (r1.xyz) * (c[21].yyy);
    r5 = (r5) * (r6);
    r5 = (r8.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r8.xxxx) + (r5);
    r5.w = c2.x;
    r2 = saturate((r2) * (c[9]) + (r5.wwww));
    r3 = saturate((r3) * (r8.zzzz) + (r4));
    r1.xyz = (r0.xyz) * (r1.xyz);
    r2 = (r2) * (r3);
    r3.xyz = (r1.xyz) * (c3.xxx) + (r7.xyz);
    r1.x = dot(c[10], r2);
    r1.y = dot(c[11], r2);
    r3.w = ((r7.w) >= 0.0f ? (r8.w) : (c2.y));
    r1.z = dot(c[20], r2);
    r2.w = (r3.w) * (r3.w);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r3.xyz);
    r1.z = (r2.w) * (c[29].w);
    r2.xyz = (c[29].xyz) * (r1.zzz) + (r0.xyz);
    r2.w = c2.x;
    r0.x = dot(r2, c[24]);
    r0.y = dot(r2, c[25]);
    r0.z = dot(r2, c[26]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
