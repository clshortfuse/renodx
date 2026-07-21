// Mechanically reconstructed from 0xC270A5F1.ps_3_0.cso.
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
    const float4 c1 = float4(-1.0f, 1.0f, 0.0f, 8.0f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 4.0f);
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

    r0.w = dot(v7.xyz, v7.xyz);
    r4.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r4.www)) + (c[17].xyz);
    r3.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r3.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c1.y);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r5.w = (r0.w) * (r0.z);
    r0 = tex2D(s1, v1.xy);
    r4.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1.w = dot(r4.xy, r4.xy) + (c1.z);
    r0.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c3.xy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1.w = exp2(-(r1.w));
    r5.xy = (r0.wy) * (c7.xx) + (c7.yy);
    r2.w = (r1.w) * (c4.x) + (c4.y);
    r0.w = dot(r5.xy, r4.xy) + (c1.z);
    r1 = tex2D(s14, v1.zw);
    r6.xy = (r1.xy) * (c4.ww);
    r0.y = dot(r5.xy, r5.xy) + (c1.z);
    r5.xy = (r2.xz) * (r6.xx);
    r1.z = exp2(-(r0.y));
    r0.y = (r1.x) * (c4.w) + (-(r5.x));
    r0.y = (r2.z) * (-(r6.x)) + (r0.y);
    r2.xy = (r0.xz) * (r6.yy);
    r1.w = (r1.y) * (c4.w) + (-(r2.x));
    r0.x = (r1.z) * (c4.x) + (c4.y);
    r0.z = (r0.z) * (-(r6.y)) + (r1.w);
    r0.x = (r2.w) * (r0.x);
    r0.w = saturate((r0.w) * (r0.x) + (r0.x));
    r7.y = (r0.y) + (r0.y);
    r0.y = (r0.z) + (r0.z);
    r0.xz = (r2.xy) * (c3.ww);
    r2.xyz = (r0.www) * (r0.xyz);
    r0 = v2;
    r0.xyz = (r4.xxx) * (v5.xyz) + (r0.xyz);
    r7.xz = (r5.xy) * (c3.ww);
    r1.xyz = (r4.yyy) * (v4.xyz) + (r0.xyz);
    r0.xyz = (r7.xyz) * (r2.www) + (r2.xyz);
    r10.xyz = normalize(r1.xyz);
    r14.xyz = (r0.xyz) * (c[5].yyy);
    r4.z = saturate(dot(r10.xyz, r3.xyz));
    r3 = tex2D(s0, v1.xy);
    r2 = tex2D(s3, v8.xy);
    r1 = tex2D(s4, v8.zw);
    r0.xyz = (r1.xyz) + (c1.xxx);
    r12.xyz = (v0.zzz) * (r0.xyz) + (c1.yyy);
    r1 = tex2D(s5, v1.xy);
    r0.xyz = (r12.xyz) * (r1.xyz);
    r8.xyz = (r0.xyz) * (-(r0.xyz)) + (c1.yyy);
    r4.y = (r1.w) * (-(c7.z)) + (c7.w);
    r1.xyz = (r4.www) * (v7.xyz);
    r7.w = saturate(dot(r10.xyz, -(r1.xyz)));
    r4.x = (r1.w) * (c4.z);
    r9.xyz = (r0.xyz) * (r0.xyz);
    r0.y = (r7.w) * (r4.y) + (r4.x);
    r16.xy = (r1.ww) * (c9.xy) + (c9.zw);
    r3.w = saturate(dot(r10.xyz, c[17].xyz));
    r4.w = exp2(r16.y);
    r0.z = (r3.w) * (r4.y) + (r4.x);
    r0.x = pow(abs(r4.z), r4.w);
    r0.z = (r0.z) * (r0.y) + (c8.x);
    r0.y = (r4.w) * (c8.y) + (c8.z);
    r0.z = 1.0f / (r0.z);
    r4.w = (r0.x) * (r0.y);
    r4.z = (r3.w) * (r0.z);
    r0.xyz = (r8.xyz) * (r5.www) + (r9.xyz);
    r4.w = (r4.w) * (r4.z);
    r2.xyz = (r2.xyz) * (v0.yyy);
    r0.xyz = (r0.xyz) * (r4.www);
    r11.xyz = (r2.xyz) * (r2.www) + (r3.xyz);
    r15.xyz = (r0.xyz) * (c[5].www);
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c1.y) : (c1.z));
    r13.xyz = (r3.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c1.y) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c1.yyyz);
            r2 = (r3) + (-(c11.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c10.xxyy);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (c10.zzyy);
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c11.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c8.zzzz);
            if ((c8.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c10.xx);
                r2.zw = (v6.zx) * (c1.yz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c10.zz);
                r3.zw = (v6.zx) * (c1.yz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c11.xy);
                r3.zw = (v6.zx) * (c1.yz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c11.xy));
                r3.zw = (v6.zx) * (c1.yz);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c8.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v6.w) * (c12.x) + (c12.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c3.w));
            r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c10.xx);
                r3.zw = (v6.zz) * (c1.yz);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c10.zz);
                r4.zw = (v6.zz) * (c1.yz);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c11.xy);
                r4.zw = (v6.zz) * (c1.yz);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c11.xy));
                r4.zw = (v6.zz) * (c1.yz);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c8.zzzz);
                r0.z = saturate((v6.w) + (c10.w));
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
    r2.xyz = (r2.www) * (r13.xyz) + (r14.xyz);
    r3.xyz = (r2.www) * (r0.xyz);
    r5.xyz = (r12.xyz) * (r11.xyz);
    r0.z = (-(r7.w)) + (c1.y);
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r1.xyz, r10.xyz);
    r2.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r1.w) * (c1.w);
    r1.xyz = (r10.xyz) * (-(r0.zzz)) + (r1.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[5].xxx);
    r4.xyz = (r8.xyz) * (r2.www) + (r9.xyz);
    r1.xyz = (r5.xyz) * (r5.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.y;

    return oC0;
}
