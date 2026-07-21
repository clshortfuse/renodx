// Mechanically reconstructed from 0x32E51D68.ps_3_0.cso.
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
    const float4 c1 = float4(2.0f, -1.0f, -0.5f, 1.0f);
    const float4 c3 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c4 = float4(0.0f, -0.200000003f, 1.0f, 0.200000003f);
    const float4 c12 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c13 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c14 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c15 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c16 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c29 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c30 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c31 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s7, v7.zw);
    r2.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0 = (c1.xxxx) * (v9) + (c1.yyyy);
    r1.y = dot(r2.xy, r0.zw) + (c4.x);
    r1.x = dot(r2.xy, r0.xy) + (c4.x);
    r0 = tex2D(s1, v1.xy);
    r2.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0 = tex2D(s5, v7.zw);
    r5.w = (r0.w) * (v0.z);
    r10.xy = lerp(r2.xy, r1.xy, r5.ww);
    r4 = tex2D(s0, v1.xy);
    r2 = tex2D(s4, v7.xy);
    r0.w = (r2.w) * (v0.y) + (c1.z);
    r1.xy = (v1.zw) * (-(c1.yz));
    r3 = tex2D(s13, r1.xy);
    r1.xy = (v1.zw) * (c13.xy) + (c13.zy);
    r1 = tex2D(s13, r1.xy);
    r3.w = r1.y;
    r4.xyz = float3(((r0.w) >= 0.0f ? (r2.x) : (r4.x)), ((r0.w) >= 0.0f ? (r2.y) : (r4.y)), ((r0.w) >= 0.0f ? (r2.z) : (r4.z)));
    r2.xy = (r3.yw) * (c14.xx) + (c14.yy);
    r1.w = dot(r10.xy, r10.xy) + (c4.x);
    r1.y = dot(r2.xy, r2.xy) + (c4.x);
    r1.w = exp2(-(r1.w));
    r1.y = exp2(-(r1.y));
    r1.w = (r1.w) * (c12.x) + (c12.y);
    r2.w = (r1.y) * (c12.x) + (c12.y);
    r1.y = dot(r2.xy, r10.xy) + (c4.x);
    r3.w = (r1.w) * (r2.w);
    r2 = tex2D(s14, v1.zw);
    r6.xy = (r2.xy) * (c13.ww);
    r2.w = saturate((r1.y) * (r3.w) + (r3.w));
    r3.xy = (r3.xz) * (r6.xx);
    r1.y = (r2.x) * (c13.w) + (-(r3.x));
    r5.xy = (r1.xz) * (r6.yy);
    r1.y = (r3.z) * (-(r6.x)) + (r1.y);
    r1.x = (r2.y) * (c13.w) + (-(r5.x));
    r1.z = (r1.z) * (-(r6.y)) + (r1.x);
    r8.y = (r1.y) + (r1.y);
    r1.y = (r1.z) + (r1.z);
    r1.xz = (r5.xy) * (c14.xx);
    r1.xyz = (r2.www) * (r1.xyz);
    r8.xz = (r3.xy) * (c14.xx);
    r3.xyz = lerp(r4.xyz, r0.xyz, r5.www);
    r4.xyz = (r8.xyz) * (r1.www) + (r1.xyz);
    r1 = tex2D(s8, v1.xy);
    r3.w = ((r0.w) >= 0.0f ? (c1.w) : (r1.y));
    r2.w = -(r1.w);
    r2.xyz = c4.yyy;
    r0 = tex2D(s9, v7.zw);
    r0 = (r2) + (r0);
    r1 = (r1.wwww) * (c4.xxxz) + (c4.wwwx);
    r13.xyz = lerp(r3.www, c[27].xyw, r5.www);
    r0 = (r5.wwww) * (r0) + (r1);
    r1 = tex2D(s6, v8.xy);
    r1.xyz = (r1.xyz) + (c1.yyy);
    r1.w = dot(v6.xyz, v6.xyz);
    r5.xyz = (-(v6.xyz)) + (c[5].xyz);
    r2.w = rsqrt(r1.w);
    r1.w = dot(r5.xyz, r5.xyz);
    r1.w = rsqrt(r1.w);
    r6.xyz = (r2.www) * (v6.xyz);
    r1.xyz = (v0.www) * (r1.xyz) + (c1.www);
    r7.xyz = (r5.xyz) * (r1.www) + (-(r6.xyz));
    r2.xyz = normalize(r7.xyz);
    r9.xyz = (r5.xyz) * (r1.www);
    r5.xyz = (r0.xyz) * (r1.xyz);
    r0.z = saturate(dot(r2.xyz, r9.xyz));
    r14.xyz = (r5.xyz) * (-(r5.xyz)) + (c1.www);
    r1.w = (-(r0.z)) + (c1.w);
    r9.w = (r0.w) * (-(c14.z)) + (c14.w);
    r0.z = (r1.w) * (r1.w);
    r3.w = (r0.z) * (r0.z);
    r0.xyz = v2.xyz;
    r0.xyz = (r10.xxx) * (v4.xyz) + (r0.xyz);
    r4.w = (r1.w) * (r3.w);
    r0.xyz = (r10.yyy) * (v3.xyz) + (r0.xyz);
    r15.xyz = (r5.xyz) * (r5.xyz);
    r16.xyz = normalize(r0.xyz);
    r3.w = saturate(dot(r16.xyz, r2.xyz));
    r10.w = (r0.w) * (c12.w);
    r2.z = saturate(dot(r9.xyz, r16.xyz));
    r1.w = saturate(dot(r16.xyz, -(r6.xyz)));
    r0.z = (r2.z) * (r9.w) + (r10.w);
    r8.w = (r1.w) * (r9.w) + (r10.w);
    r0.z = (r0.z) * (r8.w) + (c15.x);
    r2.xy = (r0.ww) * (c31.xy) + (c31.zw);
    r0.y = 1.0f / (r0.z);
    r7.w = exp2(r2.y);
    r0.z = pow(abs(r3.w), r7.w);
    r5.w = (r7.w) * (c15.y) + (c15.z);
    r3.w = (r2.z) * (r0.y);
    r2.y = (r0.z) * (r5.w);
    r0.xyz = (r14.xyz) * (r4.www) + (r15.xyz);
    r2.y = (r3.w) * (r2.y);
    r12.xyz = (r4.xyz) * (r13.yyy);
    r0.xyz = (r0.xyz) * (r2.yyy);
    r1.xyz = (r3.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r10.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r13.zzz) * (r0.xyz);
    r0.xyz = (r2.zzz) * (c[6].xyz);
    r1.w = (-(r1.w)) + (c1.w);
    r5.xyz = (r10.xyz) * (r0.xyz) + (r1.xyz);
    r0.z = (r1.w) * (r1.w);
    r0.y = 1.0f / (r2.x);
    r0.z = (r1.w) * (r0.z);
    r1.w = (r0.y) * (r0.z);
    r0.w = (r0.w) * (c12.z);
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
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c4.z) : (c4.x));
    r11.xyz = (r6.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((c1.w) >= (v5.w))
        {
            r1 = (v5.xyzx) * (c4.zzzx);
            r0 = (r1) + (-(c29.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r2 = (r1) + (c16.xxyy);
            r2 = tex2Dlod(s2, r2);
            r0.x = r2.x;
            r2 = (r1) + (c16.zzyy);
            r2 = tex2Dlod(s2, r2);
            r0.y = r2.x;
            r1 = (r1) + (c29.xyzz);
            r1 = tex2Dlod(s2, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c15.zzzz);
            if ((c15.w) < (v5.w))
            {
                r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c16.xx);
                r0.zw = (v5.zx) * (c4.zx);
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (c16.zz);
                r1.zw = (v5.zx) * (c4.zx);
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c29.xy);
                r1.zw = (v5.zx) * (c4.zx);
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c29.xy));
                r1.zw = (v5.zx) * (c4.zx);
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c15.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v5.w) * (c30.x) + (c30.y);
                r0.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r0.w = r4.w;
            }
        }
        else
        {
            r0.w = (v5.w) + (-(c14.x));
            r0.w = ((r0.w) >= 0.0f ? (c4.x) : (c4.z));
            if ((r0.w) != (-(r0.w)))
            {
                r13.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r13.xy) + (c16.xx);
                r1.zw = (v5.zz) * (c4.zx);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r13.xy) + (c16.zz);
                r2.zw = (v5.zz) * (c4.zx);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r13.xy) + (c29.xy);
                r2.zw = (v5.zz) * (c4.zx);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r13.xy) + (-(c29.xy));
                r2.zw = (v5.zz) * (c4.zx);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c15.zzzz);
                r0.w = saturate((v5.w) + (c16.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
        }
    }
    r0.z = (-(r11.w)) + (c1.w);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.y) * (r0.y);
    r0.z = (r0.z) * (r0.y);
    r0.y = (r6.w) * (r9.w) + (r10.w);
    r0.y = (r0.y) * (r8.w) + (c15.x);
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
    r2.xyz = (r0.xyz) * (c12.zzz) + (r1.xyz);
    r1.z = (r0.w) * (c30.z) + (c30.w);
    r1.w = (r0.w) * (r0.w);
    r0 = (v6.xyzx) * (c4.zzzx) + (c4.xxxz);
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
    r3.xy = (r0.xy) * (c30.zz) + (c30.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c4.x) : (r0.z));
    r0.z = (r3.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r3.y)) + (c1.w);
    r0.xy = (r1.zz) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r1.w = (r1.w) * (r0.w);
    r0.xy = (r0.xy) * (-(c1.zz)) + (-(c1.zz));
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
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.w;

    return oC0;
}
