// Mechanically reconstructed from 0x478C5690.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD7;
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
    const float4 c0 = float4(6.375f, 31.875f, 0.0f, 0.0f);
    const float4 c1 = float4(-2.0f, 3.0f, 7.0f, 0.5f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(2.0f, -1.0f, 0.142857f, 8.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (c[21].xyz) + (-(v1.xyz));
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r1.x = 1.0f / (r0.w);
    r0.xyz = (r0.xyz) * (r0.www);
    r1.y = (r1.x) * (r1.x);
    r0.w = dot(c[24].yz, r1.xy) + (c[24].x);
    r1.xy = saturate((r1.xx) * (c[25].xy) + (c[25].zw));
    r1.zw = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c1.xx) + (c1.yy);
    r1.xy = (r1.zw) * (r1.xy);
    r0.w = (r0.w) * (r1.x);
    r0.w = (r1.y) * (r0.w);
    r1.x = dot(v2.xyz, v2.xyz);
    r1.x = rsqrt(r1.x);
    r1.yzw = (r1.xxx) * (v2.xyz);
    r2.x = max(abs(r1.z), abs(r1.w));
    r3.x = max(abs(r1.y), r2.x);
    r2.x = 1.0f / (r3.x);
    r2.yzw = (r1.yzw) * (c[5].xyz);
    r2.xyz = (r2.yzw) * (r2.xxx) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r0.w = (r0.w) * (r2.w);
    r2.xyz = (r0.www) * (c[22].xyz);
    r2.xyz = (r2.xyz) * (c[23].xxx);
    r3 = tex2D(s2, v4.xy);
    r3.xy = (r3.wy) * (c2.xy) + (c2.zw);
    r3.xy = (r3.xy) * (c1.ww) + (c1.ww);
    r3.xy = (r3.xy) * (c3.xx) + (c3.yy);
    r4.xyz = (r1.wyz) * (v3.yzx);
    r4.xyz = (r1.zwy) * (v3.zxy) + (-(r4.xyz));
    r4.xyz = (r4.xyz) * (v3.www);
    r3.yzw = (r3.yyy) * (r4.xyz);
    r3.xyz = (r3.xxx) * (v3.xyz) + (r3.yzw);
    r3.xyz = (v2.xyz) * (r1.xxx) + (r3.xyz);
    r4.xyz = normalize(r3.xyz);
    r0.x = saturate(dot(r4.xyz, r0.xyz));
    r0.xyz = (r2.xyz) * (r0.xxx);
    r0.xyz = (r0.xyz) * (c3.zzz);
    r0.w = max(abs(r4.y), abs(r4.z));
    r1.x = max(abs(r4.x), r0.w);
    r0.w = 1.0f / (r1.x);
    r2.xyz = (r4.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (r0.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r2.xyz) * (c0.yyy) + (r0.xyz);
    r2 = tex2D(s4, v4.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = normalize(v1.xyz);
    r0.w = dot(r3.xyz, r4.xyz);
    r0.w = (r0.w) + (r0.w);
    r3.xyz = (r4.xyz) * (-(r0.www)) + (r3.xyz);
    r3.w = c3.w;
    r3 = texCUBElod(s15, r3);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c3.www);
    r4 = tex3D(s11, v5.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r3.xyz = (r3.xyz) * (r4.xyz);
    r3.xyz = (r3.xyz) * (c0.xxx);
    r4 = tex2D(s3, v4.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r3.xyz = (r3.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = max(r0.xyz, c0.zzz);
    r0.w = c[26].w;
    r0.xy = (r0.ww) * (c[32].xy);
    r0.xy = (r0.xy) * (c[31].xx);
    r0.xy = (v4.xy) * (c[31].xx) + (r0.xy);
    r3 = tex2D(s6, r0.xy);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (v6.xxx);
    r0.xyz = (r0.xyz) * (c1.zzz);
    r3.xy = (r0.ww) * (c[33].xy);
    r3.xy = (r3.xy) * (c[34].xx);
    r3.xy = (v4.xy) * (c[34].xx) + (r3.xy);
    r3 = tex2D(s5, r3.xy);
    r2.xyz = (r0.xyz) * (-(r3.xyz)) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r3 = tex2D(s1, v4.xy);
    r0.w = (-(r3.x)) + (-(c3.y));
    r0.xyz = (r0.www) * (r2.xyz) + (r0.xyz);
    r2 = (c[7]) + (-(v1.yyyy));
    r3 = (r2) * (r2);
    r4 = (c[6]) + (-(v1.xxxx));
    r3 = (r4) * (r4) + (r3);
    r5 = (c[8]) + (-(v1.zzzz));
    r3 = (r5) * (r5) + (r3);
    r6.x = rsqrt(r3.x);
    r6.y = rsqrt(r3.y);
    r6.z = rsqrt(r3.z);
    r6.w = rsqrt(r3.w);
    r7.y = c3.y;
    r3 = saturate((r3) * (c[9]) + (-(r7.yyyy)));
    r2 = (r2) * (r6);
    r2 = (r1.zzzz) * (r2);
    r4 = (r4) * (r6);
    r5 = (r5) * (r6);
    r2 = (r4) * (r1.yyyy) + (r2);
    r1 = saturate((r5) * (r1.wwww) + (r2));
    r1 = (r3) * (r1);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r0.xyz);
    r0.w = -(c3.y);
    r1.x = dot(r0, c[28]);
    r1.y = dot(r0, c[29]);
    r1.z = dot(r0, c[30]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[27].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = -(c3.y);

    return oC0;
}
