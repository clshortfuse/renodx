// Mechanically reconstructed from 0x67418B52.ps_3_0.cso.
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
    const float4 c1 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c3 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
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
    float4 r14 = 0.0f;
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
    r2.w = (-(r0.w)) + (c0.z);
    r0.w = (r2.w) * (r2.w);
    r5.w = dot(r3.xyz, c[30].xyz);
    r3.w = (r0.w) * (r0.w);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r2.w = (r2.w) * (r3.w);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r0 = tex2D(s4, v1.xy);
    r12.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.zzz);
    r13.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r12.xyz) * (r2.www) + (r13.xyz);
    r12.w = (r0.w) * (-(c0.w)) + (c0.z);
    r13.w = (r0.w) * (c0.w);
    r9.xyz = normalize(v2.xyz);
    r6.w = saturate(dot(r3.xyz, r9.xyz));
    r2.w = saturate(dot(r9.xyz, -(r1.xyz)));
    r3.w = (r6.w) * (r12.w) + (r13.w);
    r11.w = (r2.w) * (r12.w) + (r13.w);
    r3.w = (r3.w) * (r11.w) + (c1.x);
    r2.w = (-(r2.w)) + (c0.z);
    r3.w = 1.0f / (r3.w);
    r3.z = (r2.w) * (r2.w);
    r3.w = (r6.w) * (r3.w);
    r2.w = (r2.w) * (r3.z);
    r3.z = dot(r1.xyz, r9.xyz);
    r3.xy = (r0.ww) * (c13.xy) + (c13.zw);
    r4.w = saturate(dot(r9.xyz, r2.xyz));
    r10.w = exp2(r3.y);
    r2.y = pow(abs(r4.w), r10.w);
    r8.w = (r10.w) * (c1.y) + (c1.z);
    r2.z = (r3.z) + (r3.z);
    r2.y = (r2.y) * (r8.w);
    r2.x = 1.0f / (r3.x);
    r2.y = (r3.w) * (r2.y);
    r2.w = (r2.w) * (r2.x);
    r6.xyz = (r0.xyz) * (r2.yyy);
    r0.w = (r0.w) * (c0.x);
    r0.xyz = (r9.xyz) * (-(r2.zzz)) + (r1.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r0.xyz) * (c0.xxx);
    r8.xyz = (r12.xyz) * (r2.www) + (r13.xyz);
    r0 = tex3D(s11, v6.xyz);
    r2.xyz = (v5.xyz) * (-(r1.www)) + (c[17].xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r14.xyz = normalize(r2.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r0.w = saturate(dot(r14.xyz, c[17].xyz));
    r7.xyz = (r0.xyz) * (c0.yyy);
    r1.w = (-(r0.w)) + (c0.z);
    r0.w = (r1.w) * (r1.w);
    r1.y = max(abs(r9.y), abs(r9.z));
    r1.z = (r0.w) * (r0.w);
    r0.w = max(abs(r9.x), r1.y);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r9.xyz) * (c[5].xyz);
    r7.w = (r1.w) * (r1.z);
    r0.xyz = (r0.xyz) * (r0.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[37].yyy);
    r9.w = saturate(dot(r9.xyz, c[17].xyz));
    r11.xyz = (r0.xyz) * (c0.yyy);
    r10.xyz = (r9.www) * (c[18].xyz);
    if ((c0.z) >= (v4.w))
    {
        r1 = (v4.xyzx) * (c3.xxxy);
        r0 = (r1) + (-(c4.xyzz));
        r0 = tex2Dlod(s1, r0);
        r0.w = r0.x;
        r2 = (r1) + (c3.zzyy);
        r2 = tex2Dlod(s1, r2);
        r0.x = r2.x;
        r2 = (r1) + (c3.wwyy);
        r2 = tex2Dlod(s1, r2);
        r0.y = r2.x;
        r1 = (r1) + (c4.xyzz);
        r1 = tex2Dlod(s1, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c1.zzzz);
        if ((c1.w) < (v4.w))
        {
            r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c3.zz);
            r0.zw = (v4.zx) * (c3.xy);
            r0 = tex2Dlod(s1, r0);
            r1.xy = (r4.xy) + (c3.ww);
            r1.zw = (v4.zx) * (c3.xy);
            r3 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (c4.xy);
            r1.zw = (v4.zx) * (c3.xy);
            r2 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (-(c4.xy));
            r1.zw = (v4.zx) * (c3.xy);
            r1 = tex2Dlod(s1, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c1.zzzz);
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
        r0.z = (v4.w) + (c4.w);
        r0.z = ((r0.z) >= 0.0f ? (c3.y) : (c3.x));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c3.zz);
            r1.zw = (v4.zz) * (c3.xy);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r0.xy) + (c3.ww);
            r2.zw = (v4.zz) * (c3.xy);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (c4.xy);
            r2.zw = (v4.zz) * (c3.xy);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (-(c4.xy));
            r2.zw = (v4.zz) * (c3.xy);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.y = dot(r1, c1.zzzz);
            r0.z = saturate((v4.w) + (c12.y));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
    }
    r0.z = (r9.w) * (r12.w) + (r13.w);
    r0.z = (r0.z) * (r11.w) + (c1.x);
    r1.w = saturate(dot(r9.xyz, r14.xyz));
    r0.y = 1.0f / (r0.z);
    r0.z = pow(abs(r1.w), r10.w);
    r0.y = (r9.w) * (r0.y);
    r0.z = (r8.w) * (r0.z);
    r1.w = (r0.y) * (r0.z);
    r0.xyz = (r12.xyz) * (r7.www) + (r13.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[37].www);
    r0.xyz = (r0.xyz) * (c[19].xyz);
    r1.xyz = (r0.www) * (r10.xyz) + (r11.xyz);
    r2.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r8.xyz) * (r7.xyz);
    r1.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r7.xyz = (r0.xyz) * (c[37].xxx) + (r1.xyz);
    r0.xyz = (r6.xyz) * (c[23].xyz);
    r2.xyz = (r0.xyz) * (c[37].www);
    r0 = (v5.yyyy) * (c[33]);
    r1.xyz = (r6.www) * (c[22].xyz);
    r0 = (v5.xxxx) * (c[32]) + (r0);
    r6.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0 = (v5.zzzz) * (c[34]) + (r0);
    r1.w = saturate((r5.w) * (c[31].x) + (c[31].y));
    r3 = (r0) + (c[35]);
    r0.z = (r1.w) * (c12.z) + (c12.w);
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
    r0 = (v5.xyzx) * (c3.xxxy) + (c3.yyyx);
    r5.w = dot(r1, c1.zzzz);
    r1.w = dot(r0, c[29]);
    r1.w = 1.0f / (r1.w);
    r2.x = dot(r0, c[28]);
    r1.x = dot(r0, c[26]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[27]);
    r0.w = dot(c[24].yz, r2.xy) + (c[24].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[25].xy) + (c[25].zw));
    r2.xy = (r0.xy) * (c12.zz) + (c12.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c3.y) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c0.z);
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
    r2.y = c0.z;
    r0 = saturate((r0) * (c[9]) + (r2.yyyy));
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
    r0.xyz = max(((r0.xyz) * (c[38].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}
