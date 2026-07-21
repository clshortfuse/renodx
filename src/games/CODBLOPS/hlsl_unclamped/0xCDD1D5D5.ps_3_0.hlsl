// Mechanically reconstructed from 0xCDD1D5D5.ps_3_0.cso.
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
    const float4 c1 = float4(1.0f, -1.0f, 0.200000003f, 0.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c6 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c7 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c8 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c9 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c10 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c11 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    float4 r13 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v6.xyz, v6.xyz);
    r4.z = rsqrt(r0.w);
    r0.xyz = (v6.xyz) * (-(r4.zzz)) + (c[17].xyz);
    r3.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r3.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c1.x);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r2.w = (r0.w) * (r0.z);
    r1 = tex2D(s0, v0.xy);
    r1.w = (r1.w) * (-(v7.x)) + (c1.x);
    r0 = tex2D(s2, v7.zw);
    r5.z = (r0.w) * (v7.y);
    r2.xyz = lerp(r1.xyz, r0.xyz, r5.zzz);
    r0.w = (r0.w) * (-(v7.y)) + (c1.x);
    r5.w = (r1.w) * (-(r0.w)) + (c1.x);
    r0.w = c1.z;
    r6.xyz = (r2.xyz) * (r2.xyz);
    r0.w = (r5.z) * (r0.w);
    r6.w = (r0.w) * (-(r0.w)) + (c1.x);
    r7.w = (r0.w) * (r0.w);
    r0 = tex2D(s3, v7.zw);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.xy = (v0.zw) * (c4.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c4.xy) + (c4.zy);
    r0 = tex2D(s13, r0.xy);
    r1.w = r0.y;
    r7.xy = (r5.zz) * (r2.xy);
    r2.xy = (r1.yw) * (c6.xx) + (c6.yy);
    r0.y = dot(r7.xy, r7.xy) + (c1.w);
    r0.w = dot(r2.xy, r2.xy) + (c1.w);
    r0.y = exp2(-(r0.y));
    r0.w = exp2(-(r0.w));
    r4.w = (r0.y) * (c3.x) + (c3.y);
    r0.y = (r0.w) * (c3.x) + (c3.y);
    r0.w = dot(r2.xy, r7.xy) + (c1.w);
    r0.y = (r4.w) * (r0.y);
    r3.w = (r6.w) * (r2.w) + (r7.w);
    r0.w = saturate((r0.w) * (r0.y) + (r0.y));
    r2 = tex2D(s14, v0.zw);
    r5.xy = (r2.xy) * (c4.ww);
    r4.xy = (r1.xz) * (r5.xx);
    r1.xy = (r0.xz) * (r5.yy);
    r0.x = (r2.x) * (c4.w) + (-(r4.x));
    r0.y = (r2.y) * (c4.w) + (-(r1.x));
    r1.w = (r1.z) * (-(r5.x)) + (r0.x);
    r0.z = (r0.z) * (-(r5.y)) + (r0.y);
    r0.y = (r0.z) + (r0.z);
    r0.xz = (r1.xy) * (c6.xx);
    r5.y = (r1.w) + (r1.w);
    r1.xyz = (r0.www) * (r0.xyz);
    r0 = tex2D(s4, v7.zw);
    r0.yz = (r0.wy) + (c1.yy);
    r11.xy = (r5.zz) * (r0.yz) + (c1.xx);
    r0.xyz = v1.xyz;
    r0.xyz = (r7.xxx) * (v4.xyz) + (r0.xyz);
    r0.w = (r11.x) * (-(c6.z)) + (c6.w);
    r0.xyz = (r7.yyy) * (v3.xyz) + (r0.xyz);
    r7.xyz = normalize(r0.xyz);
    r8.xyz = (r4.zzz) * (v6.xyz);
    r8.w = saturate(dot(r7.xyz, -(r8.xyz)));
    r0.y = (r11.x) * (c3.w);
    r2.z = saturate(dot(r7.xyz, r3.xyz));
    r0.z = (r8.w) * (r0.w) + (r0.y);
    r12.xy = (r11.xx) * (c8.xy) + (c8.zw);
    r1.w = saturate(dot(r7.xyz, c[17].xyz));
    r2.w = exp2(r12.y);
    r0.w = (r1.w) * (r0.w) + (r0.y);
    r0.y = pow(abs(r2.z), r2.w);
    r0.z = (r0.w) * (r0.z) + (c7.x);
    r0.w = (r2.w) * (c7.y) + (c7.z);
    r0.z = 1.0f / (r0.z);
    r0.w = (r0.y) * (r0.w);
    r0.z = (r1.w) * (r0.z);
    r5.xz = (r4.xy) * (c6.xx);
    r0.w = (r0.w) * (r0.z);
    r0.xyz = (r5.xyz) * (r4.www) + (r1.xyz);
    r0.w = (r3.w) * (r0.w);
    r10.xyz = (r11.yyy) * (r0.xyz);
    r9.w = (r11.y) * (r0.w);
    r0 = tex2D(s12, v0.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c1.x) : (c1.w));
    r9.xyz = (r1.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r1.w = r0.w;
    }
    else
    {
        if ((c1.x) >= (v5.w))
        {
            r1 = (v5.xyzx) * (c1.xxxw);
            r0 = (r1) + (-(c9.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r2 = (r1) + (c10.xxyy);
            r2 = tex2Dlod(s1, r2);
            r0.x = r2.x;
            r2 = (r1) + (c10.zzyy);
            r2 = tex2Dlod(s1, r2);
            r0.y = r2.x;
            r1 = (r1) + (c9.xyzz);
            r1 = tex2Dlod(s1, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c7.zzzz);
            if ((c7.w) < (v5.w))
            {
                r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c10.xx);
                r0.zw = (v5.zx) * (c1.xw);
                r0 = tex2Dlod(s1, r0);
                r1.xy = (r4.xy) + (c10.zz);
                r1.zw = (v5.zx) * (c1.xw);
                r3 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (c9.xy);
                r1.zw = (v5.zx) * (c1.xw);
                r2 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (-(c9.xy));
                r1.zw = (v5.zx) * (c1.xw);
                r1 = tex2Dlod(s1, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c7.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v5.w) * (c11.x) + (c11.y);
                r1.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r1.w = r4.w;
            }
        }
        else
        {
            r0.w = (v5.w) + (-(c6.x));
            r0.w = ((r0.w) >= 0.0f ? (c1.w) : (c1.x));
            if ((r0.w) != (-(r0.w)))
            {
                r13.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r13.xy) + (c10.xx);
                r1.zw = (v5.zz) * (c1.xw);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r13.xy) + (c10.zz);
                r2.zw = (v5.zz) * (c1.xw);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r13.xy) + (c9.xy);
                r2.zw = (v5.zz) * (c1.xw);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r13.xy) + (-(c9.xy));
                r2.zw = (v5.zz) * (c1.xw);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c7.zzzz);
                r0.w = saturate((v5.w) + (c10.w));
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
    r1.xyz = (r1.www) * (r9.xyz) + (r10.xyz);
    r2.xyz = (r9.www) * (c[19].xyz);
    r0.w = (-(r8.w)) + (c1.x);
    r0.y = 1.0f / (r12.x);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.w) * (r0.z);
    r0.w = dot(r8.xyz, r7.xyz);
    r2.w = (r0.y) * (r0.z);
    r0.z = (r0.w) + (r0.w);
    r0.w = (r11.x) * (c3.z);
    r0.xyz = (r7.xyz) * (-(r0.zzz)) + (r8.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r6.w) * (r2.w) + (r7.w);
    r0.xyz = (r11.yyy) * (r0.xyz);
    r2.xyz = (r1.www) * (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz);
    r1.xyz = (r6.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.zzz) + (r1.xyz);
    r1.xyz = (r5.www) * (v2.xyz);
    r0.xyz = (r0.xyz) * (r5.www) + (-(r1.xyz));
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r5.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
