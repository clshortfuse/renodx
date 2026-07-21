// Mechanically reconstructed from 0x53CA4F27.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float2 vPosInput : VPOS;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    float4 vPos = float4(input.vPosInput.xy, 0.0f, 0.0f);
    const float4 c0 = float4(0.999511719f, 9.99999994e-09f, 1.0f, 0.5f);
    const float4 c1 = float4(31.875f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (vPos.xy) * (c[6].zw);
    r0 = tex2D(s1, r0.xy);
    r1.w = (-abs(r0.x)) + (c0.x);
    r0.w = max(c0.y, r1.w);
    r0.y = 1.0f / (r0.w);
    r0.w = c0.x;
    r0.z = (r0.w) * (c[4].x);
    r0.w = 1.0f / (v0.z);
    r0.z = (r0.y) * (r0.z);
    r0.xy = (r0.ww) * (v0.xy);
    r0.xy = (r0.zz) * (r0.xy);
    r0.w = c0.z;
    r2.y = dot(r0, v3);
    r2.z = dot(r0, v4);
    r2.x = dot(r0, v2);
    r1.xyz = (r2.xyz) * (c0.www) + (c0.www);
    r3.w = (-abs(r2.x)) + (c0.z);
    r0 = r1.xxxx;
    clip(r0.wwxx);
    r0 = r1.yyyy;
    clip(r0.wwxx);
    r0 = r1.zzzz;
    clip(r0.wwxx);
    r0 = (-(r1.xxxx)) + (c0.zzzz);
    clip(r0.wwxx);
    r0 = tex2D(s0, r1.yz);
    r2.xyz = normalize(v5.xyz);
    r3.z = max(abs(r2.y), abs(r2.z));
    r1.w = max(abs(r2.x), r3.z);
    r2.xyz = (r2.xyz) * (c[5].xyz);
    r1.w = 1.0f / (r1.w);
    r4.x = v5.w;
    r4.y = v0.w;
    r4.z = v1.z;
    r3.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r2.xyz) * (r1.www) + (r4.xyz);
    r2 = tex3D(s11, r0.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2 = (-(r1.yyyy)) + (c0.zzzz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    clip(r2.wwxx);
    r0.xyz = (r0.xyz) * (c[7].xxx);
    r1 = (-(r1.zzzz)) + (c0.zzzz);
    r0.xyz = max(((r0.xyz) * (c1.xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    clip(r1.wwxx);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r3.w) * (r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
