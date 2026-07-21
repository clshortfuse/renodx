// Mechanically reconstructed from 0x76174C6B.ps_3_0.cso.
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
    const float4 c3 = float4(0.959999979f, 0.0399999991f, 0.0009765625f, 0.25f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(0.125f, 0.25f, 1.0f, 0.0f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c15 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = v2;
    r0.xyz = (r1.xxx) * (v5.xyz) + (r0.xyz);
    r1.w = dot(v7.xyz, v7.xyz);
    r0.xyz = (r1.yyy) * (v4.xyz) + (r0.xyz);
    r4.w = rsqrt(r1.w);
    r10.xyz = normalize(r0.xyz);
    r2 = tex2D(s3, v1.xy);
    r3.w = (r2.w) * (-(c1.w)) + (c1.z);
    r0.xyz = (r4.www) * (v7.xyz);
    r1.w = saturate(dot(r10.xyz, -(r0.xyz)));
    r4.z = (r2.w) * (c1.w);
    r2.x = (r1.w) * (r3.w) + (r4.z);
    r1.w = (-(r1.w)) + (c1.z);
    r1.z = (r1.w) * (r1.w);
    r3.xy = (r2.ww) * (c4.xy) + (c4.zw);
    r1.w = (r1.w) * (r1.z);
    r1.y = 1.0f / (r3.x);
    r1.z = dot(r0.xyz, r10.xyz);
    r1.w = (r1.w) * (r1.y);
    r1.z = (r1.z) + (r1.z);
    r2.z = (r1.w) * (c3.x) + (c3.y);
    r1.w = (r2.w) * (c1.x);
    r1.xyz = (r10.xyz) * (-(r1.zzz)) + (r0.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r2.w = exp2(r3.y);
    r3.xyz = (r0.xyz) * (c1.xxx);
    r1 = tex3D(s11, v8.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r3.xyz = (v7.xyz) * (-(r4.www)) + (c[17].xyz);
    r1.xyz = (r0.xyz) * (c1.yyy);
    r0.xyz = normalize(r3.xyz);
    r7.xyz = (r2.zzz) * (r1.xyz);
    r1.w = saturate(dot(r0.xyz, c[17].xyz));
    r1.z = saturate(dot(r10.xyz, r0.xyz));
    r2.z = saturate(dot(r10.xyz, c[17].xyz));
    r0.x = pow(abs(r1.z), r2.w);
    r0.z = (r2.z) * (r3.w) + (r4.z);
    r0.y = (r2.w) * (c12.x) + (c12.y);
    r0.z = (r0.z) * (r2.x) + (c3.z);
    r0.y = (r0.x) * (r0.y);
    r0.z = 1.0f / (r0.z);
    r0.x = (r2.z) * (r0.z);
    r0.z = (-(r1.w)) + (c1.z);
    r2.w = (r0.y) * (r0.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.y) * (r0.y);
    r1.w = max(abs(r10.y), abs(r10.z));
    r1.z = (r0.z) * (r0.y);
    r0.z = max(abs(r10.x), r1.w);
    r1.w = 1.0f / (r0.z);
    r0.xyz = (r10.xyz) * (c[5].xyz);
    r2.x = (r1.z) * (c3.x) + (c3.y);
    r0.xyz = (r0.xyz) * (r1.www) + (v8.xyz);
    r1 = tex3D(s11, r0.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r2.w = (r2.w) * (r2.x);
    r0.xyz = (r2.yyy) * (r0.xyz);
    r9.xyz = (r0.xyz) * (c1.yyy);
    r8.xyz = (r2.zzz) * (c[18].xyz);
    if ((c1.z) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c12.zzzw);
        r1 = (r3) + (-(c13.xyzz));
        r1 = tex2Dlod(s2, r1);
        r1.w = r1.x;
        r4 = (r3) + (c14.xxyy);
        r4 = tex2Dlod(s2, r4);
        r1.x = r4.x;
        r4 = (r3) + (c14.zzyy);
        r4 = tex2Dlod(s2, r4);
        r1.y = r4.x;
        r3 = (r3) + (c13.xyzz);
        r3 = tex2Dlod(s2, r3);
        r1.z = r3.x;
        r0.z = dot(r1, c3.wwww);
        if ((c14.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c14.xx);
            r1.zw = (v6.zx) * (c12.zw);
            r1 = tex2Dlod(s2, r1);
            r3.xy = (r0.xy) + (c14.zz);
            r3.zw = (v6.zx) * (c12.zw);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c13.xy);
            r3.zw = (v6.zx) * (c12.zw);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c13.xy));
            r3.zw = (v6.zx) * (c12.zw);
            r3 = tex2Dlod(s2, r3);
            r1.y = r5.x;
            r1.z = r4.x;
            r1.w = r3.x;
            r0.y = dot(r1, c3.wwww);
            r0.x = (-(r0.z)) + (r0.y);
            r0.y = (v6.w) * (c15.x) + (c15.y);
            r1.w = (r0.y) * (r0.x) + (r0.z);
        }
        else
        {
            r1.w = r0.z;
        }
    }
    else
    {
        r0.z = (v6.w) + (c13.w);
        r0.z = ((r0.z) >= 0.0f ? (c12.w) : (c12.z));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c14.xx);
            r3.zw = (v6.zz) * (c12.zw);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (c14.zz);
            r4.zw = (v6.zz) * (c12.zw);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c13.xy);
            r4.zw = (v6.zz) * (c12.zw);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c13.xy));
            r4.zw = (v6.zz) * (c12.zw);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c3.wwww);
            r0.z = saturate((v6.w) + (c15.y));
            r0.y = (r1.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r1.w;
        }
        r1.w = r0.z;
    }
    r0.z = (r2.y) * (r2.w);
    r0.xyz = (r0.zzz) * (c[19].xyz);
    r8.xyz = (r1.www) * (r8.xyz) + (r9.xyz);
    r9.xyz = (r1.www) * (r0.xyz);
    r6 = tex2D(s0, v1.xy);
    r5 = (-(v7.yyyy)) + (c[7]);
    r4 = (-(v7.xxxx)) + (c[6]);
    r1 = (r5) * (r5);
    r1 = (r4) * (r4) + (r1);
    r3 = (-(v7.zzzz)) + (c[8]);
    r1 = (r3) * (r3) + (r1);
    r0.xyz = (r6.xyz) * (v0.xyz);
    r6.x = rsqrt(r1.x);
    r6.y = rsqrt(r1.y);
    r6.z = rsqrt(r1.z);
    r6.w = rsqrt(r1.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r5 = (r5) * (r6);
    r5 = (r10.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r10.xxxx) + (r5);
    r3 = saturate((r3) * (r10.zzzz) + (r4));
    r2.x = c1.z;
    r1 = saturate((r1) * (c[9]) + (r2.xxxx));
    r4.xyz = (r0.xyz) * (r8.xyz) + (r9.xyz);
    r1 = (r3) * (r1);
    r3.xyz = (r7.xyz) * (r2.yyy) + (r4.xyz);
    r2.z = dot(c[20], r1);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.z;

    return oC0;
}
