// Mechanically reconstructed from 0x42CE1BF6.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    centroid float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : COLOR0;
    float2 vPosInput : VPOS;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 vPos = float4(input.vPosInput.xy, 0.0f, 0.0f);
    const float4 c1 = float4(1.0f, 0.5f, -0.0f, 31.875f);
    const float4 c2 = float4(4.0f, 0.25f, 0.5f, 0.0450000018f);
    const float4 c3 = float4(10.0f, -1.44269502f, 8.0f, -9.99999975e-05f);
    const float4 c4 = float4(64.0f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c1.xy);
    r1 = tex2D(s13, r0.xy);
    r0 = tex2D(s14, v0.zw);
    r4.xy = (r0.xy) * (c1.ww);
    r1.xy = (r1.xz) * (r4.xx);
    r0.w = (r0.x) * (c1.w) + (-(r1.x));
    r5.xz = (r1.xy) * (c2.xx);
    r0.w = (r1.z) * (-(r4.x)) + (r0.w);
    r1.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r2 = tex2D(s13, r1.xy);
    r6.xz = (r4.yy) * (r2.xz);
    r5.y = (r0.w) + (r0.w);
    r2.w = (r0.y) * (c1.w) + (-(r6.x));
    r0 = tex2D(s0, v2.xy);
    r0.x = r0.w;
    r1 = tex2D(s0, v2.zw);
    r0.zw = r1.wy;
    r1 = tex2D(s1, v3.xy);
    r1.x = r1.w;
    r3 = tex2D(s1, v3.zw);
    r1.zw = r3.wy;
    r0 = (r0) * (c[24].xxxx) + (c[24].yyyy);
    r1 = (r1) * (c[24].zzzz) + (c[24].wwww);
    r2.w = (r2.z) * (-(r4.y)) + (r2.w);
    r0 = (r0) + (r1);
    r0.xy = (r0.zw) + (r0.xy);
    r0.z = c1.x;
    r0.z = dot(r0.xyz, r0.xyz);
    r0.w = dot(v1.xyz, v1.xyz);
    r4.z = rsqrt(r0.z);
    r1.w = rsqrt(r0.w);
    r4.xy = (r0.xy) * (r4.zz);
    r3.xyz = (r1.www) * (v1.xyz);
    r6.y = (r2.w) * (c1.y);
    r1.z = saturate(dot(r4.xyz, -(r3.xyz)));
    r2.xyz = (r5.xyz) + (r6.xyz);
    r1.y = (-(r1.z)) + (c1.x);
    r0.z = dot(r2.xzy, c2.yyz);
    r0.w = (r1.y) * (r1.y);
    r6.xyz = (r0.zzz) * (c[23].xyz);
    r0.w = (r0.w) * (r0.w);
    r0.xyz = c[21].xyz;
    r0.xyz = (-(r0.xyz)) + (c[22].xyz);
    r0.w = (r1.y) * (r0.w);
    r0.xyz = (r1.zzz) * (r0.xyz) + (c[21].xyz);
    r5.w = (c[20].w) * (r0.w) + (c[20].z);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.w = (-(r5.w)) + (c1.x);
    r3.w = 1.0f / (r1.w);
    r5.xyz = (r0.xyz) * (r0.www);
    r0.xy = (vPos.xy) * (c[10].zw);
    r0.zw = c1.zx;
    r0 = tex2Dproj(s3, r0);
    r0.z = (abs(r0.x)) + (-(v1.w));
    r0.w = saturate((r3.w) * (c[23].w));
    r1.w = saturate((r0.z) * (c2.w));
    r0.z = (r0.w) * (c3.y);
    r0.w = rsqrt(r1.w);
    r0.xy = (r4.xy) * (c3.xx);
    r0.w = 1.0f / (r0.w);
    r4.w = exp2(r0.z);
    r0.xy = (r0.xy) * (r0.ww) + (vPos.xy);
    r1.xyz = lerp(r6.xyz, r5.xyz, r4.www);
    r0.xy = (r0.xy) * (c[10].zw);
    r0 = tex2D(s2, r0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.w = 1.0f / (c[11].x);
    r0.w = (v4.w) * (c[21].w);
    r1.xyz = (r0.xyz) * (-(r2.www)) + (r1.xyz);
    r0.w = (r1.w) * (r0.w);
    r1.xyz = (r1.xyz) * (r0.www);
    r0.w = dot(r3.xyz, r4.xyz);
    r1.xyz = (r0.xyz) * (r2.www) + (r1.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r4.xyz) * (-(r0.www)) + (r3.xyz);
    r2.w = dot(c[7].xyz, r3.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.z = (c[5].w) * (v1.z) + (c[5].x);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.w = min(r3.z, c4.x);
    r0.xyz = (r5.www) * (r0.xyz);
    r0.w = (r0.w) * (-(c3.y));
    r2.x = exp2(r0.w);
    r2.y = (v1.z) * (c[5].w);
    r2.z = (r3.z) + (c1.x);
    r0.w = (abs(r2.y)) + (c3.w);
    r2.z = ((r3.z) >= 0.0f ? (r2.z) : (r2.x));
    r2.y = ((r0.w) >= 0.0f ? (r2.y) : (c1.x));
    r2.z = (r2.z) + (-(c[6].x));
    r2.y = 1.0f / (r2.y);
    r2.z = (r2.z) * (r2.y);
    r2.y = saturate(c[6].x);
    r0.xyz = (r4.www) * (r0.xyz);
    r0.w = ((r0.w) >= 0.0f ? (r2.z) : (r2.y));
    r0.xyz = (r1.www) * (r0.xyz);
    r0.w = (r0.w) * (c[5].y);
    r1.xyz = (r0.xyz) * (c3.zzz) + (r1.xyz);
    r0.w = (r0.w) * (r3.w) + (c[5].z);
    r2.w = saturate((c[9].y) * (r2.w) + (c[9].x));
    r0.w = saturate(exp2(r0.w));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[8].xyz);
    r0.w = (-(r0.w)) + (c1.x);
    r0.xyz = (r2.www) * (r0.xyz) + (c[0].xyz);
    r0.w = (r0.w) * (c[8].w);
    r0.xyz = (r0.xyz) * (c[0].www) + (-(r1.xyz));
    r0.w = (r1.w) * (r0.w);
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}
