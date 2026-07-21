// Mechanically reconstructed from 0x57906AC1.ps_3_0.cso.
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(1.0f, 0.0f, -1.0f, 8.0f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c8 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c9 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c10 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c11 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c13 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    r4.z = rsqrt(r0.w);
    r0.xyz = (v6.xyz) * (-(r4.zzz)) + (c[17].xyz);
    r3.xyz = normalize(r0.xyz);
    r4.w = saturate(dot(r3.xyz, c[17].xyz));
    r1 = tex2D(s0, v0.xy);
    r1.w = (r1.w) * (-(v7.x)) + (c1.x);
    r0 = tex2D(s2, v7.zw);
    r3.w = (r0.w) * (v7.y);
    r0.w = (r0.w) * (-(v7.y)) + (c1.x);
    r2.xyz = lerp(r1.xyz, r0.xyz, r3.www);
    r5.w = (r1.w) * (-(r0.w)) + (c1.x);
    r0 = tex2D(s3, v7.zw);
    r4.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.xy = (v0.zw) * (c3.xy) + (c3.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c3.xy);
    r1 = tex2D(s13, r1.xy);
    r0.w = r1.y;
    r4.xy = (r3.ww) * (r4.xy);
    r5.xy = (r0.wy) * (c8.xx) + (c8.yy);
    r0.y = dot(r4.xy, r4.xy) + (c1.y);
    r0.w = dot(r5.xy, r5.xy) + (c1.y);
    r0.y = exp2(-(r0.y));
    r0.w = exp2(-(r0.w));
    r1.w = (r0.y) * (c4.x) + (c4.y);
    r0.y = (r0.w) * (c4.x) + (c4.y);
    r0.w = dot(r5.xy, r4.xy) + (c1.y);
    r0.y = (r1.w) * (r0.y);
    r6.xyz = (r2.xyz) * (r2.xyz);
    r0.w = saturate((r0.w) * (r0.y) + (r0.y));
    r2 = tex2D(s14, v0.zw);
    r7.xy = (r2.xy) * (c4.ww);
    r1.xy = (r1.xz) * (r7.xx);
    r5.xy = (r0.xz) * (r7.yy);
    r0.x = (r2.x) * (c4.w) + (-(r1.x));
    r0.y = (r2.y) * (c4.w) + (-(r5.x));
    r1.z = (r1.z) * (-(r7.x)) + (r0.x);
    r0.z = (r0.z) * (-(r7.y)) + (r0.y);
    r0.y = (r0.z) + (r0.z);
    r0.xz = (r5.xy) * (c3.ww);
    r5.y = (r1.z) + (r1.z);
    r0.xyz = (r0.www) * (r0.xyz);
    r5.xz = (r1.xy) * (c3.ww);
    r0.w = (-(r4.w)) + (c1.x);
    r1.xyz = (r5.xyz) * (r1.www) + (r0.xyz);
    r0.z = (r0.w) * (r0.w);
    r1.w = (r0.z) * (r0.z);
    r0.xyz = v1.xyz;
    r0.xyz = (r4.xxx) * (v4.xyz) + (r0.xyz);
    r4.w = (r0.w) * (r1.w);
    r0.xyz = (r4.yyy) * (v3.xyz) + (r0.xyz);
    r0.w = c1.z;
    r2.xyz = (r0.www) + (c[5].xyw);
    r10.xyz = normalize(r0.xyz);
    r0 = tex2D(s4, v7.zw);
    r0 = (r0) + (c1.yyyz);
    r3.z = saturate(dot(r10.xyz, r3.xyz));
    r0.xyz = (r3.www) * (r0.xyz);
    r7.xyz = (r0.xyz) * (-(r0.xyz)) + (c1.xxx);
    r6.w = (r3.w) * (r0.w) + (c1.x);
    r0.w = (r6.w) * (-(c8.z)) + (c8.w);
    r11.xyz = (r4.zzz) * (v6.xyz);
    r7.w = saturate(dot(r10.xyz, -(r11.xyz)));
    r3.y = (r6.w) * (c4.z);
    r8.xyz = (r0.xyz) * (r0.xyz);
    r0.z = (r7.w) * (r0.w) + (r3.y);
    r15.xy = (r6.ww) * (c10.xy) + (c10.zw);
    r1.w = saturate(dot(r10.xyz, c[17].xyz));
    r2.w = exp2(r15.y);
    r0.w = (r1.w) * (r0.w) + (r3.y);
    r0.y = pow(abs(r3.z), r2.w);
    r0.z = (r0.w) * (r0.z) + (c9.x);
    r0.w = (r2.w) * (c9.y) + (c9.z);
    r0.z = 1.0f / (r0.z);
    r0.w = (r0.y) * (r0.w);
    r2.w = (r1.w) * (r0.z);
    r0.xyz = (r7.xyz) * (r4.www) + (r8.xyz);
    r0.w = (r0.w) * (r2.w);
    r9.xyz = (r3.www) * (r2.xyz) + (c1.xxx);
    r0.xyz = (r0.xyz) * (r0.www);
    r14.xyz = (r1.xyz) * (r9.yyy);
    r12.xyz = (r9.zzz) * (r0.xyz);
    r0 = tex2D(s12, v0.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c1.x) : (c1.y));
    r13.xyz = (r1.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r1.w = r0.w;
    }
    else
    {
        if ((c1.x) >= (v5.w))
        {
            r1 = (v5.xyzx) * (c1.xxxy);
            r0 = (r1) + (-(c12.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r2 = (r1) + (c11.xxyy);
            r2 = tex2Dlod(s1, r2);
            r0.x = r2.x;
            r2 = (r1) + (c11.zzyy);
            r2 = tex2Dlod(s1, r2);
            r0.y = r2.x;
            r1 = (r1) + (c12.xyzz);
            r1 = tex2Dlod(s1, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c9.zzzz);
            if ((c9.w) < (v5.w))
            {
                r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c11.xx);
                r0.zw = (v5.zx) * (c1.xy);
                r0 = tex2Dlod(s1, r0);
                r1.xy = (r4.xy) + (c11.zz);
                r1.zw = (v5.zx) * (c1.xy);
                r3 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (c12.xy);
                r1.zw = (v5.zx) * (c1.xy);
                r2 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (-(c12.xy));
                r1.zw = (v5.zx) * (c1.xy);
                r1 = tex2Dlod(s1, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c9.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v5.w) * (c13.x) + (c13.y);
                r1.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r1.w = r4.w;
            }
        }
        else
        {
            r0.w = (v5.w) + (-(c3.w));
            r0.w = ((r0.w) >= 0.0f ? (c1.y) : (c1.x));
            if ((r0.w) != (-(r0.w)))
            {
                r16.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r16.xy) + (c11.xx);
                r1.zw = (v5.zz) * (c1.xy);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r16.xy) + (c11.zz);
                r2.zw = (v5.zz) * (c1.xy);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r16.xy) + (c12.xy);
                r2.zw = (v5.zz) * (c1.xy);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r16.xy) + (-(c12.xy));
                r2.zw = (v5.zz) * (c1.xy);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c9.zzzz);
                r0.w = saturate((v5.w) + (c11.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r1.w = r0.w;
        }
    }
    r1.xyz = (r1.www) * (r13.xyz) + (r14.xyz);
    r2.xyz = (r12.xyz) * (c[19].xyz);
    r0.w = (-(r7.w)) + (c1.x);
    r0.y = 1.0f / (r15.x);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.w) * (r0.z);
    r0.w = dot(r11.xyz, r10.xyz);
    r2.w = (r0.y) * (r0.z);
    r0.z = (r0.w) + (r0.w);
    r0.w = (r6.w) * (c1.w);
    r0.xyz = (r10.xyz) * (-(r0.zzz)) + (r11.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r9.xxx) * (r0.xyz);
    r3.xyz = (r7.xyz) * (r2.www) + (r8.xyz);
    r2.xyz = (r1.www) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r6.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.www) + (r1.xyz);
    r1.xyz = (r5.www) * (v2.xyz);
    r0.xyz = (r0.xyz) * (r5.www) + (-(r1.xyz));
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (r5.w) * (c[6].w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
