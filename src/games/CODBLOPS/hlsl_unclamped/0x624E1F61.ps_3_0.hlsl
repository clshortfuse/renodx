// Mechanically reconstructed from 0x624E1F61.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 31.875f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.25f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v4.ww) * (c[21].xy) + (v4.xy);
    r0.zw = v4.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v4.ww) * (-(c[21].xy)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v4.ww) * (c[21].zw) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v4.ww) * (-(c[21].zw)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r2.xyz = normalize(v2.xyz);
    r3.w = max(abs(r2.y), abs(r2.z));
    r0.w = r1.x;
    r1.w = max(abs(r2.x), r3.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r2.xyz) * (c[5].xyz);
    r3.w = dot(r0, c1.zzzz);
    r0.xyz = (r1.xyz) * (r1.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r1.xyz = (-(v5.xyz)) + (c[6].xyz);
    r3.y = dot(r1.xyz, r1.xyz);
    r2.w = rsqrt(r3.y);
    r1.xyz = (r1.xyz) * (r2.www);
    r1.w = dot(r1.xyz, c[9].xyz);
    r3.x = 1.0f / (r2.w);
    r1.w = saturate((r1.w) * (c[10].x) + (c[10].y));
    r2.w = saturate(dot(r1.xyz, r2.xyz));
    r2.z = (r1.w) * (c[10].w);
    r1.w = lerp(r0.w, r3.w, r2.z);
    r2.xy = saturate((r3.xx) * (c[20].xy) + (c[20].zw));
    r1.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c1.xx) + (c1.yy);
    r0.w = dot(c[11].yz, r3.xy) + (c[11].x);
    r2.xy = (r1.xy) * (r2.xy);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r2.z = (r0.w) * (r2.x);
    r0 = tex2D(s0, v1.xy);
    r2.x = (r0.w) * (v0.w) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.z = (r2.y) * (r2.z);
    r0 = float4(((r2.x) >= 0.0f ? (r0.x) : (c0.z)), ((r2.x) >= 0.0f ? (r0.y) : (c0.z)), ((r2.x) >= 0.0f ? (r0.z) : (c0.z)), ((r2.x) >= 0.0f ? (r0.w) : (c0.z)));
    r1.w = (r1.w) * (r2.z);
    r1.xyz = (r1.xyz) * (r0.www);
    r2.xyz = (r1.xyz) * (c0.www);
    r1.xyz = c[7].xyz;
    r1.xyz = (r1.xyz) * (c[8].xxx);
    r1.xyz = (r2.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r1.xyz) * (r0.xyz);
    r1.w = c0.y;
    r0.x = dot(r1, c[23]);
    r0.y = dot(r1, c[24]);
    r0.z = dot(r1, c[25]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
