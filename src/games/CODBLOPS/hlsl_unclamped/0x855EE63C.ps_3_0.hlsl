// Mechanically reconstructed from 0x855EE63C.ps_3_0.cso.
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
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
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
    float4 v7 = input.v7;
    const float4 c0 = float4(-0.5f, 0.5f, 1.10000002f, 10.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(1.0f, -0.0f, 8.0f, 31.875f);
    const float4 c3 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(0.125f, 0.25f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 r9 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s5, v1.xy);
    r2.xy = (v1.xy) + (c0.xx);
    r2.z = c0.y;
    r1.xy = (r2.xy) * (c[20].xx) + (r2.zz);
    r1 = tex2D(s3, r1.xy);
    r4.w = (v7.w) * (c0.z) + (-(r1.x));
    r0.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r7.w = saturate((r4.w) * (c0.w));
    r1.xy = lerp(r3.xy, r0.xy, r7.ww);
    r0.xyz = v2.xyz;
    r0.xyz = (r1.xxx) * (v5.xyz) + (r0.xyz);
    r0.w = dot(v6.xyz, v6.xyz);
    r0.xyz = (r1.yyy) * (v4.xyz) + (r0.xyz);
    r3.w = rsqrt(r0.w);
    r1.xyz = normalize(r0.xyz);
    r8.xyz = (r3.www) * (v6.xyz);
    r9.xy = (r2.xy) * (c[21].xx) + (r2.zz);
    r2.z = saturate(dot(r1.xyz, -(r8.xyz)));
    r0 = tex2D(s2, v1.xy);
    r2.x = (r0.w) * (c3.x);
    r1.w = (r0.w) * (-(c3.x)) + (c3.y);
    r2.w = saturate(dot(r1.xyz, c[17].xyz));
    r2.y = (r2.z) * (r1.w) + (r2.x);
    r1.w = (r2.w) * (r1.w) + (r2.x);
    r3.xyz = (v6.xyz) * (-(r3.www)) + (c[17].xyz);
    r1.w = (r1.w) * (r2.y) + (c3.z);
    r6.w = (-(r2.z)) + (c2.x);
    r1.w = 1.0f / (r1.w);
    r3.w = (r2.w) * (r1.w);
    r2.xyz = normalize(r3.xyz);
    r4.z = saturate(dot(r1.xyz, r2.xyz));
    r3.xy = (r0.ww) * (c4.xy) + (c4.zw);
    r1.w = saturate(dot(r2.xyz, c[17].xyz));
    r3.z = exp2(r3.y);
    r5.w = 1.0f / (r3.x);
    r1.w = (-(r1.w)) + (c2.x);
    r2.x = pow(abs(r4.z), r3.z);
    r2.y = (r1.w) * (r1.w);
    r2.z = (r3.z) * (c12.x) + (c12.y);
    r2.y = (r2.y) * (r2.y);
    r2.z = (r2.x) * (r2.z);
    r1.w = (r1.w) * (r2.y);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r4.xyz = (r0.xyz) * (-(r0.xyz)) + (c2.xxx);
    r2.z = (r3.w) * (r2.z);
    r0.xyz = (r4.xyz) * (r1.www) + (r5.xyz);
    r1.w = (r0.w) * (c2.z);
    r0.xyz = (r2.zzz) * (r0.xyz);
    r2.xyz = (r0.xyz) * (c[7].www);
    r3.w = max(abs(r1.y), abs(r1.z));
    r6.xy = c[6].xy;
    r3.xyz = (r6.yyy) * (c[19].xyz);
    r0.w = max(abs(r1.x), r3.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r1.xyz) * (c[5].xyz);
    r3.xyz = (r2.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v7.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r0.xyz) * (c[7].yyy);
    r0.xyz = (r6.xxx) * (c[18].xyz);
    r2.xyz = (r2.xyz) * (c2.www);
    r0.xyz = (r2.www) * (r0.xyz);
    r7.xyz = (r3.xyz) * (r0.www);
    r6.xyz = (r0.www) * (r0.xyz) + (r2.xyz);
    r2 = tex2D(s4, r9.xy);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r3.w = (r0.w) * (v0.w);
    r3.xyz = (r0.xyz) * (r0.xyz);
    r8.w = dot(r8.xyz, r1.xyz);
    r0 = lerp(r3, r2, r7.wwww);
    r2.z = (r8.w) + (r8.w);
    r2.w = (-(r7.w)) + (c2.x);
    r1.xyz = (r1.xyz) * (-(r2.zzz)) + (r8.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r0.xyz) * (r6.xyz) + (r7.xyz);
    r3.xyz = (r1.xyz) * (c2.zzz);
    r1 = tex3D(s11, v7.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r6.w) * (r6.w);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r1.w = (r6.w) * (r1.w);
    r0.xyz = (r0.xyz) * (c2.www);
    r1.w = (r5.w) * (r1.w);
    r1.xyz = (r4.xyz) * (r1.www) + (r5.xyz);
    r1.w = ((r4.w) >= 0.0f ? (r2.w) : (c2.y));
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r1.w);
    r0.xyz = (r0.xyz) * (c[7].xxx) + (r2.xyz);
    r1.w = (r1.w) * (c[22].w);
    r0.xyz = (c[22].xyz) * (r1.www) + (r0.xyz);
    r1.xyz = (r0.www) * (r0.xyz);
    r1.w = c2.x;
    r0.x = dot(r1, c[9]);
    r0.y = dot(r1, c[10]);
    r0.z = dot(r1, c[11]);
    r0.xyz = (v3.xyz) * (-(r0.www)) + (r0.xyz);
    r0.xyz = (r0.xyz) * (v2.www);
    r0.xyz = (v3.xyz) * (r0.www) + (r0.xyz);
    r0.xyz = max(((r0.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
