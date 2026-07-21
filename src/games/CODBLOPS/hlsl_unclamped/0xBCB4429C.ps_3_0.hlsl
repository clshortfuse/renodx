// Mechanically reconstructed from 0xBCB4429C.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.25f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.000244140625f, 0.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c6 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0 = tex2D(s0, v1.xy);
    r1.w = (r0.w) * (v0.x) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1 = float4(((r1.w) >= 0.0f ? (r0.x) : (c0.z)), ((r1.w) >= 0.0f ? (r0.y) : (c0.z)), ((r1.w) >= 0.0f ? (r0.z) : (c0.z)), ((r1.w) >= 0.0f ? (r0.w) : (c0.z)));
    r0 = tex2D(s2, v5.xy);
    r2.w = (r0.w) * (v0.y) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1 = float4(((r2.w) >= 0.0f ? (r0.x) : (r1.x)), ((r2.w) >= 0.0f ? (r0.y) : (r1.y)), ((r2.w) >= 0.0f ? (r0.z) : (r1.z)), ((r2.w) >= 0.0f ? (r0.w) : (r1.w)));
    r0 = tex2D(s3, v5.zw);
    r2.w = (r0.w) * (v0.z) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r0 = float4(((r2.w) >= 0.0f ? (r0.x) : (r1.x)), ((r2.w) >= 0.0f ? (r0.y) : (r1.y)), ((r2.w) >= 0.0f ? (r0.z) : (r1.z)), ((r2.w) >= 0.0f ? (r0.w) : (r1.w)));
    r1.xy = (v1.zw) * (c0.yw);
    r1 = tex2D(s13, r1.xy);
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c1.xx);
    r6.xyz = (r0.xyz) * (r0.xyz);
    r4.xy = (r1.xz) * (r5.xx);
    r0.x = r1.y;
    r0.z = (r2.x) * (c1.x) + (-(r4.x));
    r2.w = (r1.z) * (-(r5.x)) + (r0.z);
    r1.xy = (v1.zw) * (c0.yw) + (c0.zw);
    r1 = tex2D(s13, r1.xy);
    r3.xy = (r5.yy) * (r1.xz);
    r0.y = r1.y;
    r0.z = (r2.y) * (c1.x) + (-(r3.x));
    r0.xy = (r0.xy) * (c1.yy) + (c1.zz);
    r1.w = (r1.z) * (-(r5.y)) + (r0.z);
    r0.z = dot(r0.xy, r0.xy) + (c0.z);
    r2.y = (r2.w) + (r2.w);
    r0.z = exp2(-(r0.z));
    r0.y = (r1.w) + (r1.w);
    r1.w = saturate((r0.z) * (c3.x) + (c3.y));
    r2.xz = (r4.xy) * (c1.yy);
    r0.xz = (r3.xy) * (c1.yy);
    r1.xyz = normalize(v2.xyz);
    r0.xyz = (r0.xyz) * (r1.www) + (r2.xyz);
    r2.w = saturate(dot(c[17].xyz, r1.xyz));
    r8.xyz = (r0.www) * (r0.xyz);
    r1 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c0.y) : (c0.z));
    r7.xyz = (r2.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r2 = (v4.xyzx) * (c0.yyyz);
            r1 = (r2) + (-(c4.xyzz));
            r1 = tex2Dlod(s1, r1);
            r1.w = r1.x;
            r3 = (r2) + (c3.zzww);
            r3 = tex2Dlod(s1, r3);
            r1.x = r3.x;
            r3 = (r2) + (-(c3.zzww));
            r3 = tex2Dlod(s1, r3);
            r1.y = r3.x;
            r2 = (r2) + (c4.xyzz);
            r2 = tex2Dlod(s1, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c1.wwww);
            if ((c4.w) < (v4.w))
            {
                r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c3.zz);
                r1.zw = (v4.zx) * (c0.yz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r0.xy) + (-(c3.zz));
                r2.zw = (v4.zx) * (c0.yz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r0.xy) + (c4.xy);
                r2.zw = (v4.zx) * (c0.yz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r0.xy) + (-(c4.xy));
                r2.zw = (v4.zx) * (c0.yz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c1.wwww);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v4.w) * (c6.x) + (c6.y);
                r0.z = (r0.y) * (r0.x) + (r0.z);
            }
        }
        else
        {
            r0.z = (v4.w) + (-(c1.y));
            r0.z = ((r0.z) >= 0.0f ? (c0.z) : (c0.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c3.zz);
                r2.zw = (v4.zz) * (c0.yz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r0.xy) + (-(c3.zz));
                r3.zw = (v4.zz) * (c0.yz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (c4.xy);
                r3.zw = (v4.zz) * (c0.yz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (-(c4.xy));
                r3.zw = (v4.zz) * (c0.yz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c1.wwww);
                r0.z = saturate((v4.w) + (c6.y));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
        }
    }
    r0.xyz = (r0.zzz) * (r7.xyz) + (r8.xyz);
    r0.xyz = (r6.xyz) * (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
