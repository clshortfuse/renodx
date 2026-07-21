// Mechanically reconstructed from 0x2110044D.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
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
    const float4 c0 = float4(-2.0f, 3.0f, 31.875f, 0.25f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v4.ww) * (c[20].xy) + (v4.xy);
    r0.zw = v4.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v4.ww) * (-(c[20].xy)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v4.ww) * (c[20].zw) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v4.ww) * (-(c[20].zw)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r2.xyz = normalize(v2.xyz);
    r3.w = max(abs(r2.y), abs(r2.z));
    r0.w = r1.x;
    r1.w = max(abs(r2.x), r3.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r2.xyz) * (c[5].xyz);
    r3.w = dot(r0, c0.wwww);
    r0.xyz = (r1.xyz) * (r1.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r1.xyz = (-(v5.xyz)) + (c[6].xyz);
    r3.y = dot(r1.xyz, r1.xyz);
    r1.w = rsqrt(r3.y);
    r1.xyz = (r1.xyz) * (r1.www);
    r3.x = 1.0f / (r1.w);
    r1.w = dot(r1.xyz, c[8].xyz);
    r1.z = saturate(dot(r1.xyz, r2.xyz));
    r2.w = saturate((r1.w) * (c[9].x) + (c[9].y));
    r2.xy = saturate((r3.xx) * (c[11].xy) + (c[11].zw));
    r1.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c0.xx) + (c0.yy);
    r1.w = dot(c[10].yz, r3.xy) + (c[10].x);
    r1.xy = (r1.xy) * (r2.xy);
    r2.w = (r2.w) * (c[9].w);
    r1.x = (r1.w) * (r1.x);
    r1.w = lerp(r0.w, r3.w, r2.w);
    r0.w = (r1.y) * (r1.x);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = (r1.w) * (r0.w);
    r2.xyz = (r0.xyz) * (c0.zzz);
    r1.xyz = (r1.zzz) * (c[7].xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r2.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
