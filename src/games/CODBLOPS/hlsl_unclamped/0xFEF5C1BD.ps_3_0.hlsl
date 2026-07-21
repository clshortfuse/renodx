// Mechanically reconstructed from 0xFEF5C1BD.ps_3_0.cso.
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
    float4 v1 : COLOR1;
    float4 v2 : COLOR0;
    float4 v3 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    const float4 c0 = float4(1.0f, 0.0f, 31.875f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (v0.zwz) * (c0.xxy) + (c0.yyx);
    r1 = tex3D(s11, r0.xyz);
    r0 = (-(v3.yyyy)) + (c[6]);
    r2 = (r0) * (r0);
    r0 = (-(v3.xxxx)) + (c[5]);
    r2 = (r0) * (r0) + (r2);
    r0 = (-(v3.zzzz)) + (c[7]);
    r0 = (r0) * (r0) + (r2);
    r1.w = c0.x;
    r0 = saturate((r0) * (c[8]) + (r1.wwww));
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.x = dot(c[9], r0);
    r2.y = dot(c[10], r0);
    r2.z = dot(c[11], r0);
    r0 = tex2D(s0, v0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r1.xyz) * (c0.zzz);
    r2.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v1.xyz));
    r1.xyz = v1.xyz;
    r0.xyz = (v2.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
