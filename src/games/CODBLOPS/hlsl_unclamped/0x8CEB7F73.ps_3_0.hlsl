// Mechanically reconstructed from 0x8CEB7F73.ps_3_0.cso.
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
sampler3D s11 : register(s11);
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
    const float4 c0 = float4(-0.5f, 8.0f, 31.875f, 1.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c14 = float4(4.0f, -3.0f, -4.0f, 2.0f);
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

    r0.xy = (v1.xy) * (c[39].xy);
    r0 = tex2D(s6, r0.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s1, v1.xy);
    r0.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r5.xy = (c[39].zz) * (r1.xy) + (r0.xy);
    r0.w = dot(v7.xyz, v7.xyz);
    r3.xyz = (-(v7.xyz)) + (c[21].xyz);
    r2.w = rsqrt(r0.w);
    r0.w = dot(r3.xyz, r3.xyz);
    r1.w = rsqrt(r0.w);
    r2.xyz = (r2.www) * (v7.xyz);
    r0 = v2;
    r1.xyz = (r5.xxx) * (v5.xyz) + (r0.xyz);
    r4.xyz = (r3.xyz) * (r1.www) + (-(r2.xyz));
    r0.xyz = normalize(r4.xyz);
    r10.xyz = (r3.xyz) * (r1.www);
    r1.xyz = (r5.yyy) * (v4.xyz) + (r1.xyz);
    r1.w = saturate(dot(r0.xyz, r10.xyz));
    r9.xyz = normalize(r1.xyz);
    r3.w = (-(r1.w)) + (c0.w);
    r4.w = (r3.w) * (r3.w);
    r1.xy = (v1.xy) * (c[40].xy);
    r1 = tex2D(s7, r1.xy);
    r3.xyz = (r1.xyz) + (c0.xxx);
    r1 = tex2D(s0, v1.xy);
    r1.xyz = saturate((r3.xyz) * (r1.www) + (r1.xyz));
    r1.w = (r4.w) * (r4.w);
    r1.xyz = (r1.xyz) * (v0.xyz);
    r3.w = (r3.w) * (r1.w);
    r7.xyz = (r1.xyz) * (r1.xyz);
    r1 = tex2D(s5, v1.xy);
    r14.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.www);
    r15.xyz = (r1.xyz) * (r1.xyz);
    r14.w = (r1.w) * (-(c3.x)) + (c3.y);
    r15.w = (r1.w) * (c3.x);
    r7.w = saturate(dot(r10.xyz, r9.xyz));
    r1.y = saturate(dot(r9.xyz, -(r2.xyz)));
    r1.z = (r7.w) * (r14.w) + (r15.w);
    r13.w = (r1.y) * (r14.w) + (r15.w);
    r8.xyz = (r14.xyz) * (r3.www) + (r15.xyz);
    r1.z = (r1.z) * (r13.w) + (c3.z);
    r1.z = 1.0f / (r1.z);
    r1.y = (-(r1.y)) + (c0.w);
    r1.z = (r7.w) * (r1.z);
    r1.x = (r1.y) * (r1.y);
    r3.w = (r1.y) * (r1.x);
    r1.xy = (r1.ww) * (c4.xy) + (c4.zw);
    r1.w = (r1.w) * (c0.y);
    r1.x = 1.0f / (r1.x);
    r12.w = exp2(r1.y);
    r1.y = saturate(dot(r9.xyz, r0.xyz));
    r3.w = (r3.w) * (r1.x);
    r0.y = pow(abs(r1.y), r12.w);
    r10.w = (r12.w) * (c12.x) + (c12.y);
    r0.z = dot(r2.xyz, r9.xyz);
    r0.y = (r0.y) * (r10.w);
    r0.z = (r0.z) + (r0.z);
    r8.w = (r1.z) * (r0.y);
    r1.xyz = (r9.xyz) * (-(r0.zzz)) + (r2.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r3.xyz = (r0.xyz) * (c0.yyy);
    r2.xyz = (r14.xyz) * (r3.www) + (r15.xyz);
    r1 = tex3D(s11, v8.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r1.xyz = (v7.xyz) * (-(r2.www)) + (c[17].xyz);
    r0.xyz = (r0.xyz) * (c0.zzz);
    r16.xyz = normalize(r1.xyz);
    r11.xyz = (r2.xyz) * (r0.xyz);
    r0.z = saturate(dot(r16.xyz, c[17].xyz));
    r1.w = (-(r0.z)) + (c0.w);
    r1.y = max(abs(r9.y), abs(r9.z));
    r1.z = (r1.w) * (r1.w);
    r0.z = max(abs(r9.x), r1.y);
    r1.y = 1.0f / (r0.z);
    r0.xyz = (r9.xyz) * (c[5].xyz);
    r1.z = (r1.z) * (r1.z);
    r0.xyz = (r0.xyz) * (r1.yyy) + (v8.xyz);
    r2 = tex3D(s11, r0.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r9.w = (r1.w) * (r1.z);
    r0.xyz = (r0.xyz) * (c[38].yyy);
    r11.w = saturate(dot(r9.xyz, c[17].xyz));
    r17.xy = c[36].xy;
    r2.xyz = (r17.xxx) * (c[18].xyz);
    r1 = tex2D(s8, v1.xy);
    r0.xyz = (r0.xyz) * (r1.www);
    r12.xyz = (r11.www) * (r2.xyz);
    r13.xyz = (r0.xyz) * (c0.zzz);
    if ((c0.w) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c3.yyyw);
        r2 = (r3) + (-(c13.xyzz));
        r2 = tex2Dlod(s2, r2);
        r2.w = r2.x;
        r4 = (r3) + (c12.zzww);
        r4 = tex2Dlod(s2, r4);
        r2.x = r4.x;
        r4 = (r3) + (-(c12.zzww));
        r4 = tex2Dlod(s2, r4);
        r2.y = r4.x;
        r3 = (r3) + (c13.xyzz);
        r3 = tex2Dlod(s2, r3);
        r2.z = r3.x;
        r0.z = dot(r2, c12.yyyy);
        if ((c13.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c12.zz);
            r2.zw = (v6.zx) * (c3.yw);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r0.xy) + (-(c12.zz));
            r3.zw = (v6.zx) * (c3.yw);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c13.xy);
            r3.zw = (v6.zx) * (c3.yw);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c13.xy));
            r3.zw = (v6.zx) * (c3.yw);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.y = dot(r2, c12.yyyy);
            r0.x = (-(r0.z)) + (r0.y);
            r0.y = (v6.w) * (c14.x) + (c14.y);
            r2.w = (r0.y) * (r0.x) + (r0.z);
        }
        else
        {
            r2.w = r0.z;
        }
    }
    else
    {
        r0.z = (v6.w) + (c14.z);
        r0.z = ((r0.z) >= 0.0f ? (c3.w) : (c3.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c12.zz);
            r3.zw = (v6.zz) * (c3.yw);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (-(c12.zz));
            r4.zw = (v6.zz) * (c3.yw);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c13.xy);
            r4.zw = (v6.zz) * (c3.yw);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c13.xy));
            r4.zw = (v6.zz) * (c3.yw);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c12.yyyy);
            r0.z = saturate((v6.w) + (c14.y));
            r0.y = (r2.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r2.w;
        }
        r2.w = r0.z;
    }
    r0.z = (r11.w) * (r14.w) + (r15.w);
    r0.z = (r0.z) * (r13.w) + (c3.z);
    r2.z = saturate(dot(r9.xyz, r16.xyz));
    r0.y = 1.0f / (r0.z);
    r0.z = pow(abs(r2.z), r12.w);
    r0.y = (r11.w) * (r0.y);
    r0.z = (r10.w) * (r0.z);
    r2.z = (r0.y) * (r0.z);
    r0.xyz = (r14.xyz) * (r9.www) + (r15.xyz);
    r0.xyz = (r2.zzz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[38].www);
    r0.xyz = (r1.www) * (r0.xyz);
    r2.xyz = (r17.yyy) * (c[19].xyz);
    r2.xyz = (r0.xyz) * (r2.xyz);
    r0.xyz = (r2.www) * (r12.xyz) + (r13.xyz);
    r3.xyz = (r2.www) * (r2.xyz);
    r2.xyz = (r11.xyz) * (c[38].xxx);
    r3.xyz = (r7.xyz) * (r0.xyz) + (r3.xyz);
    r0.xyz = (r8.xyz) * (r8.www);
    r8.xyz = (r2.xyz) * (r1.xyz) + (r3.xyz);
    r2.w = dot(r10.xyz, c[30].xyz);
    r0.xyz = (r0.xyz) * (c[23].xyz);
    r2.xyz = (r0.xyz) * (c[38].www);
    r1 = (v7.yyyy) * (c[33]);
    r0.xyz = (r7.www) * (c[22].xyz);
    r1 = (v7.xxxx) * (c[32]) + (r1);
    r6.xyz = (r7.xyz) * (r0.xyz) + (r2.xyz);
    r1 = (v7.zzzz) * (c[34]) + (r1);
    r0.z = saturate((r2.w) * (c[31].x) + (c[31].y));
    r4 = (r1) + (c[35]);
    r0.y = (r0.z) * (-(c14.w)) + (-(c14.y));
    r3.zw = r4.zw;
    r0.z = (r0.z) * (r0.z);
    r5.zw = r3.zw;
    r4.z = (r0.y) * (r0.z);
    r1.zw = r5.zw;
    r2.xy = (r4.ww) * (-(c[37].zw)) + (r4.xy);
    r2.zw = r1.zw;
    r2 = tex2Dproj(s3, r2);
    r2.w = r2.x;
    r5.xy = (r3.ww) * (-(c[37].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r2.y = r5.x;
    r3.xy = (r3.ww) * (c[37].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r2.x = r5.x;
    r1.xy = (r3.ww) * (c[37].zw) + (r4.xy);
    r1 = tex2Dproj(s3, r1);
    r2.z = r1.x;
    r1 = (v7.xyzx) * (c3.yyyw) + (c3.wwwy);
    r6.w = dot(r2, c12.yyyy);
    r0.z = dot(r1, c[29]);
    r2.w = 1.0f / (r0.z);
    r2.x = dot(r1, c[28]);
    r0.x = dot(r1, c[26]);
    r2.y = (r2.x) * (r2.x);
    r0.y = dot(r1, c[27]);
    r0.z = dot(c[24].yz, r2.xy) + (c[24].x);
    r1.w = saturate(1.0f / (r0.z));
    r1.xy = saturate((r2.xx) * (c[25].xy) + (c[25].zw));
    r2.xy = (r1.xy) * (-(c14.ww)) + (-(c14.yy));
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c3.w) : (r1.w));
    r1.w = (r2.x) * (r1.x);
    r0.z = (r0.z) * (r1.w);
    r1.w = (r1.y) * (-(r2.y)) + (c0.w);
    r0.xy = (r2.ww) * (r0.xy);
    r0.z = (r0.z) * (r1.w);
    r7.w = (r4.z) * (r0.z);
    r0.xy = (r0.xy) * (-(c0.xx)) + (-(c0.xx));
    r5 = tex2D(s4, r0.xy);
    r4 = (-(v7.yyyy)) + (c[7]);
    r3 = (-(v7.xxxx)) + (c[6]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v7.zzzz)) + (c[8]);
    r1 = (r2) * (r2) + (r1);
    r0.xyz = (r5.xyz) * (r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = (r7.www) * (r0.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r3.x = c0.w;
    r1 = saturate((r1) * (c[9]) + (r3.xxxx));
    r0.xyz = (r6.www) * (r0.xyz);
    r1 = (r2) * (r1);
    r2.xyz = (r0.xyz) * (r6.xyz) + (r8.xyz);
    r0.z = dot(c[20], r1);
    r0.x = dot(c[10], r1);
    r0.y = dot(c[11], r1);
    r1.xyz = (r7.xyz) * (r0.xyz) + (r2.xyz);
    r1.w = c0.w;
    r0.z = dot(r1, c[44]);
    r0.x = dot(r1, c[42]);
    r0.y = dot(r1, c[43]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[41].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}
