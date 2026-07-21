// Mechanically reconstructed from 0x87326115.ps_3_0.cso.
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
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(0.5f, 2.0f, -1.0f, 1.0f);
    const float4 c3 = float4(-101.222f, 103.222f, 1.0f, 0.0f);
    const float4 c4 = float4(1.16412354f, 1.59579468f, -0.87065506f, 8.0f);
    const float4 c11 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = lerp(c[8].xy, c[8].zw, v4.xy);
    r1 = tex2D(s2, r0.xy);
    r1.y = r1.x;
    r2 = tex2D(s3, r0.xy);
    r0 = tex2D(s1, r0.xy);
    r1.xw = (r0.xx) * (c3.zw) + (c3.wz);
    r1.z = r2.x;
    r0.y = dot(c11, r1);
    r0.x = dot(c4.xyz, r1.xyw);
    r0.z = dot(c0.xyz, r1.xzw);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c4.www);
    r1 = tex2D(s5, v4.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.x = c2.x;
    r0.w = (-(r2.x)) + (c[7].x);
    r0.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (r1.x)), ((r0.w) >= 0.0f ? (r0.y) : (r1.y)), ((r0.w) >= 0.0f ? (r0.z) : (r1.z)));
    r1 = tex2D(s4, v4.xy);
    r1.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r1.xy = (r1.xy) * (c2.xx) + (c2.xx);
    r1.xy = (r1.xy) * (c2.yy) + (c2.zz);
    r0.w = dot(v2.xyz, v2.xyz);
    r0.w = rsqrt(r0.w);
    r2.xyz = (r0.www) * (v2.xyz);
    r3.xyz = (r2.zxy) * (v3.yzx);
    r3.xyz = (r2.yzx) * (v3.zxy) + (-(r3.xyz));
    r3.xyz = (r3.xyz) * (v3.www);
    r1.yzw = (r1.yyy) * (r3.xyz);
    r1.xyz = (r1.xxx) * (v3.xyz) + (r1.yzw);
    r1.xyz = (v2.xyz) * (r0.www) + (r1.xyz);
    r3.xyz = normalize(r1.xyz);
    r1.xyz = normalize(c[17].xyz);
    r0.w = dot(-(r1.xyz), r3.xyz);
    r0.w = (r0.w) + (r0.w);
    r4.xyz = (r3.xyz) * (-(r0.www)) + (-(r1.xyz));
    r5.xyz = normalize(v1.xyz);
    r0.w = saturate(dot(r4.xyz, -(r5.xyz)));
    r1.w = dot(r1.xyz, r5.xyz);
    r1.x = saturate(dot(r3.xyz, r1.xyz));
    r1.y = saturate((r1.w) * (c2.x) + (c2.x));
    r1.z = (r1.y) * (c3.x) + (c3.y);
    r1.y = (r1.y) + (c2.w);
    r2.w = pow(abs(r0.w), r1.z);
    r0.w = max(abs(r2.y), abs(r2.z));
    r1.z = max(abs(r2.x), r0.w);
    r2.xyz = (r2.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.z);
    r2.xyz = (r2.xyz) * (r0.www) + (v5.xyz);
    r4 = tex3D(s11, r2.xyz);
    r2.xyz = (r4.www) * (c[19].xyz);
    r4.xyz = (r4.www) * (c[18].xyz);
    r4.xyz = (r4.xyz) * (c[6].xxx);
    r1.xzw = (r1.xxx) * (r4.xyz);
    r2.xyz = (r2.xyz) * (c[6].yyy);
    r2.xyz = (r2.www) * (r2.xyz);
    r2.xyz = (r1.yyy) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[10].xxx);
    r0.w = max(abs(r3.y), abs(r3.z));
    r1.y = max(abs(r3.x), r0.w);
    r3.xyz = (r3.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.y);
    r3.xyz = (r3.xyz) * (r0.www) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r1.xyz = (r3.xyz) * (c0.www) + (r1.xzw);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r1.xyz = max(r0.xyz, c3.www);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c2.w;

    return oC0;
}
