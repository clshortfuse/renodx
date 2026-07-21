// Mechanically reconstructed from 0xDFBDD667.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler3D s11 : register(s11);

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
    float4 v8 : TEXCOORD6;
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
    float4 v8 = input.v8;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(1.0f, 0.0f, 0.0f, 0.0f);
    const float4 c2 = float4(-2.0f, 3.0f, 31.875f, 0.25f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v6.ww) * (c[20].xy) + (v6.xy);
    r0.zw = v6.zw;
    r1 = tex2Dproj(s2, r0);
    r0.xy = (v6.ww) * (-(c[20].xy)) + (v6.xy);
    r0.zw = v6.zw;
    r0 = tex2Dproj(s2, r0);
    r1.y = r0.x;
    r0.xy = (v6.ww) * (c[20].zw) + (v6.xy);
    r0.zw = v6.zw;
    r0 = tex2Dproj(s2, r0);
    r1.z = r0.x;
    r0.xy = (v6.ww) * (-(c[20].zw)) + (v6.xy);
    r0.zw = v6.zw;
    r2 = tex2Dproj(s2, r0);
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = v2;
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r3.yyy) * (v4.xyz) + (r0.xyz);
    r3.xyz = normalize(r0.xyz);
    r2.w = max(abs(r3.y), abs(r3.z));
    r1.w = r2.x;
    r0.z = max(abs(r3.x), r2.w);
    r2.w = 1.0f / (r0.z);
    r0.xyz = (r3.xyz) * (c[5].xyz);
    r4.w = dot(r1, c2.wwww);
    r0.xyz = (r0.xyz) * (r2.www) + (v8.xyz);
    r1 = tex3D(s11, r0.xyz);
    r0.xyz = (-(v7.xyz)) + (c[6].xyz);
    r4.y = dot(r0.xyz, r0.xyz);
    r2.w = rsqrt(r4.y);
    r0.xyz = (r0.xyz) * (r2.www);
    r4.x = 1.0f / (r2.w);
    r2.w = dot(r0.xyz, c[8].xyz);
    r2.z = saturate(dot(r0.xyz, r3.xyz));
    r2.w = saturate((r2.w) * (c[9].x) + (c[9].y));
    r2.xy = saturate((r4.xx) * (c[11].xy) + (c[11].zw));
    r0.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c2.xx) + (c2.yy);
    r0.z = dot(c[10].yz, r4.xy) + (c[10].x);
    r0.xy = (r0.xy) * (r2.xy);
    r3.w = (r2.w) * (c[9].w);
    r0.z = (r0.z) * (r0.x);
    r2.w = lerp(r1.w, r4.w, r3.w);
    r1.w = (r0.y) * (r0.z);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r2.w = (r2.w) * (r1.w);
    r3.xyz = (r0.xyz) * (c2.zzz);
    r2.xyz = (r2.zzz) * (c[7].xyz);
    r1 = tex2D(s0, v1.xy);
    r0.xyz = (r1.xyz) * (v0.xyz);
    r1.xyz = (r2.www) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}
