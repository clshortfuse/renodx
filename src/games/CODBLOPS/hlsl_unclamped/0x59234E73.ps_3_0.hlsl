// Mechanically reconstructed from 0x59234E73.ps_3_0.cso.
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
sampler2D s5 : register(s5);
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
    const float4 c1 = float4(-0.5f, 0.0f, 0.600000024f, 0.400000006f);
    const float4 c3 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c4 = float4(0.959999979f, 0.0399999991f, 31.875f, 4.0f);
    const float4 c7 = float4(4.0f, -2.0f, 0.125f, 0.25f);
    const float4 c8 = float4(1.0f, 0.5f, 0.0f, 0.0009765625f);
    const float4 c9 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c10 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c11 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
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
    float4 r10 = 0.0f;
    float4 r11 = 0.0f;
    float4 r12 = 0.0f;
    float4 r13 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = tex2D(s1, v0.xy);
    r0.xy = (v0.zw) * (c8.xy) + (c8.zy);
    r0 = tex2D(s13, r0.xy);
    r2.xy = (v0.zw) * (c3.yw);
    r2 = tex2D(s13, r2.xy);
    r0.w = r2.y;
    r4.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1.xy = (r0.wy) * (c7.xx) + (c7.yy);
    r0.w = dot(r4.xy, r4.xy) + (c1.y);
    r0.y = dot(r1.xy, r1.xy) + (c1.y);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c1.z) + (c1.w);
    r1.w = (r0.y) * (c1.z) + (c1.w);
    r0.y = dot(r1.xy, r4.xy) + (c1.y);
    r2.w = (r0.w) * (r1.w);
    r1 = tex2D(s14, v0.zw);
    r5.xy = (r1.xy) * (c4.zz);
    r1.w = saturate((r0.y) * (r2.w) + (r2.w));
    r2.xy = (r2.xz) * (r5.xx);
    r0.y = (r1.x) * (c4.z) + (-(r2.x));
    r3.xy = (r0.xz) * (r5.yy);
    r0.y = (r2.z) * (-(r5.x)) + (r0.y);
    r0.x = (r1.y) * (c4.z) + (-(r3.x));
    r0.z = (r0.z) * (-(r5.y)) + (r0.x);
    r6.y = (r0.y) + (r0.y);
    r0.y = (r0.z) + (r0.z);
    r0.xz = (r3.xy) * (c4.ww);
    r0.xyz = (r1.www) * (r0.xyz);
    r6.xz = (r2.xy) * (c4.ww);
    r3.xyz = (r6.xyz) * (r0.www) + (r0.xyz);
    r2 = tex2D(s4, v0.xy);
    r0 = tex2D(s3, v7.zw);
    r0.w = (r0.w) * (v7.y) + (c1.x);
    r1 = tex2D(s5, v7.zw);
    r12.xy = float2(((r0.w) >= 0.0f ? (r1.w) : (r2.w)), ((r0.w) >= 0.0f ? (r1.y) : (r2.y)));
    r1 = tex2D(s0, v0.xy);
    r1.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (r1.x)), ((r0.w) >= 0.0f ? (r0.y) : (r1.y)), ((r0.w) >= 0.0f ? (r0.z) : (r1.z)));
    r1.w = (r12.x) * (-(c3.z)) + (c3.y);
    r0.w = dot(v6.xyz, v6.xyz);
    r2.w = rsqrt(r0.w);
    r0 = v1;
    r0.xyz = (r4.xxx) * (v4.xyz) + (r0.xyz);
    r3.w = (r12.x) * (c3.z);
    r0.xyz = (r4.yyy) * (v3.xyz) + (r0.xyz);
    r8.xyz = normalize(r0.xyz);
    r9.xyz = (r2.www) * (v6.xyz);
    r6.w = saturate(dot(r8.xyz, -(r9.xyz)));
    r2.xyz = (v6.xyz) * (-(r2.www)) + (c[17].xyz);
    r2.w = (r6.w) * (r1.w) + (r3.w);
    r0.xyz = normalize(r2.xyz);
    r2.y = saturate(dot(r8.xyz, r0.xyz));
    r13.xy = (r12.xx) * (c9.xy) + (c9.zw);
    r0.x = saturate(dot(r0.xyz, c[17].xyz));
    r2.z = exp2(r13.y);
    r0.y = pow(abs(r2.y), r2.z);
    r0.z = (r2.z) * (c7.z) + (c7.w);
    r0.z = (r0.y) * (r0.z);
    r0.y = saturate(dot(r8.xyz, c[17].xyz));
    r1.w = (r0.y) * (r1.w) + (r3.w);
    r0.x = (-(r0.x)) + (c3.y);
    r1.w = (r1.w) * (r2.w) + (c8.w);
    r2.w = (r0.x) * (r0.x);
    r1.w = 1.0f / (r1.w);
    r2.w = (r2.w) * (r2.w);
    r1.w = (r0.y) * (r1.w);
    r0.x = (r0.x) * (r2.w);
    r0.z = (r0.z) * (r1.w);
    r0.x = (r0.x) * (c4.x) + (c4.y);
    r7.xyz = (r1.xyz) * (r1.xyz);
    r0.z = (r0.z) * (r0.x);
    r7.w = (r12.y) * (r0.z);
    r11.xyz = (r3.xyz) * (r12.yyy);
    r1 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c8.x) : (c8.z));
    r10.xyz = (r0.yyy) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c3.y) >= (v5.w))
        {
            r2 = (v5.xyzx) * (c8.xxxz);
            r1 = (r2) + (-(c11.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r3 = (r2) + (c10.xxyy);
            r3 = tex2Dlod(s2, r3);
            r1.x = r3.x;
            r3 = (r2) + (c10.zzyy);
            r3 = tex2Dlod(s2, r3);
            r1.y = r3.x;
            r2 = (r2) + (c11.xyzz);
            r2 = tex2Dlod(s2, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c7.wwww);
            if ((c10.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c10.xx);
                r1.zw = (v5.zx) * (c8.xz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r0.xy) + (c10.zz);
                r2.zw = (v5.zx) * (c8.xz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (c11.xy);
                r2.zw = (v5.zx) * (c8.xz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (-(c11.xy));
                r2.zw = (v5.zx) * (c8.xz);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c7.wwww);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c12.x) + (c12.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c4.w));
            r0.z = ((r0.z) >= 0.0f ? (c8.z) : (c8.x));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c10.xx);
                r2.zw = (v5.zz) * (c8.xz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c10.zz);
                r3.zw = (v5.zz) * (c8.xz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c11.xy);
                r3.zw = (v5.zz) * (c8.xz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c11.xy));
                r3.zw = (v5.zz) * (c8.xz);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c7.wwww);
                r0.z = saturate((v5.w) + (c11.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
            r2.w = r0.z;
        }
    }
    r2.xyz = (r2.www) * (r10.xyz) + (r11.xyz);
    r3.xyz = (r7.www) * (c[19].xyz);
    r0.z = (-(r6.w)) + (c3.y);
    r0.x = 1.0f / (r13.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r9.xyz, r8.xyz);
    r3.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r12.x) * (c3.x);
    r1.xyz = (r8.xyz) * (-(r0.zzz)) + (r9.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r3.w) * (c4.x) + (c4.y);
    r0.xyz = (r12.yyy) * (r0.xyz);
    r1.xyz = (r2.www) * (r3.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r1.xyz = (r7.xyz) * (r2.xyz) + (r1.xyz);
    r0.xyz = (r6.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[5].w;

    return oC0;
}
