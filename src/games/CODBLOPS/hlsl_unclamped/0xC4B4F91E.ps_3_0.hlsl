// Mechanically reconstructed from 0xC4B4F91E.ps_3_0.cso.
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
    const float4 c1 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c3 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c4 = float4(2.0f, -1.0f, 0.0f, -0.5f);
    const float4 c12 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c13 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c14 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c15 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c16 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c26 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c27 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    r0.w = saturate(dot(r5.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (-(c4.y));
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r4.w = (r0.w) * (r0.z);
    r0 = tex2D(s5, v7.xy);
    r1.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0 = (c4.xxxx) * (v8) + (c4.yyyy);
    r3.y = dot(r1.xy, r0.zw) + (c4.z);
    r3.x = dot(r1.xy, r0.xy) + (c4.z);
    r0 = tex2D(s6, v7.zw);
    r1.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0 = (c4.xxxx) * (v9) + (c4.yyyy);
    r6.y = dot(r1.xy, r0.zw) + (c4.z);
    r6.x = dot(r1.xy, r0.xy) + (c4.z);
    r1 = tex2D(s0, v1.xy);
    r0 = tex2D(s3, v7.xy);
    r7.w = (r0.w) * (v0.y) + (c4.w);
    r2 = tex2D(s1, v1.xy);
    r2.xy = (r2.wy) * (c3.xy) + (c3.zw);
    r4.xyz = float3(((r7.w) >= 0.0f ? (r0.x) : (r1.x)), ((r7.w) >= 0.0f ? (r0.y) : (r1.y)), ((r7.w) >= 0.0f ? (r0.z) : (r1.z)));
    r7.xy = float2(((r7.w) >= 0.0f ? (r3.x) : (r2.x)), ((r7.w) >= 0.0f ? (r3.y) : (r2.y)));
    r1 = tex2D(s7, v1.xy);
    r2 = (r1.wwww) * (c1.xxxy) + (c1.zzzx);
    r0 = tex2D(s8, v7.xy);
    r3 = float4(((r7.w) >= 0.0f ? (r0.x) : (r2.x)), ((r7.w) >= 0.0f ? (r0.y) : (r2.y)), ((r7.w) >= 0.0f ? (r0.z) : (r2.z)), ((r7.w) >= 0.0f ? (r0.w) : (r2.w)));
    r2 = tex2D(s4, v7.zw);
    r5.w = (r2.w) * (v0.z) + (c4.w);
    r0 = tex2D(s9, v7.zw);
    r0 = float4(((r5.w) >= 0.0f ? (r0.x) : (r3.x)), ((r5.w) >= 0.0f ? (r0.y) : (r3.y)), ((r5.w) >= 0.0f ? (r0.z) : (r3.z)), ((r5.w) >= 0.0f ? (r0.w) : (r3.w)));
    r2.xyz = float3(((r5.w) >= 0.0f ? (r2.x) : (r4.x)), ((r5.w) >= 0.0f ? (r2.y) : (r4.y)), ((r5.w) >= 0.0f ? (r2.z) : (r4.z)));
    r11.xyz = (r0.xyz) * (-(r0.xyz)) + (-(c4.yyy));
    r12.xyz = (r0.xyz) * (r0.xyz);
    r7.xy = float2(((r5.w) >= 0.0f ? (r6.x) : (r7.x)), ((r5.w) >= 0.0f ? (r6.y) : (r7.y)));
    r0.xyz = (r11.xyz) * (r4.www) + (r12.xyz);
    r6.xyz = (r2.xyz) * (r2.xyz);
    r1.z = dot(r7.xy, r7.xy) + (c4.z);
    r1.w = (r0.w) * (-(c13.z)) + (c13.w);
    r1.z = exp2(-(r1.z));
    r1.z = (r1.z) * (c12.x) + (c12.y);
    r2.xy = (v1.zw) * (-(c4.yw));
    r4 = tex2D(s13, r2.xy);
    r2.xy = (v1.zw) * (-(c4.yw)) + (-(c4.zw));
    r2 = tex2D(s13, r2.xy);
    r3 = tex2D(s14, v1.zw);
    r9.xy = (r3.xy) * (c12.ww);
    r4.w = r2.y;
    r8.xy = (r4.xz) * (r9.xx);
    r10.xy = (r4.yw) * (c13.xx) + (c13.yy);
    r2.w = (r3.x) * (c12.w) + (-(r8.x));
    r1.x = dot(r10.xy, r7.xy) + (c4.z);
    r2.w = (r4.z) * (-(r9.x)) + (r2.w);
    r4.xy = (r2.xz) * (r9.yy);
    r2.x = dot(r10.xy, r10.xy) + (c4.z);
    r2.y = (r3.y) * (c12.w) + (-(r4.x));
    r2.x = exp2(-(r2.x));
    r2.y = (r2.z) * (-(r9.y)) + (r2.y);
    r2.z = (r2.x) * (c12.x) + (c12.y);
    r2.y = (r2.y) + (r2.y);
    r2.z = (r1.z) * (r2.z);
    r1.x = saturate((r1.x) * (r2.z) + (r2.z));
    r2.xz = (r4.xy) * (c13.xx);
    r10.y = (r2.w) + (r2.w);
    r2.xyz = (r2.xyz) * (r1.xxx);
    r10.xz = (r8.xy) * (c13.xx);
    r3.xyz = v2.xyz;
    r3.xyz = (r7.xxx) * (v4.xyz) + (r3.xyz);
    r2.xyz = (r10.xyz) * (r1.zzz) + (r2.xyz);
    r3.xyz = (r7.yyy) * (v3.xyz) + (r3.xyz);
    r9.xyz = normalize(r3.xyz);
    r16.xy = (r0.ww) * (c15.xy) + (c15.zw);
    r1.x = (r0.w) * (c12.z);
    r3.w = exp2(r16.y);
    r3.z = saturate(dot(r9.xyz, r5.xyz));
    r7.xyz = (r6.www) * (v6.xyz);
    r6.w = saturate(dot(r9.xyz, -(r7.xyz)));
    r2.w = saturate(dot(r9.xyz, c[17].xyz));
    r1.z = (r6.w) * (r1.w) + (r1.x);
    r1.w = (r2.w) * (r1.w) + (r1.x);
    r1.x = pow(abs(r3.z), r3.w);
    r1.z = (r1.w) * (r1.z) + (c14.x);
    r1.w = (r3.w) * (c14.y) + (c14.z);
    r1.z = 1.0f / (r1.z);
    r1.w = (r1.x) * (r1.w);
    r3.w = (r2.w) * (r1.z);
    r1.xyz = float3(((r7.w) >= 0.0f ? (c[23].x) : (r1.y)), ((r7.w) >= 0.0f ? (c[23].y) : (r1.y)), ((r7.w) >= 0.0f ? (c[23].w) : (r1.y)));
    r1.w = (r1.w) * (r3.w);
    r13.xyz = float3(((r5.w) >= 0.0f ? (c[24].x) : (r1.x)), ((r5.w) >= 0.0f ? (c[24].y) : (r1.y)), ((r5.w) >= 0.0f ? (c[24].w) : (r1.z)));
    r0.xyz = (r0.xyz) * (r1.www);
    r14.xyz = (r2.xyz) * (r13.yyy);
    r15.xyz = (r13.zzz) * (r0.xyz);
    r1 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (-(c4.y)) : (-(c4.z)));
    r8.xyz = (r2.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r1.w = r0.z;
    }
    else
    {
        if ((-(c4.y)) >= (v5.w))
        {
            r2 = (v5.xyzx) * (-(c4.yyyz));
            r1 = (r2) + (-(c16.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r3 = (r2) + (c26.xxyy);
            r3 = tex2Dlod(s2, r3);
            r1.x = r3.x;
            r3 = (r2) + (c26.zzyy);
            r3 = tex2Dlod(s2, r3);
            r1.y = r3.x;
            r2 = (r2) + (c16.xyzz);
            r2 = tex2Dlod(s2, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c14.zzzz);
            if ((c14.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c26.xx);
                r1.zw = (v5.zx) * (-(c4.yz));
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r0.xy) + (c26.zz);
                r2.zw = (v5.zx) * (-(c4.yz));
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (c16.xy);
                r2.zw = (v5.zx) * (-(c4.yz));
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (-(c16.xy));
                r2.zw = (v5.zx) * (-(c4.yz));
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c14.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c27.x) + (c27.y);
                r1.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r1.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c13.x));
            r0.z = ((r0.z) >= 0.0f ? (-(c4.z)) : (-(c4.y)));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c26.xx);
                r2.zw = (v5.zz) * (-(c4.yz));
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c26.zz);
                r3.zw = (v5.zz) * (-(c4.yz));
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c16.xy);
                r3.zw = (v5.zz) * (-(c4.yz));
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c16.xy));
                r3.zw = (v5.zz) * (-(c4.yz));
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c14.zzzz);
                r0.z = saturate((v5.w) + (c26.w));
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
    r1.xyz = (r15.xyz) * (c[19].xyz);
    r0.xyz = (r1.www) * (r8.xyz) + (r14.xyz);
    r1.xyz = (r1.www) * (r1.xyz);
    r8.xyz = (r6.xyz) * (r0.xyz) + (r1.xyz);
    r0.z = (-(r6.w)) + (-(c4.y));
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r7.xyz, r9.xyz);
    r4.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r0.w = (r0.w) * (c1.w);
    r0.xyz = (r9.xyz) * (-(r0.zzz)) + (r7.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r4.xyz = (r13.xxx) * (r0.xyz);
    r3 = (-(v6.yyyy)) + (c[6]);
    r2 = (-(v6.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v6.zzzz)) + (c[7]);
    r5.xyz = (r11.xyz) * (r4.www) + (r12.xyz);
    r0 = (r1) * (r1) + (r0);
    r5.xyz = (r4.xyz) * (r5.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r5.xyz = (r10.xyz) * (r5.xyz);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r2.z = c4.y;
    r0 = saturate((r0) * (c[8]) + (-(r2.zzzz)));
    r2.xyz = (r5.xyz) * (c1.www) + (r8.xyz);
    r0 = (r1) * (r0);
    r1.z = dot(c[11], r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r0.w = dot(c[20].xyz, r7.xyz);
    r0.w = saturate((c[22].y) * (r0.w) + (c[22].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[21].xyz);
    r1.xyz = (r6.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[25].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = -(c4.y);

    return oC0;
}
