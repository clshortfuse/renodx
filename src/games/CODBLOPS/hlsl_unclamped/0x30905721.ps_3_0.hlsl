// Mechanically reconstructed from 0x30905721.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : TEXCOORD3;
    float4 v1 : TEXCOORD4;
    float4 v2 : TEXCOORD5;
    float4 v3 : TEXCOORD6;
    float4 v4 : TEXCOORD7;
    float4 v5 : TEXCOORD8;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(1e-15f, 1.0f, 1.44269502f, 0.200000003f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(-2.0f, 3.0f, -0.5f, 0.5f);
    const float4 c3 = float4(5.0f, 0.25f, 0.100000001f, 0.0f);
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

    r0.xy = (v5.xy) + (c2.zz);
    r0.w = c2.w;
    r5.xy = (r0.xy) * (c[11].xx) + (r0.ww);
    r0.xy = ddy(v5.xy);
    r3.xy = ddx(r5.xy);
    r7.xy = ddx(v5.xy);
    r8.xy = (r0.xy) * (r3.yy);
    r4.xy = ddy(r5.yx);
    r0 = v0;
    r2.xyz = (r0.yzx) * (v3.zxy);
    r1 = tex2D(s0, v5.xy);
    r1.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r0.xyz = (v3.yzx) * (r0.zxy) + (-(r2.xyz));
    r6.xy = (r1.xy) * (c[10].xx);
    r2.xy = (r7.xy) * (r4.xx) + (-(r8.xy));
    r1.xyz = (-(r0.xyz)) * (r6.yyy);
    r0.xyz = (r2.yyy) * (v1.xyz);
    r1.xyz = (r6.xxx) * (v0.xyz) + (r1.xyz);
    r0.xyz = (v0.xyz) * (r2.xxx) + (r0.xyz);
    r2.xyz = (r1.xyz) + (v3.xyz);
    r1.y = (r3.y) * (r4.y);
    r1.z = dot(r2.xyz, r2.xyz);
    r1.w = (r3.x) * (r4.x) + (-(r1.y));
    r2.w = rsqrt(r1.z);
    r1.xyz = float3(((r1.w) >= 0.0f ? (r0.x) : (-(r0.x))), ((r1.w) >= 0.0f ? (r0.y) : (-(r0.y))), ((r1.w) >= 0.0f ? (r0.z) : (-(r0.z))));
    r0.xyz = (r2.xyz) * (r2.www);
    r1.w = dot(r1.xyz, r0.xyz);
    r1.xyz = (r1.www) * (-(r0.xyz)) + (r1.xyz);
    r3.xyz = normalize(r1.xyz);
    r4.xyz = (r0.zxy) * (r3.yzx);
    r1 = tex2D(s1, r5.xy);
    r1.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r0.xyz = (r0.yzx) * (r3.zxy) + (-(r4.xyz));
    r4.xy = (r1.xy) * (c[20].xx);
    r1.xyz = (-(r0.xyz)) * (r4.yyy);
    r0.xyz = (-(v2.xyz)) + (c[5].xyz);
    r1.xyz = (r4.xxx) * (r3.xyz) + (r1.xyz);
    r4.y = dot(r0.xyz, r0.xyz);
    r1.w = dot(-(v2.xyz), -(v2.xyz));
    r4.z = rsqrt(r4.y);
    r1.w = rsqrt(r1.w);
    r0.xyz = (r0.xyz) * (r4.zzz);
    r3.xyz = (r2.xyz) * (r2.www) + (r1.xyz);
    r2.xyz = (-(v2.xyz)) * (r1.www) + (r0.xyz);
    r1.xyz = normalize(r3.xyz);
    r3.xyz = normalize(r2.xyz);
    r2.xyz = (r1.www) * (-(v2.xyz));
    r1.w = saturate(dot(r3.xyz, r1.xyz));
    r2.w = dot(r3.xyz, r2.xyz);
    r3.w = (r1.w) + (r1.w);
    r1.w = (r1.w) * (r1.w) + (c0.x);
    r3.z = 1.0f / (r2.w);
    r4.w = saturate(dot(r2.xyz, r1.xyz));
    r2.w = saturate(dot(r1.xyz, r0.xyz));
    r1.z = (r3.w) * (r3.z);
    r1.y = min(r4.w, r2.w);
    r3.y = saturate((r1.z) * (r1.y));
    r3.z = 1.0f / (r1.w);
    r1 = tex2D(s2, r5.xy);
    r1.z = (r1.x) * (r1.x);
    r1.w = (-(r3.z)) + (c0.y);
    r3.w = 1.0f / (r1.z);
    r1.z = (r2.w) * (r3.y);
    r1.w = (r1.w) * (r3.w);
    r1.z = rsqrt(r1.z);
    r1.y = (r1.w) * (c0.z);
    r1.w = (r3.z) * (r3.z);
    r1.y = exp2(r1.y);
    r1.z = 1.0f / (r1.z);
    r1.w = (r1.w) * (r1.y);
    r4.x = 1.0f / (r4.z);
    r3.z = (r1.z) * (r1.w);
    r1.w = dot(c[7].yz, r4.xy) + (c[7].x);
    r3.xy = saturate((r4.xx) * (c[8].xy) + (c[8].zw));
    r1.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c2.xx) + (c2.yy);
    r3.xy = (r1.xy) * (r3.xy);
    r1.xyz = normalize(v3.xyz);
    r1.w = (r1.w) * (r3.x);
    r0.y = dot(r0.xyz, r1.xyz);
    r0.z = (r3.y) * (r1.w);
    r1.w = (r0.y) + (c0.w);
    r0.xyz = (r0.zzz) * (c[6].xyz);
    r3.y = saturate((r1.w) * (c3.x));
    r1.z = saturate(dot(r2.xyz, r1.xyz));
    r1.w = (r3.y) * (c2.x) + (c2.y);
    r1.y = (r3.y) * (r3.y);
    r1.z = (r4.w) + (r1.z);
    r1.w = (r1.w) * (r1.y);
    r2.z = (r1.z) * (c2.w);
    r0.xyz = (r0.xyz) * (r1.www);
    r1.w = max(c3.z, r2.z);
    r1.xyz = (r3.zzz) * (r0.xyz);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r3.www) * (r1.xyz);
    r1.w = rsqrt(r1.w);
    r1.xyz = (r1.xyz) * (c3.yyy);
    r1.w = 1.0f / (r1.w);
    r0.xyz = (r2.www) * (r0.xyz);
    r3.xyz = (r1.xyz) * (r1.www);
    r2 = tex2D(s4, r5.xy);
    r1 = tex2D(s3, r5.xy);
    r2.xyz = (r2.xyz) * (c[21].xxx);
    r2.xyz = (r3.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v4.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v4.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
