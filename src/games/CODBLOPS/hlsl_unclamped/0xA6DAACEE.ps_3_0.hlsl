// Mechanically reconstructed from 0xA6DAACEE.ps_3_0.cso.
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
    const float4 c3 = float4(2.0f, -1.0f, 0.0f, -0.5f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c12 = float4(0.959999979f, 0.0399999991f, 31.875f, 4.0f);
    const float4 c13 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c14 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c15 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c16 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c24 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c25 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r2 = tex2D(s1, v1.xy);
    r1 = tex2D(s0, v1.xy);
    r0 = tex2D(s3, v7.xy);
    r3.w = (r0.w) * (v0.y);
    r5.xy = (r2.wy) * (c1.xy) + (c1.zw);
    r4.xyz = lerp(r1.xyz, r0.xyz, r3.www);
    r2 = tex2D(s7, v1.xy);
    r0 = tex2D(s8, v7.xy);
    r1 = tex2D(s5, v7.xy);
    r6.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r1 = (c3.xxxx) * (v8) + (c3.yyyy);
    r3.y = dot(r6.xy, r1.zw) + (c3.z);
    r3.x = dot(r6.xy, r1.xy) + (c3.z);
    r1.zw = lerp(r2.wy, r0.wy, r3.ww);
    r1.xy = lerp(r5.xy, r3.xy, r3.ww);
    r0 = tex2D(s6, v7.zw);
    r3.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c3.xxxx) * (v9) + (c3.yyyy);
    r2.y = dot(r3.xy, r0.zw) + (c3.z);
    r2.x = dot(r3.xy, r0.xy) + (c3.z);
    r3 = tex2D(s4, v7.zw);
    r2.w = (r3.w) * (v0.z) + (c3.w);
    r0 = tex2D(s9, v7.zw);
    r2.z = r0.w;
    r3.xyz = float3(((r2.w) >= 0.0f ? (r3.x) : (r4.x)), ((r2.w) >= 0.0f ? (r3.y) : (r4.y)), ((r2.w) >= 0.0f ? (r3.z) : (r4.z)));
    r7.xyz = float3(((r2.w) >= 0.0f ? (r2.x) : (r1.x)), ((r2.w) >= 0.0f ? (r2.y) : (r1.y)), ((r2.w) >= 0.0f ? (r2.z) : (r1.z)));
    r5.w = ((r2.w) >= 0.0f ? (r0.y) : (r1.w));
    r0.w = dot(r7.xy, r7.xy) + (c3.z);
    r5.xyz = (r3.xyz) * (r3.xyz);
    r0.w = exp2(-(r0.w));
    r4.w = (r7.z) * (-(c13.z)) + (c13.w);
    r3.w = (r0.w) * (c4.x) + (c4.y);
    r1.w = dot(v6.xyz, v6.xyz);
    r0.xy = (v1.zw) * (-(c3.yw)) + (-(c3.zw));
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (-(c3.yw));
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r4.z = rsqrt(r1.w);
    r6.xy = (r0.wy) * (c13.xx) + (c13.yy);
    r1 = tex2D(s14, v1.zw);
    r8.xy = (r1.xy) * (c12.zz);
    r0.w = dot(r6.xy, r7.xy) + (c3.z);
    r3.xy = (r2.xz) * (r8.xx);
    r0.y = (r1.x) * (c12.z) + (-(r3.x));
    r4.xy = (r0.xz) * (r8.yy);
    r0.x = (r2.z) * (-(r8.x)) + (r0.y);
    r0.y = (r1.y) * (c12.z) + (-(r4.x));
    r0.y = (r0.z) * (-(r8.y)) + (r0.y);
    r0.z = dot(r6.xy, r6.xy) + (c3.z);
    r10.y = (r0.x) + (r0.x);
    r0.z = exp2(-(r0.z));
    r0.y = (r0.y) + (r0.y);
    r0.z = (r0.z) * (c4.x) + (c4.y);
    r0.z = (r3.w) * (r0.z);
    r2.xyz = (v6.xyz) * (-(r4.zzz)) + (c[17].xyz);
    r1.w = saturate((r0.w) * (r0.z) + (r0.z));
    r1.xyz = normalize(r2.xyz);
    r0.xz = (r4.xy) * (c12.ww);
    r0.w = saturate(dot(r1.xyz, c[17].xyz));
    r0.xyz = (r0.xyz) * (r1.www);
    r0.w = (-(r0.w)) + (-(c3.y));
    r10.xz = (r3.xy) * (c12.ww);
    r1.w = (r0.w) * (r0.w);
    r3.y = (r7.z) * (c4.w);
    r1.w = (r1.w) * (r1.w);
    r2.w = (r0.w) * (r1.w);
    r12.xy = (r7.zz) * (c15.xy) + (c15.zw);
    r3.z = exp2(r12.y);
    r2.xyz = v2.xyz;
    r2.xyz = (r7.xxx) * (v4.xyz) + (r2.xyz);
    r0.w = (r3.z) * (c14.y) + (c14.z);
    r2.xyz = (r7.yyy) * (v3.xyz) + (r2.xyz);
    r9.xyz = normalize(r2.xyz);
    r6.xyz = (r4.zzz) * (v6.xyz);
    r6.w = saturate(dot(r9.xyz, -(r6.xyz)));
    r1.w = saturate(dot(r9.xyz, c[17].xyz));
    r2.x = (r6.w) * (r4.w) + (r3.y);
    r2.y = (r1.w) * (r4.w) + (r3.y);
    r2.z = saturate(dot(r9.xyz, r1.xyz));
    r1.z = (r2.y) * (r2.x) + (c14.x);
    r1.y = pow(abs(r2.z), r3.z);
    r1.z = 1.0f / (r1.z);
    r0.w = (r0.w) * (r1.y);
    r1.y = (r1.w) * (r1.z);
    r1.z = (r2.w) * (c12.x) + (c12.y);
    r0.w = (r0.w) * (r1.y);
    r0.xyz = (r10.xyz) * (r3.www) + (r0.xyz);
    r0.w = (r1.z) * (r0.w);
    r11.xyz = (r5.www) * (r0.xyz);
    r7.w = (r5.w) * (r0.w);
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (-(c3.y)) : (-(c3.z)));
    r8.xyz = (r1.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((-(c3.y)) >= (v5.w))
        {
            r1 = (v5.xyzx) * (-(c3.yyyz));
            r0 = (r1) + (-(c16.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r2 = (r1) + (c24.xxyy);
            r2 = tex2Dlod(s2, r2);
            r0.x = r2.x;
            r2 = (r1) + (c24.zzyy);
            r2 = tex2Dlod(s2, r2);
            r0.y = r2.x;
            r1 = (r1) + (c16.xyzz);
            r1 = tex2Dlod(s2, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c14.zzzz);
            if ((c14.w) < (v5.w))
            {
                r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c24.xx);
                r0.zw = (v5.zx) * (-(c3.yz));
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (c24.zz);
                r1.zw = (v5.zx) * (-(c3.yz));
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c16.xy);
                r1.zw = (v5.zx) * (-(c3.yz));
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c16.xy));
                r1.zw = (v5.zx) * (-(c3.yz));
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c14.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v5.w) * (c25.x) + (c25.y);
                r0.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r0.w = r4.w;
            }
        }
        else
        {
            r0.w = (v5.w) + (-(c12.w));
            r0.w = ((r0.w) >= 0.0f ? (-(c3.z)) : (-(c3.y)));
            if ((r0.w) != (-(r0.w)))
            {
                r7.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r7.xy) + (c24.xx);
                r1.zw = (v5.zz) * (-(c3.yz));
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r7.xy) + (c24.zz);
                r2.zw = (v5.zz) * (-(c3.yz));
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r7.xy) + (c16.xy);
                r2.zw = (v5.zz) * (-(c3.yz));
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r7.xy) + (-(c16.xy));
                r2.zw = (v5.zz) * (-(c3.yz));
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c14.zzzz);
                r0.w = saturate((v5.w) + (c24.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
        }
    }
    r0.xyz = (r0.www) * (r8.xyz) + (r11.xyz);
    r1.xyz = (r7.www) * (c[19].xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r0.w = (-(r6.w)) + (-(c3.y));
    r8.xyz = (r5.xyz) * (r0.xyz) + (r1.xyz);
    r0.y = (r0.w) * (r0.w);
    r0.z = 1.0f / (r12.x);
    r0.w = (r0.w) * (r0.y);
    r0.z = (r0.z) * (r0.w);
    r0.w = dot(r6.xyz, r9.xyz);
    r4.w = (r0.z) * (c12.x) + (c12.y);
    r0.z = (r0.w) + (r0.w);
    r0.w = (r7.z) * (c4.z);
    r0.xyz = (r9.xyz) * (-(r0.zzz)) + (r6.xyz);
    r0 = texCUBElod(s15, r0);
    r4.xyz = (r0.xyz) * (r0.xyz);
    r3 = (-(v6.yyyy)) + (c[6]);
    r2 = (-(v6.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v6.zzzz)) + (c[7]);
    r4.xyz = (r5.www) * (r4.xyz);
    r0 = (r1) * (r1) + (r0);
    r7.xyz = (r4.www) * (r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r7.xyz = (r10.xyz) * (r7.xyz);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r2.z = c3.y;
    r0 = saturate((r0) * (c[8]) + (-(r2.zzzz)));
    r2.xyz = (r7.xyz) * (c4.zzz) + (r8.xyz);
    r0 = (r1) * (r0);
    r1.z = dot(c[11], r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r0.w = dot(c[20].xyz, r6.xyz);
    r0.w = saturate((c[22].y) * (r0.w) + (c[22].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[21].xyz);
    r1.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = -(c3.y);

    return oC0;
}
