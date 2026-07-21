// Mechanically reconstructed from 0xB36BFB83.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c12 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c15 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c16 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c22 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    float4 r15 = 0.0f;
    float4 r16 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v6.xyz, v6.xyz);
    r6.w = rsqrt(r0.w);
    r0.xyz = (v6.xyz) * (-(r6.www)) + (c[17].xyz);
    r5.xyz = normalize(r0.xyz);
    r0 = tex2D(s0, v0.xy);
    r1.w = (r0.w) * (v7.x) + (c1.x);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r6.z = saturate(dot(r5.xyz, c[17].xyz));
    r3 = float4(((r1.w) >= 0.0f ? (r0.x) : (c1.z)), ((r1.w) >= 0.0f ? (r0.y) : (c1.z)), ((r1.w) >= 0.0f ? (r0.z) : (c1.z)), ((r1.w) >= 0.0f ? (r0.w) : (c1.z)));
    r0 = tex2D(s3, v7.zw);
    r4.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s2, v7.zw);
    r5.w = (r0.w) * (v7.y) + (c1.x);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r0 = float4(((r5.w) >= 0.0f ? (r0.x) : (r3.x)), ((r5.w) >= 0.0f ? (r0.y) : (r3.y)), ((r5.w) >= 0.0f ? (r0.z) : (r3.z)), ((r5.w) >= 0.0f ? (r0.w) : (r3.w)));
    r1.xy = (v0.zw) * (c4.xy);
    r2 = tex2D(s13, r1.xy);
    r1.xy = (v0.zw) * (c4.xy) + (c4.zy);
    r1 = tex2D(s13, r1.xy);
    r2.w = r1.y;
    r6.xy = float2(((r5.w) >= 0.0f ? (r4.x) : (c1.z)), ((r5.w) >= 0.0f ? (r4.y) : (c1.z)));
    r3.xy = (r2.yw) * (c12.xx) + (c12.yy);
    r1.y = dot(r6.xy, r6.xy) + (c1.z);
    r1.w = dot(r3.xy, r3.xy) + (c1.z);
    r1.y = exp2(-(r1.y));
    r1.w = exp2(-(r1.w));
    r2.w = (r1.y) * (c3.x) + (c3.y);
    r1.y = (r1.w) * (c3.x) + (c3.y);
    r1.w = dot(r3.xy, r6.xy) + (c1.z);
    r1.y = (r2.w) * (r1.y);
    r8.xyz = (r0.xyz) * (r0.xyz);
    r3.z = saturate((r1.w) * (r1.y) + (r1.y));
    r4 = tex2D(s14, v0.zw);
    r0.xy = (r4.xy) * (c3.ww);
    r2.xy = (r2.xz) * (r0.xx);
    r1.xy = (r1.xz) * (r0.yy);
    r1.w = (r4.x) * (c3.w) + (-(r2.x));
    r0.z = (r4.y) * (c3.w) + (-(r1.x));
    r0.x = (r2.z) * (-(r0.x)) + (r1.w);
    r0.z = (r1.z) * (-(r0.y)) + (r0.z);
    r9.y = (r0.x) + (r0.x);
    r0.y = (r0.z) + (r0.z);
    r0.xz = (r1.xy) * (c4.ww);
    r1.w = (-(r6.z)) + (c1.y);
    r0.xyz = (r3.zzz) * (r0.xyz);
    r1.z = (r1.w) * (r1.w);
    r9.xz = (r2.xy) * (c4.ww);
    r1.z = (r1.z) * (r1.z);
    r3.xyz = (r9.xyz) * (r2.www) + (r0.xyz);
    r4.z = (r1.w) * (r1.z);
    r1 = tex2D(s4, v7.zw);
    r2 = float4(((r5.w) >= 0.0f ? (r1.x) : (c1.z)), ((r5.w) >= 0.0f ? (r1.y) : (c1.z)), ((r5.w) >= 0.0f ? (r1.z) : (c1.z)), ((r5.w) >= 0.0f ? (r1.w) : (c1.y)));
    r1 = v1;
    r0.xyz = (r6.xxx) * (v4.xyz) + (r1.xyz);
    r11.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.yyy);
    r0.xyz = (r6.yyy) * (v3.xyz) + (r0.xyz);
    r10.xyz = normalize(r0.xyz);
    r14.xyz = (r6.www) * (v6.xyz);
    r0.z = (r2.w) * (-(c12.z)) + (c12.w);
    r8.w = saturate(dot(r10.xyz, -(r14.xyz)));
    r0.x = (r2.w) * (c3.z);
    r4.w = saturate(dot(r10.xyz, c[17].xyz));
    r0.y = (r8.w) * (r0.z) + (r0.x);
    r0.z = (r4.w) * (r0.z) + (r0.x);
    r12.xyz = (r2.xyz) * (r2.xyz);
    r0.z = (r0.z) * (r0.y) + (c13.x);
    r0.x = 1.0f / (r0.z);
    r16.xy = (r2.ww) * (c14.xy) + (c14.zw);
    r1.y = saturate(dot(r10.xyz, r5.xyz));
    r1.z = exp2(r16.y);
    r0.y = pow(abs(r1.y), r1.z);
    r0.z = (r1.z) * (c13.y) + (c13.z);
    r1.y = (r4.w) * (r0.x);
    r1.z = (r0.y) * (r0.z);
    r0.xyz = (r11.xyz) * (r4.zzz) + (r12.xyz);
    r1.z = (r1.y) * (r1.z);
    r13.xyz = float3(((r5.w) >= 0.0f ? (c[20].x) : (r3.w)), ((r5.w) >= 0.0f ? (c[20].y) : (r3.w)), ((r5.w) >= 0.0f ? (c[20].w) : (r3.w)));
    r0.xyz = (r0.xyz) * (r1.zzz);
    r15.xyz = (r3.xyz) * (r13.yyy);
    r1.xyz = (r13.zzz) * (r0.xyz);
    r3 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r3.y)) >= 0.0f ? (c1.y) : (c1.z));
    r2.xyz = (r4.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r3.y;
        r3.w = r0.z;
    }
    else
    {
        if ((c1.y) >= (v5.w))
        {
            r4 = (v5.xyzx) * (c1.yyyz);
            r3 = (r4) + (-(c16.xyzz));
            r3 = tex2Dlod(s1, r3);
            r3.w = r3.x;
            r5 = (r4) + (c15.xxyy);
            r5 = tex2Dlod(s1, r5);
            r3.x = r5.x;
            r5 = (r4) + (c15.zzyy);
            r5 = tex2Dlod(s1, r5);
            r3.y = r5.x;
            r4 = (r4) + (c16.xyzz);
            r4 = tex2Dlod(s1, r4);
            r3.z = r4.x;
            r0.z = dot(r3, c13.zzzz);
            if ((c13.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c15.xx);
                r3.zw = (v5.zx) * (c1.yz);
                r3 = tex2Dlod(s1, r3);
                r4.xy = (r0.xy) + (c15.zz);
                r4.zw = (v5.zx) * (c1.yz);
                r6 = tex2Dlod(s1, r4);
                r4.xy = (r0.xy) + (c16.xy);
                r4.zw = (v5.zx) * (c1.yz);
                r5 = tex2Dlod(s1, r4);
                r4.xy = (r0.xy) + (-(c16.xy));
                r4.zw = (v5.zx) * (c1.yz);
                r4 = tex2Dlod(s1, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.y = dot(r3, c13.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c22.x) + (c22.y);
                r3.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r3.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c4.w));
            r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r4.xy = (r0.xy) + (c15.xx);
                r4.zw = (v5.zz) * (c1.yz);
                r4 = tex2Dlod(s1, r4);
                r5.xy = (r0.xy) + (c15.zz);
                r5.zw = (v5.zz) * (c1.yz);
                r7 = tex2Dlod(s1, r5);
                r5.xy = (r0.xy) + (c16.xy);
                r5.zw = (v5.zz) * (c1.yz);
                r6 = tex2Dlod(s1, r5);
                r5.xy = (r0.xy) + (-(c16.xy));
                r5.zw = (v5.zz) * (c1.yz);
                r5 = tex2Dlod(s1, r5);
                r4.y = r7.x;
                r4.z = r6.x;
                r4.w = r5.x;
                r0.x = dot(r4, c13.zzzz);
                r0.z = saturate((v5.w) + (c15.w));
                r0.y = (r3.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r3.y;
            }
            r3.w = r0.z;
        }
    }
    r1.xyz = (r1.xyz) * (c[19].xyz);
    r0.xyz = (r3.www) * (r2.xyz) + (r15.xyz);
    r1.xyz = (r3.www) * (r1.xyz);
    r1.xyz = (r8.xyz) * (r0.xyz) + (r1.xyz);
    r0.z = (-(r8.w)) + (c1.y);
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r14.xyz, r10.xyz);
    r6.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r2.w) * (c1.w);
    r2.xyz = (r10.xyz) * (-(r0.zzz)) + (r14.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r5 = (-(v6.yyyy)) + (c[6]);
    r4 = (-(v6.xxxx)) + (c[5]);
    r2 = (r5) * (r5);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v6.zzzz)) + (c[7]);
    r0.xyz = (r13.xxx) * (r0.xyz);
    r2 = (r3) * (r3) + (r2);
    r7.xyz = (r11.xyz) * (r6.www) + (r12.xyz);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r0.xyz = (r0.xyz) * (r7.xyz);
    r5 = (r5) * (r6);
    r5 = (r10.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r10.xxxx) + (r5);
    r3 = saturate((r3) * (r10.zzzz) + (r4));
    r4.z = c1.y;
    r2 = saturate((r2) * (c[8]) + (r4.zzzz));
    r0.xyz = (r9.xyz) * (r0.xyz);
    r2 = (r3) * (r2);
    r1.xyz = (r0.xyz) * (c1.www) + (r1.xyz);
    r0.z = dot(c[11], r2);
    r0.x = dot(c[9], r2);
    r0.y = dot(c[10], r2);
    r0.xyz = (r8.xyz) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
