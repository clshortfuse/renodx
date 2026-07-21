// Mechanically reconstructed from 0x992F78FD.ps_3_0.cso.
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
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD4;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
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
    const float4 c3 = float4(1.0f, 0.797884583f, 0.959999979f, 0.0399999991f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c6 = float4(4.0f, -2.0f, 0.0009765625f, 0.25f);
    const float4 c7 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c8 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c9 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
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

    r0 = tex2D(s1, v0.xy);
    r4.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r4.xy, r4.xy) + (c1.x);
    r1.w = exp2(-(r0.w));
    r0.xy = (v0.zw) * (c4.xy) + (c4.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c4.xy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r2.w = (r1.w) * (c1.y) + (c1.z);
    r3.xy = (r0.wy) * (c6.xx) + (c6.yy);
    r1 = tex2D(s14, v0.zw);
    r5.xy = (r1.xy) * (c4.ww);
    r0.w = dot(r3.xy, r4.xy) + (c1.x);
    r2.xy = (r2.xz) * (r5.xx);
    r0.y = dot(r3.xy, r3.xy) + (c1.x);
    r1.w = (r1.x) * (c4.w) + (-(r2.x));
    r0.y = exp2(-(r0.y));
    r1.w = (r2.z) * (-(r5.x)) + (r1.w);
    r3.xy = (r0.xz) * (r5.yy);
    r0.y = (r0.y) * (c1.y) + (c1.z);
    r0.x = (r1.y) * (c4.w) + (-(r3.x));
    r0.y = (r2.w) * (r0.y);
    r0.z = (r0.z) * (-(r5.y)) + (r0.x);
    r0.w = saturate((r0.w) * (r0.y) + (r0.y));
    r0.y = (r0.z) + (r0.z);
    r0.xz = (r3.xy) * (c6.xx);
    r7.y = (r1.w) + (r1.w);
    r0.xyz = (r0.www) * (r0.xyz);
    r7.xz = (r2.xy) * (c6.xx);
    r0.w = dot(v6.xyz, v6.xyz);
    r2.xyz = (r7.xyz) * (r2.www) + (r0.xyz);
    r2.w = rsqrt(r0.w);
    r0 = v1;
    r0.xyz = (r4.xxx) * (v4.xyz) + (r0.xyz);
    r3.xyz = (v6.xyz) * (-(r2.www)) + (c[17].xyz);
    r1.xyz = (r4.yyy) * (v3.xyz) + (r0.xyz);
    r0.xyz = normalize(r3.xyz);
    r8.xyz = normalize(r1.xyz);
    r1.w = saturate(dot(r0.xyz, c[17].xyz));
    r9.xyz = (r2.www) * (v6.xyz);
    r1.w = (-(r1.w)) + (c3.x);
    r7.w = saturate(dot(r8.xyz, -(r9.xyz)));
    r1.z = (r1.w) * (r1.w);
    r2.w = saturate(dot(r8.xyz, r0.xyz));
    r0.z = (r1.z) * (r1.z);
    r0.x = (r1.w) * (r0.z);
    r0.y = saturate(dot(r8.xyz, c[17].xyz));
    r1 = tex2D(s4, v0.xy);
    r0.z = (r1.w) * (-(c3.y)) + (c3.x);
    r1.x = (r1.w) * (c3.y);
    r1.z = (r7.w) * (r0.z) + (r1.x);
    r0.z = (r0.y) * (r0.z) + (r1.x);
    r0.z = (r0.z) * (r1.z) + (c6.z);
    r12.xy = (r1.ww) * (c7.xy) + (c7.zw);
    r1.z = 1.0f / (r0.z);
    r0.z = exp2(r12.y);
    r1.x = pow(abs(r2.w), r0.z);
    r0.z = (r0.z) * (c8.x) + (c8.y);
    r1.z = (r0.y) * (r1.z);
    r0.z = (r1.x) * (r0.z);
    r0.x = (r0.x) * (c3.z) + (c3.w);
    r0.z = (r1.z) * (r0.z);
    r1.x = (r0.x) * (r0.z);
    r11.xyz = (r2.xyz) * (r1.yyy);
    r2 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c4.x) : (c4.z));
    r10.xyz = (r0.yyy) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r1.z = r0.z;
    }
    else
    {
        if ((c3.x) >= (v5.w))
        {
            r3 = (v5.xyzx) * (c4.xxxz);
            r2 = (r3) + (-(c9.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c8.zzww);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (-(c8.zzww));
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c9.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r1.z = dot(r2, c6.wwww);
            if ((c9.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c8.zz);
                r2.zw = (v5.zx) * (c4.xz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (-(c8.zz));
                r3.zw = (v5.zx) * (c4.xz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c9.xy);
                r3.zw = (v5.zx) * (c4.xz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c9.xy));
                r3.zw = (v5.zx) * (c4.xz);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.z = dot(r2, c6.wwww);
                r0.y = (-(r1.z)) + (r0.z);
                r0.z = (v5.w) * (c10.x) + (c10.y);
                r1.z = (r0.z) * (r0.y) + (r1.z);
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c6.x));
            r0.z = ((r0.z) >= 0.0f ? (c4.z) : (c4.x));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c8.zz);
                r3.zw = (v5.zz) * (c4.xz);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (-(c8.zz));
                r4.zw = (v5.zz) * (c4.xz);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c9.xy);
                r4.zw = (v5.zz) * (c4.xz);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c9.xy));
                r4.zw = (v5.zz) * (c4.xz);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c6.wwww);
                r0.z = saturate((v5.w) + (c10.y));
                r0.y = (r2.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r2.y;
            }
            r1.z = r0.z;
        }
    }
    r0.z = (r1.y) * (r1.x);
    r0.xyz = (r0.zzz) * (c[19].xyz);
    r4.xyz = (r1.zzz) * (r10.xyz) + (r11.xyz);
    r5.xyz = (r1.zzz) * (r0.xyz);
    r3 = tex2D(s0, v0.xy);
    r2 = tex2D(s3, v7.zw);
    r0.xyz = (r2.xyz) * (v7.yyy);
    r3.xyz = (r0.xyz) * (r2.www) + (r3.xyz);
    r0.z = (-(r7.w)) + (c3.x);
    r0.x = 1.0f / (r12.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r9.xyz, r8.xyz);
    r1.z = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r1.w) * (c1.w);
    r2.xyz = (r8.xyz) * (-(r0.zzz)) + (r9.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r1.z) * (c3.z) + (c3.w);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r1.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r5.xyz);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.x;

    return oC0;
}
