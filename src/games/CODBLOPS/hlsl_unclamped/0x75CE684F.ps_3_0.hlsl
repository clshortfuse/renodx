// Mechanically reconstructed from 0x75CE684F.ps_3_0.cso.
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
    const float4 c4 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c12 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c34 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c35 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c36 = float4(2.0f, -1.0f, 1.0f, 0.0f);
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

    r1 = tex2D(s0, v1.xy);
    r1.w = (r1.w) * (-(v0.x)) + (c36.z);
    r0 = tex2D(s4, v7.xy);
    r6.w = (r0.w) * (v0.y);
    r0.w = (r0.w) * (-(v0.y)) + (c36.z);
    r2.xyz = lerp(r1.xyz, r0.xyz, r6.www);
    r1.w = (r1.w) * (-(r0.w)) + (c36.z);
    r0 = tex2D(s7, v7.zw);
    r3.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c36.xxxx) * (v8) + (c36.yyyy);
    r1.y = dot(r3.xy, r0.zw) + (c36.w);
    r1.x = dot(r3.xy, r0.xy) + (c36.w);
    r0 = tex2D(s6, v7.xy);
    r3.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r1.w = (-(r1.w)) + (c36.z);
    r4.xy = (r6.ww) * (-(r3.xy)) + (r1.xy);
    r0 = tex2D(s5, v7.zw);
    r4.w = (r0.w) * (v0.z);
    r1.xyz = lerp(r2.xyz, r0.xyz, r4.www);
    r0.xy = (r4.xy) * (r4.ww);
    r10.xy = (r6.ww) * (r3.xy) + (r0.xy);
    r0.w = (r0.w) * (-(v0.z)) + (c36.z);
    r5.w = (r1.w) * (-(r0.w)) + (c36.z);
    r0.w = dot(r10.xy, r10.xy) + (c36.w);
    r9.xyz = (r1.xyz) * (r1.xyz);
    r0.w = exp2(-(r0.w));
    r5.z = (r0.w) * (c4.x) + (c4.y);
    r0.xy = (v1.zw) * (c12.xy) + (c12.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c12.xy);
    r2 = tex2D(s13, r1.xy);
    r1 = tex2D(s14, v1.zw);
    r4.xy = (r1.xy) * (c4.ww);
    r0.w = r2.y;
    r2.xy = (r2.xz) * (r4.xx);
    r5.xy = (r0.wy) * (c35.xx) + (c35.yy);
    r0.y = (r1.x) * (c4.w) + (-(r2.x));
    r0.w = dot(r5.xy, r10.xy) + (c36.w);
    r1.w = (r2.z) * (-(r4.x)) + (r0.y);
    r3.xy = (r0.xz) * (r4.yy);
    r0.x = dot(r5.xy, r5.xy) + (c36.w);
    r0.y = (r1.y) * (c4.w) + (-(r3.x));
    r0.x = exp2(-(r0.x));
    r0.y = (r0.z) * (-(r4.y)) + (r0.y);
    r0.z = (r0.x) * (c4.x) + (c4.y);
    r0.y = (r0.y) + (r0.y);
    r0.z = (r5.z) * (r0.z);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r0.xz = (r3.xy) * (c12.ww);
    r6.y = (r1.w) + (r1.w);
    r4.xyz = (r0.xyz) * (r0.www);
    r0 = tex2D(s8, v7.xy);
    r0 = (r0) + (c36.wwwy);
    r6.xz = (r2.xy) * (c12.ww);
    r3 = (r6.wwww) * (r0) + (c36.wwwz);
    r1 = tex2D(s9, v7.zw);
    r2 = (r1.wwww) * (c3.xxxy) + (c3.zzzx);
    r4.xyz = (r6.xyz) * (r5.zzz) + (r4.xyz);
    r0 = lerp(r3, r2, r4.wwww);
    r1.w = dot(v6.xyz, v6.xyz);
    r5.xyz = (-(v6.xyz)) + (c[5].xyz);
    r2.w = rsqrt(r1.w);
    r1.w = dot(r5.xyz, r5.xyz);
    r1.w = rsqrt(r1.w);
    r7.xyz = (r2.www) * (v6.xyz);
    r1.z = c36.y;
    r2.xyz = (r1.zzz) + (c[32].xyw);
    r8.xyz = (r5.xyz) * (r1.www) + (-(r7.xyz));
    r3.xyz = normalize(r8.xyz);
    r8.xyz = (r5.xyz) * (r1.www);
    r2.xyz = (r6.www) * (r2.xyz) + (c36.zzz);
    r1.w = saturate(dot(r3.xyz, r8.xyz));
    r15.xyz = (r0.xyz) * (-(r0.xyz)) + (c36.zzz);
    r1.w = (-(r1.w)) + (c36.z);
    r10.w = (r0.w) * (-(c35.z)) + (c35.w);
    r1.z = (r1.w) * (r1.w);
    r1.z = (r1.z) * (r1.z);
    r5.xyz = v2.xyz;
    r5.xyz = (r10.xxx) * (v4.xyz) + (r5.xyz);
    r7.w = (r1.w) * (r1.z);
    r5.xyz = (r10.yyy) * (v3.xyz) + (r5.xyz);
    r16.xyz = (r0.xyz) * (r0.xyz);
    r17.xyz = normalize(r5.xyz);
    r1.z = saturate(dot(r17.xyz, r3.xyz));
    r11.w = (r0.w) * (c4.z);
    r3.w = saturate(dot(r8.xyz, r17.xyz));
    r1.w = saturate(dot(r17.xyz, -(r7.xyz)));
    r0.z = (r3.w) * (r10.w) + (r11.w);
    r9.w = (r1.w) * (r10.w) + (r11.w);
    r0.z = (r0.z) * (r9.w) + (c13.x);
    r3.xy = (r0.ww) * (c34.xy) + (c34.zw);
    r0.y = 1.0f / (r0.z);
    r8.w = exp2(r3.y);
    r0.z = pow(abs(r1.z), r8.w);
    r6.w = (r8.w) * (c13.y) + (c13.z);
    r1.x = (r3.w) * (r0.y);
    r1.z = (r0.z) * (r6.w);
    r0.xyz = (r15.xyz) * (r7.www) + (r16.xyz);
    r1.z = (r1.x) * (r1.z);
    r14.xyz = lerp(r2.xyz, r1.yyy, r4.www);
    r0.xyz = (r0.xyz) * (r1.zzz);
    r13.xyz = (r4.xyz) * (r14.yyy);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r1.xyz = (r14.zzz) * (r0.xyz);
    r1.w = (-(r1.w)) + (c36.z);
    r0.xyz = (r3.www) * (c[6].xyz);
    r2.y = (r1.w) * (r1.w);
    r2.z = 1.0f / (r3.x);
    r1.w = (r1.w) * (r2.y);
    r5.xyz = (r9.xyz) * (r0.xyz) + (r1.xyz);
    r1.w = (r2.z) * (r1.w);
    r0.w = (r0.w) * (c3.w);
    r1.z = dot(r7.xyz, r17.xyz);
    r0.xyz = (v6.xyz) * (-(r2.www)) + (c[17].xyz);
    r1.z = (r1.z) + (r1.z);
    r18.xyz = normalize(r0.xyz);
    r0.xyz = (r17.xyz) * (-(r1.zzz)) + (r7.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r12.w = saturate(dot(r18.xyz, c[17].xyz));
    r10.xyz = (r14.xxx) * (r0.xyz);
    r11.xyz = (r15.xyz) * (r1.www) + (r16.xyz);
    r7.w = saturate(dot(r17.xyz, c[17].xyz));
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c36.z) : (c36.w));
    r12.xyz = (r7.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((c36.z) >= (v5.w))
        {
            r1 = (v5.xyzx) * (c36.zzzw);
            r0 = (r1) + (-(c15.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r2 = (r1) + (c14.xxyy);
            r2 = tex2Dlod(s1, r2);
            r0.x = r2.x;
            r2 = (r1) + (c14.zzyy);
            r2 = tex2Dlod(s1, r2);
            r0.y = r2.x;
            r1 = (r1) + (c15.xyzz);
            r1 = tex2Dlod(s1, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c13.zzzz);
            if ((c13.w) < (v5.w))
            {
                r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c14.xx);
                r0.zw = (v5.zx) * (c36.zw);
                r0 = tex2Dlod(s1, r0);
                r1.xy = (r4.xy) + (c14.zz);
                r1.zw = (v5.zx) * (c36.zw);
                r3 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (c15.xy);
                r1.zw = (v5.zx) * (c36.zw);
                r2 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (-(c15.xy));
                r1.zw = (v5.zx) * (c36.zw);
                r1 = tex2Dlod(s1, r1);
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
            r0.w = (v5.w) + (-(c12.w));
            r0.w = ((r0.w) >= 0.0f ? (c36.w) : (c36.z));
            if ((r0.w) != (-(r0.w)))
            {
                r14.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r14.xy) + (c14.xx);
                r1.zw = (v5.zz) * (c36.zw);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r14.xy) + (c14.zz);
                r2.zw = (v5.zz) * (c36.zw);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r14.xy) + (c15.xy);
                r2.zw = (v5.zz) * (c36.zw);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r14.xy) + (-(c15.xy));
                r2.zw = (v5.zz) * (c36.zw);
                r2 = tex2Dlod(s1, r2);
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
    r0.z = (-(r12.w)) + (c36.z);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.y) * (r0.y);
    r0.z = (r0.z) * (r0.y);
    r0.y = (r7.w) * (r10.w) + (r11.w);
    r0.y = (r0.y) * (r9.w) + (c13.x);
    r1.w = saturate(dot(r17.xyz, r18.xyz));
    r0.x = 1.0f / (r0.y);
    r0.y = pow(abs(r1.w), r8.w);
    r0.x = (r7.w) * (r0.x);
    r0.y = (r6.w) * (r0.y);
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
    r6.xyz = (r1.xyz) * (c3.www) + (r2.xyz);
    r0 = (v6.xxxx) * (c[24]) + (r0);
    r1.w = dot(r8.xyz, c[22].xyz);
    r0 = (v6.zzzz) * (c[26]) + (r0);
    r1.w = saturate((r1.w) * (c[23].x) + (c[23].y));
    r3 = (r0) + (c[27]);
    r0.z = (r1.w) * (c16.z) + (c16.w);
    r2.zw = r3.zw;
    r0.w = (r1.w) * (r1.w);
    r4.zw = r2.zw;
    r3.z = (r0.z) * (r0.w);
    r0.zw = r4.zw;
    r1.xy = (r3.ww) * (-(c[28].zw)) + (r3.xy);
    r1.zw = r0.zw;
    r1 = tex2Dproj(s2, r1);
    r1.w = r1.x;
    r4.xy = (r2.ww) * (-(c[28].xy)) + (r3.xy);
    r4 = tex2Dproj(s2, r4);
    r1.y = r4.x;
    r2.xy = (r2.ww) * (c[28].xy) + (r3.xy);
    r4 = tex2Dproj(s2, r2);
    r1.x = r4.x;
    r0.xy = (r2.ww) * (c[28].zw) + (r3.xy);
    r0 = tex2Dproj(s2, r0);
    r1.z = r0.x;
    r0 = (v6.xyzx) * (c36.zzzw) + (c36.wwwz);
    r1.w = dot(r1, c13.zzzz);
    r1.z = dot(r0, c[21]);
    r1.z = 1.0f / (r1.z);
    r2.x = dot(r0, c[20]);
    r1.x = dot(r0, c[10]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[11]);
    r0.w = dot(c[8].yz, r2.xy) + (c[8].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[9].xy) + (c[9].zw));
    r2.xy = (r0.xy) * (c16.zz) + (c16.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c36.w) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c36.z);
    r0.xy = (r1.zz) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r2.w = (r3.z) * (r0.w);
    r0.xy = (r0.xy) * (c12.yy) + (c12.yy);
    r0 = tex2D(s3, r0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(c[29].xyz, r7.xyz);
    r0.w = saturate((c[31].y) * (r0.w) + (c[31].x));
    r1.xyz = c[0].xyz;
    r1.xyz = (-(r1.xyz)) + (c[30].xyz);
    r0.xyz = (r2.www) * (r0.xyz);
    r1.xyz = (r0.www) * (r1.xyz) + (c[0].xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r1.xyz = (r1.xyz) * (c[0].www);
    r0.xyz = (r0.xyz) * (r5.xyz) + (r6.xyz);
    r1.xyz = (r5.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r5.www) + (-(r1.xyz));
    r0.xyz = (v2.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[33].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r5.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
