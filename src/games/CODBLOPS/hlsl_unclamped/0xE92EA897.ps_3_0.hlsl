// Mechanically reconstructed from 0xE92EA897.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

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
    const float4 c0 = float4(-0.5f, 1.0f, 0.5f, 0.0f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.25f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.000244140625f, 0.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c12 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0.xy = (v0.zw) * (c0.yz);
    r0 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v0.zw);
    r6.xy = (r1.xy) * (c1.xx);
    r5.xy = (r0.xz) * (r6.xx);
    r0.w = (r1.x) * (c1.x) + (-(r5.x));
    r2.x = r0.y;
    r0.w = (r0.z) * (-(r6.x)) + (r0.w);
    r3.y = (r0.w) + (r0.w);
    r0.xy = (v0.zw) * (c0.yz) + (c0.wz);
    r0 = tex2D(s13, r0.xy);
    r2.y = r0.y;
    r4.xy = (r6.yy) * (r0.xz);
    r0.xy = (r2.xy) * (c1.yy) + (c1.zz);
    r1.w = (r1.y) * (c1.x) + (-(r4.x));
    r0.w = dot(r0.xy, r0.xy) + (c0.w);
    r0.z = (r0.z) * (-(r6.y)) + (r1.w);
    r0.w = exp2(-(r0.w));
    r0.y = (r0.z) + (r0.z);
    r0.w = saturate((r0.w) * (c3.x) + (c3.y));
    r3.xz = (r5.xy) * (c1.yy);
    r0.xz = (r4.xy) * (c1.yy);
    r8.xyz = (r0.xyz) * (r0.www) + (r3.xyz);
    r0 = tex2D(s12, v0.zw);
    r9.xyz = normalize(v1.xyz);
    r0.z = saturate(dot(c[17].xyz, r9.xyz));
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c0.y) : (c0.w));
    r7.xyz = (r0.zzz) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r7.w = r0.w;
    }
    else
    {
        if ((c0.y) >= (v3.w))
        {
            r1 = (v3.xyzx) * (c0.yyyw);
            r0 = (r1) + (-(c4.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r2 = (r1) + (c3.zzww);
            r2 = tex2Dlod(s1, r2);
            r0.x = r2.x;
            r2 = (r1) + (-(c3.zzww));
            r2 = tex2Dlod(s1, r2);
            r0.y = r2.x;
            r1 = (r1) + (c4.xyzz);
            r1 = tex2Dlod(s1, r1);
            r0.z = r1.x;
            r7.w = dot(r0, c1.wwww);
            if ((c4.w) < (v3.w))
            {
                r4.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c3.zz);
                r0.zw = (v3.zx) * (c0.yw);
                r0 = tex2Dlod(s1, r0);
                r1.xy = (r4.xy) + (-(c3.zz));
                r1.zw = (v3.zx) * (c0.yw);
                r3 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (c4.xy);
                r1.zw = (v3.zx) * (c0.yw);
                r2 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (-(c4.xy));
                r1.zw = (v3.zx) * (c0.yw);
                r1 = tex2Dlod(s1, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c1.wwww);
                r0.z = (-(r7.w)) + (r0.w);
                r0.w = (v3.w) * (c12.x) + (c12.y);
                r7.w = (r0.w) * (r0.z) + (r7.w);
            }
        }
        else
        {
            r0.w = (v3.w) + (-(c1.y));
            r0.w = ((r0.w) >= 0.0f ? (c0.w) : (c0.y));
            if ((r0.w) != (-(r0.w)))
            {
                r5.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r5.xy) + (c3.zz);
                r1.zw = (v3.zz) * (c0.yw);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r5.xy) + (-(c3.zz));
                r2.zw = (v3.zz) * (c0.yw);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (c4.xy);
                r2.zw = (v3.zz) * (c0.yw);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (-(c4.xy));
                r2.zw = (v3.zz) * (c0.yw);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c1.wwww);
                r0.w = saturate((v3.w) + (c12.y));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r7.w = r0.w;
        }
    }
    r3 = tex2D(s0, v0.xy);
    r2 = tex2D(s2, v5.zw);
    r5 = (-(v4.yyyy)) + (c[6]);
    r4 = (-(v4.xxxx)) + (c[5]);
    r0 = (r5) * (r5);
    r0 = (r4) * (r4) + (r0);
    r1 = (-(v4.zzzz)) + (c[7]);
    r0 = (r1) * (r1) + (r0);
    r6.x = rsqrt(r0.x);
    r6.y = rsqrt(r0.y);
    r6.z = rsqrt(r0.z);
    r6.w = rsqrt(r0.w);
    r2.w = (r2.w) * (v5.y) + (c0.x);
    r5 = (r5) * (r6);
    r5 = (r9.yyyy) * (r5);
    r4 = (r4) * (r6);
    r1 = (r1) * (r6);
    r4 = (r4) * (r9.xxxx) + (r5);
    r1 = saturate((r1) * (r9.zzzz) + (r4));
    r3.w = c0.y;
    r0 = saturate((r0) * (c[8]) + (r3.wwww));
    r3.xyz = float3(((r2.w) >= 0.0f ? (r2.x) : (r3.x)), ((r2.w) >= 0.0f ? (r2.y) : (r3.y)), ((r2.w) >= 0.0f ? (r2.z) : (r3.z)));
    r0 = (r1) * (r0);
    r2.z = dot(c[11], r0);
    r1.xyz = (r3.xyz) * (r3.xyz);
    r2.x = dot(c[9], r0);
    r2.y = dot(c[10], r0);
    r0.xyz = (r7.www) * (r7.xyz) + (r8.xyz);
    r2.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
