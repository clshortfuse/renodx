// Mechanically reconstructed from 0xBABD8B83.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 8.0f, 31.875f, 1.0f);
    const float4 c1 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c3 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c4 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c9 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c10 = float4(4.0f, -3.0f, -4.0f, 0.0f);
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
    r1.w = rsqrt(r0.w);
    r1.xyz = (v5.xyz) * (-(r1.www)) + (c[17].xyz);
    r0.xyz = normalize(r1.xyz);
    r0.w = saturate(dot(r0.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c0.w);
    r1.z = (r0.w) * (r0.w);
    r7.xyz = normalize(v2.xyz);
    r1.y = (r1.z) * (r1.z);
    r1.z = max(abs(r7.y), abs(r7.z));
    r7.w = (r0.w) * (r1.y);
    r0.w = max(abs(r7.x), r1.z);
    r9.w = saturate(dot(r7.xyz, r0.xyz));
    r0.w = 1.0f / (r0.w);
    r8.w = saturate(dot(r7.xyz, c[17].xyz));
    r0.xyz = (r7.xyz) * (c[5].xyz);
    r8.xyz = (r1.www) * (v5.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v6.xyz);
    r1 = tex3D(s11, r0.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r6.w = saturate(dot(r7.xyz, -(r8.xyz)));
    r1.xyz = (r0.xyz) * (c[6].yyy);
    r0 = tex2D(s4, v1.xy);
    r1.xyz = (r1.xyz) * (r0.www);
    r9.xyz = (r1.xyz) * (c0.zzz);
    r6.xyz = (r8.www) * (c[18].xyz);
    if ((c0.w) >= (v4.w))
    {
        r2 = (v4.xyzx) * (c1.yyyw);
        r1 = (r2) + (-(c9.xyzz));
        r1 = tex2Dlod(s1, r1);
        r1.w = r1.x;
        r3 = (r2) + (c4.zzww);
        r3 = tex2Dlod(s1, r3);
        r1.x = r3.x;
        r3 = (r2) + (-(c4.zzww));
        r3 = tex2Dlod(s1, r3);
        r1.y = r3.x;
        r2 = (r2) + (c9.xyzz);
        r2 = tex2Dlod(s1, r2);
        r1.z = r2.x;
        r5.w = dot(r1, c4.yyyy);
        if ((c9.w) < (v4.w))
        {
            r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r5.xy) + (c4.zz);
            r1.zw = (v4.zx) * (c1.yw);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r5.xy) + (-(c4.zz));
            r2.zw = (v4.zx) * (c1.yw);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r5.xy) + (c9.xy);
            r2.zw = (v4.zx) * (c1.yw);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r5.xy) + (-(c9.xy));
            r2.zw = (v4.zx) * (c1.yw);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r1.w = dot(r1, c4.yyyy);
            r1.z = (-(r5.w)) + (r1.w);
            r1.w = (v4.w) * (c10.x) + (c10.y);
            r3.w = (r1.w) * (r1.z) + (r5.w);
        }
        else
        {
            r3.w = r5.w;
        }
    }
    else
    {
        r1.z = (v4.w) + (c10.z);
        r1.z = ((r1.z) >= 0.0f ? (c1.w) : (c1.y));
        if ((r1.z) != (-(r1.z)))
        {
            r1.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r1.xy) + (c4.zz);
            r2.zw = (v4.zz) * (c1.yw);
            r2 = tex2Dlod(s1, r2);
            r3.xy = (r1.xy) + (-(c4.zz));
            r3.zw = (v4.zz) * (c1.yw);
            r5 = tex2Dlod(s1, r3);
            r3.xy = (r1.xy) + (c9.xy);
            r3.zw = (v4.zz) * (c1.yw);
            r4 = tex2Dlod(s1, r3);
            r3.xy = (r1.xy) + (-(c9.xy));
            r3.zw = (v4.zz) * (c1.yw);
            r3 = tex2Dlod(s1, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r1.y = dot(r2, c4.yyyy);
            r1.z = saturate((v4.w) + (c10.y));
            r1.w = (r1.w) + (-(r1.y));
            r1.w = (r1.z) * (r1.w) + (r1.y);
        }
        r3.w = r1.w;
    }
    r3.xyz = (r3.www) * (r6.xyz) + (r9.xyz);
    r1.xy = (v1.xy) * (c[7].xy);
    r1 = tex2D(s3, r1.xy);
    r9.xyz = (r1.xyz) + (c0.xxx);
    r2 = tex2D(s0, v1.xy);
    r1 = tex2D(s2, v1.xy);
    r5.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.www);
    r6.xyz = (r1.xyz) * (r1.xyz);
    r1.z = (r1.w) * (-(c1.x)) + (c1.y);
    r1.x = (r1.w) * (c1.x);
    r1.y = (r6.w) * (r1.z) + (r1.x);
    r1.z = (r8.w) * (r1.z) + (r1.x);
    r1.z = (r1.z) * (r1.y) + (c1.z);
    r10.xy = (r1.ww) * (c3.xy) + (c3.zw);
    r1.x = 1.0f / (r1.z);
    r4.w = exp2(r10.y);
    r1.y = pow(abs(r9.w), r4.w);
    r1.z = (r4.w) * (c4.x) + (c4.y);
    r4.z = (r8.w) * (r1.x);
    r4.w = (r1.y) * (r1.z);
    r1.xyz = (r5.xyz) * (r7.www) + (r6.xyz);
    r4.w = (r4.z) * (r4.w);
    r1.xyz = (r1.xyz) * (r4.www);
    r1.xyz = (r1.xyz) * (c[6].www);
    r1.xyz = (r0.www) * (r1.xyz);
    r4.xyz = (r1.xyz) * (c[19].xyz);
    r1.xyz = saturate((r9.xyz) * (r2.www) + (r2.xyz));
    r4.xyz = (r3.www) * (r4.xyz);
    r2.xyz = (r1.xyz) * (v0.xyz);
    r2.w = 1.0f / (r10.x);
    r0.w = (-(r6.w)) + (c0.w);
    r1.z = dot(r8.xyz, r7.xyz);
    r3.w = (r0.w) * (r0.w);
    r1.z = (r1.z) + (r1.z);
    r1.w = (r1.w) * (c0.y);
    r1.xyz = (r7.xyz) * (-(r1.zzz)) + (r8.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r0.w) * (r3.w);
    r7.xyz = (r1.xyz) * (c0.yyy);
    r1 = tex3D(s11, v6.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r2.w) * (r0.w);
    r1.xyz = (r7.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c0.zzz);
    r5.xyz = (r5.xyz) * (r0.www) + (r6.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r5.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz) + (r4.xyz);
    r1.xyz = (r1.xyz) * (c[6].xxx);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
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
