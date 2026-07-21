// Mechanically reconstructed from 0xCF966D32.ps_3_0.cso.
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
sampler2D s7 : register(s7);
sampler2D s8 : register(s8);
sampler2D s9 : register(s9);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD4;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
    float4 v8 : TEXCOORD7;
    float4 v9 : COLOR1;
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
    float4 v9 = input.v9;
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(2.0f, -1.0f, 0.0f, -0.200000003f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c11 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c12 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c15 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c16 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c20 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0 = tex2D(s6, v7.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c3.xxxx) * (v9) + (c3.yyyy);
    r2.y = dot(r1.xy, r0.zw) + (c3.z);
    r2.x = dot(r1.xy, r0.xy) + (c3.z);
    r0 = tex2D(s1, v1.xy);
    r4.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r1 = tex2D(s0, v1.xy);
    r0 = tex2D(s3, v7.xy);
    r4.w = (r0.w) * (v0.y);
    r3.xyz = lerp(r1.xyz, r0.xyz, r4.www);
    r5.xy = lerp(r4.xy, r2.xy, r4.ww);
    r2 = tex2D(s7, v1.xy);
    r0 = tex2D(s8, v7.xy);
    r0.z = dot(v6.xyz, v6.xyz);
    r9.w = rsqrt(r0.z);
    r4.xyz = (v6.xyz) * (-(r9.www)) + (c[17].xyz);
    r1.xyz = normalize(r4.xyz);
    r0.z = saturate(dot(r1.xyz, c[17].xyz));
    r0.z = (-(r0.z)) + (-(c3.y));
    r0.x = (r0.z) * (r0.z);
    r3.w = lerp(r2.y, r0.y, r4.w);
    r0.y = (r0.x) * (r0.x);
    r1.w = lerp(r2.w, r0.w, r4.w);
    r6.w = (r0.z) * (r0.y);
    r0 = tex2D(s4, v7.zw);
    r7.z = (r0.w) * (v0.z);
    r10.xyz = lerp(r3.xyz, r0.xyz, r7.zzz);
    r0.xy = (v1.zw) * (c11.xy) + (c11.zy);
    r0 = tex2D(s13, r0.xy);
    r2.xy = (v1.zw) * (c11.xy);
    r2 = tex2D(s13, r2.xy);
    r0.w = r2.y;
    r4.xy = (r7.zz) * (-(r5.xy)) + (r5.xy);
    r3.xy = (r0.wy) * (c12.xx) + (c12.yy);
    r0.w = dot(r4.xy, r4.xy) + (c3.z);
    r0.y = dot(r3.xy, r3.xy) + (c3.z);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c4.x) + (c4.y);
    r2.w = (r0.y) * (c4.x) + (c4.y);
    r0.y = dot(r3.xy, r4.xy) + (c3.z);
    r2.w = (r0.w) * (r2.w);
    r8.xyz = lerp(r3.www, c[8].xyw, r7.zzz);
    r2.w = saturate((r0.y) * (r2.w) + (r2.w));
    r3 = tex2D(s14, v1.zw);
    r6.xy = (r3.xy) * (c11.ww);
    r5.xy = (r2.xz) * (r6.xx);
    r2.xy = (r0.xz) * (r6.yy);
    r0.x = (r3.x) * (c11.w) + (-(r5.x));
    r0.y = (r3.y) * (c11.w) + (-(r2.x));
    r2.z = (r2.z) * (-(r6.x)) + (r0.x);
    r0.z = (r0.z) * (-(r6.y)) + (r0.y);
    r0.y = (r0.z) + (r0.z);
    r0.xz = (r2.xy) * (c12.xx);
    r6.y = (r2.z) + (r2.z);
    r2.xyz = (r2.www) * (r0.xyz);
    r6.xz = (r5.xy) * (c12.xx);
    r0.xyz = v2.xyz;
    r0.xyz = (r4.xxx) * (v4.xyz) + (r0.xyz);
    r2.xyz = (r6.xyz) * (r0.www) + (r2.xyz);
    r0.xyz = (r4.yyy) * (v3.xyz) + (r0.xyz);
    r12.xyz = (r8.yyy) * (r2.xyz);
    r9.xyz = normalize(r0.xyz);
    r8.w = saturate(dot(r9.xyz, r1.xyz));
    r7.w = saturate(dot(r9.xyz, c[17].xyz));
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (-(c3.y)) : (-(c3.z)));
    r11.xyz = (r7.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r3.w = r0.w;
    }
    else
    {
        if ((-(c3.y)) >= (v5.w))
        {
            r2 = (v5.xyzx) * (-(c3.yyyz));
            r0 = (r2) + (-(c16.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r3 = (r2) + (c15.xxyy);
            r3 = tex2Dlod(s2, r3);
            r0.x = r3.x;
            r3 = (r2) + (c15.zzyy);
            r3 = tex2Dlod(s2, r3);
            r0.y = r3.x;
            r2 = (r2) + (c16.xyzz);
            r2 = tex2Dlod(s2, r2);
            r0.z = r2.x;
            r1.z = dot(r0, c13.zzzz);
            if ((c13.w) < (v5.w))
            {
                r1.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r1.xy) + (c15.xx);
                r0.zw = (v5.zx) * (-(c3.yz));
                r0 = tex2Dlod(s2, r0);
                r2.xy = (r1.xy) + (c15.zz);
                r2.zw = (v5.zx) * (-(c3.yz));
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r1.xy) + (c16.xy);
                r2.zw = (v5.zx) * (-(c3.yz));
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r1.xy) + (-(c16.xy));
                r2.zw = (v5.zx) * (-(c3.yz));
                r2 = tex2Dlod(s2, r2);
                r0.y = r4.x;
                r0.z = r3.x;
                r0.w = r2.x;
                r0.w = dot(r0, c13.zzzz);
                r0.z = (-(r1.z)) + (r0.w);
                r0.w = (v5.w) * (c20.x) + (c20.y);
                r3.w = (r0.w) * (r0.z) + (r1.z);
            }
            else
            {
                r3.w = r1.z;
            }
        }
        else
        {
            r0.w = (v5.w) + (-(c12.x));
            r0.w = ((r0.w) >= 0.0f ? (-(c3.z)) : (-(c3.y)));
            if ((r0.w) != (-(r0.w)))
            {
                r1.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r1.xy) + (c15.xx);
                r2.zw = (v5.zz) * (-(c3.yz));
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r1.xy) + (c15.zz);
                r3.zw = (v5.zz) * (-(c3.yz));
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r1.xy) + (c16.xy);
                r3.zw = (v5.zz) * (-(c3.yz));
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r1.xy) + (-(c16.xy));
                r3.zw = (v5.zz) * (-(c3.yz));
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c13.zzzz);
                r0.w = saturate((v5.w) + (c15.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r3.w = r0.w;
        }
    }
    r2.w = -(r1.w);
    r2.xyz = c3.www;
    r0 = tex2D(s9, v7.zw);
    r0 = (r2) + (r0);
    r1.xyz = -(c3.www);
    r2 = tex2D(s5, v8.xy);
    r2.xyz = (r2.xyz) + (c3.yyy);
    r0 = (r7.zzzz) * (r0) + (r1);
    r2.xyz = (v0.www) * (r2.xyz) + (-(c3.yyy));
    r0.xyz = (r0.xyz) * (r2.xyz);
    r1.xyz = (r0.xyz) * (-(r0.xyz)) + (-(c3.yyy));
    r7.xyz = (r0.xyz) * (r0.xyz);
    r0.y = (r0.w) * (-(c12.z)) + (c12.w);
    r13.xy = (r0.ww) * (c14.xy) + (c14.zw);
    r2.w = exp2(r13.y);
    r3.xyz = (r9.www) * (v6.xyz);
    r0.x = (r0.w) * (c4.w);
    r1.w = saturate(dot(r9.xyz, -(r3.xyz)));
    r0.z = (r7.w) * (r0.y) + (r0.x);
    r0.y = (r1.w) * (r0.y) + (r0.x);
    r0.x = pow(abs(r8.w), r2.w);
    r0.z = (r0.z) * (r0.y) + (c13.x);
    r0.y = (r2.w) * (c13.y) + (c13.z);
    r0.z = 1.0f / (r0.z);
    r2.w = (r0.x) * (r0.y);
    r4.w = (r7.w) * (r0.z);
    r0.xyz = (r1.xyz) * (r6.www) + (r7.xyz);
    r2.w = (r2.w) * (r4.w);
    r4.xyz = (r3.www) * (r11.xyz) + (r12.xyz);
    r0.xyz = (r0.xyz) * (r2.www);
    r2.xyz = (r10.xyz) * (r2.xyz);
    r0.xyz = (r8.zzz) * (r0.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (c[19].xyz);
    r5.xyz = (r3.www) * (r0.xyz);
    r0.z = (-(r1.w)) + (-(c3.y));
    r0.x = 1.0f / (r13.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r3.xyz, r9.xyz);
    r1.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r0.w = (r0.w) * (c4.z);
    r0.xyz = (r9.xyz) * (-(r0.zzz)) + (r3.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r8.xxx) * (r0.xyz);
    r1.xyz = (r1.xyz) * (r1.www) + (r7.xyz);
    r2.xyz = (r2.xyz) * (r4.xyz) + (r5.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.xyz = (r6.xyz) * (r0.xyz);
    r0.w = dot(c[5].xyz, r3.xyz);
    r0.w = saturate((c[7].y) * (r0.w) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r1.xyz) * (c4.zzz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[9].w;

    return oC0;
}
