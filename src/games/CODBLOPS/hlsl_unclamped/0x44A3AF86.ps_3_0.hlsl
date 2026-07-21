// Mechanically reconstructed from 0x44A3AF86.ps_3_0.cso.
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
    const float4 c38 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s6, v7.zw);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c1.xxxx) * (v8) + (c1.yyyy);
    r2.y = dot(r1.xy, r0.zw) + (c1.w);
    r2.x = dot(r1.xy, r0.xy) + (c1.w);
    r0 = tex2D(s1, v0.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s0, v0.xy);
    r5.w = (r0.w) * (v7.x) + (c1.z);
    r0 = (r0.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r3.xy = float2(((r5.w) >= 0.0f ? (r1.x) : (c1.w)), ((r5.w) >= 0.0f ? (r1.y) : (c1.w)));
    r1 = float4(((r5.w) >= 0.0f ? (r0.x) : (c1.w)), ((r5.w) >= 0.0f ? (r0.y) : (c1.w)), ((r5.w) >= 0.0f ? (r0.z) : (c1.w)), ((r5.w) >= 0.0f ? (r0.w) : (c1.w)));
    r0 = tex2D(s5, v7.zw);
    r4.w = (r0.w) * (v7.y) + (c1.z);
    r0 = (r0.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r5.xy = float2(((r4.w) >= 0.0f ? (r2.x) : (r3.x)), ((r4.w) >= 0.0f ? (r2.y) : (r3.y)));
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (r1.x)), ((r4.w) >= 0.0f ? (r0.y) : (r1.y)), ((r4.w) >= 0.0f ? (r0.z) : (r1.z)), ((r4.w) >= 0.0f ? (r0.w) : (r1.w)));
    r1.w = dot(r5.xy, r5.xy) + (c1.w);
    r8.xyz = (r0.xyz) * (r0.xyz);
    r0.z = exp2(-(r1.w));
    r4.z = (r0.z) * (c4.x) + (c4.y);
    r0.xy = (v0.zw) * (-(c1.yz));
    r3 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (-(c1.yz)) + (-(c1.wz));
    r1 = tex2D(s13, r0.xy);
    r3.w = r1.y;
    r2 = tex2D(s14, v0.zw);
    r0.xy = (r2.xy) * (c4.ww);
    r4.xy = (r3.yw) * (c12.xx) + (c12.yy);
    r3.xy = (r3.xz) * (r0.xx);
    r0.z = dot(r4.xy, r5.xy) + (c1.w);
    r1.w = (r2.x) * (c4.w) + (-(r3.x));
    r1.w = (r3.z) * (-(r0.x)) + (r1.w);
    r1.xy = (r1.xz) * (r0.yy);
    r2.w = (r2.y) * (c4.w) + (-(r1.x));
    r0.x = dot(r4.xy, r4.xy) + (c1.w);
    r0.y = (r1.z) * (-(r0.y)) + (r2.w);
    r0.x = exp2(-(r0.x));
    r11.y = (r1.w) + (r1.w);
    r0.x = (r0.x) * (c4.x) + (c4.y);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r4.z) * (r0.x);
    r1.w = saturate((r0.z) * (r0.x) + (r0.x));
    r0.xz = (r1.xy) * (c12.xx);
    r0.xyz = (r0.xyz) * (r1.www);
    r11.xz = (r3.xy) * (c12.xx);
    r1 = tex2D(s7, v0.xy);
    r3 = float4(((r5.w) >= 0.0f ? (r1.x) : (-(c1.w))), ((r5.w) >= 0.0f ? (r1.y) : (-(c1.w))), ((r5.w) >= 0.0f ? (r1.z) : (-(c1.w))), ((r5.w) >= 0.0f ? (r1.w) : (-(c1.y))));
    r1 = tex2D(s8, v7.zw);
    r2 = (r1.wwww) * (c3.xxxy) + (c3.zzzx);
    r0.xyz = (r11.xyz) * (r4.zzz) + (r0.xyz);
    r3 = float4(((r4.w) >= 0.0f ? (r2.x) : (r3.x)), ((r4.w) >= 0.0f ? (r2.y) : (r3.y)), ((r4.w) >= 0.0f ? (r2.z) : (r3.z)), ((r4.w) >= 0.0f ? (r2.w) : (r3.w)));
    r1.w = dot(v6.xyz, v6.xyz);
    r2.xyz = (-(v6.xyz)) + (c[20].xyz);
    r11.w = rsqrt(r1.w);
    r1.w = dot(r2.xyz, r2.xyz);
    r1.w = rsqrt(r1.w);
    r16.xyz = (r11.www) * (v6.xyz);
    r10.w = (r3.w) * (-(c12.z)) + (c12.w);
    r4.xyz = (r2.xyz) * (r1.www) + (-(r16.xyz));
    r15.xyz = normalize(r4.xyz);
    r17.xyz = (r2.xyz) * (r1.www);
    r13.xyz = (r3.xyz) * (-(r3.xyz)) + (-(c1.yyy));
    r1.w = saturate(dot(r15.xyz, r17.xyz));
    r19.yw = c1.yw;
    r2.xyz = float3(((r5.w) >= 0.0f ? (c[36].x) : (r19.w)), ((r5.w) >= 0.0f ? (c[36].y) : (r19.w)), ((r5.w) >= 0.0f ? (c[36].w) : (r19.w)));
    r1.w = (-(r1.w)) + (-(c1.y));
    r10.xyz = float3(((r4.w) >= 0.0f ? (r1.y) : (r2.x)), ((r4.w) >= 0.0f ? (r1.y) : (r2.y)), ((r4.w) >= 0.0f ? (r1.y) : (r2.z)));
    r1.z = (r1.w) * (r1.w);
    r18.xyz = (r0.xyz) * (r10.yyy);
    r0.z = (r1.z) * (r1.z);
    r0.z = (r1.w) * (r0.z);
    r14.xyz = (r3.xyz) * (r3.xyz);
    r12.xyz = (r13.xyz) * (r0.zzz) + (r14.xyz);
    r8.w = dot(r17.xyz, c[29].xyz);
    r2 = tex2D(s12, v0.zw);
    r1 = v1;
    r0.xyz = (r5.xxx) * (v4.xyz) + (r1.xyz);
    r0.xyz = (r5.yyy) * (v3.xyz) + (r0.xyz);
    r9.xyz = normalize(r0.xyz);
    r9.w = saturate(dot(r9.xyz, c[17].xyz));
    r0.z = ((-abs(r2.y)) >= 0.0f ? (-(c1.y)) : (-(c1.w)));
    r1.xyz = (r9.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r4.z = r0.z;
    }
    else
    {
        if ((-(c1.y)) >= (v5.w))
        {
            r4 = (v5.xyzx) * (-(c1.yyyw));
            r2 = (r4) + (-(c15.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r5 = (r4) + (c14.xxyy);
            r5 = tex2Dlod(s2, r5);
            r2.x = r5.x;
            r5 = (r4) + (c14.zzyy);
            r5 = tex2Dlod(s2, r5);
            r2.y = r5.x;
            r4 = (r4) + (c15.xyzz);
            r4 = tex2Dlod(s2, r4);
            r2.z = r4.x;
            r0.z = dot(r2, c13.zzzz);
            if ((c13.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c14.xx);
                r2.zw = (v5.zx) * (-(c1.yw));
                r2 = tex2Dlod(s2, r2);
                r4.xy = (r0.xy) + (c14.zz);
                r4.zw = (v5.zx) * (-(c1.yw));
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c15.xy);
                r4.zw = (v5.zx) * (-(c1.yw));
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c15.xy));
                r4.zw = (v5.zx) * (-(c1.yw));
                r4 = tex2Dlod(s2, r4);
                r2.y = r6.x;
                r2.z = r5.x;
                r2.w = r4.x;
                r0.y = dot(r2, c13.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c16.x) + (c16.y);
                r4.z = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r4.z = r0.z;
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
                r0.y = (r2.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r2.y;
            }
            r4.z = r0.z;
        }
    }
    r3.xyz = (r4.zzz) * (r1.xyz) + (r18.xyz);
    r5.y = (r3.w) * (c4.z);
    r4.w = saturate(dot(r17.xyz, r9.xyz));
    r2.w = (r4.w) * (r10.w) + (r5.y);
    r4.y = saturate(dot(r9.xyz, -(r16.xyz)));
    r1.xyz = (v6.xyz) * (-(r11.www)) + (c[17].xyz);
    r5.z = (r4.y) * (r10.w) + (r5.y);
    r0.xyz = normalize(r1.xyz);
    r1.y = (r2.w) * (r5.z) + (c13.x);
    r1.z = saturate(dot(r0.xyz, c[17].xyz));
    r1.y = 1.0f / (r1.y);
    r5.w = (r4.w) * (r1.y);
    r5.x = (-(r1.z)) + (-(c1.y));
    r1.y = (r5.x) * (r5.x);
    r1.z = dot(r16.xyz, r9.xyz);
    r6.w = (r1.y) * (r1.y);
    r1.z = (r1.z) + (r1.z);
    r2.w = (r3.w) * (c3.w);
    r2.xyz = (r9.xyz) * (-(r1.zzz)) + (r16.xyz);
    r2 = texCUBElod(s15, r2);
    r1.z = (-(r4.y)) + (-(c1.y));
    r1.y = (r1.z) * (r1.z);
    r4.xy = (r3.ww) * (c38.xy) + (c38.zw);
    r2.w = (r1.z) * (r1.y);
    r3.w = 1.0f / (r4.x);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r2.w = (r2.w) * (r3.w);
    r1.xyz = (r10.xxx) * (r1.xyz);
    r2.xyz = (r13.xyz) * (r2.www) + (r14.xyz);
    r4.x = (r5.x) * (r6.w);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r4.y = exp2(r4.y);
    r3.w = saturate(dot(r9.xyz, r15.xyz));
    r2.w = (r4.y) * (c13.y) + (c13.z);
    r2.z = (r9.w) * (r10.w) + (r5.y);
    r2.y = (r2.z) * (r5.z) + (c13.x);
    r2.z = saturate(dot(r9.xyz, r0.xyz));
    r0.y = 1.0f / (r2.y);
    r0.z = pow(abs(r2.z), r4.y);
    r0.y = (r9.w) * (r0.y);
    r0.z = (r2.w) * (r0.z);
    r2.y = (r0.y) * (r0.z);
    r0.xyz = (r13.xyz) * (r4.xxx) + (r14.xyz);
    r2.z = pow(abs(r3.w), r4.y);
    r0.xyz = (r2.yyy) * (r0.xyz);
    r2.w = (r2.w) * (r2.z);
    r0.xyz = (r10.zzz) * (r0.xyz);
    r2.w = (r5.w) * (r2.w);
    r2.xyz = (r0.xyz) * (c[19].xyz);
    r0.xyz = (r12.xyz) * (r2.www);
    r2.xyz = (r4.zzz) * (r2.xyz);
    r2.xyz = (r8.xyz) * (r3.xyz) + (r2.xyz);
    r1.xyz = (r11.xyz) * (r1.xyz);
    r7.xyz = (r1.xyz) * (c3.www) + (r2.xyz);
    r0.xyz = (r0.xyz) * (c[22].xyz);
    r1.xyz = (r10.zzz) * (r0.xyz);
    r2 = (v6.yyyy) * (c[32]);
    r0.xyz = (r4.www) * (c[21].xyz);
    r2 = (v6.xxxx) * (c[31]) + (r2);
    r1.xyz = (r8.xyz) * (r0.xyz) + (r1.xyz);
    r2 = (v6.zzzz) * (c[33]) + (r2);
    r0.z = saturate((r8.w) * (c[30].x) + (c[30].y));
    r5 = (r2) + (c[34]);
    r0.y = (r0.z) * (c16.z) + (c16.w);
    r4.zw = r5.zw;
    r0.z = (r0.z) * (r0.z);
    r6.zw = r4.zw;
    r5.z = (r0.y) * (r0.z);
    r2.zw = r6.zw;
    r3.xy = (r5.ww) * (-(c[35].zw)) + (r5.xy);
    r3.zw = r2.zw;
    r3 = tex2Dproj(s3, r3);
    r3.w = r3.x;
    r6.xy = (r4.ww) * (-(c[35].xy)) + (r5.xy);
    r6 = tex2Dproj(s3, r6);
    r3.y = r6.x;
    r4.xy = (r4.ww) * (c[35].xy) + (r5.xy);
    r6 = tex2Dproj(s3, r4);
    r3.x = r6.x;
    r2.xy = (r4.ww) * (c[35].zw) + (r5.xy);
    r2 = tex2Dproj(s3, r2);
    r3.z = r2.x;
    r2 = (v6.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r7.w = dot(r3, c13.zzzz);
    r0.z = dot(r2, c[28]);
    r3.w = 1.0f / (r0.z);
    r3.x = dot(r2, c[27]);
    r0.x = dot(r2, c[25]);
    r3.y = (r3.x) * (r3.x);
    r0.y = dot(r2, c[26]);
    r0.z = dot(c[23].yz, r3.xy) + (c[23].x);
    r2.w = saturate(1.0f / (r0.z));
    r2.xy = saturate((r3.xx) * (c[24].xy) + (c[24].zw));
    r3.xy = (r2.xy) * (c16.zz) + (c16.ww);
    r2.xy = (r2.xy) * (r2.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.w) : (r2.w));
    r2.w = (r3.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r3.y)) + (-(c1.y));
    r0.xy = (r3.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r8.w = (r5.z) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.zz)) + (-(c1.zz));
    r6 = tex2D(s4, r0.xy);
    r5 = (-(v6.yyyy)) + (c[6]);
    r4 = (-(v6.xxxx)) + (c[5]);
    r2 = (r5) * (r5);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v6.zzzz)) + (c[7]);
    r2 = (r3) * (r3) + (r2);
    r0.xyz = (r6.xyz) * (r6.xyz);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r0.xyz = (r8.www) * (r0.xyz);
    r5 = (r5) * (r6);
    r5 = (r9.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r9.xxxx) + (r5);
    r3 = saturate((r3) * (r9.zzzz) + (r4));
    r2 = saturate((r2) * (c[8]) + (-(r19.yyyy)));
    r0.xyz = (r7.www) * (r0.xyz);
    r2 = (r3) * (r2);
    r1.xyz = (r0.xyz) * (r1.xyz) + (r7.xyz);
    r0.z = dot(c[11], r2);
    r0.x = dot(c[9], r2);
    r0.y = dot(c[10], r2);
    r0.xyz = (r8.xyz) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
