// Mechanically reconstructed from 0xD3A952EC.ps_3_0.cso.
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
    const float4 c1 = float4(2.0f, -1.0f, 0.200000003f, 0.0f);
    const float4 c3 = float4(-0.5f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c4 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c8 = float4(0.797884583f, 1.0f, 0.5f, 0.0f);
    const float4 c9 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c10 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c11 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
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
    r6.z = rsqrt(r0.w);
    r0.xyz = (v6.xyz) * (-(r6.zzz)) + (c[17].xyz);
    r5.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r5.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (-(c1.y));
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r6.w = (r0.w) * (r0.z);
    r0 = tex2D(s1, v0.xy);
    r6.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s4, v7.zw);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c1.xxxx) * (v8) + (c1.yyyy);
    r3.y = dot(r1.xy, r0.zw) + (c1.w);
    r3.x = dot(r1.xy, r0.xy) + (c1.w);
    r0 = tex2D(s0, v0.xy);
    r1 = tex2D(s3, v7.zw);
    r5.w = (r1.w) * (v7.y) + (c3.x);
    r2.xy = (v0.zw) * (c8.yz) + (c8.wz);
    r2 = tex2D(s13, r2.xy);
    r4.xy = (v0.zw) * (c8.yz);
    r4 = tex2D(s13, r4.xy);
    r2.w = r4.y;
    r6.xy = float2(((r5.w) >= 0.0f ? (r3.x) : (r6.x)), ((r5.w) >= 0.0f ? (r3.y) : (r6.y)));
    r3.xy = (r2.wy) * (c4.yy) + (c4.zz);
    r0.w = dot(r6.xy, r6.xy) + (c1.w);
    r1.w = dot(r3.xy, r3.xy) + (c1.w);
    r0.w = exp2(-(r0.w));
    r1.w = exp2(-(r1.w));
    r0.w = (r0.w) * (c3.y) + (c3.z);
    r2.w = (r1.w) * (c3.y) + (c3.z);
    r1.w = dot(r3.xy, r6.xy) + (c1.w);
    r2.w = (r0.w) * (r2.w);
    r3 = tex2D(s14, v0.zw);
    r7.xy = (r3.xy) * (c4.xx);
    r1.w = saturate((r1.w) * (r2.w) + (r2.w));
    r4.xy = (r4.xz) * (r7.xx);
    r2.w = (r3.x) * (c4.x) + (-(r4.x));
    r8.xy = (r2.xz) * (r7.yy);
    r2.y = (r4.z) * (-(r7.x)) + (r2.w);
    r2.w = (r3.y) * (c4.x) + (-(r8.x));
    r2.w = (r2.z) * (-(r7.y)) + (r2.w);
    r7.y = (r2.y) + (r2.y);
    r2.y = (r2.w) + (r2.w);
    r2.xz = (r8.xy) * (c4.yy);
    r3.xyz = (r1.www) * (r2.xyz);
    r7.xz = (r4.xy) * (c4.yy);
    r2 = tex2D(s5, v0.xy);
    r4.xyz = (r0.xyz) * (r2.xxx);
    r3.xyz = (r7.xyz) * (r0.www) + (r3.xyz);
    r4.xyz = float3(((r5.w) >= 0.0f ? (r1.x) : (r4.x)), ((r5.w) >= 0.0f ? (r1.y) : (r4.y)), ((r5.w) >= 0.0f ? (r1.z) : (r4.z)));
    r1.w = r2.w;
    r1.xyz = lerp(r0.xyz, c1.zzz, r2.xxx);
    r0 = tex2D(s6, v7.zw);
    r1 = float4(((r5.w) >= 0.0f ? (r0.x) : (r1.x)), ((r5.w) >= 0.0f ? (r0.y) : (r1.y)), ((r5.w) >= 0.0f ? (r0.z) : (r1.z)), ((r5.w) >= 0.0f ? (r0.w) : (r1.w)));
    r8.xyz = (r4.xyz) * (r4.xyz);
    r9.xyz = (r1.xyz) * (-(r1.xyz)) + (-(c1.yyy));
    r10.xyz = (r1.xyz) * (r1.xyz);
    r0 = v1;
    r0.xyz = (r6.xxx) * (v4.xyz) + (r0.xyz);
    r2.x = (r1.w) * (-(c8.x)) + (c8.y);
    r0.xyz = (r6.yyy) * (v3.xyz) + (r0.xyz);
    r1.xyz = normalize(r0.xyz);
    r12.xyz = (r6.zzz) * (v6.xyz);
    r7.w = saturate(dot(r1.xyz, -(r12.xyz)));
    r0.z = (r1.w) * (c8.x);
    r2.z = saturate(dot(r1.xyz, r5.xyz));
    r0.y = (r7.w) * (r2.x) + (r0.z);
    r16.xy = (r1.ww) * (c9.xy) + (c9.zw);
    r3.w = saturate(dot(r1.xyz, c[17].xyz));
    r2.w = exp2(r16.y);
    r0.z = (r3.w) * (r2.x) + (r0.z);
    r0.x = pow(abs(r2.z), r2.w);
    r0.z = (r0.z) * (r0.y) + (c4.w);
    r0.y = (r2.w) * (c10.x) + (c10.y);
    r0.z = 1.0f / (r0.z);
    r2.w = (r0.x) * (r0.y);
    r2.z = (r3.w) * (r0.z);
    r0.xyz = (r9.xyz) * (r6.www) + (r10.xyz);
    r2.w = (r2.w) * (r2.z);
    r11.xyz = float3(((r5.w) >= 0.0f ? (c[5].x) : (r2.y)), ((r5.w) >= 0.0f ? (c[5].y) : (r2.y)), ((r5.w) >= 0.0f ? (c[5].w) : (r2.y)));
    r0.xyz = (r0.xyz) * (r2.www);
    r15.xyz = (r3.xyz) * (r11.yyy);
    r13.xyz = (r11.zzz) * (r0.xyz);
    r2 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (-(c1.y)) : (-(c1.w)));
    r14.xyz = (r3.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r2.w = r0.z;
    }
    else
    {
        if ((-(c1.y)) >= (v5.w))
        {
            r3 = (v5.xyzx) * (-(c1.yyyw));
            r2 = (r3) + (-(c11.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c10.zzww);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (-(c10.zzww));
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c11.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c10.yyyy);
            if ((c11.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c10.zz);
                r2.zw = (v5.zx) * (-(c1.yw));
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (-(c10.zz));
                r3.zw = (v5.zx) * (-(c1.yw));
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c11.xy);
                r3.zw = (v5.zx) * (-(c1.yw));
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c11.xy));
                r3.zw = (v5.zx) * (-(c1.yw));
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c10.yyyy);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c12.x) + (c12.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c4.y));
            r0.z = ((r0.z) >= 0.0f ? (-(c1.w)) : (-(c1.y)));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c10.zz);
                r3.zw = (v5.zz) * (-(c1.yw));
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (-(c10.zz));
                r4.zw = (v5.zz) * (-(c1.yw));
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c11.xy);
                r4.zw = (v5.zz) * (-(c1.yw));
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c11.xy));
                r4.zw = (v5.zz) * (-(c1.yw));
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c10.yyyy);
                r0.z = saturate((v5.w) + (c12.y));
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
    r2.xyz = (r2.www) * (r14.xyz) + (r15.xyz);
    r4.xyz = (r13.xyz) * (c[19].xyz);
    r0.z = (-(r7.w)) + (-(c1.y));
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r12.xyz, r1.xyz);
    r3.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r1.w) * (c3.w);
    r1.xyz = (r1.xyz) * (-(r0.zzz)) + (r12.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r11.xxx) * (r0.xyz);
    r3.xyz = (r9.xyz) * (r3.www) + (r10.xyz);
    r1.xyz = (r2.www) * (r4.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r8.xyz) * (r2.xyz) + (r1.xyz);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[6].w;

    return oC0;
}
