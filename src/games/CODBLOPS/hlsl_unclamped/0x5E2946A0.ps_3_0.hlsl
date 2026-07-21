// Mechanically reconstructed from 0x5E2946A0.ps_3_0.cso.
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
    const float4 c0 = float4(6.0f, 13.0f, 8.0f, 12.0f);
    const float4 c1 = float4(0.0f, 0.75f, 31.875f, 0.5f);
    const float4 c2 = float4(-28.0f, 30.0f, 1.0f, 0.136841998f);
    const float4 c3 = float4(0.38647899f, 0.392856985f, 0.364796013f, 10.0f);
    const float4 c4 = float4(9.0f, 15.0f, 4.0f, 11.0f);
    const float4 c12 = float4(9.99999994e-09f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = normalize(v2.xyz);
    r1.x = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.x);
    r0.w = 1.0f / (r2.x);
    r1.xyz = (r0.xyz) * (c[5].xyz);
    r1.xyz = (r1.xyz) * (r0.www) + (v4.xyz);
    r1 = tex3D(s11, r1.xyz);
    r2.xyz = (r1.www) * (c[18].xyz);
    r2.xyz = (r2.xyz) * (c[6].xxx);
    r3.xyz = normalize(c[17].xyz);
    r0.w = saturate(dot(r0.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r0.www);
    r4.x = log2(abs(r2.x));
    r4.y = log2(abs(r2.y));
    r4.z = log2(abs(r2.z));
    r4.xyz = (r4.xyz) * (c1.yyy);
    r5.x = exp2(r4.x);
    r5.y = exp2(r4.y);
    r5.z = exp2(r4.z);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r4.xyz = (r1.www) * (c[19].xyz);
    r4.xyz = (r4.xyz) * (c[6].yyy);
    r1.xyz = (r1.xyz) * (c1.zzz) + (r5.xyz);
    r6.x = c[11].x;
    r7 = (-(r6.xxxx)) + (c0);
    r2.xyz = float3(((-abs(r7.x)) >= 0.0f ? (r2.x) : (c1.x)), ((-abs(r7.x)) >= 0.0f ? (r2.y) : (c1.x)), ((-abs(r7.x)) >= 0.0f ? (r2.z) : (c1.x)));
    r2.xyz = float3(((-abs(r7.y)) >= 0.0f ? (r5.x) : (r2.x)), ((-abs(r7.y)) >= 0.0f ? (r5.y) : (r2.y)), ((-abs(r7.y)) >= 0.0f ? (r5.z) : (r2.z)));
    r2.xyz = float3(((-abs(r7.z)) >= 0.0f ? (r1.x) : (r2.x)), ((-abs(r7.z)) >= 0.0f ? (r1.y) : (r2.y)), ((-abs(r7.z)) >= 0.0f ? (r1.z) : (r2.z)));
    r0.w = dot(-(r3.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r5.xyz = (r0.xyz) * (-(r0.www)) + (-(r3.xyz));
    r7.xyz = normalize(v1.xyz);
    r0.w = saturate(dot(r5.xyz, -(r7.xyz)));
    r1.w = dot(r3.xyz, r7.xyz);
    r1.w = saturate((r1.w) * (c1.w) + (c1.w));
    r2.w = (r1.w) * (c2.x) + (c2.y);
    r1.w = (r1.w) + (c2.z);
    r3.x = pow(abs(r0.w), r2.w);
    r3.xyz = (r4.xyz) * (r3.xxx);
    r3.xyz = (r1.www) * (r3.xyz);
    r2.xyz = float3(((-abs(r7.w)) >= 0.0f ? (r3.x) : (r2.x)), ((-abs(r7.w)) >= 0.0f ? (r3.y) : (r2.y)), ((-abs(r7.w)) >= 0.0f ? (r3.z) : (r2.z)));
    r4.xyz = (r3.xyz) * (c3.xyz);
    r5 = (-(r6.xxxx)) + (c4);
    r2.xyz = float3(((-abs(r5.x)) >= 0.0f ? (r4.x) : (r2.x)), ((-abs(r5.x)) >= 0.0f ? (r4.y) : (r2.y)), ((-abs(r5.x)) >= 0.0f ? (r4.z) : (r2.z)));
    r0.w = dot(r7.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r0.xyz) * (-(r0.www)) + (r7.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.zzz);
    r4 = tex3D(s11, v4.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (c1.zzz);
    r2.xyz = float3(((-abs(r5.y)) >= 0.0f ? (r0.x) : (r2.x)), ((-abs(r5.y)) >= 0.0f ? (r0.y) : (r2.y)), ((-abs(r5.y)) >= 0.0f ? (r0.z) : (r2.z)));
    r0.xyz = (r0.xyz) * (c[21].xxx);
    r2.xyz = float3(((-abs(r5.z)) >= 0.0f ? (r0.x) : (r2.x)), ((-abs(r5.z)) >= 0.0f ? (r0.y) : (r2.y)), ((-abs(r5.z)) >= 0.0f ? (r0.z) : (r2.z)));
    r0.xyz = (r3.xyz) * (c3.xyz) + (r0.xyz);
    r2.xyz = float3(((-abs(r5.w)) >= 0.0f ? (r0.x) : (r2.x)), ((-abs(r5.w)) >= 0.0f ? (r0.y) : (r2.y)), ((-abs(r5.w)) >= 0.0f ? (r0.z) : (r2.z)));
    r0.xyz = (r0.xyz) * (c2.www);
    r3.xy = (v3.xy) * (c[20].xy) + (c[20].zw);
    r3 = tex2D(s1, r3.xy);
    r0.xyz = (r1.xyz) * (r3.xyz) + (r0.xyz);
    r1.xyz = max(r0.xyz, c1.xxx);
    r0.x = (-(r6.x)) + (c3.w);
    r0.xyz = float3(((-abs(r0.x)) >= 0.0f ? (r1.x) : (r2.x)), ((-abs(r0.x)) >= 0.0f ? (r1.y) : (r2.y)), ((-abs(r0.x)) >= 0.0f ? (r1.z) : (r2.z)));
    r0.w = abs(c[11].x);
    r0.xyz = float3(((-(r0.w)) >= 0.0f ? (r1.x) : (r0.x)), ((-(r0.w)) >= 0.0f ? (r1.y) : (r0.y)), ((-(r0.w)) >= 0.0f ? (r1.z) : (r0.z)));
    r0.xyz = (r1.xyz) * (c12.xxx) + (r0.xyz);
    r0.xyz = float3(((c[11].x) >= 0.0f ? (r0.x) : (r1.x)), ((c[11].x) >= 0.0f ? (r0.y) : (r1.y)), ((c[11].x) >= 0.0f ? (r0.z) : (r1.z)));
    r0.w = c2.z;
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
    oC0.w = c2.z;

    return oC0;
}
