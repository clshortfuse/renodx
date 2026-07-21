// Mechanically reconstructed from 0xAFAA4BAE.ps_3_0.cso.
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
sampler2D s10 : register(s10);
sampler2D s11 : register(s11);
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
    const float4 c12 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c13 = float4(0.797884583f, 1.0f, 0.125f, 0.25f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c36 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    float4 r18 = 0.0f;
    float4 r19 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s7, v7.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c3.xxxx) * (v8) + (c3.yyyy);
    r4.y = dot(r1.xy, r0.zw) + (c3.w);
    r4.x = dot(r1.xy, r0.xy) + (c3.w);
    r0 = tex2D(s8, v7.zw);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c3.xxxx) * (v9) + (c3.yyyy);
    r3.y = dot(r1.xy, r0.zw) + (c3.w);
    r3.x = dot(r1.xy, r0.xy) + (c3.w);
    r1 = tex2D(s1, v1.xy);
    r0 = tex2D(s0, v1.xy);
    r6.w = (r0.w) * (v0.x) + (c3.z);
    r0 = (r0.xyzx) * (-(c3.yyyw)) + (-(c3.wwwy));
    r2.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r1 = float4(((r6.w) >= 0.0f ? (r0.x) : (c3.w)), ((r6.w) >= 0.0f ? (r0.y) : (c3.w)), ((r6.w) >= 0.0f ? (r0.z) : (c3.w)), ((r6.w) >= 0.0f ? (r0.w) : (c3.w)));
    r0 = tex2D(s5, v7.xy);
    r5.z = (r0.w) * (v0.y) + (c3.z);
    r0 = (r0.xyzx) * (-(c3.yyyw)) + (-(c3.wwwy));
    r5.xy = float2(((r6.w) >= 0.0f ? (r2.x) : (c3.w)), ((r6.w) >= 0.0f ? (r2.y) : (c3.w)));
    r1 = float4(((r5.z) >= 0.0f ? (r0.x) : (r1.x)), ((r5.z) >= 0.0f ? (r0.y) : (r1.y)), ((r5.z) >= 0.0f ? (r0.z) : (r1.z)), ((r5.z) >= 0.0f ? (r0.w) : (r1.w)));
    r0 = tex2D(s9, v1.xy);
    r2 = float4(((r6.w) >= 0.0f ? (r0.x) : (-(c3.w))), ((r6.w) >= 0.0f ? (r0.y) : (-(c3.w))), ((r6.w) >= 0.0f ? (r0.z) : (-(c3.w))), ((r6.w) >= 0.0f ? (r0.w) : (-(c3.y))));
    r0 = tex2D(s10, v7.xy);
    r2 = float4(((r5.z) >= 0.0f ? (r0.x) : (r2.x)), ((r5.z) >= 0.0f ? (r0.y) : (r2.y)), ((r5.z) >= 0.0f ? (r0.z) : (r2.z)), ((r5.z) >= 0.0f ? (r0.w) : (r2.w)));
    r0 = tex2D(s6, v7.zw);
    r5.w = (r0.w) * (v0.z) + (c3.z);
    r0 = (r0.xyzx) * (-(c3.yyyw)) + (-(c3.wwwy));
    r4.xy = float2(((r5.z) >= 0.0f ? (r4.x) : (r5.x)), ((r5.z) >= 0.0f ? (r4.y) : (r5.y)));
    r0 = float4(((r5.w) >= 0.0f ? (r0.x) : (r1.x)), ((r5.w) >= 0.0f ? (r0.y) : (r1.y)), ((r5.w) >= 0.0f ? (r0.z) : (r1.z)), ((r5.w) >= 0.0f ? (r0.w) : (r1.w)));
    r1 = tex2D(s11, v7.zw);
    r1 = float4(((r5.w) >= 0.0f ? (r1.x) : (r2.x)), ((r5.w) >= 0.0f ? (r1.y) : (r2.y)), ((r5.w) >= 0.0f ? (r1.z) : (r2.z)), ((r5.w) >= 0.0f ? (r1.w) : (r2.w)));
    r5.xy = float2(((r5.w) >= 0.0f ? (r3.x) : (r4.x)), ((r5.w) >= 0.0f ? (r3.y) : (r4.y)));
    r10.xyz = (r0.xyz) * (r0.xyz);
    r16.xyz = (r1.xyz) * (-(r1.xyz)) + (-(c3.yyy));
    r0.z = dot(r5.xy, r5.xy) + (c3.w);
    r10.w = (r1.w) * (-(c13.x)) + (c13.y);
    r0.z = exp2(-(r0.z));
    r6.z = (r0.z) * (c4.x) + (c4.y);
    r0.xy = (v1.zw) * (-(c3.yz));
    r4 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (-(c3.yz)) + (-(c3.wz));
    r2 = tex2D(s13, r0.xy);
    r3 = tex2D(s14, v1.zw);
    r0.xy = (r3.xy) * (c12.xx);
    r4.w = r2.y;
    r6.xy = (r4.xz) * (r0.xx);
    r4.xy = (r4.yw) * (c12.yy) + (c12.zz);
    r2.w = (r3.x) * (c12.x) + (-(r6.x));
    r0.z = dot(r4.xy, r5.xy) + (c3.w);
    r3.w = (r4.z) * (-(r0.x)) + (r2.w);
    r2.xy = (r2.xz) * (r0.yy);
    r0.x = dot(r4.xy, r4.xy) + (c3.w);
    r2.w = (r3.y) * (c12.x) + (-(r2.x));
    r0.x = exp2(-(r0.x));
    r0.y = (r2.z) * (-(r0.y)) + (r2.w);
    r0.x = (r0.x) * (c4.x) + (c4.y);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r6.z) * (r0.x);
    r2.w = saturate((r0.z) * (r0.x) + (r0.x));
    r0.xz = (r2.xy) * (c12.yy);
    r7.y = (r3.w) + (r3.w);
    r2.xyz = (r0.xyz) * (r2.www);
    r0.z = dot(v6.xyz, v6.xyz);
    r3.xyz = (-(v6.xyz)) + (c[5].xyz);
    r3.w = rsqrt(r0.z);
    r0.z = dot(r3.xyz, r3.xyz);
    r2.w = rsqrt(r0.z);
    r8.xyz = (r3.www) * (v6.xyz);
    r7.xz = (r6.xy) * (c12.yy);
    r4.xyz = (r3.xyz) * (r2.www) + (-(r8.xyz));
    r0.xyz = normalize(r4.xyz);
    r9.xyz = (r3.xyz) * (r2.www);
    r2.xyz = (r7.xyz) * (r6.zzz) + (r2.xyz);
    r2.w = saturate(dot(r0.xyz, r9.xyz));
    r3.x = c3.w;
    r3.xyz = float3(((r6.w) >= 0.0f ? (c[32].x) : (r3.x)), ((r6.w) >= 0.0f ? (c[32].y) : (r3.x)), ((r6.w) >= 0.0f ? (c[32].w) : (r3.x)));
    r2.w = (-(r2.w)) + (-(c3.y));
    r3.xyz = float3(((r5.z) >= 0.0f ? (c[33].x) : (r3.x)), ((r5.z) >= 0.0f ? (c[33].y) : (r3.y)), ((r5.z) >= 0.0f ? (c[33].w) : (r3.z)));
    r4.w = (r2.w) * (r2.w);
    r4.w = (r4.w) * (r4.w);
    r4.xyz = v2.xyz;
    r4.xyz = (r5.xxx) * (v4.xyz) + (r4.xyz);
    r5.z = (r2.w) * (r4.w);
    r4.xyz = (r5.yyy) * (v3.xyz) + (r4.xyz);
    r17.xyz = (r1.xyz) * (r1.xyz);
    r18.xyz = normalize(r4.xyz);
    r1.z = saturate(dot(r18.xyz, r0.xyz));
    r11.w = (r1.w) * (c4.w);
    r4.w = saturate(dot(r9.xyz, r18.xyz));
    r2.w = saturate(dot(r18.xyz, -(r8.xyz)));
    r0.z = (r4.w) * (r10.w) + (r11.w);
    r9.w = (r2.w) * (r10.w) + (r11.w);
    r0.z = (r0.z) * (r9.w) + (c12.w);
    r4.xy = (r1.ww) * (c36.xy) + (c36.zw);
    r0.y = 1.0f / (r0.z);
    r8.w = exp2(r4.y);
    r0.z = pow(abs(r1.z), r8.w);
    r6.w = (r8.w) * (c13.z) + (c13.w);
    r1.y = (r4.w) * (r0.y);
    r1.z = (r0.z) * (r6.w);
    r0.xyz = (r16.xyz) * (r5.zzz) + (r17.xyz);
    r1.z = (r1.y) * (r1.z);
    r15.xyz = float3(((r5.w) >= 0.0f ? (c[34].x) : (r3.x)), ((r5.w) >= 0.0f ? (c[34].y) : (r3.y)), ((r5.w) >= 0.0f ? (c[34].w) : (r3.z)));
    r0.xyz = (r0.xyz) * (r1.zzz);
    r14.xyz = (r2.xyz) * (r15.yyy);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r1.xyz = (r15.zzz) * (r0.xyz);
    r2.w = (-(r2.w)) + (-(c3.y));
    r0.xyz = (r4.www) * (c[6].xyz);
    r2.y = (r2.w) * (r2.w);
    r2.z = 1.0f / (r4.x);
    r2.w = (r2.w) * (r2.y);
    r6.xyz = (r10.xyz) * (r0.xyz) + (r1.xyz);
    r2.w = (r2.z) * (r2.w);
    r1.w = (r1.w) * (c4.z);
    r1.z = dot(r8.xyz, r18.xyz);
    r0.xyz = (v6.xyz) * (-(r3.www)) + (c[17].xyz);
    r1.z = (r1.z) + (r1.z);
    r19.xyz = normalize(r0.xyz);
    r1.xyz = (r18.xyz) * (-(r1.zzz)) + (r8.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r12.w = saturate(dot(r19.xyz, c[17].xyz));
    r11.xyz = (r15.xxx) * (r0.xyz);
    r12.xyz = (r16.xyz) * (r2.www) + (r17.xyz);
    r7.w = saturate(dot(r18.xyz, c[17].xyz));
    r1 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (-(c3.y)) : (-(c3.w)));
    r13.xyz = (r7.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r1.w = r0.z;
    }
    else
    {
        if ((-(c3.y)) >= (v5.w))
        {
            r2 = (v5.xyzx) * (-(c3.yyyw));
            r1 = (r2) + (-(c15.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r3 = (r2) + (c14.xxyy);
            r3 = tex2Dlod(s2, r3);
            r1.x = r3.x;
            r3 = (r2) + (c14.zzyy);
            r3 = tex2Dlod(s2, r3);
            r1.y = r3.x;
            r2 = (r2) + (c15.xyzz);
            r2 = tex2Dlod(s2, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c13.wwww);
            if ((c14.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c14.xx);
                r1.zw = (v5.zx) * (-(c3.yw));
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r0.xy) + (c14.zz);
                r2.zw = (v5.zx) * (-(c3.yw));
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (c15.xy);
                r2.zw = (v5.zx) * (-(c3.yw));
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (-(c15.xy));
                r2.zw = (v5.zx) * (-(c3.yw));
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c13.wwww);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c16.x) + (c16.y);
                r1.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r1.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c12.y));
            r0.z = ((r0.z) >= 0.0f ? (-(c3.w)) : (-(c3.y)));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c14.xx);
                r2.zw = (v5.zz) * (-(c3.yw));
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c14.zz);
                r3.zw = (v5.zz) * (-(c3.yw));
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c15.xy);
                r3.zw = (v5.zz) * (-(c3.yw));
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c15.xy));
                r3.zw = (v5.zz) * (-(c3.yw));
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c13.wwww);
                r0.z = saturate((v5.w) + (c15.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
            r1.w = r0.z;
        }
    }
    r0.z = (-(r12.w)) + (-(c3.y));
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.y) * (r0.y);
    r0.z = (r0.z) * (r0.y);
    r0.y = (r7.w) * (r10.w) + (r11.w);
    r0.y = (r0.y) * (r9.w) + (c12.w);
    r1.z = saturate(dot(r18.xyz, r19.xyz));
    r0.x = 1.0f / (r0.y);
    r0.y = pow(abs(r1.z), r8.w);
    r0.x = (r7.w) * (r0.x);
    r0.y = (r6.w) * (r0.y);
    r1.z = (r0.x) * (r0.y);
    r0.xyz = (r16.xyz) * (r0.zzz) + (r17.xyz);
    r0.xyz = (r1.zzz) * (r0.xyz);
    r0.xyz = (r15.zzz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[19].xyz);
    r1.xyz = (r1.www) * (r13.xyz) + (r14.xyz);
    r2.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r11.xyz) * (r12.xyz);
    r2.xyz = (r10.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r1 = (v6.yyyy) * (c[25]);
    r7.xyz = (r0.xyz) * (c4.zzz) + (r2.xyz);
    r1 = (v6.xxxx) * (c[24]) + (r1);
    r0.z = dot(r9.xyz, c[22].xyz);
    r1 = (v6.zzzz) * (c[26]) + (r1);
    r0.z = saturate((r0.z) * (c[23].x) + (c[23].y));
    r4 = (r1) + (c[27]);
    r0.y = (r0.z) * (c16.z) + (c16.w);
    r3.zw = r4.zw;
    r0.z = (r0.z) * (r0.z);
    r5.zw = r3.zw;
    r4.z = (r0.y) * (r0.z);
    r2.zw = r5.zw;
    r1.xy = (r4.ww) * (-(c[28].zw)) + (r4.xy);
    r1.zw = r2.zw;
    r1 = tex2Dproj(s3, r1);
    r1.w = r1.x;
    r5.xy = (r3.ww) * (-(c[28].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r1.y = r5.x;
    r3.xy = (r3.ww) * (c[28].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r1.x = r5.x;
    r2.xy = (r3.ww) * (c[28].zw) + (r4.xy);
    r3 = tex2Dproj(s3, r2);
    r2 = (v6.xyzx) * (-(c3.yyyw)) + (-(c3.wwwy));
    r1.z = r3.x;
    r0.z = dot(r2, c[21]);
    r3.w = 1.0f / (r0.z);
    r3.x = dot(r2, c[20]);
    r0.x = dot(r2, c[10]);
    r3.y = (r3.x) * (r3.x);
    r0.y = dot(r2, c[11]);
    r0.z = dot(c[8].yz, r3.xy) + (c[8].x);
    r2.w = saturate(1.0f / (r0.z));
    r2.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r3.xy = (r2.xy) * (c16.zz) + (c16.ww);
    r2.xy = (r2.xy) * (r2.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c3.w) : (r2.w));
    r2.w = (r3.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r3.y)) + (-(c3.y));
    r0.xy = (r3.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r3.w = (r4.z) * (r0.z);
    r0.xy = (r0.xy) * (-(c3.zz)) + (-(c3.zz));
    r2 = tex2D(s4, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = dot(r1, c13.wwww);
    r0.xyz = (r3.www) * (r0.xyz);
    r1.xyz = (r1.www) * (r0.xyz);
    r0.z = dot(c[29].xyz, r8.xyz);
    r1.w = saturate((c[31].y) * (r0.z) + (c[31].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[30].xyz);
    r1.xyz = (r1.xyz) * (r6.xyz) + (r7.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[35].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
