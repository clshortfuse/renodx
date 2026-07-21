// Mechanically reconstructed from 0x45FB5FC8.ps_3_0.cso.
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
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c7 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c8 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c9 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
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
    float4 r13 = 0.0f;
    float4 r14 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v5.xyz, v5.xyz);
    r4.z = rsqrt(r0.w);
    r0.xyz = (v5.xyz) * (-(r4.zzz)) + (c[17].xyz);
    r3.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r3.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c0.y);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r0.xy = (v1.zw) * (c1.xy) + (c1.zy);
    r1 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v1.zw);
    r6.xy = (r2.xy) * (c1.ww);
    r4.w = (r0.w) * (r0.z);
    r4.xy = (r1.xz) * (r6.yy);
    r0.w = (r2.y) * (c1.w) + (-(r4.x));
    r1.w = (r1.z) * (-(r6.y)) + (r0.w);
    r0.xy = (v1.zw) * (c0.yw);
    r0 = tex2D(s13, r0.xy);
    r5.xy = (r6.xx) * (r0.xz);
    r1.x = r0.y;
    r0.w = (r2.x) * (c1.w) + (-(r5.x));
    r0.xy = (r1.xy) * (c3.xx) + (c3.yy);
    r0.z = (r0.z) * (-(r6.x)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c1.z);
    r6.y = (r0.z) + (r0.z);
    r0.w = exp2(-(r0.w));
    r2.y = (r1.w) + (r1.w);
    r3.w = saturate((r0.w) * (c3.z) + (c3.w));
    r6.xz = (r5.xy) * (c3.xx);
    r2.xz = (r4.xy) * (c3.xx);
    r9.xyz = normalize(v2.xyz);
    r10.xyz = (r4.zzz) * (v5.xyz);
    r3.z = saturate(dot(r9.xyz, r3.xyz));
    r6.w = saturate(dot(r9.xyz, -(r10.xyz)));
    r1 = tex2D(s2, v1.xy);
    r7.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r0.w = (r1.w) * (-(c0.z)) + (c0.y);
    r0.y = (r1.w) * (c0.z);
    r8.xyz = (r1.xyz) * (r1.xyz);
    r0.z = (r6.w) * (r0.w) + (r0.y);
    r13.xy = (r1.ww) * (c7.xy) + (c7.zw);
    r2.w = saturate(dot(r9.xyz, c[17].xyz));
    r1.z = exp2(r13.y);
    r0.w = (r2.w) * (r0.w) + (r0.y);
    r0.y = pow(abs(r3.z), r1.z);
    r0.z = (r0.w) * (r0.z) + (c4.x);
    r0.w = (r1.z) * (c4.y) + (c4.z);
    r0.z = 1.0f / (r0.z);
    r0.w = (r0.y) * (r0.w);
    r1.z = (r2.w) * (r0.z);
    r0.xyz = (r7.xyz) * (r4.www) + (r8.xyz);
    r0.w = (r0.w) * (r1.z);
    r1.xyz = (r2.xyz) * (r3.www) + (r6.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r11.xyz = (r1.xyz) * (c[5].yyy);
    r12.xyz = (r0.xyz) * (c[5].www);
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c1.x) : (c1.z));
    r1.xyz = (r2.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r2 = (v4.xyzx) * (c1.xxxz);
            r0 = (r2) + (-(c8.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r3 = (r2) + (c9.xxyy);
            r3 = tex2Dlod(s1, r3);
            r0.x = r3.x;
            r3 = (r2) + (c9.zzyy);
            r3 = tex2Dlod(s1, r3);
            r0.y = r3.x;
            r2 = (r2) + (c8.xyzz);
            r2 = tex2Dlod(s1, r2);
            r0.z = r2.x;
            r5.w = dot(r0, c4.zzzz);
            if ((c4.w) < (v4.w))
            {
                r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r5.xy) + (c9.xx);
                r0.zw = (v4.zx) * (c1.xz);
                r0 = tex2Dlod(s1, r0);
                r2.xy = (r5.xy) + (c9.zz);
                r2.zw = (v4.zx) * (c1.xz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (c8.xy);
                r2.zw = (v4.zx) * (c1.xz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (-(c8.xy));
                r2.zw = (v4.zx) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r0.y = r4.x;
                r0.z = r3.x;
                r0.w = r2.x;
                r0.w = dot(r0, c4.zzzz);
                r0.z = (-(r5.w)) + (r0.w);
                r0.w = (v4.w) * (c10.x) + (c10.y);
                r0.w = (r0.w) * (r0.z) + (r5.w);
            }
            else
            {
                r0.w = r5.w;
            }
        }
        else
        {
            r0.w = (v4.w) + (-(c3.x));
            r0.w = ((r0.w) >= 0.0f ? (c1.z) : (c1.x));
            if ((r0.w) != (-(r0.w)))
            {
                r14.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r14.xy) + (c9.xx);
                r2.zw = (v4.zz) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r14.xy) + (c9.zz);
                r3.zw = (v4.zz) * (c1.xz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r14.xy) + (c8.xy);
                r3.zw = (v4.zz) * (c1.xz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r14.xy) + (-(c8.xy));
                r3.zw = (v4.zz) * (c1.xz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c4.zzzz);
                r0.w = saturate((v4.w) + (c9.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
        }
    }
    r0.xyz = (r12.xyz) * (c[19].xyz);
    r3.xyz = (r0.www) * (r1.xyz) + (r11.xyz);
    r4.xyz = (r0.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r1.z = (-(r6.w)) + (c0.y);
    r1.x = 1.0f / (r13.x);
    r1.y = (r1.z) * (r1.z);
    r1.y = (r1.z) * (r1.y);
    r1.z = dot(r10.xyz, r9.xyz);
    r2.w = (r1.x) * (r1.y);
    r1.z = (r1.z) + (r1.z);
    r1.w = (r1.w) * (c0.x);
    r1.xyz = (r9.xyz) * (-(r1.zzz)) + (r10.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c[5].xxx);
    r5.xyz = (r7.xyz) * (r2.www) + (r8.xyz);
    r2.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r1.xyz) * (r5.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz) + (r4.xyz);
    r1.xyz = (r6.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c0.xxx) + (r2.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
