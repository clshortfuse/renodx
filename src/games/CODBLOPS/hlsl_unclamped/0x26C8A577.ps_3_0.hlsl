// Mechanically reconstructed from 0x26C8A577.ps_3_0.cso.
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
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD4;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
    float4 v5 : TEXCOORD7;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.5f, 0.449999988f, 0.330000013f, 0.0900000036f);
    const float4 c2 = float4(1.0f, 31.875f, 9.99999975e-05f, 0.100000001f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r1.xy = (v5.xy) * (c[7].xy);
    r0 = tex2D(s1, r1.xy);
    r1 = tex2D(s0, r1.xy);
    r3.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1.xyz = v3.xyz;
    r2.xyz = (r1.zxy) * (v1.yzx);
    r3.xy = (r3.xy) * (c[8].xx);
    r1.xyz = (r1.yzx) * (v1.zxy) + (-(r2.xyz));
    r1.xyz = (r3.yyy) * (-(r1.xyz));
    r1.xyz = (r3.xxx) * (v1.xyz) + (r1.xyz);
    r1.xyz = (r1.xyz) + (v3.xyz);
    r5.xyz = normalize(r1.xyz);
    r1.w = max(abs(r5.y), abs(r5.z));
    r2.w = (r0.w) + (-(c2.x));
    r0.w = max(abs(r5.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r1.xyz = (r5.xyz) * (c[5].xyz);
    r2.xyz = normalize(-(v2.xyz));
    r1.xyz = (r1.xyz) * (r0.www) + (v0.xyz);
    r1 = tex3D(s11, r1.xyz);
    r3.xyz = (r1.www) * (c[18].xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (c[9].x) * (c[9].x);
    r1.w = c[9].x;
    r6.xy = (r1.ww) * (r1.ww) + (c1.zw);
    r4.xy = (r0.ww) * (c1.xy);
    r6.x = 1.0f / (r6.x);
    r6.y = 1.0f / (r6.y);
    r0.w = (r4.x) * (-(r6.x)) + (c2.x);
    r3.w = (r4.y) * (r6.y);
    r4.xyz = (r1.xyz) * (r0.www);
    r1.xyz = normalize(c[17].xyz);
    r4.xyz = (r4.xyz) * (c2.yyy);
    r5.w = saturate(dot(r5.xyz, r1.xyz));
    r4.w = saturate(dot(r5.xyz, r2.xyz));
    r1.w = dot(r1.xyz, r2.xyz);
    r1.w = saturate((r5.w) * (-(r4.w)) + (r1.w));
    r5.y = max(abs(r2.y), abs(r2.z));
    r5.z = (r3.w) * (r1.w);
    r1.w = max(abs(r2.x), r5.y);
    r1.xyz = (r2.xyz) * (c[5].xyz);
    r1.w = 1.0f / (r1.w);
    r5.y = 1.0f / (r4.w);
    r1.xyz = (r1.xyz) * (r1.www) + (v0.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = saturate((r5.w) * (r5.y));
    r1.xyz = (r4.xyz) * (r1.xyz);
    r1.w = (r5.z) * (r1.w);
    r1.xyz = (r1.xyz) * (c2.yyy);
    r0.w = (r0.w) * (r5.w) + (r1.w);
    r1.x = rsqrt(r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = rsqrt(r1.z);
    r4.xyz = (r3.xyz) * (r0.www) + (r4.xyz);
    r1.x = 1.0f / (r1.x);
    r1.y = 1.0f / (r1.y);
    r1.z = 1.0f / (r1.z);
    r0.w = (r4.w) * (r4.w);
    r1.w = (r4.w) * (-(r4.w)) + (c2.x);
    r1.xyz = (r3.www) * (r1.xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (c2.x) : (r1.w));
    r3.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r0.www) + (r4.xyz);
    r1.xyz = normalize(v3.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz) + (-(v4.xyz));
    r0.w = dot(r2.xyz, r1.xyz);
    r1.x = v1.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v4.xyz);
    r1.w = max(c2.z, r0.w);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = pow(abs(r1.w), c2.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (r2.w) + (c2.x);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
