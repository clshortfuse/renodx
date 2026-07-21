// Mechanically reconstructed from 0x7B1BF719.ps_3_0.cso.
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
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0009765625f, 0.25f);
    const float4 c12 = float4(1.0f, 0.797884583f, 0.959999979f, 0.0399999991f);
    const float4 c13 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c14 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c16 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c3.xy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1.w = dot(r3.xy, r3.xy) + (c1.x);
    r1.xy = (r0.wy) * (c4.xx) + (c4.yy);
    r0.y = exp2(-(r1.w));
    r0.w = dot(r1.xy, r1.xy) + (c1.x);
    r2.w = (r0.y) * (c1.y) + (c1.z);
    r0.y = exp2(-(r0.w));
    r0.w = dot(r1.xy, r3.xy) + (c1.x);
    r0.y = (r0.y) * (c1.y) + (c1.z);
    r1 = tex2D(s14, v1.zw);
    r6.xy = (r1.xy) * (c3.ww);
    r0.y = (r2.w) * (r0.y);
    r4.xy = (r2.xz) * (r6.xx);
    r3.z = saturate((r0.w) * (r0.y) + (r0.y));
    r0.w = (r1.x) * (c3.w) + (-(r4.x));
    r0.w = (r2.z) * (-(r6.x)) + (r0.w);
    r0.y = dot(v7.xyz, v7.xyz);
    r5.xy = (r0.xz) * (r6.yy);
    r3.w = rsqrt(r0.y);
    r0.y = (r1.y) * (c3.w) + (-(r5.x));
    r2.xyz = (v7.xyz) * (-(r3.www)) + (c[17].xyz);
    r0.z = (r0.z) * (-(r6.y)) + (r0.y);
    r1.xyz = normalize(r2.xyz);
    r6.y = (r0.w) + (r0.w);
    r0.w = saturate(dot(r1.xyz, c[17].xyz));
    r0.y = (r0.z) + (r0.z);
    r0.w = (-(r0.w)) + (c12.x);
    r0.xz = (r5.xy) * (c4.xx);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r3.zzz) * (r0.xyz);
    r1.w = (r1.w) * (r1.w);
    r6.xz = (r4.xy) * (c4.xx);
    r0.w = (r0.w) * (r1.w);
    r2.xyz = (r6.xyz) * (r2.www) + (r0.xyz);
    r2.w = (r0.w) * (c12.z) + (c12.w);
    r0 = tex2D(s3, v1.xy);
    r1.w = (r0.w) * (-(c12.y)) + (c12.x);
    r8.xyz = (r2.xyz) * (r0.yyy);
    r2.xyz = v2.xyz;
    r2.xyz = (r3.xxx) * (v5.xyz) + (r2.xyz);
    r3.z = (r0.w) * (c12.y);
    r2.xyz = (r3.yyy) * (v4.xyz) + (r2.xyz);
    r10.xyz = normalize(r2.xyz);
    r9.xyz = (r3.www) * (v7.xyz);
    r0.z = saturate(dot(r10.xyz, -(r9.xyz)));
    r2.xy = (r0.ww) * (c13.xy) + (c13.zw);
    r2.z = (r0.z) * (r1.w) + (r3.z);
    r2.y = exp2(r2.y);
    r3.w = saturate(dot(r10.xyz, r1.xyz));
    r0.x = saturate(dot(r10.xyz, c[17].xyz));
    r1.y = pow(abs(r3.w), r2.y);
    r1.z = (r0.x) * (r1.w) + (r3.z);
    r1.w = (r2.y) * (c14.x) + (c14.y);
    r1.z = (r1.z) * (r2.z) + (c4.z);
    r1.w = (r1.y) * (r1.w);
    r1.z = 1.0f / (r1.z);
    r1.z = (r0.x) * (r1.z);
    r0.z = (-(r0.z)) + (c12.x);
    r1.w = (r1.w) * (r1.z);
    r1.y = (r0.z) * (r0.z);
    r1.z = 1.0f / (r2.x);
    r0.z = (r0.z) * (r1.y);
    r1.w = (r2.w) * (r1.w);
    r0.z = (r1.z) * (r0.z);
    r6.w = (r0.y) * (r1.w);
    r7.w = (r0.z) * (c12.z) + (c12.w);
    r1 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c3.x) : (c3.z));
    r7.xyz = (r0.xxx) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c12.x) >= (v6.w))
        {
            r2 = (v6.xyzx) * (c3.xxxz);
            r1 = (r2) + (-(c15.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r3 = (r2) + (c14.zzww);
            r3 = tex2Dlod(s2, r3);
            r1.x = r3.x;
            r3 = (r2) + (-(c14.zzww));
            r3 = tex2Dlod(s2, r3);
            r1.y = r3.x;
            r2 = (r2) + (c15.xyzz);
            r2 = tex2Dlod(s2, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c4.wwww);
            if ((c15.w) < (v6.w))
            {
                r5.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r5.xy) + (c14.zz);
                r1.zw = (v6.zx) * (c3.xz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r5.xy) + (-(c14.zz));
                r2.zw = (v6.zx) * (c3.xz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r5.xy) + (c15.xy);
                r2.zw = (v6.zx) * (c3.xz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r5.xy) + (-(c15.xy));
                r2.zw = (v6.zx) * (c3.xz);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c4.wwww);
                r1.w = (-(r0.z)) + (r0.x);
                r0.x = (v6.w) * (c16.x) + (c16.y);
                r2.w = (r0.x) * (r1.w) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c4.x));
            r0.z = ((r0.z) >= 0.0f ? (c3.z) : (c3.x));
            if ((r0.z) != (-(r0.z)))
            {
                r11.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r11.xy) + (c14.zz);
                r2.zw = (v6.zz) * (c3.xz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r11.xy) + (-(c14.zz));
                r3.zw = (v6.zz) * (c3.xz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r11.xy) + (c15.xy);
                r3.zw = (v6.zz) * (c3.xz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r11.xy) + (-(c15.xy));
                r3.zw = (v6.zz) * (c3.xz);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r1.w = dot(r2, c4.wwww);
                r0.z = saturate((v6.w) + (c16.y));
                r0.x = (r1.y) + (-(r1.w));
                r0.z = (r0.z) * (r0.x) + (r1.w);
            }
            else
            {
                r0.z = r1.y;
            }
            r2.w = r0.z;
        }
    }
    r0.z = dot(r9.xyz, r10.xyz);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r0.w) * (c1.w);
    r1.xyz = (r10.xyz) * (-(r0.zzz)) + (r9.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r8.xyz = (r2.www) * (r7.xyz) + (r8.xyz);
    r0.xyz = (r0.yyy) * (r1.xyz);
    r1.xyz = (r7.www) * (r0.xyz);
    r0.xyz = (r6.www) * (c[19].xyz);
    r7.xyz = (r6.xyz) * (r1.xyz);
    r9.xyz = (r2.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r4 = (-(v7.yyyy)) + (c[6]);
    r3 = (-(v7.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v7.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r0 = (r0.wxyz) * (v0.wxyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r6.xyz = (r0.yzw) * (r0.yzw);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r0.w = c12.x;
    r1 = saturate((r1) * (c[8]) + (r0.wwww));
    r3.xyz = (r6.xyz) * (r8.xyz) + (r9.xyz);
    r1 = (r2) * (r1);
    r3.xyz = (r7.xyz) * (c1.www) + (r3.xyz);
    r2.z = dot(c[11], r1);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r1.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
