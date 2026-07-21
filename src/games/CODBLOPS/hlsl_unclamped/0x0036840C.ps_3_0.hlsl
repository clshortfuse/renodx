// Mechanically reconstructed from 0x0036840C.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(-1.0f, 1.0f, 0.5f, 0.0f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.25f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, -2.0f, 3.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c0.yz);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c0.yz) + (c0.wz);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r1.xy = (r2.yw) * (c1.yy) + (c1.zz);
    r0.w = dot(r1.xy, r1.xy) + (c0.w);
    r1 = tex2D(s14, v0.zw);
    r4.xy = (r1.xy) * (c1.xx);
    r0.w = exp2(-(r0.w));
    r2.xy = (r2.xz) * (r4.xx);
    r2.w = saturate((r0.w) * (c2.x) + (c2.y));
    r0.w = (r1.x) * (c1.x) + (-(r2.x));
    r3.xz = (r2.xy) * (c1.yy);
    r0.xy = (r0.xz) * (r4.yy);
    r1.w = (r2.z) * (-(r4.x)) + (r0.w);
    r0.w = (r1.y) * (c1.x) + (-(r0.x));
    r3.y = (r1.w) + (r1.w);
    r0.w = (r0.z) * (-(r4.y)) + (r0.w);
    r2.xz = (r0.xy) * (c1.yy);
    r2.y = (r0.w) + (r0.w);
    r0.xy = (v3.ww) * (c[11].xy) + (v3.xy);
    r0.zw = v3.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v3.ww) * (-(c[11].xy)) + (v3.xy);
    r1.zw = v3.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v3.ww) * (c[11].zw) + (v3.xy);
    r1.zw = v3.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v3.ww) * (-(c[11].zw)) + (v3.xy);
    r1.zw = v3.zw;
    r1 = tex2Dproj(s1, r1);
    r0.w = r1.x;
    r2.xyz = (r2.xyz) * (r2.www) + (r3.xyz);
    r2.w = dot(r0, c1.wwww);
    r0 = tex2D(s12, v0.zw);
    r1.xyz = (-(v4.xyz)) + (c[5].xyz);
    r5.y = dot(r1.xyz, r1.xyz);
    r0.z = rsqrt(r5.y);
    r1.xyz = (r1.xyz) * (r0.zzz);
    r0.w = dot(r1.xyz, c[7].xyz);
    r5.x = 1.0f / (r0.z);
    r0.w = saturate((r0.w) * (c[8].x) + (c[8].y));
    r0.z = (r0.w) * (c[8].w);
    r4.xy = saturate((r5.xx) * (c[10].xy) + (c[10].zw));
    r3.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c2.zz) + (c2.ww);
    r0.w = dot(c[9].yz, r5.xy) + (c[9].x);
    r3.xy = (r3.xy) * (r4.xy);
    r1.w = lerp(r0.y, r2.w, r0.z);
    r0.w = (r0.w) * (r3.x);
    r0.w = (r3.y) * (r0.w);
    r0.xyz = normalize(v1.xyz);
    r1.w = (r1.w) * (r0.w);
    r1.z = saturate(dot(r1.xyz, r0.xyz));
    r0 = tex2D(s2, v5.zw);
    r0.xyz = (r0.xyz) + (c0.xxx);
    r1.xyz = (r1.zzz) * (c[6].xyz);
    r3.xyz = (v5.yyy) * (r0.xyz) + (c0.yyy);
    r0 = tex2D(s0, v0.xy);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r1.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[20].w;

    return oC0;
}
