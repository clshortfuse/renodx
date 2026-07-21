// Mechanically reconstructed from 0x281BA1C9.ps_3_0.cso.
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
    float4 v8 : COLOR1;
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
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(2.0f, -1.0f, -0.5f, -0.0f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c12 = float4(0.797884583f, 1.0f, 0.125f, 0.25f);
    const float4 c13 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c14 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c15 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c16 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c21 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    r7.w = rsqrt(r0.w);
    r0.xyz = (v6.xyz) * (-(r7.www)) + (c[17].xyz);
    r6.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r6.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (-(c3.y));
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r3.w = (r0.w) * (r0.z);
    r0 = tex2D(s5, v7.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c3.xxxx) * (v8) + (c3.yyyy);
    r4.y = dot(r1.xy, r0.zw) + (c3.w);
    r4.x = dot(r1.xy, r0.xy) + (c3.w);
    r0 = tex2D(s1, v1.xy);
    r1 = tex2D(s6, v7.zw);
    r5.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r1 = (c3.xxxx) * (v9) + (c3.yyyy);
    r2.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r3.y = dot(r5.xy, r1.zw) + (c3.w);
    r0 = tex2D(s0, v1.xy);
    r7.z = (r0.w) * (v0.x) + (c3.z);
    r0 = (r0.xyzx) * (-(c3.yyyw)) + (-(c3.wwwy));
    r3.x = dot(r5.xy, r1.xy) + (c3.w);
    r1 = float4(((r7.z) >= 0.0f ? (r0.x) : (c3.w)), ((r7.z) >= 0.0f ? (r0.y) : (c3.w)), ((r7.z) >= 0.0f ? (r0.z) : (c3.w)), ((r7.z) >= 0.0f ? (r0.w) : (c3.w)));
    r0 = tex2D(s3, v7.xy);
    r6.w = (r0.w) * (v0.y) + (c3.z);
    r0 = (r0.xyzx) * (-(c3.yyyw)) + (-(c3.wwwy));
    r5.xy = float2(((r7.z) >= 0.0f ? (r2.x) : (c3.w)), ((r7.z) >= 0.0f ? (r2.y) : (c3.w)));
    r1 = float4(((r6.w) >= 0.0f ? (r0.x) : (r1.x)), ((r6.w) >= 0.0f ? (r0.y) : (r1.y)), ((r6.w) >= 0.0f ? (r0.z) : (r1.z)), ((r6.w) >= 0.0f ? (r0.w) : (r1.w)));
    r0 = tex2D(s7, v1.xy);
    r2 = float4(((r7.z) >= 0.0f ? (r0.x) : (-(c3.w))), ((r7.z) >= 0.0f ? (r0.y) : (-(c3.w))), ((r7.z) >= 0.0f ? (r0.z) : (-(c3.w))), ((r7.z) >= 0.0f ? (r0.w) : (-(c3.y))));
    r0 = tex2D(s8, v7.xy);
    r2 = float4(((r6.w) >= 0.0f ? (r0.x) : (r2.x)), ((r6.w) >= 0.0f ? (r0.y) : (r2.y)), ((r6.w) >= 0.0f ? (r0.z) : (r2.z)), ((r6.w) >= 0.0f ? (r0.w) : (r2.w)));
    r0 = tex2D(s4, v7.zw);
    r5.w = (r0.w) * (v0.z) + (c3.z);
    r0 = (r0.xyzx) * (-(c3.yyyw)) + (-(c3.wwwy));
    r4.xy = float2(((r6.w) >= 0.0f ? (r4.x) : (r5.x)), ((r6.w) >= 0.0f ? (r4.y) : (r5.y)));
    r0 = float4(((r5.w) >= 0.0f ? (r0.x) : (r1.x)), ((r5.w) >= 0.0f ? (r0.y) : (r1.y)), ((r5.w) >= 0.0f ? (r0.z) : (r1.z)), ((r5.w) >= 0.0f ? (r0.w) : (r1.w)));
    r1 = tex2D(s9, v7.zw);
    r1 = float4(((r5.w) >= 0.0f ? (r1.x) : (r2.x)), ((r5.w) >= 0.0f ? (r1.y) : (r2.y)), ((r5.w) >= 0.0f ? (r1.z) : (r2.z)), ((r5.w) >= 0.0f ? (r1.w) : (r2.w)));
    r10.xyz = (r1.xyz) * (-(r1.xyz)) + (-(c3.yyy));
    r11.xyz = (r1.xyz) * (r1.xyz);
    r7.xy = float2(((r5.w) >= 0.0f ? (r3.x) : (r4.x)), ((r5.w) >= 0.0f ? (r3.y) : (r4.y)));
    r5.xyz = (r10.xyz) * (r3.www) + (r11.xyz);
    r9.xyz = (r0.xyz) * (r0.xyz);
    r0.xy = (v1.zw) * (-(c3.yz)) + (-(c3.wz));
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (-(c3.yz));
    r4 = tex2D(s13, r0.xy);
    r2.w = r4.y;
    r8.w = (r1.w) * (-(c12.x)) + (c12.y);
    r0.xy = (r2.wy) * (c13.yy) + (c13.zz);
    r1.z = dot(r7.xy, r7.xy) + (c3.w);
    r0.z = dot(r0.xy, r0.xy) + (c3.w);
    r1.z = exp2(-(r1.z));
    r0.z = exp2(-(r0.z));
    r2.w = (r1.z) * (c4.x) + (c4.y);
    r1.z = (r0.z) * (c4.x) + (c4.y);
    r0.z = dot(r0.xy, r7.xy) + (c3.w);
    r1.z = (r2.w) * (r1.z);
    r3 = tex2D(s14, v1.zw);
    r0.xy = (r3.xy) * (c13.xx);
    r1.z = saturate((r0.z) * (r1.z) + (r1.z));
    r4.xy = (r4.xz) * (r0.xx);
    r0.z = (r3.x) * (c13.x) + (-(r4.x));
    r1.xy = (r2.xz) * (r0.yy);
    r0.x = (r4.z) * (-(r0.x)) + (r0.z);
    r0.z = (r3.y) * (c13.x) + (-(r1.x));
    r0.z = (r2.z) * (-(r0.y)) + (r0.z);
    r8.y = (r0.x) + (r0.x);
    r0.y = (r0.z) + (r0.z);
    r0.xz = (r1.xy) * (c13.yy);
    r1.xyz = (r1.zzz) * (r0.xyz);
    r0.xyz = v2.xyz;
    r0.xyz = (r7.xxx) * (v4.xyz) + (r0.xyz);
    r8.xz = (r4.xy) * (c13.yy);
    r0.xyz = (r7.yyy) * (v3.xyz) + (r0.xyz);
    r2.xyz = (r8.xyz) * (r2.www) + (r1.xyz);
    r1.xyz = normalize(r0.xyz);
    r0.x = c3.w;
    r0.xyz = float3(((r7.z) >= 0.0f ? (c[8].x) : (r0.x)), ((r7.z) >= 0.0f ? (c[8].y) : (r0.x)), ((r7.z) >= 0.0f ? (c[8].w) : (r0.x)));
    r4.w = saturate(dot(r1.xyz, r6.xyz));
    r3.z = (r1.w) * (c4.w);
    r16.xy = (r1.ww) * (c14.xy) + (c14.zw);
    r2.w = exp2(r16.y);
    r7.xyz = (r7.www) * (v6.xyz);
    r7.w = saturate(dot(r1.xyz, -(r7.xyz)));
    r3.w = saturate(dot(r1.xyz, c[17].xyz));
    r3.x = (r7.w) * (r8.w) + (r3.z);
    r3.z = (r3.w) * (r8.w) + (r3.z);
    r3.y = pow(abs(r4.w), r2.w);
    r3.z = (r3.z) * (r3.x) + (c13.w);
    r2.w = (r2.w) * (c12.z) + (c12.w);
    r3.z = 1.0f / (r3.z);
    r2.w = (r3.y) * (r2.w);
    r3.z = (r3.w) * (r3.z);
    r0.xyz = float3(((r6.w) >= 0.0f ? (c[9].x) : (r0.x)), ((r6.w) >= 0.0f ? (c[9].y) : (r0.y)), ((r6.w) >= 0.0f ? (c[9].w) : (r0.z)));
    r2.w = (r2.w) * (r3.z);
    r12.xyz = float3(((r5.w) >= 0.0f ? (c[10].x) : (r0.x)), ((r5.w) >= 0.0f ? (c[10].y) : (r0.y)), ((r5.w) >= 0.0f ? (c[10].w) : (r0.z)));
    r0.xyz = (r5.xyz) * (r2.www);
    r15.xyz = (r2.xyz) * (r12.yyy);
    r13.xyz = (r12.zzz) * (r0.xyz);
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (-(c3.y)) : (-(c3.w)));
    r14.xyz = (r3.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r2.w = r0.z;
    }
    else
    {
        if ((-(c3.y)) >= (v5.w))
        {
            r3 = (v5.xyzx) * (-(c3.yyyw));
            r2 = (r3) + (-(c16.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c15.xxyy);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (c15.zzyy);
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c16.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c12.wwww);
            if ((c15.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c15.xx);
                r2.zw = (v5.zx) * (-(c3.yw));
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c15.zz);
                r3.zw = (v5.zx) * (-(c3.yw));
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c16.xy);
                r3.zw = (v5.zx) * (-(c3.yw));
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c16.xy));
                r3.zw = (v5.zx) * (-(c3.yw));
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c12.wwww);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c21.x) + (c21.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c13.y));
            r0.z = ((r0.z) >= 0.0f ? (-(c3.w)) : (-(c3.y)));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c15.xx);
                r3.zw = (v5.zz) * (-(c3.yw));
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c15.zz);
                r4.zw = (v5.zz) * (-(c3.yw));
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c16.xy);
                r4.zw = (v5.zz) * (-(c3.yw));
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c16.xy));
                r4.zw = (v5.zz) * (-(c3.yw));
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c12.wwww);
                r0.z = saturate((v5.w) + (c16.w));
                r0.y = (r2.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r2.y;
            }
            r2.w = r0.z;
        }
    }
    r2.xyz = (r2.www) * (r14.xyz) + (r15.xyz);
    r0.xyz = (r13.xyz) * (c[19].xyz);
    r3.xyz = (r2.www) * (r0.xyz);
    r0.z = (-(r7.w)) + (-(c3.y));
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r7.xyz, r1.xyz);
    r2.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r1.w) * (c4.z);
    r1.xyz = (r1.xyz) * (-(r0.zzz)) + (r7.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r12.xxx) * (r0.xyz);
    r1.xyz = (r10.xyz) * (r2.www) + (r11.xyz);
    r2.xyz = (r9.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.xyz = (r8.xyz) * (r0.xyz);
    r0.z = dot(c[5].xyz, r7.xyz);
    r1.w = saturate((c[7].y) * (r0.z) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r1.xyz) * (c4.zzz) + (r2.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[11].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
