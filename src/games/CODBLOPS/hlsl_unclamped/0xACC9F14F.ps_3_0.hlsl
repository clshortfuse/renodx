// Mechanically reconstructed from 0xACC9F14F.ps_3_0.cso.
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
    float4 v6 : TEXCOORD4;
    float4 v7 : TEXCOORD5;
    float4 v8 : TEXCOORD6;
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
    float4 v8 = input.v8;
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(31.875f, 0.797884583f, 1.0f, 0.0009765625f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c14 = float4(4.0f, -3.0f, -4.0f, 0.0f);
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
    float4 r10 = 0.0f;
    float4 r11 = 0.0f;
    float4 r12 = 0.0f;
    float4 r13 = 0.0f;
    float4 r14 = 0.0f;
    float4 r15 = 0.0f;
    float4 r16 = 0.0f;
    float4 r17 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v7.xyz, v7.xyz);
    r4.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r4.www)) + (c[17].xyz);
    r3.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r3.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c0.y);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r4.z = (r0.w) * (r0.z);
    r0.xy = (v1.xy) * (c[8].xy);
    r1 = tex2D(s4, r0.xy);
    r0 = tex2D(s0, v1.xy);
    r5.w = (r0.w) * (v0.w) + (c0.x);
    r2 = tex2D(s1, v1.xy);
    r2.xy = (r2.wy) * (c1.xy) + (c1.zw);
    r1.xyz = (r1.xyz) + (c0.xxx);
    r2.xy = float2(((r5.w) >= 0.0f ? (r2.x) : (c0.z)), ((r5.w) >= 0.0f ? (r2.y) : (c0.z)));
    r0.xyz = saturate((r1.xyz) * (r0.www) + (r0.xyz));
    r1 = v2;
    r1.xyz = (r2.xxx) * (v5.xyz) + (r1.xyz);
    r1.xyz = (r2.yyy) * (v4.xyz) + (r1.xyz);
    r0.w = c0.y;
    r12.xyz = normalize(r1.xyz);
    r0 = float4(((r5.w) >= 0.0f ? (r0.x) : (c0.z)), ((r5.w) >= 0.0f ? (r0.y) : (c0.z)), ((r5.w) >= 0.0f ? (r0.z) : (c0.z)), ((r5.w) >= 0.0f ? (r0.w) : (c0.z)));
    r4.y = saturate(dot(r12.xyz, r3.xyz));
    r0.xyz = (r0.xyz) * (v0.xyz);
    r2 = tex2D(s3, v1.xy);
    r3 = float4(((r5.w) >= 0.0f ? (r2.x) : (c0.z)), ((r5.w) >= 0.0f ? (r2.y) : (c0.z)), ((r5.w) >= 0.0f ? (r2.z) : (c0.z)), ((r5.w) >= 0.0f ? (r2.w) : (c0.y)));
    r10.xyz = (r3.xyz) * (-(r3.xyz)) + (c0.yyy);
    r11.xyz = (r3.xyz) * (r3.xyz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r10.xyz) * (r4.zzz) + (r11.xyz);
    r0.z = (r3.w) * (-(c3.y)) + (c3.z);
    r3.xyz = (r4.www) * (v7.xyz);
    r9.w = saturate(dot(r12.xyz, -(r3.xyz)));
    r0.y = (r3.w) * (c3.y);
    r4.w = (r9.w) * (r0.z) + (r0.y);
    r16.xy = (r3.ww) * (c4.xy) + (c4.zw);
    r4.z = exp2(r16.y);
    r2.w = saturate(dot(r12.xyz, c[17].xyz));
    r0.x = pow(abs(r4.y), r4.z);
    r0.y = (r2.w) * (r0.z) + (r0.y);
    r0.z = (r4.z) * (c12.x) + (c12.y);
    r0.y = (r0.y) * (r4.w) + (c3.w);
    r0.z = (r0.x) * (r0.z);
    r0.y = 1.0f / (r0.y);
    r0.y = (r2.w) * (r0.y);
    r4.w = max(abs(r12.y), abs(r12.z));
    r4.z = (r0.z) * (r0.y);
    r0.z = max(abs(r12.x), r4.w);
    r4.w = 1.0f / (r0.z);
    r0.xyz = (r12.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (r4.zzz);
    r0.xyz = (r0.xyz) * (r4.www) + (v8.xyz);
    r4 = tex3D(s11, r0.xyz);
    r0.xyz = (r4.xyz) * (r4.xyz);
    r4.y = c0.z;
    r9.xyz = float3(((r5.w) >= 0.0f ? (c[7].x) : (r4.y)), ((r5.w) >= 0.0f ? (c[7].y) : (r4.y)), ((r5.w) >= 0.0f ? (c[7].w) : (r4.y)));
    r4.xyz = (r2.xyz) * (r9.zzz);
    r17.xy = c[6].xy;
    r2.xyz = (r17.xxx) * (c[18].xyz);
    r0.xyz = (r0.xyz) * (r9.yyy);
    r14.xyz = (r2.www) * (r2.xyz);
    r2 = tex2D(s5, v1.xy);
    r0.xyz = (r0.xyz) * (r2.www);
    r13.xyz = (r4.xyz) * (r2.www);
    r15.xyz = (r0.xyz) * (c3.xxx);
    if ((c0.y) >= (v6.w))
    {
        r5 = (v6.xyzx) * (c0.yyyz);
        r4 = (r5) + (-(c13.xyzz));
        r4 = tex2Dlod(s2, r4);
        r4.w = r4.x;
        r6 = (r5) + (c12.zzww);
        r6 = tex2Dlod(s2, r6);
        r4.x = r6.x;
        r6 = (r5) + (-(c12.zzww));
        r6 = tex2Dlod(s2, r6);
        r4.y = r6.x;
        r5 = (r5) + (c13.xyzz);
        r5 = tex2Dlod(s2, r5);
        r4.z = r5.x;
        r2.w = dot(r4, c12.yyyy);
        if ((c13.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r4.xy = (r0.xy) + (c12.zz);
            r4.zw = (v6.zx) * (c0.yz);
            r4 = tex2Dlod(s2, r4);
            r5.xy = (r0.xy) + (-(c12.zz));
            r5.zw = (v6.zx) * (c0.yz);
            r7 = tex2Dlod(s2, r5);
            r5.xy = (r0.xy) + (c13.xy);
            r5.zw = (v6.zx) * (c0.yz);
            r6 = tex2Dlod(s2, r5);
            r5.xy = (r0.xy) + (-(c13.xy));
            r5.zw = (v6.zx) * (c0.yz);
            r5 = tex2Dlod(s2, r5);
            r4.y = r7.x;
            r4.z = r6.x;
            r4.w = r5.x;
            r0.z = dot(r4, c12.yyyy);
            r0.y = (-(r2.w)) + (r0.z);
            r0.z = (v6.w) * (c14.x) + (c14.y);
            r2.w = (r0.z) * (r0.y) + (r2.w);
        }
    }
    else
    {
        r0.z = (v6.w) + (c14.z);
        r0.z = ((r0.z) >= 0.0f ? (c0.z) : (c0.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r5.xy = (r0.xy) + (c12.zz);
            r5.zw = (v6.zz) * (c0.yz);
            r5 = tex2Dlod(s2, r5);
            r6.xy = (r0.xy) + (-(c12.zz));
            r6.zw = (v6.zz) * (c0.yz);
            r8 = tex2Dlod(s2, r6);
            r6.xy = (r0.xy) + (c13.xy);
            r6.zw = (v6.zz) * (c0.yz);
            r7 = tex2Dlod(s2, r6);
            r6.xy = (r0.xy) + (-(c13.xy));
            r6.zw = (v6.zz) * (c0.yz);
            r6 = tex2Dlod(s2, r6);
            r5.y = r8.x;
            r5.z = r7.x;
            r5.w = r6.x;
            r0.x = dot(r5, c12.yyyy);
            r0.z = saturate((v6.w) + (c14.y));
            r0.y = (r4.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r4.w;
        }
        r2.w = r0.z;
    }
    r4.xyz = (r2.www) * (r14.xyz) + (r15.xyz);
    r0.xyz = (r17.yyy) * (c[19].xyz);
    r6.xyz = (r13.xyz) * (r0.xyz);
    r5.w = 1.0f / (r16.x);
    r4.w = (-(r9.w)) + (c0.y);
    r0.z = dot(r3.xyz, r12.xyz);
    r5.z = (r4.w) * (r4.w);
    r0.z = (r0.z) + (r0.z);
    r3.w = (r3.w) * (c0.w);
    r3.xyz = (r12.xyz) * (-(r0.zzz)) + (r3.xyz);
    r3 = texCUBElod(s15, r3);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r4.w = (r4.w) * (r5.z);
    r5.xyz = (r0.xyz) * (c0.www);
    r3 = tex3D(s11, v8.xyz);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r3.w = (r5.w) * (r4.w);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.xxx);
    r5.xyz = (r10.xyz) * (r3.www) + (r11.xyz);
    r3.xyz = (r2.www) * (r6.xyz);
    r0.xyz = (r0.xyz) * (r5.xyz);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r3.xyz);
    r0.xyz = (r9.xxx) * (r0.xyz);
    r2.xyz = (r0.xyz) * (r2.xyz) + (r1.xyz);
    r2.w = c0.y;
    r0.z = dot(r2, c[20]);
    r0.x = dot(r2, c[10]);
    r0.y = dot(r2, c[11]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
