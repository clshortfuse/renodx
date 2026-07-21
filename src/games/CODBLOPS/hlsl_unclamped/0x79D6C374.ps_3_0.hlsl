// Mechanically reconstructed from 0x79D6C374.ps_3_0.cso.
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
    const float4 c12 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c30 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s6, v7.zw);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c1.xxxx) * (v8) + (c1.yyyy);
    r2.y = dot(r1.xy, r0.zw) + (c1.w);
    r2.x = dot(r1.xy, r0.xy) + (c1.w);
    r1 = tex2D(s1, v0.xy);
    r0 = tex2D(s0, v0.xy);
    r5.w = (r0.w) * (v7.x) + (c1.z);
    r0 = (r0.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r3.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1 = float4(((r5.w) >= 0.0f ? (r0.x) : (c1.w)), ((r5.w) >= 0.0f ? (r0.y) : (c1.w)), ((r5.w) >= 0.0f ? (r0.z) : (c1.w)), ((r5.w) >= 0.0f ? (r0.w) : (c1.w)));
    r4 = tex2D(s7, v0.xy);
    r3.zw = (r4.ww) * (c3.xy) + (c3.zx);
    r0 = tex2D(s5, v7.zw);
    r4.w = (r0.w) * (v7.y) + (c1.z);
    r0 = (r0.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r3 = float4(((r5.w) >= 0.0f ? (r3.x) : (-(c1.w))), ((r5.w) >= 0.0f ? (r3.y) : (-(c1.w))), ((r5.w) >= 0.0f ? (r3.z) : (-(c1.w))), ((r5.w) >= 0.0f ? (r3.w) : (-(c1.y))));
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (r1.x)), ((r4.w) >= 0.0f ? (r0.y) : (r1.y)), ((r4.w) >= 0.0f ? (r0.z) : (r1.z)), ((r4.w) >= 0.0f ? (r0.w) : (r1.w)));
    r1 = tex2D(s8, v7.zw);
    r2.zw = (r1.ww) * (c3.xy) + (c3.zx);
    r1.w = ((r5.w) >= 0.0f ? (r4.y) : (c1.w));
    r2 = float4(((r4.w) >= 0.0f ? (r2.x) : (r3.x)), ((r4.w) >= 0.0f ? (r2.y) : (r3.y)), ((r4.w) >= 0.0f ? (r2.z) : (r3.z)), ((r4.w) >= 0.0f ? (r2.w) : (r3.w)));
    r10.w = ((r4.w) >= 0.0f ? (r1.y) : (r1.w));
    r11.xyz = (r0.xyz) * (r0.xyz);
    r11.w = (r2.z) * (-(r2.z)) + (-(c1.y));
    r0.z = dot(v6.xyz, v6.xyz);
    r1.xyz = (-(v6.xyz)) + (c[5].xyz);
    r6.w = rsqrt(r0.z);
    r0.z = dot(r1.xyz, r1.xyz);
    r1.w = rsqrt(r0.z);
    r10.xyz = (r6.www) * (v6.xyz);
    r3.w = dot(r2.xy, r2.xy) + (c1.w);
    r3.xyz = (r1.xyz) * (r1.www) + (-(r10.xyz));
    r0.xyz = normalize(r3.xyz);
    r3.xyz = (r1.xyz) * (r1.www);
    r12.w = (r2.z) * (r2.z);
    r2.z = saturate(dot(r0.xyz, r3.xyz));
    r1 = v1;
    r1.xyz = (r2.xxx) * (v4.xyz) + (r1.xyz);
    r2.z = (-(r2.z)) + (-(c1.y));
    r1.xyz = (r2.yyy) * (v3.xyz) + (r1.xyz);
    r4.w = (r2.z) * (r2.z);
    r9.xyz = normalize(r1.xyz);
    r1.z = (r4.w) * (r4.w);
    r1.y = saturate(dot(r9.xyz, r0.xyz));
    r0.x = (r2.z) * (r1.z);
    r14.z = (r2.w) * (-(c12.z)) + (c12.w);
    r14.y = (r2.w) * (c4.z);
    r1.z = saturate(dot(r3.xyz, r9.xyz));
    r13.w = saturate(dot(r9.xyz, -(r10.xyz)));
    r0.z = (r1.z) * (r14.z) + (r14.y);
    r14.w = (r13.w) * (r14.z) + (r14.y);
    r0.z = (r0.z) * (r14.w) + (c13.x);
    r13.xy = (r2.ww) * (c30.xy) + (c30.zw);
    r0.y = 1.0f / (r0.z);
    r13.z = exp2(r13.y);
    r0.z = pow(abs(r1.y), r13.z);
    r8.w = (r13.z) * (c13.y) + (c13.z);
    r0.y = (r1.z) * (r0.y);
    r0.z = (r0.z) * (r8.w);
    r0.x = (r11.w) * (r0.x) + (r12.w);
    r0.z = (r0.y) * (r0.z);
    r0.y = exp2(-(r3.w));
    r0.z = (r0.x) * (r0.z);
    r2.z = (r0.y) * (c4.x) + (c4.y);
    r0.xyz = (r0.zzz) * (c[7].xyz);
    r9.w = dot(r3.xyz, c[22].xyz);
    r6.xyz = (r10.www) * (r0.xyz);
    r1.xyz = (r1.zzz) * (c[6].xyz);
    r0.xy = (v0.zw) * (-(c1.yz));
    r5 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (-(c1.yz)) + (-(c1.wz));
    r3 = tex2D(s13, r0.xy);
    r5.w = r3.y;
    r4 = tex2D(s14, v0.zw);
    r0.xy = (r4.xy) * (c4.ww);
    r7.xy = (r5.yw) * (c12.xx) + (c12.yy);
    r5.xy = (r5.xz) * (r0.xx);
    r0.z = dot(r7.xy, r2.xy) + (c1.w);
    r2.y = (r4.x) * (c4.w) + (-(r5.x));
    r3.w = (r5.z) * (-(r0.x)) + (r2.y);
    r2.xy = (r3.xz) * (r0.yy);
    r3.y = (r4.y) * (c4.w) + (-(r2.x));
    r0.x = dot(r7.xy, r7.xy) + (c1.w);
    r0.y = (r3.z) * (-(r0.y)) + (r3.y);
    r0.x = exp2(-(r0.x));
    r8.y = (r3.w) + (r3.w);
    r0.x = (r0.x) * (c4.x) + (c4.y);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r2.z) * (r0.x);
    r3.w = saturate((r0.z) * (r0.x) + (r0.x));
    r0.xz = (r2.xy) * (c12.xx);
    r0.xyz = (r0.xyz) * (r3.www);
    r8.xz = (r5.xy) * (c12.xx);
    r1.xyz = (r11.xyz) * (r1.xyz) + (r6.xyz);
    r0.xyz = (r8.xyz) * (r2.zzz) + (r0.xyz);
    r12.xyz = (r10.www) * (r0.xyz);
    r2.xyz = (v6.xyz) * (-(r6.www)) + (c[17].xyz);
    r0.xyz = normalize(r2.xyz);
    r3 = (v6.yyyy) * (c[25]);
    r2.z = saturate(dot(r0.xyz, c[17].xyz));
    r3 = (v6.xxxx) * (c[24]) + (r3);
    r2.z = (-(r2.z)) + (-(c1.y));
    r3 = (v6.zzzz) * (c[26]) + (r3);
    r2.y = (r2.z) * (r2.z);
    r6 = (r3) + (c[27]);
    r2.y = (r2.y) * (r2.y);
    r5.zw = r6.zw;
    r2.z = (r2.z) * (r2.y);
    r7.zw = r5.zw;
    r2.y = (r11.w) * (r2.z) + (r12.w);
    r4.zw = r7.zw;
    r3.xy = (r6.ww) * (-(c[28].zw)) + (r6.xy);
    r3.zw = r4.zw;
    r3 = tex2Dproj(s3, r3);
    r3.w = r3.x;
    r7.xy = (r5.ww) * (-(c[28].xy)) + (r6.xy);
    r7 = tex2Dproj(s3, r7);
    r3.y = r7.x;
    r5.xy = (r5.ww) * (c[28].xy) + (r6.xy);
    r7 = tex2Dproj(s3, r5);
    r3.x = r7.x;
    r4.xy = (r5.ww) * (c[28].zw) + (r6.xy);
    r4 = tex2Dproj(s3, r4);
    r2.z = saturate(dot(r9.xyz, c[17].xyz));
    r3.z = (r2.z) * (r14.z) + (r14.y);
    r2.x = saturate(dot(r9.xyz, r0.xyz));
    r0.y = (r3.z) * (r14.w) + (c13.x);
    r0.z = pow(abs(r2.x), r13.z);
    r0.y = 1.0f / (r0.y);
    r0.z = (r8.w) * (r0.z);
    r0.y = (r2.z) * (r0.y);
    r0.z = (r0.z) * (r0.y);
    r3.z = r4.x;
    r0.z = (r2.y) * (r0.z);
    r8.w = dot(r3, c13.zzzz);
    r13.z = (r10.w) * (r0.z);
    r3 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r3.y)) >= 0.0f ? (-(c1.y)) : (-(c1.w)));
    r2.xyz = (r2.zzz) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r3.y;
        r3.w = r0.z;
    }
    else
    {
        if ((-(c1.y)) >= (v5.w))
        {
            r4 = (v5.xyzx) * (-(c1.yyyw));
            r3 = (r4) + (-(c15.xyzz));
            r3 = tex2Dlod(s2, r3);
            r3.w = r3.x;
            r5 = (r4) + (c14.xxyy);
            r5 = tex2Dlod(s2, r5);
            r3.x = r5.x;
            r5 = (r4) + (c14.zzyy);
            r5 = tex2Dlod(s2, r5);
            r3.y = r5.x;
            r4 = (r4) + (c15.xyzz);
            r4 = tex2Dlod(s2, r4);
            r3.z = r4.x;
            r0.z = dot(r3, c13.zzzz);
            if ((c13.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c14.xx);
                r3.zw = (v5.zx) * (-(c1.yw));
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c14.zz);
                r4.zw = (v5.zx) * (-(c1.yw));
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c15.xy);
                r4.zw = (v5.zx) * (-(c1.yw));
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c15.xy));
                r4.zw = (v5.zx) * (-(c1.yw));
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.y = dot(r3, c13.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c16.x) + (c16.y);
                r3.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r3.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c12.x));
            r0.z = ((r0.z) >= 0.0f ? (-(c1.w)) : (-(c1.y)));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r4.xy = (r0.xy) + (c14.xx);
                r4.zw = (v5.zz) * (-(c1.yw));
                r4 = tex2Dlod(s2, r4);
                r5.xy = (r0.xy) + (c14.zz);
                r5.zw = (v5.zz) * (-(c1.yw));
                r7 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (c15.xy);
                r5.zw = (v5.zz) * (-(c1.yw));
                r6 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (-(c15.xy));
                r5.zw = (v5.zz) * (-(c1.yw));
                r5 = tex2Dlod(s2, r5);
                r4.y = r7.x;
                r4.z = r6.x;
                r4.w = r5.x;
                r0.x = dot(r4, c13.zzzz);
                r0.z = saturate((v5.w) + (c14.w));
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
    r0.xyz = (r3.www) * (r2.xyz) + (r12.xyz);
    r2.xyz = (r13.zzz) * (c[19].xyz);
    r2.xyz = (r3.www) * (r2.xyz);
    r3.w = (-(r13.w)) + (-(c1.y));
    r3.xyz = (r11.xyz) * (r0.xyz) + (r2.xyz);
    r0.z = (r3.w) * (r3.w);
    r0.y = 1.0f / (r13.x);
    r0.z = (r3.w) * (r0.z);
    r0.y = (r0.y) * (r0.z);
    r0.z = dot(r10.xyz, r9.xyz);
    r3.w = (r11.w) * (r0.y) + (r12.w);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r2.w) * (c3.w);
    r2.xyz = (r9.xyz) * (-(r0.zzz)) + (r10.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r10.www) * (r0.xyz);
    r2.w = saturate((r9.w) * (c[23].x) + (c[23].y));
    r4.xyz = (r3.www) * (r0.xyz);
    r0.y = (r2.w) * (c16.z) + (c16.w);
    r0.z = (r2.w) * (r2.w);
    r2 = (v6.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r3.w = (r0.y) * (r0.z);
    r0.z = dot(r2, c[21]);
    r4.w = 1.0f / (r0.z);
    r5.x = dot(r2, c[20]);
    r0.x = dot(r2, c[10]);
    r5.y = (r5.x) * (r5.x);
    r0.y = dot(r2, c[11]);
    r0.z = dot(c[8].yz, r5.xy) + (c[8].x);
    r2.w = saturate(1.0f / (r0.z));
    r2.xy = saturate((r5.xx) * (c[9].xy) + (c[9].zw));
    r5.xy = (r2.xy) * (c16.zz) + (c16.ww);
    r2.xy = (r2.xy) * (r2.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.w) : (r2.w));
    r2.w = (r5.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r5.y)) + (-(c1.y));
    r0.xy = (r4.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r3.w = (r3.w) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.zz)) + (-(c1.zz));
    r2 = tex2D(s4, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r8.xyz) * (r4.xyz);
    r0.xyz = (r3.www) * (r0.xyz);
    r2.xyz = (r2.xyz) * (c3.www) + (r3.xyz);
    r0.xyz = (r8.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
