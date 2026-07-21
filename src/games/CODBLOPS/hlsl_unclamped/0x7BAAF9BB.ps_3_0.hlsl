// Mechanically reconstructed from 0x7BAAF9BB.ps_3_0.cso.
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
sampler2D s6 : register(s6);
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
    float4 v8 : COLOR1;
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
    float4 v8 = input.v8;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(2.0f, -1.0f, -0.5f, -0.0f);
    const float4 c3 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c8 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c9 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c10 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c11 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c13 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    r8.w = rsqrt(r0.w);
    r0.xyz = (v6.xyz) * (-(r8.www)) + (c[17].xyz);
    r7.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r7.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (-(c1.y));
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r7.w = (r0.w) * (r0.z);
    r0 = tex2D(s4, v7.zw);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c1.xxxx) * (v8) + (c1.yyyy);
    r3.y = dot(r1.xy, r0.zw) + (c1.w);
    r3.x = dot(r1.xy, r0.xy) + (c1.w);
    r0 = tex2D(s1, v0.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s0, v0.xy);
    r8.z = (r0.w) * (v7.x) + (c1.z);
    r0 = (r0.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r5.xy = float2(((r8.z) >= 0.0f ? (r1.x) : (c1.w)), ((r8.z) >= 0.0f ? (r1.y) : (c1.w)));
    r2 = float4(((r8.z) >= 0.0f ? (r0.x) : (c1.w)), ((r8.z) >= 0.0f ? (r0.y) : (c1.w)), ((r8.z) >= 0.0f ? (r0.z) : (c1.w)), ((r8.z) >= 0.0f ? (r0.w) : (c1.w)));
    r0 = tex2D(s3, v7.zw);
    r6.w = (r0.w) * (v7.y);
    r1.xy = (v0.zw) * (-(c1.yz));
    r4 = tex2D(s13, r1.xy);
    r1.xy = (v0.zw) * (-(c1.yz)) + (-(c1.wz));
    r1 = tex2D(s13, r1.xy);
    r4.w = r1.y;
    r8.xy = lerp(r5.xy, r3.xy, r6.ww);
    r3.xy = (r4.yw) * (c8.xx) + (c8.yy);
    r1.w = dot(r8.xy, r8.xy) + (c1.w);
    r1.y = dot(r3.xy, r3.xy) + (c1.w);
    r1.w = exp2(-(r1.w));
    r1.y = exp2(-(r1.y));
    r1.w = (r1.w) * (c4.x) + (c4.y);
    r3.w = (r1.y) * (c4.x) + (c4.y);
    r1.y = dot(r3.xy, r8.xy) + (c1.w);
    r4.w = (r1.w) * (r3.w);
    r3 = tex2D(s14, v0.zw);
    r6.xy = (r3.xy) * (c4.ww);
    r3.w = saturate((r1.y) * (r4.w) + (r4.w));
    r4.xy = (r4.xz) * (r6.xx);
    r1.y = (r3.x) * (c4.w) + (-(r4.x));
    r5.xy = (r1.xz) * (r6.yy);
    r1.y = (r4.z) * (-(r6.x)) + (r1.y);
    r1.x = (r3.y) * (c4.w) + (-(r5.x));
    r1.z = (r1.z) * (-(r6.y)) + (r1.x);
    r9.y = (r1.y) + (r1.y);
    r1.y = (r1.z) + (r1.z);
    r1.xz = (r5.xy) * (c8.xx);
    r1.xyz = (r3.www) * (r1.xyz);
    r9.xz = (r4.xy) * (c8.xx);
    r4.xyz = lerp(r2.xyz, r0.xyz, r6.www);
    r6.xyz = (r9.xyz) * (r1.www) + (r1.xyz);
    r1 = tex2D(s5, v0.xy);
    r3 = (r1.wwww) * (c3.xxxy) + (c3.zzzx);
    r2.xyz = (r4.xyz) * (r4.xyz);
    r5 = float4(((r8.z) >= 0.0f ? (r3.x) : (-(c1.w))), ((r8.z) >= 0.0f ? (r3.y) : (-(c1.w))), ((r8.z) >= 0.0f ? (r3.z) : (-(c1.w))), ((r8.z) >= 0.0f ? (r3.w) : (-(c1.y))));
    r4 = tex2D(s6, v7.zw);
    r3 = lerp(r5, r4, r6.wwww);
    r4.w = ((r8.z) >= 0.0f ? (r1.y) : (c1.w));
    r10.xyz = (r3.xyz) * (-(r3.xyz)) + (-(c1.yyy));
    r11.xyz = (r3.xyz) * (r3.xyz);
    r1 = v1;
    r0.xyz = (r8.xxx) * (v4.xyz) + (r1.xyz);
    r4.z = (r3.w) * (-(c8.z)) + (c8.w);
    r0.xyz = (r8.yyy) * (v3.xyz) + (r0.xyz);
    r3.xyz = normalize(r0.xyz);
    r13.xyz = (r8.www) * (v6.xyz);
    r9.w = saturate(dot(r3.xyz, -(r13.xyz)));
    r0.z = (r3.w) * (c4.z);
    r1.x = saturate(dot(r3.xyz, r7.xyz));
    r0.y = (r9.w) * (r4.z) + (r0.z);
    r16.xy = (r3.ww) * (c10.xy) + (c10.zw);
    r1.z = saturate(dot(r3.xyz, c[17].xyz));
    r1.y = exp2(r16.y);
    r0.z = (r1.z) * (r4.z) + (r0.z);
    r0.x = pow(abs(r1.x), r1.y);
    r0.z = (r0.z) * (r0.y) + (c9.x);
    r0.y = (r1.y) * (c9.y) + (c9.z);
    r0.z = 1.0f / (r0.z);
    r1.y = (r0.x) * (r0.y);
    r1.x = (r1.z) * (r0.z);
    r0.xyz = (r10.xyz) * (r7.www) + (r11.xyz);
    r1.y = (r1.y) * (r1.x);
    r12.xyz = lerp(r4.www, c[5].xyw, r6.www);
    r0.xyz = (r0.xyz) * (r1.yyy);
    r15.xyz = (r6.xyz) * (r12.yyy);
    r14.xyz = (r12.zzz) * (r0.xyz);
    r4 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r4.y)) >= 0.0f ? (-(c1.y)) : (-(c1.w)));
    r1.xyz = (r1.zzz) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r4.y;
        r4.w = r0.z;
    }
    else
    {
        if ((-(c1.y)) >= (v5.w))
        {
            r5 = (v5.xyzx) * (-(c1.yyyw));
            r4 = (r5) + (-(c12.xyzz));
            r4 = tex2Dlod(s2, r4);
            r4.w = r4.x;
            r6 = (r5) + (c11.xxyy);
            r6 = tex2Dlod(s2, r6);
            r4.x = r6.x;
            r6 = (r5) + (c11.zzyy);
            r6 = tex2Dlod(s2, r6);
            r4.y = r6.x;
            r5 = (r5) + (c12.xyzz);
            r5 = tex2Dlod(s2, r5);
            r4.z = r5.x;
            r0.z = dot(r4, c9.zzzz);
            if ((c9.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r4.xy = (r0.xy) + (c11.xx);
                r4.zw = (v5.zx) * (-(c1.yw));
                r4 = tex2Dlod(s2, r4);
                r5.xy = (r0.xy) + (c11.zz);
                r5.zw = (v5.zx) * (-(c1.yw));
                r7 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (c12.xy);
                r5.zw = (v5.zx) * (-(c1.yw));
                r6 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (-(c12.xy));
                r5.zw = (v5.zx) * (-(c1.yw));
                r5 = tex2Dlod(s2, r5);
                r4.y = r7.x;
                r4.z = r6.x;
                r4.w = r5.x;
                r0.y = dot(r4, c9.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c13.x) + (c13.y);
                r4.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r4.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c8.x));
            r0.z = ((r0.z) >= 0.0f ? (-(c1.w)) : (-(c1.y)));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r5.xy = (r0.xy) + (c11.xx);
                r5.zw = (v5.zz) * (-(c1.yw));
                r5 = tex2Dlod(s2, r5);
                r6.xy = (r0.xy) + (c11.zz);
                r6.zw = (v5.zz) * (-(c1.yw));
                r8 = tex2Dlod(s2, r6);
                r6.xy = (r0.xy) + (c12.xy);
                r6.zw = (v5.zz) * (-(c1.yw));
                r7 = tex2Dlod(s2, r6);
                r6.xy = (r0.xy) + (-(c12.xy));
                r6.zw = (v5.zz) * (-(c1.yw));
                r6 = tex2Dlod(s2, r6);
                r5.y = r8.x;
                r5.z = r7.x;
                r5.w = r6.x;
                r0.x = dot(r5, c9.zzzz);
                r0.z = saturate((v5.w) + (c11.w));
                r0.y = (r4.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r4.y;
            }
            r4.w = r0.z;
        }
    }
    r1.xyz = (r4.www) * (r1.xyz) + (r15.xyz);
    r5.xyz = (r14.xyz) * (c[19].xyz);
    r0.z = (-(r9.w)) + (-(c1.y));
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r13.xyz, r3.xyz);
    r4.z = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r3.w = (r3.w) * (c3.w);
    r3.xyz = (r3.xyz) * (-(r0.zzz)) + (r13.xyz);
    r3 = texCUBElod(s15, r3);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r12.xxx) * (r0.xyz);
    r4.xyz = (r10.xyz) * (r4.zzz) + (r11.xyz);
    r3.xyz = (r4.www) * (r5.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r1.xyz = (r2.xyz) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r9.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r1.z = (-(r2.w)) + (-(c1.y));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
    r0.w = (r0.w) * (-(v7.y)) + (-(c1.y));
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (r1.z) * (-(r0.w)) + (-(c1.y));
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[6].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
