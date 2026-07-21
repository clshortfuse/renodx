// Mechanically reconstructed from 0xE370E3EE.ps_3_0.cso.
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
    const float4 c0 = float4(-1.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.125f, 0.25f);
    const float4 c4 = float4(0.797884583f, 1.0f, 0.5f, 0.0f);
    const float4 c7 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c8 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c9 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
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
    float4 r11 = 0.0f;
    float4 r12 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v4.xyz, v4.xyz);
    r2.z = rsqrt(r0.w);
    r0.xyz = (v4.xyz) * (-(r2.zzz)) + (c[17].xyz);
    r1.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r1.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c0.y);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r7.w = (r0.w) * (r0.z);
    r0 = tex2D(s3, v0.xy);
    r1.w = (r0.w) * (-(c4.x)) + (c4.y);
    r8.xyz = normalize(v1.xyz);
    r2.w = saturate(dot(r8.xyz, r1.xyz));
    r9.xyz = (r2.zzz) * (v4.xyz);
    r0.x = saturate(dot(r8.xyz, -(r9.xyz)));
    r12.xy = (r0.ww) * (c7.xy) + (c7.zw);
    r1.y = (r0.w) * (c4.x);
    r0.z = exp2(r12.y);
    r1.z = (r0.x) * (r1.w) + (r1.y);
    r1.x = pow(abs(r2.w), r0.z);
    r0.z = (r0.z) * (c3.z) + (c3.w);
    r4.w = saturate(dot(r8.xyz, c[17].xyz));
    r0.z = (r1.x) * (r0.z);
    r1.w = (r4.w) * (r1.w) + (r1.y);
    r1.w = (r1.w) * (r1.z) + (c1.w);
    r1.xy = (v0.zw) * (c4.yz) + (c4.wz);
    r2 = tex2D(s13, r1.xy);
    r3 = tex2D(s14, v0.zw);
    r6.xy = (r3.xy) * (c1.xx);
    r3.w = 1.0f / (r1.w);
    r4.xy = (r2.xz) * (r6.yy);
    r1.w = (r3.y) * (c1.x) + (-(r4.x));
    r2.w = (r2.z) * (-(r6.y)) + (r1.w);
    r1.xy = (v0.zw) * (c4.yz);
    r1 = tex2D(s13, r1.xy);
    r5.xy = (r6.xx) * (r1.xz);
    r2.x = r1.y;
    r1.w = (r3.x) * (c1.x) + (-(r5.x));
    r1.xy = (r2.xy) * (c1.yy) + (c1.zz);
    r1.z = (r1.z) * (-(r6.x)) + (r1.w);
    r1.w = dot(r1.xy, r1.xy) + (c4.w);
    r6.y = (r1.z) + (r1.z);
    r1.w = exp2(-(r1.w));
    r1.y = (r2.w) + (r2.w);
    r2.w = saturate((r1.w) * (c3.x) + (c3.y));
    r6.xz = (r5.xy) * (c1.yy);
    r1.xz = (r4.xy) * (c1.yy);
    r1.w = (r4.w) * (r3.w);
    r1.xyz = (r1.xyz) * (r2.www) + (r6.xyz);
    r6.w = (r0.z) * (r1.w);
    r11.xyz = (r0.yyy) * (r1.xyz);
    r1 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c4.y) : (c4.w));
    r10.xyz = (r4.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
    }
    else
    {
        if ((c0.y) >= (v3.w))
        {
            r2 = (v3.xyzx) * (c4.yyyw);
            r1 = (r2) + (-(c8.xyzz));
            r1 = tex2Dlod(s1, r1);
            r1.w = r1.x;
            r3 = (r2) + (c9.xxyy);
            r3 = tex2Dlod(s1, r3);
            r1.x = r3.x;
            r3 = (r2) + (c9.zzyy);
            r3 = tex2Dlod(s1, r3);
            r1.y = r3.x;
            r2 = (r2) + (c8.xyzz);
            r2 = tex2Dlod(s1, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c3.wwww);
            if ((c9.w) < (v3.w))
            {
                r5.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r5.xy) + (c9.xx);
                r1.zw = (v3.zx) * (c4.yw);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r5.xy) + (c9.zz);
                r2.zw = (v3.zx) * (c4.yw);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (c8.xy);
                r2.zw = (v3.zx) * (c4.yw);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (-(c8.xy));
                r2.zw = (v3.zx) * (c4.yw);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r1.w = dot(r1, c3.wwww);
                r1.z = (-(r0.z)) + (r1.w);
                r1.w = (v3.w) * (c10.x) + (c10.y);
                r0.z = (r1.w) * (r1.z) + (r0.z);
            }
        }
        else
        {
            r0.z = (v3.w) + (-(c1.y));
            r0.z = ((r0.z) >= 0.0f ? (c4.w) : (c4.y));
            if ((r0.z) != (-(r0.z)))
            {
                r7.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r7.xy) + (c9.xx);
                r2.zw = (v3.zz) * (c4.yw);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r7.xy) + (c9.zz);
                r3.zw = (v3.zz) * (c4.yw);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r7.xy) + (c8.xy);
                r3.zw = (v3.zz) * (c4.yw);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r7.xy) + (-(c8.xy));
                r3.zw = (v3.zz) * (c4.yw);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r1.z = dot(r2, c3.wwww);
                r0.z = saturate((v3.w) + (c8.w));
                r1.w = (r1.y) + (-(r1.z));
                r0.z = (r0.z) * (r1.w) + (r1.z);
            }
            else
            {
                r0.z = r1.y;
            }
        }
    }
    r1 = tex2D(s2, v5.zw);
    r1.xyz = (r1.xyz) + (c0.xxx);
    r5.xyz = (v5.yyy) * (r1.xyz) + (c0.yyy);
    r1.xyz = (r5.xyz) * (c0.zzz);
    r4.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r7.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r4.xyz) * (r7.www) + (r7.xyz);
    r1.xyz = (r6.www) * (r1.xyz);
    r1.xyz = (r0.yyy) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c[19].xyz);
    r2.xyz = (r0.zzz) * (r10.xyz) + (r11.xyz);
    r3.xyz = (r0.zzz) * (r1.xyz);
    r1 = tex2D(s0, v0.xy);
    r5.xyz = (r5.xyz) * (r1.xyz);
    r0.z = (-(r0.x)) + (c0.y);
    r1.w = 1.0f / (r12.x);
    r0.x = (r0.z) * (r0.z);
    r0.x = (r0.z) * (r0.x);
    r0.z = dot(r9.xyz, r8.xyz);
    r2.w = (r1.w) * (r0.x);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r0.w) * (c0.w);
    r1.xyz = (r8.xyz) * (-(r0.zzz)) + (r9.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.yyy) * (r1.xyz);
    r4.xyz = (r4.xyz) * (r2.www) + (r7.xyz);
    r1.xyz = (r5.xyz) * (r5.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r6.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.www) + (r1.xyz);
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
    oC0.w = c[5].w;

    return oC0;
}
