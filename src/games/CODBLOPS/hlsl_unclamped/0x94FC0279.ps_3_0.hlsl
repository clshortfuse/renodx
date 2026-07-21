// Mechanically reconstructed from 0x94FC0279.ps_3_0.cso.
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
    const float4 c3 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c4 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c12 = float4(0.797884583f, 1.0f, 0.125f, 0.25f);
    const float4 c13 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c15 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c16 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    r0 = tex2D(s0, v0.xy);
    r6.w = (r0.w) * (v7.x) + (c1.z);
    r1 = tex2D(s1, v0.xy);
    r3.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1 = (r0.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r3.xy = float2(((r6.w) >= 0.0f ? (r3.x) : (c1.w)), ((r6.w) >= 0.0f ? (r3.y) : (c1.w)));
    r0 = tex2D(s5, v7.zw);
    r5.w = (r0.w) * (v7.y);
    r1 = float4(((r6.w) >= 0.0f ? (r1.x) : (c1.w)), ((r6.w) >= 0.0f ? (r1.y) : (c1.w)), ((r6.w) >= 0.0f ? (r1.z) : (c1.w)), ((r6.w) >= 0.0f ? (r1.w) : (c1.w)));
    r7.xy = lerp(r3.xy, r2.xy, r5.ww);
    r2.xyz = lerp(r1.xyz, r0.xyz, r5.www);
    r0.z = dot(r7.xy, r7.xy) + (c1.w);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r0.z = exp2(-(r0.z));
    r5.z = (r0.z) * (c3.x) + (c3.y);
    r0.xy = (v0.zw) * (-(c1.yz));
    r4 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (-(c1.yz)) + (-(c1.wz));
    r2 = tex2D(s13, r0.xy);
    r4.w = r2.y;
    r3 = tex2D(s14, v0.zw);
    r0.xy = (r3.xy) * (c4.xx);
    r5.xy = (r4.yw) * (c4.yy) + (c4.zz);
    r4.xy = (r4.xz) * (r0.xx);
    r0.z = dot(r5.xy, r7.xy) + (c1.w);
    r2.w = (r3.x) * (c4.x) + (-(r4.x));
    r2.w = (r4.z) * (-(r0.x)) + (r2.w);
    r2.xy = (r2.xz) * (r0.yy);
    r3.w = (r3.y) * (c4.x) + (-(r2.x));
    r0.x = dot(r5.xy, r5.xy) + (c1.w);
    r0.y = (r2.z) * (-(r0.y)) + (r3.w);
    r0.x = exp2(-(r0.x));
    r11.y = (r2.w) + (r2.w);
    r0.x = (r0.x) * (c3.x) + (c3.y);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r5.z) * (r0.x);
    r2.w = saturate((r0.z) * (r0.x) + (r0.x));
    r0.xz = (r2.xy) * (c4.yy);
    r0.xyz = (r0.xyz) * (r2.www);
    r11.xz = (r4.xy) * (c4.yy);
    r0.xyz = (r11.xyz) * (r5.zzz) + (r0.xyz);
    r19.yw = c1.yw;
    r5.xyz = float3(((r6.w) >= 0.0f ? (c[36].x) : (r19.w)), ((r6.w) >= 0.0f ? (c[36].y) : (r19.w)), ((r6.w) >= 0.0f ? (c[36].w) : (r19.w)));
    r2 = tex2D(s7, v0.xy);
    r3 = float4(((r6.w) >= 0.0f ? (r2.x) : (-(c1.w))), ((r6.w) >= 0.0f ? (r2.y) : (-(c1.w))), ((r6.w) >= 0.0f ? (r2.z) : (-(c1.w))), ((r6.w) >= 0.0f ? (r2.w) : (-(c1.y))));
    r2 = tex2D(s8, v7.zw);
    r4.w = dot(v6.xyz, v6.xyz);
    r6.xyz = (-(v6.xyz)) + (c[20].xyz);
    r11.w = rsqrt(r4.w);
    r4.w = dot(r6.xyz, r6.xyz);
    r6.w = rsqrt(r4.w);
    r16.xyz = (r11.www) * (v6.xyz);
    r4 = lerp(r3, r2, r5.wwww);
    r2.xyz = (r6.xyz) * (r6.www) + (-(r16.xyz));
    r15.xyz = normalize(r2.xyz);
    r17.xyz = (r6.xyz) * (r6.www);
    r10.xyz = lerp(r5.xyz, c[37].xyw, r5.www);
    r2.w = saturate(dot(r15.xyz, r17.xyz));
    r18.xyz = (r0.xyz) * (r10.yyy);
    r0.z = (-(r2.w)) + (-(c1.y));
    r10.y = (r4.w) * (-(c12.x)) + (c12.y);
    r0.y = (r0.z) * (r0.z);
    r13.xyz = (r4.xyz) * (-(r4.xyz)) + (-(c1.yyy));
    r0.y = (r0.y) * (r0.y);
    r0.z = (r0.z) * (r0.y);
    r14.xyz = (r4.xyz) * (r4.xyz);
    r12.xyz = (r13.xyz) * (r0.zzz) + (r14.xyz);
    r9.w = dot(r17.xyz, c[29].xyz);
    r3 = tex2D(s12, v0.zw);
    r2 = v1;
    r0.xyz = (r7.xxx) * (v4.xyz) + (r2.xyz);
    r0.xyz = (r7.yyy) * (v3.xyz) + (r0.xyz);
    r9.xyz = normalize(r0.xyz);
    r10.w = saturate(dot(r9.xyz, c[17].xyz));
    r0.z = ((-abs(r3.y)) >= 0.0f ? (-(c1.y)) : (-(c1.w)));
    r2.xyz = (r10.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r3.y;
        r5.z = r0.z;
    }
    else
    {
        if ((-(c1.y)) >= (v5.w))
        {
            r5 = (v5.xyzx) * (-(c1.yyyw));
            r3 = (r5) + (-(c14.xyzz));
            r3 = tex2Dlod(s2, r3);
            r3.w = r3.x;
            r6 = (r5) + (c13.xxyy);
            r6 = tex2Dlod(s2, r6);
            r3.x = r6.x;
            r6 = (r5) + (c13.zzyy);
            r6 = tex2Dlod(s2, r6);
            r3.y = r6.x;
            r5 = (r5) + (c14.xyzz);
            r5 = tex2Dlod(s2, r5);
            r3.z = r5.x;
            r0.z = dot(r3, c12.wwww);
            if ((c13.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c13.xx);
                r3.zw = (v5.zx) * (-(c1.yw));
                r3 = tex2Dlod(s2, r3);
                r5.xy = (r0.xy) + (c13.zz);
                r5.zw = (v5.zx) * (-(c1.yw));
                r7 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (c14.xy);
                r5.zw = (v5.zx) * (-(c1.yw));
                r6 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (-(c14.xy));
                r5.zw = (v5.zx) * (-(c1.yw));
                r5 = tex2Dlod(s2, r5);
                r3.y = r7.x;
                r3.z = r6.x;
                r3.w = r5.x;
                r0.y = dot(r3, c12.wwww);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c15.x) + (c15.y);
                r5.z = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r5.z = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c4.y));
            r0.z = ((r0.z) >= 0.0f ? (-(c1.w)) : (-(c1.y)));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r5.xy = (r0.xy) + (c13.xx);
                r5.zw = (v5.zz) * (-(c1.yw));
                r5 = tex2Dlod(s2, r5);
                r6.xy = (r0.xy) + (c13.zz);
                r6.zw = (v5.zz) * (-(c1.yw));
                r8 = tex2Dlod(s2, r6);
                r6.xy = (r0.xy) + (c14.xy);
                r6.zw = (v5.zz) * (-(c1.yw));
                r7 = tex2Dlod(s2, r6);
                r6.xy = (r0.xy) + (-(c14.xy));
                r6.zw = (v5.zz) * (-(c1.yw));
                r6 = tex2Dlod(s2, r6);
                r5.y = r8.x;
                r5.z = r7.x;
                r5.w = r6.x;
                r0.x = dot(r5, c12.wwww);
                r0.z = saturate((v5.w) + (c14.w));
                r0.y = (r3.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r3.y;
            }
            r5.z = r0.z;
        }
    }
    r4.xyz = (r5.zzz) * (r2.xyz) + (r18.xyz);
    r6.y = (r4.w) * (c3.w);
    r5.w = saturate(dot(r17.xyz, r9.xyz));
    r3.w = (r5.w) * (r10.y) + (r6.y);
    r5.y = saturate(dot(r9.xyz, -(r16.xyz)));
    r2.xyz = (v6.xyz) * (-(r11.www)) + (c[17].xyz);
    r6.z = (r5.y) * (r10.y) + (r6.y);
    r0.xyz = normalize(r2.xyz);
    r2.y = (r3.w) * (r6.z) + (c4.w);
    r2.z = saturate(dot(r0.xyz, c[17].xyz));
    r2.y = 1.0f / (r2.y);
    r6.w = (r5.w) * (r2.y);
    r6.x = (-(r2.z)) + (-(c1.y));
    r2.y = (r6.x) * (r6.x);
    r2.z = dot(r16.xyz, r9.xyz);
    r7.w = (r2.y) * (r2.y);
    r2.z = (r2.z) + (r2.z);
    r3.w = (r4.w) * (c3.z);
    r3.xyz = (r9.xyz) * (-(r2.zzz)) + (r16.xyz);
    r3 = texCUBElod(s15, r3);
    r2.z = (-(r5.y)) + (-(c1.y));
    r2.y = (r2.z) * (r2.z);
    r5.xy = (r4.ww) * (c16.xy) + (c16.zw);
    r3.w = (r2.z) * (r2.y);
    r4.w = 1.0f / (r5.x);
    r2.xyz = (r3.xyz) * (r3.xyz);
    r3.w = (r3.w) * (r4.w);
    r2.xyz = (r10.xxx) * (r2.xyz);
    r3.xyz = (r13.xyz) * (r3.www) + (r14.xyz);
    r5.x = (r6.x) * (r7.w);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r5.y = exp2(r5.y);
    r4.w = saturate(dot(r9.xyz, r15.xyz));
    r3.w = (r5.y) * (c12.z) + (c12.w);
    r3.z = (r10.w) * (r10.y) + (r6.y);
    r3.y = (r3.z) * (r6.z) + (c4.w);
    r3.z = saturate(dot(r9.xyz, r0.xyz));
    r0.y = 1.0f / (r3.y);
    r0.z = pow(abs(r3.z), r5.y);
    r0.y = (r10.w) * (r0.y);
    r0.z = (r3.w) * (r0.z);
    r3.y = (r0.y) * (r0.z);
    r0.xyz = (r13.xyz) * (r5.xxx) + (r14.xyz);
    r3.z = pow(abs(r4.w), r5.y);
    r0.xyz = (r3.yyy) * (r0.xyz);
    r3.w = (r3.w) * (r3.z);
    r0.xyz = (r10.zzz) * (r0.xyz);
    r3.w = (r6.w) * (r3.w);
    r3.xyz = (r0.xyz) * (c[19].xyz);
    r0.xyz = (r12.xyz) * (r3.www);
    r3.xyz = (r5.zzz) * (r3.xyz);
    r3.xyz = (r1.xyz) * (r4.xyz) + (r3.xyz);
    r2.xyz = (r11.xyz) * (r2.xyz);
    r8.xyz = (r2.xyz) * (c3.zzz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (c[22].xyz);
    r2.xyz = (r10.zzz) * (r0.xyz);
    r3 = (v6.yyyy) * (c[32]);
    r0.xyz = (r5.www) * (c[21].xyz);
    r3 = (v6.xxxx) * (c[31]) + (r3);
    r2.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r3 = (v6.zzzz) * (c[33]) + (r3);
    r0.z = saturate((r9.w) * (c[30].x) + (c[30].y));
    r6 = (r3) + (c[34]);
    r0.y = (r0.z) * (c15.z) + (c15.w);
    r5.zw = r6.zw;
    r0.z = (r0.z) * (r0.z);
    r7.zw = r5.zw;
    r6.z = (r0.y) * (r0.z);
    r3.zw = r7.zw;
    r4.xy = (r6.ww) * (-(c[35].zw)) + (r6.xy);
    r4.zw = r3.zw;
    r4 = tex2Dproj(s3, r4);
    r4.w = r4.x;
    r7.xy = (r5.ww) * (-(c[35].xy)) + (r6.xy);
    r7 = tex2Dproj(s3, r7);
    r4.y = r7.x;
    r5.xy = (r5.ww) * (c[35].xy) + (r6.xy);
    r7 = tex2Dproj(s3, r5);
    r4.x = r7.x;
    r3.xy = (r5.ww) * (c[35].zw) + (r6.xy);
    r3 = tex2Dproj(s3, r3);
    r4.z = r3.x;
    r3 = (v6.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r8.w = dot(r4, c12.wwww);
    r0.z = dot(r3, c[28]);
    r4.w = 1.0f / (r0.z);
    r4.x = dot(r3, c[27]);
    r0.x = dot(r3, c[25]);
    r4.y = (r4.x) * (r4.x);
    r0.y = dot(r3, c[26]);
    r0.z = dot(c[23].yz, r4.xy) + (c[23].x);
    r3.w = saturate(1.0f / (r0.z));
    r3.xy = saturate((r4.xx) * (c[24].xy) + (c[24].zw));
    r4.xy = (r3.xy) * (c15.zz) + (c15.ww);
    r3.xy = (r3.xy) * (r3.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.w) : (r3.w));
    r3.w = (r4.x) * (r3.x);
    r0.z = (r0.z) * (r3.w);
    r3.w = (r3.y) * (-(r4.y)) + (-(c1.y));
    r0.xy = (r4.ww) * (r0.xy);
    r0.z = (r0.z) * (r3.w);
    r9.w = (r6.z) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.zz)) + (-(c1.zz));
    r7 = tex2D(s4, r0.xy);
    r6 = (-(v6.yyyy)) + (c[6]);
    r5 = (-(v6.xxxx)) + (c[5]);
    r3 = (r6) * (r6);
    r3 = (r5) * (r5) + (r3);
    r4 = (-(v6.zzzz)) + (c[7]);
    r3 = (r4) * (r4) + (r3);
    r0.xyz = (r7.xyz) * (r7.xyz);
    r7.x = rsqrt(r3.x);
    r7.y = rsqrt(r3.y);
    r7.z = rsqrt(r3.z);
    r7.w = rsqrt(r3.w);
    r0.xyz = (r9.www) * (r0.xyz);
    r6 = (r6) * (r7);
    r6 = (r9.yyyy) * (r6);
    r5 = (r5) * (r7);
    r4 = (r4) * (r7);
    r5 = (r5) * (r9.xxxx) + (r6);
    r4 = saturate((r4) * (r9.zzzz) + (r5));
    r3 = saturate((r3) * (c[8]) + (-(r19.yyyy)));
    r0.xyz = (r8.www) * (r0.xyz);
    r3 = (r4) * (r3);
    r2.xyz = (r0.xyz) * (r2.xyz) + (r8.xyz);
    r0.z = dot(c[11], r3);
    r0.x = dot(c[9], r3);
    r0.y = dot(c[10], r3);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r2.www) * (r0.xyz) + (v2.xyz);
    r1.w = (-(r1.w)) + (-(c1.y));
    r0.xyz = max(((r0.xyz) * (c[38].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (r0.w) * (-(v7.y)) + (-(c1.y));
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r1.w) * (-(r0.w)) + (-(c1.y));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
