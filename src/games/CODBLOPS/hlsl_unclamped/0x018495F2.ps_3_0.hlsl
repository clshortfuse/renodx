// Mechanically reconstructed from 0x018495F2.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(1.0f, 0.0f, 8.0f, 31.875f);
    const float4 c1 = float4(-2.0f, 3.0f, 9.99999975e-06f, 1e-15f);
    const float4 c2 = float4(1.0f, 1.44269502f, 0.100000001f, 0.25f);
    const float4 c3 = float4(1.16412354f, 1.59579468f, -0.87065506f, 0.0f);
    const float4 c4 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c12 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (c[6].xyz) + (-(v1.xyz));
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = (r0.xyz) * (r0.www);
    r1.x = 1.0f / (r0.w);
    r0.w = dot(-(v1.xyz), -(v1.xyz));
    r0.w = rsqrt(r0.w);
    r2.xyz = (-(v1.xyz)) * (r0.www) + (r0.xyz);
    r3.xyz = (r0.www) * (-(v1.xyz));
    r4.xyz = normalize(r2.xyz);
    r2.xyz = normalize(v2.xyz);
    r0.w = saturate(dot(r2.xyz, r4.xyz));
    r1.z = (r0.w) + (r0.w);
    r0.w = (r0.w) * (r0.w) + (c1.w);
    r0.w = 1.0f / (r0.w);
    r1.w = saturate(dot(r2.xyz, r3.xyz));
    r2.w = 1.0f / (r1.w);
    r1.z = (r1.z) * (r2.w);
    r0.x = saturate(dot(r2.xyz, r0.xyz));
    r2.w = min(r1.w, r0.x);
    r0.y = max(c2.z, r1.w);
    r0.y = 1.0f / (r0.y);
    r0.y = rsqrt(r0.y);
    r0.y = 1.0f / (r0.y);
    r0.z = saturate((r1.z) * (r2.w));
    r0.z = (r0.x) * (r0.z);
    r0.z = rsqrt(r0.z);
    r0.z = 1.0f / (r0.z);
    r1.z = (-(r0.w)) + (c2.x);
    r0.w = (r0.w) * (r0.w);
    r3 = tex2D(s6, v3.xy);
    r1.w = (r3.x) * (r3.x);
    r2.w = max(c1.z, r1.w);
    r1.w = (r2.w) * (r2.w);
    r1.w = 1.0f / (r1.w);
    r1.z = (r1.z) * (r1.w);
    r1.z = (r1.z) * (c2.y);
    r1.z = exp2(r1.z);
    r0.w = (r0.w) * (r1.z);
    r0.z = (r0.z) * (r0.w);
    r1.y = (r1.x) * (r1.x);
    r0.w = dot(c[10].yz, r1.xy) + (c[10].x);
    r1.xy = saturate((r1.xx) * (c[11].xy) + (c[11].zw));
    r3.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c1.xx) + (c1.yy);
    r1.xy = (r3.xy) * (r1.xy);
    r0.w = (r0.w) * (r1.x);
    r0.w = (r1.y) * (r0.w);
    r1.x = max(abs(r2.y), abs(r2.z));
    r3.x = max(abs(r2.x), r1.x);
    r1.xyz = (r2.xyz) * (c[5].xyz);
    r2.x = 1.0f / (r3.x);
    r1.xyz = (r1.xyz) * (r2.xxx) + (v4.xyz);
    r2 = tex3D(s11, r1.xyz);
    r0.w = (r0.w) * (r2.w);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r0.www) * (c[8].xyz);
    r3.xyz = (r0.www) * (c[7].xyz);
    r3.xyz = (r3.xyz) * (c[9].xxx);
    r3.xyz = (r0.xxx) * (r3.xyz);
    r1.xyz = (r1.xyz) * (c0.www) + (r3.xyz);
    r2.xyz = (r2.xyz) * (c[9].yyy);
    r0.xzw = (r0.zzz) * (r2.xyz);
    r0.xyz = (r0.yyy) * (r0.xzw);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.www);
    r2 = tex2D(s4, v3.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r2.xy = lerp(c[21].xy, c[21].zw, v3.xy);
    r3 = tex2D(s2, r2.xy);
    r3.y = r3.x;
    r4 = tex2D(s3, r2.xy);
    r2 = tex2D(s1, r2.xy);
    r3.xw = (r2.xx) * (c0.xy) + (c0.yx);
    r3.z = r4.x;
    r2.y = dot(c4, r3);
    r2.x = dot(c3.xyz, r3.xyw);
    r2.z = dot(c12.xyz, r3.xzw);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[23].xxx);
    r3 = tex2D(s5, v3.xy);
    r4 = (r3) * (r3);
    r3.w = (r3.w) * (-(r3.w)) + (c[24].x);
    r3.xyz = (r2.xyz) * (c0.zzz) + (-(r4.xyz));
    r2 = (c[20].xxxx) * (r3) + (r4);
    r0.xyz = (r0.xyz) * (r2.www);
    r2.xyz = (r1.xyz) * (r2.xyz) + (r0.xyz);
    r0 = max(r2, c0.yyyy);
    oC0.w = r0.w;
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);

    return oC0;
}
