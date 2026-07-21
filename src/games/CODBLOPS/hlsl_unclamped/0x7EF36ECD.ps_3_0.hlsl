// Mechanically reconstructed from 0x7EF36ECD.ps_3_0.cso.
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
    float4 oC0 = 0.0f;

    r0.xy = lerp(c[21].xy, c[21].zw, v4.xy);
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
    r2.z = c1.z;
    r0.w = (-(r2.z)) + (c[20].x);
    r0.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (r1.x)), ((r0.w) >= 0.0f ? (r0.y) : (r1.y)), ((r0.w) >= 0.0f ? (r0.z) : (r1.z)));
    r1.xyz = (c[6].xyz) + (-(v1.xyz));
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r2.x = 1.0f / (r0.w);
    r1.xyz = (r1.xyz) * (r0.www);
    r2.y = (r2.x) * (r2.x);
    r0.w = dot(c[10].yz, r2.xy) + (c[10].x);
    r2.xy = saturate((r2.xx) * (c[11].xy) + (c[11].zw));
    r2.zw = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c1.xx) + (c1.yy);
    r2.xy = (r2.zw) * (r2.xy);
    r0.w = (r0.w) * (r2.x);
    r0.w = (r2.y) * (r0.w);
    r1.w = dot(v2.xyz, v2.xyz);
    r1.w = rsqrt(r1.w);
    r2.xyz = (r1.www) * (v2.xyz);
    r3.x = max(abs(r2.y), abs(r2.z));
    r4.x = max(abs(r2.x), r3.x);
    r2.w = 1.0f / (r4.x);
    r3.xyz = (r2.xyz) * (c[5].xyz);
    r3.xyz = (r3.xyz) * (r2.www) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r0.w = (r0.w) * (r3.w);
    r3.xyz = (r0.www) * (c[8].xyz);
    r4.xyz = (r0.www) * (c[7].xyz);
    r4.xyz = (r4.xyz) * (c[9].xxx);
    r3.xyz = (r3.xyz) * (c[9].yyy);
    r5.xyz = (r2.zxy) * (v3.yzx);
    r2.xyz = (r2.yzx) * (v3.zxy) + (-(r5.xyz));
    r2.xyz = (r2.xyz) * (v3.www);
    r5 = tex2D(s4, v4.xy);
    r5.xy = (r5.wy) * (c2.xy) + (c2.zw);
    r5.xy = (r5.xy) * (c1.zz) + (c1.zz);
    r5.xy = (r5.xy) * (-(c1.xx)) + (-(c1.ww));
    r2.xyz = (r2.xyz) * (r5.yyy);
    r2.xyz = (r5.xxx) * (v3.xyz) + (r2.xyz);
    r2.xyz = (v2.xyz) * (r1.www) + (r2.xyz);
    r5.xyz = normalize(r2.xyz);
    r0.w = dot(-(r1.xyz), r5.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r5.xyz) * (-(r0.www)) + (-(r1.xyz));
    r6.xyz = normalize(v1.xyz);
    r0.w = saturate(dot(r2.xyz, -(r6.xyz)));
    r1.w = dot(r1.xyz, r6.xyz);
    r1.x = saturate(dot(r5.xyz, r1.xyz));
    r1.xyz = (r4.xyz) * (r1.xxx);
    r1.w = saturate((r1.w) * (c1.z) + (c1.z));
    r2.x = (r1.w) * (c3.x) + (c3.y);
    r1.w = (r1.w) + (c1.w);
    r3.w = pow(abs(r0.w), r2.x);
    r2.xyz = (r3.xyz) * (r3.www);
    r2.xyz = (r1.www) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[23].xxx);
    r0.w = max(abs(r5.y), abs(r5.z));
    r1.w = max(abs(r5.x), r0.w);
    r3.xyz = (r5.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.w);
    r3.xyz = (r3.xyz) * (r0.www) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r1.xyz = (r3.xyz) * (c0.www) + (r1.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r1.xyz = max(r0.xyz, c3.www);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c1.w;

    return oC0;
}
