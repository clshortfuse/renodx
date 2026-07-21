// Mechanically reconstructed from 0xB2118520.ps_3_0.cso.
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
    const float4 c0 = float4(0.142857f, 8.0f, 6.375f, 31.875f);
    const float4 c1 = float4(7.0f, 0.5f, 2.0f, -1.0f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.0f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.x = max(abs(r0.z), abs(r0.w));
    r2.x = max(abs(r0.y), r1.x);
    r1.x = 1.0f / (r2.x);
    r1.yzw = (r0.yzw) * (c[5].xyz);
    r1.xyz = (r1.yzw) * (r1.xxx) + (v5.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.www) * (c[18].xyz);
    r1.xyz = (r1.xyz) * (c[21].xxx);
    r2 = tex2D(s2, v4.xy);
    r2.xy = (r2.wy) * (c2.xy) + (c2.zw);
    r2.xy = (r2.xy) * (c1.yy) + (c1.yy);
    r2.xy = (r2.xy) * (c1.zz) + (c1.ww);
    r3.xyz = (r0.wyz) * (v3.yzx);
    r3.xyz = (r0.zwy) * (v3.zxy) + (-(r3.xyz));
    r3.xyz = (r3.xyz) * (v3.www);
    r2.yzw = (r2.yyy) * (r3.xyz);
    r2.xyz = (r2.xxx) * (v3.xyz) + (r2.yzw);
    r2.xyz = (v2.xyz) * (r0.xxx) + (r2.xyz);
    r3.xyz = normalize(r2.xyz);
    r2.xyz = normalize(c[17].xyz);
    r0.x = saturate(dot(r3.xyz, r2.xyz));
    r1.xyz = (r1.xyz) * (r0.xxx);
    r1.xyz = (r1.xyz) * (c0.xxx);
    r0.x = max(abs(r3.y), abs(r3.z));
    r1.w = max(abs(r3.x), r0.x);
    r0.x = 1.0f / (r1.w);
    r2.xyz = (r3.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (r0.xxx) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r2.xyz) * (c0.www) + (r1.xyz);
    r2 = tex2D(s4, v4.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = normalize(v1.xyz);
    r0.x = dot(r4.xyz, r3.xyz);
    r0.x = (r0.x) + (r0.x);
    r3.xyz = (r3.xyz) * (-(r0.xxx)) + (r4.xyz);
    r3.w = c0.y;
    r3 = texCUBElod(s15, r3);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c0.yyy);
    r4 = tex3D(s11, v5.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r3.xyz = (r3.xyz) * (r4.xyz);
    r3.xyz = (r3.xyz) * (c0.zzz);
    r4 = tex2D(s3, v4.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r3.xyz = (r3.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = max(r1.xyz, c3.xxx);
    r1.w = c[22].w;
    r1.xy = (r1.ww) * (c[28].xy);
    r1.xy = (r1.xy) * (c[27].xx);
    r1.xy = (v4.xy) * (c[27].xx) + (r1.xy);
    r3 = tex2D(s6, r1.xy);
    r1.xyz = (r3.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (v6.xxx);
    r1.xyz = (r1.xyz) * (c1.xxx);
    r3.xy = (r1.ww) * (c[29].xy);
    r3.xy = (r3.xy) * (c[30].xx);
    r3.xy = (v4.xy) * (c[30].xx) + (r3.xy);
    r3 = tex2D(s5, r3.xy);
    r2.xyz = (r1.xyz) * (-(r3.xyz)) + (r2.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz);
    r3 = tex2D(s1, v4.xy);
    r0.x = (-(r3.x)) + (-(c1.w));
    r1.xyz = (r0.xxx) * (r2.xyz) + (r1.xyz);
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
    r1.w = c1.w;
    r3 = saturate((r3) * (c[9]) + (-(r1.wwww)));
    r2 = (r2) * (r6);
    r2 = (r0.zzzz) * (r2);
    r4 = (r4) * (r6);
    r5 = (r5) * (r6);
    r2 = (r4) * (r0.yyyy) + (r2);
    r0 = saturate((r5) * (r0.wwww) + (r2));
    r0 = (r3) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = -(c1.w);
    r1.x = dot(r0, c[24]);
    r1.y = dot(r0, c[25]);
    r1.z = dot(r0, c[26]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = -(c1.w);

    return oC0;
}
