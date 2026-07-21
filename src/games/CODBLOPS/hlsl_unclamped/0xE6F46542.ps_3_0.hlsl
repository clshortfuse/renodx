// Mechanically reconstructed from 0xE6F46542.ps_3_0.cso.
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
    const float4 c3 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
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
    float4 oC0 = 0.0f;

    r0.w = dot(v5.xyz, v5.xyz);
    r2.xyz = (-(v5.xyz)) + (c[6].xyz);
    r1.w = rsqrt(r0.w);
    r0.w = dot(r2.xyz, r2.xyz);
    r0.w = rsqrt(r0.w);
    r4.xyz = (r1.www) * (v5.xyz);
    r1.xyz = (r2.xyz) * (r0.www) + (-(r4.xyz));
    r0.xyz = normalize(r1.xyz);
    r1.xyz = (v5.xyz) * (-(r1.www)) + (c[17].xyz);
    r9.xyz = (r2.xyz) * (r0.www);
    r2.xyz = normalize(r1.xyz);
    r0.w = saturate(dot(r0.xyz, r9.xyz));
    r3.xyz = normalize(v2.xyz);
    r1.w = (-(r0.w)) + (c1.x);
    r5.z = saturate(dot(r3.xyz, r0.xyz));
    r0.w = (r1.w) * (r1.w);
    r1.z = (r0.w) * (r0.w);
    r3.w = saturate(dot(r9.xyz, r3.xyz));
    r0 = tex2D(s4, v1.xy);
    r9.w = (r0.w) * (-(c1.y)) + (c1.x);
    r10.w = (r0.w) * (c1.y);
    r4.w = saturate(dot(r3.xyz, -(r4.xyz)));
    r0.z = (r3.w) * (r9.w) + (r10.w);
    r8.w = (r4.w) * (r9.w) + (r10.w);
    r5.w = (r1.w) * (r1.z);
    r0.z = (r0.z) * (r8.w) + (c1.z);
    r0.z = 1.0f / (r0.z);
    r7.xy = (r0.ww) * (c13.xy) + (c13.zw);
    r6.z = (r3.w) * (r0.z);
    r2.w = exp2(r7.y);
    r1.w = pow(abs(r5.z), r2.w);
    r0.z = (r2.w) * (c3.x) + (c3.y);
    r6.w = (r1.w) * (r0.z);
    r1.xy = (v1.xy) * (c[31].xy);
    r1 = tex2D(s5, r1.xy);
    r5.xyz = (r1.xyz) + (c0.xxx);
    r1 = tex2D(s0, v1.xy);
    r1.xyz = saturate((r5.xyz) * (r1.www) + (r1.xyz));
    r1.w = (r6.z) * (r6.w);
    r5.xyz = lerp(r1.xyz, c0.yyy, r0.xxx);
    r12.xyz = (r5.xyz) * (-(r5.xyz)) + (c1.xxx);
    r13.xyz = (r5.xyz) * (r5.xyz);
    r5.xyz = (r0.xxx) * (r1.xyz);
    r1.xyz = (r12.xyz) * (r5.www) + (r13.xyz);
    r5.xyz = (r5.xyz) * (v0.xyz);
    r1.xyz = (r1.www) * (r1.xyz);
    r8.xyz = (r5.xyz) * (r5.xyz);
    r1.xyz = (r1.xyz) * (c[8].xyz);
    r5.xyz = (r0.yyy) * (r1.xyz);
    r1.xyz = (r3.www) * (c[7].xyz);
    r0.x = saturate(dot(r2.xyz, c[17].xyz));
    r6.xyz = (r8.xyz) * (r1.xyz) + (r5.xyz);
    r3.w = 1.0f / (r7.x);
    r1.w = dot(r4.xyz, r3.xyz);
    r4.w = (-(r4.w)) + (c1.x);
    r1.z = (r1.w) + (r1.w);
    r1.w = (r0.w) * (c0.z);
    r1.xyz = (r3.xyz) * (-(r1.zzz)) + (r4.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r4.w) * (r4.w);
    r4.xyz = (r1.xyz) * (c0.zzz);
    r1 = tex3D(s11, v6.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r4.w) * (r0.w);
    r1.xyz = (r4.xyz) * (r1.xyz);
    r0.w = (r3.w) * (r0.w);
    r1.xyz = (r1.xyz) * (c0.www);
    r4.xyz = (r12.xyz) * (r0.www) + (r13.xyz);
    r0.w = (-(r0.x)) + (c1.x);
    r7.xyz = (r1.xyz) * (r4.xyz);
    r0.x = (r0.w) * (r0.w);
    r0.x = (r0.x) * (r0.x);
    r1.w = max(abs(r3.y), abs(r3.z));
    r0.x = (r0.w) * (r0.x);
    r0.w = max(abs(r3.x), r1.w);
    r1.w = 1.0f / (r0.w);
    r1.xyz = (r3.xyz) * (c[5].xyz);
    r0.w = saturate(dot(r3.xyz, r2.xyz));
    r1.xyz = (r1.xyz) * (r1.www) + (v6.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r7.w = pow(abs(r0.w), r2.w);
    r2.xyz = (r0.yyy) * (r1.xyz);
    r6.w = saturate(dot(r3.xyz, c[17].xyz));
    r14.xy = c[29].xy;
    r1.xyz = (r14.xxx) * (c[18].xyz);
    r11.xyz = (r2.xyz) * (c0.www);
    r10.xyz = (r6.www) * (r1.xyz);
    if ((c1.x) >= (v4.w))
    {
        r2 = (v4.xyzx) * (c1.xxxw);
        r1 = (r2) + (-(c4.xyzz));
        r1 = tex2Dlod(s1, r1);
        r1.w = r1.x;
        r3 = (r2) + (c3.zzww);
        r3 = tex2Dlod(s1, r3);
        r1.x = r3.x;
        r3 = (r2) + (-(c3.zzww));
        r3 = tex2Dlod(s1, r3);
        r1.y = r3.x;
        r2 = (r2) + (c4.xyzz);
        r2 = tex2Dlod(s1, r2);
        r1.z = r2.x;
        r0.w = dot(r1, c3.yyyy);
        if ((c4.w) < (v4.w))
        {
            r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r5.xy) + (c3.zz);
            r1.zw = (v4.zx) * (c1.xw);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r5.xy) + (-(c3.zz));
            r2.zw = (v4.zx) * (c1.xw);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r5.xy) + (c4.xy);
            r2.zw = (v4.zx) * (c1.xw);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r5.xy) + (-(c4.xy));
            r2.zw = (v4.zx) * (c1.xw);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r1.w = dot(r1, c3.yyyy);
            r1.z = (-(r0.w)) + (r1.w);
            r1.w = (v4.w) * (c12.x) + (c12.y);
            r0.w = (r1.w) * (r1.z) + (r0.w);
        }
    }
    else
    {
        r0.w = (v4.w) + (c12.z);
        r0.w = ((r0.w) >= 0.0f ? (c1.w) : (c1.x));
        if ((r0.w) != (-(r0.w)))
        {
            r1.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r1.xy) + (c3.zz);
            r2.zw = (v4.zz) * (c1.xw);
            r2 = tex2Dlod(s1, r2);
            r3.xy = (r1.xy) + (-(c3.zz));
            r3.zw = (v4.zz) * (c1.xw);
            r5 = tex2Dlod(s1, r3);
            r3.xy = (r1.xy) + (c4.xy);
            r3.zw = (v4.zz) * (c1.xw);
            r4 = tex2Dlod(s1, r3);
            r3.xy = (r1.xy) + (-(c4.xy));
            r3.zw = (v4.zz) * (c1.xw);
            r3 = tex2Dlod(s1, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r1.z = dot(r2, c3.yyyy);
            r0.w = saturate((v4.w) + (c12.y));
            r1.w = (r1.w) + (-(r1.z));
            r0.w = (r0.w) * (r1.w) + (r1.z);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    r1.w = (r6.w) * (r9.w) + (r10.w);
    r1.w = (r1.w) * (r8.w) + (c1.z);
    r1.w = 1.0f / (r1.w);
    r0.z = (r0.z) * (r7.w);
    r1.w = (r6.w) * (r1.w);
    r0.z = (r0.z) * (r1.w);
    r1.xyz = (r12.xyz) * (r0.xxx) + (r13.xyz);
    r1.xyz = (r0.zzz) * (r1.xyz);
    r1.xyz = (r0.yyy) * (r1.xyz);
    r3.xyz = (r14.yyy) * (c[19].xyz);
    r2.xyz = (r0.www) * (r10.xyz) + (r11.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz);
    r3.xyz = (r0.www) * (r1.xyz);
    r1 = (v5.yyyy) * (c[26]);
    r8.xyz = (r8.xyz) * (r2.xyz) + (r3.xyz);
    r1 = (v5.xxxx) * (c[25]) + (r1);
    r0.w = dot(r9.xyz, c[23].xyz);
    r1 = (v5.zzzz) * (c[27]) + (r1);
    r0.w = saturate((r0.w) * (c[24].x) + (c[24].y));
    r4 = (r1) + (c[28]);
    r0.z = (r0.w) * (-(c12.w)) + (-(c12.y));
    r3.zw = r4.zw;
    r0.w = (r0.w) * (r0.w);
    r5.zw = r3.zw;
    r0.z = (r0.z) * (r0.w);
    r2.zw = r5.zw;
    r1.xy = (r4.ww) * (-(c[30].zw)) + (r4.xy);
    r1.zw = r2.zw;
    r1 = tex2Dproj(s2, r1);
    r1.w = r1.x;
    r5.xy = (r3.ww) * (-(c[30].xy)) + (r4.xy);
    r5 = tex2Dproj(s2, r5);
    r1.y = r5.x;
    r3.xy = (r3.ww) * (c[30].xy) + (r4.xy);
    r5 = tex2Dproj(s2, r3);
    r1.x = r5.x;
    r2.xy = (r3.ww) * (c[30].zw) + (r4.xy);
    r3 = tex2Dproj(s2, r2);
    r2 = (v5.xyzx) * (c1.xxxw) + (c1.wwwx);
    r1.z = r3.x;
    r0.w = dot(r2, c[22]);
    r3.w = 1.0f / (r0.w);
    r4.x = dot(r2, c[21]);
    r3.x = dot(r2, c[11]);
    r4.y = (r4.x) * (r4.x);
    r3.y = dot(r2, c[20]);
    r0.w = dot(c[9].yz, r4.xy) + (c[9].x);
    r0.x = saturate(1.0f / (r0.w));
    r2.xy = saturate((r4.xx) * (c[10].xy) + (c[10].zw));
    r4.xy = (r2.xy) * (-(c12.ww)) + (-(c12.yy));
    r2.xy = (r2.xy) * (r2.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.w) : (r0.x));
    r0.x = (r4.x) * (r2.x);
    r0.w = (r0.w) * (r0.x);
    r0.x = (r2.y) * (-(r4.y)) + (c1.x);
    r2.xy = (r3.ww) * (r3.xy);
    r0.w = (r0.w) * (r0.x);
    r0.z = (r0.z) * (r0.w);
    r2.xy = (r2.xy) * (-(c0.xx)) + (-(c0.xx));
    r2 = tex2D(s3, r2.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.w = dot(r1, c3.yyyy);
    r2.xyz = (r0.zzz) * (r2.xyz);
    r1.xyz = (r7.xyz) * (r0.yyy) + (r8.xyz);
    r0.xyz = (r0.www) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r6.xyz) + (r1.xyz);
    r0.w = c1.x;
    r1.z = dot(r0, c[35]);
    r1.x = dot(r0, c[33]);
    r1.y = dot(r0, c[34]);
    r0.xyz = (r1.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}
