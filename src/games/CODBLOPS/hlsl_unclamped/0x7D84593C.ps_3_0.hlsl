// Mechanically reconstructed from 0x7D84593C.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 0.0f, 0.707106769f, 0.5f);
    const float4 c1 = float4(1.0f, 0.5f, 6.28318548f, -3.14159274f);
    const float4 c2 = float4(-1.0f, 1.0f, 0.00333333341f, 0.0f);
    const float4 c3 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c4 = float4(300.0f, 3.0f, 0.25f, 31.875f);
    const float4 c12 = float4(4.0f, -2.0f, 0.75f, 0.0f);
    const float4 c13 = float4(1.0f, 0.5f, 0.0f, 4.0f);
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

    r1.yzw = c2.yzw;
    r0.w = (r1.z) * (c[5].w);
    r0.w = frac(abs(r0.w));
    r0.w = ((c[5].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r0.w = (r0.w) * (c[9].x);
    r0.xy = (r0.ww) * (c4.xy);
    r0 = tex2D(s1, r0.xy);
    r2.xy = frac(v6.xy);
    r2.xy = (r2.xy) + (c0.xx);
    r0.z = dot(v2.xyz, v2.xyz);
    r0.w = dot(r2.xy, r2.xy) + (c0.x);
    r0.y = (r0.z) * (r0.w);
    r0.w = dot(v2.xy, r2.xy) + (c0.y);
    r0.w = (r0.w) * (r0.w) + (-(r0.y));
    r0.w = rsqrt(r0.w);
    r0.w = 1.0f / (r0.w);
    r0.y = 1.0f / (r0.z);
    r0.z = dot(v2.xy, -(r2.xy)) + (r0.w);
    r0.w = saturate(r0.x);
    r0.y = (r0.y) * (r0.z);
    r0.z = c[11].x;
    r1.z = (c[10].x) * (-(r0.z)) + (r0.z);
    r0.xy = (v2.xy) * (r0.yy) + (r2.xy);
    r0.w = (r0.w) * (r1.z);
    r2.xy = (r0.xy) * (c[7].xy);
    r2.w = (c[10].x) * (r0.z) + (r0.w);
    r0.xy = (r2.xy) * (c0.zz) + (c0.ww);
    r3.xy = (r2.xy) * (c0.zz);
    r0.zw = (r1.wy) * (c[20].xx);
    r0 = tex2Dbias(s2, r0);
    r1.xy = c1.xy;
    r1.w = (c[8].x) * (r1.x) + (r1.y);
    r1.w = frac(r1.w);
    r2.z = (r1.w) * (c1.z) + (c1.w);
    r1.xy = float2(cos(r2.z), sin(r2.z));
    r0 = (r2.wwww) * (r0);
    r2.xy = (r1.yx) * (c2.xy);
    r1.x = dot(r1.xy, r3.xy) + (c0.y);
    r1.y = dot(r2.xy, r3.xy) + (c0.y);
    r2 = (r0) * (c[21]);
    r0.xy = (r1.xy) + (c0.ww);
    r1 = tex2D(s0, r0.xy);
    r0 = tex2D(s4, v6.xy);
    r3 = tex2D(s3, v6.xy);
    r4.xy = (r3.wy) * (c3.xy) + (c3.zw);
    r3.xyz = (r4.yyy) * (v1.xyz);
    r4.xyz = (r4.xxx) * (v0.xyz) + (r3.xyz);
    r3.xy = (v6.zw) * (c13.xy);
    r5 = tex2D(s13, r3.xy);
    r3.xy = (v6.zw) * (c13.xy) + (c13.zy);
    r3 = tex2D(s13, r3.xy);
    r5.w = r3.y;
    r6.xyz = (r4.xyz) + (v4.xyz);
    r7.xy = (r5.yw) * (c12.xx) + (c12.yy);
    r3.w = dot(v4.xyz, v4.xyz);
    r4.xyz = (r7.yyy) * (v1.xyz);
    r3.w = rsqrt(r3.w);
    r4.xyz = (r7.xxx) * (v0.xyz) + (r4.xyz);
    r8.xyz = normalize(r6.xyz);
    r6.xyz = (v4.xyz) * (r3.www) + (r4.xyz);
    r4 = tex2D(s14, v6.zw);
    r10.xy = (r4.xy) * (c4.ww);
    r9.xyz = normalize(r6.xyz);
    r5.xy = (r5.xz) * (r10.xx);
    r4.w = dot(r9.xyz, r8.xyz);
    r3.w = (r4.x) * (c4.w) + (-(r5.x));
    r7.xz = (r5.xy) * (c13.ww);
    r3.w = (r5.z) * (-(r10.x)) + (r3.w);
    r7.y = (r3.w) + (r3.w);
    r3.xy = (r3.xz) * (r10.yy);
    r3.w = (r4.y) * (c4.w) + (-(r3.x));
    r4.xz = (r3.xy) * (c13.ww);
    r3.w = (r3.z) * (-(r10.y)) + (r3.w);
    r3.xyz = normalize(-(v3.xyz));
    r4.y = (r3.w) + (r3.w);
    r3.w = dot(r3.xyz, r8.xyz);
    r6.xyz = (r4.www) * (r4.xyz) + (r7.xyz);
    r3.w = (r3.w) * (-(r3.w)) + (c2.y);
    r4.w = dot(r9.xyz, r3.xyz);
    r3.w = rsqrt(r3.w);
    r4.xyz = (r4.www) * (r4.xyz) + (r7.xyz);
    r3.w = 1.0f / (r3.w);
    r4.w = saturate((r3.w) * (c4.z));
    r5.xyz = normalize(c[17].xyz);
    r7.xyz = (r4.xyz) * (r4.www);
    r5.w = saturate(dot(r3.xyz, r5.xyz));
    r3 = tex2D(s12, v6.zw);
    r4.xyz = (r3.yyy) * (c[18].xyz);
    r3.w = saturate(dot(r8.xyz, r5.xyz));
    r3.xyz = (r5.www) * (r4.xyz);
    r4.xyz = (r4.xyz) * (r3.www);
    r5.xyz = (r4.www) * (r3.xyz);
    r3.xyz = (r6.xyz) * (c12.zzz) + (r7.xyz);
    r4.xyz = (r4.xyz) * (c12.zzz) + (r5.xyz);
    r3.xyz = (r3.xyz) + (r4.xyz);
    r0.xyz = saturate((r0.xyz) * (r3.xyz));
    r0.xyz = (r1.xyz) * (-(r2.xyz)) + (r0.xyz);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v5.xyz));
    r1.x = v0.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v5.xyz);
    r1.w = (r1.w) * (-(r2.w)) + (c2.y);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (-(r0.w)) + (c2.y);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r1.w) * (-(r0.w)) + (c2.y);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
