// Mechanically reconstructed from 0x5F70060C.ps_3_0.cso.
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
    const float4 c7 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c8 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c9 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c10 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c11 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c12 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    r7.z = rsqrt(r0.w);
    r0.xyz = (v6.xyz) * (-(r7.zzz)) + (c[17].xyz);
    r6.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r6.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (-(c1.y));
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r5.w = (r0.w) * (r0.z);
    r0 = tex2D(s1, v0.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s4, v7.zw);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c1.xxxx) * (v8) + (c1.yyyy);
    r2.y = dot(r3.xy, r0.zw) + (c1.w);
    r2.x = dot(r3.xy, r0.xy) + (c1.w);
    r0 = tex2D(s0, v0.xy);
    r4.w = (r0.w) * (v7.x) + (c1.z);
    r0 = (r0.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r3.xy = float2(((r4.w) >= 0.0f ? (r1.x) : (c1.w)), ((r4.w) >= 0.0f ? (r1.y) : (c1.w)));
    r1 = float4(((r4.w) >= 0.0f ? (r0.x) : (c1.w)), ((r4.w) >= 0.0f ? (r0.y) : (c1.w)), ((r4.w) >= 0.0f ? (r0.z) : (c1.w)), ((r4.w) >= 0.0f ? (r0.w) : (c1.w)));
    r0 = tex2D(s3, v7.zw);
    r8.w = (r0.w) * (v7.y);
    r10.xyz = lerp(r1.xyz, r0.xyz, r8.www);
    r7.xy = lerp(r3.xy, r2.xy, r8.ww);
    r3 = tex2D(s5, v0.xy);
    r2 = (r3.wwww) * (c3.xxxy) + (c3.zzzx);
    r7.w = ((r4.w) >= 0.0f ? (r3.y) : (c1.w));
    r4 = float4(((r4.w) >= 0.0f ? (r2.x) : (-(c1.w))), ((r4.w) >= 0.0f ? (r2.y) : (-(c1.w))), ((r4.w) >= 0.0f ? (r2.z) : (-(c1.w))), ((r4.w) >= 0.0f ? (r2.w) : (-(c1.y))));
    r2 = tex2D(s6, v7.zw);
    r3 = lerp(r4, r2, r8.wwww);
    r1.xyz = (r3.xyz) * (-(r3.xyz)) + (-(c1.yyy));
    r11.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r1.xyz) * (r5.www) + (r11.xyz);
    r2.xy = (v0.zw) * (-(c1.yz)) + (-(c1.wz));
    r2 = tex2D(s13, r2.xy);
    r3.xy = (v0.zw) * (-(c1.yz));
    r5 = tex2D(s13, r3.xy);
    r2.w = r5.y;
    r3.z = dot(r7.xy, r7.xy) + (c1.w);
    r3.xy = (r2.wy) * (c7.xx) + (c7.yy);
    r2.y = exp2(-(r3.z));
    r2.w = dot(r3.xy, r3.xy) + (c1.w);
    r6.w = (r2.y) * (c4.x) + (c4.y);
    r2.w = exp2(-(r2.w));
    r12.xyz = lerp(r7.www, c[5].xyw, r8.www);
    r2.y = (r2.w) * (c4.x) + (c4.y);
    r2.w = dot(r3.xy, r7.xy) + (c1.w);
    r2.y = (r6.w) * (r2.y);
    r4 = tex2D(s14, v0.zw);
    r8.xy = (r4.xy) * (c4.ww);
    r2.w = saturate((r2.w) * (r2.y) + (r2.y));
    r5.xy = (r5.xz) * (r8.xx);
    r2.y = (r4.x) * (c4.w) + (-(r5.x));
    r3.xy = (r2.xz) * (r8.yy);
    r2.y = (r5.z) * (-(r8.x)) + (r2.y);
    r2.x = (r4.y) * (c4.w) + (-(r3.x));
    r2.z = (r2.z) * (-(r8.y)) + (r2.x);
    r9.y = (r2.y) + (r2.y);
    r2.y = (r2.z) + (r2.z);
    r2.xz = (r3.xy) * (c7.xx);
    r4.xyz = (r2.www) * (r2.xyz);
    r2 = v1;
    r2.xyz = (r7.xxx) * (v4.xyz) + (r2.xyz);
    r7.w = (r3.w) * (-(c7.z)) + (c7.w);
    r2.xyz = (r7.yyy) * (v3.xyz) + (r2.xyz);
    r3.xyz = normalize(r2.xyz);
    r13.xyz = (r7.zzz) * (v6.xyz);
    r9.w = saturate(dot(r3.xyz, -(r13.xyz)));
    r2.z = (r3.w) * (c4.z);
    r5.z = saturate(dot(r3.xyz, r6.xyz));
    r2.y = (r9.w) * (r7.w) + (r2.z);
    r16.xy = (r3.ww) * (c9.xy) + (c9.zw);
    r5.w = saturate(dot(r3.xyz, c[17].xyz));
    r4.w = exp2(r16.y);
    r2.z = (r5.w) * (r7.w) + (r2.z);
    r2.x = pow(abs(r5.z), r4.w);
    r2.y = (r2.z) * (r2.y) + (c8.x);
    r2.z = (r4.w) * (c8.y) + (c8.z);
    r2.y = 1.0f / (r2.y);
    r2.z = (r2.x) * (r2.z);
    r2.y = (r5.w) * (r2.y);
    r9.xz = (r5.xy) * (c7.xx);
    r4.w = (r2.z) * (r2.y);
    r2.xyz = (r9.xyz) * (r6.www) + (r4.xyz);
    r0.xyz = (r0.xyz) * (r4.www);
    r15.xyz = (r12.yyy) * (r2.xyz);
    r14.xyz = (r12.zzz) * (r0.xyz);
    r4 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r4.y)) >= 0.0f ? (-(c1.y)) : (-(c1.w)));
    r2.xyz = (r5.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r4.y;
        r4.w = r0.z;
    }
    else
    {
        if ((-(c1.y)) >= (v5.w))
        {
            r5 = (v5.xyzx) * (-(c1.yyyw));
            r4 = (r5) + (-(c11.xyzz));
            r4 = tex2Dlod(s2, r4);
            r4.w = r4.x;
            r6 = (r5) + (c10.xxyy);
            r6 = tex2Dlod(s2, r6);
            r4.x = r6.x;
            r6 = (r5) + (c10.zzyy);
            r6 = tex2Dlod(s2, r6);
            r4.y = r6.x;
            r5 = (r5) + (c11.xyzz);
            r5 = tex2Dlod(s2, r5);
            r4.z = r5.x;
            r0.z = dot(r4, c8.zzzz);
            if ((c8.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r4.xy = (r0.xy) + (c10.xx);
                r4.zw = (v5.zx) * (-(c1.yw));
                r4 = tex2Dlod(s2, r4);
                r5.xy = (r0.xy) + (c10.zz);
                r5.zw = (v5.zx) * (-(c1.yw));
                r7 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (c11.xy);
                r5.zw = (v5.zx) * (-(c1.yw));
                r6 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (-(c11.xy));
                r5.zw = (v5.zx) * (-(c1.yw));
                r5 = tex2Dlod(s2, r5);
                r4.y = r7.x;
                r4.z = r6.x;
                r4.w = r5.x;
                r0.y = dot(r4, c8.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c12.x) + (c12.y);
                r4.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r4.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c7.x));
            r0.z = ((r0.z) >= 0.0f ? (-(c1.w)) : (-(c1.y)));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r5.xy = (r0.xy) + (c10.xx);
                r5.zw = (v5.zz) * (-(c1.yw));
                r5 = tex2Dlod(s2, r5);
                r6.xy = (r0.xy) + (c10.zz);
                r6.zw = (v5.zz) * (-(c1.yw));
                r8 = tex2Dlod(s2, r6);
                r6.xy = (r0.xy) + (c11.xy);
                r6.zw = (v5.zz) * (-(c1.yw));
                r7 = tex2Dlod(s2, r6);
                r6.xy = (r0.xy) + (-(c11.xy));
                r6.zw = (v5.zz) * (-(c1.yw));
                r6 = tex2Dlod(s2, r6);
                r5.y = r8.x;
                r5.z = r7.x;
                r5.w = r6.x;
                r0.x = dot(r5, c8.zzzz);
                r0.z = saturate((v5.w) + (c10.w));
                r0.y = (r4.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r4.y;
            }
            r4.w = r0.z;
        }
    }
    r2.xyz = (r4.www) * (r2.xyz) + (r15.xyz);
    r0.xyz = (r14.xyz) * (c[19].xyz);
    r4.xyz = (r4.www) * (r0.xyz);
    r0.z = (-(r9.w)) + (-(c1.y));
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r13.xyz, r3.xyz);
    r4.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r3.w = (r3.w) * (c3.w);
    r3.xyz = (r3.xyz) * (-(r0.zzz)) + (r13.xyz);
    r3 = texCUBElod(s15, r3);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r12.xxx) * (r0.xyz);
    r3.xyz = (r1.xyz) * (r4.www) + (r11.xyz);
    r1.xyz = (r10.xyz) * (r10.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r4.xyz);
    r0.xyz = (r9.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r2.www) * (r0.xyz) + (v2.xyz);
    r1.w = (-(r1.w)) + (-(c1.y));
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
