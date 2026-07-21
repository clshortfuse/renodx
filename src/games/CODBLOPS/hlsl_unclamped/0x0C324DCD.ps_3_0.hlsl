// Mechanically reconstructed from 0x0C324DCD.ps_3_0.cso.
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
    const float4 c3 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c12 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c16 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c33 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c34 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c35 = float4(2.0f, -1.0f, 1.0f, 0.200000003f);
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

    r0 = tex2D(s7, v7.zw);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c35.xxxx) * (v8) + (c35.yyyy);
    r4.y = dot(r1.xy, r0.zw) + (c3.x);
    r4.x = dot(r1.xy, r0.xy) + (c3.x);
    r1 = tex2D(s1, v1.xy);
    r0 = tex2D(s5, v7.xy);
    r0.xyz = (r0.xyz) + (c35.yyy);
    r3.xyz = (v0.yyy) * (r0.xyz) + (c35.zzz);
    r0 = tex2D(s0, v1.xy);
    r2 = tex2D(s6, v7.zw);
    r5.w = (r2.w) * (v0.z);
    r2.xyz = (r0.xyz) * (-(r3.xyz)) + (r2.xyz);
    r5.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r1.xyz = (r5.www) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r1.xyz);
    r9.xy = lerp(r5.xy, r4.xy, r5.ww);
    r10.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(v6.xyz, v6.xyz);
    r6.w = dot(r9.xy, r9.xy) + (c3.x);
    r14.w = rsqrt(r0.w);
    r2 = tex2D(s8, v1.xy);
    r4.w = r2.w;
    r1 = tex2D(s9, v7.zw);
    r0.xyz = (-(v6.xyz)) + (c[5].xyz);
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r7.xyz = (r14.www) * (v6.xyz);
    r4.xyz = (r0.xyz) * (r0.www) + (-(r7.xyz));
    r5.xyz = normalize(r4.xyz);
    r8.xyz = (r0.xyz) * (r0.www);
    r4.xyz = (r3.xyz) * (c35.www);
    r0.w = saturate(dot(r5.xyz, r8.xyz));
    r3 = (r1.wwww) * (c3.xxxy) + (c3.zzzx);
    r1.w = (-(r0.w)) + (c35.z);
    r0 = lerp(r4, r3, r5.wwww);
    r1.z = (r1.w) * (r1.w);
    r11.xyz = (r0.xyz) * (-(r0.xyz)) + (c35.zzz);
    r1.z = (r1.z) * (r1.z);
    r12.w = (r0.w) * (-(c34.z)) + (c34.w);
    r2.w = (r1.w) * (r1.z);
    r12.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = v2.xyz;
    r0.xyz = (r9.xxx) * (v4.xyz) + (r0.xyz);
    r16.xy = (r0.ww) * (c33.xy) + (c33.zw);
    r0.xyz = (r9.yyy) * (v3.xyz) + (r0.xyz);
    r10.w = exp2(r16.y);
    r13.xyz = normalize(r0.xyz);
    r1.z = saturate(dot(r13.xyz, r5.xyz));
    r13.w = (r0.w) * (c12.z);
    r1.w = saturate(dot(r8.xyz, r13.xyz));
    r7.w = saturate(dot(r13.xyz, -(r7.xyz)));
    r0.y = (r1.w) * (r12.w) + (r13.w);
    r11.w = (r7.w) * (r12.w) + (r13.w);
    r0.z = pow(abs(r1.z), r10.w);
    r0.y = (r0.y) * (r11.w) + (c13.x);
    r0.y = 1.0f / (r0.y);
    r8.w = (r10.w) * (c13.y) + (c13.z);
    r1.x = (r1.w) * (r0.y);
    r1.z = (r0.z) * (r8.w);
    r0.xyz = (r11.xyz) * (r2.www) + (r12.xyz);
    r1.x = (r1.x) * (r1.z);
    r1.z = exp2(-(r6.w));
    r0.xyz = (r0.xyz) * (r1.xxx);
    r6.w = lerp(r2.y, r1.y, r5.w);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r4.w = (r1.z) * (c12.x) + (c12.y);
    r5.xyz = (r6.www) * (r0.xyz);
    r4.xyz = (r1.www) * (c[6].xyz);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c4.xy);
    r3 = tex2D(s13, r0.xy);
    r1.w = r3.y;
    r2 = tex2D(s14, v1.zw);
    r0.xy = (r2.xy) * (c12.ww);
    r6.xy = (r1.wy) * (c34.xx) + (c34.yy);
    r3.xy = (r3.xz) * (r0.xx);
    r0.z = dot(r6.xy, r9.xy) + (c3.x);
    r1.w = (r2.x) * (c12.w) + (-(r3.x));
    r1.w = (r3.z) * (-(r0.x)) + (r1.w);
    r1.xy = (r1.xz) * (r0.yy);
    r2.w = (r2.y) * (c12.w) + (-(r1.x));
    r0.x = dot(r6.xy, r6.xy) + (c3.x);
    r0.y = (r1.z) * (-(r0.y)) + (r2.w);
    r0.x = exp2(-(r0.x));
    r9.y = (r1.w) + (r1.w);
    r0.x = (r0.x) * (c12.x) + (c12.y);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r4.w) * (r0.x);
    r1.w = saturate((r0.z) * (r0.x) + (r0.x));
    r0.xz = (r1.xy) * (c4.ww);
    r0.xyz = (r0.xyz) * (r1.www);
    r9.xz = (r3.xy) * (c4.ww);
    r6.xyz = (r10.xyz) * (r4.xyz) + (r5.xyz);
    r0.xyz = (r9.xyz) * (r4.www) + (r0.xyz);
    r15.xyz = (r6.www) * (r0.xyz);
    r9.w = saturate(dot(r13.xyz, c[17].xyz));
    r1 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c3.y) : (c3.x));
    r14.xyz = (r9.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r1.w = r0.z;
    }
    else
    {
        if ((c35.z) >= (v5.w))
        {
            r2 = (v5.xyzx) * (c3.yyyx);
            r1 = (r2) + (-(c16.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r3 = (r2) + (c14.xxyy);
            r3 = tex2Dlod(s2, r3);
            r1.x = r3.x;
            r3 = (r2) + (c14.zzyy);
            r3 = tex2Dlod(s2, r3);
            r1.y = r3.x;
            r2 = (r2) + (c16.xyzz);
            r2 = tex2Dlod(s2, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c13.zzzz);
            if ((c13.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c14.xx);
                r1.zw = (v5.zx) * (c3.yx);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r0.xy) + (c14.zz);
                r2.zw = (v5.zx) * (c3.yx);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (c16.xy);
                r2.zw = (v5.zx) * (c3.yx);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (-(c16.xy));
                r2.zw = (v5.zx) * (c3.yx);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c13.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c15.x) + (c15.y);
                r1.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r1.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c4.w));
            r0.z = ((r0.z) >= 0.0f ? (c3.x) : (c3.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c14.xx);
                r2.zw = (v5.zz) * (c3.yx);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c14.zz);
                r3.zw = (v5.zz) * (c3.yx);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c16.xy);
                r3.zw = (v5.zz) * (c3.yx);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c16.xy));
                r3.zw = (v5.zz) * (c3.yx);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c13.zzzz);
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
    r1.xyz = (v6.xyz) * (-(r14.www)) + (c[17].xyz);
    r0.xyz = normalize(r1.xyz);
    r1.z = saturate(dot(r0.xyz, c[17].xyz));
    r1.z = (-(r1.z)) + (c35.z);
    r1.y = (r1.z) * (r1.z);
    r1.y = (r1.y) * (r1.y);
    r1.y = (r1.z) * (r1.y);
    r1.z = (r9.w) * (r12.w) + (r13.w);
    r1.x = (r1.z) * (r11.w) + (c13.x);
    r1.z = saturate(dot(r13.xyz, r0.xyz));
    r0.y = 1.0f / (r1.x);
    r0.z = pow(abs(r1.z), r10.w);
    r0.y = (r9.w) * (r0.y);
    r0.z = (r8.w) * (r0.z);
    r1.z = (r0.y) * (r0.z);
    r0.xyz = (r11.xyz) * (r1.yyy) + (r12.xyz);
    r0.xyz = (r1.zzz) * (r0.xyz);
    r0.xyz = (r6.www) * (r0.xyz);
    r2.xyz = (r1.www) * (r14.xyz) + (r15.xyz);
    r0.xyz = (r0.xyz) * (c[19].xyz);
    r3.xyz = (r1.www) * (r0.xyz);
    r0.z = (-(r7.w)) + (c35.z);
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r7.xyz, r13.xyz);
    r1.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r0.w = (r0.w) * (c3.w);
    r0.xyz = (r13.xyz) * (-(r0.zzz)) + (r7.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r6.www) * (r0.xyz);
    r1.xyz = (r11.xyz) * (r1.www) + (r12.xyz);
    r2.xyz = (r10.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.xyz = (r9.xyz) * (r0.xyz);
    r0 = (v6.yyyy) * (c[25]);
    r5.xyz = (r1.xyz) * (c3.www) + (r2.xyz);
    r0 = (v6.xxxx) * (c[24]) + (r0);
    r1.w = dot(r8.xyz, c[22].xyz);
    r0 = (v6.zzzz) * (c[26]) + (r0);
    r1.w = saturate((r1.w) * (c[23].x) + (c[23].y));
    r3 = (r0) + (c[27]);
    r0.z = (r1.w) * (c15.z) + (c15.w);
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
    r1 = (v6.xyzx) * (c3.yyyx) + (c3.xxxy);
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
    r3.xy = (r1.xy) * (c15.zz) + (c15.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r1.w = ((-abs(r1.w)) >= 0.0f ? (c3.x) : (r1.z));
    r1.z = (r3.x) * (r1.x);
    r1.w = (r1.w) * (r1.z);
    r1.z = (r1.y) * (-(r3.y)) + (c35.z);
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
    r1.xyz = (r1.xyz) * (r6.xyz) + (r5.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c35.z;

    return oC0;
}
