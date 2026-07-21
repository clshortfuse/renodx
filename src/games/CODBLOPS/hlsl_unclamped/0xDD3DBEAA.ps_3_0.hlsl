// Mechanically reconstructed from 0xDD3DBEAA.ps_3_0.cso.
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
    float4 v6 : TEXCOORD6;
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
    float4 v6 = input.v6;
    float4 vPos = float4(input.vPosInput.xy, 0.0f, 0.0f);
    const float4 c0 = float4(0.999511719f, 9.99999994e-09f, 1.0f, 0.5f);
    const float4 c1 = float4(-2.0f, 3.0f, 31.875f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (vPos.xy) * (c[10].zw);
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
    r4.w = (-abs(r2.x)) + (c0.z);
    r0 = r1.xxxx;
    clip(r0.wwxx);
    r0 = r1.yyyy;
    clip(r0.wwxx);
    r0 = r1.zzzz;
    clip(r0.wwxx);
    r0 = (-(r1.xxxx)) + (c0.zzzz);
    clip(r0.wwxx);
    r2 = (-(r1.yyyy)) + (c0.zzzz);
    r0 = tex2D(s0, r1.yz);
    r3.xyz = (-(v6.xyz)) + (c[6].xyz);
    r5.y = dot(r3.xyz, r3.xyz);
    r3.w = rsqrt(r5.y);
    r5.x = 1.0f / (r3.w);
    r4.xy = saturate((r5.xx) * (c[9].xy) + (c[9].zw));
    r1.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c1.xx) + (c1.yy);
    r1.w = dot(c[8].yz, r5.xy) + (c[8].x);
    r1.xy = (r1.xy) * (r4.xy);
    r1.w = (r1.w) * (r1.x);
    r5.xyz = (r3.xyz) * (r3.www);
    r1.w = (r1.y) * (r1.w);
    r4.x = v5.w;
    r6.xyz = normalize(v5.xyz);
    r4.y = v0.w;
    r3.w = max(abs(r6.y), abs(r6.z));
    r4.z = v1.z;
    r1.y = max(abs(r6.x), r3.w);
    r1.x = 1.0f / (r1.y);
    r3.xyz = (r6.xyz) * (c[5].xyz);
    r1.y = saturate(dot(r5.xyz, r6.xyz));
    r3.xyz = (r3.xyz) * (r1.xxx) + (r4.xyz);
    r3 = tex3D(s11, r3.xyz);
    r1.w = (r1.w) * (r3.w);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4.xyz = (r3.xyz) * (c1.zzz);
    r3.xyz = (r1.yyy) * (c[7].xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r1.www) * (r3.xyz) + (r4.xyz);
    clip(r2.wwxx);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1 = (-(r1.zzzz)) + (c0.zzzz);
    r0.xyz = max(((r0.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    clip(r1.wwxx);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r4.w) * (r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
