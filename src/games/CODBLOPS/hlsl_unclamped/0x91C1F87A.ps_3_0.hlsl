// Mechanically reconstructed from 0x91C1F87A.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD6;
    float4 v6 : TEXCOORD7;
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
    const float4 c0 = float4(0.0f, 0.25f, 1.0f, 0.5f);
    const float4 c1 = float4(2.0f, -1.0f, 8.0f, 31.875f);
    const float4 c3 = float4(4.0f, -3.0f, -4.0f, 7.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c12 = float4(-2.0f, 3.0f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c14 = float4(0.200000003f, 4.0f, -2.0f, 0.142857f);
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

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r1.xyz = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    r2 = (c[31]) * (v1.yyyy);
    r2 = (v1.xxxx) * (c[30]) + (r2);
    r2 = (v1.zzzz) * (c[32]) + (r2);
    r2 = (r2) + (c[33]);
    r3.xy = (r2.ww) * (c[35].xy);
    r3.zw = c0.xx;
    r4 = (r2) + (r3.xyww);
    r4 = tex2Dproj(s2, r4);
    r3 = (r2) + (-(r3));
    r3 = tex2Dproj(s2, r3);
    r5.xy = (r2.ww) * (c[35].zw);
    r5.zw = c0.xx;
    r6 = (r2) + (r5.xyww);
    r6 = tex2Dproj(s2, r6);
    r2 = (r2) + (-(r5));
    r2 = tex2Dproj(s2, r2);
    r4.y = r3.x;
    r4.z = r6.x;
    r4.w = r2.x;
    r1.w = dot(r4, c0.yyyy);
    r2.xyz = (c[20].xyz) + (-(v1.xyz));
    r3.xyz = normalize(r2.xyz);
    r2 = (v1.xyzx) * (c0.zzzx) + (c0.xxxz);
    r4.x = dot(r2, c[24]);
    r4.y = dot(r2, c[25]);
    r4.z = dot(r2, c[26]);
    r2.x = dot(r2, c[27]);
    r4.w = (r4.z) * (r4.z);
    r2.y = dot(c[22].yz, r4.zw) + (c[22].x);
    r2.z = saturate(1.0f / (r2.y));
    r2.y = ((-abs(r2.y)) >= 0.0f ? (c0.x) : (r2.z));
    r2.zw = saturate((r4.zz) * (c[23].xy) + (c[23].zw));
    r4.zw = (r2.zw) * (r2.zw);
    r2.zw = (r2.zw) * (c12.xx) + (c12.yy);
    r2.z = (r4.z) * (r2.z);
    r2.y = (r2.y) * (r2.z);
    r2.z = (r4.w) * (-(r2.w)) + (c0.z);
    r2.y = (r2.y) * (r2.z);
    r2.z = dot(r3.xyz, c[28].xyz);
    r2.z = saturate((r2.z) * (c[29].x) + (c[29].y));
    r2.w = (r2.z) * (r2.z);
    r2.z = (r2.z) * (c12.x) + (c12.y);
    r2.z = (r2.w) * (r2.z);
    r2.y = (r2.y) * (r2.z);
    r2.x = 1.0f / (r2.x);
    r2.xz = (r4.xy) * (r2.xx);
    r2.xz = (r2.xz) * (c0.ww) + (c0.ww);
    r4 = tex2D(s3, r2.xz);
    r2.x = (r4.x) * (r4.x);
    r2.x = (r2.y) * (r2.x);
    r1.w = (r1.w) * (r2.x);
    r2.xyz = (r1.www) * (c[21].xyz);
    if ((c0.z) >= (v5.w))
    {
        r4 = (v5.xyzx) * (c0.zzzx) + (c0.xxxz);
        r4 = (r4) * (c0.zzzx);
        r5 = (r4) + (c12.zzww);
        r5 = tex2Dlod(s1, r5);
        r6 = (r4) + (-(c12.zzww));
        r6 = tex2Dlod(s1, r6);
        r7 = (r4) + (c4.xyzz);
        r7 = tex2Dlod(s1, r7);
        r4 = (r4) + (-(c4.xyzz));
        r4 = tex2Dlod(s1, r4);
        r5.y = r6.x;
        r5.z = r7.x;
        r5.w = r4.x;
        r1.w = dot(r5, c0.yyyy);
        if ((c4.w) < (v5.w))
        {
            r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r4.zw = (v5.zx) * (c0.zx) + (c0.xz);
            r4 = (r4) * (c0.zzzx);
            r5 = (r4) + (c12.zzww);
            r5 = tex2Dlod(s1, r5);
            r6 = (r4) + (-(c12.zzww));
            r6 = tex2Dlod(s1, r6);
            r7 = (r4) + (c4.xyzz);
            r7 = tex2Dlod(s1, r7);
            r4 = (r4) + (-(c4.xyzz));
            r4 = tex2Dlod(s1, r4);
            r5.y = r6.x;
            r5.z = r7.x;
            r5.w = r4.x;
            r2.w = dot(r5, c0.yyyy);
            r3.w = (v5.w) * (c3.x) + (c3.y);
            r4.x = lerp(r1.w, r2.w, r3.w);
            r1.w = r4.x;
        }
    }
    else
    {
        r4 = tex2D(s12, v4.zw);
        r2.w = (c3.z) + (v5.w);
        r2.w = ((r2.w) >= 0.0f ? (c0.x) : (c0.z));
        if ((r2.w) != (-(r2.w)))
        {
            r5.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r5.zw = (v5.zz) * (c0.zx) + (c0.xz);
            r5 = (r5) * (c0.zzzx);
            r6 = (r5) + (c12.zzww);
            r6 = tex2Dlod(s1, r6);
            r7 = (r5) + (-(c12.zzww));
            r7 = tex2Dlod(s1, r7);
            r8 = (r5) + (c4.xyzz);
            r8 = tex2Dlod(s1, r8);
            r5 = (r5) + (-(c4.xyzz));
            r5 = tex2Dlod(s1, r5);
            r6.y = r7.x;
            r6.z = r8.x;
            r6.w = r5.x;
            r2.w = dot(r6, c0.yyyy);
            r3.w = saturate((-(c12.y)) + (v5.w));
            r1.w = lerp(r2.w, r4.y, r3.w);
        }
        else
        {
            r1.w = r4.y;
        }
    }
    r4.xyz = (r1.www) * (c[18].xyz);
    r5.xyz = normalize(c[17].xyz);
    r1.w = c[36].w;
    r6.xy = (r1.ww) * (c[42].xy);
    r6.xy = (r6.xy) * (c[41].xx);
    r6.xy = (v4.xy) * (c[41].xx) + (r6.xy);
    r6 = tex2D(s9, r6.xy);
    r6.xyz = (r6.xyz) * (r6.xyz);
    r6.xyz = (r6.xyz) * (v6.xxx);
    r6.xyz = (r6.xyz) * (c3.www);
    r7.xy = (r1.ww) * (c[43].xy);
    r7.xy = (r7.xy) * (c[44].xx);
    r7.xy = (v4.xy) * (c[44].xx) + (r7.xy);
    r7 = tex2D(s8, r7.xy);
    r8.xyz = (r6.xyz) * (r7.xyz);
    r9 = tex2D(s5, v4.xy);
    r9.xy = (r9.wy) * (c13.xy) + (c13.zw);
    r9.xy = (r9.xy) * (c0.ww) + (c0.ww);
    r9.xy = (r9.xy) * (c1.xx) + (c1.yy);
    r9.yzw = (r1.xyz) * (r9.yyy);
    r9.xyz = (r9.xxx) * (v3.xyz) + (r9.yzw);
    r9.xyz = (v2.xyz) * (r0.xxx) + (r9.xyz);
    r0.x = dot(r9.xyz, r9.xyz);
    r0.x = rsqrt(r0.x);
    r10.xyz = (r9.xyz) * (r0.xxx);
    r4.xyz = (r4.xyz) * (c[34].xxx);
    r1.w = saturate(dot(r10.xyz, r5.xyz));
    r2.w = saturate(dot(r10.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r2.www);
    r2.xyz = (r1.www) * (r4.xyz) + (r2.xyz);
    r3.xyz = normalize(v1.xyz);
    r1.w = dot(r3.xyz, r10.xyz);
    r1.w = (r1.w) + (r1.w);
    r3.xyz = (r10.xyz) * (-(r1.www)) + (r3.xyz);
    r3.w = c1.z;
    r3 = texCUBElod(s15, r3);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c1.zzz);
    r4 = tex2D(s14, v4.zw);
    r4.zw = (c0.zw) * (v4.zw);
    r5 = tex2D(s13, r4.zw);
    r4.zw = (r4.xy) * (c1.ww);
    r5.xw = (r5.xz) * (r4.zz);
    r11.xz = (r5.xw) * (c3.xx);
    r1.w = (r4.x) * (c1.w) + (-(r5.x));
    r1.w = (r5.z) * (-(r4.z)) + (r1.w);
    r11.y = (r1.w) + (r1.w);
    r3.xyz = (r3.xyz) * (r11.xyz);
    r3.xyz = (r3.xyz) * (c14.xxx);
    r12.xyz = normalize(v3.xyz);
    r13.xyz = normalize(r1.xyz);
    r1.xy = (v4.zw) * (c0.zw) + (c0.xw);
    r1 = tex2D(s13, r1.xy);
    r4.xz = (r4.ww) * (r1.xz);
    r5.xw = (r4.xz) * (c3.xx);
    r1.w = (r4.y) * (c1.w) + (-(r4.x));
    r1.z = (r1.z) * (-(r4.w)) + (r1.w);
    r5.z = (r1.z) + (r1.z);
    r1.x = r5.y;
    r1.xy = (r1.xy) * (c14.yy) + (c14.zz);
    r1.yzw = (r13.xyz) * (r1.yyy);
    r1.xyz = (r1.xxx) * (r12.xyz) + (r1.yzw);
    r1.xyz = (r9.xyz) * (r0.xxx) + (r1.xyz);
    r4.xyz = normalize(r1.xyz);
    r0.x = dot(r4.xyz, r10.xyz);
    r1.xyz = (r0.xxx) * (r5.xzw) + (r11.xyz);
    r4 = tex2D(s7, v4.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r5 = tex2D(s6, v4.xy);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r1.xyz = (r2.xyz) * (c14.www) + (r1.xyz);
    r2.xyz = (r3.xyz) * (r5.xyz);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r2.xyz);
    r2.xyz = max(r1.xyz, c0.xxx);
    r1 = tex2D(s4, v4.xy);
    r0.x = (-(r1.x)) + (c0.z);
    r1.xyz = (r6.xyz) * (-(r7.xyz)) + (r2.xyz);
    r1.xyz = (r0.xxx) * (r1.xyz) + (r8.xyz);
    r2 = (c[5]) + (-(v1.xxxx));
    r3 = (c[6]) + (-(v1.yyyy));
    r4 = (c[7]) + (-(v1.zzzz));
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
    r6.z = c0.z;
    r5 = saturate((r5) * (c[8]) + (r6.zzzz));
    r3 = (r0.zzzz) * (r3);
    r2 = (r2) * (r0.yyyy) + (r3);
    r0 = saturate((r4) * (r0.wwww) + (r2));
    r0 = (r5) * (r0);
    r2.x = dot(c[9], r0);
    r2.y = dot(c[10], r0);
    r2.z = dot(c[11], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = c0.z;
    r1.x = dot(r0, c[38]);
    r1.y = dot(r0, c[39]);
    r1.z = dot(r0, c[40]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}
