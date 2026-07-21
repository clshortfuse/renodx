// Mechanically reconstructed from 0xF0A4E0CE.ps_3_0.cso.
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
    const float4 c0 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.0009765625f, 0.25f);
    const float4 c2 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c3 = float4(0.125f, 0.25f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v4.ww) * (c[22].xy) + (v4.xy);
    r0.zw = v4.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v4.ww) * (-(c[22].xy)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v4.ww) * (c[22].zw) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v4.ww) * (-(c[22].zw)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r6.xyz = normalize(v2.xyz);
    r2.w = max(abs(r6.y), abs(r6.z));
    r0.w = r1.x;
    r1.w = max(abs(r6.x), r2.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r6.xyz) * (c[5].xyz);
    r3.w = dot(r0, c1.wwww);
    r0.xyz = (r1.xyz) * (r1.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r2.xyz = (-(v5.xyz)) + (c[6].xyz);
    r5.y = dot(r2.xyz, r2.xyz);
    r4.z = rsqrt(r5.y);
    r3.xyz = (r2.xyz) * (r4.zzz);
    r1.w = dot(r3.xyz, c[10].xyz);
    r1.w = saturate((r1.w) * (c[11].x) + (c[11].y));
    r5.x = 1.0f / (r4.z);
    r2.w = (r1.w) * (c[11].w);
    r4.xy = saturate((r5.xx) * (c[21].xy) + (c[21].zw));
    r1.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c1.xx) + (c1.yy);
    r1.z = dot(c[20].yz, r5.xy) + (c[20].x);
    r4.xy = (r1.xy) * (r4.xy);
    r1.w = lerp(r0.w, r3.w, r2.w);
    r0.w = (r1.z) * (r4.x);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r4.y) * (r0.w);
    r1.w = (r1.w) * (r0.w);
    r4.w = saturate(dot(r6.xyz, r3.xyz));
    r0 = tex2D(s2, v1.xy);
    r4.x = (r0.w) * (c0.w);
    r4.y = (r0.w) * (-(c0.w)) + (c0.z);
    r7.xyz = normalize(v5.xyz);
    r2.w = (r4.w) * (r4.y) + (r4.x);
    r3.w = saturate(dot(r6.xyz, -(r7.xyz)));
    r4.y = (r3.w) * (r4.y) + (r4.x);
    r3.w = (-(r3.w)) + (c0.z);
    r2.w = (r2.w) * (r4.y) + (c1.z);
    r4.xyz = (r2.xyz) * (r4.zzz) + (-(r7.xyz));
    r2.w = 1.0f / (r2.w);
    r2.xyz = normalize(r4.xyz);
    r4.z = (r4.w) * (r2.w);
    r4.y = saturate(dot(r6.xyz, r2.xyz));
    r2.w = saturate(dot(r2.xyz, r3.xyz));
    r3.xy = (r0.ww) * (c2.xy) + (c2.zw);
    r3.z = exp2(r3.y);
    r2.w = (-(r2.w)) + (c0.z);
    r2.x = pow(abs(r4.y), r3.z);
    r2.z = (r2.w) * (r2.w);
    r2.y = (r3.z) * (c3.x) + (c3.y);
    r2.z = (r2.z) * (r2.z);
    r3.z = (r2.x) * (r2.y);
    r2.w = (r2.w) * (r2.z);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.zzz);
    r3.z = (r4.z) * (r3.z);
    r0.xyz = (r2.xyz) * (r2.www) + (r5.xyz);
    r2.w = 1.0f / (r3.x);
    r0.xyz = (r3.zzz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[23].www);
    r4.xy = c[9].xy;
    r3.xyz = (r4.yyy) * (c[8].xyz);
    r0.w = (r0.w) * (c0.x);
    r3.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (c[23].yyy);
    r0.xyz = (r4.xxx) * (c[7].xyz);
    r1.xyz = (r1.xyz) * (c0.yyy);
    r0.xyz = (r4.www) * (r0.xyz);
    r4.xyz = (r1.www) * (r3.xyz);
    r3.xyz = (r1.www) * (r0.xyz) + (r1.xyz);
    r1 = tex2D(s0, v1.xy);
    r0.z = dot(r7.xyz, r6.xyz);
    r0.z = (r0.z) + (r0.z);
    r1.xyz = (r1.xyz) * (v0.xyz);
    r0.xyz = (r6.xyz) * (-(r0.zzz)) + (r7.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r6.xyz = (r0.xyz) * (c0.xxx);
    r0 = tex3D(s11, v6.xyz);
    r0.w = (r3.w) * (r3.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r3.w) * (r0.w);
    r0.xyz = (r6.xyz) * (r0.xyz);
    r0.w = (r2.w) * (r0.w);
    r0.xyz = (r0.xyz) * (c0.yyy);
    r2.xyz = (r2.xyz) * (r0.www) + (r5.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz) + (r4.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (c[23].xxx) + (r1.xyz);
    r0.w = c0.z;
    r1.x = dot(r0, c[25]);
    r1.y = dot(r0, c[26]);
    r1.z = dot(r0, c[27]);
    r0.xyz = (r1.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}
