// Mechanically reconstructed from 0xA8F0D7C7.ps_3_0.cso.
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
    const float4 c1 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c12 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c15 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c16 = float4(-1.0f, 1.0f, 0.200000003f, 0.0f);
    const float4 c25 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s1, v1.xy);
    r8.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1 = tex2D(s7, v1.xy);
    r0 = tex2D(s4, v8.xy);
    r0.xyz = (r0.xyz) + (c16.xxx);
    r6.xyz = (v0.yyy) * (r0.xyz) + (c16.yyy);
    r0 = tex2D(s5, v8.zw);
    r2.xyz = (r0.xyz) + (c16.xxx);
    r0.xyz = (r6.xyz) * (c16.zzz);
    r4.xyz = (v0.zzz) * (r2.xyz) + (c16.yyy);
    r5.xyz = (r0.xyz) * (r4.xyz);
    r0 = tex2D(s6, v9.xy);
    r2.xyz = (r0.xyz) + (c16.xxx);
    r0.w = dot(v7.xyz, v7.xyz);
    r0.xyz = (-(v7.xyz)) + (c[5].xyz);
    r1.x = rsqrt(r0.w);
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r14.xyz = (r1.xxx) * (v7.xyz);
    r3.xyz = (v0.www) * (r2.xyz) + (c16.yyy);
    r7.xyz = (r0.xyz) * (r0.www) + (-(r14.xyz));
    r2.xyz = normalize(r7.xyz);
    r10.xyz = (r0.xyz) * (r0.www);
    r5.xyz = (r5.xyz) * (r3.xyz);
    r0.w = saturate(dot(r2.xyz, r10.xyz));
    r11.xyz = (r5.xyz) * (-(r5.xyz)) + (c16.yyy);
    r1.z = (-(r0.w)) + (c16.y);
    r11.w = (r1.w) * (-(c4.z)) + (c4.w);
    r0.w = (r1.z) * (r1.z);
    r2.w = (r0.w) * (r0.w);
    r0 = v2;
    r0.xyz = (r8.xxx) * (v5.xyz) + (r0.xyz);
    r4.w = (r1.z) * (r2.w);
    r0.xyz = (r8.yyy) * (v4.xyz) + (r0.xyz);
    r12.xyz = (r5.xyz) * (r5.xyz);
    r13.xyz = normalize(r0.xyz);
    r2.w = saturate(dot(r13.xyz, r2.xyz));
    r12.w = (r1.w) * (c1.w);
    r3.w = saturate(dot(r10.xyz, r13.xyz));
    r1.z = saturate(dot(r13.xyz, -(r14.xyz)));
    r0.z = (r3.w) * (r11.w) + (r12.w);
    r10.w = (r1.z) * (r11.w) + (r12.w);
    r0.z = (r0.z) * (r10.w) + (c12.x);
    r17.xy = (r1.ww) * (c25.xy) + (c25.zw);
    r0.y = 1.0f / (r0.z);
    r9.w = exp2(r17.y);
    r0.z = pow(abs(r2.w), r9.w);
    r7.w = (r9.w) * (c12.y) + (c12.z);
    r2.z = (r3.w) * (r0.y);
    r2.w = (r0.z) * (r7.w);
    r0.xyz = (r11.xyz) * (r4.www) + (r12.xyz);
    r2.w = (r2.z) * (r2.w);
    r5.xyz = (r0.xyz) * (r2.www);
    r2 = tex2D(s0, v1.xy);
    r0.xyz = (r6.xyz) * (r2.xyz);
    r2.xyz = (r5.xyz) * (c[7].xyz);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r6.xyz = (r1.yyy) * (r2.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r9.xyz = (r0.xyz) * (r0.xyz);
    r0.z = dot(r8.xy, r8.xy) + (c16.w);
    r5.xyz = (r3.www) * (c[6].xyz);
    r0.z = exp2(-(r0.z));
    r5.w = (r0.z) * (c1.x) + (c1.y);
    r0.xy = (v1.zw) * (c3.xy);
    r4 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r2 = tex2D(s13, r0.xy);
    r4.w = r2.y;
    r3 = tex2D(s14, v1.zw);
    r0.xy = (r3.xy) * (c3.ww);
    r7.xy = (r4.yw) * (c4.xx) + (c4.yy);
    r4.xy = (r4.xz) * (r0.xx);
    r0.z = dot(r7.xy, r8.xy) + (c16.w);
    r2.w = (r3.x) * (c3.w) + (-(r4.x));
    r2.w = (r4.z) * (-(r0.x)) + (r2.w);
    r2.xy = (r2.xz) * (r0.yy);
    r3.w = (r3.y) * (c3.w) + (-(r2.x));
    r0.x = dot(r7.xy, r7.xy) + (c16.w);
    r0.y = (r2.z) * (-(r0.y)) + (r3.w);
    r0.x = exp2(-(r0.x));
    r8.y = (r2.w) + (r2.w);
    r0.x = (r0.x) * (c1.x) + (c1.y);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r5.w) * (r0.x);
    r2.w = saturate((r0.z) * (r0.x) + (r0.x));
    r0.xz = (r2.xy) * (c4.xx);
    r0.xyz = (r0.xyz) * (r2.www);
    r8.xz = (r4.xy) * (c4.xx);
    r7.xyz = (r9.xyz) * (r5.xyz) + (r6.xyz);
    r0.xyz = (r8.xyz) * (r5.www) + (r0.xyz);
    r16.xyz = (r1.yyy) * (r0.xyz);
    r8.w = saturate(dot(r13.xyz, c[17].xyz));
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c16.y) : (c16.w));
    r15.xyz = (r8.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r3.w = r0.z;
    }
    else
    {
        if ((c16.y) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c16.yyyw);
            r2 = (r3) + (-(c13.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c15.xxyy);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (c15.zzyy);
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c13.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c12.zzzz);
            if ((c12.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c15.xx);
                r2.zw = (v6.zx) * (c16.yw);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c15.zz);
                r3.zw = (v6.zx) * (c16.yw);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c13.xy);
                r3.zw = (v6.zx) * (c16.yw);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c13.xy));
                r3.zw = (v6.zx) * (c16.yw);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c12.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v6.w) * (c14.x) + (c14.y);
                r3.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r3.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c4.x));
            r0.z = ((r0.z) >= 0.0f ? (c16.w) : (c16.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c15.xx);
                r3.zw = (v6.zz) * (c16.yw);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c15.zz);
                r4.zw = (v6.zz) * (c16.yw);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c13.xy);
                r4.zw = (v6.zz) * (c16.yw);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c13.xy));
                r4.zw = (v6.zz) * (c16.yw);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c12.zzzz);
                r0.z = saturate((v6.w) + (c15.w));
                r0.y = (r2.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r2.y;
            }
            r3.w = r0.z;
        }
    }
    r0.xyz = (v7.xyz) * (-(r1.xxx)) + (c[17].xyz);
    r4.xyz = normalize(r0.xyz);
    r0.z = saturate(dot(r4.xyz, c[17].xyz));
    r0.z = (-(r0.z)) + (c16.y);
    r0.y = (r0.z) * (r0.z);
    r3.xyz = (r3.www) * (r15.xyz) + (r16.xyz);
    r0.y = (r0.y) * (r0.y);
    r1.x = (r0.z) * (r0.y);
    r0.z = (-(r1.z)) + (c16.y);
    r0.x = 1.0f / (r17.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r14.xyz, r13.xyz);
    r1.z = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r1.w) * (c1.z);
    r2.xyz = (r13.xyz) * (-(r0.zzz)) + (r14.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r8.w) * (r11.w) + (r12.w);
    r1.w = (r1.w) * (r10.w) + (c12.x);
    r2.z = saturate(dot(r13.xyz, r4.xyz));
    r2.w = 1.0f / (r1.w);
    r1.w = pow(abs(r2.z), r9.w);
    r2.w = (r8.w) * (r2.w);
    r1.w = (r7.w) * (r1.w);
    r1.w = (r2.w) * (r1.w);
    r2.xyz = (r11.xyz) * (r1.xxx) + (r12.xyz);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r4.xyz = (r1.www) * (r2.xyz);
    r2.xyz = (r11.xyz) * (r1.zzz) + (r12.xyz);
    r1.xyz = (r1.yyy) * (r4.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (c[19].xyz);
    r1.xyz = (r3.www) * (r1.xyz);
    r1.w = dot(r10.xyz, c[22].xyz);
    r3.xyz = (r9.xyz) * (r3.xyz) + (r1.xyz);
    r1.w = saturate((r1.w) * (c[23].x) + (c[23].y));
    r2.xyz = (r8.xyz) * (r0.xyz);
    r0.y = (r1.w) * (c14.z) + (c14.w);
    r0.z = (r1.w) * (r1.w);
    r1 = (v7.xyzx) * (c16.yyyw) + (c16.wwwy);
    r2.w = (r0.y) * (r0.z);
    r0.z = dot(r1, c[21]);
    r3.w = 1.0f / (r0.z);
    r4.x = dot(r1, c[20]);
    r0.x = dot(r1, c[10]);
    r4.y = (r4.x) * (r4.x);
    r0.y = dot(r1, c[11]);
    r0.z = dot(c[8].yz, r4.xy) + (c[8].x);
    r1.w = saturate(1.0f / (r0.z));
    r1.xy = saturate((r4.xx) * (c[9].xy) + (c[9].zw));
    r4.xy = (r1.xy) * (c14.zz) + (c14.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c16.w) : (r1.w));
    r1.w = (r4.x) * (r1.x);
    r0.z = (r0.z) * (r1.w);
    r1.w = (r1.y) * (-(r4.y)) + (c16.y);
    r0.xy = (r3.ww) * (r0.xy);
    r0.z = (r0.z) * (r1.w);
    r2.w = (r2.w) * (r0.z);
    r0.xy = (r0.xy) * (c3.yy) + (c3.yy);
    r1 = tex2D(s3, r0.xy);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r2.xyz) * (c1.zzz) + (r3.xyz);
    r0.xyz = (r2.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r7.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c16.y;

    return oC0;
}
