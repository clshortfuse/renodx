// Mechanically reconstructed from 0xCB47C763.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(0.0f, 0.25f, 1.0f, 0.5f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.000244140625f, 0.0f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 9.99999975e-06f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(2.0f, -1.0f, 1e-15f, 1.44269502f);
    const float4 c14 = float4(0.100000001f, 9.99999997e-07f, 0.0f, 0.0f);
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

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r1.xyz = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    r2 = (c[32]) * (v1.yyyy);
    r2 = (v1.xxxx) * (c[31]) + (r2);
    r2 = (v1.zzzz) * (c[33]) + (r2);
    r2 = (r2) + (c[34]);
    r3.xy = (r2.ww) * (c[36].xy);
    r3.zw = c0.xx;
    r4 = (r2) + (r3.xyww);
    r4 = tex2Dproj(s2, r4);
    r3 = (r2) + (-(r3));
    r3 = tex2Dproj(s2, r3);
    r5.xy = (r2.ww) * (c[36].zw);
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
    r4.x = dot(r2, c[25]);
    r4.y = dot(r2, c[26]);
    r4.z = dot(r2, c[27]);
    r2.x = dot(r2, c[28]);
    r4.w = (r4.z) * (r4.z);
    r2.y = dot(c[23].yz, r4.zw) + (c[23].x);
    r2.z = saturate(1.0f / (r2.y));
    r2.y = ((-abs(r2.y)) >= 0.0f ? (c0.x) : (r2.z));
    r2.zw = saturate((r4.zz) * (c[24].xy) + (c[24].zw));
    r4.zw = (r2.zw) * (r2.zw);
    r2.zw = (r2.zw) * (c1.xx) + (c1.yy);
    r2.z = (r4.z) * (r2.z);
    r2.y = (r2.y) * (r2.z);
    r2.z = (r4.w) * (-(r2.w)) + (c0.z);
    r2.y = (r2.y) * (r2.z);
    r2.z = dot(r3.xyz, c[29].xyz);
    r2.z = saturate((r2.z) * (c[30].x) + (c[30].y));
    r2.w = (r2.z) * (r2.z);
    r2.z = (r2.z) * (c1.x) + (c1.y);
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
    r4.xyz = (r1.www) * (c[22].xyz);
    if ((c0.z) >= (v5.w))
    {
        r5 = (v5.xyzx) * (c0.zzzx) + (c0.xxxz);
        r5 = (r5) * (c0.zzzx);
        r6 = (r5) + (c1.zzww);
        r6 = tex2Dlod(s1, r6);
        r7 = (r5) + (-(c1.zzww));
        r7 = tex2Dlod(s1, r7);
        r8 = (r5) + (c3.xyzz);
        r8 = tex2Dlod(s1, r8);
        r5 = (r5) + (-(c3.xyzz));
        r5 = tex2Dlod(s1, r5);
        r6.y = r7.x;
        r6.z = r8.x;
        r6.w = r5.x;
        r1.w = dot(r6, c0.yyyy);
        if ((c3.w) < (v5.w))
        {
            r5.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r5.zw = (v5.zx) * (c0.zx) + (c0.xz);
            r5 = (r5) * (c0.zzzx);
            r6 = (r5) + (c1.zzww);
            r6 = tex2Dlod(s1, r6);
            r7 = (r5) + (-(c1.zzww));
            r7 = tex2Dlod(s1, r7);
            r8 = (r5) + (c3.xyzz);
            r8 = tex2Dlod(s1, r8);
            r5 = (r5) + (-(c3.xyzz));
            r5 = tex2Dlod(s1, r5);
            r6.y = r7.x;
            r6.z = r8.x;
            r6.w = r5.x;
            r2.w = dot(r6, c0.yyyy);
            r3.w = (v5.w) * (c4.x) + (c4.y);
            r4.w = lerp(r1.w, r2.w, r3.w);
            r1.w = r4.w;
        }
    }
    else
    {
        r2.w = (c4.z) + (v5.w);
        r2.w = ((r2.w) >= 0.0f ? (c0.x) : (c0.z));
        if ((r2.w) != (-(r2.w)))
        {
            r5.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r5.zw = (v5.zz) * (c0.zx) + (c0.xz);
            r5 = (r5) * (c0.zzzx);
            r6 = (r5) + (c1.zzww);
            r6 = tex2Dlod(s1, r6);
            r7 = (r5) + (-(c1.zzww));
            r7 = tex2Dlod(s1, r7);
            r8 = (r5) + (c3.xyzz);
            r8 = tex2Dlod(s1, r8);
            r5 = (r5) + (-(c3.xyzz));
            r5 = tex2Dlod(s1, r5);
            r6.y = r7.x;
            r6.z = r8.x;
            r6.w = r5.x;
            r2.w = dot(r6, c0.yyyy);
            r3.w = saturate((-(c1.y)) + (v5.w));
            r1.w = (r3.w) * (-(r2.w)) + (r2.w);
        }
        else
        {
            r1.w = c0.x;
        }
    }
    r5.xyz = (r1.www) * (c[18].xyz);
    r6.xyz = (r1.www) * (c[19].xyz);
    r7.xyz = normalize(c[17].xyz);
    r8.xy = ddx(v4.xy);
    r8.zw = ddy(v4.xy);
    r9.xy = (c[42].xx) * (v4.xy);
    r9 = tex2D(s4, r9.xy);
    r9.xy = (r9.wy) * (c12.xy) + (c12.zw);
    r9.xy = (r9.xy) * (c0.ww) + (c0.ww);
    r9.xy = (r9.xy) * (c13.xx) + (c13.yy);
    r1.xyz = (r1.xyz) * (r9.yyy);
    r1.xyz = (r9.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r9.xyz = normalize(r1.xyz);
    r1.xyz = (r5.xyz) * (c[35].xxx);
    r0.x = saturate(dot(r9.xyz, r7.xyz));
    r1.w = saturate(dot(r9.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r1.www);
    r1.xyz = (r0.xxx) * (r1.xyz) + (r2.xyz);
    r2.xyz = (r6.xyz) * (c[35].yyy);
    r5 = tex2D(s6, v4.xy);
    r2.w = (r5.x) * (c[45].x);
    r3.w = max(c4.w, r2.w);
    r2.w = dot(-(v1.xyz), -(v1.xyz));
    r2.w = rsqrt(r2.w);
    r6.xyz = (r2.www) * (-(v1.xyz));
    r4.w = saturate(dot(r9.xyz, r6.xyz));
    r3.w = (r3.w) * (r3.w);
    r3.w = 1.0f / (r3.w);
    r7.xyz = (-(v1.xyz)) * (r2.www) + (r7.xyz);
    r10.xyz = normalize(r7.xyz);
    r5.w = saturate(dot(r9.xyz, r10.xyz));
    r6.w = (r5.w) * (r5.w) + (c13.z);
    r6.w = 1.0f / (r6.w);
    r7.x = (-(r6.w)) + (c0.z);
    r7.x = (r3.w) * (r7.x);
    r7.x = (r7.x) * (c13.w);
    r7.x = exp2(r7.x);
    r6.w = (r6.w) * (r6.w);
    r6.w = (r7.x) * (r6.w);
    r5.w = (r5.w) + (r5.w);
    r7.x = 1.0f / (r4.w);
    r5.w = (r5.w) * (r7.x);
    r7.y = min(r4.w, r0.x);
    r5.w = saturate((r5.w) * (r7.y));
    r0.x = (r0.x) * (r5.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.x = (r6.w) * (r0.x);
    r3.xyz = (-(v1.xyz)) * (r2.www) + (r3.xyz);
    r10.xyz = normalize(r3.xyz);
    r2.w = saturate(dot(r9.xyz, r10.xyz));
    r3.x = (r2.w) * (r2.w) + (c13.z);
    r3.x = 1.0f / (r3.x);
    r3.y = (-(r3.x)) + (c0.z);
    r3.y = (r3.w) * (r3.y);
    r3.y = (r3.y) * (c13.w);
    r3.y = exp2(r3.y);
    r3.x = (r3.x) * (r3.x);
    r3.x = (r3.y) * (r3.x);
    r2.w = dot(r7.xx, r2.ww) + (c0.x);
    r3.y = min(r4.w, r1.w);
    r2.w = saturate((r2.w) * (r3.y));
    r1.w = (r1.w) * (r2.w);
    r1.w = rsqrt(r1.w);
    r1.w = 1.0f / (r1.w);
    r1.w = (r3.x) * (r1.w);
    r3.xyz = (r4.xyz) * (r1.www);
    r2.xyz = (r0.xxx) * (r2.xyz) + (r3.xyz);
    r0.x = saturate(dot(r0.yzw, r6.xyz));
    r0.x = (r4.w) + (r0.x);
    r0.x = (r0.x) * (c0.w);
    r1.w = max(c14.x, r0.x);
    r0.x = 1.0f / (r1.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r2.xyz = (r2.xyz) * (r0.xxx);
    r2.xyz = (r3.www) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[44].xxx);
    r2.xyz = (r2.xyz) * (c0.yyy) + (c0.zzz);
    r3.xz = c0.xz;
    r0.x = max(c[43].x, r3.x);
    r0.x = (r0.x) + (-(c0.z));
    r3.x = log2(abs(r2.x));
    r3.y = log2(abs(r2.y));
    r3.w = log2(abs(r2.z));
    r2.xyz = (r0.xxx) * (r3.xyw);
    r3.x = exp2(r2.x);
    r3.y = exp2(r2.y);
    r3.w = exp2(r2.z);
    r2.xyz = normalize(v1.xyz);
    r0.x = dot(r2.xyz, r9.xyz);
    r0.x = (r0.x) + (r0.x);
    r0.x = (r9.x) * (-(r0.x)) + (r2.x);
    r0.x = (r0.x) * (c14.y);
    r2.xyz = (r5.xyz) * (c[41].xxx);
    r2.xyz = (r0.xxx) * (r2.xyz);
    r2.xyz = (r3.xyw) * (c[43].yyy) + (r2.xyz);
    r4 = tex2Dgrad(s5, v4.xy, r8.xy, r8.zw);
    r4 = (r4) * (r4);
    r2.xyz = (r2.xyz) * (c[46].xxx);
    r4.xyz = (r1.xyz) * (r4.xyz) + (r2.xyz);
    r1 = max(r4, c0.xxxx);
    r2 = (c[5]) + (-(v1.xxxx));
    r4 = (c[6]) + (-(v1.yyyy));
    r5 = (c[7]) + (-(v1.zzzz));
    r6 = (r4) * (r4);
    r6 = (r2) * (r2) + (r6);
    r6 = (r5) * (r5) + (r6);
    r7.x = rsqrt(r6.x);
    r7.y = rsqrt(r6.y);
    r7.z = rsqrt(r6.z);
    r7.w = rsqrt(r6.w);
    r2 = (r2) * (r7);
    r4 = (r4) * (r7);
    r5 = (r5) * (r7);
    r3 = saturate((r6) * (c[8]) + (r3.zzzz));
    r4 = (r0.zzzz) * (r4);
    r2 = (r2) * (r0.yyyy) + (r4);
    r0 = saturate((r5) * (r0.wwww) + (r2));
    r0 = (r3) * (r0);
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
    oC0.w = r1.w;

    return oC0;
}
