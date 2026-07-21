// Mechanically reconstructed from 0x5F08BE01.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.5f, 2.0f, -1.0f, 9.99999997e-07f);
    const float4 c2 = float4(0.0f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (c[25].xx) * (v4.xy);
    r0 = tex2D(s1, r0.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.xy = (r0.xy) * (c1.xx) + (c1.xx);
    r0.xy = (r0.xy) * (c1.yy) + (c1.zz);
    r0.z = dot(v2.xyz, v2.xyz);
    r0.z = rsqrt(r0.z);
    r1.xyz = (r0.zzz) * (v2.xyz);
    r2.xyz = (r1.zxy) * (v3.yzx);
    r2.xyz = (r1.yzx) * (v3.zxy) + (-(r2.xyz));
    r2.xyz = (r2.xyz) * (v3.www);
    r2.xyz = (r0.yyy) * (r2.xyz);
    r0.xyw = (r0.xxx) * (v3.xyz) + (r2.xyz);
    r0.xyz = (v2.xyz) * (r0.zzz) + (r0.xyw);
    r2.xyz = normalize(r0.xyz);
    r0.xyz = normalize(v1.xyz);
    r0.y = dot(r0.xyz, r2.xyz);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r2.x) * (-(r0.y)) + (r0.x);
    r0.x = (r0.x) * (c1.w);
    r2 = tex2D(s3, v4.xy);
    r0.yzw = (r2.xyz) * (c[24].xxx);
    r0.xyz = (r0.xxx) * (r0.yzw) + (c[26].yyy);
    r0.xyz = (r0.xyz) * (c[27].xxx);
    r2.xy = ddx(v4.xy);
    r2.zw = ddy(v4.xy);
    r2 = tex2Dgrad(s2, v4.xy, r2.xy, r2.zw);
    r0.w = (r2.w) * (r2.w);
    r2 = max(r0, c2.xxxx);
    r0 = (c[6]) + (-(v1.yyyy));
    r3 = (r0) * (r0);
    r4 = (c[5]) + (-(v1.xxxx));
    r3 = (r4) * (r4) + (r3);
    r5 = (c[7]) + (-(v1.zzzz));
    r3 = (r5) * (r5) + (r3);
    r6.x = rsqrt(r3.x);
    r6.y = rsqrt(r3.y);
    r6.z = rsqrt(r3.z);
    r6.w = rsqrt(r3.w);
    r7.z = c1.z;
    r3 = saturate((r3) * (c[8]) + (-(r7.zzzz)));
    r0 = (r0) * (r6);
    r0 = (r1.yyyy) * (r0);
    r4 = (r4) * (r6);
    r5 = (r5) * (r6);
    r0 = (r4) * (r1.xxxx) + (r0);
    r0 = saturate((r5) * (r1.zzzz) + (r0));
    r0 = (r3) * (r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r1.z = dot(c[11], r0);
    r0.xyz = (r2.xyz) * (r1.xyz) + (r2.xyz);
    oC0.w = r2.w;
    r0.w = -(c1.z);
    r1.x = dot(r0, c[21]);
    r1.y = dot(r0, c[22]);
    r1.z = dot(r0, c[23]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);

    return oC0;
}
