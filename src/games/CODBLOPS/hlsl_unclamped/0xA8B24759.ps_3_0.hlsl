// Mechanically reconstructed from 0xA8B24759.ps_3_0.cso.
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
    const float4 c1 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c12 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c38 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c39 = float4(2.0f, -1.0f, 0.0f, 1.0f);
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

    r0 = tex2D(s6, v7.zw);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c39.xxxx) * (v8) + (c39.yyyy);
    r2.y = dot(r1.xy, r0.zw) + (c39.z);
    r2.x = dot(r1.xy, r0.xy) + (c39.z);
    r0 = tex2D(s1, v0.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1 = tex2D(s5, v7.zw);
    r5.w = (r1.w) * (v7.y);
    r4.xy = lerp(r0.xy, r2.xy, r5.ww);
    r1.w = (r1.w) * (-(v7.y)) + (c39.w);
    r0 = tex2D(s0, v0.xy);
    r2.xyz = lerp(r0.xyz, r1.xyz, r5.www);
    r0.w = (r0.w) * (-(v7.x)) + (c39.w);
    r6.w = (r0.w) * (-(r1.w)) + (c39.w);
    r0.w = dot(r4.xy, r4.xy) + (c39.z);
    r6.xyz = (r2.xyz) * (r2.xyz);
    r0.w = exp2(-(r0.w));
    r3.z = (r0.w) * (c3.x) + (c3.y);
    r0.w = dot(v6.xyz, v6.xyz);
    r3.w = rsqrt(r0.w);
    r0.xy = (v0.zw) * (c4.xy);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c4.xy) + (c4.zy);
    r0 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v0.zw);
    r5.xy = (r1.xy) * (c3.ww);
    r2.w = r0.y;
    r3.xy = (r2.xz) * (r5.xx);
    r7.xy = (r2.yw) * (c12.xx) + (c12.yy);
    r0.y = (r1.x) * (c3.w) + (-(r3.x));
    r0.w = dot(r7.xy, r4.xy) + (c39.z);
    r1.w = (r2.z) * (-(r5.x)) + (r0.y);
    r2.xy = (r0.xz) * (r5.yy);
    r0.x = dot(r7.xy, r7.xy) + (c39.z);
    r0.y = (r1.y) * (c3.w) + (-(r2.x));
    r0.x = exp2(-(r0.x));
    r0.y = (r0.z) * (-(r5.y)) + (r0.y);
    r0.z = (r0.x) * (c3.x) + (c3.y);
    r7.y = (r1.w) + (r1.w);
    r0.z = (r3.z) * (r0.z);
    r0.y = (r0.y) + (r0.y);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r0.xz = (r2.xy) * (c4.ww);
    r1.xyz = (-(v6.xyz)) + (c[20].xyz);
    r2.xyz = (r0.xyz) * (r0.www);
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r15.xyz = (r3.www) * (v6.xyz);
    r7.xz = (r3.xy) * (c4.ww);
    r0.xyz = (r1.xyz) * (r0.www) + (-(r15.xyz));
    r2.xyz = (r7.xyz) * (r3.zzz) + (r2.xyz);
    r11.xyz = normalize(r0.xyz);
    r0.xyz = (v6.xyz) * (-(r3.www)) + (c[17].xyz);
    r18.xyz = (r1.xyz) * (r0.www);
    r14.xyz = normalize(r0.xyz);
    r0.z = dot(r18.xyz, c[29].xyz);
    r0.w = saturate(dot(r14.xyz, c[17].xyz));
    r0.z = saturate((r0.z) * (c[30].x) + (c[30].y));
    r0.x = (r0.z) * (c16.z) + (c16.w);
    r0.y = (r0.z) * (r0.z);
    r0.z = saturate(dot(r11.xyz, r18.xyz));
    r7.w = (r0.x) * (r0.y);
    r0.y = (-(r0.z)) + (c39.w);
    r0.w = (-(r0.w)) + (c39.w);
    r0.x = (r0.y) * (r0.y);
    r0.z = (r0.w) * (r0.w);
    r0.x = (r0.x) * (r0.x);
    r0.z = (r0.z) * (r0.z);
    r4.w = (r0.y) * (r0.x);
    r8.w = (r0.w) * (r0.z);
    r1 = tex2D(s12, v0.zw);
    r0 = tex2D(s8, v7.zw);
    r8.xyz = lerp(c[36].xyw, r0.yyy, r5.www);
    r17.xyz = (r2.xyz) * (r8.yyy);
    r2 = (r0.wwww) * (c1.xxxy) + (c1.zzzx);
    r3 = tex2D(s7, v0.xy);
    r0 = lerp(r3, r2, r5.wwww);
    r12.xyz = (r0.xyz) * (-(r0.xyz)) + (c39.www);
    r2.xyz = v1.xyz;
    r2.xyz = (r4.xxx) * (v4.xyz) + (r2.xyz);
    r13.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r4.yyy) * (v3.xyz) + (r2.xyz);
    r10.xyz = (r12.xyz) * (r4.www) + (r13.xyz);
    r9.xyz = normalize(r0.xyz);
    r9.w = (r0.w) * (-(c12.z)) + (c12.w);
    r8.y = saturate(dot(r9.xyz, c[17].xyz));
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c39.w) : (c39.z));
    r16.xyz = (r8.yyy) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r3.w = r0.z;
    }
    else
    {
        if ((c39.w) >= (v5.w))
        {
            r2 = (v5.xyzx) * (c39.wwwz);
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
            r0.z = dot(r1, c13.zzzz);
            if ((c13.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c14.xx);
                r1.zw = (v5.zx) * (c39.wz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r0.xy) + (c14.zz);
                r2.zw = (v5.zx) * (c39.wz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (c15.xy);
                r2.zw = (v5.zx) * (c39.wz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (-(c15.xy));
                r2.zw = (v5.zx) * (c39.wz);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c13.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c16.x) + (c16.y);
                r3.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r3.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c4.w));
            r0.z = ((r0.z) >= 0.0f ? (c39.z) : (c39.w));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c14.xx);
                r2.zw = (v5.zz) * (c39.wz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c14.zz);
                r3.zw = (v5.zz) * (c39.wz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c15.xy);
                r3.zw = (v5.zz) * (c39.wz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c15.xy));
                r3.zw = (v5.zz) * (c39.wz);
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
            r3.w = r0.z;
        }
    }
    r4.x = (r0.w) * (c3.z);
    r4.w = saturate(dot(r18.xyz, r9.xyz));
    r3.z = saturate(dot(r9.xyz, -(r15.xyz)));
    r0.z = (r4.w) * (r9.w) + (r4.x);
    r4.y = (r3.z) * (r9.w) + (r4.x);
    r2.xyz = (r3.www) * (r16.xyz) + (r17.xyz);
    r0.z = (r0.z) * (r4.y) + (c13.x);
    r0.y = 1.0f / (r0.z);
    r0.z = dot(r15.xyz, r9.xyz);
    r2.w = (r4.w) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r0.w) * (c1.w);
    r1.xyz = (r9.xyz) * (-(r0.zzz)) + (r15.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (-(r3.z)) + (c39.w);
    r1.z = (r1.w) * (r1.w);
    r1.xy = (r0.ww) * (c38.xy) + (c38.zw);
    r0.w = (r1.w) * (r1.z);
    r1.w = 1.0f / (r1.x);
    r0.xyz = (r8.xxx) * (r0.xyz);
    r0.w = (r0.w) * (r1.w);
    r3.xyz = (r12.xyz) * (r0.www) + (r13.xyz);
    r4.z = exp2(r1.y);
    r0.w = (r4.z) * (c13.y) + (c13.z);
    r1.w = (r8.y) * (r9.w) + (r4.x);
    r1.w = (r1.w) * (r4.y) + (c13.x);
    r4.y = saturate(dot(r9.xyz, r14.xyz));
    r1.z = 1.0f / (r1.w);
    r1.w = pow(abs(r4.y), r4.z);
    r1.z = (r8.y) * (r1.z);
    r1.w = (r0.w) * (r1.w);
    r1.w = (r1.z) * (r1.w);
    r1.xyz = (r12.xyz) * (r8.www) + (r13.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r1.www) * (r1.xyz);
    r3.z = saturate(dot(r9.xyz, r11.xyz));
    r1.xyz = (r8.zzz) * (r1.xyz);
    r1.w = pow(abs(r3.z), r4.z);
    r1.xyz = (r1.xyz) * (c[19].xyz);
    r0.w = (r0.w) * (r1.w);
    r1.xyz = (r3.www) * (r1.xyz);
    r1.w = (r2.w) * (r0.w);
    r2.xyz = (r6.xyz) * (r2.xyz) + (r1.xyz);
    r1.xyz = (r7.xyz) * (r0.xyz);
    r0 = (v6.yyyy) * (c[32]);
    r7.xyz = (r1.xyz) * (c1.www) + (r2.xyz);
    r0 = (v6.xxxx) * (c[31]) + (r0);
    r1.xyz = (r10.xyz) * (r1.www);
    r0 = (v6.zzzz) * (c[33]) + (r0);
    r1.xyz = (r1.xyz) * (c[22].xyz);
    r3 = (r0) + (c[34]);
    r1.xyz = (r8.zzz) * (r1.xyz);
    r2.zw = r3.zw;
    r0.xyz = (r4.www) * (c[21].xyz);
    r4.zw = r2.zw;
    r5.xyz = (r6.xyz) * (r0.xyz) + (r1.xyz);
    r0.zw = r4.zw;
    r1.xy = (r3.ww) * (-(c[35].zw)) + (r3.xy);
    r1.zw = r0.zw;
    r1 = tex2Dproj(s3, r1);
    r1.w = r1.x;
    r4.xy = (r2.ww) * (-(c[35].xy)) + (r3.xy);
    r4 = tex2Dproj(s3, r4);
    r1.y = r4.x;
    r2.xy = (r2.ww) * (c[35].xy) + (r3.xy);
    r4 = tex2Dproj(s3, r2);
    r1.x = r4.x;
    r0.xy = (r2.ww) * (c[35].zw) + (r3.xy);
    r0 = tex2Dproj(s3, r0);
    r1.z = r0.x;
    r0 = (v6.xyzx) * (c39.wwwz) + (c39.zzzw);
    r5.w = dot(r1, c13.zzzz);
    r1.w = dot(r0, c[28]);
    r1.w = 1.0f / (r1.w);
    r2.x = dot(r0, c[27]);
    r1.x = dot(r0, c[25]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[26]);
    r0.w = dot(c[23].yz, r2.xy) + (c[23].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r0.xy) * (c16.zz) + (c16.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c39.z) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c39.w);
    r0.xy = (r1.ww) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r7.w = (r7.w) * (r0.w);
    r0.xy = (r0.xy) * (c4.yy) + (c4.yy);
    r4 = tex2D(s4, r0.xy);
    r3 = (-(v6.yyyy)) + (c[6]);
    r2 = (-(v6.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v6.zzzz)) + (c[7]);
    r0 = (r1) * (r1) + (r0);
    r8.xyz = (r4.xyz) * (r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r8.xyz = (r7.www) * (r8.xyz);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r2.x = c39.w;
    r0 = saturate((r0) * (c[8]) + (r2.xxxx));
    r2.xyz = (r5.www) * (r8.xyz);
    r0 = (r1) * (r0);
    r2.xyz = (r2.xyz) * (r5.xyz) + (r7.xyz);
    r1.z = dot(c[11], r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r0.xyz = (r6.xyz) * (r1.xyz) + (r2.xyz);
    r1.xyz = (r6.www) * (v2.xyz);
    r0.xyz = (r0.xyz) * (r6.www) + (-(r1.xyz));
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r6.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
