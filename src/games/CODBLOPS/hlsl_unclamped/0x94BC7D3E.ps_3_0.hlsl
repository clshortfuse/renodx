// Mechanically reconstructed from 0x94BC7D3E.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
samplerCUBE s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-0.0f, -9.99999975e-05f, 1.0f, 64.0f);
    const float4 c1 = float4(1.44269502f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = (c[5].w) * (v1.z) + (c[5].x);
    r1.w = min(r0.w, c0.w);
    r0.z = (r1.w) * (c1.x);
    r0.x = exp2(r0.z);
    r0.z = (r0.w) + (c0.z);
    r0.y = (v1.z) * (c[5].w);
    r0.z = ((r0.w) >= 0.0f ? (r0.z) : (r0.x));
    r0.w = (abs(r0.y)) + (c0.y);
    r0.z = (r0.z) + (-(c[6].x));
    r0.y = ((r0.w) >= 0.0f ? (r0.y) : (c0.z));
    r0.x = 1.0f / (r0.y);
    r0.y = 1.0f / (v1.z);
    r0.z = (r0.z) * (r0.x);
    r0.y = (r0.y) * (c[20].x);
    r1.w = saturate(c[6].x);
    r0.xy = (r0.yy) * (v1.xy);
    r0.z = ((r0.w) >= 0.0f ? (r0.z) : (r1.w));
    r0.w = dot(r0.xy, r0.xy) + (c0.x);
    r4.w = (r0.z) * (c[5].y);
    r0.w = rsqrt(r0.w);
    r2.z = dot(v1.xyz, v1.xyz);
    r0.w = 1.0f / (r0.w);
    r1 = (r0.xyxy) * (c[22]) + (v4);
    r2.w = saturate((r0.w) * (c[21].x) + (c[21].y));
    r0 = tex2D(s2, r1.zw);
    r1 = tex2D(s1, r1.xy);
    r0.w = (r0.x) * (r1.w);
    r1.w = rsqrt(r2.z);
    r4.z = (r2.w) * (r0.w);
    r3 = texCUBE(s0, v0.xyz);
    r2 = texCUBE(s0, v0.xyw);
    r0 = lerp(r3, r2, v1.wwww);
    r2.w = (r4.z) * (v3.x);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.w = ((-(v1.z)) >= 0.0f ? (c0.x) : (r2.w));
    r2.x = dot(r0.xyz, c[7].xyz);
    r2.y = dot(r0.xyz, c[8].xyz);
    r2.z = dot(r0.xyz, c[9].xyz);
    r1.w = 1.0f / (r1.w);
    r0.xyz = lerp(r2.xyz, r1.xyz, r2.www);
    r1.w = (r4.w) * (r1.w) + (c[5].z);
    r0.xyz = (r0.xyz) * (c[20].zzz);
    r1.w = saturate(exp2(r1.w));
    r0.xyz = (r0.xyz) * (c[11].xxx) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
