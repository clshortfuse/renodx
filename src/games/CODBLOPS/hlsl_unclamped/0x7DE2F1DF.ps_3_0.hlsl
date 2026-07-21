// Mechanically reconstructed from 0x7DE2F1DF.ps_3_0.cso.
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
sampler2D s10 : register(s10);
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
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c12 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c31 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c32 = float4(2.0f, -1.0f, 0.0f, 1.0f);
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
    float4 r17 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s7, v7.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c32.xxxx) * (v9) + (c32.yyyy);
    r2.y = dot(r1.xy, r0.zw) + (c32.z);
    r2.x = dot(r1.xy, r0.xy) + (c32.z);
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r1 = tex2D(s0, v1.xy);
    r0 = tex2D(s4, v7.xy);
    r3.w = (r0.w) * (v0.y);
    r5.xyz = lerp(r1.xyz, r0.xyz, r3.www);
    r6.xy = lerp(r3.xy, r2.xy, r3.ww);
    r1 = tex2D(s8, v1.xy);
    r0 = tex2D(s9, v7.xy);
    r2 = lerp(r1, r0, r3.wwww);
    r0.xyw = c[27].xyw;
    r1.xyz = (-(r0.xyw)) + (c[28].xyw);
    r0 = tex2D(s5, v7.zw);
    r4.w = (r0.w) * (v0.z);
    r4.xyz = (r3.www) * (r1.xyz) + (c[27].xyw);
    r3.xyz = lerp(r5.xyz, r0.xyz, r4.www);
    r1 = tex2D(s10, v7.zw);
    r0 = lerp(r2, r1, r4.wwww);
    r1 = tex2D(s6, v8.xy);
    r1.xyz = (r1.xyz) + (c32.yyy);
    r13.xyz = lerp(r4.xyz, c[29].xyw, r4.www);
    r1.xyz = (v0.www) * (r1.xyz) + (c32.www);
    r7.xy = (r4.ww) * (-(r6.xy)) + (r6.xy);
    r4.xyz = (r0.xyz) * (r1.xyz);
    r0.xyz = (r3.xyz) * (r1.xyz);
    r1.w = dot(r7.xy, r7.xy) + (c32.z);
    r10.xyz = (r0.xyz) * (r0.xyz);
    r0.z = exp2(-(r1.w));
    r4.w = (r0.z) * (c3.x) + (c3.y);
    r0.xy = (v1.zw) * (c4.xy);
    r3 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r1 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v1.zw);
    r6.xy = (r2.xy) * (c4.ww);
    r3.w = r1.y;
    r5.xy = (r3.xz) * (r6.xx);
    r3.xy = (r3.yw) * (c12.xx) + (c12.yy);
    r0.y = (r2.x) * (c4.w) + (-(r5.x));
    r0.z = dot(r3.xy, r7.xy) + (c32.z);
    r1.y = (r3.z) * (-(r6.x)) + (r0.y);
    r0.xy = (r1.xz) * (r6.yy);
    r1.w = dot(r3.xy, r3.xy) + (c32.z);
    r1.x = (r2.y) * (c4.w) + (-(r0.x));
    r1.w = exp2(-(r1.w));
    r1.z = (r1.z) * (-(r6.y)) + (r1.x);
    r1.w = (r1.w) * (c3.x) + (c3.y);
    r8.y = (r1.y) + (r1.y);
    r1.w = (r4.w) * (r1.w);
    r1.y = (r1.z) + (r1.z);
    r1.w = saturate((r0.z) * (r1.w) + (r1.w));
    r0.z = dot(v6.xyz, v6.xyz);
    r2.xyz = (-(v6.xyz)) + (c[5].xyz);
    r2.w = rsqrt(r0.z);
    r0.z = dot(r2.xyz, r2.xyz);
    r3.w = rsqrt(r0.z);
    r6.xyz = (r2.www) * (v6.xyz);
    r1.xz = (r0.xy) * (c12.xx);
    r3.xyz = (r2.xyz) * (r3.www) + (-(r6.xyz));
    r0.xyz = normalize(r3.xyz);
    r9.xyz = (r2.xyz) * (r3.www);
    r1.xyz = (r1.xyz) * (r1.www);
    r1.w = saturate(dot(r0.xyz, r9.xyz));
    r14.xyz = (r4.xyz) * (-(r4.xyz)) + (c32.www);
    r1.w = (-(r1.w)) + (c32.w);
    r9.w = (r0.w) * (-(c12.z)) + (c12.w);
    r2.z = (r1.w) * (r1.w);
    r3.w = (r2.z) * (r2.z);
    r2.xyz = v2.xyz;
    r2.xyz = (r7.xxx) * (v4.xyz) + (r2.xyz);
    r3.z = (r1.w) * (r3.w);
    r2.xyz = (r7.yyy) * (v3.xyz) + (r2.xyz);
    r15.xyz = (r4.xyz) * (r4.xyz);
    r16.xyz = normalize(r2.xyz);
    r3.w = saturate(dot(r16.xyz, r0.xyz));
    r10.w = (r0.w) * (c3.w);
    r2.z = saturate(dot(r9.xyz, r16.xyz));
    r1.w = saturate(dot(r16.xyz, -(r6.xyz)));
    r0.z = (r2.z) * (r9.w) + (r10.w);
    r8.w = (r1.w) * (r9.w) + (r10.w);
    r0.z = (r0.z) * (r8.w) + (c13.x);
    r2.xy = (r0.ww) * (c31.xy) + (c31.zw);
    r0.y = 1.0f / (r0.z);
    r7.w = exp2(r2.y);
    r0.z = pow(abs(r3.w), r7.w);
    r5.w = (r7.w) * (c13.y) + (c13.z);
    r3.w = (r2.z) * (r0.y);
    r2.y = (r0.z) * (r5.w);
    r0.xyz = (r14.xyz) * (r3.zzz) + (r15.xyz);
    r2.y = (r3.w) * (r2.y);
    r8.xz = (r5.xy) * (c12.xx);
    r0.xyz = (r0.xyz) * (r2.yyy);
    r1.xyz = (r8.xyz) * (r4.www) + (r1.xyz);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r12.xyz = (r13.yyy) * (r1.xyz);
    r1.xyz = (r13.zzz) * (r0.xyz);
    r0.xyz = (r2.zzz) * (c[6].xyz);
    r1.w = (-(r1.w)) + (c32.w);
    r5.xyz = (r10.xyz) * (r0.xyz) + (r1.xyz);
    r0.z = (r1.w) * (r1.w);
    r0.y = 1.0f / (r2.x);
    r0.z = (r1.w) * (r0.z);
    r1.w = (r0.y) * (r0.z);
    r0.w = (r0.w) * (c3.z);
    r0.xyz = (v6.xyz) * (-(r2.www)) + (c[17].xyz);
    r1.z = dot(r6.xyz, r16.xyz);
    r17.xyz = normalize(r0.xyz);
    r0.z = (r1.z) + (r1.z);
    r11.w = saturate(dot(r17.xyz, c[17].xyz));
    r0.xyz = (r16.xyz) * (-(r0.zzz)) + (r6.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r13.xxx) * (r0.xyz);
    r1.xyz = (r14.xyz) * (r1.www) + (r15.xyz);
    r7.xyz = (r0.xyz) * (r1.xyz);
    r6.w = saturate(dot(r16.xyz, c[17].xyz));
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c32.w) : (c32.z));
    r11.xyz = (r6.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((c32.w) >= (v5.w))
        {
            r1 = (v5.xyzx) * (c32.wwwz);
            r0 = (r1) + (-(c15.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r2 = (r1) + (c14.xxyy);
            r2 = tex2Dlod(s2, r2);
            r0.x = r2.x;
            r2 = (r1) + (c14.zzyy);
            r2 = tex2Dlod(s2, r2);
            r0.y = r2.x;
            r1 = (r1) + (c15.xyzz);
            r1 = tex2Dlod(s2, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c13.zzzz);
            if ((c13.w) < (v5.w))
            {
                r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c14.xx);
                r0.zw = (v5.zx) * (c32.wz);
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (c14.zz);
                r1.zw = (v5.zx) * (c32.wz);
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c15.xy);
                r1.zw = (v5.zx) * (c32.wz);
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c15.xy));
                r1.zw = (v5.zx) * (c32.wz);
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c13.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v5.w) * (c16.x) + (c16.y);
                r0.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r0.w = r4.w;
            }
        }
        else
        {
            r0.w = (v5.w) + (-(c12.x));
            r0.w = ((r0.w) >= 0.0f ? (c32.z) : (c32.w));
            if ((r0.w) != (-(r0.w)))
            {
                r13.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r13.xy) + (c14.xx);
                r1.zw = (v5.zz) * (c32.wz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r13.xy) + (c14.zz);
                r2.zw = (v5.zz) * (c32.wz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r13.xy) + (c15.xy);
                r2.zw = (v5.zz) * (c32.wz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r13.xy) + (-(c15.xy));
                r2.zw = (v5.zz) * (c32.wz);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c13.zzzz);
                r0.w = saturate((v5.w) + (c14.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
        }
    }
    r0.z = (-(r11.w)) + (c32.w);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.y) * (r0.y);
    r0.z = (r0.z) * (r0.y);
    r0.y = (r6.w) * (r9.w) + (r10.w);
    r0.y = (r0.y) * (r8.w) + (c13.x);
    r1.w = saturate(dot(r16.xyz, r17.xyz));
    r0.x = 1.0f / (r0.y);
    r0.y = pow(abs(r1.w), r7.w);
    r0.x = (r6.w) * (r0.x);
    r0.y = (r5.w) * (r0.y);
    r1.w = (r0.x) * (r0.y);
    r0.xyz = (r14.xyz) * (r0.zzz) + (r15.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r13.zzz) * (r0.xyz);
    r1.xyz = (r0.xyz) * (c[19].xyz);
    r0.xyz = (r0.www) * (r11.xyz) + (r12.xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r1.xyz = (r10.xyz) * (r0.xyz) + (r1.xyz);
    r0.w = dot(r9.xyz, c[22].xyz);
    r0.xyz = (r8.xyz) * (r7.xyz);
    r0.w = saturate((r0.w) * (c[23].x) + (c[23].y));
    r2.xyz = (r0.xyz) * (c3.zzz) + (r1.xyz);
    r1.z = (r0.w) * (c16.z) + (c16.w);
    r1.w = (r0.w) * (r0.w);
    r0 = (v6.xyzx) * (c32.wwwz) + (c32.zzzw);
    r1.w = (r1.z) * (r1.w);
    r1.z = dot(r0, c[21]);
    r1.z = 1.0f / (r1.z);
    r3.x = dot(r0, c[20]);
    r1.x = dot(r0, c[10]);
    r3.y = (r3.x) * (r3.x);
    r1.y = dot(r0, c[11]);
    r0.w = dot(c[8].yz, r3.xy) + (c[8].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r3.xy = (r0.xy) * (c16.zz) + (c16.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c32.z) : (r0.z));
    r0.z = (r3.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r3.y)) + (c32.w);
    r0.xy = (r1.zz) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r1.w = (r1.w) * (r0.w);
    r0.xy = (r0.xy) * (c4.yy) + (c4.yy);
    r0 = tex2D(s3, r0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r1.www) * (r0.xyz);
    r0.w = dot(c[24].xyz, r6.xyz);
    r0.w = saturate((c[26].y) * (r0.w) + (c[26].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[25].xyz);
    r1.xyz = (r1.xyz) * (r5.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c32.w;

    return oC0;
}
