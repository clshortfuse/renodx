// Mechanically reconstructed from 0xF98C905F.ps_3_0.cso.
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
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(0.5f, 0.449999988f, 0.330000013f, 0.0900000036f);
    const float4 c4 = float4(4.0f, -2.0f, 2.0f, 0.0f);
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

    r0.xy = (v4.xy) + (-(c3.xx));
    r0.w = c3.x;
    r0.xy = (r0.xy) * (c[10].xx) + (r0.ww);
    r0 = tex2D(s3, r0.xy);
    r2.xy = ddx(v4.xy);
    r3.xy = ddy(v4.yx);
    r0.z = (r2.y) * (r3.y);
    r1.xyz = ddy(v2.xyz);
    r0.z = (r2.x) * (r3.x) + (-(r0.z));
    r2.xyz = (r2.yyy) * (r1.xyz);
    r1.xyz = ddx(v2.xyz);
    r0.w = dot(v3.xyz, v3.xyz);
    r1.xyz = (r1.xyz) * (r3.xxx) + (-(r2.xyz));
    r0.w = rsqrt(r0.w);
    r2.xyz = float3(((r0.z) >= 0.0f ? (r1.x) : (-(r1.x))), ((r0.z) >= 0.0f ? (r1.y) : (-(r1.y))), ((r0.z) >= 0.0f ? (r1.z) : (-(r1.z))));
    r1.xyz = (r0.www) * (v3.xyz);
    r0.z = dot(r2.xyz, r1.xyz);
    r1.xyz = (r0.zzz) * (-(r1.xyz)) + (r2.xyz);
    r2.xyz = normalize(r1.xyz);
    r1.xyz = (r2.yzx) * (v3.zxy);
    r4.xyz = (v3.yzx) * (r2.zxy) + (-(r1.xyz));
    r1 = tex2D(s0, v4.xy);
    r6.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r1.xy = (v4.zw) * (c2.xy);
    r3 = tex2D(s13, r1.xy);
    r1.xy = (v4.zw) * (c2.xy) + (c2.zy);
    r1 = tex2D(s13, r1.xy);
    r3.w = r1.y;
    r4.xyz = (r4.xyz) * (r6.yyy);
    r5.xy = (r3.yw) * (c4.xx) + (c4.yy);
    r4.xyz = (r6.xxx) * (r2.xyz) + (r4.xyz);
    r2.xyz = (r5.yyy) * (v1.xyz);
    r4.xyz = (r4.xyz) + (v3.xyz);
    r2.xyz = (r5.xxx) * (v0.xyz) + (r2.xyz);
    r5.xyz = normalize(r4.xyz);
    r4.xyz = (v3.xyz) * (r0.www) + (r2.xyz);
    r2 = tex2D(s14, v4.zw);
    r8.xy = (r2.xy) * (c2.ww);
    r7.xyz = normalize(r4.xyz);
    r3.xy = (r3.xz) * (r8.xx);
    r0.w = dot(r7.xyz, r5.xyz);
    r0.z = (r2.x) * (c2.w) + (-(r3.x));
    r6.xz = (r3.xy) * (c4.xx);
    r1.xy = (r1.xz) * (r8.yy);
    r0.y = (r3.z) * (-(r8.x)) + (r0.z);
    r0.z = (r2.y) * (c2.w) + (-(r1.x));
    r6.y = (r0.y) + (r0.y);
    r0.z = (r1.z) * (-(r8.y)) + (r0.z);
    r2.xz = (r1.xy) * (c4.xx);
    r2.y = (r0.z) + (r0.z);
    r3.xyz = (r0.www) * (r2.xyz) + (r6.xyz);
    r1 = tex2D(s1, v4.xy);
    r0.w = (r1.x) * (r1.x);
    r1.xy = (r1.xx) * (r1.xx) + (c3.zw);
    r8.xy = (r0.ww) * (c3.xy);
    r9.x = 1.0f / (r1.x);
    r9.y = 1.0f / (r1.y);
    r4.xyz = normalize(-(v2.xyz));
    r0.w = (r8.x) * (-(r9.x)) + (c2.x);
    r0.z = dot(r7.xyz, r4.xyz);
    r3.xyz = (r3.xyz) * (r0.www);
    r1.xyz = (r0.zzz) * (r2.xyz) + (r6.xyz);
    r0.y = (r8.y) * (r9.y);
    r1.xyz = (r3.xyz) * (r1.xyz);
    r0.z = saturate(dot(r5.xyz, r4.xyz));
    r2.xyz = normalize(c[17].xyz);
    r1.w = saturate(dot(r5.xyz, r2.xyz));
    r2.w = dot(r2.xyz, r4.xyz);
    r2.w = saturate((r1.w) * (-(r0.z)) + (r2.w));
    r2.z = 1.0f / (r0.z);
    r2.w = (r0.y) * (r2.w);
    r2.z = saturate((r1.w) * (r2.z));
    r1.x = rsqrt(r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = rsqrt(r1.z);
    r2.w = (r2.w) * (r2.z);
    r2.x = 1.0f / (r1.x);
    r2.y = 1.0f / (r1.y);
    r2.z = 1.0f / (r1.z);
    r0.w = (r0.w) * (r1.w) + (r2.w);
    r1 = tex2D(s12, v4.zw);
    r1.xyz = (r1.yyy) * (c[18].xyz);
    r2.xyz = (r0.yyy) * (r2.xyz);
    r3.xyz = (r1.xyz) * (r0.www) + (r3.xyz);
    r0.w = (r0.z) * (r0.z);
    r1.xyz = normalize(v2.xyz);
    r0.y = (r0.z) * (-(r0.z)) + (c2.x);
    r0.z = dot(c[5].xyz, r1.xyz);
    r0.z = saturate((c[7].y) * (r0.z) + (c[7].x));
    r1.xyz = c[0].xyz;
    r1.xyz = (-(r1.xyz)) + (c[6].xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (c2.x) : (r0.y));
    r1.xyz = (r0.zzz) * (r1.xyz) + (c[0].xyz);
    r3.xyz = (r2.xyz) * (r0.www) + (r3.xyz);
    r2.xyz = (r1.xyz) * (c[0].www);
    r1 = tex2D(s2, v4.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r3.xyz) * (r1.xyz) + (-(r2.xyz));
    r1.w = (r0.x) + (-(c2.x));
    r0.xyz = (v0.www) * (r1.xyz) + (r2.xyz);
    r1.z = c2.x;
    r0.w = min(c[8].x, r1.z);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (c4.z) * (r0.w) + (r1.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = saturate((-(r0.w)) + (c2.x));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
