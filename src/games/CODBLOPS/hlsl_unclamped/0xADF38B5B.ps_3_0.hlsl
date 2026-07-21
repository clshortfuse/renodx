// Mechanically reconstructed from 0xADF38B5B.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD4;
    float4 v7 : TEXCOORD5;
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
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 31.875f);
    const float4 c2 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c3 = float4(4.0f, -2.0f, 2.0f, 0.25f);
    const float4 c4 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v6.ww) * (c[11].xy) + (v6.xy);
    r0.zw = v6.zw;
    r0 = tex2Dproj(s2, r0);
    r1.xy = (v6.ww) * (-(c[11].xy)) + (v6.xy);
    r1.zw = v6.zw;
    r1 = tex2Dproj(s2, r1);
    r0.y = r1.x;
    r1.xy = (v6.ww) * (c[11].zw) + (v6.xy);
    r1.zw = v6.zw;
    r1 = tex2Dproj(s2, r1);
    r0.z = r1.x;
    r1.xy = (v6.ww) * (-(c[11].zw)) + (v6.xy);
    r1.zw = v6.zw;
    r1 = tex2Dproj(s2, r1);
    r0.w = r1.x;
    r2.w = dot(r0, c3.wwww);
    r0 = tex2D(s12, v1.zw);
    r1.xyz = (-(v7.xyz)) + (c[5].xyz);
    r4.y = dot(r1.xyz, r1.xyz);
    r0.z = rsqrt(r4.y);
    r3.xyz = (r1.xyz) * (r0.zzz);
    r0.w = dot(r3.xyz, c[7].xyz);
    r4.x = 1.0f / (r0.z);
    r0.w = saturate((r0.w) * (c[8].x) + (c[8].y));
    r0.z = (r0.w) * (c[8].w);
    r2.xy = saturate((r4.xx) * (c[10].xy) + (c[10].zw));
    r1.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c4.xx) + (c4.yy);
    r0.w = dot(c[9].yz, r4.xy) + (c[9].x);
    r1.xy = (r1.xy) * (r2.xy);
    r1.w = lerp(r0.y, r2.w, r0.z);
    r0.w = (r0.w) * (r1.x);
    r1.z = (r1.y) * (r0.w);
    r0.xy = (v1.zw) * (c2.xy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r2.w = (r1.w) * (r1.z);
    r4.xy = (r0.yw) * (c3.xx) + (c3.yy);
    r1 = tex2D(s1, v1.xy);
    r6.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r4.xy, r4.xy) + (c1.x);
    r0.y = dot(r6.xy, r6.xy) + (c1.x);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c1.y) + (c1.z);
    r3.w = (r0.y) * (c1.y) + (c1.z);
    r1 = tex2D(s14, v1.zw);
    r5.xy = (r1.xy) * (c1.ww);
    r1.w = (r0.w) * (r3.w);
    r2.xy = (r2.xz) * (r5.yy);
    r0.w = dot(r4.xy, r6.xy) + (c1.x);
    r0.y = (r1.y) * (c1.w) + (-(r2.x));
    r0.w = saturate((r0.w) * (r1.w) + (r1.w));
    r0.y = (r2.z) * (-(r5.y)) + (r0.y);
    r2.xz = (r2.xy) * (c2.ww);
    r2.y = (r0.y) + (r0.y);
    r2.xyz = (r0.www) * (r2.xyz);
    r0.xy = (r0.xz) * (r5.xx);
    r0.w = (r1.x) * (c1.w) + (-(r0.x));
    r1.xyz = v2.xyz;
    r4.xyz = (r6.xxx) * (v5.xyz) + (r1.xyz);
    r1.xz = (r3.ww) * (r0.xy);
    r4.xyz = (r6.yyy) * (v4.xyz) + (r4.xyz);
    r0.w = (r0.z) * (-(r5.x)) + (r0.w);
    r0.xyz = normalize(r4.xyz);
    r1.y = (r3.w) * (r0.w);
    r0.w = saturate(dot(r3.xyz, r0.xyz));
    r2.xyz = (r1.xyz) * (c3.xzx) + (r2.xyz);
    r1.xyz = (r0.www) * (c[6].xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r2.xyz = (r2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.x);
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
