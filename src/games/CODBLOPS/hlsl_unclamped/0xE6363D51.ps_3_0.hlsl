// Mechanically reconstructed from 0xE6363D51.ps_3_0.cso.
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
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD4;
    float4 v7 : TEXCOORD5;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 31.875f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c4 = float4(4.0f, -2.0f, 2.0f, 0.25f);
    const float4 c12 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
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

    r0 = tex2D(s1, v1.xy);
    r4.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r4.xy, r4.xy) + (c1.x);
    r1.w = exp2(-(r0.w));
    r0.xy = (v1.zw) * (c3.xy);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r0.w = (r1.w) * (c1.y) + (c1.z);
    r6.xy = (r2.yw) * (c4.xx) + (c4.yy);
    r1 = tex2D(s14, v1.zw);
    r5.xy = (r1.xy) * (c1.ww);
    r1.w = dot(r6.xy, r4.xy) + (c1.x);
    r3.xy = (r2.xz) * (r5.xx);
    r0.y = (r1.x) * (c1.w) + (-(r3.x));
    r1.z = dot(r6.xy, r6.xy) + (c1.x);
    r0.y = (r2.z) * (-(r5.x)) + (r0.y);
    r1.z = exp2(-(r1.z));
    r2.xy = (r0.xz) * (r5.yy);
    r1.z = (r1.z) * (c1.y) + (c1.z);
    r0.x = (r1.y) * (c1.w) + (-(r2.x));
    r1.z = (r0.w) * (r1.z);
    r0.x = (r0.z) * (-(r5.y)) + (r0.x);
    r0.z = saturate((r1.w) * (r1.z) + (r1.z));
    r0.y = (r0.w) * (r0.y);
    r1.y = (r0.x) + (r0.x);
    r1.xz = (r2.xy) * (c3.ww);
    r2.xyz = v2.xyz;
    r2.xyz = (r4.xxx) * (v5.xyz) + (r2.xyz);
    r1.xyz = (r0.zzz) * (r1.xyz);
    r2.xyz = (r4.yyy) * (v4.xyz) + (r2.xyz);
    r0.xz = (r0.ww) * (r3.xy);
    r7.xyz = normalize(r2.xyz);
    r6.xyz = (r0.xyz) * (c4.xzx) + (r1.xyz);
    r1.w = saturate(dot(c[17].xyz, r7.xyz));
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c3.x) : (c3.z));
    r5.xyz = (r1.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r5.w = r0.w;
    }
    else
    {
        if ((c3.x) >= (v6.w))
        {
            r1 = (v6.xyzx) * (c3.xxxz);
            r0 = (r1) + (-(c13.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r2 = (r1) + (c12.xxyy);
            r2 = tex2Dlod(s2, r2);
            r0.x = r2.x;
            r2 = (r1) + (c12.zzyy);
            r2 = tex2Dlod(s2, r2);
            r0.y = r2.x;
            r1 = (r1) + (c13.xyzz);
            r1 = tex2Dlod(s2, r1);
            r0.z = r1.x;
            r5.w = dot(r0, c4.wwww);
            if ((c12.w) < (v6.w))
            {
                r4.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c12.xx);
                r0.zw = (v6.zx) * (c3.xz);
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (c12.zz);
                r1.zw = (v6.zx) * (c3.xz);
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c13.xy);
                r1.zw = (v6.zx) * (c3.xz);
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c13.xy));
                r1.zw = (v6.zx) * (c3.xz);
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c4.wwww);
                r0.z = (-(r5.w)) + (r0.w);
                r0.w = (v6.w) * (c14.x) + (c14.y);
                r5.w = (r0.w) * (r0.z) + (r5.w);
            }
        }
        else
        {
            r0.w = (v6.w) + (-(c3.w));
            r0.w = ((r0.w) >= 0.0f ? (c3.z) : (c3.x));
            if ((r0.w) != (-(r0.w)))
            {
                r8.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r8.xy) + (c12.xx);
                r1.zw = (v6.zz) * (c3.xz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r8.xy) + (c12.zz);
                r2.zw = (v6.zz) * (c3.xz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r8.xy) + (c13.xy);
                r2.zw = (v6.zz) * (c3.xz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r8.xy) + (-(c13.xy));
                r2.zw = (v6.zz) * (c3.xz);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c4.wwww);
                r0.w = saturate((v6.w) + (c13.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r5.w = r0.w;
        }
    }
    r0.xyz = (-(v7.xyz)) + (c[5].xyz);
    r1.xyz = normalize(r0.xyz);
    r0 = (v7.yyyy) * (c[24]);
    r6.w = saturate(dot(r1.xyz, r7.xyz));
    r0 = (v7.xxxx) * (c[23]) + (r0);
    r1.w = dot(r1.xyz, c[21].xyz);
    r0 = (v7.zzzz) * (c[25]) + (r0);
    r1.w = saturate((r1.w) * (c[22].x) + (c[22].y));
    r3 = (r0) + (c[26]);
    r0.z = (r1.w) * (c14.z) + (c14.w);
    r2.zw = r3.zw;
    r0.w = (r1.w) * (r1.w);
    r4.zw = r2.zw;
    r3.z = (r0.z) * (r0.w);
    r1.zw = r4.zw;
    r0.xy = (r3.ww) * (-(c[27].zw)) + (r3.xy);
    r0.zw = r1.zw;
    r0 = tex2Dproj(s3, r0);
    r0.w = r0.x;
    r4.xy = (r2.ww) * (-(c[27].xy)) + (r3.xy);
    r4 = tex2Dproj(s3, r4);
    r0.y = r4.x;
    r2.xy = (r2.ww) * (c[27].xy) + (r3.xy);
    r4 = tex2Dproj(s3, r2);
    r0.x = r4.x;
    r1.xy = (r2.ww) * (c[27].zw) + (r3.xy);
    r1 = tex2Dproj(s3, r1);
    r0.z = r1.x;
    r1.w = dot(r0, c4.wwww);
    r0 = (v7.xyzx) * (c3.xxxz) + (c3.zzzx);
    r2.xyz = (r6.www) * (c[6].xyz);
    r1.z = dot(r0, c[20]);
    r1.z = 1.0f / (r1.z);
    r3.x = dot(r0, c[11]);
    r1.x = dot(r0, c[9]);
    r3.y = (r3.x) * (r3.x);
    r1.y = dot(r0, c[10]);
    r0.w = dot(c[7].yz, r3.xy) + (c[7].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r3.xx) * (c[8].xy) + (c[8].zw));
    r3.xy = (r0.xy) * (c14.zz) + (c14.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.x) : (r0.z));
    r0.z = (r3.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r3.y)) + (c3.x);
    r0.xy = (r1.zz) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r2.w = (r3.z) * (r0.w);
    r0.xy = (r0.xy) * (c3.yy) + (c3.yy);
    r0 = tex2D(s4, r0.xy);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r3.xyz = (r2.www) * (r1.xyz);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r3.xyz = (r1.www) * (r3.xyz);
    r4.xyz = (r2.xyz) * (r1.xyz);
    r2.xyz = (r5.www) * (r5.xyz) + (r6.xyz);
    r3.xyz = (r3.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r1.x = rsqrt(r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = rsqrt(r1.z);
    r0.w = rsqrt(r0.x);
    oC0.x = 1.0f / (r1.x);
    oC0.y = 1.0f / (r1.y);
    oC0.z = 1.0f / (r1.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
