// Mechanically reconstructed from 0x6B94D3F5.ps_3_0.cso.
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
    const float4 c0 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c1 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c3 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c4 = float4(0.5f, -28.0f, 30.0f, 8.0f);
    const float4 c12 = float4(12.0f, 9.0f, 15.0f, 4.0f);
    const float4 c13 = float4(0.38647899f, 0.392856985f, 0.364796013f, 31.875f);
    const float4 c14 = float4(11.0f, 2.0f, 0.0666666701f, 0.144999996f);
    const float4 c15 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0625f);
    const float4 c16 = float4(0.125f, 1.0f, 0.0133333337f, 0.219999999f);
    const float4 c18 = float4(0.240400001f, 1.24039996f, 0.015625f, 64.0f);
    const float4 c42 = float4(1.16412354f, 1.59579468f, -0.87065506f, 0.600000024f);
    const float4 c43 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c44 = float4(81.2394867f, 17.3480244f, 37.3498383f, 59.3948402f);
    const float4 c45 = float4(9.99999994e-09f, 0.0f, 0.0f, 0.0f);
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
    if ((c3.x) >= (v5.w))
    {
        r2 = (v5.xyzx) * (c3.xxxy) + (c3.zzzx);
        r2 = (r2) * (c3.xxxy);
        r3 = (r2) + (c3.wwyy);
        r3 = tex2Dlod(s1, r3);
        r4 = (r2) + (-(c3.wwyy));
        r4 = tex2Dlod(s1, r4);
        r5 = (r2) + (c0.xyzz);
        r5 = tex2Dlod(s1, r5);
        r2 = (r2) + (-(c0.xyzz));
        r2 = tex2Dlod(s1, r2);
        r3.y = r4.x;
        r3.z = r5.x;
        r3.w = r2.x;
        r0.w = dot(r3, c0.wwww);
        if ((c1.x) < (v5.w))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zx) * (c3.xy) + (c3.zx);
            r2 = (r2) * (c3.xxxy);
            r3 = (r2) + (c3.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c3.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c0.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c0.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r1.x = dot(r3, c0.wwww);
            r1.y = (v5.w) * (c1.y) + (c1.z);
            r2.x = lerp(r0.w, r1.x, r1.y);
            r0.w = r2.x;
        }
    }
    else
    {
        r1.x = (c1.w) + (v5.w);
        r1.x = ((r1.x) >= 0.0f ? (c3.y) : (c3.x));
        if ((r1.x) != (-(r1.x)))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zz) * (c3.xy) + (c3.zx);
            r2 = (r2) * (c3.xxxy);
            r3 = (r2) + (c3.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c3.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c0.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c0.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r1.x = dot(r3, c0.wwww);
            r1.y = saturate((c1.z) + (v5.w));
            r0.w = lerp(r1.x, r1.w, r1.y);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    r1.xyz = (r0.www) * (c[19].xyz);
    r2.xyz = normalize(c[17].xyz);
    r1.xyz = (r1.xyz) * (c[21].yyy);
    r3.xyz = normalize(v1.xyz);
    r0.w = dot(-(r2.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r4.xyz = (r0.xyz) * (-(r0.www)) + (-(r2.xyz));
    r0.w = dot(r2.xyz, r3.xyz);
    r0.w = saturate((r0.w) * (c4.x) + (c4.x));
    r1.w = (r0.w) * (c4.y) + (c4.z);
    r0.w = (r0.w) + (c3.x);
    r2.x = saturate(dot(r4.xyz, -(r3.xyz)));
    r3.w = pow(abs(r2.x), r1.w);
    r1.xyz = (r1.xyz) * (r3.www);
    r1.xyz = (r0.www) * (r1.xyz);
    r2.x = c[30].x;
    r4 = (-(r2.xxxx)) + (c12);
    r2.yzw = float3(((-abs(r4.x)) >= 0.0f ? (r1.x) : (c3.y)), ((-abs(r4.x)) >= 0.0f ? (r1.y) : (c3.y)), ((-abs(r4.x)) >= 0.0f ? (r1.z) : (c3.y)));
    r5.xyz = (r1.xyz) * (c13.xyz);
    r2.yzw = float3(((-abs(r4.y)) >= 0.0f ? (r5.x) : (r2.y)), ((-abs(r4.y)) >= 0.0f ? (r5.y) : (r2.z)), ((-abs(r4.y)) >= 0.0f ? (r5.z) : (r2.w)));
    r0.w = dot(r3.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r3.xyz = (r0.xyz) * (-(r0.www)) + (r3.xyz);
    r3 = texCUBE(s15, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c4.www);
    r5 = tex3D(s11, v4.xyz);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r3.xyz = (r3.xyz) * (r5.xyz);
    r3.xyz = (r3.xyz) * (c13.www);
    r2.yzw = float3(((-abs(r4.z)) >= 0.0f ? (r3.x) : (r2.y)), ((-abs(r4.z)) >= 0.0f ? (r3.y) : (r2.z)), ((-abs(r4.z)) >= 0.0f ? (r3.z) : (r2.w)));
    r3.xyz = (r3.xyz) * (c[31].xxx);
    r2.yzw = float3(((-abs(r4.w)) >= 0.0f ? (r3.x) : (r2.y)), ((-abs(r4.w)) >= 0.0f ? (r3.y) : (r2.z)), ((-abs(r4.w)) >= 0.0f ? (r3.z) : (r2.w)));
    r1.xyz = (r1.xyz) * (c13.xyz) + (r3.xyz);
    r3.xy = (-(r2.xx)) + (c14.xy);
    r2.xyz = float3(((-abs(r3.x)) >= 0.0f ? (r1.x) : (r2.y)), ((-abs(r3.x)) >= 0.0f ? (r1.y) : (r2.z)), ((-abs(r3.x)) >= 0.0f ? (r1.z) : (r2.w)));
    r0.w = c[22].w;
    r1.w = (r0.w) * (c12.z);
    r1.w = frac(r1.w);
    r1.w = (r0.w) * (c12.z) + (-(r1.w));
    r3.z = (r1.w) * (c14.z) + (v3.y);
    r3.x = c14.w;
    r4 = tex2D(s7, r3.xz);
    r2.w = (r4.x) * (-(c18.x)) + (v3.x);
    r2.w = (r2.w) * (c18.y) + (-(v3.x));
    r3.x = (c[34].x) * (r2.w) + (v3.x);
    r2.w = frac(abs(v3.y));
    r3.z = ((v3.y) >= 0.0f ? (r2.w) : (-(r2.w)));
    r2.w = ((r3.x) >= 0.0f ? (c3.y) : (c3.x));
    r3.w = (-(r3.x)) + (c3.x);
    r3.w = ((r3.w) >= 0.0f ? (c3.y) : (c3.x));
    r2.w = (r2.w) + (r3.w);
    r3.x = saturate(r3.x);
    r4.z = c18.z;
    r3.w = (r4.z) * (c[23].x);
    r3.w = frac(abs(r3.w));
    r3.w = ((c[23].x) >= 0.0f ? (r3.w) : (-(r3.w)));
    r3.w = (r3.w) * (c18.w);
    r4.x = frac(r3.w);
    r3.w = (r3.w) + (-(r4.x));
    r4.x = (r3.w) * (c16.x);
    r4.y = frac(abs(r4.x));
    r4.y = ((r3.w) >= 0.0f ? (r4.y) : (-(r4.y)));
    r3.w = frac(r4.x);
    r4.z = (r4.x) + (-(r3.w));
    r4.xy = (r4.yz) * (c16.yx);
    r4.xy = (r3.xz) * (c16.xx) + (r4.xy);
    r5 = tex2D(s3, r4.xy);
    r6 = tex2D(s4, r4.xy);
    r4 = tex2D(s5, r4.xy);
    r5.xw = (r5.xx) * (c3.xy) + (c3.zx);
    r5.y = r6.x;
    r4.y = dot(c42.xyz, r5.xyw);
    r5.z = r4.x;
    r4.z = dot(c43, r5);
    r4.w = dot(c15.xyz, r5.xzw);
    r4.xyz = (r4.yzw) * (c[40].xxx);
    r5.xy = lerp(c[24].xy, c[24].zw, r3.xz);
    r5 = tex2D(s2, r5.xy);
    r3.xzw = (r5.xyz) * (c[41].xxx);
    r5.x = c4.x;
    r4.w = (-(r5.x)) + (c[25].x);
    r3.xzw = float3(((r4.w) >= 0.0f ? (r3.x) : (r4.x)), ((r4.w) >= 0.0f ? (r3.z) : (r4.y)), ((r4.w) >= 0.0f ? (r3.w) : (r4.z)));
    r3.xzw = float3(((-(r2.w)) >= 0.0f ? (r3.x) : (c3.y)), ((-(r2.w)) >= 0.0f ? (r3.z) : (c3.y)), ((-(r2.w)) >= 0.0f ? (r3.w) : (c3.y)));
    r4.y = (r1.w) * (c16.z);
    r4.x = c16.w;
    r4 = tex2D(s7, r4.xy);
    r1.w = (-(r4.x)) + (c42.w);
    r1.w = ((r1.w) >= 0.0f ? (c3.x) : (c3.y));
    r1.w = (r1.w) * (c[34].x);
    r3.xzw = (r1.www) * (-(r3.xzw)) + (r3.xzw);
    r1.w = abs(c[22].w);
    r1.w = frac(r1.w);
    r4.y = ((c[22].w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r4.x = c15.w;
    r4 = tex2D(s7, r4.xy);
    r1.w = saturate((r4.x) * (c[32].x));
    r4.x = 1.0f / (c[33].x);
    r4.y = 1.0f / (c[33].y);
    r2.w = dot(r0.wwww, c44);
    r5.x = frac(r2.w);
    r5.w = c[22].w;
    r2.w = dot(r5.xwww, c44);
    r5.y = frac(r2.w);
    r2.w = dot(r5.xyww, c44);
    r5.z = frac(r2.w);
    r2.w = dot(r5, c44);
    r5.w = frac(r2.w);
    r2.w = dot(r5, c44);
    r5.x = frac(r2.w);
    r2.w = dot(r5, c44);
    r5.y = frac(r2.w);
    r4.xy = (v3.xy) * (r4.xy) + (r5.xy);
    r4 = tex2D(s6, r4.xy);
    r5.xyz = lerp(r3.xzw, r4.xyz, r1.www);
    r1.w = (c[39].x) + (-(v3.y));
    r1.w = (r1.w) + (c3.x);
    r0.w = (r0.w) * (c[35].x);
    r2.w = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r2.w) : (-(r2.w)));
    r0.w = (r1.w) + (r0.w);
    r1.w = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r1.w = pow(abs(r0.w), c[38].x);
    r3.x = c3.x;
    r0.w = (r1.w) * (-(c[37].x)) + (r3.x);
    r4.xyz = lerp(c[36].xyz, r5.xyz, r0.www);
    r2.xyz = float3(((-abs(r3.y)) >= 0.0f ? (r4.x) : (r2.x)), ((-abs(r3.y)) >= 0.0f ? (r4.y) : (r2.y)), ((-abs(r3.y)) >= 0.0f ? (r4.z) : (r2.z)));
    r1.xyz = (r1.xyz) + (r4.xyz);
    r0.w = abs(c[30].x);
    r2.xyz = float3(((-(r0.w)) >= 0.0f ? (r1.x) : (r2.x)), ((-(r0.w)) >= 0.0f ? (r1.y) : (r2.y)), ((-(r0.w)) >= 0.0f ? (r1.z) : (r2.z)));
    r4 = (c[6]) + (-(v1.xxxx));
    r5 = (c[7]) + (-(v1.yyyy));
    r6 = (c[8]) + (-(v1.zzzz));
    r7 = (r5) * (r5);
    r7 = (r4) * (r4) + (r7);
    r7 = (r6) * (r6) + (r7);
    r8.x = rsqrt(r7.x);
    r8.y = rsqrt(r7.y);
    r8.z = rsqrt(r7.z);
    r8.w = rsqrt(r7.w);
    r4 = (r4) * (r8);
    r5 = (r5) * (r8);
    r6 = (r6) * (r8);
    r3 = saturate((r7) * (c[9]) + (r3.xxxx));
    r5 = (r0.yyyy) * (r5);
    r4 = (r4) * (r0.xxxx) + (r5);
    r0 = saturate((r6) * (r0.zzzz) + (r4));
    r0 = (r3) * (r0);
    r3.x = dot(c[10], r0);
    r3.y = dot(c[11], r0);
    r3.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r3.xyz) + (r1.xyz);
    r1.xyz = (r0.xyz) * (c45.xxx) + (r2.xyz);
    r0.xyz = float3(((c[30].x) >= 0.0f ? (r1.x) : (r0.x)), ((c[30].x) >= 0.0f ? (r1.y) : (r0.y)), ((c[30].x) >= 0.0f ? (r1.z) : (r0.z)));
    r0.w = c3.x;
    r1.x = dot(r0, c[27]);
    r1.y = dot(r0, c[28]);
    r1.z = dot(r0, c[29]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[26].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.x;

    return oC0;
}
