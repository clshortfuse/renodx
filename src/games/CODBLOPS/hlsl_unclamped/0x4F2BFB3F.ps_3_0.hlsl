// Mechanically reconstructed from 0x4F2BFB3F.ps_3_0.cso.
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
    const float4 c3 = float4(0.0f, -0.5f, 1.0f, 0.200000003f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c12 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c13 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c40 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c41 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c42 = float4(2.0f, -1.0f, 1.0f, 0.200000003f);
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
    float4 oC0 = 0.0f;

    r0 = tex2D(s7, v7.zw);
    r2.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c42.xxxx) * (v8) + (c42.yyyy);
    r1.y = dot(r2.xy, r0.zw) + (c3.x);
    r1.x = dot(r2.xy, r0.xy) + (c3.x);
    r0 = tex2D(s1, v1.xy);
    r2.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s0, v1.xy);
    r4 = tex2D(s6, v7.zw);
    r4.w = (r4.w) * (v0.z) + (c3.y);
    r8.xy = float2(((r4.w) >= 0.0f ? (r1.x) : (r2.x)), ((r4.w) >= 0.0f ? (r1.y) : (r2.y)));
    r2 = tex2D(s8, v1.xy);
    r1 = tex2D(s5, v7.xy);
    r1.xyz = (r1.xyz) + (c42.yyy);
    r3.w = r2.w;
    r1.xyz = (v0.yyy) * (r1.xyz) + (c42.zzz);
    r5.xyz = (r0.xyz) * (r1.xyz);
    r3.xyz = (r1.xyz) * (c42.www);
    r1 = tex2D(s9, v7.zw);
    r0 = (r1.wwww) * (c3.xxxz) + (c3.wwwx);
    r4.xyz = float3(((r4.w) >= 0.0f ? (r4.x) : (r5.x)), ((r4.w) >= 0.0f ? (r4.y) : (r5.y)), ((r4.w) >= 0.0f ? (r4.z) : (r5.z)));
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (r3.x)), ((r4.w) >= 0.0f ? (r0.y) : (r3.y)), ((r4.w) >= 0.0f ? (r0.z) : (r3.z)), ((r4.w) >= 0.0f ? (r0.w) : (r3.w)));
    r7.w = ((r4.w) >= 0.0f ? (r1.y) : (r2.y));
    r5.xyz = (r4.xyz) * (r4.xyz);
    r1.w = dot(v6.xyz, v6.xyz);
    r1.xyz = (-(v6.xyz)) + (c[20].xyz);
    r11.w = rsqrt(r1.w);
    r1.w = dot(r1.xyz, r1.xyz);
    r1.w = rsqrt(r1.w);
    r6.xyz = (r11.www) * (v6.xyz);
    r9.w = (r0.w) * (-(c13.z)) + (c13.w);
    r3.xyz = (r1.xyz) * (r1.www) + (-(r6.xyz));
    r2.xyz = normalize(r3.xyz);
    r1.xyz = (r1.xyz) * (r1.www);
    r13.xyz = (r0.xyz) * (-(r0.xyz)) + (c42.zzz);
    r1.w = saturate(dot(r2.xyz, r1.xyz));
    r2.w = dot(r8.xy, r8.xy) + (c3.x);
    r1.w = (-(r1.w)) + (c42.z);
    r3.w = exp2(-(r2.w));
    r2.w = (r1.w) * (r1.w);
    r11.z = (r3.w) * (c4.x) + (c4.y);
    r2.w = (r2.w) * (r2.w);
    r3.w = (r1.w) * (r2.w);
    r3.xyz = v2.xyz;
    r3.xyz = (r8.xxx) * (v4.xyz) + (r3.xyz);
    r14.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r8.yyy) * (v3.xyz) + (r3.xyz);
    r10.w = (r0.w) * (c4.w);
    r10.xyz = normalize(r0.xyz);
    r6.w = saturate(dot(r1.xyz, r10.xyz));
    r1.w = saturate(dot(r10.xyz, -(r6.xyz)));
    r2.w = (r6.w) * (r9.w) + (r10.w);
    r8.w = (r1.w) * (r9.w) + (r10.w);
    r0.xyz = (r13.xyz) * (r3.www) + (r14.xyz);
    r2.w = (r2.w) * (r8.w) + (c16.x);
    r3.w = 1.0f / (r2.w);
    r3.xy = (r0.ww) * (c41.xy) + (c41.zw);
    r4.z = exp2(r3.y);
    r3.z = saturate(dot(r10.xyz, r2.xyz));
    r2.w = pow(abs(r3.z), r4.z);
    r4.w = (r4.z) * (c16.y) + (c16.z);
    r2.z = (r6.w) * (r3.w);
    r2.w = (r2.w) * (r4.w);
    r5.w = dot(r1.xyz, c[29].xyz);
    r1.z = (r2.z) * (r2.w);
    r0.xyz = (r0.xyz) * (r1.zzz);
    r1.w = (-(r1.w)) + (c42.z);
    r0.xyz = (r0.xyz) * (c[22].xyz);
    r1.y = (r1.w) * (r1.w);
    r1.z = 1.0f / (r3.x);
    r1.w = (r1.w) * (r1.y);
    r7.xyz = (r7.www) * (r0.xyz);
    r8.z = (r1.z) * (r1.w);
    r0.w = (r0.w) * (c4.z);
    r0.xy = (v1.zw) * (c12.xy) + (c12.zy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c12.xy);
    r3 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v1.zw);
    r0.xy = (r2.xy) * (c12.ww);
    r1.w = r3.y;
    r3.xy = (r3.xz) * (r0.xx);
    r4.xy = (r1.wy) * (c13.xx) + (c13.yy);
    r1.w = (r2.x) * (c12.w) + (-(r3.x));
    r0.z = dot(r4.xy, r8.xy) + (c3.x);
    r2.w = (r3.z) * (-(r0.x)) + (r1.w);
    r1.xy = (r1.xz) * (r0.yy);
    r0.x = dot(r4.xy, r4.xy) + (c3.x);
    r1.w = (r2.y) * (c12.w) + (-(r1.x));
    r0.x = exp2(-(r0.x));
    r0.y = (r1.z) * (-(r0.y)) + (r1.w);
    r0.x = (r0.x) * (c4.x) + (c4.y);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r11.z) * (r0.x);
    r1.w = saturate((r0.z) * (r0.x) + (r0.x));
    r0.xz = (r1.xy) * (c13.xx);
    r9.y = (r2.w) + (r2.w);
    r0.xyz = (r0.xyz) * (r1.www);
    r9.xz = (r3.xy) * (c13.xx);
    r1.w = dot(r6.xyz, r10.xyz);
    r0.xyz = (r9.xyz) * (r11.zzz) + (r0.xyz);
    r1.w = (r1.w) + (r1.w);
    r12.xyz = (r7.www) * (r0.xyz);
    r0.xyz = (r10.xyz) * (-(r1.www)) + (r6.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (v6.xyz) * (-(r11.www)) + (c[17].xyz);
    r1.xyz = (r7.www) * (r0.xyz);
    r0.xyz = normalize(r2.xyz);
    r2.xyz = (r13.xyz) * (r8.zzz) + (r14.xyz);
    r0.w = saturate(dot(r0.xyz, c[17].xyz));
    r8.xyz = (r1.xyz) * (r2.xyz);
    r1.z = (-(r0.w)) + (c42.z);
    r0.w = (r1.z) * (r1.z);
    r1.w = saturate(dot(r10.xyz, c[17].xyz));
    r1.y = (r0.w) * (r0.w);
    r0.w = (r1.w) * (r9.w) + (r10.w);
    r1.x = saturate(dot(r10.xyz, r0.xyz));
    r0.z = (r0.w) * (r8.w) + (c16.x);
    r0.w = pow(abs(r1.x), r4.z);
    r0.z = 1.0f / (r0.z);
    r0.w = (r4.w) * (r0.w);
    r0.z = (r1.w) * (r0.z);
    r9.w = (r1.z) * (r1.y);
    r8.w = (r0.w) * (r0.z);
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c3.z) : (c3.x));
    r11.xyz = (r1.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((c42.z) >= (v5.w))
        {
            r1 = (v5.xyzx) * (c3.zzzx);
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
            r4.w = dot(r0, c16.zzzz);
            if ((c16.w) < (v5.w))
            {
                r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c14.xx);
                r0.zw = (v5.zx) * (c3.zx);
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (c14.zz);
                r1.zw = (v5.zx) * (c3.zx);
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c15.xy);
                r1.zw = (v5.zx) * (c3.zx);
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c15.xy));
                r1.zw = (v5.zx) * (c3.zx);
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c16.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v5.w) * (c40.x) + (c40.y);
                r0.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r0.w = r4.w;
            }
        }
        else
        {
            r0.w = (v5.w) + (-(c13.x));
            r0.w = ((r0.w) >= 0.0f ? (c3.x) : (c3.z));
            if ((r0.w) != (-(r0.w)))
            {
                r15.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r15.xy) + (c14.xx);
                r1.zw = (v5.zz) * (c3.zx);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r15.xy) + (c14.zz);
                r2.zw = (v5.zz) * (c3.zx);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r15.xy) + (c15.xy);
                r2.zw = (v5.zz) * (c3.zx);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r15.xy) + (-(c15.xy));
                r2.zw = (v5.zz) * (c3.zx);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c16.zzzz);
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
    r0.xyz = (r13.xyz) * (r9.www) + (r14.xyz);
    r0.xyz = (r8.www) * (r0.xyz);
    r0.xyz = (r7.www) * (r0.xyz);
    r1.xyz = (r0.xyz) * (c[19].xyz);
    r0.xyz = (r0.www) * (r11.xyz) + (r12.xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r1.xyz = (r5.xyz) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r9.xyz) * (r8.xyz);
    r9.xyz = (r0.xyz) * (c4.zzz) + (r1.xyz);
    r0 = (v6.yyyy) * (c[32]);
    r1.xyz = (r6.www) * (c[21].xyz);
    r0 = (v6.xxxx) * (c[31]) + (r0);
    r8.xyz = (r5.xyz) * (r1.xyz) + (r7.xyz);
    r0 = (v6.zzzz) * (c[33]) + (r0);
    r1.w = saturate((r5.w) * (c[30].x) + (c[30].y));
    r3 = (r0) + (c[34]);
    r0.z = (r1.w) * (c40.z) + (c40.w);
    r2.zw = r3.zw;
    r0.w = (r1.w) * (r1.w);
    r4.zw = r2.zw;
    r3.z = (r0.z) * (r0.w);
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
    r0 = (v6.xyzx) * (c3.zzzx) + (c3.xxxz);
    r5.w = dot(r1, c16.zzzz);
    r1.w = dot(r0, c[28]);
    r1.w = 1.0f / (r1.w);
    r2.x = dot(r0, c[27]);
    r1.x = dot(r0, c[25]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[26]);
    r0.w = dot(c[23].yz, r2.xy) + (c[23].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r0.xy) * (c40.zz) + (c40.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c3.x) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c42.z);
    r0.xy = (r1.ww) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r6.w = (r3.z) * (r0.w);
    r0.xy = (r0.xy) * (-(c3.yy)) + (-(c3.yy));
    r4 = tex2D(s4, r0.xy);
    r3 = (-(v6.yyyy)) + (c[6]);
    r2 = (-(v6.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v6.zzzz)) + (c[7]);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r0 = (r1) * (r1) + (r0);
    r7.xyz = (r6.www) * (r4.xyz);
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
    r2.y = c42.z;
    r0 = saturate((r0) * (c[8]) + (r2.yyyy));
    r2.xyz = (r7.xyz) * (r8.xyz) + (r9.xyz);
    r0 = (r1) * (r0);
    r1.z = dot(c[11], r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r0.w = dot(c[36].xyz, r6.xyz);
    r0.w = saturate((c[38].y) * (r0.w) + (c[38].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[37].xyz);
    r1.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[39].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c42.z;

    return oC0;
}
