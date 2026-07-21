// Mechanically reconstructed from 0x87940F58.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD7;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(7.0f, 0.5f, 2.0f, -1.0f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 0.142857f);
    const float4 c2 = float4(8.0f, 31.875f, 4.0f, 0.200000003f);
    const float4 c3 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s2, v4.xy);
    r0.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0.xy = (r0.xy) * (c0.yy) + (c0.yy);
    r0.xy = (r0.xy) * (c0.zz) + (c0.ww);
    r0.z = dot(v2.xyz, v2.xyz);
    r0.z = rsqrt(r0.z);
    r1.xyz = (r0.zzz) * (v2.xyz);
    r2.xyz = (r1.zxy) * (v3.yzx);
    r1.xyz = (r1.yzx) * (v3.zxy) + (-(r2.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    r2.xyz = (r0.yyy) * (r1.xyz);
    r0.xyw = (r0.xxx) * (v3.xyz) + (r2.xyz);
    r0.xyz = (v2.xyz) * (r0.zzz) + (r0.xyw);
    r2.xyz = normalize(r1.xyz);
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r1.xy = (abs(c0.wy)) * (v4.zw);
    r1 = tex2D(s13, r1.xy);
    r3.xy = (v4.zw) * (c1.xy) + (c1.zy);
    r3 = tex2D(s13, r3.xy);
    r1.w = r3.y;
    r1.yw = (r1.yw) * (c4.xx) + (c4.yy);
    r2.xyz = (r2.xyz) * (r1.www);
    r4.xyz = normalize(v3.xyz);
    r2.xyz = (r1.yyy) * (r4.xyz) + (r2.xyz);
    r2.xyz = (r0.xyz) * (r0.www) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r4.xyz = normalize(r2.xyz);
    r0.w = dot(r4.xyz, r0.xyz);
    r2 = tex2D(s14, v4.zw);
    r1.yw = (r2.xy) * (c2.yy);
    r2.zw = (r3.xz) * (r1.ww);
    r2.y = (r2.y) * (c2.y) + (-(r2.z));
    r3.xw = (r2.zw) * (c2.zz);
    r1.w = (r3.z) * (-(r1.w)) + (r2.y);
    r3.y = (r1.w) + (r1.w);
    r1.xw = (r1.xz) * (r1.yy);
    r2.x = (r2.x) * (c2.y) + (-(r1.x));
    r2.yw = (r1.xw) * (c2.zz);
    r1.x = (r1.z) * (-(r1.y)) + (r2.x);
    r2.z = (r1.x) + (r1.x);
    r1.xyz = (r0.www) * (r3.xyw) + (r2.yzw);
    r3.xyz = normalize(c[17].xyz);
    r0.w = saturate(dot(r0.xyz, r3.xyz));
    r3 = tex2D(s12, v4.zw);
    r3.xyz = (r3.yyy) * (c[18].xyz);
    r3.xyz = (r3.xyz) * (c[5].xxx);
    r3.xyz = (r0.www) * (r3.xyz);
    r1.xyz = (r3.xyz) * (c1.www) + (r1.xyz);
    r3.xyz = normalize(v1.xyz);
    r0.w = dot(r3.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r0.xyz) * (-(r0.www)) + (r3.xyz);
    r0.w = c2.x;
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.xxx);
    r0.xyz = (r2.yzw) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.www);
    r2 = tex2D(s3, v4.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r2 = tex2D(s4, v4.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r0.xyz);
    r1.xyz = max(r0.xyz, c1.zzz);
    r0.w = c[6].w;
    r0.xy = (r0.ww) * (c[20].xy);
    r0.xy = (r0.xy) * (c[11].xx);
    r0.xy = (v4.xy) * (c[11].xx) + (r0.xy);
    r2 = tex2D(s6, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (v5.xxx);
    r0.xyz = (r0.xyz) * (c0.xxx);
    r2.xy = (r0.ww) * (c[21].xy);
    r2.xy = (r2.xy) * (c[22].xx);
    r2.xy = (v4.xy) * (c[22].xx) + (r2.xy);
    r2 = tex2D(s5, r2.xy);
    r1.xyz = (r0.xyz) * (-(r2.xyz)) + (r1.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r2 = tex2D(s1, v4.xy);
    r0.w = (-(r2.x)) + (-(c0.w));
    r0.xyz = (r0.www) * (r1.xyz) + (r0.xyz);
    r0.w = -(c0.w);
    r1.x = dot(r0, c[8]);
    r1.y = dot(r0, c[9]);
    r1.z = dot(r0, c[10]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = -(c0.w);

    return oC0;
}
