// Mechanically reconstructed from 0x4DD53914.ps_3_0.cso.
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
    const float4 c0 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c1 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c3 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c4 = float4(0.5f, -28.0f, 30.0f, 8.0f);
    const float4 c12 = float4(12.0f, 9.0f, 15.0f, 4.0f);
    const float4 c13 = float4(0.38647899f, 0.392856985f, 0.364796013f, 31.875f);
    const float4 c14 = float4(11.0f, 2.0f, 0.0666666701f, 0.144999996f);
    const float4 c15 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0625f);
    const float4 c16 = float4(0.240400001f, 1.24039996f, 0.0133333337f, 0.219999999f);
    const float4 c18 = float4(1.16412354f, 1.59579468f, -0.87065506f, 0.600000024f);
    const float4 c32 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c33 = float4(81.2394867f, 17.3480244f, 37.3498383f, 59.3948402f);
    const float4 c34 = float4(9.99999994e-09f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
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
    r1.xyz = (r1.xyz) * (c[6].yyy);
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
    r2.x = c[21].x;
    r4 = (-(r2.xxxx)) + (c12);
    r2.yzw = float3(((-abs(r4.x)) >= 0.0f ? (r1.x) : (c3.y)), ((-abs(r4.x)) >= 0.0f ? (r1.y) : (c3.y)), ((-abs(r4.x)) >= 0.0f ? (r1.z) : (c3.y)));
    r5.xyz = (r1.xyz) * (c13.xyz);
    r2.yzw = float3(((-abs(r4.y)) >= 0.0f ? (r5.x) : (r2.y)), ((-abs(r4.y)) >= 0.0f ? (r5.y) : (r2.z)), ((-abs(r4.y)) >= 0.0f ? (r5.z) : (r2.w)));
    r0.w = dot(r3.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r0.xyz) * (-(r0.www)) + (r3.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c4.www);
    r3 = tex3D(s11, v4.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (c13.www);
    r2.yzw = float3(((-abs(r4.z)) >= 0.0f ? (r0.x) : (r2.y)), ((-abs(r4.z)) >= 0.0f ? (r0.y) : (r2.z)), ((-abs(r4.z)) >= 0.0f ? (r0.z) : (r2.w)));
    r0.xyz = (r0.xyz) * (c[22].xxx);
    r2.yzw = float3(((-abs(r4.w)) >= 0.0f ? (r0.x) : (r2.y)), ((-abs(r4.w)) >= 0.0f ? (r0.y) : (r2.z)), ((-abs(r4.w)) >= 0.0f ? (r0.z) : (r2.w)));
    r0.xyz = (r1.xyz) * (c13.xyz) + (r0.xyz);
    r1.xy = (-(r2.xx)) + (c14.xy);
    r1.xzw = float3(((-abs(r1.x)) >= 0.0f ? (r0.x) : (r2.y)), ((-abs(r1.x)) >= 0.0f ? (r0.y) : (r2.z)), ((-abs(r1.x)) >= 0.0f ? (r0.z) : (r2.w)));
    r0.w = c[7].w;
    r2.x = (r0.w) * (c12.z);
    r2.x = frac(r2.x);
    r2.x = (r0.w) * (c12.z) + (-(r2.x));
    r2.z = (r2.x) * (c14.z) + (v3.y);
    r2.y = c14.w;
    r3 = tex2D(s6, r2.yz);
    r2.y = (r3.x) * (-(c16.x)) + (v3.x);
    r2.y = (r2.y) * (c16.y) + (-(v3.x));
    r2.y = (c[25].x) * (r2.y) + (v3.x);
    r2.w = frac(abs(v3.y));
    r2.z = ((v3.y) >= 0.0f ? (r2.w) : (-(r2.w)));
    r2.w = ((r2.y) >= 0.0f ? (c3.y) : (c3.x));
    r3.x = (-(r2.y)) + (c3.x);
    r3.x = ((r3.x) >= 0.0f ? (c3.y) : (c3.x));
    r2.w = (r2.w) + (r3.x);
    r2.y = saturate(r2.y);
    r3.xy = lerp(c[8].xy, c[8].zw, r2.yz);
    r4 = tex2D(s2, r3.xy);
    r5 = tex2D(s3, r3.xy);
    r3 = tex2D(s4, r3.xy);
    r4.xw = (r4.xx) * (c3.xy) + (c3.zx);
    r4.y = r5.x;
    r3.y = dot(c18.xyz, r4.xyw);
    r4.z = r3.x;
    r3.z = dot(c32, r4);
    r3.w = dot(c15.xyz, r4.xzw);
    r3.xyz = (r3.yzw) * (c[31].xxx);
    r2.yzw = float3(((-(r2.w)) >= 0.0f ? (r3.x) : (c3.y)), ((-(r2.w)) >= 0.0f ? (r3.y) : (c3.y)), ((-(r2.w)) >= 0.0f ? (r3.z) : (c3.y)));
    r3.y = (r2.x) * (c16.z);
    r3.x = c16.w;
    r3 = tex2D(s6, r3.xy);
    r2.x = (-(r3.x)) + (c18.w);
    r2.x = ((r2.x) >= 0.0f ? (c3.x) : (c3.y));
    r2.x = (r2.x) * (c[25].x);
    r2.xyz = (r2.xxx) * (-(r2.yzw)) + (r2.yzw);
    r2.w = abs(c[7].w);
    r2.w = frac(r2.w);
    r3.y = ((c[7].w) >= 0.0f ? (r2.w) : (-(r2.w)));
    r3.x = c15.w;
    r3 = tex2D(s6, r3.xy);
    r2.w = saturate((r3.x) * (c[23].x));
    r3.x = 1.0f / (c[24].x);
    r3.y = 1.0f / (c[24].y);
    r3.z = dot(r0.wwww, c33);
    r4.x = frac(r3.z);
    r4.w = c[7].w;
    r3.z = dot(r4.xwww, c33);
    r4.y = frac(r3.z);
    r3.z = dot(r4.xyww, c33);
    r4.z = frac(r3.z);
    r3.z = dot(r4, c33);
    r4.w = frac(r3.z);
    r3.z = dot(r4, c33);
    r4.x = frac(r3.z);
    r3.z = dot(r4, c33);
    r4.y = frac(r3.z);
    r3.xy = (v3.xy) * (r3.xy) + (r4.xy);
    r3 = tex2D(s5, r3.xy);
    r4.xyz = lerp(r2.xyz, r3.xyz, r2.www);
    r2.x = (c[30].x) + (-(v3.y));
    r2.x = (r2.x) + (c3.x);
    r0.w = (r0.w) * (c[26].x);
    r2.y = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r2.y) : (-(r2.y)));
    r0.w = (r2.x) + (r0.w);
    r2.x = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r2.x) : (-(r2.x)));
    r2.x = pow(abs(r0.w), c[29].x);
    r3.x = c3.x;
    r0.w = (r2.x) * (-(c[28].x)) + (r3.x);
    r2.xyz = lerp(c[27].xyz, r4.xyz, r0.www);
    r1.xyz = float3(((-abs(r1.y)) >= 0.0f ? (r2.x) : (r1.x)), ((-abs(r1.y)) >= 0.0f ? (r2.y) : (r1.z)), ((-abs(r1.y)) >= 0.0f ? (r2.z) : (r1.w)));
    r0.xyz = (r0.xyz) + (r2.xyz);
    r0.w = abs(c[21].x);
    r1.xyz = float3(((-(r0.w)) >= 0.0f ? (r0.x) : (r1.x)), ((-(r0.w)) >= 0.0f ? (r0.y) : (r1.y)), ((-(r0.w)) >= 0.0f ? (r0.z) : (r1.z)));
    r1.xyz = (r0.xyz) * (c34.xxx) + (r1.xyz);
    r0.xyz = float3(((c[21].x) >= 0.0f ? (r1.x) : (r0.x)), ((c[21].x) >= 0.0f ? (r1.y) : (r0.y)), ((c[21].x) >= 0.0f ? (r1.z) : (r0.z)));
    r0.w = c3.x;
    r1.x = dot(r0, c[10]);
    r1.y = dot(r0, c[11]);
    r1.z = dot(r0, c[20]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.x;

    return oC0;
}
