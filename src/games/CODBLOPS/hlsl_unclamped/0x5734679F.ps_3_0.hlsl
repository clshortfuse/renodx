// Mechanically reconstructed from 0x5734679F.ps_3_0.cso.
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c12 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c16 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c31 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
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

    r0.w = dot(v7.xyz, v7.xyz);
    r15.w = rsqrt(r0.w);
    r0 = tex2D(s1, v1.xy);
    r1.xyz = (-(v7.xyz)) + (c[5].xyz);
    r0.z = dot(r1.xyz, r1.xyz);
    r0.z = rsqrt(r0.z);
    r14.xyz = (r15.www) * (v7.xyz);
    r3.xyz = (r1.xyz) * (r0.zzz) + (-(r14.xyz));
    r2.xyz = normalize(r3.xyz);
    r3.xyz = (r1.xyz) * (r0.zzz);
    r0.z = saturate(dot(r2.xyz, r3.xyz));
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = (-(r0.z)) + (c1.y);
    r0.y = dot(r3.xyz, c[22].xyz);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r1.z = saturate((r0.y) * (c[23].x) + (c[23].y));
    r4.z = (r0.w) * (r0.z);
    r1.w = (r1.z) * (c15.z) + (c15.w);
    r0 = tex2D(s0, v1.xy);
    r4.w = (r0.w) * (v0.w) + (c1.x);
    r0.w = (r1.z) * (r1.z);
    r7.xy = float2(((r4.w) >= 0.0f ? (r1.x) : (c1.z)), ((r4.w) >= 0.0f ? (r1.y) : (c1.z)));
    r8.w = (r1.w) * (r0.w);
    r1 = v2;
    r1.xyz = (r7.xxx) * (v5.xyz) + (r1.xyz);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1.xyz = (r7.yyy) * (v4.xyz) + (r1.xyz);
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (c1.z)), ((r4.w) >= 0.0f ? (r0.y) : (c1.z)), ((r4.w) >= 0.0f ? (r0.z) : (c1.z)), ((r4.w) >= 0.0f ? (r0.w) : (c1.z)));
    r13.xyz = normalize(r1.xyz);
    r1.xyz = (r0.xyz) * (v0.xyz);
    r4.y = saturate(dot(r13.xyz, r2.xyz));
    r2 = tex2D(s5, v1.xy);
    r2 = float4(((r4.w) >= 0.0f ? (r2.x) : (c1.z)), ((r4.w) >= 0.0f ? (r2.y) : (c1.z)), ((r4.w) >= 0.0f ? (r2.z) : (c1.z)), ((r4.w) >= 0.0f ? (r2.w) : (c1.y)));
    r11.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.yyy);
    r12.xyz = (r2.xyz) * (r2.xyz);
    r13.w = (r2.w) * (-(c31.z)) + (c31.w);
    r14.w = (r2.w) * (c3.z);
    r3.w = saturate(dot(r3.xyz, r13.xyz));
    r16.w = saturate(dot(r13.xyz, -(r14.xyz)));
    r0.z = (r3.w) * (r13.w) + (r14.w);
    r12.w = (r16.w) * (r13.w) + (r14.w);
    r0.z = (r0.z) * (r12.w) + (c12.x);
    r16.xy = (r2.ww) * (c16.xy) + (c16.zw);
    r0.y = 1.0f / (r0.z);
    r11.w = exp2(r16.y);
    r0.z = pow(abs(r4.y), r11.w);
    r9.w = (r11.w) * (c12.y) + (c12.z);
    r2.y = (r3.w) * (r0.y);
    r2.z = (r0.z) * (r9.w);
    r0.xyz = (r11.xyz) * (r4.zzz) + (r12.xyz);
    r2.z = (r2.y) * (r2.z);
    r8.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r2.zzz);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r1.y = c1.z;
    r10.xyz = float3(((r4.w) >= 0.0f ? (c[29].x) : (r1.y)), ((r4.w) >= 0.0f ? (c[29].y) : (r1.y)), ((r4.w) >= 0.0f ? (c[29].w) : (r1.y)));
    r2.xyz = (r0.xyz) * (r10.zzz);
    r0.z = dot(r7.xy, r7.xy) + (c1.z);
    r1.xyz = (r3.www) * (c[6].xyz);
    r0.z = exp2(-(r0.z));
    r6.w = (r0.z) * (c3.x) + (c3.y);
    r0.xy = (v1.zw) * (c4.xy);
    r5 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r3 = tex2D(s13, r0.xy);
    r5.w = r3.y;
    r4 = tex2D(s14, v1.zw);
    r0.xy = (r4.xy) * (c3.ww);
    r6.xy = (r5.yw) * (c31.xx) + (c31.yy);
    r5.xy = (r5.xz) * (r0.xx);
    r0.z = dot(r6.xy, r7.xy) + (c1.z);
    r3.w = (r4.x) * (c3.w) + (-(r5.x));
    r3.w = (r5.z) * (-(r0.x)) + (r3.w);
    r3.xy = (r3.xz) * (r0.yy);
    r4.w = (r4.y) * (c3.w) + (-(r3.x));
    r0.x = dot(r6.xy, r6.xy) + (c1.z);
    r0.y = (r3.z) * (-(r0.y)) + (r4.w);
    r0.x = exp2(-(r0.x));
    r9.y = (r3.w) + (r3.w);
    r0.x = (r0.x) * (c3.x) + (c3.y);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r6.w) * (r0.x);
    r3.w = saturate((r0.z) * (r0.x) + (r0.x));
    r0.xz = (r3.xy) * (c4.ww);
    r0.xyz = (r0.xyz) * (r3.www);
    r9.xz = (r5.xy) * (c4.ww);
    r1.xyz = (r8.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r9.xyz) * (r6.www) + (r0.xyz);
    r15.xyz = (r10.yyy) * (r0.xyz);
    r10.w = saturate(dot(r13.xyz, c[17].xyz));
    r3 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r3.y)) >= 0.0f ? (c1.y) : (c1.z));
    r2.xyz = (r10.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r3.y;
        r3.w = r0.z;
    }
    else
    {
        if ((c1.y) >= (v6.w))
        {
            r4 = (v6.xyzx) * (c1.yyyz);
            r3 = (r4) + (-(c13.xyzz));
            r3 = tex2Dlod(s2, r3);
            r3.w = r3.x;
            r5 = (r4) + (c14.xxyy);
            r5 = tex2Dlod(s2, r5);
            r3.x = r5.x;
            r5 = (r4) + (c14.zzyy);
            r5 = tex2Dlod(s2, r5);
            r3.y = r5.x;
            r4 = (r4) + (c13.xyzz);
            r4 = tex2Dlod(s2, r4);
            r3.z = r4.x;
            r0.z = dot(r3, c12.zzzz);
            if ((c12.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c14.xx);
                r3.zw = (v6.zx) * (c1.yz);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c14.zz);
                r4.zw = (v6.zx) * (c1.yz);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c13.xy);
                r4.zw = (v6.zx) * (c1.yz);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c13.xy));
                r4.zw = (v6.zx) * (c1.yz);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.y = dot(r3, c12.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v6.w) * (c15.x) + (c15.y);
                r3.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r3.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c4.w));
            r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r4.xy = (r0.xy) + (c14.xx);
                r4.zw = (v6.zz) * (c1.yz);
                r4 = tex2Dlod(s2, r4);
                r5.xy = (r0.xy) + (c14.zz);
                r5.zw = (v6.zz) * (c1.yz);
                r7 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (c13.xy);
                r5.zw = (v6.zz) * (c1.yz);
                r6 = tex2Dlod(s2, r5);
                r5.xy = (r0.xy) + (-(c13.xy));
                r5.zw = (v6.zz) * (c1.yz);
                r5 = tex2Dlod(s2, r5);
                r4.y = r7.x;
                r4.z = r6.x;
                r4.w = r5.x;
                r0.x = dot(r4, c12.zzzz);
                r0.z = saturate((v6.w) + (c14.w));
                r0.y = (r3.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r3.y;
            }
            r3.w = r0.z;
        }
    }
    r3.xyz = (r3.www) * (r2.xyz) + (r15.xyz);
    r0.z = (-(r16.w)) + (c1.y);
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r14.xyz, r13.xyz);
    r4.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r2.w) * (c1.w);
    r2.xyz = (r13.xyz) * (-(r0.zzz)) + (r14.xyz);
    r2 = texCUBElod(s15, r2);
    r4.xyz = (v7.xyz) * (-(r15.www)) + (c[17].xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = normalize(r4.xyz);
    r0.xyz = (r10.xxx) * (r0.xyz);
    r2.w = saturate(dot(r2.xyz, c[17].xyz));
    r4.xyz = (r11.xyz) * (r4.www) + (r12.xyz);
    r2.w = (-(r2.w)) + (c1.y);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r4.w = (r2.w) * (r2.w);
    r4.w = (r4.w) * (r4.w);
    r4.z = (r10.w) * (r13.w) + (r14.w);
    r4.y = (r4.z) * (r12.w) + (c12.x);
    r4.z = saturate(dot(r13.xyz, r2.xyz));
    r2.y = 1.0f / (r4.y);
    r2.z = pow(abs(r4.z), r11.w);
    r2.y = (r10.w) * (r2.y);
    r2.z = (r9.w) * (r2.z);
    r2.w = (r2.w) * (r4.w);
    r4.w = (r2.y) * (r2.z);
    r4.xyz = (r11.xyz) * (r2.www) + (r12.xyz);
    r2 = (v7.yyyy) * (c[25]);
    r4.xyz = (r4.www) * (r4.xyz);
    r2 = (v7.xxxx) * (c[24]) + (r2);
    r4.xyz = (r10.zzz) * (r4.xyz);
    r2 = (v7.zzzz) * (c[26]) + (r2);
    r4.xyz = (r4.xyz) * (c[19].xyz);
    r5 = (r2) + (c[27]);
    r2.xyz = (r3.www) * (r4.xyz);
    r4.zw = r5.zw;
    r8.xyz = (r8.xyz) * (r3.xyz) + (r2.xyz);
    r6.zw = r4.zw;
    r7.xyz = (r9.xyz) * (r0.xyz);
    r3.zw = r6.zw;
    r2.xy = (r5.ww) * (-(c[28].zw)) + (r5.xy);
    r2.zw = r3.zw;
    r2 = tex2Dproj(s3, r2);
    r2.w = r2.x;
    r6.xy = (r4.ww) * (-(c[28].xy)) + (r5.xy);
    r6 = tex2Dproj(s3, r6);
    r2.y = r6.x;
    r4.xy = (r4.ww) * (c[28].xy) + (r5.xy);
    r6 = tex2Dproj(s3, r4);
    r2.x = r6.x;
    r3.xy = (r4.ww) * (c[28].zw) + (r5.xy);
    r4 = tex2Dproj(s3, r3);
    r3 = (v7.xyzx) * (c1.yyyz) + (c1.zzzy);
    r2.z = r4.x;
    r0.z = dot(r3, c[21]);
    r4.w = 1.0f / (r0.z);
    r4.x = dot(r3, c[20]);
    r0.x = dot(r3, c[10]);
    r4.y = (r4.x) * (r4.x);
    r0.y = dot(r3, c[11]);
    r0.z = dot(c[8].yz, r4.xy) + (c[8].x);
    r3.w = saturate(1.0f / (r0.z));
    r3.xy = saturate((r4.xx) * (c[9].xy) + (c[9].zw));
    r4.xy = (r3.xy) * (c15.zz) + (c15.ww);
    r3.xy = (r3.xy) * (r3.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.z) : (r3.w));
    r3.w = (r4.x) * (r3.x);
    r0.z = (r0.z) * (r3.w);
    r3.w = (r3.y) * (-(r4.y)) + (c1.y);
    r0.xy = (r4.ww) * (r0.xy);
    r0.z = (r0.z) * (r3.w);
    r4.w = (r8.w) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.xx)) + (-(c1.xx));
    r3 = tex2D(s4, r0.xy);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r2.w = dot(r2, c12.zzzz);
    r0.xyz = (r4.www) * (r0.xyz);
    r2.xyz = (r7.xyz) * (c1.www) + (r8.xyz);
    r0.xyz = (r2.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
