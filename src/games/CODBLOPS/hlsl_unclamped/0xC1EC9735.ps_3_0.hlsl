// Mechanically reconstructed from 0xC1EC9735.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-2.0f, 3.0f, 0.0f, 0.75f);
    const float4 c1 = float4(6.0f, 13.0f, 8.0f, 12.0f);
    const float4 c2 = float4(31.875f, 0.5f, -28.0f, 30.0f);
    const float4 c3 = float4(1.0f, 0.38647899f, 0.392856985f, 0.364796013f);
    const float4 c4 = float4(9.0f, 15.0f, 4.0f, 11.0f);
    const float4 c12 = float4(0.136841998f, 10.0f, 9.99999994e-09f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (c[21].xyz) + (-(v1.xyz));
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r1.x = 1.0f / (r0.w);
    r0.xyz = (r0.xyz) * (r0.www);
    r1.y = (r1.x) * (r1.x);
    r0.w = dot(c[25].yz, r1.xy) + (c[25].x);
    r1.xy = saturate((r1.xx) * (c[26].xy) + (c[26].zw));
    r1.zw = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c0.xx) + (c0.yy);
    r1.xy = (r1.zw) * (r1.xy);
    r0.w = (r0.w) * (r1.x);
    r0.w = (r1.y) * (r0.w);
    r1.xyz = normalize(v2.xyz);
    r2.x = max(abs(r1.y), abs(r1.z));
    r3.x = max(abs(r1.x), r2.x);
    r1.w = 1.0f / (r3.x);
    r2.xyz = (r1.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (r1.www) + (v4.xyz);
    r2 = tex3D(s11, r2.xyz);
    r0.w = (r0.w) * (r2.w);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r0.www) * (c[22].xyz);
    r4.xyz = (r0.www) * (c[23].xyz);
    r4.xyz = (r4.xyz) * (c[24].yyy);
    r3.xyz = (r3.xyz) * (c[24].xxx);
    r0.w = saturate(dot(r1.xyz, r0.xyz));
    r3.xyz = (r3.xyz) * (r0.www);
    r5.x = log2(abs(r3.x));
    r5.y = log2(abs(r3.y));
    r5.z = log2(abs(r3.z));
    r5.xyz = (r5.xyz) * (c0.www);
    r6.x = exp2(r5.x);
    r6.y = exp2(r5.y);
    r6.z = exp2(r5.z);
    r2.xyz = (r2.xyz) * (c2.xxx) + (r6.xyz);
    r5.x = c[31].x;
    r7 = (-(r5.xxxx)) + (c1);
    r3.xyz = float3(((-abs(r7.x)) >= 0.0f ? (r3.x) : (c0.z)), ((-abs(r7.x)) >= 0.0f ? (r3.y) : (c0.z)), ((-abs(r7.x)) >= 0.0f ? (r3.z) : (c0.z)));
    r3.xyz = float3(((-abs(r7.y)) >= 0.0f ? (r6.x) : (r3.x)), ((-abs(r7.y)) >= 0.0f ? (r6.y) : (r3.y)), ((-abs(r7.y)) >= 0.0f ? (r6.z) : (r3.z)));
    r3.xyz = float3(((-abs(r7.z)) >= 0.0f ? (r2.x) : (r3.x)), ((-abs(r7.z)) >= 0.0f ? (r2.y) : (r3.y)), ((-abs(r7.z)) >= 0.0f ? (r2.z) : (r3.z)));
    r0.w = dot(-(r0.xyz), r1.xyz);
    r0.w = (r0.w) + (r0.w);
    r5.yzw = (r1.xyz) * (-(r0.www)) + (-(r0.xyz));
    r6.xyz = normalize(v1.xyz);
    r0.w = saturate(dot(r5.yzw, -(r6.xyz)));
    r0.x = dot(r0.xyz, r6.xyz);
    r0.x = saturate((r0.x) * (c2.y) + (c2.y));
    r0.y = (r0.x) * (c2.z) + (c2.w);
    r0.x = (r0.x) + (c3.x);
    r1.w = pow(abs(r0.w), r0.y);
    r0.yzw = (r4.xyz) * (r1.www);
    r0.xyz = (r0.xxx) * (r0.yzw);
    r3.xyz = float3(((-abs(r7.w)) >= 0.0f ? (r0.x) : (r3.x)), ((-abs(r7.w)) >= 0.0f ? (r0.y) : (r3.y)), ((-abs(r7.w)) >= 0.0f ? (r0.z) : (r3.z)));
    r4.xyz = (r0.xyz) * (c3.yzw);
    r7 = (-(r5.xxxx)) + (c4);
    r3.xyz = float3(((-abs(r7.x)) >= 0.0f ? (r4.x) : (r3.x)), ((-abs(r7.x)) >= 0.0f ? (r4.y) : (r3.y)), ((-abs(r7.x)) >= 0.0f ? (r4.z) : (r3.z)));
    r0.w = dot(r6.xyz, r1.xyz);
    r0.w = (r0.w) + (r0.w);
    r4.xyz = (r1.xyz) * (-(r0.www)) + (r6.xyz);
    r4 = texCUBE(s15, r4.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r4.xyz) * (c1.zzz);
    r6 = tex3D(s11, v4.xyz);
    r5.yzw = (r6.xyz) * (r6.xyz);
    r4.xyz = (r4.xyz) * (r5.yzw);
    r4.xyz = (r4.xyz) * (c2.xxx);
    r3.xyz = float3(((-abs(r7.y)) >= 0.0f ? (r4.x) : (r3.x)), ((-abs(r7.y)) >= 0.0f ? (r4.y) : (r3.y)), ((-abs(r7.y)) >= 0.0f ? (r4.z) : (r3.z)));
    r4.xyz = (r4.xyz) * (c[33].xxx);
    r3.xyz = float3(((-abs(r7.z)) >= 0.0f ? (r4.x) : (r3.x)), ((-abs(r7.z)) >= 0.0f ? (r4.y) : (r3.y)), ((-abs(r7.z)) >= 0.0f ? (r4.z) : (r3.z)));
    r0.xyz = (r0.xyz) * (c3.yzw) + (r4.xyz);
    r3.xyz = float3(((-abs(r7.w)) >= 0.0f ? (r0.x) : (r3.x)), ((-abs(r7.w)) >= 0.0f ? (r0.y) : (r3.y)), ((-abs(r7.w)) >= 0.0f ? (r0.z) : (r3.z)));
    r0.xyz = (r0.xyz) * (c12.xxx);
    r4.xy = (v3.xy) * (c[32].xy) + (c[32].zw);
    r4 = tex2D(s1, r4.xy);
    r0.xyz = (r2.xyz) * (r4.xyz) + (r0.xyz);
    r2.xyz = max(r0.xyz, c0.zzz);
    r0.x = (-(r5.x)) + (c12.y);
    r0.xyz = float3(((-abs(r0.x)) >= 0.0f ? (r2.x) : (r3.x)), ((-abs(r0.x)) >= 0.0f ? (r2.y) : (r3.y)), ((-abs(r0.x)) >= 0.0f ? (r2.z) : (r3.z)));
    r0.w = abs(c[31].x);
    r0.xyz = float3(((-(r0.w)) >= 0.0f ? (r2.x) : (r0.x)), ((-(r0.w)) >= 0.0f ? (r2.y) : (r0.y)), ((-(r0.w)) >= 0.0f ? (r2.z) : (r0.z)));
    r3 = (c[7]) + (-(v1.yyyy));
    r4 = (r3) * (r3);
    r5 = (c[6]) + (-(v1.xxxx));
    r4 = (r5) * (r5) + (r4);
    r6 = (c[8]) + (-(v1.zzzz));
    r4 = (r6) * (r6) + (r4);
    r7.x = rsqrt(r4.x);
    r7.y = rsqrt(r4.y);
    r7.z = rsqrt(r4.z);
    r7.w = rsqrt(r4.w);
    r8.x = c3.x;
    r4 = saturate((r4) * (c[9]) + (r8.xxxx));
    r3 = (r3) * (r7);
    r3 = (r1.yyyy) * (r3);
    r5 = (r5) * (r7);
    r6 = (r6) * (r7);
    r3 = (r5) * (r1.xxxx) + (r3);
    r1 = saturate((r6) * (r1.zzzz) + (r3));
    r1 = (r4) * (r1);
    r3.x = dot(c[10], r1);
    r3.y = dot(c[11], r1);
    r3.z = dot(c[20], r1);
    r1.xyz = (r2.xyz) * (r3.xyz) + (r2.xyz);
    r0.xyz = (r1.xyz) * (c12.zzz) + (r0.xyz);
    r0.xyz = float3(((c[31].x) >= 0.0f ? (r0.x) : (r1.x)), ((c[31].x) >= 0.0f ? (r0.y) : (r1.y)), ((c[31].x) >= 0.0f ? (r0.z) : (r1.z)));
    r0.w = c3.x;
    r1.x = dot(r0, c[28]);
    r1.y = dot(r0, c[29]);
    r1.z = dot(r0, c[30]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[27].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c3.x;

    return oC0;
}
