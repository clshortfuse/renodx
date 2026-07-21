// Mechanically reconstructed from 0x725DDE0F.ps_3_0.cso.
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
samplerCUBE s15 : register(s15);

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
    const float4 c0 = float4(0.200000003f, 8.0f, 31.875f, 1.0f);
    const float4 c1 = float4(0.797884583f, -2.0f, 3.0f, 1.0f);
    const float4 c2 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c3 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    r7.xyz = normalize(v2.xyz);
    r2.w = max(abs(r7.y), abs(r7.z));
    r0.w = r1.x;
    r1.w = max(abs(r7.x), r2.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r7.xyz) * (c[5].xyz);
    r4.w = dot(r0, c2.zzzz);
    r0.xyz = (r1.xyz) * (r1.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r1.xyz = (-(v5.xyz)) + (c[6].xyz);
    r5.y = dot(r1.xyz, r1.xyz);
    r2.z = rsqrt(r5.y);
    r3.xyz = (r1.xyz) * (r2.zzz);
    r1.w = dot(r3.xyz, c[9].xyz);
    r1.w = saturate((r1.w) * (c[10].x) + (c[10].y));
    r5.x = 1.0f / (r2.z);
    r3.w = (r1.w) * (c[10].w);
    r4.xy = saturate((r5.xx) * (c[20].xy) + (c[20].zw));
    r2.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c1.yy) + (c1.zz);
    r2.w = dot(c[11].yz, r5.xy) + (c[11].x);
    r2.xy = (r2.xy) * (r4.xy);
    r1.w = lerp(r0.w, r4.w, r3.w);
    r0.w = (r2.w) * (r2.x);
    r4.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r2.y) * (r0.w);
    r3.w = (r1.w) * (r0.w);
    r1.w = saturate(dot(r7.xyz, r3.xyz));
    r0 = tex2D(s2, v1.xy);
    r2.x = (r0.w) * (c1.x);
    r8.xyz = normalize(v5.xyz);
    r2.y = (r0.w) * (-(c1.x)) + (c1.w);
    r2.w = saturate(dot(r7.xyz, -(r8.xyz)));
    r0.z = (r1.w) * (r2.y) + (r2.x);
    r2.y = (r2.w) * (r2.y) + (r2.x);
    r2.w = (-(r2.w)) + (c0.w);
    r0.z = (r0.z) * (r2.y) + (c2.x);
    r0.z = 1.0f / (r0.z);
    r2.xyz = (r1.xyz) * (r2.zzz) + (-(r8.xyz));
    r5.w = (r1.w) * (r0.z);
    r1.xyz = normalize(r2.xyz);
    r2.xyz = (r1.www) * (c[7].xyz);
    r4.w = saturate(dot(r7.xyz, r1.xyz));
    r0.z = saturate(dot(r1.xyz, r3.xyz));
    r9.xy = (r0.ww) * (c3.xy) + (c3.zw);
    r3.z = exp2(r9.y);
    r0.z = (-(r0.z)) + (c0.w);
    r1.y = pow(abs(r4.w), r3.z);
    r1.w = (r0.z) * (r0.z);
    r1.z = (r3.z) * (c2.y) + (c2.z);
    r1.w = (r1.w) * (r1.w);
    r4.w = (r1.y) * (r1.z);
    r0.z = (r0.z) * (r1.w);
    r1 = tex2D(s0, v1.xy);
    r3.xyz = lerp(r1.xyz, c0.xxx, r0.xxx);
    r6.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (-(r3.xyz)) + (c0.www);
    r1.w = (r5.w) * (r4.w);
    r5.xyz = (r3.xyz) * (r0.zzz) + (r6.xyz);
    r0.z = 1.0f / (r9.x);
    r5.xyz = (r1.www) * (r5.xyz);
    r1.xyz = (r0.xxx) * (r1.xyz);
    r5.xyz = (r0.yyy) * (r5.xyz);
    r5.xyz = (r5.xyz) * (c[8].xyz);
    r4.xyz = (r4.xyz) * (r0.yyy);
    r5.xyz = (r3.www) * (r5.xyz);
    r4.xyz = (r4.xyz) * (c0.zzz);
    r4.xyz = (r3.www) * (r2.xyz) + (r4.xyz);
    r0.x = dot(r8.xyz, r7.xyz);
    r2.xyz = (r1.xyz) * (v0.xyz);
    r0.x = (r0.x) + (r0.x);
    r1.xyz = (r7.xyz) * (-(r0.xxx)) + (r8.xyz);
    r1.w = (r0.w) * (c0.y);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r7.xyz = (r1.xyz) * (c0.yyy);
    r1 = tex3D(s11, v6.xyz);
    r0.w = (r2.w) * (r2.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r2.w) * (r0.w);
    r1.xyz = (r7.xyz) * (r1.xyz);
    r0.w = (r0.z) * (r0.w);
    r1.xyz = (r1.xyz) * (c0.zzz);
    r3.xyz = (r3.xyz) * (r0.www) + (r6.xyz);
    r2.xyz = (r2.xyz) * (r4.xyz) + (r5.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz);
    r0.xyz = (r1.xyz) * (r0.yyy) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}
