// Mechanically reconstructed from 0x2A41AF7C.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD2;
    float4 v1 : TEXCOORD3;
    float4 v2 : TEXCOORD4;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
    float4 v5 : TEXCOORD7;
    float4 v6 : TEXCOORD8;
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
    const float4 c1 = float4(-0.5f, 0.5f, 4.06451607f, -2.06451607f);
    const float4 c2 = float4(4.0f, -0.5f, -2.07999992f, 200.0f);
    const float4 c3 = float4(-2.0f, 3.0f, 1.0f, 0.5f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c12 = float4(4.0f, -2.0f, 8.0f, 0.0f);
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
    float4 r10 = 0.0f;
    float4 oC0 = 0.0f;

    r2.xy = c1.xy;
    r0.xy = (v6.xy) * (c[23].xx) + (r2.xx);
    r0.xy = (r0.xy) * (c[24].xx) + (r2.yy);
    r0 = tex2D(s1, r0.xy);
    r6.xy = (v6.xy) * (c[23].xx);
    r0.w = (r0.y) * (c1.z) + (c1.w);
    r1.xy = (r6.xy) * (c2.xx) + (c2.yy);
    r0.y = (r0.w) * (c1.z) + (c1.w);
    r1.xy = (r1.xy) * (c[25].xx) + (r2.yy);
    r1 = tex2D(s2, r1.xy);
    r0.w = (r1.y) * (c1.z) + (c1.w);
    r0.w = (r0.w) * (c1.z) + (c1.w);
    r0.xz = c2.zz;
    r3.xy = (r0.zw) * (c[27].xx);
    r1.xyz = v5.xyz;
    r2.xyz = (r1.zxy) * (v3.yzx);
    r3.xy = (c[26].xx) * (r0.xy) + (r3.xy);
    r1.xyz = (r1.yzx) * (v3.zxy) + (-(r2.xyz));
    r0.xyz = (r3.yyy) * (-(r1.xyz));
    r0.xyz = (r3.xxx) * (v3.xyz) + (r0.xyz);
    r0.w = dot(-(v4.xyz), -(v4.xyz));
    r0.xyz = (r0.xyz) + (v5.xyz);
    r2.w = rsqrt(r0.w);
    r8.xyz = normalize(r0.xyz);
    r0.xyz = (r2.www) * (-(v4.xyz));
    r0.w = dot(-(r0.xyz), r8.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r8.xyz) * (-(r0.www)) + (-(r0.xyz));
    r2.xyz = (r0.yyy) * (v1.xyw);
    r2.xyz = (r0.xxx) * (v0.xyw) + (r2.xyz);
    r4.xyz = (r0.zzz) * (v2.xyw) + (r2.xyz);
    r0.w = 1.0f / (r4.z);
    r3.xyz = (r1.xyz) * (v3.www);
    r2.xy = (r4.xy) * (r0.ww);
    r1.xy = (r2.xy) * (c1.yx) + (c1.yy);
    r3.w = max(abs(r2.x), abs(r2.y));
    r1 = tex2D(s0, r1.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = 1.0f / (c[20].x);
    r1.xyz = (r1.xyz) * (r0.www);
    r0.w = c4.z;
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r0.xyz) * (c[21].xxx);
    r0.xyz = (-(v4.xyz)) + (c[5].xyz);
    r2.xyz = (r2.xyz) * (c12.zzz);
    r7.y = dot(r0.xyz, r0.xyz);
    r1.xyz = (r1.xyz) * (c[22].xxx) + (-(r2.xyz));
    r1.w = rsqrt(r7.y);
    r0.w = saturate((r3.w) * (-(r3.w)) + (c3.z));
    r7.x = 1.0f / (r1.w);
    r3.w = ((-(r4.z)) >= 0.0f ? (c4.z) : (r0.w));
    r5.xy = saturate((r7.xx) * (c[8].xy) + (c[8].zw));
    r4.xy = (r5.xy) * (r5.xy);
    r5.xy = (r5.xy) * (c3.xx) + (c3.yy);
    r0.w = dot(c[7].yz, r7.xy) + (c[7].x);
    r4.xy = (r4.xy) * (r5.xy);
    r1.xyz = (r3.www) * (r1.xyz) + (r2.xyz);
    r0.w = (r0.w) * (r4.x);
    r2.xyz = (r0.xyz) * (r1.www);
    r1.w = (r4.y) * (r0.w);
    r0 = tex2D(s12, v6.zw);
    r5.xyz = (-(v4.xyz)) * (r2.www) + (r2.xyz);
    r4.xyz = normalize(r5.xyz);
    r0.w = (r1.w) * (r0.y);
    r1.w = saturate(dot(r8.xyz, r4.xyz));
    r5.xyz = (r0.www) * (c[6].xyz);
    r0.w = pow(abs(r1.w), c2.w);
    r5.w = saturate(dot(r8.xyz, r2.xyz));
    r7.xyz = (r0.www) * (r5.xyz) + (r1.xyz);
    r1 = tex2D(s4, r6.xy);
    r0 = tex2D(s3, r6.xy);
    r2.xy = (v6.zw) * (c3.zw);
    r4 = tex2D(s13, r2.xy);
    r2.xy = (v6.zw) * (c4.xy) + (c4.zy);
    r2 = tex2D(s13, r2.xy);
    r4.w = r2.y;
    r6.xy = (r4.yw) * (c12.xx) + (c12.yy);
    r3.xyz = (r3.xyz) * (r6.yyy);
    r1.w = dot(v5.xyz, v5.xyz);
    r3.xyz = (r6.xxx) * (v3.xyz) + (r3.xyz);
    r1.w = rsqrt(r1.w);
    r9.xyz = (v5.xyz) * (r1.www) + (r3.xyz);
    r3 = tex2D(s14, v6.zw);
    r10.xy = (r3.xy) * (c4.ww);
    r6.xyz = normalize(r9.xyz);
    r4.xy = (r4.xz) * (r10.xx);
    r1.w = dot(r6.xyz, r8.xyz);
    r2.w = (r3.x) * (c4.w) + (-(r4.x));
    r6.xz = (r4.xy) * (c2.xx);
    r2.xy = (r2.xz) * (r10.yy);
    r3.w = (r4.z) * (-(r10.x)) + (r2.w);
    r2.w = (r3.y) * (c4.w) + (-(r2.x));
    r6.y = (r3.w) + (r3.w);
    r2.w = (r2.z) * (-(r10.y)) + (r2.w);
    r2.xz = (r2.xy) * (c2.xx);
    r2.y = (r2.w) + (r2.w);
    r3.xyz = (r7.xyz) * (r1.xyz);
    r1.xyz = (r1.www) * (r2.xyz) + (r6.xyz);
    r1.xyz = (r5.www) * (r5.xyz) + (r1.xyz);
    r4.xyz = normalize(v4.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.z = dot(c[9].xyz, r4.xyz);
    r1.w = saturate((c[11].y) * (r0.z) + (c[11].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[10].xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v4.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
