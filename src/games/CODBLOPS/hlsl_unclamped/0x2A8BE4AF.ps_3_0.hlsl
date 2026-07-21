// Mechanically reconstructed from 0x2A8BE4AF.ps_3_0.cso.
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
    const float4 c37 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c38 = float4(2.0f, -1.0f, 0.0f, 1.0f);
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

    r0 = tex2D(s7, v7.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c38.xxxx) * (v9) + (c38.yyyy);
    r2.y = dot(r1.xy, r0.zw) + (c38.z);
    r2.x = dot(r1.xy, r0.xy) + (c38.z);
    r0 = tex2D(s1, v1.xy);
    r4.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r1 = tex2D(s0, v1.xy);
    r0 = tex2D(s4, v7.xy);
    r5.w = (r0.w) * (v0.y);
    r3.xyz = lerp(r1.xyz, r0.xyz, r5.www);
    r7.xy = lerp(r4.xy, r2.xy, r5.ww);
    r2 = tex2D(s8, v1.xy);
    r0 = tex2D(s9, v7.xy);
    r1 = tex2D(s5, v7.zw);
    r4.xyz = (r1.xyz) + (c38.yyy);
    r1 = lerp(r2, r0, r5.wwww);
    r4.xyz = (v0.zzz) * (r4.xyz) + (c38.www);
    r11.w = (r1.w) * (-(c12.z)) + (c12.w);
    r2.xyz = (r1.xyz) * (r4.xyz);
    r0 = tex2D(s6, v8.xy);
    r0.xyz = (r0.xyz) + (c38.yyy);
    r1.xyz = (v0.www) * (r0.xyz) + (c38.www);
    r0.xyz = (r3.xyz) * (r4.xyz);
    r4.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(r7.xy, r7.xy) + (c38.z);
    r14.xyz = (r4.xyz) * (-(r4.xyz)) + (c38.www);
    r0.w = exp2(-(r0.w));
    r6.w = (r0.w) * (c3.x) + (c3.y);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c4.xy);
    r3 = tex2D(s13, r1.xy);
    r2 = tex2D(s14, v1.zw);
    r6.xy = (r2.xy) * (c4.ww);
    r0.w = r3.y;
    r1.xy = (r3.xz) * (r6.xx);
    r8.xy = (r0.wy) * (c12.xx) + (c12.yy);
    r0.y = (r2.x) * (c4.w) + (-(r1.x));
    r0.w = dot(r8.xy, r7.xy) + (c38.z);
    r1.z = (r3.z) * (-(r6.x)) + (r0.y);
    r3.xy = (r0.xz) * (r6.yy);
    r0.x = dot(r8.xy, r8.xy) + (c38.z);
    r0.y = (r2.y) * (c4.w) + (-(r3.x));
    r0.x = exp2(-(r0.x));
    r0.y = (r0.z) * (-(r6.y)) + (r0.y);
    r0.z = (r0.x) * (c3.x) + (c3.y);
    r0.y = (r0.y) + (r0.y);
    r0.z = (r6.w) * (r0.z);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r0.xz = (r3.xy) * (c12.xx);
    r11.y = (r1.z) + (r1.z);
    r0.xyz = (r0.xyz) * (r0.www);
    r0.w = dot(v6.xyz, v6.xyz);
    r2.xyz = (-(v6.xyz)) + (c[20].xyz);
    r4.w = rsqrt(r0.w);
    r0.w = dot(r2.xyz, r2.xyz);
    r0.w = rsqrt(r0.w);
    r6.xyz = (r4.www) * (v6.xyz);
    r11.xz = (r1.xy) * (c12.xx);
    r3.xyz = (r2.xyz) * (r0.www) + (-(r6.xyz));
    r1.xyz = normalize(r3.xyz);
    r2.xyz = (r2.xyz) * (r0.www);
    r0.xyz = (r11.xyz) * (r6.www) + (r0.xyz);
    r0.w = saturate(dot(r1.xyz, r2.xyz));
    r3.xyw = c[34].xyw;
    r3.xyz = (-(r3.xyw)) + (c[35].xyw);
    r0.w = (-(r0.w)) + (c38.w);
    r8.xyz = (r5.www) * (r3.xyz) + (c[34].xyw);
    r2.w = (r0.w) * (r0.w);
    r13.xyz = (r0.xyz) * (r8.yyy);
    r0.z = (r2.w) * (r2.w);
    r0.w = (r0.w) * (r0.z);
    r15.xyz = (r4.xyz) * (r4.xyz);
    r0.xyz = (r14.xyz) * (r0.www) + (r15.xyz);
    r3.xyz = v2.xyz;
    r3.xyz = (r7.xxx) * (v4.xyz) + (r3.xyz);
    r5.w = dot(r2.xyz, c[29].xyz);
    r3.xyz = (r7.yyy) * (v3.xyz) + (r3.xyz);
    r12.w = (r1.w) * (c3.w);
    r10.xyz = normalize(r3.xyz);
    r6.w = saturate(dot(r2.xyz, r10.xyz));
    r2.w = saturate(dot(r10.xyz, -(r6.xyz)));
    r2.z = (r6.w) * (r11.w) + (r12.w);
    r10.w = (r2.w) * (r11.w) + (r12.w);
    r0.w = (r1.w) * (c3.z);
    r2.z = (r2.z) * (r10.w) + (c13.x);
    r2.z = 1.0f / (r2.z);
    r2.xy = (r1.ww) * (c37.xy) + (c37.zw);
    r9.w = exp2(r2.y);
    r2.y = saturate(dot(r10.xyz, r1.xyz));
    r1.w = pow(abs(r2.y), r9.w);
    r7.w = (r9.w) * (c13.y) + (c13.z);
    r1.z = (r6.w) * (r2.z);
    r1.w = (r1.w) * (r7.w);
    r1.w = (r1.z) * (r1.w);
    r1.xyz = (v6.xyz) * (-(r4.www)) + (c[17].xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r16.xyz = normalize(r1.xyz);
    r13.w = saturate(dot(r16.xyz, c[17].xyz));
    r7.xyz = (r0.xyz) * (c[22].xyz);
    r0.x = 1.0f / (r2.x);
    r0.y = (-(r2.w)) + (c38.w);
    r1.w = (r0.y) * (r0.y);
    r0.z = dot(r6.xyz, r10.xyz);
    r0.y = (r0.y) * (r1.w);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r0.x) * (r0.y);
    r0.xyz = (r10.xyz) * (-(r0.zzz)) + (r6.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r8.xxx) * (r0.xyz);
    r1.xyz = (r14.xyz) * (r1.www) + (r15.xyz);
    r9.xyz = (r0.xyz) * (r1.xyz);
    r8.w = saturate(dot(r10.xyz, c[17].xyz));
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c38.w) : (c38.z));
    r12.xyz = (r8.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((c38.w) >= (v5.w))
        {
            r1 = (v5.xyzx) * (c38.wwwz);
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
                r0.zw = (v5.zx) * (c38.wz);
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (c14.zz);
                r1.zw = (v5.zx) * (c38.wz);
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c15.xy);
                r1.zw = (v5.zx) * (c38.wz);
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c15.xy));
                r1.zw = (v5.zx) * (c38.wz);
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
            r0.w = ((r0.w) >= 0.0f ? (c38.z) : (c38.w));
            if ((r0.w) != (-(r0.w)))
            {
                r8.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r8.xy) + (c14.xx);
                r1.zw = (v5.zz) * (c38.wz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r8.xy) + (c14.zz);
                r2.zw = (v5.zz) * (c38.wz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r8.xy) + (c15.xy);
                r2.zw = (v5.zz) * (c38.wz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r8.xy) + (-(c15.xy));
                r2.zw = (v5.zz) * (c38.wz);
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
    r0.z = (-(r13.w)) + (c38.w);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.y) * (r0.y);
    r0.z = (r0.z) * (r0.y);
    r0.y = (r8.w) * (r11.w) + (r12.w);
    r0.y = (r0.y) * (r10.w) + (c13.x);
    r1.w = saturate(dot(r10.xyz, r16.xyz));
    r0.x = 1.0f / (r0.y);
    r0.y = pow(abs(r1.w), r9.w);
    r0.x = (r8.w) * (r0.x);
    r0.y = (r7.w) * (r0.y);
    r1.w = (r0.x) * (r0.y);
    r0.xyz = (r14.xyz) * (r0.zzz) + (r15.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r8.zzz) * (r0.xyz);
    r1.xyz = (r0.xyz) * (c[19].xyz);
    r0.xyz = (r0.www) * (r12.xyz) + (r13.xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r2.xyz = (r5.xyz) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r11.xyz) * (r9.xyz);
    r1.xyz = (r8.zzz) * (r7.xyz);
    r9.xyz = (r0.xyz) * (c3.zzz) + (r2.xyz);
    r0.xyz = (r6.www) * (c[21].xyz);
    r0.w = saturate((r5.w) * (c[30].x) + (c[30].y));
    r8.xyz = (r5.xyz) * (r0.xyz) + (r1.xyz);
    r1.z = (r0.w) * (c16.z) + (c16.w);
    r1.w = (r0.w) * (r0.w);
    r0 = (v6.xyzx) * (c38.wwwz) + (c38.zzzw);
    r1.w = (r1.z) * (r1.w);
    r1.z = dot(r0, c[28]);
    r1.z = 1.0f / (r1.z);
    r2.x = dot(r0, c[27]);
    r1.x = dot(r0, c[25]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[26]);
    r0.w = dot(c[23].yz, r2.xy) + (c[23].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r0.xy) * (c16.zz) + (c16.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c38.z) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c38.w);
    r0.xy = (r1.zz) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r5.w = (r1.w) * (r0.w);
    r0.xy = (r0.xy) * (c4.yy) + (c4.yy);
    r4 = tex2D(s3, r0.xy);
    r3 = (-(v6.yyyy)) + (c[6]);
    r2 = (-(v6.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v6.zzzz)) + (c[7]);
    r0 = (r1) * (r1) + (r0);
    r7.xyz = (r4.xyz) * (r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r7.xyz = (r5.www) * (r7.xyz);
    r3 = (r3) * (r4);
    r3 = (r10.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r10.xxxx) + (r3);
    r1 = saturate((r1) * (r10.zzzz) + (r2));
    r2.x = c38.w;
    r0 = saturate((r0) * (c[8]) + (r2.xxxx));
    r2.xyz = (r7.xyz) * (r8.xyz) + (r9.xyz);
    r0 = (r1) * (r0);
    r1.z = dot(c[11], r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r0.w = dot(c[31].xyz, r6.xyz);
    r0.w = saturate((c[33].y) * (r0.w) + (c[33].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[32].xyz);
    r1.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[36].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c38.w;

    return oC0;
}
