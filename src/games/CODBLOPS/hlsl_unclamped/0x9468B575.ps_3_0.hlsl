// Mechanically reconstructed from 0x9468B575.ps_3_0.cso.
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
    float4 v8 : TEXCOORD6;
    float4 v9 : TEXCOORD7;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-1.0f, 1.0f, 0.0f, 8.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c12 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c13 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c34 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
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
    float4 r17 = 0.0f;
    float4 oC0 = 0.0f;

    r2 = tex2D(s1, v1.xy);
    r1 = tex2D(s0, v1.xy);
    r0 = tex2D(s4, v8.xy);
    r4.w = (r0.w) * (v0.y);
    r2.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r5.xyz = lerp(r1.xyz, r0.xyz, r4.www);
    r1 = tex2D(s7, v1.xy);
    r0 = tex2D(s8, v8.xy);
    r10.xy = (r4.ww) * (-(r2.xy)) + (r2.xy);
    r3.w = dot(r10.xy, r10.xy) + (c1.z);
    r2 = lerp(r1, r0, r4.wwww);
    r0.w = exp2(-(r3.w));
    r8.w = (r2.w) * (-(c34.z)) + (c34.w);
    r5.w = (r0.w) * (c3.x) + (c3.y);
    r0 = tex2D(s5, v8.zw);
    r0.xyz = (r0.xyz) + (c1.xxx);
    r6.xyz = (v0.zzz) * (r0.xyz) + (c1.yyy);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c4.xy);
    r3 = tex2D(s13, r1.xy);
    r0.w = r3.y;
    r1 = tex2D(s14, v1.zw);
    r7.xy = (r1.xy) * (c3.ww);
    r8.xy = (r0.wy) * (c34.xx) + (c34.yy);
    r3.xy = (r3.xz) * (r7.xx);
    r0.w = dot(r8.xy, r10.xy) + (c1.z);
    r0.y = (r1.x) * (c3.w) + (-(r3.x));
    r1.w = (r3.z) * (-(r7.x)) + (r0.y);
    r4.xy = (r0.xz) * (r7.yy);
    r0.y = (r1.y) * (c3.w) + (-(r4.x));
    r0.x = dot(r8.xy, r8.xy) + (c1.z);
    r0.y = (r0.z) * (-(r7.y)) + (r0.y);
    r0.z = exp2(-(r0.x));
    r8.y = (r1.w) + (r1.w);
    r0.z = (r0.z) * (c3.x) + (c3.y);
    r0.y = (r0.y) + (r0.y);
    r0.z = (r5.w) * (r0.z);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r0.xz = (r4.xy) * (c4.ww);
    r0.xyz = (r0.xyz) * (r0.www);
    r8.xz = (r3.xy) * (c4.ww);
    r4.xyz = (r2.xyz) * (r6.xyz);
    r1.xyz = (r8.xyz) * (r5.www) + (r0.xyz);
    r0 = tex2D(s6, v9.xy);
    r0.xyz = (r0.xyz) + (c1.xxx);
    r2.xyz = (r5.xyz) * (r6.xyz);
    r3.xyz = (v0.www) * (r0.xyz) + (c1.yyy);
    r0.xyz = (r4.xyz) * (r3.xyz);
    r3.xyz = (r2.xyz) * (r3.xyz);
    r0.w = dot(v7.xyz, v7.xyz);
    r2.xyz = (-(v7.xyz)) + (c[20].xyz);
    r9.w = rsqrt(r0.w);
    r0.w = dot(r2.xyz, r2.xyz);
    r0.w = rsqrt(r0.w);
    r14.xyz = (r9.www) * (v7.xyz);
    r7.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r2.xyz) * (r0.www) + (-(r14.xyz));
    r11.xyz = normalize(r3.xyz);
    r17.xyz = (r2.xyz) * (r0.www);
    r12.xyz = (r0.xyz) * (-(r0.xyz)) + (c1.yyy);
    r0.w = saturate(dot(r11.xyz, r17.xyz));
    r3.xyw = c[31].xyw;
    r2.xyz = (-(r3.xyw)) + (c[32].xyw);
    r0.w = (-(r0.w)) + (c1.y);
    r2.xyz = (r4.www) * (r2.xyz) + (c[31].xyw);
    r1.w = (r0.w) * (r0.w);
    r16.xyz = (r1.xyz) * (r2.yyy);
    r1.w = (r1.w) * (r1.w);
    r0.w = (r0.w) * (r1.w);
    r13.xyz = (r0.xyz) * (r0.xyz);
    r9.xyz = (r12.xyz) * (r0.www) + (r13.xyz);
    r2.y = dot(r17.xyz, c[29].xyz);
    r1 = tex2D(s12, v1.zw);
    r0 = v2;
    r0.xyz = (r10.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r10.yyy) * (v4.xyz) + (r0.xyz);
    r10.xyz = normalize(r0.xyz);
    r7.w = saturate(dot(r10.xyz, c[17].xyz));
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c1.y) : (c1.z));
    r15.xyz = (r7.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r4.w = r0.z;
    }
    else
    {
        if ((c1.y) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c1.yyyz);
            r1 = (r3) + (-(c15.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r4 = (r3) + (c13.xxyy);
            r4 = tex2Dlod(s2, r4);
            r1.x = r4.x;
            r4 = (r3) + (c13.zzyy);
            r4 = tex2Dlod(s2, r4);
            r1.y = r4.x;
            r3 = (r3) + (c15.xyzz);
            r3 = tex2Dlod(s2, r3);
            r1.z = r3.x;
            r0.z = dot(r1, c12.zzzz);
            if ((c12.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c13.xx);
                r1.zw = (v6.zx) * (c1.yz);
                r1 = tex2Dlod(s2, r1);
                r3.xy = (r0.xy) + (c13.zz);
                r3.zw = (v6.zx) * (c1.yz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c15.xy);
                r3.zw = (v6.zx) * (c1.yz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c15.xy));
                r3.zw = (v6.zx) * (c1.yz);
                r3 = tex2Dlod(s2, r3);
                r1.y = r5.x;
                r1.z = r4.x;
                r1.w = r3.x;
                r0.y = dot(r1, c12.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v6.w) * (c14.x) + (c14.y);
                r4.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r4.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c4.w));
            r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c13.xx);
                r3.zw = (v6.zz) * (c1.yz);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c13.zz);
                r4.zw = (v6.zz) * (c1.yz);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c15.xy);
                r4.zw = (v6.zz) * (c1.yz);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c15.xy));
                r4.zw = (v6.zz) * (c1.yz);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c12.zzzz);
                r0.z = saturate((v6.w) + (c13.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
            r4.w = r0.z;
        }
    }
    r6.z = (r2.w) * (c3.z);
    r3.w = saturate(dot(r17.xyz, r10.xyz));
    r3.xyz = (r4.www) * (r15.xyz) + (r16.xyz);
    r1.w = (r3.w) * (r8.w) + (r6.z);
    r1.xyz = (v7.xyz) * (-(r9.www)) + (c[17].xyz);
    r4.z = saturate(dot(r10.xyz, -(r14.xyz)));
    r0.xyz = normalize(r1.xyz);
    r6.w = (r4.z) * (r8.w) + (r6.z);
    r1.z = saturate(dot(r0.xyz, c[17].xyz));
    r1.w = (r1.w) * (r6.w) + (c12.x);
    r1.w = 1.0f / (r1.w);
    r1.z = (-(r1.z)) + (c1.y);
    r5.w = (r3.w) * (r1.w);
    r1.w = (r1.z) * (r1.z);
    r1.y = (r1.w) * (r1.w);
    r1.w = dot(r14.xyz, r10.xyz);
    r5.z = (r1.z) * (r1.y);
    r1.z = (r1.w) + (r1.w);
    r1.w = (r2.w) * (c1.w);
    r1.xyz = (r10.xyz) * (-(r1.zzz)) + (r14.xyz);
    r1 = texCUBElod(s15, r1);
    r1.w = (-(r4.z)) + (c1.y);
    r4.z = (r1.w) * (r1.w);
    r5.xy = (r2.ww) * (c16.xy) + (c16.zw);
    r1.w = (r1.w) * (r4.z);
    r2.w = 1.0f / (r5.x);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r2.w);
    r1.xyz = (r2.xxx) * (r1.xyz);
    r4.xyz = (r12.xyz) * (r1.www) + (r13.xyz);
    r1.xyz = (r1.xyz) * (r4.xyz);
    r4.y = exp2(r5.y);
    r1.w = (r4.y) * (c12.y) + (c12.z);
    r2.w = (r7.w) * (r8.w) + (r6.z);
    r2.x = (r2.w) * (r6.w) + (c12.x);
    r2.w = saturate(dot(r10.xyz, r0.xyz));
    r0.y = 1.0f / (r2.x);
    r0.z = pow(abs(r2.w), r4.y);
    r0.y = (r7.w) * (r0.y);
    r0.z = (r1.w) * (r0.z);
    r2.w = (r0.y) * (r0.z);
    r0.xyz = (r12.xyz) * (r5.zzz) + (r13.xyz);
    r4.z = saturate(dot(r10.xyz, r11.xyz));
    r0.xyz = (r2.www) * (r0.xyz);
    r2.w = pow(abs(r4.z), r4.y);
    r0.xyz = (r2.zzz) * (r0.xyz);
    r1.w = (r1.w) * (r2.w);
    r0.xyz = (r0.xyz) * (c[19].xyz);
    r1.w = (r5.w) * (r1.w);
    r4.xyz = (r4.www) * (r0.xyz);
    r0.xyz = (r9.xyz) * (r1.www);
    r3.xyz = (r7.xyz) * (r3.xyz) + (r4.xyz);
    r1.xyz = (r8.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[22].xyz);
    r9.xyz = (r1.xyz) * (c1.www) + (r3.xyz);
    r1.xyz = (r2.zzz) * (r0.xyz);
    r0.xyz = (r3.www) * (c[21].xyz);
    r1.w = saturate((r2.y) * (c[30].x) + (c[30].y));
    r8.xyz = (r7.xyz) * (r0.xyz) + (r1.xyz);
    r0.y = (r1.w) * (c14.z) + (c14.w);
    r0.z = (r1.w) * (r1.w);
    r1 = (v7.xyzx) * (c1.yyyz) + (c1.zzzy);
    r2.w = (r0.y) * (r0.z);
    r0.z = dot(r1, c[28]);
    r2.z = 1.0f / (r0.z);
    r2.x = dot(r1, c[27]);
    r0.x = dot(r1, c[25]);
    r2.y = (r2.x) * (r2.x);
    r0.y = dot(r1, c[26]);
    r0.z = dot(c[23].yz, r2.xy) + (c[23].x);
    r1.w = saturate(1.0f / (r0.z));
    r1.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r1.xy) * (c14.zz) + (c14.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.z) : (r1.w));
    r1.w = (r2.x) * (r1.x);
    r0.z = (r0.z) * (r1.w);
    r1.w = (r1.y) * (-(r2.y)) + (c1.y);
    r0.xy = (r2.zz) * (r0.xy);
    r0.z = (r0.z) * (r1.w);
    r7.w = (r2.w) * (r0.z);
    r0.xy = (r0.xy) * (c4.yy) + (c4.yy);
    r6 = tex2D(s3, r0.xy);
    r4 = (-(v7.yyyy)) + (c[6]);
    r3 = (-(v7.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v7.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = (r6.xyz) * (r6.xyz);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r3.z = c1.y;
    r1 = saturate((r1) * (c[8]) + (r3.zzzz));
    r0.xyz = (r7.www) * (r0.xyz);
    r1 = (r2) * (r1);
    r2.xyz = (r0.xyz) * (r8.xyz) + (r9.xyz);
    r0.z = dot(c[11], r1);
    r0.x = dot(c[9], r1);
    r0.y = dot(c[10], r1);
    r0.xyz = (r7.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[33].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.y;

    return oC0;
}
