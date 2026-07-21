// Mechanically reconstructed from 0x19C7881D.ps_3_0.cso.
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
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD4;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 2.0f, 0.25f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c7 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c8 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c9 = float4(4.0f, -3.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r3.xy, r3.xy) + (c1.x);
    r1.w = exp2(-(r0.w));
    r0.xy = (v1.zw) * (c4.xy);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r0.w = (r1.w) * (c1.y) + (c1.z);
    r6.xy = (r2.yw) * (c3.xx) + (c3.yy);
    r1 = tex2D(s14, v1.zw);
    r5.xy = (r1.xy) * (c1.ww);
    r1.w = dot(r6.xy, r3.xy) + (c1.x);
    r4.xy = (r2.xz) * (r5.xx);
    r1.z = (r1.x) * (c1.w) + (-(r4.x));
    r0.y = dot(r6.xy, r6.xy) + (c1.x);
    r1.z = (r2.z) * (-(r5.x)) + (r1.z);
    r1.x = exp2(-(r0.y));
    r0.xy = (r0.xz) * (r5.yy);
    r2.w = (r1.x) * (c1.y) + (c1.z);
    r1.x = (r1.y) * (c1.w) + (-(r0.x));
    r1.y = (r0.w) * (r2.w);
    r0.z = (r0.z) * (-(r5.y)) + (r1.x);
    r1.w = saturate((r1.w) * (r1.y) + (r1.y));
    r1.y = (r0.w) * (r1.z);
    r2.y = (r0.z) + (r0.z);
    r2.xz = (r0.xy) * (c4.ww);
    r0.xyz = v2.xyz;
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r2.xyz = (r1.www) * (r2.xyz);
    r3.xyz = (r3.yyy) * (v4.xyz) + (r0.xyz);
    r1.xz = (r0.ww) * (r4.xy);
    r0.xyz = normalize(r3.xyz);
    r6.xyz = (r1.xyz) * (c3.xzx) + (r2.xyz);
    r1.w = saturate(dot(c[17].xyz, r0.xyz));
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c4.x) : (c4.z));
    r5.xyz = (r1.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r1.w = r0.w;
    }
    else
    {
        if ((c4.x) >= (v6.w))
        {
            r1 = (v6.xyzx) * (c4.xxxz);
            r0 = (r1) + (-(c7.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r2 = (r1) + (c8.xxyy);
            r2 = tex2Dlod(s2, r2);
            r0.x = r2.x;
            r2 = (r1) + (c8.zzyy);
            r2 = tex2Dlod(s2, r2);
            r0.y = r2.x;
            r1 = (r1) + (c7.xyzz);
            r1 = tex2Dlod(s2, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c3.wwww);
            if ((c8.w) < (v6.w))
            {
                r4.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c8.xx);
                r0.zw = (v6.zx) * (c4.xz);
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (c8.zz);
                r1.zw = (v6.zx) * (c4.xz);
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c7.xy);
                r1.zw = (v6.zx) * (c4.xz);
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c7.xy));
                r1.zw = (v6.zx) * (c4.xz);
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c3.wwww);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v6.w) * (c9.x) + (c9.y);
                r1.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r1.w = r4.w;
            }
        }
        else
        {
            r0.w = (v6.w) + (-(c4.w));
            r0.w = ((r0.w) >= 0.0f ? (c4.z) : (c4.x));
            if ((r0.w) != (-(r0.w)))
            {
                r7.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r7.xy) + (c8.xx);
                r1.zw = (v6.zz) * (c4.xz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r7.xy) + (c8.zz);
                r2.zw = (v6.zz) * (c4.xz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r7.xy) + (c7.xy);
                r2.zw = (v6.zz) * (c4.xz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r7.xy) + (-(c7.xy));
                r2.zw = (v6.zz) * (c4.xz);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c3.wwww);
                r0.w = saturate((v6.w) + (c7.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r1.w = r0.w;
        }
    }
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r2.xyz = (r1.www) * (r5.xyz) + (r6.xyz);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (r0.x) * (c[5].w);
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    r0.w = rsqrt(r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
