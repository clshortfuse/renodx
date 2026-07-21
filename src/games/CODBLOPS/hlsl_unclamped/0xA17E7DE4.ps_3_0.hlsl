// Mechanically reconstructed from 0xA17E7DE4.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD4;
    float4 v3 : TEXCOORD5;
    float4 v4 : COLOR0;
    float4 v5 : TEXCOORD8;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(31.875f, 1.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v0.xy);
    r2.xyz = normalize(v1.xyz);
    r3.w = max(abs(r2.y), abs(r2.z));
    r0.xyz = (r0.xyz) * (c[21].xyz);
    r1.w = max(abs(r2.x), r3.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r2.xyz) * (c[5].xyz);
    r2.w = saturate(dot(r2.xyz, c[17].xyz));
    r1.xyz = (r1.xyz) * (r1.www) + (v2.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.w = (r2.w) * (r1.w);
    r4.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (c[23].x) + (c[23].y);
    r3.xyz = (r1.www) * (c[18].xyz);
    r1 = (-(v5.yyyy)) + (c[7]);
    r2 = (r1) * (r1);
    r1 = (-(v5.xxxx)) + (c[6]);
    r2 = (r1) * (r1) + (r2);
    r1 = (-(v5.zzzz)) + (c[8]);
    r4.xyz = (r4.xyz) * (v0.zzz);
    r1 = (r1) * (r1) + (r2);
    r4.xyz = (r4.xyz) * (c0.xxx);
    r2.z = c0.y;
    r1 = saturate((r1) * (c[9]) + (r2.zzzz));
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r1.xyz = (r3.xyz) * (v4.xyz) + (r4.xyz);
    r2.xyz = (r0.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = saturate((r0.w) + (r0.w));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
