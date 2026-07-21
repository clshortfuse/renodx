// Mechanically reconstructed from 0x0CE27D31.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c7 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c8 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c9 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c10 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0.w = dot(v4.xyz, v4.xyz);
    r3.w = rsqrt(r0.w);
    r0.xyz = (v4.xyz) * (-(r3.www)) + (c[17].xyz);
    r3.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r3.xyz, c[17].xyz));
    r4.w = (-(r0.w)) + (c0.y);
    r0.w = (r4.w) * (r4.w);
    r0.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r1 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v0.zw);
    r5.xy = (r2.xy) * (c1.ww);
    r1.w = (r0.w) * (r0.w);
    r4.xy = (r1.xz) * (r5.yy);
    r0.w = (r2.y) * (c1.w) + (-(r4.x));
    r1.z = (r1.z) * (-(r5.y)) + (r0.w);
    r0.xy = (v0.zw) * (c0.yw);
    r0 = tex2D(s13, r0.xy);
    r6.xy = (r5.xx) * (r0.xz);
    r1.x = r0.y;
    r0.w = (r2.x) * (c1.w) + (-(r6.x));
    r0.xy = (r1.xy) * (c3.xx) + (c3.yy);
    r0.z = (r0.z) * (-(r5.x)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c1.z);
    r5.y = (r0.z) + (r0.z);
    r0.w = exp2(-(r0.w));
    r0.y = (r1.z) + (r1.z);
    r0.w = saturate((r0.w) * (c3.z) + (c3.w));
    r5.xz = (r6.xy) * (c3.xx);
    r0.xz = (r4.xy) * (c3.xx);
    r6.w = (r4.w) * (r1.w);
    r0.xyz = (r0.xyz) * (r0.www) + (r5.xyz);
    r9.xyz = (r0.xyz) * (c[5].yyy);
    r7.xyz = normalize(v1.xyz);
    r8.w = saturate(dot(r7.xyz, r3.xyz));
    r8.xyz = (r3.www) * (v4.xyz);
    r5.w = saturate(dot(r7.xyz, -(r8.xyz)));
    r7.w = saturate(dot(r7.xyz, c[17].xyz));
    r0 = tex2D(s12, v0.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c1.x) : (c1.z));
    r6.xyz = (r7.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r3.w = r0.w;
    }
    else
    {
        if ((c0.y) >= (v3.w))
        {
            r1 = (v3.xyzx) * (c1.xxxz);
            r0 = (r1) + (-(c9.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r2 = (r1) + (c8.xxyy);
            r2 = tex2Dlod(s1, r2);
            r0.x = r2.x;
            r2 = (r1) + (c8.zzyy);
            r2 = tex2Dlod(s1, r2);
            r0.y = r2.x;
            r1 = (r1) + (c9.xyzz);
            r1 = tex2Dlod(s1, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c4.zzzz);
            if ((c4.w) < (v3.w))
            {
                r4.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c8.xx);
                r0.zw = (v3.zx) * (c1.xz);
                r0 = tex2Dlod(s1, r0);
                r1.xy = (r4.xy) + (c8.zz);
                r1.zw = (v3.zx) * (c1.xz);
                r3 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (c9.xy);
                r1.zw = (v3.zx) * (c1.xz);
                r2 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (-(c9.xy));
                r1.zw = (v3.zx) * (c1.xz);
                r1 = tex2Dlod(s1, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c4.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v3.w) * (c10.x) + (c10.y);
                r3.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r3.w = r4.w;
            }
        }
        else
        {
            r0.w = (v3.w) + (-(c3.x));
            r0.w = ((r0.w) >= 0.0f ? (c1.z) : (c1.x));
            if ((r0.w) != (-(r0.w)))
            {
                r10.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r10.xy) + (c8.xx);
                r1.zw = (v3.zz) * (c1.xz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r10.xy) + (c8.zz);
                r2.zw = (v3.zz) * (c1.xz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r10.xy) + (c9.xy);
                r2.zw = (v3.zz) * (c1.xz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r10.xy) + (-(c9.xy));
                r2.zw = (v3.zz) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c4.zzzz);
                r0.w = saturate((v3.w) + (c8.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r3.w = r0.w;
        }
    }
    r3.xyz = (r3.www) * (r6.xyz) + (r9.xyz);
    r2 = tex2D(s0, v0.xy);
    r1 = tex2D(s2, v5.zw);
    r1.xyz = (r1.xyz) * (v5.yyy);
    r0 = tex2D(s3, v0.xy);
    r4.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.yyy);
    r6.xyz = (r0.xyz) * (r0.xyz);
    r0.z = (r0.w) * (-(c0.z)) + (c0.y);
    r0.x = (r0.w) * (c0.z);
    r0.y = (r5.w) * (r0.z) + (r0.x);
    r0.z = (r7.w) * (r0.z) + (r0.x);
    r0.z = (r0.z) * (r0.y) + (c4.x);
    r9.xy = (r0.ww) * (c7.xy) + (c7.zw);
    r0.x = 1.0f / (r0.z);
    r2.w = exp2(r9.y);
    r0.y = pow(abs(r8.w), r2.w);
    r0.z = (r2.w) * (c4.y) + (c4.z);
    r4.w = (r7.w) * (r0.x);
    r2.w = (r0.y) * (r0.z);
    r0.xyz = (r4.xyz) * (r6.www) + (r6.xyz);
    r2.w = (r4.w) * (r2.w);
    r1.xyz = (r1.xyz) * (r1.www) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r2.www);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[5].www);
    r2.xyz = (r0.xyz) * (c[19].xyz);
    r0.z = (-(r5.w)) + (c0.y);
    r0.x = 1.0f / (r9.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r8.xyz, r7.xyz);
    r1.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r0.w = (r0.w) * (c0.x);
    r0.xyz = (r7.xyz) * (-(r0.zzz)) + (r8.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[5].xxx);
    r4.xyz = (r4.xyz) * (r1.www) + (r6.xyz);
    r2.xyz = (r3.www) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz) + (r2.xyz);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
