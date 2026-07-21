// Mechanically reconstructed from 0xF73AE8E4.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 8.0f, 31.875f, 1.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c9 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c10 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c11 = float4(4.0f, -3.0f, -4.0f, 0.0f);
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

    r0.w = dot(v7.xyz, v7.xyz);
    r2.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r2.www)) + (c[17].xyz);
    r1.xyz = normalize(r0.xyz);
    r0 = tex2D(s1, v1.xy);
    r2.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r1.w = saturate(dot(r1.xyz, c[17].xyz));
    r0 = v2;
    r0.xyz = (r2.xxx) * (v5.xyz) + (r0.xyz);
    r2.z = (-(r1.w)) + (c0.w);
    r0.xyz = (r2.yyy) * (v4.xyz) + (r0.xyz);
    r1.w = (r2.z) * (r2.z);
    r8.xyz = normalize(r0.xyz);
    r0.z = (r1.w) * (r1.w);
    r1.w = max(abs(r8.y), abs(r8.z));
    r8.w = (r2.z) * (r0.z);
    r0.z = max(abs(r8.x), r1.w);
    r10.w = saturate(dot(r8.xyz, r1.xyz));
    r1.w = 1.0f / (r0.z);
    r9.xyz = (r2.www) * (v7.xyz);
    r0.xyz = (r8.xyz) * (c[5].xyz);
    r7.w = saturate(dot(r8.xyz, -(r9.xyz)));
    r0.xyz = (r0.xyz) * (r1.www) + (v8.xyz);
    r2 = tex3D(s11, r0.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r9.w = saturate(dot(r8.xyz, c[17].xyz));
    r0.xyz = (r0.xyz) * (c[6].yyy);
    r1 = tex2D(s5, v1.xy);
    r0.xyz = (r0.xyz) * (r1.www);
    r10.xyz = (r0.xyz) * (c0.zzz);
    r7.xyz = (r9.www) * (c[18].xyz);
    if ((c0.w) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c3.yyyw);
        r2 = (r3) + (-(c10.xyzz));
        r2 = tex2Dlod(s2, r2);
        r2.w = r2.x;
        r4 = (r3) + (c9.zzww);
        r4 = tex2Dlod(s2, r4);
        r2.x = r4.x;
        r4 = (r3) + (-(c9.zzww));
        r4 = tex2Dlod(s2, r4);
        r2.y = r4.x;
        r3 = (r3) + (c10.xyzz);
        r3 = tex2Dlod(s2, r3);
        r2.z = r3.x;
        r0.z = dot(r2, c9.yyyy);
        if ((c10.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c9.zz);
            r2.zw = (v6.zx) * (c3.yw);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r0.xy) + (-(c9.zz));
            r3.zw = (v6.zx) * (c3.yw);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c10.xy);
            r3.zw = (v6.zx) * (c3.yw);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c10.xy));
            r3.zw = (v6.zx) * (c3.yw);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.y = dot(r2, c9.yyyy);
            r0.x = (-(r0.z)) + (r0.y);
            r0.y = (v6.w) * (c11.x) + (c11.y);
            r4.w = (r0.y) * (r0.x) + (r0.z);
        }
        else
        {
            r4.w = r0.z;
        }
    }
    else
    {
        r0.z = (v6.w) + (c11.z);
        r0.z = ((r0.z) >= 0.0f ? (c3.w) : (c3.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c9.zz);
            r3.zw = (v6.zz) * (c3.yw);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (-(c9.zz));
            r4.zw = (v6.zz) * (c3.yw);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c10.xy);
            r4.zw = (v6.zz) * (c3.yw);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c10.xy));
            r4.zw = (v6.zz) * (c3.yw);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c9.yyyy);
            r0.z = saturate((v6.w) + (c11.y));
            r0.y = (r2.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r2.w;
        }
        r4.w = r0.z;
    }
    r4.xyz = (r4.www) * (r7.xyz) + (r10.xyz);
    r0.xy = (v1.xy) * (c[7].xy);
    r2 = tex2D(s4, r0.xy);
    r0.xyz = (r2.xyz) + (c0.xxx);
    r3 = tex2D(s0, v1.xy);
    r2 = tex2D(s3, v1.xy);
    r5.xyz = (r2.xyz) * (-(r2.xyz)) + (c0.www);
    r7.xyz = (r2.xyz) * (r2.xyz);
    r2.z = (r2.w) * (-(c3.x)) + (c3.y);
    r2.x = (r2.w) * (c3.x);
    r2.y = (r7.w) * (r2.z) + (r2.x);
    r2.z = (r9.w) * (r2.z) + (r2.x);
    r2.z = (r2.z) * (r2.y) + (c3.z);
    r10.xy = (r2.ww) * (c4.xy) + (c4.zw);
    r2.x = 1.0f / (r2.z);
    r5.w = exp2(r10.y);
    r2.y = pow(abs(r10.w), r5.w);
    r2.z = (r5.w) * (c9.x) + (c9.y);
    r6.w = (r9.w) * (r2.x);
    r5.w = (r2.y) * (r2.z);
    r2.xyz = (r5.xyz) * (r8.www) + (r7.xyz);
    r5.w = (r6.w) * (r5.w);
    r2.xyz = (r2.xyz) * (r5.www);
    r2.xyz = (r2.xyz) * (c[6].www);
    r2.xyz = (r1.www) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[19].xyz);
    r0.xyz = saturate((r0.xyz) * (r3.www) + (r3.xyz));
    r3.xyz = (r4.www) * (r2.xyz);
    r6.xyz = (r0.xyz) * (v0.xyz);
    r3.w = 1.0f / (r10.x);
    r1.w = (-(r7.w)) + (c0.w);
    r0.z = dot(r9.xyz, r8.xyz);
    r4.w = (r1.w) * (r1.w);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r2.w) * (c0.y);
    r2.xyz = (r8.xyz) * (-(r0.zzz)) + (r9.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r1.w) * (r4.w);
    r8.xyz = (r0.xyz) * (c0.yyy);
    r2 = tex3D(s11, v8.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r3.w) * (r1.w);
    r0.xyz = (r8.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.zzz);
    r5.xyz = (r5.xyz) * (r1.www) + (r7.xyz);
    r2.xyz = (r6.xyz) * (r6.xyz);
    r0.xyz = (r0.xyz) * (r5.xyz);
    r2.xyz = (r2.xyz) * (r4.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (c[6].xxx);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}
