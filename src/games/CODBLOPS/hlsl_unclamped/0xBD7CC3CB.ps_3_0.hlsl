// Mechanically reconstructed from 0xBD7CC3CB.ps_3_0.cso.
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
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(31.875f, 4.0f, -2.0f, 0.25f);
    const float4 c1 = float4(0.600000024f, 0.400000006f, 0.000244140625f, 0.0f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, 0.0f, 0.0f);
    const float4 c6 = float4(-1.0f, 1.0f, 0.5f, 0.0f);
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

    r0 = tex2D(s2, v4.zw);
    r0.xyz = (r0.xyz) + (c6.xxx);
    r1.xyz = (v4.yyy) * (r0.xyz) + (c6.yyy);
    r0 = tex2D(s0, v0.xy);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r0.xy = (v0.zw) * (c6.yz);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v0.zw);
    r7.xy = (r2.xy) * (c0.xx);
    r3.xyz = normalize(v1.xyz);
    r6.xy = (r0.xz) * (r7.xx);
    r1.x = r0.y;
    r0.w = (r2.x) * (c0.x) + (-(r6.x));
    r1.w = (r0.z) * (-(r7.x)) + (r0.w);
    r0.xy = (v0.zw) * (c6.yz) + (c6.wz);
    r0 = tex2D(s13, r0.xy);
    r4.xy = (r7.yy) * (r0.xz);
    r1.y = r0.y;
    r0.w = (r2.y) * (c0.x) + (-(r4.x));
    r0.xy = (r1.xy) * (c0.yy) + (c0.zz);
    r0.z = (r0.z) * (-(r7.y)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c6.w);
    r1.y = (r1.w) + (r1.w);
    r0.w = exp2(-(r0.w));
    r0.y = (r0.z) + (r0.z);
    r0.w = saturate((r0.w) * (c1.x) + (c1.y));
    r1.xz = (r6.xy) * (c0.yy);
    r0.xz = (r4.xy) * (c0.yy);
    r1.w = saturate(dot(c[17].xyz, r3.xyz));
    r7.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r0 = tex2D(s12, v0.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c6.y) : (c6.w));
    r6.xyz = (r1.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((c6.y) >= (v3.w))
        {
            r1 = (v3.xyzx) * (c6.yyyw);
            r0 = (r1) + (-(c3.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r2 = (r1) + (c1.zzww);
            r2 = tex2Dlod(s1, r2);
            r0.x = r2.x;
            r2 = (r1) + (-(c1.zzww));
            r2 = tex2Dlod(s1, r2);
            r0.y = r2.x;
            r1 = (r1) + (c3.xyzz);
            r1 = tex2Dlod(s1, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c0.wwww);
            if ((c3.w) < (v3.w))
            {
                r4.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c1.zz);
                r0.zw = (v3.zx) * (c6.yw);
                r0 = tex2Dlod(s1, r0);
                r1.xy = (r4.xy) + (-(c1.zz));
                r1.zw = (v3.zx) * (c6.yw);
                r3 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (c3.xy);
                r1.zw = (v3.zx) * (c6.yw);
                r2 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (-(c3.xy));
                r1.zw = (v3.zx) * (c6.yw);
                r1 = tex2Dlod(s1, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c0.wwww);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v3.w) * (c4.x) + (c4.y);
                r0.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r0.w = r4.w;
            }
        }
        else
        {
            r0.w = (v3.w) + (-(c0.y));
            r0.w = ((r0.w) >= 0.0f ? (c6.w) : (c6.y));
            if ((r0.w) != (-(r0.w)))
            {
                r8.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r8.xy) + (c1.zz);
                r1.zw = (v3.zz) * (c6.yw);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r8.xy) + (-(c1.zz));
                r2.zw = (v3.zz) * (c6.yw);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r8.xy) + (c3.xy);
                r2.zw = (v3.zz) * (c6.yw);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r8.xy) + (-(c3.xy));
                r2.zw = (v3.zz) * (c6.yw);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c0.wwww);
                r0.w = saturate((v3.w) + (c4.y));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
        }
    }
    r0.xyz = (r0.www) * (r6.xyz) + (r7.xyz);
    r0.xyz = (r5.xyz) * (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c6.y;

    return oC0;
}
