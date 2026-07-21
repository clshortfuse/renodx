// Mechanically reconstructed from 0x9B72E0A0.ps_3_0.cso.
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
    const float4 c1 = float4(-2.0f, 3.0f, 0.0f, 0.25f);
    const float4 c2 = float4(9.99999975e-06f, 1e-15f, 1.0f, 1.44269502f);
    const float4 c3 = float4(0.100000001f, 1.0f, 0.0f, 8.0f);
    const float4 c4 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c12 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (c[6].xyz) + (-(v1.xyz));
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r1.x = 1.0f / (r0.w);
    r0.xyz = (r0.xyz) * (r0.www);
    r1.y = (r1.x) * (r1.x);
    r0.w = dot(c[20].yz, r1.xy) + (c[20].x);
    r1.xy = saturate((r1.xx) * (c[21].xy) + (c[21].zw));
    r1.zw = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c1.xx) + (c1.yy);
    r1.xy = (r1.zw) * (r1.xy);
    r0.w = (r0.w) * (r1.x);
    r0.w = (r1.y) * (r0.w);
    r1.xy = (c[22].xy) * (v5.ww);
    r1.zw = c1.zz;
    r2 = (r1.xyww) + (v5);
    r1 = (-(r1)) + (v5);
    r1 = tex2Dproj(s1, r1);
    r1.y = r1.x;
    r2 = tex2Dproj(s1, r2);
    r1.x = r2.x;
    r2.xy = (c[22].zw) * (v5.ww);
    r2.zw = c1.zz;
    r3 = (r2.xyww) + (v5);
    r2 = (-(r2)) + (v5);
    r2 = tex2Dproj(s1, r2);
    r1.w = r2.x;
    r2 = tex2Dproj(s1, r3);
    r1.z = r2.x;
    r1.x = dot(r1, c1.wwww);
    r1.y = dot(r0.xyz, c[10].xyz);
    r1.y = saturate((r1.y) * (c[11].x) + (c[11].y));
    r1.y = (r1.y) * (c[11].w);
    r2.xyz = normalize(v2.xyz);
    r1.z = max(abs(r2.y), abs(r2.z));
    r3.x = max(abs(r2.x), r1.z);
    r1.z = 1.0f / (r3.x);
    r3.xyz = (r2.xyz) * (c[5].xyz);
    r3.xyz = (r3.xyz) * (r1.zzz) + (v4.xyz);
    r3 = tex3D(s11, r3.xyz);
    r2.w = lerp(r3.w, r1.x, r1.y);
    r1.xyz = (r3.xyz) * (r3.xyz);
    r0.w = (r0.w) * (r2.w);
    r3.xyz = (r0.www) * (c[8].xyz);
    r4.xyz = (r0.www) * (c[7].xyz);
    r4.xyz = (r4.xyz) * (c[9].xxx);
    r3.xyz = (r3.xyz) * (c[9].yyy);
    r0.w = dot(-(v1.xyz), -(v1.xyz));
    r0.w = rsqrt(r0.w);
    r5.xyz = (-(v1.xyz)) * (r0.www) + (r0.xyz);
    r0.x = saturate(dot(r2.xyz, r0.xyz));
    r0.yzw = (r0.www) * (-(v1.xyz));
    r0.y = saturate(dot(r2.xyz, r0.yzw));
    r6.xyz = normalize(r5.xyz);
    r0.z = saturate(dot(r2.xyz, r6.xyz));
    r0.w = (r0.z) + (r0.z);
    r0.z = (r0.z) * (r0.z) + (c2.y);
    r0.z = 1.0f / (r0.z);
    r1.w = 1.0f / (r0.y);
    r0.w = (r0.w) * (r1.w);
    r1.w = min(r0.y, r0.x);
    r2.x = max(c3.x, r0.y);
    r0.y = 1.0f / (r2.x);
    r0.y = rsqrt(r0.y);
    r0.y = 1.0f / (r0.y);
    r0.w = saturate((r0.w) * (r1.w));
    r0.w = (r0.x) * (r0.w);
    r2.xyz = (r4.xyz) * (r0.xxx);
    r1.xyz = (r1.xyz) * (c0.www) + (r2.xyz);
    r0.x = rsqrt(r0.w);
    r0.x = 1.0f / (r0.x);
    r0.w = (r0.z) * (r0.z);
    r0.z = (-(r0.z)) + (c2.z);
    r2 = tex2D(s7, v3.xy);
    r1.w = (r2.x) * (r2.x);
    r2.x = max(c2.x, r1.w);
    r1.w = (r2.x) * (r2.x);
    r1.w = 1.0f / (r1.w);
    r0.z = (r0.z) * (r1.w);
    r0.z = (r0.z) * (c2.w);
    r0.z = exp2(r0.z);
    r0.z = (r0.w) * (r0.z);
    r0.x = (r0.x) * (r0.z);
    r0.xzw = (r3.xyz) * (r0.xxx);
    r0.xyz = (r0.yyy) * (r0.xzw);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.www);
    r2 = tex2D(s5, v3.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r2.xy = lerp(c[24].xy, c[24].zw, v3.xy);
    r3 = tex2D(s3, r2.xy);
    r3.y = r3.x;
    r4 = tex2D(s4, r2.xy);
    r2 = tex2D(s2, r2.xy);
    r3.xw = (r2.xx) * (c3.yz) + (c3.zy);
    r3.z = r4.x;
    r2.y = dot(c4, r3);
    r2.x = dot(c0.xyz, r3.xyw);
    r2.z = dot(c12.xyz, r3.xzw);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[26].xxx);
    r3 = tex2D(s6, v3.xy);
    r4 = (r3) * (r3);
    r3.w = (r3.w) * (-(r3.w)) + (c[27].x);
    r3.xyz = (r2.xyz) * (c3.www) + (-(r4.xyz));
    r2 = (c[23].xxxx) * (r3) + (r4);
    r0.xyz = (r0.xyz) * (r2.www);
    r2.xyz = (r1.xyz) * (r2.xyz) + (r0.xyz);
    r0 = max(r2, c1.zzzz);
    oC0.w = r0.w;
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[25].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);

    return oC0;
}
