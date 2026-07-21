// Mechanically reconstructed from 0xEEE14566.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
    float4 v6 : TEXCOORD7;
    float4 v7 : TEXCOORD8;
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
    const float4 c1 = float4(-0.5f, 0.5f, 4.06451607f, -2.06451607f);
    const float4 c2 = float4(4.0f, -0.5f, -2.07999992f, 200.0f);
    const float4 c3 = float4(31.875f, 0.0f, 8.0f, 1.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r2.xy = c1.xy;
    r0.xy = (v7.xy) * (c[20].xx) + (r2.xx);
    r0.xy = (r0.xy) * (c[21].xx) + (r2.yy);
    r0 = tex2D(s1, r0.xy);
    r6.xy = (v7.xy) * (c[20].xx);
    r0.w = (r0.y) * (c1.z) + (c1.w);
    r1.xy = (r6.xy) * (c2.xx) + (c2.yy);
    r0.y = (r0.w) * (c1.z) + (c1.w);
    r1.xy = (r1.xy) * (c[22].xx) + (r2.yy);
    r1 = tex2D(s2, r1.xy);
    r0.w = (r1.y) * (c1.z) + (c1.w);
    r0.w = (r0.w) * (c1.z) + (c1.w);
    r0.xz = c2.zz;
    r3.xy = (r0.zw) * (c[24].xx);
    r1.xyz = v6.xyz;
    r2.xyz = (r1.zxy) * (v4.yzx);
    r3.xy = (c[23].xx) * (r0.xy) + (r3.xy);
    r0.xyz = (r1.yzx) * (v4.zxy) + (-(r2.xyz));
    r0.xyz = (r3.yyy) * (-(r0.xyz));
    r0.xyz = (r3.xxx) * (v4.xyz) + (r0.xyz);
    r0.w = dot(-(v5.xyz), -(v5.xyz));
    r0.xyz = (r0.xyz) + (v6.xyz);
    r2.w = rsqrt(r0.w);
    r3.xyz = normalize(r0.xyz);
    r0.xyz = (r2.www) * (-(v5.xyz));
    r0.w = dot(-(r0.xyz), r3.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r3.xyz) * (-(r0.www)) + (-(r0.xyz));
    r1.xyz = (r0.yyy) * (v2.xyw);
    r1.xyz = (r0.xxx) * (v1.xyw) + (r1.xyz);
    r4.xyz = (r0.zzz) * (v3.xyw) + (r1.xyz);
    r0.w = 1.0f / (r4.z);
    r4.xy = (r4.xy) * (r0.ww);
    r1.xy = (r4.xy) * (c1.yx) + (c1.yy);
    r1 = tex2D(s0, r1.xy);
    r2.xyz = (r1.xyz) * (r1.xyz);
    r0.w = c3.y;
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = 1.0f / (c[9].x);
    r1.xyz = (r0.xyz) * (c[10].xxx);
    r0.xyz = (r2.xyz) * (r0.www);
    r2.xyz = (r1.xyz) * (c3.zzz);
    r0.w = max(abs(r4.x), abs(r4.y));
    r1.xyz = (r0.xyz) * (c[11].xxx) + (-(r2.xyz));
    r0.w = saturate((r0.w) * (-(r0.w)) + (c3.w));
    r4.w = max(abs(r3.y), abs(r3.z));
    r1.w = ((-(r4.z)) >= 0.0f ? (c3.y) : (r0.w));
    r0.w = max(abs(r3.x), r4.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r3.xyz) * (c[5].xyz);
    r1.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v0.xyz);
    r0 = tex3D(s11, r0.xyz);
    r5.xyz = normalize(c[17].xyz);
    r2.xyz = (-(v5.xyz)) * (r2.www) + (r5.xyz);
    r4.xyz = normalize(r2.xyz);
    r2.xyz = (r0.www) * (c[18].xyz);
    r1.w = saturate(dot(r3.xyz, r4.xyz));
    r4.xyz = (r0.xyz) * (r0.xyz);
    r0.w = pow(abs(r1.w), c2.w);
    r2.w = saturate(dot(r3.xyz, r5.xyz));
    r3.xyz = (r0.www) * (r2.xyz) + (r1.xyz);
    r1 = tex2D(s4, r6.xy);
    r0 = tex2D(s3, r6.xy);
    r3.xyz = (r3.xyz) * (r1.xyz);
    r1.xyz = (r4.xyz) * (c3.xxx);
    r1.xyz = (r2.www) * (r2.xyz) + (r1.xyz);
    r4.xyz = normalize(v5.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.z = dot(c[6].xyz, r4.xyz);
    r1.w = saturate((c[8].y) * (r0.z) + (c[8].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[7].xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v5.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
