// Mechanically reconstructed from 0xC031AB35.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);
sampler2D s6 : register(s6);
sampler2D s7 : register(s7);
sampler2D s8 : register(s8);
sampler2D s9 : register(s9);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : TEXCOORD7;
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
    const float4 c0 = float4(6.375f, 31.875f, 0.0f, 0.0f);
    const float4 c1 = float4(0.0f, 0.25f, 1.0f, 0.5f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 7.0f);
    const float4 c12 = float4(-2.0f, 3.0f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c14 = float4(2.0f, -1.0f, 0.142857f, 8.0f);
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
    float4 oC0 = 0.0f;

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r1.xyz = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    r1.w = max(abs(r0.z), abs(r0.w));
    r2.x = max(abs(r0.y), r1.w);
    r2.yzw = (r0.yzw) * (c[5].xyz);
    r1.w = 1.0f / (r2.x);
    r2.xyz = (r2.yzw) * (r1.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r3 = (c[32]) * (v1.yyyy);
    r3 = (v1.xxxx) * (c[31]) + (r3);
    r3 = (v1.zzzz) * (c[33]) + (r3);
    r3 = (r3) + (c[34]);
    r4.xy = (r3.ww) * (c[36].xy);
    r4.zw = c1.xx;
    r5 = (r3) + (r4.xyww);
    r5 = tex2Dproj(s2, r5);
    r4 = (r3) + (-(r4));
    r4 = tex2Dproj(s2, r4);
    r6.xy = (r3.ww) * (c[36].zw);
    r6.zw = c1.xx;
    r7 = (r3) + (r6.xyww);
    r7 = tex2Dproj(s2, r7);
    r3 = (r3) + (-(r6));
    r3 = tex2Dproj(s2, r3);
    r5.y = r4.x;
    r5.z = r7.x;
    r5.w = r3.x;
    r1.w = dot(r5, c1.yyyy);
    r2.xyz = (c[21].xyz) + (-(v1.xyz));
    r3.xyz = normalize(r2.xyz);
    r4 = (v1.xyzx) * (c1.zzzx) + (c1.xxxz);
    r2.x = dot(r4, c[25]);
    r2.y = dot(r4, c[26]);
    r5.x = dot(r4, c[27]);
    r2.z = dot(r4, c[28]);
    r5.y = (r5.x) * (r5.x);
    r3.w = dot(c[23].yz, r5.xy) + (c[23].x);
    r4.x = saturate(1.0f / (r3.w));
    r3.w = ((-abs(r3.w)) >= 0.0f ? (c1.x) : (r4.x));
    r4.xy = saturate((r5.xx) * (c[24].xy) + (c[24].zw));
    r4.zw = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c12.xx) + (c12.yy);
    r4.x = (r4.z) * (r4.x);
    r3.w = (r3.w) * (r4.x);
    r4.x = (r4.w) * (-(r4.y)) + (c1.z);
    r3.w = (r3.w) * (r4.x);
    r4.x = dot(r3.xyz, c[29].xyz);
    r4.x = saturate((r4.x) * (c[30].x) + (c[30].y));
    r4.y = (r4.x) * (r4.x);
    r4.x = (r4.x) * (c12.x) + (c12.y);
    r4.x = (r4.y) * (r4.x);
    r3.w = (r3.w) * (r4.x);
    r2.z = 1.0f / (r2.z);
    r2.xy = (r2.xy) * (r2.zz);
    r2.xy = (r2.xy) * (c1.ww) + (c1.ww);
    r4 = tex2D(s3, r2.xy);
    r2.x = (r4.x) * (r4.x);
    r2.x = (r3.w) * (r2.x);
    r1.w = (r1.w) * (r2.x);
    r2.xyz = (r1.www) * (c[22].xyz);
    if ((c1.z) >= (v6.w))
    {
        r4 = (v6.xyzx) * (c1.zzzx) + (c1.xxxz);
        r4 = (r4) * (c1.zzzx);
        r5 = (r4) + (c12.zzww);
        r5 = tex2Dlod(s1, r5);
        r6 = (r4) + (-(c12.zzww));
        r6 = tex2Dlod(s1, r6);
        r7 = (r4) + (c3.xyzz);
        r7 = tex2Dlod(s1, r7);
        r4 = (r4) + (-(c3.xyzz));
        r4 = tex2Dlod(s1, r4);
        r5.y = r6.x;
        r5.z = r7.x;
        r5.w = r4.x;
        r1.w = dot(r5, c1.yyyy);
        if ((c3.w) < (v6.w))
        {
            r4.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r4.zw = (v6.zx) * (c1.zx) + (c1.xz);
            r4 = (r4) * (c1.zzzx);
            r5 = (r4) + (c12.zzww);
            r5 = tex2Dlod(s1, r5);
            r6 = (r4) + (-(c12.zzww));
            r6 = tex2Dlod(s1, r6);
            r7 = (r4) + (c3.xyzz);
            r7 = tex2Dlod(s1, r7);
            r4 = (r4) + (-(c3.xyzz));
            r4 = tex2Dlod(s1, r4);
            r5.y = r6.x;
            r5.z = r7.x;
            r5.w = r4.x;
            r3.w = dot(r5, c1.yyyy);
            r4.x = (v6.w) * (c4.x) + (c4.y);
            r5.x = lerp(r1.w, r3.w, r4.x);
            r1.w = r5.x;
        }
    }
    else
    {
        r3.w = (c4.z) + (v6.w);
        r3.w = ((r3.w) >= 0.0f ? (c1.x) : (c1.z));
        if ((r3.w) != (-(r3.w)))
        {
            r4.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r4.zw = (v6.zz) * (c1.zx) + (c1.xz);
            r4 = (r4) * (c1.zzzx);
            r5 = (r4) + (c12.zzww);
            r5 = tex2Dlod(s1, r5);
            r6 = (r4) + (-(c12.zzww));
            r6 = tex2Dlod(s1, r6);
            r7 = (r4) + (c3.xyzz);
            r7 = tex2Dlod(s1, r7);
            r4 = (r4) + (-(c3.xyzz));
            r4 = tex2Dlod(s1, r4);
            r5.y = r6.x;
            r5.z = r7.x;
            r5.w = r4.x;
            r3.w = dot(r5, c1.yyyy);
            r4.x = saturate((-(c12.y)) + (v6.w));
            r1.w = lerp(r3.w, r2.w, r4.x);
        }
        else
        {
            r1.w = r2.w;
        }
    }
    r4.xyz = (r1.www) * (c[18].xyz);
    r5.xyz = normalize(c[17].xyz);
    r1.w = c[37].w;
    r6.xy = (r1.ww) * (c[43].xy);
    r6.xy = (r6.xy) * (c[42].xx);
    r6.xy = (v4.xy) * (c[42].xx) + (r6.xy);
    r6 = tex2D(s9, r6.xy);
    r6.xyz = (r6.xyz) * (r6.xyz);
    r6.xyz = (r6.xyz) * (v7.xxx);
    r6.xyz = (r6.xyz) * (c4.www);
    r7.xy = (r1.ww) * (c[44].xy);
    r7.xy = (r7.xy) * (c[45].xx);
    r7.xy = (v4.xy) * (c[45].xx) + (r7.xy);
    r7 = tex2D(s8, r7.xy);
    r8.xyz = (r6.xyz) * (r7.xyz);
    r9 = tex2D(s5, v4.xy);
    r9.xy = (r9.wy) * (c13.xy) + (c13.zw);
    r9.xy = (r9.xy) * (c1.ww) + (c1.ww);
    r9.xy = (r9.xy) * (c14.xx) + (c14.yy);
    r1.xyz = (r1.xyz) * (r9.yyy);
    r1.xyz = (r9.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r9.xyz = normalize(r1.xyz);
    r1.xyz = (r4.xyz) * (c[35].xxx);
    r0.x = saturate(dot(r9.xyz, r5.xyz));
    r1.w = saturate(dot(r9.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r1.www);
    r1.xyz = (r0.xxx) * (r1.xyz) + (r2.xyz);
    r1.xyz = (r1.xyz) * (c14.zzz);
    r2.xyz = normalize(v1.xyz);
    r0.x = dot(r2.xyz, r9.xyz);
    r0.x = (r0.x) + (r0.x);
    r2.xyz = (r9.xyz) * (-(r0.xxx)) + (r2.xyz);
    r2.w = c14.w;
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c14.www);
    r3 = tex3D(s11, v5.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (c0.xxx);
    r0.x = max(abs(r9.y), abs(r9.z));
    r1.w = max(abs(r9.x), r0.x);
    r3.xyz = (r9.xyz) * (c[5].xyz);
    r0.x = 1.0f / (r1.w);
    r3.xyz = (r3.xyz) * (r0.xxx) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4 = tex2D(s7, v4.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r5 = tex2D(s6, v4.xy);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r1.xyz = (r3.xyz) * (c0.yyy) + (r1.xyz);
    r2.xyz = (r2.xyz) * (r5.xyz);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r2.xyz);
    r2.xyz = max(r1.xyz, c1.xxx);
    r1 = tex2D(s4, v4.xy);
    r0.x = (-(r1.x)) + (c1.z);
    r1.xyz = (r6.xyz) * (-(r7.xyz)) + (r2.xyz);
    r1.xyz = (r0.xxx) * (r1.xyz) + (r8.xyz);
    r2 = (c[6]) + (-(v1.xxxx));
    r3 = (c[7]) + (-(v1.yyyy));
    r4 = (c[8]) + (-(v1.zzzz));
    r5 = (r3) * (r3);
    r5 = (r2) * (r2) + (r5);
    r5 = (r4) * (r4) + (r5);
    r6.x = rsqrt(r5.x);
    r6.y = rsqrt(r5.y);
    r6.z = rsqrt(r5.z);
    r6.w = rsqrt(r5.w);
    r2 = (r2) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r6);
    r6.z = c1.z;
    r5 = saturate((r5) * (c[9]) + (r6.zzzz));
    r3 = (r0.zzzz) * (r3);
    r2 = (r2) * (r0.yyyy) + (r3);
    r0 = saturate((r4) * (r0.wwww) + (r2));
    r0 = (r5) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = c1.z;
    r1.x = dot(r0, c[39]);
    r1.y = dot(r0, c[40]);
    r1.z = dot(r0, c[41]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[38].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.z;

    return oC0;
}
