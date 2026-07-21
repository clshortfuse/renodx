// Mechanically reconstructed from 0xFE2D8074.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(8.0f, 1.0f, 0.5f, 31.875f);
    const float4 c1 = float4(0.0f, 0.25f, 1.0f, -0.0f);
    const float4 c3 = float4(-2.0f, 3.0f, 0.5f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -28.0f, 30.0f);
    const float4 c12 = float4(0.000244140625f, 0.0f, -0.000244140625f, -0.0f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
    const float4 c14 = float4(0.38647899f, 0.392856985f, 0.364796013f, 0.782500029f);
    const float4 c15 = float4(4.0f, 2.0f, 15.0f, 0.0399999991f);
    const float4 c16 = float4(0.00749999983f, 1.00750005f, 0.0f, 0.0f);
    const float4 c18 = float4(81.2394867f, 17.3480244f, 37.3498383f, 59.3948402f);
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
    r1 = (c[31]) * (v1.yyyy);
    r1 = (v1.xxxx) * (c[30]) + (r1);
    r1 = (v1.zzzz) * (c[32]) + (r1);
    r1 = (r1) + (c[33]);
    r2.xy = (r1.ww) * (c[35].xy);
    r2.zw = c1.xx;
    r3 = (r1) + (r2.xyww);
    r3 = tex2Dproj(s2, r3);
    r2 = (r1) + (-(r2));
    r2 = tex2Dproj(s2, r2);
    r4.xy = (r1.ww) * (c[35].zw);
    r4.zw = c1.xx;
    r5 = (r1) + (r4.xyww);
    r5 = tex2Dproj(s2, r5);
    r1 = (r1) + (-(r4));
    r1 = tex2Dproj(s2, r1);
    r3.y = r2.x;
    r3.z = r5.x;
    r3.w = r1.x;
    r0.w = dot(r3, c1.yyyy);
    r1.xyz = (c[20].xyz) + (-(v1.xyz));
    r2.xyz = normalize(r1.xyz);
    r1 = (v1.xyzx) * (c1.zzzx) + (c1.wwwz);
    r3.x = dot(r1, c[24]);
    r3.y = dot(r1, c[25]);
    r3.z = dot(r1, c[26]);
    r1.x = dot(r1, c[27]);
    r3.w = (r3.z) * (r3.z);
    r1.y = dot(c[22].yz, r3.zw) + (c[22].x);
    r1.z = saturate(1.0f / (r1.y));
    r1.y = ((-abs(r1.y)) >= 0.0f ? (c1.x) : (r1.z));
    r1.zw = saturate((r3.zz) * (c[23].xy) + (c[23].zw));
    r3.zw = (r1.zw) * (r1.zw);
    r1.zw = (r1.zw) * (c3.xx) + (c3.yy);
    r1.z = (r3.z) * (r1.z);
    r1.y = (r1.y) * (r1.z);
    r1.z = (r3.w) * (-(r1.w)) + (c1.z);
    r1.y = (r1.y) * (r1.z);
    r1.z = dot(r2.xyz, c[28].xyz);
    r1.z = saturate((r1.z) * (c[29].x) + (c[29].y));
    r1.w = (r1.z) * (r1.z);
    r1.z = (r1.z) * (c3.x) + (c3.y);
    r1.z = (r1.w) * (r1.z);
    r1.y = (r1.y) * (r1.z);
    r1.x = 1.0f / (r1.x);
    r1.xz = (r3.xy) * (r1.xx);
    r1.xz = (r1.xz) * (c3.zz) + (c3.zz);
    r3 = tex2D(s3, r1.xz);
    r1.x = (r3.x) * (r3.x);
    r1.x = (r1.y) * (r1.x);
    r0.w = (r0.w) * (r1.x);
    r1.xyz = (r0.www) * (c[21].xyz);
    if ((c1.z) >= (v4.w))
    {
        r3 = (v4.xyzx) * (c1.zzzx) + (c1.wwwz);
        r3 = (r3) * (c1.zzzx);
        r4 = (r3) + (c12.xxyy);
        r4 = tex2Dlod(s1, r4);
        r5 = (r3) + (c12.zzww);
        r5 = tex2Dlod(s1, r5);
        r6 = (r3) + (c13.xyzz);
        r6 = tex2Dlod(s1, r6);
        r3 = (r3) + (-(c13.xyzz));
        r3 = tex2Dlod(s1, r3);
        r4.y = r5.x;
        r4.z = r6.x;
        r4.w = r3.x;
        r0.w = dot(r4, c1.yyyy);
        if ((c3.w) < (v4.w))
        {
            r3.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v4.zx) * (c1.zx) + (c1.wz);
            r3 = (r3) * (c1.zzzx);
            r4 = (r3) + (c12.xxyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (c12.zzww);
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c13.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c13.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r1.w = dot(r4, c1.yyyy);
            r2.w = (v4.w) * (c4.x) + (c4.y);
            r3.x = lerp(r0.w, r1.w, r2.w);
            r0.w = r3.x;
        }
    }
    else
    {
        r3 = tex2D(s12, v3.zw);
        r1.w = (c13.w) + (v4.w);
        r1.w = ((r1.w) >= 0.0f ? (c1.x) : (c1.z));
        if ((r1.w) != (-(r1.w)))
        {
            r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r4.zw = (v4.zz) * (c1.zx) + (c1.wz);
            r4 = (r4) * (c1.zzzx);
            r5 = (r4) + (c12.xxyy);
            r5 = tex2Dlod(s1, r5);
            r6 = (r4) + (c12.zzww);
            r6 = tex2Dlod(s1, r6);
            r7 = (r4) + (c13.xyzz);
            r7 = tex2Dlod(s1, r7);
            r4 = (r4) + (-(c13.xyzz));
            r4 = tex2Dlod(s1, r4);
            r5.y = r6.x;
            r5.z = r7.x;
            r5.w = r4.x;
            r1.w = dot(r5, c1.yyyy);
            r2.w = saturate((-(c3.y)) + (v4.w));
            r0.w = lerp(r1.w, r3.y, r2.w);
        }
        else
        {
            r0.w = r3.y;
        }
    }
    r3.xyz = (r0.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r3.xyz = (r3.xyz) * (c[34].yyy);
    r5.xyz = normalize(v1.xyz);
    r0.w = dot(-(r4.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r6.xyz = (r0.xyz) * (-(r0.www)) + (-(r4.xyz));
    r0.w = dot(r4.xyz, r5.xyz);
    r0.w = saturate((r0.w) * (c3.z) + (c3.z));
    r1.w = (r0.w) * (c4.z) + (c4.w);
    r0.w = (r0.w) + (c1.z);
    r2.w = saturate(dot(r6.xyz, -(r5.xyz)));
    r3.w = pow(abs(r2.w), r1.w);
    r3.xyz = (r3.xyz) * (r3.www);
    r2.w = dot(-(r2.xyz), r0.xyz);
    r2.w = (r2.w) + (r2.w);
    r4.xyz = (r0.xyz) * (-(r2.www)) + (-(r2.xyz));
    r2.x = dot(r2.xyz, r5.xyz);
    r2.x = saturate((r2.x) * (c3.z) + (c3.z));
    r3.w = lerp(r1.w, -(c3.x), r2.x);
    r1.w = lerp(r0.w, -(c3.x), r2.x);
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
    r2.xyz = (r2.xyz) * (c0.xxx);
    r3 = tex2D(s14, v3.zw);
    r3.yz = (c0.yz) * (v3.zw);
    r4 = tex2D(s13, r3.yz);
    r0.w = (r3.x) * (c0.w);
    r3.yz = (r4.xz) * (r0.ww);
    r2.xw = (r2.xz) * (r3.yz);
    r1.w = (r3.x) * (c0.w) + (-(r3.y));
    r0.w = (r4.z) * (-(r0.w)) + (r1.w);
    r2.z = (r2.y) * (r0.w);
    r2.xyz = (r2.xzw) * (c[41].xxx);
    r2.xyz = (r2.xyz) * (c15.xyx);
    r1.xyz = (r1.xyz) * (c14.xyz) + (r2.xyz);
    r0.w = c[36].w;
    r1.w = (r0.w) * (c15.z);
    r1.w = frac(r1.w);
    r1.w = (r0.w) * (c15.z) + (-(r1.w));
    r2.y = (r1.w) * (c15.w) + (v3.y);
    r2.x = c14.w;
    r2 = tex2D(s5, r2.xy);
    r1.w = (r2.x) * (-(c16.x)) + (v3.x);
    r1.w = (r1.w) * (c16.y) + (-(v3.x));
    r2.x = (c[44].x) * (r1.w) + (v3.x);
    r1.w = frac(abs(v3.y));
    r2.y = ((v3.y) >= 0.0f ? (r1.w) : (-(r1.w)));
    r1.w = ((r2.x) >= 0.0f ? (c1.x) : (c1.z));
    r2.z = (-(r2.x)) + (c1.z);
    r2.z = ((r2.z) >= 0.0f ? (c1.x) : (c1.z));
    r1.w = (r1.w) + (r2.z);
    r2.x = saturate(r2.x);
    r2 = tex2D(s6, r2.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = float3(((-(r1.w)) >= 0.0f ? (r2.x) : (c1.x)), ((-(r1.w)) >= 0.0f ? (r2.y) : (c1.x)), ((-(r1.w)) >= 0.0f ? (r2.z) : (c1.x)));
    r1.w = abs(c[36].w);
    r1.w = frac(r1.w);
    r3.y = ((c[36].w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r3.x = c1.x;
    r3 = tex2D(s5, r3.xy);
    r1.w = saturate((r3.x) * (c[42].x));
    r3.x = 1.0f / (c[43].x);
    r3.y = 1.0f / (c[43].y);
    r2.w = dot(r0.wwww, c18);
    r4.x = frac(r2.w);
    r4.w = c[36].w;
    r2.w = dot(r4.xwww, c18);
    r4.y = frac(r2.w);
    r2.w = dot(r4.xyww, c18);
    r4.z = frac(r2.w);
    r2.w = dot(r4, c18);
    r4.w = frac(r2.w);
    r2.w = dot(r4, c18);
    r4.x = frac(r2.w);
    r2.w = dot(r4, c18);
    r4.y = frac(r2.w);
    r3.xy = (v3.xy) * (r3.xy) + (r4.xy);
    r3 = tex2D(s4, r3.xy);
    r4.xyz = lerp(r2.xyz, r3.xyz, r1.www);
    r1.w = (c[49].x) + (-(v3.y));
    r1.w = (r1.w) + (c1.z);
    r0.w = (r0.w) * (c[45].x);
    r2.x = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r2.x) : (-(r2.x)));
    r0.w = (r1.w) + (r0.w);
    r1.w = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r1.w = pow(abs(r0.w), c[48].x);
    r2.z = c1.z;
    r0.w = (r1.w) * (-(c[47].x)) + (r2.z);
    r2.xyw = lerp(c[46].xyz, r4.xyz, r0.www);
    r1.xyz = (r1.xyz) + (r2.xyw);
    r3 = (c[5]) + (-(v1.xxxx));
    r4 = (c[6]) + (-(v1.yyyy));
    r5 = (c[7]) + (-(v1.zzzz));
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
    r2 = saturate((r6) * (c[8]) + (r2.zzzz));
    r4 = (r0.yyyy) * (r4);
    r3 = (r3) * (r0.xxxx) + (r4);
    r0 = saturate((r5) * (r0.zzzz) + (r3));
    r0 = (r2) * (r0);
    r2.x = dot(c[9], r0);
    r2.y = dot(c[10], r0);
    r2.z = dot(c[11], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = c1.z;
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
    oC0.w = c1.z;

    return oC0;
}
