// Mechanically reconstructed from 0x99F3F5B8.ps_3_0.cso.
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 0.5f, 1.10000002f, 10.0f);
    const float4 c3 = float4(1.0f, 0.0f, 8.0f, 31.875f);
    const float4 c4 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.25f);
    const float4 c12 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c13 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c15 = float4(4.0f, -3.0f, -4.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0.w = dot(v7.xyz, v7.xyz);
    r3.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r3.www)) + (c[17].xyz);
    r6.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r6.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c3.x);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r4.w = (r0.w) * (r0.z);
    r0.xy = (v1.xy) + (c1.xx);
    r0.z = c1.y;
    r1.xy = (r0.xy) * (c[28].xx) + (r0.zz);
    r0.xy = (r0.xy) * (c[27].xx) + (r0.zz);
    r0 = tex2D(s4, r0.xy);
    r6.w = (v8.w) * (c1.z) + (-(r0.x));
    r0 = tex2D(s0, v1.xy);
    r2.w = (r0.w) * (v0.w);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r7.w = saturate((r6.w) * (c1.w));
    r1 = tex2D(s5, r1.xy);
    r0 = tex2D(s1, v1.xy);
    r4.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s6, v1.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r3.xy = lerp(r4.xy, r0.xy, r7.ww);
    r0.xyz = v2.xyz;
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r3.yyy) * (v4.xyz) + (r0.xyz);
    r8.xyz = normalize(r0.xyz);
    r5.xyz = (r3.www) * (v7.xyz);
    r3.w = saturate(dot(r8.xyz, -(r5.xyz)));
    r3.z = (-(r3.w)) + (c3.x);
    r3.y = (r3.z) * (r3.z);
    r0 = lerp(r2, r1, r7.wwww);
    r2.w = (r3.z) * (r3.y);
    r1 = tex2D(s3, v1.xy);
    r3.xyz = (r1.xyz) * (-(r1.xyz)) + (c3.xxx);
    r4.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r3.xyz) * (r4.www) + (r4.xyz);
    r1.z = (r1.w) * (-(c4.x)) + (c4.y);
    r5.w = (r1.w) * (c4.x);
    r1.xy = (r1.ww) * (c12.xy) + (c12.zw);
    r4.w = (r3.w) * (r1.z) + (r5.w);
    r1.x = 1.0f / (r1.x);
    r1.w = (r1.w) * (c3.z);
    r3.w = (r2.w) * (r1.x);
    r7.z = exp2(r1.y);
    r2.w = saturate(dot(r8.xyz, r6.xyz));
    r1.x = pow(abs(r2.w), r7.z);
    r2.w = saturate(dot(r8.xyz, c[17].xyz));
    r1.y = (r7.z) * (c13.x) + (c13.y);
    r1.z = (r2.w) * (r1.z) + (r5.w);
    r1.y = (r1.x) * (r1.y);
    r1.z = (r1.z) * (r4.w) + (c4.z);
    r1.x = 1.0f / (r1.z);
    r1.z = dot(r5.xyz, r8.xyz);
    r1.x = (r2.w) * (r1.x);
    r1.z = (r1.z) + (r1.z);
    r4.w = (r1.y) * (r1.x);
    r1.xyz = (r8.xyz) * (-(r1.zzz)) + (r5.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r2.xyz) * (r4.www);
    r5.xyz = (r1.xyz) * (c3.zzz);
    r1 = tex3D(s11, v8.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r2.xyz) * (c[22].www);
    r1.xyz = (r5.xyz) * (r1.xyz);
    r3.xyz = (r3.xyz) * (r3.www) + (r4.xyz);
    r1.xyz = (r1.xyz) * (c3.www);
    r6.xyz = (r3.xyz) * (r1.xyz);
    r3.w = max(abs(r8.y), abs(r8.z));
    r4.xy = c[21].xy;
    r3.xyz = (r4.yyy) * (c[19].xyz);
    r1.w = max(abs(r8.x), r3.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r8.xyz) * (c[5].xyz);
    r9.xyz = (r2.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (r1.www) + (v8.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r4.xxx) * (c[18].xyz);
    r1.xyz = (r1.xyz) * (c[22].yyy);
    r7.xyz = (r2.www) * (r2.xyz);
    r10.xyz = (r1.xyz) * (c3.www);
    if ((c3.x) >= (v6.w))
    {
        r2 = (v6.xyzx) * (c3.xxxy);
        r1 = (r2) + (-(c14.xyzz));
        r1 = tex2Dlod(s2, r1);
        r1.w = r1.x;
        r3 = (r2) + (c13.zzww);
        r3 = tex2Dlod(s2, r3);
        r1.x = r3.x;
        r3 = (r2) + (-(c13.zzww));
        r3 = tex2Dlod(s2, r3);
        r1.y = r3.x;
        r2 = (r2) + (c14.xyzz);
        r2 = tex2Dlod(s2, r2);
        r1.z = r2.x;
        r5.w = dot(r1, c4.wwww);
        if ((c14.w) < (v6.w))
        {
            r5.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r5.xy) + (c13.zz);
            r1.zw = (v6.zx) * (c3.xy);
            r1 = tex2Dlod(s2, r1);
            r2.xy = (r5.xy) + (-(c13.zz));
            r2.zw = (v6.zx) * (c3.xy);
            r4 = tex2Dlod(s2, r2);
            r2.xy = (r5.xy) + (c14.xy);
            r2.zw = (v6.zx) * (c3.xy);
            r3 = tex2Dlod(s2, r2);
            r2.xy = (r5.xy) + (-(c14.xy));
            r2.zw = (v6.zx) * (c3.xy);
            r2 = tex2Dlod(s2, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r1.w = dot(r1, c4.wwww);
            r1.z = (-(r5.w)) + (r1.w);
            r1.w = (v6.w) * (c15.x) + (c15.y);
            r5.w = (r1.w) * (r1.z) + (r5.w);
        }
    }
    else
    {
        r1.z = (v6.w) + (c15.z);
        r1.z = ((r1.z) >= 0.0f ? (c3.y) : (c3.x));
        if ((r1.z) != (-(r1.z)))
        {
            r1.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r1.xy) + (c13.zz);
            r2.zw = (v6.zz) * (c3.xy);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r1.xy) + (-(c13.zz));
            r3.zw = (v6.zz) * (c3.xy);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r1.xy) + (c14.xy);
            r3.zw = (v6.zz) * (c3.xy);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r1.xy) + (-(c14.xy));
            r3.zw = (v6.zz) * (c3.xy);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r1.y = dot(r2, c4.wwww);
            r1.z = saturate((v6.w) + (c15.y));
            r1.w = (r1.w) + (-(r1.y));
            r1.w = (r1.z) * (r1.w) + (r1.y);
        }
        r5.w = r1.w;
    }
    r4 = (-(v7.yyyy)) + (c[7]);
    r3 = (-(v7.xxxx)) + (c[6]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v7.zzzz)) + (c[8]);
    r7.xyz = (r5.www) * (r7.xyz) + (r10.xyz);
    r1 = (r2) * (r2) + (r1);
    r9.xyz = (r9.xyz) * (r5.www);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r7.xyz = (r0.xyz) * (r7.xyz) + (r9.xyz);
    r4 = (r4) * (r5);
    r4 = (r8.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r8.xxxx) + (r4);
    r2 = saturate((r2) * (r8.zzzz) + (r3));
    r3.w = c3.x;
    r1 = saturate((r1) * (c[9]) + (r3.wwww));
    r3.xyz = (r6.xyz) * (c[22].xxx) + (r7.xyz);
    r1 = (r2) * (r1);
    r2.z = dot(c[20], r1);
    r2.w = (-(r7.w)) + (c3.x);
    r2.x = dot(c[10], r1);
    r2.w = ((r6.w) >= 0.0f ? (r2.w) : (c3.y));
    r2.y = dot(c[11], r1);
    r1.w = (r2.w) * (r2.w);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r1.w = (r1.w) * (c[29].w);
    r0.xyz = (c[29].xyz) * (r1.www) + (r0.xyz);
    r1.xyz = (r0.www) * (r0.xyz);
    r1.w = c3.x;
    r0.z = dot(r1, c[26]);
    r0.x = dot(r1, c[24]);
    r0.y = dot(r1, c[25]);
    r0.xyz = (v3.xyz) * (-(r0.www)) + (r0.xyz);
    r0.xyz = (r0.xyz) * (v2.www);
    r0.xyz = (v3.xyz) * (r0.www) + (r0.xyz);
    r0.xyz = max(((r0.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
