// Mechanically reconstructed from 0x97CB4AB8.ps_3_0.cso.
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
    const float4 c14 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c15 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c16 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c25 = float4(4.0f, -3.0f, 0.0f, 0.0f);
    const float4 c26 = float4(2.0f, -1.0f, 0.0f, 1.0f);
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
    r5.w = rsqrt(r0.w);
    r0 = tex2D(s6, v7.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c26.xxxx) * (v9) + (c26.yyyy);
    r2.y = dot(r1.xy, r0.zw) + (c26.z);
    r2.x = dot(r1.xy, r0.xy) + (c26.z);
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r1 = tex2D(s0, v1.xy);
    r0 = tex2D(s3, v7.xy);
    r3.w = (r0.w) * (v0.y);
    r7.xy = lerp(r3.xy, r2.xy, r3.ww);
    r0.w = dot(r7.xy, r7.xy) + (c26.z);
    r5.xyz = lerp(r1.xyz, r0.xyz, r3.www);
    r0.w = exp2(-(r0.w));
    r4.w = (r0.w) * (c3.x) + (c3.y);
    r0.xy = (v1.zw) * (c4.xy);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r0 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v1.zw);
    r3.xy = (r1.xy) * (c4.ww);
    r2.w = r0.y;
    r4.xy = (r2.xz) * (r3.xx);
    r6.xy = (r2.yw) * (c12.xx) + (c12.yy);
    r0.y = (r1.x) * (c4.w) + (-(r4.x));
    r0.w = dot(r6.xy, r7.xy) + (c26.z);
    r1.w = (r2.z) * (-(r3.x)) + (r0.y);
    r2.xy = (r0.xz) * (r3.yy);
    r0.x = dot(r6.xy, r6.xy) + (c26.z);
    r0.y = (r1.y) * (c4.w) + (-(r2.x));
    r0.x = exp2(-(r0.x));
    r0.y = (r0.z) * (-(r3.y)) + (r0.y);
    r0.z = (r0.x) * (c3.x) + (c3.y);
    r10.y = (r1.w) + (r1.w);
    r0.z = (r4.w) * (r0.z);
    r0.y = (r0.y) + (r0.y);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r0.xz = (r2.xy) * (c12.xx);
    r1.xyz = (v6.xyz) * (-(r5.www)) + (c[17].xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r3.xyz = normalize(r1.xyz);
    r10.xz = (r4.xy) * (c12.xx);
    r0.w = saturate(dot(r3.xyz, c[17].xyz));
    r2.xyz = (r10.xyz) * (r4.www) + (r0.xyz);
    r2.w = (-(r0.w)) + (c26.w);
    r0 = tex2D(s4, v7.zw);
    r0.xyz = (r0.xyz) + (c26.yyy);
    r4.w = (r2.w) * (r2.w);
    r6.xyz = (v0.zzz) * (r0.xyz) + (c26.www);
    r0 = tex2D(s7, v1.xy);
    r1 = tex2D(s5, v8.xy);
    r1.xyz = (r1.xyz) + (c26.yyy);
    r0.xyz = (r6.xyz) * (r0.xyz);
    r4.xyz = (v0.www) * (r1.xyz) + (c26.www);
    r1.w = (r4.w) * (r4.w);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r1.w = (r2.w) * (r1.w);
    r11.xyz = (r0.xyz) * (-(r0.xyz)) + (c26.www);
    r12.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r5.xyz) * (r6.xyz);
    r0.xyz = (r11.xyz) * (r1.www) + (r12.xyz);
    r1.xyz = (r4.xyz) * (r1.xyz);
    r6.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = v2.xyz;
    r1.xyz = (r7.xxx) * (v4.xyz) + (r1.xyz);
    r1.w = (r0.w) * (-(c12.z)) + (c12.w);
    r1.xyz = (r7.yyy) * (v3.xyz) + (r1.xyz);
    r9.xyz = normalize(r1.xyz);
    r16.xy = (r0.ww) * (c14.xy) + (c14.zw);
    r1.y = (r0.w) * (c3.w);
    r4.w = exp2(r16.y);
    r3.z = saturate(dot(r9.xyz, r3.xyz));
    r7.xyz = (r5.www) * (v6.xyz);
    r6.w = saturate(dot(r9.xyz, -(r7.xyz)));
    r2.w = saturate(dot(r9.xyz, c[17].xyz));
    r1.z = (r6.w) * (r1.w) + (r1.y);
    r1.w = (r2.w) * (r1.w) + (r1.y);
    r1.y = pow(abs(r3.z), r4.w);
    r1.z = (r1.w) * (r1.z) + (c13.x);
    r1.w = (r4.w) * (c13.y) + (c13.z);
    r1.z = 1.0f / (r1.z);
    r1.w = (r1.y) * (r1.w);
    r3.z = (r2.w) * (r1.z);
    r8.zw = c26.zw;
    r1.xyz = (r8.zwz) + (-(c[23].xyw));
    r1.w = (r1.w) * (r3.z);
    r13.xyz = (r3.www) * (r1.xyz) + (c[23].xyw);
    r0.xyz = (r0.xyz) * (r1.www);
    r14.xyz = (r2.xyz) * (r13.yyy);
    r15.xyz = (r13.zzz) * (r0.xyz);
    r1 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c26.w) : (c26.z));
    r8.xyz = (r2.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r1.w = r0.z;
    }
    else
    {
        if ((c26.w) >= (v5.w))
        {
            r2 = (v5.xyzx) * (c26.wwwz);
            r1 = (r2) + (-(c15.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r3 = (r2) + (c16.xxyy);
            r3 = tex2Dlod(s2, r3);
            r1.x = r3.x;
            r3 = (r2) + (c16.zzyy);
            r3 = tex2Dlod(s2, r3);
            r1.y = r3.x;
            r2 = (r2) + (c15.xyzz);
            r2 = tex2Dlod(s2, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c13.zzzz);
            if ((c13.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c16.xx);
                r1.zw = (v5.zx) * (c26.wz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r0.xy) + (c16.zz);
                r2.zw = (v5.zx) * (c26.wz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (c15.xy);
                r2.zw = (v5.zx) * (c26.wz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (-(c15.xy));
                r2.zw = (v5.zx) * (c26.wz);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c13.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c25.x) + (c25.y);
                r1.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r1.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c12.x));
            r0.z = ((r0.z) >= 0.0f ? (c26.z) : (c26.w));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c16.xx);
                r2.zw = (v5.zz) * (c26.wz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c16.zz);
                r3.zw = (v5.zz) * (c26.wz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c15.xy);
                r3.zw = (v5.zz) * (c26.wz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c15.xy));
                r3.zw = (v5.zz) * (c26.wz);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c13.zzzz);
                r0.z = saturate((v5.w) + (c16.w));
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
    r1.xyz = (r15.xyz) * (c[19].xyz);
    r0.xyz = (r1.www) * (r8.xyz) + (r14.xyz);
    r1.xyz = (r1.www) * (r1.xyz);
    r8.xyz = (r6.xyz) * (r0.xyz) + (r1.xyz);
    r0.z = (-(r6.w)) + (c26.w);
    r0.x = 1.0f / (r16.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r7.xyz, r9.xyz);
    r4.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r0.w = (r0.w) * (c3.z);
    r0.xyz = (r9.xyz) * (-(r0.zzz)) + (r7.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r4.xyz = (r13.xxx) * (r0.xyz);
    r3 = (-(v6.yyyy)) + (c[6]);
    r2 = (-(v6.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v6.zzzz)) + (c[7]);
    r5.xyz = (r11.xyz) * (r4.www) + (r12.xyz);
    r0 = (r1) * (r1) + (r0);
    r5.xyz = (r4.xyz) * (r5.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r5.xyz = (r10.xyz) * (r5.xyz);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r0 = saturate((r0) * (c[8]) + (r8.wwww));
    r2.xyz = (r5.xyz) * (c3.zzz) + (r8.xyz);
    r0 = (r1) * (r0);
    r1.z = dot(c[11], r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r0.w = dot(c[20].xyz, r7.xyz);
    r0.w = saturate((c[22].y) * (r0.w) + (c[22].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[21].xyz);
    r1.xyz = (r6.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c26.w;

    return oC0;
}
