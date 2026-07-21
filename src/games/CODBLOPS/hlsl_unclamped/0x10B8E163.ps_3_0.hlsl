// Mechanically reconstructed from 0x10B8E163.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 1.0f, -1.0f, 0.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c4 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c12 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c15 = float4(0.797884583f, 1.0f, 0.125f, 0.25f);
    const float4 c16 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r3.w = dot(v7.xyz, v7.xyz);
    r2 = tex2D(s1, v1.xy);
    r0.xy = (v1.zw) * (-(c1.zx));
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (-(c1.zx)) + (-(c1.wx));
    r0 = tex2D(s13, r0.xy);
    r1.w = r0.y;
    r5.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r2.xy = (r1.yw) * (c4.yy) + (c4.zz);
    r0.w = dot(r5.xy, r5.xy) + (c1.w);
    r0.y = dot(r2.xy, r2.xy) + (c1.w);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c3.x) + (c3.y);
    r1.w = (r0.y) * (c3.x) + (c3.y);
    r0.y = dot(r2.xy, r5.xy) + (c1.w);
    r1.w = (r0.w) * (r1.w);
    r11.w = rsqrt(r3.w);
    r1.w = saturate((r0.y) * (r1.w) + (r1.w));
    r2 = tex2D(s14, v1.zw);
    r6.xy = (r2.xy) * (c4.xx);
    r3.xy = (r1.xz) * (r6.xx);
    r4.xy = (r0.xz) * (r6.yy);
    r0.y = (r2.x) * (c4.x) + (-(r3.x));
    r0.x = (r2.y) * (c4.x) + (-(r4.x));
    r0.y = (r1.z) * (-(r6.x)) + (r0.y);
    r0.z = (r0.z) * (-(r6.y)) + (r0.x);
    r8.y = (r0.y) + (r0.y);
    r1.xyz = (-(v7.xyz)) + (c[20].xyz);
    r0.y = (r0.z) + (r0.z);
    r0.z = dot(r1.xyz, r1.xyz);
    r2.w = rsqrt(r0.z);
    r14.xyz = (r11.www) * (v7.xyz);
    r0.xz = (r4.xy) * (c4.yy);
    r2.xyz = (r1.xyz) * (r2.www) + (-(r14.xyz));
    r13.xyz = normalize(r2.xyz);
    r15.xyz = (r1.xyz) * (r2.www);
    r0.xyz = (r1.www) * (r0.xyz);
    r1.w = saturate(dot(r13.xyz, r15.xyz));
    r8.xz = (r3.xy) * (c4.yy);
    r1.w = (-(r1.w)) + (c1.y);
    r3.xyz = (r8.xyz) * (r0.www) + (r0.xyz);
    r0.w = (r1.w) * (r1.w);
    r8.w = dot(r15.xyz, c[29].xyz);
    r1.z = (r0.w) * (r0.w);
    r0 = tex2D(s6, v8.zw);
    r0.xyz = (r0.xyz) + (c1.zzz);
    r0.w = (r1.w) * (r1.z);
    r4.xyz = (v0.zzz) * (r0.xyz) + (c1.yyy);
    r1 = tex2D(s0, v1.xy);
    r2 = tex2D(s7, v1.xy);
    r0.xyz = (r4.xyz) * (r2.xyz);
    r11.xyz = (r0.xyz) * (-(r0.xyz)) + (c1.yyy);
    r12.xyz = (r0.xyz) * (r0.xyz);
    r10.xyz = (r11.xyz) * (r0.www) + (r12.xyz);
    r0 = tex2D(s5, v8.xy);
    r0.w = (r0.w) * (v0.y) + (c1.x);
    r10.w = (r2.w) * (-(c15.x)) + (c15.y);
    r0.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (r1.x)), ((r0.w) >= 0.0f ? (r0.y) : (r1.y)), ((r0.w) >= 0.0f ? (r0.z) : (r1.z)));
    r0.xyz = (r4.xyz) * (r0.xyz);
    r7.w = c1.y;
    r2.xyz = float3(((r0.w) >= 0.0f ? (r7.w) : (c[36].x)), ((r0.w) >= 0.0f ? (r7.w) : (c[36].y)), ((r0.w) >= 0.0f ? (r7.w) : (c[36].w)));
    r7.xyz = (r0.xyz) * (r0.xyz);
    r17.xyz = (r3.xyz) * (r2.yyy);
    r1 = tex2D(s12, v1.zw);
    r0 = v2;
    r0.xyz = (r5.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r5.yyy) * (v4.xyz) + (r0.xyz);
    r9.xyz = normalize(r0.xyz);
    r9.w = saturate(dot(r9.xyz, c[17].xyz));
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c1.y) : (c1.w));
    r16.xyz = (r9.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r2.y = r0.z;
    }
    else
    {
        if ((c1.y) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c1.yyyw);
            r1 = (r3) + (-(c13.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r4 = (r3) + (c12.xxyy);
            r4 = tex2Dlod(s2, r4);
            r1.x = r4.x;
            r4 = (r3) + (c12.zzyy);
            r4 = tex2Dlod(s2, r4);
            r1.y = r4.x;
            r3 = (r3) + (c13.xyzz);
            r3 = tex2Dlod(s2, r3);
            r1.z = r3.x;
            r2.y = dot(r1, c15.wwww);
            if ((c12.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c12.xx);
                r1.zw = (v6.zx) * (c1.yw);
                r1 = tex2Dlod(s2, r1);
                r3.xy = (r0.xy) + (c12.zz);
                r3.zw = (v6.zx) * (c1.yw);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c13.xy);
                r3.zw = (v6.zx) * (c1.yw);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c13.xy));
                r3.zw = (v6.zx) * (c1.yw);
                r3 = tex2Dlod(s2, r3);
                r1.y = r5.x;
                r1.z = r4.x;
                r1.w = r3.x;
                r0.z = dot(r1, c15.wwww);
                r0.y = (-(r2.y)) + (r0.z);
                r0.z = (v6.w) * (c14.x) + (c14.y);
                r2.y = (r0.z) * (r0.y) + (r2.y);
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c4.y));
            r0.z = ((r0.z) >= 0.0f ? (c1.w) : (c1.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c12.xx);
                r3.zw = (v6.zz) * (c1.yw);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c12.zz);
                r4.zw = (v6.zz) * (c1.yw);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c13.xy);
                r4.zw = (v6.zz) * (c1.yw);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c13.xy));
                r4.zw = (v6.zz) * (c1.yw);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c15.wwww);
                r0.z = saturate((v6.w) + (c13.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
            r2.y = r0.z;
        }
    }
    r3.xyz = (r2.yyy) * (r16.xyz) + (r17.xyz);
    r5.z = (r2.w) * (c3.w);
    r3.w = saturate(dot(r15.xyz, r9.xyz));
    r1.w = (r3.w) * (r10.w) + (r5.z);
    r4.z = saturate(dot(r9.xyz, -(r14.xyz)));
    r1.xyz = (v7.xyz) * (-(r11.www)) + (c[17].xyz);
    r5.w = (r4.z) * (r10.w) + (r5.z);
    r0.xyz = normalize(r1.xyz);
    r1.z = (r1.w) * (r5.w) + (c4.w);
    r1.w = saturate(dot(r0.xyz, c[17].xyz));
    r1.z = 1.0f / (r1.z);
    r4.w = (r3.w) * (r1.z);
    r6.w = (-(r1.w)) + (c1.y);
    r1.z = (r6.w) * (r6.w);
    r1.w = dot(r14.xyz, r9.xyz);
    r6.z = (r1.z) * (r1.z);
    r1.z = (r1.w) + (r1.w);
    r1.w = (r2.w) * (c3.z);
    r1.xyz = (r9.xyz) * (-(r1.zzz)) + (r14.xyz);
    r1 = texCUBElod(s15, r1);
    r1.w = (-(r4.z)) + (c1.y);
    r4.z = (r1.w) * (r1.w);
    r5.xy = (r2.ww) * (c16.xy) + (c16.zw);
    r1.w = (r1.w) * (r4.z);
    r2.w = 1.0f / (r5.x);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r2.w);
    r1.xyz = (r2.xxx) * (r1.xyz);
    r4.xyz = (r11.xyz) * (r1.www) + (r12.xyz);
    r2.w = (r6.w) * (r6.z);
    r1.xyz = (r1.xyz) * (r4.xyz);
    r4.y = exp2(r5.y);
    r4.z = saturate(dot(r9.xyz, r13.xyz));
    r1.w = (r4.y) * (c15.z) + (c15.w);
    r2.x = (r9.w) * (r10.w) + (r5.z);
    r4.x = (r2.x) * (r5.w) + (c4.w);
    r2.x = saturate(dot(r9.xyz, r0.xyz));
    r0.y = 1.0f / (r4.x);
    r0.z = pow(abs(r2.x), r4.y);
    r0.y = (r9.w) * (r0.y);
    r0.z = (r1.w) * (r0.z);
    r2.x = (r0.y) * (r0.z);
    r0.xyz = (r11.xyz) * (r2.www) + (r12.xyz);
    r2.w = pow(abs(r4.z), r4.y);
    r0.xyz = (r2.xxx) * (r0.xyz);
    r1.w = (r1.w) * (r2.w);
    r0.xyz = (r2.zzz) * (r0.xyz);
    r1.w = (r4.w) * (r1.w);
    r4.xyz = (r0.xyz) * (c[19].xyz);
    r0.xyz = (r10.xyz) * (r1.www);
    r4.xyz = (r2.yyy) * (r4.xyz);
    r3.xyz = (r7.xyz) * (r3.xyz) + (r4.xyz);
    r1.xyz = (r8.xyz) * (r1.xyz);
    r8.xyz = (r1.xyz) * (c3.zzz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (c[22].xyz);
    r2.xyz = (r2.zzz) * (r0.xyz);
    r1 = (v7.yyyy) * (c[32]);
    r0.xyz = (r3.www) * (c[21].xyz);
    r1 = (v7.xxxx) * (c[31]) + (r1);
    r6.xyz = (r7.xyz) * (r0.xyz) + (r2.xyz);
    r1 = (v7.zzzz) * (c[33]) + (r1);
    r0.z = saturate((r8.w) * (c[30].x) + (c[30].y));
    r4 = (r1) + (c[34]);
    r0.y = (r0.z) * (c14.z) + (c14.w);
    r3.zw = r4.zw;
    r0.z = (r0.z) * (r0.z);
    r5.zw = r3.zw;
    r4.z = (r0.y) * (r0.z);
    r1.zw = r5.zw;
    r2.xy = (r4.ww) * (-(c[35].zw)) + (r4.xy);
    r2.zw = r1.zw;
    r2 = tex2Dproj(s3, r2);
    r2.w = r2.x;
    r5.xy = (r3.ww) * (-(c[35].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r2.y = r5.x;
    r3.xy = (r3.ww) * (c[35].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r2.x = r5.x;
    r1.xy = (r3.ww) * (c[35].zw) + (r4.xy);
    r1 = tex2Dproj(s3, r1);
    r2.z = r1.x;
    r1 = (v7.xyzx) * (c1.yyyw) + (c1.wwwy);
    r6.w = dot(r2, c15.wwww);
    r0.z = dot(r1, c[28]);
    r2.w = 1.0f / (r0.z);
    r2.x = dot(r1, c[27]);
    r0.x = dot(r1, c[25]);
    r2.y = (r2.x) * (r2.x);
    r0.y = dot(r1, c[26]);
    r0.z = dot(c[23].yz, r2.xy) + (c[23].x);
    r1.w = saturate(1.0f / (r0.z));
    r1.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r1.xy) * (c14.zz) + (c14.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.w) : (r1.w));
    r1.w = (r2.x) * (r1.x);
    r0.z = (r0.z) * (r1.w);
    r1.w = (r1.y) * (-(r2.y)) + (c1.y);
    r0.xy = (r2.ww) * (r0.xy);
    r0.z = (r0.z) * (r1.w);
    r8.w = (r4.z) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.xx)) + (-(c1.xx));
    r5 = tex2D(s4, r0.xy);
    r4 = (-(v7.yyyy)) + (c[6]);
    r3 = (-(v7.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v7.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r0.xyz = (r5.xyz) * (r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = (r8.www) * (r0.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r1 = saturate((r1) * (c[8]) + (r7.wwww));
    r0.xyz = (r6.www) * (r0.xyz);
    r1 = (r2) * (r1);
    r2.xyz = (r0.xyz) * (r6.xyz) + (r8.xyz);
    r0.z = dot(c[11], r1);
    r0.x = dot(c[9], r1);
    r0.y = dot(c[10], r1);
    r0.xyz = (r7.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.y;

    return oC0;
}
