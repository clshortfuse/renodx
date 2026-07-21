// Mechanically reconstructed from 0x0187ED3A.ps_3_0.cso.
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
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD3;
    float4 v2 : TEXCOORD5;
    float4 v3 : TEXCOORD6;
    float4 v4 : TEXCOORD7;
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
    const float4 c0 = float4(2.75f, -2.0f, 0.5f, 2.0f);
    const float4 c1 = float4(75.0f, 0.5f, -0.5f, 3.68000007f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.00333333341f, 300.0f, -64.0301971f, 9.40301991f);
    const float4 c4 = float4(60.0f, 1.0f, 31.875f, 100.0f);
    const float4 c12 = float4(8.0f, 0.0f, 0.0f, 0.0f);
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

    r0 = tex2D(s1, v5.xy);
    r0.w = saturate(r0.y);
    r0.xyz = c[10].xyz;
    r0.xyz = (-(r0.yzx)) + (c[11].yzx);
    r3.xyz = (r0.www) * (r0.xyz) + (c[10].yzx);
    r0.w = frac(r3.y);
    r0.z = (r3.y) + (-(r0.w));
    r2.w = (r0.w) + (c1.z);
    r0.w = c3.x;
    r0.w = (r0.w) * (c[6].w);
    r0.z = (r0.z) * (c0.y);
    r0.w = frac(abs(r0.w));
    r2.z = exp2(r0.z);
    r3.y = ((c[6].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r1.y = (r3.y) * (c4.x);
    r8.xy = (v5.xy) * (c[9].xx);
    r0.x = (r8.x) * (r2.z) + (r1.y);
    r0.z = (r2.z) * (r8.y);
    r0 = tex2D(s2, r0.xz);
    r1.xzw = (r3.yyy) * (c3.yzw);
    r2.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0.xy = (r8.xy) * (r2.zz) + (r1.zw);
    r0 = tex2D(s2, r0.xy);
    r0.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0.w = ((r2.w) >= 0.0f ? (c0.z) : (c0.w));
    r4.xy = (r2.xy) * (r0.xy);
    r0.w = (r2.z) * (r0.w);
    r3.w = (abs(r2.w)) + (abs(r2.w));
    r0.x = (r8.x) * (r0.w) + (r1.y);
    r0.z = (r8.y) * (r0.w);
    r2.xy = (r8.xy) * (r0.ww) + (r1.zw);
    r0 = tex2D(s2, r0.xz);
    r5.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = tex2D(s2, r2.xy);
    r2.xy = (r8.xy) * (c[20].xx);
    r6.xy = (c[21].xy) * (r1.xx) + (r2.xy);
    r2.xy = (c[22].xx) * (r1.xx) + (r2.xy);
    r1 = tex2D(s3, r6.xy);
    r2 = tex2D(s3, r2.xy);
    r0.z = (r1.x) + (r2.x);
    r0.z = (r0.z) + (r0.z);
    r0.z = (r3.y) * (-(c1.x)) + (r0.z);
    r0.z = (r0.z) + (c1.y);
    r0.z = frac(r0.z);
    r0.z = (r0.z) + (c1.z);
    r0.z = (abs(r0.z)) * (c1.w);
    r0.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r1.w = pow(abs(r0.z), c0.x);
    r0.xy = (r0.xy) * (r5.xy) + (-(r4.xy));
    r0.w = lerp(c[23].x, c[23].y, r1.w);
    r2.xy = (r3.ww) * (r0.xy) + (r4.xy);
    r1.w = (r3.x) * (r0.w);
    r0 = tex2D(s0, r8.xy);
    r3.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0.xyz = v3.xyz;
    r1.xyz = (r0.zxy) * (v1.yzx);
    r2.xy = (r1.ww) * (r2.xy) + (r3.xy);
    r0.xyz = (r0.yzx) * (v1.zxy) + (-(r1.xyz));
    r0.xyz = (r2.yyy) * (-(r0.xyz));
    r0.xyz = (r2.xxx) * (v1.xyz) + (r0.xyz);
    r0.xyz = (r0.xyz) + (v3.xyz);
    r6.xyz = normalize(r0.xyz);
    r1.w = max(abs(r6.y), abs(r6.z));
    r0.w = max(abs(r6.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r6.xyz) * (c[5].xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v0.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.z = dot(-(v2.xyz), -(v2.xyz));
    r1.w = rsqrt(r0.z);
    r2.xyz = (r1.www) * (-(v2.xyz));
    r0.z = dot(-(r2.xyz), r6.xyz);
    r0.z = (r0.z) + (r0.z);
    r1.xyz = (r0.www) * (c[18].xyz);
    r0.xyz = (r6.xyz) * (-(r0.zzz)) + (-(r2.xyz));
    r2.w = saturate(dot(r6.xyz, r2.xyz));
    r0.w = c[8].x;
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r0.xyz) * (c12.xxx);
    r5.xyz = normalize(c[17].xyz);
    r7.xyz = (-(v2.xyz)) * (r1.www) + (r5.xyz);
    r4.xyz = normalize(v3.xyz);
    r0.xyz = normalize(r7.xyz);
    r1.w = max(abs(r4.y), abs(r4.z));
    r3.w = saturate(dot(r6.xyz, r0.xyz));
    r0.w = max(abs(r4.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r4.xyz) * (c[5].xyz);
    r1.w = pow(abs(r3.w), c4.w);
    r0.xyz = (r0.xyz) * (r0.www) + (v0.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = saturate(dot(r4.xyz, r5.xyz));
    r0.xyz = (r0.xyz) * (c4.zzz);
    r2.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r4.xyz = (r0.www) * (r1.xyz) + (r0.xyz);
    r1 = tex2D(s5, r8.xy);
    r0 = tex2D(s4, r8.xy);
    r0.w = (-(r2.w)) + (c4.y);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.z = (r0.w) * (r0.w);
    r1.xyz = (r4.xyz) * (r1.xyz);
    r0.z = (r0.z) * (r0.z);
    r2.w = (-(r0.x)) + (c4.y);
    r1.w = (r0.w) * (r0.z);
    r0.xyz = (r2.xyz) * (r3.zzz) + (-(r1.xyz));
    r0.w = saturate(lerp(r2.w, c4.y, r1.w));
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v4.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v4.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c4.y;

    return oC0;
}
