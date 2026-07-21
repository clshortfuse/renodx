// Mechanically reconstructed from 0x09C4D3C2.ps_3_0.cso.
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
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD4;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
    float4 v8 : TEXCOORD7;
    float4 v9 : COLOR1;
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
    const float4 c1 = float4(2.0f, -1.0f, 0.200000003f, 0.0f);
    const float4 c3 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c10 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c11 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c12 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c13 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    r6.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r6.xyz, c[17].xyz));
    r7.w = (-(r0.w)) + (-(c1.y));
    r0 = tex2D(s1, v1.xy);
    r7.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0 = tex2D(s6, v7.xy);
    r1.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0 = (c1.xxxx) * (v9) + (c1.yyyy);
    r4.y = dot(r1.xy, r0.zw) + (c1.w);
    r4.x = dot(r1.xy, r0.xy) + (c1.w);
    r0 = tex2D(s7, v1.xy);
    r1 = tex2D(s0, v1.xy);
    r2 = tex2D(s3, v7.xy);
    r8.w = (r2.w) * (v0.y);
    r2.xyz = (r1.xyz) * (-(r0.xxx)) + (r2.xyz);
    r2.w = r0.w;
    r2.xyz = (r8.www) * (r2.xyz);
    r8.xyz = (r1.xyz) * (r0.xxx) + (r2.xyz);
    r2.xy = (v1.zw) * (c10.xy) + (c10.zy);
    r3 = tex2D(s13, r2.xy);
    r2.xy = (v1.zw) * (c10.xy);
    r5 = tex2D(s13, r2.xy);
    r3.w = r5.y;
    r12.xy = lerp(r7.xy, r4.xy, r8.ww);
    r2.xy = (r3.wy) * (c11.xx) + (c11.yy);
    r0.w = dot(r12.xy, r12.xy) + (c1.w);
    r0.z = dot(r2.xy, r2.xy) + (c1.w);
    r0.w = exp2(-(r0.w));
    r0.z = exp2(-(r0.z));
    r0.w = (r0.w) * (c4.x) + (c4.y);
    r1.w = (r0.z) * (c4.x) + (c4.y);
    r0.z = dot(r2.xy, r12.xy) + (c1.w);
    r1.w = (r0.w) * (r1.w);
    r4 = tex2D(s14, v1.zw);
    r2.xy = (r4.xy) * (c10.ww);
    r0.z = saturate((r0.z) * (r1.w) + (r1.w));
    r5.xy = (r5.xz) * (r2.xx);
    r1.w = (r4.x) * (c10.w) + (-(r5.x));
    r3.xy = (r3.xz) * (r2.yy);
    r2.z = (r5.z) * (-(r2.x)) + (r1.w);
    r1.w = (r4.y) * (c10.w) + (-(r3.x));
    r1.w = (r3.z) * (-(r2.y)) + (r1.w);
    r7.y = (r2.z) + (r2.z);
    r2.y = (r1.w) + (r1.w);
    r2.xz = (r3.xy) * (c11.xx);
    r2.xyz = (r0.zzz) * (r2.xyz);
    r7.xz = (r5.xy) * (c11.xx);
    r11.xyz = lerp(r0.yyy, c[8].xyw, r8.www);
    r2.xyz = (r7.xyz) * (r0.www) + (r2.xyz);
    r15.xyz = (r11.yyy) * (r2.xyz);
    r2.xyz = lerp(r1.xyz, c1.zzz, r0.xxx);
    r1 = tex2D(s8, v7.xy);
    r0 = tex2D(s4, v7.zw);
    r3.xyz = (r0.xyz) + (c1.yyy);
    r0 = lerp(r2, r1, r8.wwww);
    r3.xyz = (v0.zzz) * (r3.xyz) + (-(c1.yyy));
    r1 = tex2D(s5, v8.xy);
    r1.xyz = (r1.xyz) + (c1.yyy);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r2.xyz = (v0.www) * (r1.xyz) + (-(c1.yyy));
    r1.xyz = (r0.xyz) * (r2.xyz);
    r0.z = (r7.w) * (r7.w);
    r9.xyz = (r1.xyz) * (-(r1.xyz)) + (-(c1.yyy));
    r0.z = (r0.z) * (r0.z);
    r1.w = (r7.w) * (r0.z);
    r0.xyz = v2.xyz;
    r0.xyz = (r12.xxx) * (v4.xyz) + (r0.xyz);
    r10.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r12.yyy) * (v3.xyz) + (r0.xyz);
    r0.xyz = (r9.xyz) * (r1.www) + (r10.xyz);
    r12.xyz = normalize(r1.xyz);
    r1.w = (r0.w) * (-(c11.z)) + (c11.w);
    r4.w = saturate(dot(r12.xyz, r6.xyz));
    r1.y = (r0.w) * (c4.w);
    r16.xy = (r0.ww) * (c13.xy) + (c13.zw);
    r3.w = exp2(r16.y);
    r6.xyz = (r6.www) * (v6.xyz);
    r6.w = saturate(dot(r12.xyz, -(r6.xyz)));
    r2.w = saturate(dot(r12.xyz, c[17].xyz));
    r1.z = (r6.w) * (r1.w) + (r1.y);
    r1.w = (r2.w) * (r1.w) + (r1.y);
    r1.y = pow(abs(r4.w), r3.w);
    r1.z = (r1.w) * (r1.z) + (c12.x);
    r1.w = (r3.w) * (c12.y) + (c12.z);
    r1.z = 1.0f / (r1.z);
    r1.w = (r1.y) * (r1.w);
    r3.w = (r2.w) * (r1.z);
    r1.xyz = (r8.xyz) * (r3.xyz);
    r1.w = (r1.w) * (r3.w);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r8.xyz = (r1.xyz) * (r1.xyz);
    r13.xyz = (r11.zzz) * (r0.xyz);
    r1 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (-(c1.y)) : (-(c1.w)));
    r14.xyz = (r2.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r1.w = r0.z;
    }
    else
    {
        if ((-(c1.y)) >= (v5.w))
        {
            r2 = (v5.xyzx) * (-(c1.yyyw));
            r1 = (r2) + (-(c15.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r3 = (r2) + (c14.xxyy);
            r3 = tex2Dlod(s2, r3);
            r1.x = r3.x;
            r3 = (r2) + (c14.zzyy);
            r3 = tex2Dlod(s2, r3);
            r1.y = r3.x;
            r2 = (r2) + (c15.xyzz);
            r2 = tex2Dlod(s2, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c12.zzzz);
            if ((c12.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c14.xx);
                r1.zw = (v5.zx) * (-(c1.yw));
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r0.xy) + (c14.zz);
                r2.zw = (v5.zx) * (-(c1.yw));
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (c15.xy);
                r2.zw = (v5.zx) * (-(c1.yw));
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (-(c15.xy));
                r2.zw = (v5.zx) * (-(c1.yw));
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c12.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c16.x) + (c16.y);
                r1.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r1.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c11.x));
            r0.z = ((r0.z) >= 0.0f ? (-(c1.w)) : (-(c1.y)));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c14.xx);
                r2.zw = (v5.zz) * (-(c1.yw));
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c14.zz);
                r3.zw = (v5.zz) * (-(c1.yw));
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c15.xy);
                r3.zw = (v5.zz) * (-(c1.yw));
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c15.xy));
                r3.zw = (v5.zz) * (-(c1.yw));
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c12.zzzz);
                r0.z = saturate((v5.w) + (c14.w));
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
    r2.xyz = (r1.www) * (r14.xyz) + (r15.xyz);
    r0.xyz = (r13.xyz) * (c[19].xyz);
    r3.xyz = (r1.www) * (r0.xyz);
    r0.z = (-(r6.w)) + (-(c1.y));
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r6.xyz, r12.xyz);
    r1.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r0.w = (r0.w) * (c4.z);
    r0.xyz = (r12.xyz) * (-(r0.zzz)) + (r6.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r11.xxx) * (r0.xyz);
    r1.xyz = (r9.xyz) * (r1.www) + (r10.xyz);
    r2.xyz = (r8.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.xyz = (r7.xyz) * (r0.xyz);
    r0.w = dot(c[5].xyz, r6.xyz);
    r0.w = saturate((c[7].y) * (r0.w) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r1.xyz) * (c4.zzz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = -(c1.y);

    return oC0;
}
