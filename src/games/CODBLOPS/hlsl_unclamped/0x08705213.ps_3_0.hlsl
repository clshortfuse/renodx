// Mechanically reconstructed from 0x08705213.ps_3_0.cso.
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
    const float4 c1 = float4(0.200000003f, -1.0f, 1.0f, 0.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 31.875f);
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
    r6.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r6.www)) + (c[17].xyz);
    r5.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r5.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c1.z);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r3.w = (r0.w) * (r0.z);
    r0 = tex2D(s1, v1.xy);
    r1 = tex2D(s3, v8.xy);
    r1.xyz = (r1.xyz) + (c1.yyy);
    r11.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r3.xyz = (v0.yyy) * (r1.xyz) + (c1.zzz);
    r1 = tex2D(s5, v1.xy);
    r0 = tex2D(s0, v1.xy);
    r6.xyz = lerp(r0.xyz, c1.xxx, r1.xxx);
    r2 = tex2D(s4, v8.zw);
    r4.xyz = (r2.xyz) + (c1.yyy);
    r2.xyz = (r3.xyz) * (r6.xyz);
    r6.xyz = (v0.zzz) * (r4.xyz) + (c1.zzz);
    r5.w = (r1.w) * (-(c7.z)) + (c7.w);
    r2.xyz = (r2.xyz) * (r6.xyz);
    r9.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.zzz);
    r10.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r1.xxx) * (r0.xyz);
    r4.xyz = (r9.xyz) * (r3.www) + (r10.xyz);
    r3.xyz = (r3.xyz) * (r0.xyz);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r0 = tex2D(s13, r0.xy);
    r2.xy = (v1.zw) * (c4.xy);
    r2 = tex2D(s13, r2.xy);
    r0.w = r2.y;
    r3.xyz = (r6.xyz) * (r3.xyz);
    r6.xy = (r0.wy) * (c7.xx) + (c7.yy);
    r0.y = dot(r11.xy, r11.xy) + (c1.w);
    r0.w = dot(r6.xy, r6.xy) + (c1.w);
    r0.y = exp2(-(r0.y));
    r0.w = exp2(-(r0.w));
    r4.w = (r0.y) * (c3.x) + (c3.y);
    r0.y = (r0.w) * (c3.x) + (c3.y);
    r0.w = dot(r6.xy, r11.xy) + (c1.w);
    r0.y = (r4.w) * (r0.y);
    r8.xyz = (r3.xyz) * (r3.xyz);
    r1.z = saturate((r0.w) * (r0.y) + (r0.y));
    r3 = tex2D(s14, v1.zw);
    r7.xy = (r3.xy) * (c4.ww);
    r6.xy = (r2.xz) * (r7.xx);
    r0.xy = (r0.xz) * (r7.yy);
    r1.x = (r3.x) * (c4.w) + (-(r6.x));
    r0.w = (r3.y) * (c4.w) + (-(r0.x));
    r1.x = (r2.z) * (-(r7.x)) + (r1.x);
    r0.w = (r0.z) * (-(r7.y)) + (r0.w);
    r7.y = (r1.x) + (r1.x);
    r3.y = (r0.w) + (r0.w);
    r3.xz = (r0.xy) * (c7.xx);
    r0 = v2;
    r2.xyz = (r11.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r1.zzz) * (r3.xyz);
    r2.xyz = (r11.yyy) * (v4.xyz) + (r2.xyz);
    r11.xyz = normalize(r2.xyz);
    r12.xyz = (r6.www) * (v7.xyz);
    r1.x = saturate(dot(r11.xyz, -(r12.xyz)));
    r2.y = (r1.w) * (c3.w);
    r3.z = saturate(dot(r11.xyz, r5.xyz));
    r2.z = (r1.x) * (r5.w) + (r2.y);
    r16.xy = (r1.ww) * (c9.xy) + (c9.zw);
    r1.z = saturate(dot(r11.xyz, c[17].xyz));
    r3.w = exp2(r16.y);
    r2.w = (r1.z) * (r5.w) + (r2.y);
    r2.y = pow(abs(r3.z), r3.w);
    r2.z = (r2.w) * (r2.z) + (c8.x);
    r2.w = (r3.w) * (c8.y) + (c8.z);
    r2.z = 1.0f / (r2.z);
    r2.w = (r2.y) * (r2.w);
    r2.z = (r1.z) * (r2.z);
    r7.xz = (r6.xy) * (c7.xx);
    r2.w = (r2.w) * (r2.z);
    r0.xyz = (r7.xyz) * (r4.www) + (r0.xyz);
    r2.xyz = (r4.xyz) * (r2.www);
    r13.xyz = (r1.yyy) * (r2.xyz);
    r15.xyz = (r1.yyy) * (r0.xyz);
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c1.z) : (c1.w));
    r14.xyz = (r1.zzz) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r1.z = r0.z;
    }
    else
    {
        if ((c1.z) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c1.zzzw);
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
            r1.z = dot(r2, c8.zzzz);
            if ((c8.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c10.xx);
                r2.zw = (v6.zx) * (c1.zw);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c10.zz);
                r3.zw = (v6.zx) * (c1.zw);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c11.xy);
                r3.zw = (v6.zx) * (c1.zw);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c11.xy));
                r3.zw = (v6.zx) * (c1.zw);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.z = dot(r2, c8.zzzz);
                r0.y = (-(r1.z)) + (r0.z);
                r0.z = (v6.w) * (c12.x) + (c12.y);
                r1.z = (r0.z) * (r0.y) + (r1.z);
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c7.x));
            r0.z = ((r0.z) >= 0.0f ? (c1.w) : (c1.z));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c10.xx);
                r3.zw = (v6.zz) * (c1.zw);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c10.zz);
                r4.zw = (v6.zz) * (c1.zw);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c11.xy);
                r4.zw = (v6.zz) * (c1.zw);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c11.xy));
                r4.zw = (v6.zz) * (c1.zw);
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
            r1.z = r0.z;
        }
    }
    r3.xyz = (r1.zzz) * (r14.xyz) + (r15.xyz);
    r4.xyz = (r13.xyz) * (c[19].xyz);
    r0.z = (-(r1.x)) + (c1.z);
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r12.xyz, r11.xyz);
    r1.x = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r1.w) * (c3.z);
    r2.xyz = (r11.xyz) * (-(r0.zzz)) + (r12.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r2.xyz = (r9.xyz) * (r1.xxx) + (r10.xyz);
    r1.xyz = (r1.zzz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r1.xyz = (r8.xyz) * (r3.xyz) + (r1.xyz);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.zzz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[5].w;

    return oC0;
}
