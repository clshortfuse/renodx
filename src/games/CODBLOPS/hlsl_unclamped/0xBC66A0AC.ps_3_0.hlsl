// Mechanically reconstructed from 0xBC66A0AC.ps_3_0.cso.
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
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
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
    const float4 c0 = float4(0.200000003f, 8.0f, 31.875f, 1.0f);
    const float4 c1 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c12 = float4(4.0f, -3.0f, -4.0f, 2.0f);
    const float4 c13 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c14 = float4(0.5f, 0.0f, 0.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0.w = dot(v5.xyz, v5.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = (v5.xyz) * (-(r0.www)) + (c[17].xyz);
    r7.xyz = normalize(r0.xyz);
    r1.w = saturate(dot(r7.xyz, c[17].xyz));
    r0.xyz = (-(v5.xyz)) + (c[21].xyz);
    r1.w = (-(r1.w)) + (c0.w);
    r1.z = dot(r0.xyz, r0.xyz);
    r2.w = rsqrt(r1.z);
    r6.xyz = (r0.www) * (v5.xyz);
    r0.w = (r1.w) * (r1.w);
    r2.xyz = (r0.xyz) * (r2.www) + (-(r6.xyz));
    r1.xyz = normalize(r2.xyz);
    r2.xyz = (r0.xyz) * (r2.www);
    r0.z = (r0.w) * (r0.w);
    r0.w = saturate(dot(r1.xyz, r2.xyz));
    r11.w = (r1.w) * (r0.z);
    r2.w = (-(r0.w)) + (c0.w);
    r6.w = dot(r2.xyz, c[30].xyz);
    r3.w = (r2.w) * (r2.w);
    r0 = tex2D(s4, v1.xy);
    r12.y = (r0.w) * (-(c1.x)) + (c1.y);
    r12.x = (r0.w) * (c1.x);
    r9.xyz = normalize(v2.xyz);
    r7.w = saturate(dot(r2.xyz, r9.xyz));
    r0.z = saturate(dot(r9.xyz, -(r6.xyz)));
    r1.w = (r7.w) * (r12.y) + (r12.x);
    r12.z = (r0.z) * (r12.y) + (r12.x);
    r2.z = (r3.w) * (r3.w);
    r1.w = (r1.w) * (r12.z) + (c1.z);
    r3.w = 1.0f / (r1.w);
    r2.xy = (r0.ww) * (c13.xy) + (c13.zw);
    r3.z = saturate(dot(r9.xyz, r1.xyz));
    r11.y = exp2(r2.y);
    r1.w = pow(abs(r3.z), r11.y);
    r11.z = (r11.y) * (c4.x) + (c4.y);
    r1.z = (r7.w) * (r3.w);
    r1.w = (r1.w) * (r11.z);
    r10.w = (r2.w) * (r2.z);
    r9.w = (r1.z) * (r1.w);
    r1.z = 1.0f / (r2.x);
    r0.z = (-(r0.z)) + (c0.w);
    r1.w = (r0.z) * (r0.z);
    r1.y = max(abs(r9.y), abs(r9.z));
    r1.w = (r0.z) * (r1.w);
    r0.z = max(abs(r9.x), r1.y);
    r8.w = (r1.z) * (r1.w);
    r0.z = 1.0f / (r0.z);
    r1.w = dot(r6.xyz, r9.xyz);
    r1.xyz = (r9.xyz) * (c[5].xyz);
    r11.x = (r1.w) + (r1.w);
    r1.xyz = (r1.xyz) * (r0.zzz) + (v6.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r12.w = saturate(dot(r9.xyz, c[17].xyz));
    r1.xyz = (r0.yyy) * (r1.xyz);
    r10.xyz = (r1.xyz) * (c0.zzz);
    r8.xyz = (r12.www) * (c[18].xyz);
    if ((c0.w) >= (v4.w))
    {
        r2 = (v4.xyzx) * (c1.yyyw);
        r1 = (r2) + (-(c3.xyzz));
        r1 = tex2Dlod(s1, r1);
        r1.w = r1.x;
        r3 = (r2) + (c4.zzww);
        r3 = tex2Dlod(s1, r3);
        r1.x = r3.x;
        r3 = (r2) + (-(c4.zzww));
        r3 = tex2Dlod(s1, r3);
        r1.y = r3.x;
        r2 = (r2) + (c3.xyzz);
        r2 = tex2Dlod(s1, r2);
        r1.z = r2.x;
        r0.z = dot(r1, c4.yyyy);
        if ((c3.w) < (v4.w))
        {
            r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r5.xy) + (c4.zz);
            r1.zw = (v4.zx) * (c1.yw);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r5.xy) + (-(c4.zz));
            r2.zw = (v4.zx) * (c1.yw);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r5.xy) + (c3.xy);
            r2.zw = (v4.zx) * (c1.yw);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r5.xy) + (-(c3.xy));
            r2.zw = (v4.zx) * (c1.yw);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r1.w = dot(r1, c4.yyyy);
            r1.z = (-(r0.z)) + (r1.w);
            r1.w = (v4.w) * (c12.x) + (c12.y);
            r0.z = (r1.w) * (r1.z) + (r0.z);
        }
    }
    else
    {
        r0.z = (v4.w) + (c12.z);
        r0.z = ((r0.z) >= 0.0f ? (c1.w) : (c1.y));
        if ((r0.z) != (-(r0.z)))
        {
            r1.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r1.xy) + (c4.zz);
            r2.zw = (v4.zz) * (c1.yw);
            r2 = tex2Dlod(s1, r2);
            r3.xy = (r1.xy) + (-(c4.zz));
            r3.zw = (v4.zz) * (c1.yw);
            r5 = tex2Dlod(s1, r3);
            r3.xy = (r1.xy) + (c3.xy);
            r3.zw = (v4.zz) * (c1.yw);
            r4 = tex2Dlod(s1, r3);
            r3.xy = (r1.xy) + (-(c3.xy));
            r3.zw = (v4.zz) * (c1.yw);
            r3 = tex2Dlod(s1, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r1.z = dot(r2, c4.yyyy);
            r0.z = saturate((v4.w) + (c12.y));
            r1.w = (r1.w) + (-(r1.z));
            r0.z = (r0.z) * (r1.w) + (r1.z);
        }
        else
        {
            r0.z = r1.w;
        }
    }
    r1.w = (r12.w) * (r12.y) + (r12.x);
    r1.w = (r1.w) * (r12.z) + (c1.z);
    r3.xyz = (r0.zzz) * (r8.xyz) + (r10.xyz);
    r1.w = 1.0f / (r1.w);
    r2.w = (r12.w) * (r1.w);
    r2.z = saturate(dot(r9.xyz, r7.xyz));
    r1.w = (r0.w) * (c0.y);
    r1.xyz = (r9.xyz) * (-(r11.xxx)) + (r6.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = pow(abs(r2.z), r11.y);
    r2.xyz = (r1.xyz) * (c0.yyy);
    r1 = tex3D(s11, v6.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r11.z) * (r0.w);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r0.w = (r2.w) * (r0.w);
    r2.xyz = (r1.xyz) * (c0.zzz);
    r1 = tex2D(s0, v1.xy);
    r4.xyz = (r0.xxx) * (r1.xyz);
    r5.xyz = lerp(r1.xyz, c0.xxx, r0.xxx);
    r6.xyz = (r5.xyz) * (-(r5.xyz)) + (c0.www);
    r7.xyz = (r5.xyz) * (r5.xyz);
    r4.xyz = (r4.xyz) * (v0.xyz);
    r1.xyz = (r6.xyz) * (r11.www) + (r7.xyz);
    r5.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r0.www) * (r1.xyz);
    r1.xyz = (r6.xyz) * (r10.www) + (r7.xyz);
    r4.xyz = (r0.yyy) * (r4.xyz);
    r1.xyz = (r9.www) * (r1.xyz);
    r4.xyz = (r4.xyz) * (c[19].xyz);
    r6.xyz = (r6.xyz) * (r8.www) + (r7.xyz);
    r4.xyz = (r0.zzz) * (r4.xyz);
    r2.xyz = (r2.xyz) * (r6.xyz);
    r3.xyz = (r5.xyz) * (r3.xyz) + (r4.xyz);
    r7.xyz = (r2.xyz) * (r0.yyy) + (r3.xyz);
    r1.xyz = (r1.xyz) * (c[23].xyz);
    r2.xyz = (r0.yyy) * (r1.xyz);
    r0 = (v5.yyyy) * (c[33]);
    r1.xyz = (r7.www) * (c[22].xyz);
    r0 = (v5.xxxx) * (c[32]) + (r0);
    r6.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0 = (v5.zzzz) * (c[34]) + (r0);
    r1.w = saturate((r6.w) * (c[31].x) + (c[31].y));
    r3 = (r0) + (c[35]);
    r0.z = (r1.w) * (-(c12.w)) + (-(c12.y));
    r2.zw = r3.zw;
    r0.w = (r1.w) * (r1.w);
    r4.zw = r2.zw;
    r3.z = (r0.z) * (r0.w);
    r0.zw = r4.zw;
    r1.xy = (r3.ww) * (-(c[36].zw)) + (r3.xy);
    r1.zw = r0.zw;
    r1 = tex2Dproj(s2, r1);
    r1.w = r1.x;
    r4.xy = (r2.ww) * (-(c[36].xy)) + (r3.xy);
    r4 = tex2Dproj(s2, r4);
    r1.y = r4.x;
    r2.xy = (r2.ww) * (c[36].xy) + (r3.xy);
    r4 = tex2Dproj(s2, r2);
    r1.x = r4.x;
    r0.xy = (r2.ww) * (c[36].zw) + (r3.xy);
    r0 = tex2Dproj(s2, r0);
    r1.z = r0.x;
    r0 = (v5.xyzx) * (c1.yyyw) + (c1.wwwy);
    r5.w = dot(r1, c4.yyyy);
    r1.w = dot(r0, c[29]);
    r1.w = 1.0f / (r1.w);
    r2.x = dot(r0, c[28]);
    r1.x = dot(r0, c[26]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[27]);
    r0.w = dot(c[24].yz, r2.xy) + (c[24].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[25].xy) + (c[25].zw));
    r2.xy = (r0.xy) * (-(c12.ww)) + (-(c12.yy));
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.w) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c0.w);
    r0.xy = (r1.ww) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r6.w = (r3.z) * (r0.w);
    r0.xy = (r0.xy) * (c14.xx) + (c14.xx);
    r4 = tex2D(s3, r0.xy);
    r3 = (-(v5.yyyy)) + (c[7]);
    r2 = (-(v5.xxxx)) + (c[6]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v5.zzzz)) + (c[8]);
    r0 = (r1) * (r1) + (r0);
    r8.xyz = (r4.xyz) * (r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r8.xyz = (r6.www) * (r8.xyz);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r2.x = c0.w;
    r0 = saturate((r0) * (c[9]) + (r2.xxxx));
    r2.xyz = (r5.www) * (r8.xyz);
    r0 = (r1) * (r0);
    r2.xyz = (r2.xyz) * (r6.xyz) + (r7.xyz);
    r1.z = dot(c[20], r0);
    r1.x = dot(c[10], r0);
    r1.y = dot(c[11], r0);
    r0.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}
