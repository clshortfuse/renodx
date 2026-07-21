// Mechanically reconstructed from 0x2376C131.ps_3_0.cso.
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
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c12 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(2.0f, -1.0f, 1.0f, 0.0f);
    const float4 c34 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c35 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    float4 r18 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s7, v7.zw);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c16.xxxx) * (v8) + (c16.yyyy);
    r2.y = dot(r1.xy, r0.zw) + (c16.w);
    r2.x = dot(r1.xy, r0.xy) + (c16.w);
    r0 = tex2D(s1, v1.xy);
    r1 = tex2D(s5, v7.xy);
    r1.xyz = (r1.xyz) + (c16.yyy);
    r4.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r3.xyz = (v0.yyy) * (r1.xyz) + (c16.zzz);
    r0 = tex2D(s0, v1.xy);
    r1 = tex2D(s6, v7.zw);
    r4.w = (r1.w) * (v0.z);
    r1.xyz = (r0.xyz) * (-(r3.xyz)) + (r1.xyz);
    r1.xyz = (r4.www) * (r1.xyz);
    r5.xy = lerp(r4.xy, r2.xy, r4.ww);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r1.xyz);
    r0.w = dot(r5.xy, r5.xy) + (c16.w);
    r9.xyz = (r0.xyz) * (r0.xyz);
    r0.w = exp2(-(r0.w));
    r3.w = (r0.w) * (c3.x) + (c3.y);
    r0.xy = (v1.zw) * (c4.xy);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r1 = tex2D(s14, v1.zw);
    r6.xy = (r1.xy) * (c4.ww);
    r7.xy = (r2.yw) * (c12.xx) + (c12.yy);
    r2.xy = (r2.xz) * (r6.xx);
    r0.w = dot(r7.xy, r5.xy) + (c16.w);
    r0.y = (r1.x) * (c4.w) + (-(r2.x));
    r1.w = (r2.z) * (-(r6.x)) + (r0.y);
    r4.xy = (r0.xz) * (r6.yy);
    r0.y = (r1.y) * (c4.w) + (-(r4.x));
    r0.x = dot(r7.xy, r7.xy) + (c16.w);
    r0.y = (r0.z) * (-(r6.y)) + (r0.y);
    r0.z = exp2(-(r0.x));
    r6.y = (r1.w) + (r1.w);
    r0.z = (r0.z) * (c3.x) + (c3.y);
    r0.y = (r0.y) + (r0.y);
    r0.z = (r3.w) * (r0.z);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r0.xz = (r4.xy) * (c12.xx);
    r0.xyz = (r0.xyz) * (r0.www);
    r6.xz = (r2.xy) * (c12.xx);
    r2.xyz = (r6.xyz) * (r3.www) + (r0.xyz);
    r0.w = dot(v6.xyz, v6.xyz);
    r1.w = rsqrt(r0.w);
    r1.xyz = (-(v6.xyz)) + (c[5].xyz);
    r0.xyz = (v6.xyz) * (-(r1.www)) + (c[17].xyz);
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r7.xyz = (r1.www) * (v6.xyz);
    r18.xyz = normalize(r0.xyz);
    r4.xyz = (r1.xyz) * (r0.www) + (-(r7.xyz));
    r0.xyz = normalize(r4.xyz);
    r8.xyz = (r1.xyz) * (r0.www);
    r11.w = saturate(dot(r18.xyz, c[17].xyz));
    r0.w = saturate(dot(r0.xyz, r8.xyz));
    r0.w = (-(r0.w)) + (c16.z);
    r1.xyz = v2.xyz;
    r1.xyz = (r5.xxx) * (v4.xyz) + (r1.xyz);
    r1.w = (r0.w) * (r0.w);
    r1.xyz = (r5.yyy) * (v3.xyz) + (r1.xyz);
    r1.w = (r1.w) * (r1.w);
    r17.xyz = normalize(r1.xyz);
    r1.y = (r0.w) * (r1.w);
    r1.w = saturate(dot(r17.xyz, r0.xyz));
    r0 = tex2D(s8, v1.xy);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r15.xyz = (r0.xyz) * (-(r0.xyz)) + (c16.zzz);
    r16.xyz = (r0.xyz) * (r0.xyz);
    r9.w = (r0.w) * (-(c12.z)) + (c12.w);
    r10.w = (r0.w) * (c3.w);
    r3.w = saturate(dot(r8.xyz, r17.xyz));
    r2.w = saturate(dot(r17.xyz, -(r7.xyz)));
    r0.z = (r3.w) * (r9.w) + (r10.w);
    r8.w = (r2.w) * (r9.w) + (r10.w);
    r0.z = (r0.z) * (r8.w) + (c13.x);
    r3.xy = (r0.ww) * (c35.xy) + (c35.zw);
    r0.y = 1.0f / (r0.z);
    r7.w = exp2(r3.y);
    r0.z = pow(abs(r1.w), r7.w);
    r5.w = (r7.w) * (c13.y) + (c13.z);
    r1.z = (r3.w) * (r0.y);
    r1.w = (r0.z) * (r5.w);
    r0.xyz = (r15.xyz) * (r1.yyy) + (r16.xyz);
    r3.z = (r1.z) * (r1.w);
    r1.zw = c16.zw;
    r1.xyz = (r1.wzw) + (-(c[32].xyw));
    r0.xyz = (r0.xyz) * (r3.zzz);
    r14.xyz = (r4.www) * (r1.xyz) + (c[32].xyw);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r1.xyz = (r14.zzz) * (r0.xyz);
    r0.xyz = (r3.www) * (c[6].xyz);
    r13.xyz = (r2.xyz) * (r14.yyy);
    r5.xyz = (r9.xyz) * (r0.xyz) + (r1.xyz);
    r1.z = 1.0f / (r3.x);
    r0.y = (-(r2.w)) + (c16.z);
    r0.x = (r0.y) * (r0.y);
    r0.z = dot(r7.xyz, r17.xyz);
    r1.w = (r0.y) * (r0.x);
    r0.z = (r0.z) + (r0.z);
    r0.w = (r0.w) * (c3.z);
    r0.xyz = (r17.xyz) * (-(r0.zzz)) + (r7.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r1.z) * (r1.w);
    r10.xyz = (r14.xxx) * (r0.xyz);
    r11.xyz = (r15.xyz) * (r0.www) + (r16.xyz);
    r6.w = saturate(dot(r17.xyz, c[17].xyz));
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c16.z) : (c16.w));
    r12.xyz = (r6.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((c16.z) >= (v5.w))
        {
            r1 = (v5.xyzx) * (c16.zzzw);
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
                r0.zw = (v5.zx) * (c16.zw);
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (c14.zz);
                r1.zw = (v5.zx) * (c16.zw);
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c15.xy);
                r1.zw = (v5.zx) * (c16.zw);
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c15.xy));
                r1.zw = (v5.zx) * (c16.zw);
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c13.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v5.w) * (c34.x) + (c34.y);
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
            r0.w = ((r0.w) >= 0.0f ? (c16.w) : (c16.z));
            if ((r0.w) != (-(r0.w)))
            {
                r14.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r14.xy) + (c14.xx);
                r1.zw = (v5.zz) * (c16.zw);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r14.xy) + (c14.zz);
                r2.zw = (v5.zz) * (c16.zw);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r14.xy) + (c15.xy);
                r2.zw = (v5.zz) * (c16.zw);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r14.xy) + (-(c15.xy));
                r2.zw = (v5.zz) * (c16.zw);
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
    r0.z = (-(r11.w)) + (c16.z);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.y) * (r0.y);
    r0.z = (r0.z) * (r0.y);
    r0.y = (r6.w) * (r9.w) + (r10.w);
    r0.y = (r0.y) * (r8.w) + (c13.x);
    r1.w = saturate(dot(r17.xyz, r18.xyz));
    r0.x = 1.0f / (r0.y);
    r0.y = pow(abs(r1.w), r7.w);
    r0.x = (r6.w) * (r0.x);
    r0.y = (r5.w) * (r0.y);
    r1.w = (r0.x) * (r0.y);
    r0.xyz = (r15.xyz) * (r0.zzz) + (r16.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r14.zzz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[19].xyz);
    r1.xyz = (r0.www) * (r12.xyz) + (r13.xyz);
    r2.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r10.xyz) * (r11.xyz);
    r2.xyz = (r9.xyz) * (r1.xyz) + (r2.xyz);
    r1.xyz = (r6.xyz) * (r0.xyz);
    r0 = (v6.yyyy) * (c[25]);
    r6.xyz = (r1.xyz) * (c3.zzz) + (r2.xyz);
    r0 = (v6.xxxx) * (c[24]) + (r0);
    r1.w = dot(r8.xyz, c[22].xyz);
    r0 = (v6.zzzz) * (c[26]) + (r0);
    r1.w = saturate((r1.w) * (c[23].x) + (c[23].y));
    r3 = (r0) + (c[27]);
    r0.z = (r1.w) * (c34.z) + (c34.w);
    r2.zw = r3.zw;
    r0.w = (r1.w) * (r1.w);
    r4.zw = r2.zw;
    r3.z = (r0.z) * (r0.w);
    r1.zw = r4.zw;
    r0.xy = (r3.ww) * (-(c[28].zw)) + (r3.xy);
    r0.zw = r1.zw;
    r0 = tex2Dproj(s3, r0);
    r0.w = r0.x;
    r4.xy = (r2.ww) * (-(c[28].xy)) + (r3.xy);
    r4 = tex2Dproj(s3, r4);
    r0.y = r4.x;
    r2.xy = (r2.ww) * (c[28].xy) + (r3.xy);
    r4 = tex2Dproj(s3, r2);
    r0.x = r4.x;
    r1.xy = (r2.ww) * (c[28].zw) + (r3.xy);
    r2 = tex2Dproj(s3, r1);
    r1 = (v6.xyzx) * (c16.zzzw) + (c16.wwwz);
    r0.z = r2.x;
    r2.w = dot(r1, c[21]);
    r2.w = 1.0f / (r2.w);
    r3.x = dot(r1, c[20]);
    r2.x = dot(r1, c[10]);
    r3.y = (r3.x) * (r3.x);
    r2.y = dot(r1, c[11]);
    r1.w = dot(c[8].yz, r3.xy) + (c[8].x);
    r1.z = saturate(1.0f / (r1.w));
    r1.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r3.xy = (r1.xy) * (c34.zz) + (c34.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r1.w = ((-abs(r1.w)) >= 0.0f ? (c16.w) : (r1.z));
    r1.z = (r3.x) * (r1.x);
    r1.w = (r1.w) * (r1.z);
    r1.z = (r1.y) * (-(r3.y)) + (c16.z);
    r1.xy = (r2.ww) * (r2.xy);
    r1.w = (r1.w) * (r1.z);
    r2.w = (r3.z) * (r1.w);
    r1.xy = (r1.xy) * (c4.yy) + (c4.yy);
    r1 = tex2D(s4, r1.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = dot(r0, c13.zzzz);
    r0.xyz = (r2.www) * (r1.xyz);
    r1.xyz = (r0.www) * (r0.xyz);
    r0.w = dot(c[29].xyz, r7.xyz);
    r0.w = saturate((c[31].y) * (r0.w) + (c[31].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[30].xyz);
    r1.xyz = (r1.xyz) * (r5.xyz) + (r6.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[33].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c16.z;

    return oC0;
}
