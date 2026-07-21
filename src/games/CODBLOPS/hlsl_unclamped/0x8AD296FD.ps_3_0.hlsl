// Mechanically reconstructed from 0x8AD296FD.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 0.200000003f, 8.0f, 31.875f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(1.0f, 0.797884583f, 0.0009765625f, 0.0f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c14 = float4(4.0f, -3.0f, -4.0f, 0.0f);
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

    r0.w = dot(v7.xyz, v7.xyz);
    r2.w = rsqrt(r0.w);
    r2.xyz = (v7.xyz) * (-(r2.www)) + (c[17].xyz);
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r1.xyz = normalize(r2.xyz);
    r0 = v2;
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r1.w = saturate(dot(r1.xyz, c[17].xyz));
    r0.xyz = (r3.yyy) * (v4.xyz) + (r0.xyz);
    r10.xyz = normalize(r0.xyz);
    r0.xyz = (r2.www) * (v7.xyz);
    r2.y = (-(r1.w)) + (c3.x);
    r1.w = saturate(dot(r10.xyz, -(r0.xyz)));
    r2.z = (r2.y) * (r2.y);
    r2.w = (-(r1.w)) + (c3.x);
    r2.x = (r2.z) * (r2.z);
    r2.z = (r2.w) * (r2.w);
    r4.w = (r2.y) * (r2.x);
    r3.w = (r2.w) * (r2.z);
    r2 = tex2D(s3, v1.xy);
    r4.z = (r2.w) * (-(c3.y)) + (c3.x);
    r4.y = (r2.w) * (c3.y);
    r3.z = (r1.w) * (r4.z) + (r4.y);
    r3.xy = (r2.ww) * (c4.xy) + (c4.zw);
    r1.w = (r2.w) * (c0.z);
    r3.x = 1.0f / (r3.x);
    r2.w = exp2(r3.y);
    r2.z = saturate(dot(r10.xyz, r1.xyz));
    r3.w = (r3.w) * (r3.x);
    r1.y = pow(abs(r2.z), r2.w);
    r1.z = (r2.w) * (c12.x) + (c12.y);
    r2.w = saturate(dot(r10.xyz, c[17].xyz));
    r2.z = (r1.y) * (r1.z);
    r1.z = (r2.w) * (r4.z) + (r4.y);
    r1.y = (r1.z) * (r3.z) + (c3.z);
    r1.z = dot(r0.xyz, r10.xyz);
    r1.y = 1.0f / (r1.y);
    r1.z = (r1.z) + (r1.z);
    r3.z = (r2.w) * (r1.y);
    r1.xyz = (r10.xyz) * (-(r1.zzz)) + (r0.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r2.z = (r2.z) * (r3.z);
    r4.xyz = (r0.xyz) * (c0.zzz);
    r1 = tex3D(s11, v8.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xy = (v1.xy) * (c[22].xy);
    r1 = tex2D(s4, r1.xy);
    r3.xyz = (r1.xyz) + (c0.xxx);
    r1 = tex2D(s0, v1.xy);
    r3.xyz = saturate((r3.xyz) * (r1.www) + (r1.xyz));
    r1.xyz = (r4.xyz) * (r0.xyz);
    r0.xyz = (r2.xxx) * (r3.xyz);
    r1.xyz = (r1.xyz) * (c0.www);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r7.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = lerp(r3.xyz, c0.yyy, r2.xxx);
    r3.xyz = (r0.xyz) * (-(r0.xyz)) + (c3.xxx);
    r4.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r3.xyz) * (r4.www) + (r4.xyz);
    r3.xyz = (r3.xyz) * (r3.www) + (r4.xyz);
    r0.xyz = (r2.zzz) * (r0.xyz);
    r8.xyz = (r1.xyz) * (r3.xyz);
    r1.xyz = (r2.yyy) * (r0.xyz);
    r1.w = max(abs(r10.y), abs(r10.z));
    r4.xy = c[21].xy;
    r3.xyz = (r4.yyy) * (c[19].xyz);
    r0.z = max(abs(r10.x), r1.w);
    r1.w = 1.0f / (r0.z);
    r0.xyz = (r10.xyz) * (c[5].xyz);
    r9.xyz = (r1.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.www) + (v8.xyz);
    r1 = tex3D(s11, r0.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r4.xxx) * (c[18].xyz);
    r0.xyz = (r2.yyy) * (r0.xyz);
    r11.xyz = (r2.www) * (r1.xyz);
    r12.xyz = (r0.xyz) * (c0.www);
    if ((c3.x) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c3.xxxw);
        r1 = (r3) + (-(c13.xyzz));
        r1 = tex2Dlod(s2, r1);
        r1.w = r1.x;
        r4 = (r3) + (c12.zzww);
        r4 = tex2Dlod(s2, r4);
        r1.x = r4.x;
        r4 = (r3) + (-(c12.zzww));
        r4 = tex2Dlod(s2, r4);
        r1.y = r4.x;
        r3 = (r3) + (c13.xyzz);
        r3 = tex2Dlod(s2, r3);
        r1.z = r3.x;
        r2.w = dot(r1, c12.yyyy);
        if ((c13.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c12.zz);
            r1.zw = (v6.zx) * (c3.xw);
            r1 = tex2Dlod(s2, r1);
            r3.xy = (r0.xy) + (-(c12.zz));
            r3.zw = (v6.zx) * (c3.xw);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c13.xy);
            r3.zw = (v6.zx) * (c3.xw);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c13.xy));
            r3.zw = (v6.zx) * (c3.xw);
            r3 = tex2Dlod(s2, r3);
            r1.y = r5.x;
            r1.z = r4.x;
            r1.w = r3.x;
            r0.z = dot(r1, c12.yyyy);
            r0.y = (-(r2.w)) + (r0.z);
            r0.z = (v6.w) * (c14.x) + (c14.y);
            r2.w = (r0.z) * (r0.y) + (r2.w);
        }
    }
    else
    {
        r0.z = (v6.w) + (c14.z);
        r0.z = ((r0.z) >= 0.0f ? (c3.w) : (c3.x));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c12.zz);
            r3.zw = (v6.zz) * (c3.xw);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (-(c12.zz));
            r4.zw = (v6.zz) * (c3.xw);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c13.xy);
            r4.zw = (v6.zz) * (c3.xw);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c13.xy));
            r4.zw = (v6.zz) * (c3.xw);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c12.yyyy);
            r0.z = saturate((v6.w) + (c14.y));
            r0.y = (r1.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r1.w;
        }
        r2.w = r0.z;
    }
    r5 = (-(v7.yyyy)) + (c[7]);
    r4 = (-(v7.xxxx)) + (c[6]);
    r1 = (r5) * (r5);
    r1 = (r4) * (r4) + (r1);
    r3 = (-(v7.zzzz)) + (c[8]);
    r1 = (r3) * (r3) + (r1);
    r0.xyz = (r2.www) * (r11.xyz) + (r12.xyz);
    r6.x = rsqrt(r1.x);
    r6.y = rsqrt(r1.y);
    r6.z = rsqrt(r1.z);
    r6.w = rsqrt(r1.w);
    r9.xyz = (r9.xyz) * (r2.www);
    r5 = (r5) * (r6);
    r5 = (r10.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r10.xxxx) + (r5);
    r3 = saturate((r3) * (r10.zzzz) + (r4));
    r2.w = c3.x;
    r1 = saturate((r1) * (c[9]) + (r2.wwww));
    r0.xyz = (r7.xyz) * (r0.xyz) + (r9.xyz);
    r1 = (r3) * (r1);
    r2.xyz = (r8.xyz) * (r2.yyy) + (r0.xyz);
    r0.z = dot(c[20], r1);
    r0.x = dot(c[10], r1);
    r0.y = dot(c[11], r1);
    r1.xyz = (r7.xyz) * (r0.xyz) + (r2.xyz);
    r1.w = c3.x;
    r0.z = dot(r1, c[26]);
    r0.x = dot(r1, c[24]);
    r0.y = dot(r1, c[25]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.x;

    return oC0;
}
