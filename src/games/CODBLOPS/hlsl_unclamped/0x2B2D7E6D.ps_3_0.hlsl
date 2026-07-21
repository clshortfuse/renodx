// Mechanically reconstructed from 0x2B2D7E6D.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
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
    const float4 c1 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c4 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c11 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(0.5f, 0.449999988f, 0.330000013f, 0.0900000036f);
    const float4 c13 = float4(4.0f, -2.0f, 2.0f, 0.0f);
    const float4 c14 = float4(1.0f, 0.5f, 0.0f, 31.875f);
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

    r0.w = dot(v4.xyz, v4.xyz);
    r5.w = rsqrt(r0.w);
    r3.xy = ddx(v5.xy);
    r2.xy = ddy(v5.yx);
    r0.w = (r3.y) * (r2.y);
    r0.xyz = ddy(v3.xyz);
    r1.xyz = (r3.yyy) * (r0.xyz);
    r0.xyz = ddx(v3.xyz);
    r0.w = (r3.x) * (r2.x) + (-(r0.w));
    r0.xyz = (r0.xyz) * (r2.xxx) + (-(r1.xyz));
    r1.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (-(r0.x))), ((r0.w) >= 0.0f ? (r0.y) : (-(r0.y))), ((r0.w) >= 0.0f ? (r0.z) : (-(r0.z))));
    r0.xyz = (r5.www) * (v4.xyz);
    r0.w = dot(r1.xyz, r0.xyz);
    r5.xyz = (r0.www) * (-(r0.xyz)) + (r1.xyz);
    if ((c1.x) >= (v0.w))
    {
        r1 = (v0.xyzx) * (c1.xxxy);
        r0 = (r1) + (-(c3.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r2 = (r1) + (c1.zzyy);
        r2 = tex2Dlod(s0, r2);
        r0.x = r2.x;
        r2 = (r1) + (c1.wwyy);
        r2 = tex2Dlod(s0, r2);
        r0.y = r2.x;
        r1 = (r1) + (c3.xyzz);
        r1 = tex2Dlod(s0, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c3.wwww);
        if ((c4.x) < (v0.w))
        {
            r4.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c1.zz);
            r0.zw = (v0.zx) * (c1.xy);
            r0 = tex2Dlod(s0, r0);
            r1.xy = (r4.xy) + (c1.ww);
            r1.zw = (v0.zx) * (c1.xy);
            r3 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (c3.xy);
            r1.zw = (v0.zx) * (c1.xy);
            r2 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (-(c3.xy));
            r1.zw = (v0.zx) * (c1.xy);
            r1 = tex2Dlod(s0, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c3.wwww);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v0.w) * (c4.y) + (c4.z);
            r3.w = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r3.w = r4.w;
        }
    }
    else
    {
        r0.w = (v0.w) + (c4.w);
        r1.w = ((r0.w) >= 0.0f ? (c1.y) : (c1.x));
        r0 = tex2D(s12, v5.zw);
        if ((r1.w) != (-(r1.w)))
        {
            r6.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r6.xy) + (c1.zz);
            r1.zw = (v0.zz) * (c1.xy);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r6.xy) + (c1.ww);
            r2.zw = (v0.zz) * (c1.xy);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r6.xy) + (c3.xy);
            r2.zw = (v0.zz) * (c1.xy);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r6.xy) + (-(c3.xy));
            r2.zw = (v0.zz) * (c1.xy);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.x = dot(r1, c3.wwww);
            r0.w = saturate((v0.w) + (c4.z));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
        r3.w = r0.w;
    }
    r2.xyz = normalize(r5.xyz);
    r0 = tex2D(s1, v5.xy);
    r1.xyz = (r2.yzx) * (v4.zxy);
    r4.xy = (r0.wy) * (c11.xy) + (c11.zw);
    r0.xyz = (v4.yzx) * (r2.zxy) + (-(r1.xyz));
    r3.xyz = (r4.yyy) * (r0.xyz);
    r0.xy = (v5.zw) * (c14.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v5.zw) * (c14.xy) + (c14.zy);
    r0 = tex2D(s13, r0.xy);
    r1.w = r0.y;
    r2.xyz = (r4.xxx) * (r2.xyz) + (r3.xyz);
    r5.xy = (r1.yw) * (c13.xx) + (c13.yy);
    r3.xyz = (r2.xyz) + (v4.xyz);
    r2.xyz = (r5.yyy) * (v2.xyz);
    r4.xyz = normalize(r3.xyz);
    r2.xyz = (r5.xxx) * (v1.xyz) + (r2.xyz);
    r6.xyz = normalize(-(v3.xyz));
    r3.xyz = (v4.xyz) * (r5.www) + (r2.xyz);
    r5.xyz = normalize(c[17].xyz);
    r2.xyz = normalize(r3.xyz);
    r4.w = dot(r2.xyz, r6.xyz);
    r5.w = dot(r2.xyz, r4.xyz);
    r2 = tex2D(s14, v5.zw);
    r3.xy = (r2.xy) * (c14.ww);
    r1.xy = (r1.xz) * (r3.xx);
    r0.xy = (r0.xz) * (r3.yy);
    r1.w = (r2.x) * (c14.w) + (-(r1.x));
    r0.w = (r2.y) * (c14.w) + (-(r0.x));
    r1.w = (r1.z) * (-(r3.x)) + (r1.w);
    r0.w = (r0.z) * (-(r3.y)) + (r0.w);
    r3.y = (r1.w) + (r1.w);
    r2.y = (r0.w) + (r0.w);
    r3.xz = (r1.xy) * (c4.yy);
    r2.xz = (r0.xy) * (c4.yy);
    r0 = tex2D(s2, v5.xy);
    r0.w = (r0.x) * (r0.x);
    r0.xy = (r0.xx) * (r0.xx) + (c12.zw);
    r8.x = 1.0f / (r0.x);
    r8.y = 1.0f / (r0.y);
    r7.xy = (r0.ww) * (c12.xy);
    r1.w = (r7.x) * (-(r8.x)) + (c1.x);
    r1.xyz = (r5.www) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r4.www) * (r2.xyz) + (r3.xyz);
    r3.xyz = (r1.www) * (r1.xyz);
    r2.x = dot(r5.xyz, r6.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r2.z = (r8.y) * (r7.y);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.x = 1.0f / (r0.x);
    r0.y = 1.0f / (r0.y);
    r0.z = 1.0f / (r0.z);
    r2.y = saturate(dot(r4.xyz, r6.xyz));
    r1.xyz = (r2.zzz) * (r0.xyz);
    r2.w = (r2.y) * (-(r2.y)) + (c1.x);
    r0.w = (r2.y) * (r2.y);
    r0.z = saturate(dot(r4.xyz, r5.xyz));
    r0.y = saturate((r0.z) * (-(r2.y)) + (r2.x));
    r0.x = 1.0f / (r2.y);
    r0.y = (r2.z) * (r0.y);
    r0.x = saturate((r0.z) * (r0.x));
    r0.w = ((-(r0.w)) >= 0.0f ? (c1.x) : (r2.w));
    r0.y = (r0.y) * (r0.x);
    r2.w = (r1.w) * (r0.z) + (r0.y);
    r0.xyz = normalize(v3.xyz);
    r2.xyz = (r3.www) * (c[18].xyz);
    r0.z = dot(c[5].xyz, r0.xyz);
    r1.w = saturate((c[7].y) * (r0.z) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r2.xyz = (r2.xyz) * (r2.www) + (r3.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r2.xyz = (r1.xyz) * (r0.www) + (r2.xyz);
    r1.xyz = (r0.xyz) * (c[0].www);
    r0 = tex2D(s3, v5.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz) + (-(r1.xyz));
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r2.xy = (v5.xy) + (-(c12.xx));
    r1.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = c12.x;
    r0.xy = (r2.xy) * (c[10].xx) + (r0.ww);
    r0 = tex2D(s4, r0.xy);
    r1.w = (r0.x) + (-(c1.x));
    r2.w = c1.x;
    r0.w = min(c[8].x, r2.w);
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    r0.w = (c13.z) * (r0.w) + (r1.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = saturate((-(r0.w)) + (c1.x));

    return oC0;
}
