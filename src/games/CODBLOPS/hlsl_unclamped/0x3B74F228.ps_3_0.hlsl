// Mechanically reconstructed from 0x3B74F228.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 0.200000003f, 8.0f, 31.875f);
    const float4 c1 = float4(1.0f, 0.797884583f, 0.0009765625f, 0.0f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c12 = float4(4.0f, -3.0f, -4.0f, 2.0f);
    const float4 c13 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0.w = dot(v5.xyz, v5.xyz);
    r3.xyz = (-(v5.xyz)) + (c[6].xyz);
    r1.w = rsqrt(r0.w);
    r0.w = dot(r3.xyz, r3.xyz);
    r0.w = rsqrt(r0.w);
    r2.xyz = (r1.www) * (v5.xyz);
    r1.xyz = (r3.xyz) * (r0.www) + (-(r2.xyz));
    r0.xyz = normalize(r1.xyz);
    r1.xyz = (v5.xyz) * (-(r1.www)) + (c[17].xyz);
    r10.xyz = (r3.xyz) * (r0.www);
    r4.xyz = normalize(r1.xyz);
    r0.w = saturate(dot(r0.xyz, r10.xyz));
    r3.xyz = normalize(v2.xyz);
    r5.w = (-(r0.w)) + (c1.x);
    r4.w = saturate(dot(r3.xyz, r0.xyz));
    r0.w = (r5.w) * (r5.w);
    r0.z = (r0.w) * (r0.w);
    r3.w = saturate(dot(r10.xyz, r3.xyz));
    r1 = tex2D(s4, v1.xy);
    r10.w = (r1.w) * (-(c1.y)) + (c1.x);
    r11.w = (r1.w) * (c1.y);
    r2.w = saturate(dot(r3.xyz, -(r2.xyz)));
    r0.w = (r3.w) * (r10.w) + (r11.w);
    r9.w = (r2.w) * (r10.w) + (r11.w);
    r5.w = (r5.w) * (r0.z);
    r0.w = (r0.w) * (r9.w) + (c1.z);
    r0.w = 1.0f / (r0.w);
    r6.xy = (r1.ww) * (c13.xy) + (c13.zw);
    r6.w = (r3.w) * (r0.w);
    r1.z = exp2(r6.y);
    r0.w = pow(abs(r4.w), r1.z);
    r7.w = (r1.z) * (c4.x) + (c4.y);
    r4.w = (r0.w) * (r7.w);
    r0.xy = (v1.xy) * (c[31].xy);
    r0 = tex2D(s5, r0.xy);
    r5.xyz = (r0.xyz) + (c0.xxx);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = saturate((r5.xyz) * (r0.www) + (r0.xyz));
    r4.w = (r6.w) * (r4.w);
    r5.xyz = lerp(r0.xyz, c0.yyy, r1.xxx);
    r13.xyz = (r5.xyz) * (-(r5.xyz)) + (c1.xxx);
    r14.xyz = (r5.xyz) * (r5.xyz);
    r5.xyz = (r1.xxx) * (r0.xyz);
    r0.xyz = (r13.xyz) * (r5.www) + (r14.xyz);
    r5.xyz = (r5.xyz) * (v0.xyz);
    r0.xyz = (r4.www) * (r0.xyz);
    r9.xyz = (r5.xyz) * (r5.xyz);
    r0.xyz = (r0.xyz) * (c[8].xyz);
    r5.xyz = (r1.yyy) * (r0.xyz);
    r0.xyz = (r3.www) * (c[7].xyz);
    r1.x = saturate(dot(r4.xyz, c[17].xyz));
    r7.xyz = (r9.xyz) * (r0.xyz) + (r5.xyz);
    r3.w = 1.0f / (r6.x);
    r0.z = dot(r2.xyz, r3.xyz);
    r4.w = (-(r2.w)) + (c1.x);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r1.w) * (c0.z);
    r2.xyz = (r3.xyz) * (-(r0.zzz)) + (r2.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r4.w) * (r4.w);
    r5.xyz = (r0.xyz) * (c0.zzz);
    r2 = tex3D(s11, v6.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r4.w) * (r1.w);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r1.w = (r3.w) * (r1.w);
    r0.xyz = (r0.xyz) * (c0.www);
    r2.xyz = (r13.xyz) * (r1.www) + (r14.xyz);
    r1.x = (-(r1.x)) + (c1.x);
    r8.xyz = (r0.xyz) * (r2.xyz);
    r0.z = (r1.x) * (r1.x);
    r0.z = (r0.z) * (r0.z);
    r1.w = max(abs(r3.y), abs(r3.z));
    r1.x = (r1.x) * (r0.z);
    r0.z = max(abs(r3.x), r1.w);
    r2.w = 1.0f / (r0.z);
    r0.xyz = (r3.xyz) * (c[5].xyz);
    r1.w = saturate(dot(r3.xyz, r4.xyz));
    r0.xyz = (r0.xyz) * (r2.www) + (v6.xyz);
    r2 = tex3D(s11, r0.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r8.w = pow(abs(r1.w), r1.z);
    r2.xyz = (r1.yyy) * (r0.xyz);
    r1.z = saturate(dot(r3.xyz, c[17].xyz));
    r15.xy = c[29].xy;
    r0.xyz = (r15.xxx) * (c[18].xyz);
    r12.xyz = (r2.xyz) * (c0.www);
    r11.xyz = (r1.zzz) * (r0.xyz);
    if ((c1.x) >= (v4.w))
    {
        r3 = (v4.xyzx) * (c1.xxxw);
        r2 = (r3) + (-(c3.xyzz));
        r2 = tex2Dlod(s1, r2);
        r2.w = r2.x;
        r4 = (r3) + (c4.zzww);
        r4 = tex2Dlod(s1, r4);
        r2.x = r4.x;
        r4 = (r3) + (-(c4.zzww));
        r4 = tex2Dlod(s1, r4);
        r2.y = r4.x;
        r3 = (r3) + (c3.xyzz);
        r3 = tex2Dlod(s1, r3);
        r2.z = r3.x;
        r1.w = dot(r2, c4.yyyy);
        if ((c3.w) < (v4.w))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c4.zz);
            r2.zw = (v4.zx) * (c1.xw);
            r2 = tex2Dlod(s1, r2);
            r3.xy = (r0.xy) + (-(c4.zz));
            r3.zw = (v4.zx) * (c1.xw);
            r5 = tex2Dlod(s1, r3);
            r3.xy = (r0.xy) + (c3.xy);
            r3.zw = (v4.zx) * (c1.xw);
            r4 = tex2Dlod(s1, r3);
            r3.xy = (r0.xy) + (-(c3.xy));
            r3.zw = (v4.zx) * (c1.xw);
            r3 = tex2Dlod(s1, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.z = dot(r2, c4.yyyy);
            r0.y = (-(r1.w)) + (r0.z);
            r0.z = (v4.w) * (c12.x) + (c12.y);
            r1.w = (r0.z) * (r0.y) + (r1.w);
        }
    }
    else
    {
        r0.z = (v4.w) + (c12.z);
        r0.z = ((r0.z) >= 0.0f ? (c1.w) : (c1.x));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c4.zz);
            r3.zw = (v4.zz) * (c1.xw);
            r3 = tex2Dlod(s1, r3);
            r4.xy = (r0.xy) + (-(c4.zz));
            r4.zw = (v4.zz) * (c1.xw);
            r6 = tex2Dlod(s1, r4);
            r4.xy = (r0.xy) + (c3.xy);
            r4.zw = (v4.zz) * (c1.xw);
            r5 = tex2Dlod(s1, r4);
            r4.xy = (r0.xy) + (-(c3.xy));
            r4.zw = (v4.zz) * (c1.xw);
            r4 = tex2Dlod(s1, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c4.yyyy);
            r0.z = saturate((v4.w) + (c12.y));
            r0.y = (r2.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r2.w;
        }
        r1.w = r0.z;
    }
    r0.z = (r1.z) * (r10.w) + (r11.w);
    r0.z = (r0.z) * (r9.w) + (c1.z);
    r0.y = 1.0f / (r0.z);
    r0.z = (r7.w) * (r8.w);
    r0.y = (r1.z) * (r0.y);
    r1.z = (r0.z) * (r0.y);
    r0.xyz = (r13.xyz) * (r1.xxx) + (r14.xyz);
    r0.xyz = (r1.zzz) * (r0.xyz);
    r2.xyz = (r1.yyy) * (r0.xyz);
    r3.xyz = (r15.yyy) * (c[19].xyz);
    r0.xyz = (r1.www) * (r11.xyz) + (r12.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r3.xyz = (r1.www) * (r2.xyz);
    r2 = (v5.yyyy) * (c[26]);
    r9.xyz = (r9.xyz) * (r0.xyz) + (r3.xyz);
    r2 = (v5.xxxx) * (c[25]) + (r2);
    r0.z = dot(r10.xyz, c[23].xyz);
    r2 = (v5.zzzz) * (c[27]) + (r2);
    r0.z = saturate((r0.z) * (c[24].x) + (c[24].y));
    r5 = (r2) + (c[28]);
    r0.y = (r0.z) * (-(c12.w)) + (-(c12.y));
    r4.zw = r5.zw;
    r0.z = (r0.z) * (r0.z);
    r6.zw = r4.zw;
    r1.w = (r0.y) * (r0.z);
    r3.zw = r6.zw;
    r2.xy = (r5.ww) * (-(c[30].zw)) + (r5.xy);
    r2.zw = r3.zw;
    r2 = tex2Dproj(s2, r2);
    r2.w = r2.x;
    r6.xy = (r4.ww) * (-(c[30].xy)) + (r5.xy);
    r6 = tex2Dproj(s2, r6);
    r2.y = r6.x;
    r4.xy = (r4.ww) * (c[30].xy) + (r5.xy);
    r6 = tex2Dproj(s2, r4);
    r2.x = r6.x;
    r3.xy = (r4.ww) * (c[30].zw) + (r5.xy);
    r4 = tex2Dproj(s2, r3);
    r3 = (v5.xyzx) * (c1.xxxw) + (c1.wwwx);
    r2.z = r4.x;
    r0.z = dot(r3, c[22]);
    r1.x = 1.0f / (r0.z);
    r4.x = dot(r3, c[21]);
    r0.x = dot(r3, c[11]);
    r4.y = (r4.x) * (r4.x);
    r0.y = dot(r3, c[20]);
    r0.z = dot(c[9].yz, r4.xy) + (c[9].x);
    r1.z = saturate(1.0f / (r0.z));
    r3.xy = saturate((r4.xx) * (c[10].xy) + (c[10].zw));
    r4.xy = (r3.xy) * (-(c12.ww)) + (-(c12.yy));
    r3.xy = (r3.xy) * (r3.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.w) : (r1.z));
    r1.z = (r4.x) * (r3.x);
    r0.z = (r0.z) * (r1.z);
    r1.z = (r3.y) * (-(r4.y)) + (c1.x);
    r0.xy = (r1.xx) * (r0.xy);
    r0.z = (r0.z) * (r1.z);
    r1.z = (r1.w) * (r0.z);
    r0.xy = (r0.xy) * (-(c0.xx)) + (-(c0.xx));
    r3 = tex2D(s3, r0.xy);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r1.w = dot(r2, c4.yyyy);
    r0.xyz = (r1.zzz) * (r0.xyz);
    r1.xyz = (r8.xyz) * (r1.yyy) + (r9.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r7.xyz) + (r1.xyz);
    r1.w = (r0.w) * (v0.w);
    r0.xyz = (r0.xyz) * (r1.www);
    r0.w = c1.x;
    r1.z = dot(r0, c[35]);
    r1.x = dot(r0, c[33]);
    r1.y = dot(r0, c[34]);
    r0.xyz = (v3.xyz) * (-(r1.www)) + (r1.xyz);
    r0.xyz = (r0.xyz) * (v2.www);
    r0.xyz = (v3.xyz) * (r1.www) + (r0.xyz);
    r0.xyz = max(((r0.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r1.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
