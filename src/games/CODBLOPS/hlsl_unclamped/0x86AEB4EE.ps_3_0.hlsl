// Mechanically reconstructed from 0x86AEB4EE.ps_3_0.cso.
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
    const float4 c1 = float4(1.0f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (-(v5.xyz)) + (c[21].xyz);
    r3.y = dot(r0.xyz, r0.xyz);
    r1.w = rsqrt(r3.y);
    r3.x = 1.0f / (r1.w);
    r2.xy = saturate((r3.xx) * (c[26].xy) + (c[26].zw));
    r1.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c0.xx) + (c0.yy);
    r0.w = dot(c[25].yz, r3.xy) + (c[25].x);
    r1.xy = (r1.xy) * (r2.xy);
    r0.w = (r0.w) * (r1.x);
    r7.xyz = (r0.xyz) * (r1.www);
    r5.w = (r1.y) * (r0.w);
    r0.xy = (v4.ww) * (c[27].xy) + (v4.xy);
    r0.zw = v4.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v4.ww) * (-(c[27].xy)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v4.ww) * (c[27].zw) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v4.ww) * (-(c[27].zw)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.w = r1.x;
    r1.z = dot(r0, c0.wwww);
    r6.xyz = normalize(v2.xyz);
    r0.w = dot(r7.xyz, c[23].xyz);
    r1.y = max(abs(r6.y), abs(r6.z));
    r1.w = saturate((r0.w) * (c[24].x) + (c[24].y));
    r0.w = max(abs(r6.x), r1.y);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r6.xyz) * (c[5].xyz);
    r1.w = (r1.w) * (c[24].w);
    r0.xyz = (r0.xyz) * (r0.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r4.w = lerp(r0.w, r1.z, r1.w);
    r4.xyz = (r0.xyz) * (r0.xyz);
    r3 = (-(v5.yyyy)) + (c[7]);
    r0 = (r3) * (r3);
    r2 = (-(v5.xxxx)) + (c[6]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v5.zzzz)) + (c[8]);
    r5.w = (r5.w) * (r4.w);
    r0 = (r1) * (r1) + (r0);
    r5.xyz = (r4.xyz) * (c0.zzz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r6.w = saturate(dot(r7.xyz, r6.xyz));
    r3 = (r3) * (r4);
    r3 = (r6.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r6.xxxx) + (r3);
    r3 = c[9];
    r0 = saturate((r0) * (r3) + (c1.xxxx));
    r1 = saturate((r1) * (r6.zzzz) + (r2));
    r2.xyz = (r6.www) * (c[22].xyz);
    r1 = (r0) * (r1);
    r3.x = dot(c[10], r1);
    r3.y = dot(c[11], r1);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r3.z = dot(c[20], r1);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r2.xyz = (r5.www) * (r2.xyz) + (r5.xyz);
    r3.xyz = (r3.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
