// Mechanically reconstructed from 0x1CC4F1AE.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 1.0f, -1.0f, 0.200000003f);
    const float4 c3 = float4(0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c4 = float4(0.797884583f, 1.0f, 0.5f, 0.0f);
    const float4 c6 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c7 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c8 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c9 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c10 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0.w = dot(v7.xyz, v7.xyz);
    r5.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r5.www)) + (c[17].xyz);
    r4.xyz = normalize(r0.xyz);
    r4.w = saturate(dot(r4.xyz, c[17].xyz));
    r1 = tex2D(s1, v1.xy);
    r0.xy = (v1.zw) * (c4.yz) + (c4.wz);
    r0 = tex2D(s13, r0.xy);
    r2.xy = (v1.zw) * (-(c1.zx));
    r2 = tex2D(s13, r2.xy);
    r0.w = r2.y;
    r5.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1.xy = (r0.wy) * (c6.yy) + (c6.zz);
    r0.y = dot(r5.xy, r5.xy) + (c3.x);
    r0.w = dot(r1.xy, r1.xy) + (c3.x);
    r0.y = exp2(-(r0.y));
    r0.w = exp2(-(r0.w));
    r3.w = (r0.y) * (c3.y) + (c3.z);
    r0.y = (r0.w) * (c3.y) + (c3.z);
    r0.w = dot(r1.xy, r5.xy) + (c3.x);
    r0.y = (r3.w) * (r0.y);
    r1 = tex2D(s14, v1.zw);
    r6.xy = (r1.xy) * (c6.xx);
    r0.w = saturate((r0.w) * (r0.y) + (r0.y));
    r2.xy = (r2.xz) * (r6.xx);
    r0.y = (r1.x) * (c6.x) + (-(r2.x));
    r3.xy = (r0.xz) * (r6.yy);
    r0.y = (r2.z) * (-(r6.x)) + (r0.y);
    r0.x = (r1.y) * (c6.x) + (-(r3.x));
    r0.z = (r0.z) * (-(r6.y)) + (r0.x);
    r7.y = (r0.y) + (r0.y);
    r0.y = (r0.z) + (r0.z);
    r0.xz = (r3.xy) * (c6.yy);
    r3.xyz = (r0.www) * (r0.xyz);
    r7.xz = (r2.xy) * (c6.yy);
    r1.w = (-(r4.w)) + (c1.y);
    r0 = v2;
    r0.xyz = (r5.xxx) * (v5.xyz) + (r0.xyz);
    r1.z = (r1.w) * (r1.w);
    r0.xyz = (r5.yyy) * (v4.xyz) + (r0.xyz);
    r1.z = (r1.z) * (r1.z);
    r10.xyz = normalize(r0.xyz);
    r4.w = (r1.w) * (r1.z);
    r0.z = saturate(dot(r10.xyz, r4.xyz));
    r1 = tex2D(s5, v1.xy);
    r11.xyz = (r5.www) * (v7.xyz);
    r0.y = (r1.w) * (-(c4.x)) + (c4.y);
    r8.w = saturate(dot(r10.xyz, -(r11.xyz)));
    r1.x = (r1.w) * (c4.x);
    r1.z = saturate(dot(r10.xyz, c[17].xyz));
    r0.x = (r8.w) * (r0.y) + (r1.x);
    r0.y = (r1.z) * (r0.y) + (r1.x);
    r0.y = (r0.y) * (r0.x) + (c6.w);
    r16.xy = (r1.ww) * (c7.xy) + (c7.zw);
    r0.y = 1.0f / (r0.y);
    r1.x = exp2(r16.y);
    r4.z = (r1.z) * (r0.y);
    r4.y = pow(abs(r0.z), r1.x);
    r2 = tex2D(s4, v8.zw);
    r0.xyz = (r2.xyz) + (c1.zzz);
    r1.x = (r1.x) * (c8.x) + (c8.y);
    r13.xyz = (v0.zzz) * (r0.xyz) + (c1.yyy);
    r1.x = (r4.y) * (r1.x);
    r0.xyz = (r13.xyz) * (c1.www);
    r8.xyz = (r0.xyz) * (-(r0.xyz)) + (c1.yyy);
    r9.xyz = (r0.xyz) * (r0.xyz);
    r1.x = (r4.z) * (r1.x);
    r2.xyz = (r8.xyz) * (r4.www) + (r9.xyz);
    r0.xyz = (r7.xyz) * (r3.www) + (r3.xyz);
    r4.xyz = (r1.xxx) * (r2.xyz);
    r3 = tex2D(s0, v1.xy);
    r2 = tex2D(s3, v8.xy);
    r1.x = (r2.w) * (v0.y) + (c1.x);
    r12.xyz = float3(((r1.x) >= 0.0f ? (r2.x) : (r3.x)), ((r1.x) >= 0.0f ? (r2.y) : (r3.y)), ((r1.x) >= 0.0f ? (r2.z) : (r3.z)));
    r7.w = ((r1.x) >= 0.0f ? (c1.y) : (r1.y));
    r15.xyz = (r4.xyz) * (r7.www);
    r14.xyz = (r0.xyz) * (r7.www);
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c4.y) : (c4.w));
    r1.xyz = (r1.zzz) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c1.y) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c4.yyyw);
            r2 = (r3) + (-(c9.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c8.zzww);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (-(c8.zzww));
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c9.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c8.yyyy);
            if ((c9.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c8.zz);
                r2.zw = (v6.zx) * (c4.yw);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (-(c8.zz));
                r3.zw = (v6.zx) * (c4.yw);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c9.xy);
                r3.zw = (v6.zx) * (c4.yw);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c9.xy));
                r3.zw = (v6.zx) * (c4.yw);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c8.yyyy);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v6.w) * (c10.x) + (c10.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c6.y));
            r0.z = ((r0.z) >= 0.0f ? (c4.w) : (c4.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c8.zz);
                r3.zw = (v6.zz) * (c4.yw);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (-(c8.zz));
                r4.zw = (v6.zz) * (c4.yw);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c9.xy);
                r4.zw = (v6.zz) * (c4.yw);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c9.xy));
                r4.zw = (v6.zz) * (c4.yw);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c8.yyyy);
                r0.z = saturate((v6.w) + (c10.y));
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
    r0.xyz = (r15.xyz) * (c[19].xyz);
    r2.xyz = (r2.www) * (r1.xyz) + (r14.xyz);
    r3.xyz = (r2.www) * (r0.xyz);
    r5.xyz = (r13.xyz) * (r12.xyz);
    r0.z = (-(r8.w)) + (c1.y);
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r11.xyz, r10.xyz);
    r2.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r1.w) * (c3.w);
    r1.xyz = (r10.xyz) * (-(r0.zzz)) + (r11.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r7.www) * (r0.xyz);
    r4.xyz = (r8.xyz) * (r2.www) + (r9.xyz);
    r1.xyz = (r5.xyz) * (r5.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.y;

    return oC0;
}
