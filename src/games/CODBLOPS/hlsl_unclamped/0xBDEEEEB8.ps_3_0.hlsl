// Mechanically reconstructed from 0xBDEEEEB8.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD4;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
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
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c3 = float4(1.0f, 0.797884583f, 0.5f, 0.0f);
    const float4 c4 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c13 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c15 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r1 = tex2D(s0, v0.xy);
    r0 = tex2D(s4, v7.zw);
    r4.w = (r0.w) * (v7.y);
    r2.xyz = lerp(r1.xyz, r0.xyz, r4.www);
    r8.xyz = (r2.xyz) * (r2.xyz);
    r0 = tex2D(s5, v7.zw);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2 = tex2D(s6, v0.xy);
    r0 = tex2D(s7, v7.zw);
    r1 = lerp(r2, r0, r4.wwww);
    r5.xy = (r4.ww) * (r3.xy);
    r11.xyz = (r1.xyz) * (-(r1.xyz)) + (c3.xxx);
    r0.w = dot(r5.xy, r5.xy) + (c1.x);
    r11.w = (r1.w) * (-(c3.y)) + (c3.x);
    r0.w = exp2(-(r0.w));
    r5.w = (r0.w) * (c1.y) + (c1.z);
    r0.w = dot(v6.xyz, v6.xyz);
    r13.w = rsqrt(r0.w);
    r0.xy = (v0.zw) * (c3.xz);
    r3 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c3.xz) + (c3.wz);
    r0 = tex2D(s13, r0.xy);
    r3.w = r0.y;
    r2 = tex2D(s14, v0.zw);
    r4.xy = (r2.xy) * (c4.xx);
    r7.xy = (r3.yw) * (c4.yy) + (c4.zz);
    r6.xy = (r3.xz) * (r4.xx);
    r0.w = dot(r7.xy, r5.xy) + (c1.x);
    r0.y = (r2.x) * (c4.x) + (-(r6.x));
    r2.w = (r3.z) * (-(r4.x)) + (r0.y);
    r3.xy = (r0.xz) * (r4.yy);
    r0.y = (r2.y) * (c4.x) + (-(r3.x));
    r0.x = dot(r7.xy, r7.xy) + (c1.x);
    r0.y = (r0.z) * (-(r4.y)) + (r0.y);
    r0.z = exp2(-(r0.x));
    r10.y = (r2.w) + (r2.w);
    r0.z = (r0.z) * (c1.y) + (c1.z);
    r0.y = (r0.y) + (r0.y);
    r0.z = (r5.w) * (r0.z);
    r2.w = saturate((r0.w) * (r0.z) + (r0.z));
    r2.xyz = (-(v6.xyz)) + (c[5].xyz);
    r0.xz = (r3.xy) * (c4.yy);
    r0.w = dot(r2.xyz, r2.xyz);
    r0.w = rsqrt(r0.w);
    r15.xyz = (r13.www) * (v6.xyz);
    r0.xyz = (r0.xyz) * (r2.www);
    r3.xyz = (r2.xyz) * (r0.www) + (-(r15.xyz));
    r4.xyz = normalize(r3.xyz);
    r9.xyz = (r2.xyz) * (r0.www);
    r10.xz = (r6.xy) * (c4.yy);
    r0.w = saturate(dot(r4.xyz, r9.xyz));
    r2.xyz = (r10.xyz) * (r5.www) + (r0.xyz);
    r2.w = (-(r0.w)) + (c3.x);
    r0.xyw = c[29].xyw;
    r3.xyz = (-(r0.xyw)) + (c[30].xyw);
    r0.w = (r2.w) * (r2.w);
    r3.w = (r0.w) * (r0.w);
    r0 = v1;
    r0.xyz = (r5.xxx) * (v4.xyz) + (r0.xyz);
    r3.w = (r2.w) * (r3.w);
    r0.xyz = (r5.yyy) * (v3.xyz) + (r0.xyz);
    r12.xyz = (r1.xyz) * (r1.xyz);
    r14.xyz = normalize(r0.xyz);
    r1.z = saturate(dot(r14.xyz, r4.xyz));
    r12.w = (r1.w) * (c3.y);
    r2.w = saturate(dot(r9.xyz, r14.xyz));
    r14.w = saturate(dot(r14.xyz, -(r15.xyz)));
    r0.z = (r2.w) * (r11.w) + (r12.w);
    r10.w = (r14.w) * (r11.w) + (r12.w);
    r0.z = (r0.z) * (r10.w) + (c4.w);
    r17.xy = (r1.ww) * (c15.xy) + (c15.zw);
    r0.y = 1.0f / (r0.z);
    r9.w = exp2(r17.y);
    r0.z = pow(abs(r1.z), r9.w);
    r7.w = (r9.w) * (c13.x) + (c13.y);
    r1.y = (r2.w) * (r0.y);
    r1.z = (r0.z) * (r7.w);
    r0.xyz = (r11.xyz) * (r3.www) + (r12.xyz);
    r1.z = (r1.y) * (r1.z);
    r13.xyz = (r4.www) * (r3.xyz) + (c[29].xyw);
    r0.xyz = (r0.xyz) * (r1.zzz);
    r16.xyz = (r2.xyz) * (r13.yyy);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r1.xyz = (r13.zzz) * (r0.xyz);
    r0.xyz = (r2.www) * (c[6].xyz);
    r7.xyz = (r8.xyz) * (r0.xyz) + (r1.xyz);
    r8.w = saturate(dot(r14.xyz, c[17].xyz));
    r2 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c3.x) : (c3.w));
    r1.xyz = (r8.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r2.w = r0.z;
    }
    else
    {
        if ((c3.x) >= (v5.w))
        {
            r3 = (v5.xyzx) * (c3.xxxw);
            r2 = (r3) + (-(c12.xyzz));
            r2 = tex2Dlod(s1, r2);
            r2.w = r2.x;
            r4 = (r3) + (c13.zzww);
            r4 = tex2Dlod(s1, r4);
            r2.x = r4.x;
            r4 = (r3) + (-(c13.zzww));
            r4 = tex2Dlod(s1, r4);
            r2.y = r4.x;
            r3 = (r3) + (c12.xyzz);
            r3 = tex2Dlod(s1, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c13.yyyy);
            if ((c12.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c13.zz);
                r2.zw = (v5.zx) * (c3.xw);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r0.xy) + (-(c13.zz));
                r3.zw = (v5.zx) * (c3.xw);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (c12.xy);
                r3.zw = (v5.zx) * (c3.xw);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (-(c12.xy));
                r3.zw = (v5.zx) * (c3.xw);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c13.yyyy);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c14.x) + (c14.y);
                r2.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r2.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c4.y));
            r0.z = ((r0.z) >= 0.0f ? (c3.w) : (c3.x));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c13.zz);
                r3.zw = (v5.zz) * (c3.xw);
                r3 = tex2Dlod(s1, r3);
                r4.xy = (r0.xy) + (-(c13.zz));
                r4.zw = (v5.zz) * (c3.xw);
                r6 = tex2Dlod(s1, r4);
                r4.xy = (r0.xy) + (c12.xy);
                r4.zw = (v5.zz) * (c3.xw);
                r5 = tex2Dlod(s1, r4);
                r4.xy = (r0.xy) + (-(c12.xy));
                r4.zw = (v5.zz) * (c3.xw);
                r4 = tex2Dlod(s1, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c13.yyyy);
                r0.z = saturate((v5.w) + (c14.y));
                r0.y = (r2.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r2.y;
            }
            r2.w = r0.z;
        }
    }
    r2.xyz = (r2.www) * (r1.xyz) + (r16.xyz);
    r0.z = (-(r14.w)) + (c3.x);
    r0.x = 1.0f / (r17.x);
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.z) * (r0.y);
    r0.z = dot(r15.xyz, r14.xyz);
    r3.w = (r0.x) * (r0.y);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r1.w) * (c1.w);
    r1.xyz = (r14.xyz) * (-(r0.zzz)) + (r15.xyz);
    r1 = texCUBElod(s15, r1);
    r3.xyz = (v6.xyz) * (-(r13.www)) + (c[17].xyz);
    r0.xyz = normalize(r3.xyz);
    r1.w = saturate(dot(r0.xyz, c[17].xyz));
    r1.w = (-(r1.w)) + (c3.x);
    r3.z = (r1.w) * (r1.w);
    r3.z = (r3.z) * (r3.z);
    r3.z = (r1.w) * (r3.z);
    r1.w = (r8.w) * (r11.w) + (r12.w);
    r3.y = (r1.w) * (r10.w) + (c4.w);
    r1.w = saturate(dot(r14.xyz, r0.xyz));
    r0.y = 1.0f / (r3.y);
    r0.z = pow(abs(r1.w), r9.w);
    r0.y = (r8.w) * (r0.y);
    r0.z = (r7.w) * (r0.z);
    r1.w = (r0.y) * (r0.z);
    r3.xyz = (r11.xyz) * (r3.zzz) + (r12.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.www) * (r3.xyz);
    r0.xyz = (r13.xxx) * (r0.xyz);
    r1.xyz = (r13.zzz) * (r1.xyz);
    r3.xyz = (r11.xyz) * (r3.www) + (r12.xyz);
    r1.xyz = (r1.xyz) * (c[19].xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r2.www) * (r1.xyz);
    r8.xyz = (r8.xyz) * (r2.xyz) + (r1.xyz);
    r1 = (v6.yyyy) * (c[25]);
    r6.xyz = (r10.xyz) * (r0.xyz);
    r1 = (v6.xxxx) * (c[24]) + (r1);
    r0.z = dot(r9.xyz, c[22].xyz);
    r1 = (v6.zzzz) * (c[26]) + (r1);
    r0.z = saturate((r0.z) * (c[23].x) + (c[23].y));
    r4 = (r1) + (c[27]);
    r0.y = (r0.z) * (c14.z) + (c14.w);
    r3.zw = r4.zw;
    r0.z = (r0.z) * (r0.z);
    r5.zw = r3.zw;
    r4.z = (r0.y) * (r0.z);
    r2.zw = r5.zw;
    r1.xy = (r4.ww) * (-(c[28].zw)) + (r4.xy);
    r1.zw = r2.zw;
    r1 = tex2Dproj(s2, r1);
    r1.w = r1.x;
    r5.xy = (r3.ww) * (-(c[28].xy)) + (r4.xy);
    r5 = tex2Dproj(s2, r5);
    r1.y = r5.x;
    r3.xy = (r3.ww) * (c[28].xy) + (r4.xy);
    r5 = tex2Dproj(s2, r3);
    r1.x = r5.x;
    r2.xy = (r3.ww) * (c[28].zw) + (r4.xy);
    r3 = tex2Dproj(s2, r2);
    r2 = (v6.xyzx) * (c3.xxxw) + (c3.wwwx);
    r1.z = r3.x;
    r0.z = dot(r2, c[21]);
    r3.w = 1.0f / (r0.z);
    r3.x = dot(r2, c[20]);
    r0.x = dot(r2, c[10]);
    r3.y = (r3.x) * (r3.x);
    r0.y = dot(r2, c[11]);
    r0.z = dot(c[8].yz, r3.xy) + (c[8].x);
    r2.w = saturate(1.0f / (r0.z));
    r2.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r3.xy = (r2.xy) * (c14.zz) + (c14.ww);
    r2.xy = (r2.xy) * (r2.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.x) : (r2.w));
    r2.w = (r3.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r3.y)) + (c3.x);
    r0.xy = (r3.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r3.w = (r4.z) * (r0.z);
    r0.xy = (r0.xy) * (c3.zz) + (c3.zz);
    r2 = tex2D(s3, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = dot(r1, c13.yyyy);
    r0.xyz = (r3.www) * (r0.xyz);
    r1.xyz = (r6.xyz) * (c1.www) + (r8.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r7.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[31].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.x;

    return oC0;
}
