// Mechanically reconstructed from 0x438C07C1.ps_3_0.cso.
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
    const float4 c0 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
    const float4 c3 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c4 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c12 = float4(4.0f, -3.0f, -2.0f, 3.0f);
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
    float4 r13 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v5.xyz, v5.xyz);
    r0.xyz = (-(v5.xyz)) + (c[21].xyz);
    r1.w = rsqrt(r0.w);
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r1.xyz = (r1.www) * (v5.xyz);
    r3.xyz = (r0.xyz) * (r0.www) + (-(r1.xyz));
    r2.xyz = normalize(r3.xyz);
    r3.xyz = (r0.xyz) * (r0.www);
    r0.w = saturate(dot(r2.xyz, r3.xyz));
    r0.w = (-(r0.w)) + (c0.z);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r2.w = dot(r3.xyz, c[30].xyz);
    r4.w = (r0.w) * (r0.z);
    r0 = tex2D(s4, v1.xy);
    r9.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.zzz);
    r11.xyz = (r0.xyz) * (r0.xyz);
    r12.w = (r0.w) * (-(c0.w)) + (c0.z);
    r13.z = (r0.w) * (c0.w);
    r10.xyz = normalize(v2.xyz);
    r5.w = saturate(dot(r3.xyz, r10.xyz));
    r3.w = saturate(dot(r10.xyz, -(r1.xyz)));
    r3.z = (r5.w) * (r12.w) + (r13.z);
    r11.w = (r3.w) * (r12.w) + (r13.z);
    r0.xyz = (r9.xyz) * (r4.www) + (r11.xyz);
    r3.z = (r3.z) * (r11.w) + (c3.x);
    r3.z = 1.0f / (r3.z);
    r3.w = (-(r3.w)) + (c0.z);
    r3.z = (r5.w) * (r3.z);
    r3.y = (r3.w) * (r3.w);
    r3.w = (r3.w) * (r3.y);
    r3.xy = (r0.ww) * (c13.xy) + (c13.zw);
    r4.w = saturate(dot(r10.xyz, r2.xyz));
    r10.w = exp2(r3.y);
    r2.z = pow(abs(r4.w), r10.w);
    r8.w = (r10.w) * (c3.y) + (c3.z);
    r2.y = dot(r1.xyz, r10.xyz);
    r2.z = (r2.z) * (r8.w);
    r3.y = (r2.y) + (r2.y);
    r2.z = (r3.z) * (r2.z);
    r2.xyz = (r0.xyz) * (r2.zzz);
    r3.z = 1.0f / (r3.x);
    r0.w = (r0.w) * (c0.x);
    r0.xyz = (r10.xyz) * (-(r3.yyy)) + (r1.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.w = (r3.w) * (r3.z);
    r1.xyz = (r0.xyz) * (c0.xxx);
    r0 = tex3D(s11, v6.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r2.xyz) * (c[23].xyz);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r1.xyz = (r9.xyz) * (r3.www) + (r11.xyz);
    r0.xyz = (r0.xyz) * (c0.yyy);
    r7.xyz = (r2.xyz) * (c[37].www);
    r5.xyz = (r1.xyz) * (r0.xyz);
    r0.w = saturate((r2.w) * (c[31].x) + (c[31].y));
    r0.xyz = (v5.xyz) * (-(r1.www)) + (c[17].xyz);
    r1.w = (r0.w) * (c12.z) + (c12.w);
    r12.xyz = normalize(r0.xyz);
    r0.z = (r0.w) * (r0.w);
    r0.w = saturate(dot(r12.xyz, c[17].xyz));
    r6.w = (r1.w) * (r0.z);
    r1.w = (-(r0.w)) + (c0.z);
    r0.w = (r1.w) * (r1.w);
    r1.y = max(abs(r10.y), abs(r10.z));
    r1.z = (r0.w) * (r0.w);
    r0.w = max(abs(r10.x), r1.y);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r10.xyz) * (c[5].xyz);
    r7.w = (r1.w) * (r1.z);
    r0.xyz = (r0.xyz) * (r0.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[37].yyy);
    r9.w = saturate(dot(r10.xyz, c[17].xyz));
    r8.xyz = (r0.xyz) * (c0.yyy);
    r6.xyz = (r9.www) * (c[18].xyz);
    if ((c0.z) >= (v4.w))
    {
        r1 = (v4.xyzx) * (c4.xxxy);
        r0 = (r1) + (-(c1.xyzz));
        r0 = tex2Dlod(s1, r0);
        r0.w = r0.x;
        r2 = (r1) + (c4.zzyy);
        r2 = tex2Dlod(s1, r2);
        r0.x = r2.x;
        r2 = (r1) + (c4.wwyy);
        r2 = tex2Dlod(s1, r2);
        r0.y = r2.x;
        r1 = (r1) + (c1.xyzz);
        r1 = tex2Dlod(s1, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c3.zzzz);
        if ((c3.w) < (v4.w))
        {
            r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c4.zz);
            r0.zw = (v4.zx) * (c4.xy);
            r0 = tex2Dlod(s1, r0);
            r1.xy = (r4.xy) + (c4.ww);
            r1.zw = (v4.zx) * (c4.xy);
            r3 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (c1.xy);
            r1.zw = (v4.zx) * (c4.xy);
            r2 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (-(c1.xy));
            r1.zw = (v4.zx) * (c4.xy);
            r1 = tex2Dlod(s1, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c3.zzzz);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v4.w) * (c12.x) + (c12.y);
            r0.w = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r0.w = r4.w;
        }
    }
    else
    {
        r0.z = (v4.w) + (c1.w);
        r0.z = ((r0.z) >= 0.0f ? (c4.y) : (c4.x));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c4.zz);
            r1.zw = (v4.zz) * (c4.xy);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r0.xy) + (c4.ww);
            r2.zw = (v4.zz) * (c4.xy);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (c1.xy);
            r2.zw = (v4.zz) * (c4.xy);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (-(c1.xy));
            r2.zw = (v4.zz) * (c4.xy);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.y = dot(r1, c3.zzzz);
            r0.z = saturate((v4.w) + (c12.y));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
    }
    r0.z = (r9.w) * (r12.w) + (r13.z);
    r0.z = (r0.z) * (r11.w) + (c3.x);
    r1.w = saturate(dot(r10.xyz, r12.xyz));
    r0.y = 1.0f / (r0.z);
    r0.z = pow(abs(r1.w), r10.w);
    r0.y = (r9.w) * (r0.y);
    r0.z = (r8.w) * (r0.z);
    r1.w = (r0.y) * (r0.z);
    r0.xyz = (r9.xyz) * (r7.www) + (r11.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[37].www);
    r0.xyz = (r0.xyz) * (c[19].xyz);
    r2.xyz = (r0.www) * (r6.xyz) + (r8.xyz);
    r3.xyz = (r0.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r1 = (v5.yyyy) * (c[33]);
    r0 = (r0.wxyz) * (v0.wxyz);
    r1 = (v5.xxxx) * (c[32]) + (r1);
    r6.xyz = (r0.yzw) * (r0.yzw);
    r1 = (v5.zzzz) * (c[34]) + (r1);
    r2.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r4 = (r1) + (c[35]);
    r8.xyz = (r5.xyz) * (c[37].xxx) + (r2.xyz);
    r3.zw = r4.zw;
    r1.xyz = (r5.www) * (c[22].xyz);
    r5.zw = r3.zw;
    r7.xyz = (r6.xyz) * (r1.xyz) + (r7.xyz);
    r1.zw = r5.zw;
    r2.xy = (r4.ww) * (-(c[36].zw)) + (r4.xy);
    r2.zw = r1.zw;
    r2 = tex2Dproj(s2, r2);
    r2.w = r2.x;
    r5.xy = (r3.ww) * (-(c[36].xy)) + (r4.xy);
    r5 = tex2Dproj(s2, r5);
    r2.y = r5.x;
    r3.xy = (r3.ww) * (c[36].xy) + (r4.xy);
    r5 = tex2Dproj(s2, r3);
    r2.x = r5.x;
    r1.xy = (r3.ww) * (c[36].zw) + (r4.xy);
    r1 = tex2Dproj(s2, r1);
    r2.z = r1.x;
    r1 = (v5.xyzx) * (c4.xxxy) + (c4.yyyx);
    r0.w = dot(r2, c3.zzzz);
    r0.z = dot(r1, c[29]);
    r2.w = 1.0f / (r0.z);
    r3.x = dot(r1, c[28]);
    r2.x = dot(r1, c[26]);
    r3.y = (r3.x) * (r3.x);
    r2.y = dot(r1, c[27]);
    r0.z = dot(c[24].yz, r3.xy) + (c[24].x);
    r0.y = saturate(1.0f / (r0.z));
    r1.xy = saturate((r3.xx) * (c[25].xy) + (c[25].zw));
    r3.xy = (r1.xy) * (c12.zz) + (c12.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c4.y) : (r0.y));
    r0.y = (r3.x) * (r1.x);
    r0.z = (r0.z) * (r0.y);
    r0.y = (r1.y) * (-(r3.y)) + (c0.z);
    r1.xy = (r2.ww) * (r2.xy);
    r0.z = (r0.z) * (r0.y);
    r0.z = (r6.w) * (r0.z);
    r1.xy = (r1.xy) * (c14.xx) + (c14.xx);
    r5 = tex2D(s3, r1.xy);
    r4 = (-(v5.yyyy)) + (c[7]);
    r3 = (-(v5.xxxx)) + (c[6]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v5.zzzz)) + (c[8]);
    r1 = (r2) * (r2) + (r1);
    r9.xyz = (r5.xyz) * (r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r9.xyz = (r0.zzz) * (r9.xyz);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r0.y = c0.z;
    r1 = saturate((r1) * (c[9]) + (r0.yyyy));
    r3.xyz = (r0.www) * (r9.xyz);
    r1 = (r2) * (r1);
    r3.xyz = (r3.xyz) * (r7.xyz) + (r8.xyz);
    r2.z = dot(c[20], r1);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r1.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[38].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r1.x = rsqrt(r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = rsqrt(r1.z);
    r0.w = rsqrt(r0.x);
    oC0.x = 1.0f / (r1.x);
    oC0.y = 1.0f / (r1.y);
    oC0.z = 1.0f / (r1.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
