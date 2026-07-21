// Mechanically reconstructed from 0xBD26E898.ps_3_0.cso.
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
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(1.16412354f, 2.01782227f, -1.08166885f, 31.875f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.5f, 1.0f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(-101.222f, 103.222f, 1.0f, 0.0f);
    const float4 c4 = float4(1.16412354f, 1.59579468f, -0.87065506f, 8.0f);
    const float4 c12 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = lerp(c[28].xy, c[28].zw, v4.xy);
    r1 = tex2D(s2, r0.xy);
    r1.y = r1.x;
    r2 = tex2D(s3, r0.xy);
    r0 = tex2D(s1, r0.xy);
    r1.xw = (r0.xx) * (c3.zw) + (c3.wz);
    r1.z = r2.x;
    r0.y = dot(c12, r1);
    r0.x = dot(c4.xyz, r1.xyw);
    r0.z = dot(c0.xyz, r1.xzw);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c4.www);
    r1 = tex2D(s5, v4.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.zw = c1.zw;
    r0.w = (-(r2.z)) + (c[27].x);
    r0.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (r1.x)), ((r0.w) >= 0.0f ? (r0.y) : (r1.y)), ((r0.w) >= 0.0f ? (r0.z) : (r1.z)));
    r1.xyz = (c[21].xyz) + (-(v1.xyz));
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r2.x = 1.0f / (r0.w);
    r1.xyz = (r1.xyz) * (r0.www);
    r2.y = (r2.x) * (r2.x);
    r0.w = dot(c[25].yz, r2.xy) + (c[25].x);
    r2.xy = saturate((r2.xx) * (c[26].xy) + (c[26].zw));
    r3.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c1.xx) + (c1.yy);
    r2.xy = (r3.xy) * (r2.xy);
    r0.w = (r0.w) * (r2.x);
    r0.w = (r2.y) * (r0.w);
    r1.w = dot(v2.xyz, v2.xyz);
    r1.w = rsqrt(r1.w);
    r2.xyz = (r1.www) * (v2.xyz);
    r3.x = max(abs(r2.y), abs(r2.z));
    r4.x = max(abs(r2.x), r3.x);
    r3.x = 1.0f / (r4.x);
    r3.yzw = (r2.xyz) * (c[5].xyz);
    r3.xyz = (r3.yzw) * (r3.xxx) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r0.w = (r0.w) * (r3.w);
    r3.xyz = (r0.www) * (c[23].xyz);
    r4.xyz = (r0.www) * (c[22].xyz);
    r4.xyz = (r4.xyz) * (c[24].xxx);
    r3.xyz = (r3.xyz) * (c[24].yyy);
    r5 = tex2D(s4, v4.xy);
    r5.xy = (r5.wy) * (c2.xy) + (c2.zw);
    r5.xy = (r5.xy) * (c1.zz) + (c1.zz);
    r5.xy = (r5.xy) * (-(c1.xx)) + (-(c1.ww));
    r6.xyz = (r2.zxy) * (v3.yzx);
    r6.xyz = (r2.yzx) * (v3.zxy) + (-(r6.xyz));
    r6.xyz = (r6.xyz) * (v3.www);
    r5.yzw = (r5.yyy) * (r6.xyz);
    r5.xyz = (r5.xxx) * (v3.xyz) + (r5.yzw);
    r5.xyz = (v2.xyz) * (r1.www) + (r5.xyz);
    r6.xyz = normalize(r5.xyz);
    r0.w = dot(-(r1.xyz), r6.xyz);
    r0.w = (r0.w) + (r0.w);
    r5.xyz = (r6.xyz) * (-(r0.www)) + (-(r1.xyz));
    r7.xyz = normalize(v1.xyz);
    r0.w = saturate(dot(r5.xyz, -(r7.xyz)));
    r1.w = dot(r1.xyz, r7.xyz);
    r1.x = saturate(dot(r6.xyz, r1.xyz));
    r1.xyz = (r4.xyz) * (r1.xxx);
    r1.w = saturate((r1.w) * (c1.z) + (c1.z));
    r3.w = (r1.w) * (c3.x) + (c3.y);
    r1.w = (r1.w) + (c1.w);
    r4.x = pow(abs(r0.w), r3.w);
    r3.xyz = (r3.xyz) * (r4.xxx);
    r3.xyz = (r1.www) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c[30].xxx);
    r0.w = max(abs(r6.y), abs(r6.z));
    r1.w = max(abs(r6.x), r0.w);
    r4.xyz = (r6.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.w);
    r4.xyz = (r4.xyz) * (r0.www) + (v5.xyz);
    r4 = tex3D(s11, r4.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r1.xyz = (r4.xyz) * (c0.www) + (r1.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r3.xyz);
    r1.xyz = max(r0.xyz, c3.www);
    r0 = (c[7]) + (-(v1.yyyy));
    r3 = (r0) * (r0);
    r4 = (c[6]) + (-(v1.xxxx));
    r3 = (r4) * (r4) + (r3);
    r5 = (c[8]) + (-(v1.zzzz));
    r3 = (r5) * (r5) + (r3);
    r6.x = rsqrt(r3.x);
    r6.y = rsqrt(r3.y);
    r6.z = rsqrt(r3.z);
    r6.w = rsqrt(r3.w);
    r3 = saturate((r3) * (c[9]) + (r2.wwww));
    r0 = (r0) * (r6);
    r0 = (r2.yyyy) * (r0);
    r4 = (r4) * (r6);
    r5 = (r5) * (r6);
    r0 = (r4) * (r2.xxxx) + (r0);
    r0 = saturate((r5) * (r2.zzzz) + (r0));
    r0 = (r3) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c1.w;

    return oC0;
}
