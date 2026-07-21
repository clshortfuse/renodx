// Mechanically reconstructed from 0x13DC78BE.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
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
    const float4 c0 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
    const float4 c1 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c3 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
    const float4 c12 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c13 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0.w = dot(v5.xyz, v5.xyz);
    r2.w = rsqrt(r0.w);
    r0.xyz = (v5.xyz) * (-(r2.www)) + (c[17].xyz);
    r4.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r4.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c0.z);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r0.w = (r0.w) * (r0.z);
    r1 = tex2D(s2, v1.xy);
    r2.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.zzz);
    r3.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r2.xyz) * (r0.www) + (r3.xyz);
    r3.w = (r1.w) * (-(c0.w)) + (c0.z);
    r0.w = (r1.w) * (c0.x);
    r0.xyz = (r2.www) * (v5.xyz);
    r10.xyz = normalize(v2.xyz);
    r4.w = (r1.w) * (c0.w);
    r2.w = saturate(dot(r10.xyz, -(r0.xyz)));
    r5.w = (r2.w) * (r3.w) + (r4.w);
    r2.w = (-(r2.w)) + (c0.z);
    r5.z = (r2.w) * (r2.w);
    r5.xy = (r1.ww) * (c3.xy) + (c3.zw);
    r1.w = (r2.w) * (r5.z);
    r2.w = 1.0f / (r5.x);
    r2.w = (r1.w) * (r2.w);
    r5.z = exp2(r5.y);
    r5.y = saturate(dot(r10.xyz, r4.xyz));
    r1.w = saturate(dot(r10.xyz, c[17].xyz));
    r4.z = pow(abs(r5.y), r5.z);
    r3.w = (r1.w) * (r3.w) + (r4.w);
    r4.w = (r5.z) * (c1.y) + (c1.z);
    r3.w = (r3.w) * (r5.w) + (c1.x);
    r4.w = (r4.z) * (r4.w);
    r3.w = 1.0f / (r3.w);
    r4.z = (r1.w) * (r3.w);
    r3.w = dot(r0.xyz, r10.xyz);
    r4.w = (r4.w) * (r4.z);
    r3.w = (r3.w) + (r3.w);
    r8.xyz = (r1.xyz) * (r4.www);
    r0.xyz = (r10.xyz) * (-(r3.www)) + (r0.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r0.xyz) * (c0.xxx);
    r2.xyz = (r2.xyz) * (r2.www) + (r3.xyz);
    r0 = tex3D(s11, v6.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.w = max(abs(r10.y), abs(r10.z));
    r1.xyz = (r1.xyz) * (r0.xyz);
    r0.w = max(abs(r10.x), r2.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r10.xyz) * (c[5].xyz);
    r1.xyz = (r1.xyz) * (c0.yyy);
    r0.xyz = (r0.xyz) * (r0.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r7.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[21].yyy);
    r6.xyz = (r0.xyz) * (c0.yyy);
    r5.xyz = (r1.www) * (c[18].xyz);
    if ((c0.z) >= (v4.w))
    {
        r1 = (v4.xyzx) * (c12.xxxy);
        r0 = (r1) + (-(c4.xyzz));
        r0 = tex2Dlod(s1, r0);
        r0.w = r0.x;
        r2 = (r1) + (c12.zzyy);
        r2 = tex2Dlod(s1, r2);
        r0.x = r2.x;
        r2 = (r1) + (c12.wwyy);
        r2 = tex2Dlod(s1, r2);
        r0.y = r2.x;
        r1 = (r1) + (c4.xyzz);
        r1 = tex2Dlod(s1, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c1.zzzz);
        if ((c1.w) < (v4.w))
        {
            r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c12.zz);
            r0.zw = (v4.zx) * (c12.xy);
            r0 = tex2Dlod(s1, r0);
            r1.xy = (r4.xy) + (c12.ww);
            r1.zw = (v4.zx) * (c12.xy);
            r3 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (c4.xy);
            r1.zw = (v4.zx) * (c12.xy);
            r2 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (-(c4.xy));
            r1.zw = (v4.zx) * (c12.xy);
            r1 = tex2Dlod(s1, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c1.zzzz);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v4.w) * (c13.x) + (c13.y);
            r0.w = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r0.w = r4.w;
        }
    }
    else
    {
        r0.z = (v4.w) + (c4.w);
        r0.z = ((r0.z) >= 0.0f ? (c12.y) : (c12.x));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c12.zz);
            r1.zw = (v4.zz) * (c12.xy);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r0.xy) + (c12.ww);
            r2.zw = (v4.zz) * (c12.xy);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (c4.xy);
            r2.zw = (v4.zz) * (c12.xy);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (-(c4.xy));
            r2.zw = (v4.zz) * (c12.xy);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.y = dot(r1, c1.zzzz);
            r0.z = saturate((v4.w) + (c13.y));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
    }
    r0.xyz = (r8.xyz) * (c[21].www);
    r0.xyz = (r0.xyz) * (c[19].xyz);
    r8.xyz = (r0.www) * (r5.xyz) + (r6.xyz);
    r9.xyz = (r0.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r4 = (-(v5.yyyy)) + (c[7]);
    r3 = (-(v5.xxxx)) + (c[6]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v5.zzzz)) + (c[8]);
    r1 = (r2) * (r2) + (r1);
    r0 = (r0.wxyz) * (v0.wxyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r6.xyz = (r0.yzw) * (r0.yzw);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r0.y = c0.z;
    r1 = saturate((r1) * (c[9]) + (r0.yyyy));
    r3.xyz = (r6.xyz) * (r8.xyz) + (r9.xyz);
    r1 = (r2) * (r1);
    r3.xyz = (r7.xyz) * (c[21].xxx) + (r3.xyz);
    r2.z = dot(c[20], r1);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r1.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r1.x = rsqrt(r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = rsqrt(r1.z);
    r0.w = rsqrt(r0.x);
    oC0.x = 1.0f / (r1.x);
    oC0.y = 1.0f / (r1.y);
    oC0.z = 1.0f / (r1.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
