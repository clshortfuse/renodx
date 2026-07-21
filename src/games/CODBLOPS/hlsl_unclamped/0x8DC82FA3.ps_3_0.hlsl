// Mechanically reconstructed from 0x8DC82FA3.ps_3_0.cso.
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
    const float4 c1 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c12 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c13 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(4.0f, -3.0f, 0.0f, 0.0f);
    const float4 c21 = float4(1.0f, -1.0f, 0.200000003f, 0.0f);
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

    r0.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r1 = tex2D(s13, r0.xy);
    r0 = tex2D(s14, v1.zw);
    r2.xy = (r0.xy) * (c3.ww);
    r4.xy = (r1.xz) * (r2.yy);
    r0.w = (r0.y) * (c3.w) + (-(r4.x));
    r0.y = r1.y;
    r0.w = (r1.z) * (-(r2.y)) + (r0.w);
    r2.y = (r0.w) + (r0.w);
    r1.xy = (v1.zw) * (c3.xy);
    r1 = tex2D(s13, r1.xy);
    r3.xy = (r2.xx) * (r1.xz);
    r0.w = (r0.x) * (c3.w) + (-(r3.x));
    r0.x = r1.y;
    r1.w = (r1.z) * (-(r2.x)) + (r0.w);
    r1.xy = (r0.xy) * (c4.xx) + (c4.yy);
    r0 = tex2D(s1, v1.xy);
    r5.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s3, v8.xy);
    r0.w = (r0.w) * (v0.y);
    r8.y = (r1.w) + (r1.w);
    r6.xy = (r0.ww) * (-(r5.xy)) + (r5.xy);
    r1.z = dot(r1.xy, r1.xy) + (c21.w);
    r1.w = dot(r6.xy, r6.xy) + (c21.w);
    r1.z = exp2(-(r1.z));
    r1.w = exp2(-(r1.w));
    r2.w = (r1.z) * (c1.x) + (c1.y);
    r1.w = (r1.w) * (c1.x) + (c1.y);
    r1.z = dot(r1.xy, r6.xy) + (c21.w);
    r1.y = (r2.w) * (r1.w);
    r1.z = saturate((r1.z) * (r1.y) + (r1.y));
    r2.xz = (r4.xy) * (c4.xx);
    r1.xyz = (r2.xyz) * (r1.zzz);
    r8.xz = (r3.xy) * (c4.xx);
    r3.xyz = (r8.xyz) * (r1.www) + (r1.xyz);
    r1 = tex2D(s0, v1.xy);
    r1.w = dot(v7.xyz, v7.xyz);
    r2.w = rsqrt(r1.w);
    r2.xyz = (v7.xyz) * (-(r2.www)) + (c[17].xyz);
    r4.xyz = normalize(r2.xyz);
    r1.w = saturate(dot(r4.xyz, c[17].xyz));
    r3.w = (-(r1.w)) + (c21.x);
    r2.xyz = lerp(r1.xyz, r0.xyz, r0.www);
    r0.z = (r3.w) * (r3.w);
    r1 = tex2D(s5, v1.xy);
    r0.x = -(r1.y);
    r0.z = (r0.z) * (r0.z);
    r0.y = (r0.x) + (c21.x);
    r5.w = (r3.w) * (r0.z);
    r15.xy = (r0.ww) * (r0.xy) + (r1.yy);
    r13.xyz = (r3.xyz) * (r15.yyy);
    r6.w = (r1.w) * (-(c4.z)) + (c4.w);
    r0 = tex2D(s4, v8.zw);
    r0.xyz = (r0.xyz) + (c21.yyy);
    r6.z = (r1.w) * (c1.w);
    r3.xyz = (v0.zzz) * (r0.xyz) + (c21.xxx);
    r5.xyz = (r3.xyz) * (c21.zzz);
    r0 = v2;
    r0.xyz = (r6.xxx) * (v5.xyz) + (r0.xyz);
    r10.xyz = (r5.xyz) * (-(r5.xyz)) + (c21.xxx);
    r0.xyz = (r6.yyy) * (v4.xyz) + (r0.xyz);
    r9.xyz = normalize(r0.xyz);
    r1.xyz = (r2.www) * (v7.xyz);
    r11.xyz = (r5.xyz) * (r5.xyz);
    r7.w = saturate(dot(r9.xyz, -(r1.xyz)));
    r0.y = (r7.w) * (r6.w) + (r6.z);
    r16.xy = (r1.ww) * (c13.xy) + (c13.zw);
    r2.w = exp2(r16.y);
    r3.w = saturate(dot(r9.xyz, c[17].xyz));
    r4.w = saturate(dot(r9.xyz, r4.xyz));
    r0.z = (r3.w) * (r6.w) + (r6.z);
    r0.x = pow(abs(r4.w), r2.w);
    r0.z = (r0.z) * (r0.y) + (c12.x);
    r0.y = (r2.w) * (c12.y) + (c12.z);
    r0.z = 1.0f / (r0.z);
    r2.w = (r0.x) * (r0.y);
    r4.w = (r3.w) * (r0.z);
    r0.xyz = (r10.xyz) * (r5.www) + (r11.xyz);
    r2.w = (r2.w) * (r4.w);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r2.www);
    r7.xyz = (r2.xyz) * (r2.xyz);
    r14.xyz = (r15.xxx) * (r0.xyz);
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c21.x) : (c21.w));
    r12.xyz = (r3.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c21.x) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c21.xxxw);
            r2 = (r3) + (-(c15.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c14.xxyy);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (c14.zzyy);
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c15.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c12.zzzz);
            if ((c12.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c14.xx);
                r2.zw = (v6.zx) * (c21.xw);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c14.zz);
                r3.zw = (v6.zx) * (c21.xw);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c15.xy);
                r3.zw = (v6.zx) * (c21.xw);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c15.xy));
                r3.zw = (v6.zx) * (c21.xw);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c12.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v6.w) * (c16.x) + (c16.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c4.x));
            r0.z = ((r0.z) >= 0.0f ? (c21.w) : (c21.x));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c14.xx);
                r3.zw = (v6.zz) * (c21.xw);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c14.zz);
                r4.zw = (v6.zz) * (c21.xw);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c15.xy);
                r4.zw = (v6.zz) * (c21.xw);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c15.xy));
                r4.zw = (v6.zz) * (c21.xw);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c12.zzzz);
                r0.z = saturate((v6.w) + (c14.w));
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
    r2.xyz = (r14.xyz) * (c[19].xyz);
    r0.xyz = (r2.www) * (r12.xyz) + (r13.xyz);
    r2.xyz = (r2.www) * (r2.xyz);
    r6.xyz = (r7.xyz) * (r0.xyz) + (r2.xyz);
    r0.z = (-(r7.w)) + (c21.x);
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r1.xyz, r9.xyz);
    r5.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r1.w) * (c1.z);
    r1.xyz = (r9.xyz) * (-(r0.zzz)) + (r1.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r4 = (-(v7.yyyy)) + (c[6]);
    r3 = (-(v7.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v7.zzzz)) + (c[7]);
    r0.xyz = (r15.xxx) * (r0.xyz);
    r1 = (r2) * (r2) + (r1);
    r10.xyz = (r10.xyz) * (r5.www) + (r11.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = (r0.xyz) * (r10.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r3.w = c21.x;
    r1 = saturate((r1) * (c[8]) + (r3.wwww));
    r0.xyz = (r8.xyz) * (r0.xyz);
    r1 = (r2) * (r1);
    r2.xyz = (r0.xyz) * (c1.zzz) + (r6.xyz);
    r0.z = dot(c[11], r1);
    r0.x = dot(c[9], r1);
    r0.y = dot(c[10], r1);
    r0.xyz = (r7.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c21.x;

    return oC0;
}
