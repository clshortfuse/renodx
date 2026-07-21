// Mechanically reconstructed from 0x22BE6199.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
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
    const float4 c0 = float4(1.16412354f, 1.59579468f, -0.87065506f, 31.875f);
    const float4 c1 = float4(0.0f, 0.25f, 1.0f, 0.5f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 9.99999975e-06f);
    const float4 c12 = float4(-2.0f, 3.0f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(1e-15f, 1.44269502f, 0.100000001f, 8.0f);
    const float4 c14 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c15 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = normalize(v2.xyz);
    r1.x = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.x);
    r1.xyz = (r0.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r2.x);
    r1.xyz = (r1.xyz) * (r0.www) + (v4.xyz);
    r1 = tex3D(s11, r1.xyz);
    r2 = (c[33]) * (v1.yyyy);
    r2 = (v1.xxxx) * (c[32]) + (r2);
    r2 = (v1.zzzz) * (c[34]) + (r2);
    r2 = (r2) + (c[35]);
    r3.xy = (r2.ww) * (c[37].xy);
    r3.zw = c1.xx;
    r4 = (r2) + (r3.xyww);
    r4 = tex2Dproj(s2, r4);
    r3 = (r2) + (-(r3));
    r3 = tex2Dproj(s2, r3);
    r5.xy = (r2.ww) * (c[37].zw);
    r5.zw = c1.xx;
    r6 = (r2) + (r5.xyww);
    r6 = tex2Dproj(s2, r6);
    r2 = (r2) + (-(r5));
    r2 = tex2Dproj(s2, r2);
    r4.y = r3.x;
    r4.z = r6.x;
    r4.w = r2.x;
    r0.w = dot(r4, c1.yyyy);
    r2.xyz = (c[21].xyz) + (-(v1.xyz));
    r3.xyz = normalize(r2.xyz);
    r2 = (v1.xyzx) * (c1.zzzx) + (c1.xxxz);
    r4.x = dot(r2, c[26]);
    r4.y = dot(r2, c[27]);
    r4.z = dot(r2, c[28]);
    r2.x = dot(r2, c[29]);
    r4.w = (r4.z) * (r4.z);
    r2.y = dot(c[24].yz, r4.zw) + (c[24].x);
    r2.z = saturate(1.0f / (r2.y));
    r2.y = ((-abs(r2.y)) >= 0.0f ? (c1.x) : (r2.z));
    r2.zw = saturate((r4.zz) * (c[25].xy) + (c[25].zw));
    r4.zw = (r2.zw) * (r2.zw);
    r2.zw = (r2.zw) * (c12.xx) + (c12.yy);
    r2.z = (r4.z) * (r2.z);
    r2.y = (r2.y) * (r2.z);
    r2.z = (r4.w) * (-(r2.w)) + (c1.z);
    r2.y = (r2.y) * (r2.z);
    r2.z = dot(r3.xyz, c[30].xyz);
    r2.z = saturate((r2.z) * (c[31].x) + (c[31].y));
    r2.w = (r2.z) * (r2.z);
    r2.z = (r2.z) * (c12.x) + (c12.y);
    r2.z = (r2.w) * (r2.z);
    r2.y = (r2.y) * (r2.z);
    r2.x = 1.0f / (r2.x);
    r2.xz = (r4.xy) * (r2.xx);
    r2.xz = (r2.xz) * (c1.ww) + (c1.ww);
    r4 = tex2D(s3, r2.xz);
    r2.x = (r4.x) * (r4.x);
    r2.x = (r2.y) * (r2.x);
    r0.w = (r0.w) * (r2.x);
    r2.xyz = (r0.www) * (c[22].xyz);
    r4.xyz = (r0.www) * (c[23].xyz);
    if ((c1.z) >= (v5.w))
    {
        r5 = (v5.xyzx) * (c1.zzzx) + (c1.xxxz);
        r5 = (r5) * (c1.zzzx);
        r6 = (r5) + (c12.zzww);
        r6 = tex2Dlod(s1, r6);
        r7 = (r5) + (-(c12.zzww));
        r7 = tex2Dlod(s1, r7);
        r8 = (r5) + (c3.xyzz);
        r8 = tex2Dlod(s1, r8);
        r5 = (r5) + (-(c3.xyzz));
        r5 = tex2Dlod(s1, r5);
        r6.y = r7.x;
        r6.z = r8.x;
        r6.w = r5.x;
        r0.w = dot(r6, c1.yyyy);
        if ((c3.w) < (v5.w))
        {
            r5.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r5.zw = (v5.zx) * (c1.zx) + (c1.xz);
            r5 = (r5) * (c1.zzzx);
            r6 = (r5) + (c12.zzww);
            r6 = tex2Dlod(s1, r6);
            r7 = (r5) + (-(c12.zzww));
            r7 = tex2Dlod(s1, r7);
            r8 = (r5) + (c3.xyzz);
            r8 = tex2Dlod(s1, r8);
            r5 = (r5) + (-(c3.xyzz));
            r5 = tex2Dlod(s1, r5);
            r6.y = r7.x;
            r6.z = r8.x;
            r6.w = r5.x;
            r2.w = dot(r6, c1.yyyy);
            r3.w = (v5.w) * (c4.x) + (c4.y);
            r4.w = lerp(r0.w, r2.w, r3.w);
            r0.w = r4.w;
        }
    }
    else
    {
        r2.w = (c4.z) + (v5.w);
        r2.w = ((r2.w) >= 0.0f ? (c1.x) : (c1.z));
        if ((r2.w) != (-(r2.w)))
        {
            r5.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r5.zw = (v5.zz) * (c1.zx) + (c1.xz);
            r5 = (r5) * (c1.zzzx);
            r6 = (r5) + (c12.zzww);
            r6 = tex2Dlod(s1, r6);
            r7 = (r5) + (-(c12.zzww));
            r7 = tex2Dlod(s1, r7);
            r8 = (r5) + (c3.xyzz);
            r8 = tex2Dlod(s1, r8);
            r5 = (r5) + (-(c3.xyzz));
            r5 = tex2Dlod(s1, r5);
            r6.y = r7.x;
            r6.z = r8.x;
            r6.w = r5.x;
            r2.w = dot(r6, c1.yyyy);
            r3.w = saturate((-(c12.y)) + (v5.w));
            r0.w = lerp(r2.w, r1.w, r3.w);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    r5.xyz = (r0.www) * (c[18].xyz);
    r6.xyz = (r0.www) * (c[19].xyz);
    r7.xyz = normalize(c[17].xyz);
    r5.xyz = (r5.xyz) * (c[36].xxx);
    r0.w = saturate(dot(r0.xyz, r7.xyz));
    r1.w = saturate(dot(r0.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r1.www);
    r2.xyz = (r0.www) * (r5.xyz) + (r2.xyz);
    r5.xyz = (r6.xyz) * (c[36].yyy);
    r6 = tex2D(s9, v3.xy);
    r2.w = (r6.x) * (r6.x);
    r3.w = max(c4.w, r2.w);
    r2.w = dot(-(v1.xyz), -(v1.xyz));
    r2.w = rsqrt(r2.w);
    r6.xyz = (r2.www) * (-(v1.xyz));
    r4.w = saturate(dot(r0.xyz, r6.xyz));
    r3.w = (r3.w) * (r3.w);
    r3.w = 1.0f / (r3.w);
    r6.xyz = (-(v1.xyz)) * (r2.www) + (r7.xyz);
    r7.xyz = normalize(r6.xyz);
    r5.w = saturate(dot(r0.xyz, r7.xyz));
    r6.x = (r5.w) * (r5.w) + (c13.x);
    r6.x = 1.0f / (r6.x);
    r6.y = (-(r6.x)) + (c1.z);
    r6.y = (r3.w) * (r6.y);
    r6.y = (r6.y) * (c13.y);
    r6.y = exp2(r6.y);
    r6.x = (r6.x) * (r6.x);
    r6.x = (r6.y) * (r6.x);
    r5.w = (r5.w) + (r5.w);
    r6.y = 1.0f / (r4.w);
    r5.w = (r5.w) * (r6.y);
    r6.z = min(r4.w, r0.w);
    r5.w = saturate((r5.w) * (r6.z));
    r0.w = (r0.w) * (r5.w);
    r0.w = rsqrt(r0.w);
    r0.w = 1.0f / (r0.w);
    r0.w = (r6.x) * (r0.w);
    r3.xyz = (-(v1.xyz)) * (r2.www) + (r3.xyz);
    r7.xyz = normalize(r3.xyz);
    r2.w = saturate(dot(r0.xyz, r7.xyz));
    r3.x = (r2.w) * (r2.w) + (c13.x);
    r3.x = 1.0f / (r3.x);
    r3.y = (-(r3.x)) + (c1.z);
    r3.y = (r3.w) * (r3.y);
    r3.y = (r3.y) * (c13.y);
    r3.y = exp2(r3.y);
    r3.x = (r3.x) * (r3.x);
    r3.x = (r3.y) * (r3.x);
    r2.w = dot(r6.yy, r2.ww) + (c1.x);
    r3.y = min(r4.w, r1.w);
    r2.w = saturate((r2.w) * (r3.y));
    r1.w = (r1.w) * (r2.w);
    r1.w = rsqrt(r1.w);
    r1.w = 1.0f / (r1.w);
    r1.w = (r3.x) * (r1.w);
    r3.xyz = (r4.xyz) * (r1.www);
    r3.xyz = (r0.www) * (r5.xyz) + (r3.xyz);
    r0.w = max(c13.z, r4.w);
    r0.w = 1.0f / (r0.w);
    r0.w = rsqrt(r0.w);
    r0.w = 1.0f / (r0.w);
    r3.xyz = (r3.xyz) * (r0.www);
    r3.xyz = (r3.www) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c1.yyy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r4 = tex2D(s8, v3.xy);
    r5 = (r4) * (r4);
    r4.xy = lerp(c[39].xy, c[39].zw, v3.xy);
    r6 = tex2D(s4, r4.xy);
    r7 = tex2D(s5, r4.xy);
    r8 = tex2D(s6, r4.xy);
    r6.xw = (r6.xx) * (c1.zx) + (c1.xz);
    r6.y = r7.x;
    r4.x = dot(c0.xyz, r6.xyw);
    r6.z = r8.x;
    r4.y = dot(c14, r6);
    r4.z = dot(c15.xyz, r6.xzw);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r4.xyz) * (c[41].xxx);
    r6.xyz = (r4.xyz) * (c13.www) + (-(r5.xyz));
    r6.w = (r4.w) * (-(r4.w)) + (c[42].x);
    r4 = (c[38].xxxx) * (r6) + (r5);
    r5 = tex2D(s7, v3.xy);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r1.xyz = (r1.xyz) * (c0.www) + (r2.xyz);
    r2.xyz = (r3.xyz) * (r5.xyz);
    r2.xyz = (r4.www) * (r2.xyz);
    r4.xyz = (r1.xyz) * (r4.xyz) + (r2.xyz);
    r1 = max(r4, c1.xxxx);
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
    r3 = (r0.yyyy) * (r3);
    r2 = (r2) * (r0.xxxx) + (r3);
    r0 = saturate((r4) * (r0.zzzz) + (r2));
    r0 = (r5) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[40].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r1.w;

    return oC0;
}
