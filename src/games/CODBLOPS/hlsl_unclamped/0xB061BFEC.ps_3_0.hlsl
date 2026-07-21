// Mechanically reconstructed from 0xB061BFEC.ps_3_0.cso.
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
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

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
    const float4 c0 = float4(0.0f, 0.25f, 1.0f, -0.0f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.5f, 0.75f);
    const float4 c3 = float4(4.0f, -3.0f, -28.0f, 30.0f);
    const float4 c4 = float4(0.000244140625f, 0.0f, -0.000244140625f, -0.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
    const float4 c13 = float4(0.38647899f, 0.392856985f, 0.364796013f, 0.782500029f);
    const float4 c14 = float4(8.0f, 31.875f, 15.0f, 0.0399999991f);
    const float4 c15 = float4(0.00749999983f, 1.00750005f, 0.0f, 0.0f);
    const float4 c16 = float4(81.2394867f, 17.3480244f, 37.3498383f, 59.3948402f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = normalize(v2.xyz);
    r1.x = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.x);
    r1.xyz = (r0.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r2.x);
    r1.xyz = (r1.xyz) * (r0.www) + (v4.xyz);
    r1 = tex3D(s11, r1.xyz);
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
    r0.w = dot(r4, c0.yyyy);
    r1.xyz = (c[21].xyz) + (-(v1.xyz));
    r2.xyz = normalize(r1.xyz);
    r3 = (v1.xyzx) * (c0.zzzx) + (c0.wwwz);
    r1.x = dot(r3, c[25]);
    r1.y = dot(r3, c[26]);
    r4.x = dot(r3, c[27]);
    r1.z = dot(r3, c[28]);
    r4.y = (r4.x) * (r4.x);
    r2.w = dot(c[23].yz, r4.xy) + (c[23].x);
    r3.x = saturate(1.0f / (r2.w));
    r2.w = ((-abs(r2.w)) >= 0.0f ? (c0.x) : (r3.x));
    r3.xy = saturate((r4.xx) * (c[24].xy) + (c[24].zw));
    r3.zw = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c1.xx) + (c1.yy);
    r3.x = (r3.z) * (r3.x);
    r2.w = (r2.w) * (r3.x);
    r3.x = (r3.w) * (-(r3.y)) + (c0.z);
    r2.w = (r2.w) * (r3.x);
    r3.x = dot(r2.xyz, c[29].xyz);
    r3.x = saturate((r3.x) * (c[30].x) + (c[30].y));
    r3.y = (r3.x) * (r3.x);
    r3.x = (r3.x) * (c1.x) + (c1.y);
    r3.x = (r3.y) * (r3.x);
    r2.w = (r2.w) * (r3.x);
    r1.z = 1.0f / (r1.z);
    r1.xy = (r1.xy) * (r1.zz);
    r1.xy = (r1.xy) * (c1.zz) + (c1.zz);
    r3 = tex2D(s3, r1.xy);
    r1.x = (r3.x) * (r3.x);
    r1.x = (r2.w) * (r1.x);
    r0.w = (r0.w) * (r1.x);
    r1.xyz = (r0.www) * (c[22].xyz);
    if ((c0.z) >= (v5.w))
    {
        r3 = (v5.xyzx) * (c0.zzzx) + (c0.wwwz);
        r3 = (r3) * (c0.zzzx);
        r4 = (r3) + (c4.xxyy);
        r4 = tex2Dlod(s1, r4);
        r5 = (r3) + (c4.zzww);
        r5 = tex2Dlod(s1, r5);
        r6 = (r3) + (c12.xyzz);
        r6 = tex2Dlod(s1, r6);
        r3 = (r3) + (-(c12.xyzz));
        r3 = tex2Dlod(s1, r3);
        r4.y = r5.x;
        r4.z = r6.x;
        r4.w = r3.x;
        r0.w = dot(r4, c0.yyyy);
        if ((c1.w) < (v5.w))
        {
            r3.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v5.zx) * (c0.zx) + (c0.wz);
            r3 = (r3) * (c0.zzzx);
            r4 = (r3) + (c4.xxyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (c4.zzww);
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c12.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c12.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.w = dot(r4, c0.yyyy);
            r3.x = (v5.w) * (c3.x) + (c3.y);
            r4.x = lerp(r0.w, r2.w, r3.x);
            r0.w = r4.x;
        }
    }
    else
    {
        r2.w = (c12.w) + (v5.w);
        r2.w = ((r2.w) >= 0.0f ? (c0.x) : (c0.z));
        if ((r2.w) != (-(r2.w)))
        {
            r3.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v5.zz) * (c0.zx) + (c0.wz);
            r3 = (r3) * (c0.zzzx);
            r4 = (r3) + (c4.xxyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (c4.zzww);
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c12.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c12.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.w = dot(r4, c0.yyyy);
            r3.x = saturate((-(c1.y)) + (v5.w));
            r0.w = lerp(r2.w, r1.w, r3.x);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    r3.xyz = (r0.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r3.xyz = (r3.xyz) * (c[35].yyy);
    r5.xyz = normalize(v1.xyz);
    r0.w = dot(-(r4.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r6.xyz = (r0.xyz) * (-(r0.www)) + (-(r4.xyz));
    r0.w = dot(r4.xyz, r5.xyz);
    r0.w = saturate((r0.w) * (c1.z) + (c1.z));
    r1.w = (r0.w) * (c3.z) + (c3.w);
    r0.w = (r0.w) + (c0.z);
    r2.w = saturate(dot(r6.xyz, -(r5.xyz)));
    r3.w = pow(abs(r2.w), r1.w);
    r3.xyz = (r3.xyz) * (r3.www);
    r2.w = dot(-(r2.xyz), r0.xyz);
    r2.w = (r2.w) + (r2.w);
    r4.xyz = (r0.xyz) * (-(r2.www)) + (-(r2.xyz));
    r2.x = dot(r2.xyz, r5.xyz);
    r2.x = saturate((r2.x) * (c1.z) + (c1.z));
    r3.w = lerp(r1.w, -(c1.x), r2.x);
    r1.w = lerp(r0.w, -(c1.x), r2.x);
    r2.x = saturate(dot(r4.xyz, -(r5.xyz)));
    r4.x = pow(abs(r2.x), r3.w);
    r1.xyz = (r1.xyz) * (r4.xxx);
    r1.xyz = (r1.www) * (r1.xyz);
    r1.xyz = (r3.xyz) * (r0.www) + (r1.xyz);
    r0.w = dot(r5.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r0.xyz) * (-(r0.www)) + (r5.xyz);
    r2 = texCUBE(s15, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c14.xxx);
    r3 = tex3D(s11, v4.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (c[42].xxx);
    r2.xyz = (r2.xyz) * (c14.yyy);
    r1.xyz = (r1.xyz) * (c13.xyz) + (r2.xyz);
    r0.w = c[37].w;
    r1.w = (r0.w) * (c14.z);
    r1.w = frac(r1.w);
    r1.w = (r0.w) * (c14.z) + (-(r1.w));
    r2.y = (r1.w) * (c14.w) + (v3.y);
    r2.x = c13.w;
    r2 = tex2D(s5, r2.xy);
    r1.w = (r2.x) * (-(c15.x)) + (v3.x);
    r1.w = (r1.w) * (c15.y) + (-(v3.x));
    r2.x = (c[45].x) * (r1.w) + (v3.x);
    r1.w = frac(abs(v3.y));
    r2.y = ((v3.y) >= 0.0f ? (r1.w) : (-(r1.w)));
    r1.w = ((r2.x) >= 0.0f ? (c0.x) : (c0.z));
    r2.z = (-(r2.x)) + (c0.z);
    r2.z = ((r2.z) >= 0.0f ? (c0.x) : (c0.z));
    r1.w = (r1.w) + (r2.z);
    r2.x = saturate(r2.x);
    r2 = tex2D(s6, r2.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = float3(((-(r1.w)) >= 0.0f ? (r2.x) : (c0.x)), ((-(r1.w)) >= 0.0f ? (r2.y) : (c0.x)), ((-(r1.w)) >= 0.0f ? (r2.z) : (c0.x)));
    r1.w = abs(c[37].w);
    r1.w = frac(r1.w);
    r3.y = ((c[37].w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r3.x = c0.x;
    r3 = tex2D(s5, r3.xy);
    r1.w = saturate((r3.x) * (c[43].x));
    r3.x = 1.0f / (c[44].x);
    r3.y = 1.0f / (c[44].y);
    r2.w = dot(r0.wwww, c16);
    r4.x = frac(r2.w);
    r4.w = c[37].w;
    r2.w = dot(r4.xwww, c16);
    r4.y = frac(r2.w);
    r2.w = dot(r4.xyww, c16);
    r4.z = frac(r2.w);
    r2.w = dot(r4, c16);
    r4.w = frac(r2.w);
    r2.w = dot(r4, c16);
    r4.x = frac(r2.w);
    r2.w = dot(r4, c16);
    r4.y = frac(r2.w);
    r3.xy = (v3.xy) * (r3.xy) + (r4.xy);
    r3 = tex2D(s4, r3.xy);
    r4.xyz = lerp(r2.xyz, r3.xyz, r1.www);
    r1.w = (c[50].x) + (-(v3.y));
    r1.w = (r1.w) + (c0.z);
    r0.w = (r0.w) * (c[46].x);
    r2.x = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r2.x) : (-(r2.x)));
    r0.w = (r1.w) + (r0.w);
    r1.w = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r1.w = pow(abs(r0.w), c[49].x);
    r2.z = c0.z;
    r0.w = (r1.w) * (-(c[48].x)) + (r2.z);
    r2.xyw = lerp(c[47].xyz, r4.xyz, r0.www);
    r1.xyz = (r1.xyz) + (r2.xyw);
    r3 = (c[6]) + (-(v1.xxxx));
    r4 = (c[7]) + (-(v1.yyyy));
    r5 = (c[8]) + (-(v1.zzzz));
    r6 = (r4) * (r4);
    r6 = (r3) * (r3) + (r6);
    r6 = (r5) * (r5) + (r6);
    r7.x = rsqrt(r6.x);
    r7.y = rsqrt(r6.y);
    r7.z = rsqrt(r6.z);
    r7.w = rsqrt(r6.w);
    r3 = (r3) * (r7);
    r4 = (r4) * (r7);
    r5 = (r5) * (r7);
    r2 = saturate((r6) * (c[9]) + (r2.zzzz));
    r4 = (r0.yyyy) * (r4);
    r3 = (r3) * (r0.xxxx) + (r4);
    r0 = saturate((r5) * (r0.zzzz) + (r3));
    r0 = (r2) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = c0.z;
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
    oC0.w = c0.z;

    return oC0;
}
