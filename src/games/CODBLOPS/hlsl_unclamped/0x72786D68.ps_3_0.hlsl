// Mechanically reconstructed from 0x72786D68.ps_3_0.cso.
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
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    float4 v6 = input.v6;
    const float4 c0 = float4(1.16412354f, 2.01782227f, -1.08166885f, 31.875f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.0f, 0.25f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.5f, 2.0f, -1.0f, 1.0f);
    const float4 c4 = float4(-101.222f, 103.222f, 1.0f, 0.0f);
    const float4 c12 = float4(1.16412354f, 1.59579468f, -0.87065506f, 8.0f);
    const float4 c13 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = lerp(c[24].xy, c[24].zw, v4.xy);
    r1 = tex2D(s3, r0.xy);
    r1.y = r1.x;
    r2 = tex2D(s4, r0.xy);
    r0 = tex2D(s2, r0.xy);
    r1.xw = (r0.xx) * (c4.zw) + (c4.wz);
    r1.z = r2.x;
    r0.y = dot(c13, r1);
    r0.x = dot(c12.xyz, r1.xyw);
    r0.z = dot(c0.xyz, r1.xzw);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c12.www);
    r1 = tex2D(s6, v4.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.x = c3.x;
    r0.w = (-(r2.x)) + (c[23].x);
    r0.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (r1.x)), ((r0.w) >= 0.0f ? (r0.y) : (r1.y)), ((r0.w) >= 0.0f ? (r0.z) : (r1.z)));
    r1.xyz = (c[6].xyz) + (-(v1.xyz));
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r2.x = 1.0f / (r0.w);
    r1.xyz = (r1.xyz) * (r0.www);
    r2.y = (r2.x) * (r2.x);
    r0.w = dot(c[20].yz, r2.xy) + (c[20].x);
    r2.xy = saturate((r2.xx) * (c[21].xy) + (c[21].zw));
    r2.zw = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c1.xx) + (c1.yy);
    r2.xy = (r2.zw) * (r2.xy);
    r0.w = (r0.w) * (r2.x);
    r0.w = (r2.y) * (r0.w);
    r2.xy = (c[22].xy) * (v6.ww);
    r2.zw = c1.zz;
    r3 = (r2.xyww) + (v6);
    r2 = (-(r2)) + (v6);
    r2 = tex2Dproj(s1, r2);
    r2.y = r2.x;
    r3 = tex2Dproj(s1, r3);
    r2.x = r3.x;
    r3.xy = (c[22].zw) * (v6.ww);
    r3.zw = c1.zz;
    r4 = (r3.xyww) + (v6);
    r3 = (-(r3)) + (v6);
    r3 = tex2Dproj(s1, r3);
    r2.w = r3.x;
    r3 = tex2Dproj(s1, r4);
    r2.z = r3.x;
    r1.w = dot(r2, c1.wwww);
    r2.x = dot(v2.xyz, v2.xyz);
    r2.x = rsqrt(r2.x);
    r2.yzw = (r2.xxx) * (v2.xyz);
    r3.x = max(abs(r2.z), abs(r2.w));
    r4.x = max(abs(r2.y), r3.x);
    r3.x = 1.0f / (r4.x);
    r3.yzw = (r2.yzw) * (c[5].xyz);
    r3.xyz = (r3.yzw) * (r3.xxx) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.x = dot(r1.xyz, c[10].xyz);
    r3.x = saturate((r3.x) * (c[11].x) + (c[11].y));
    r3.x = (r3.x) * (c[11].w);
    r4.x = lerp(r3.w, r1.w, r3.x);
    r0.w = (r0.w) * (r4.x);
    r3.xyz = (r0.www) * (c[8].xyz);
    r4.xyz = (r0.www) * (c[7].xyz);
    r4.xyz = (r4.xyz) * (c[9].xxx);
    r3.xyz = (r3.xyz) * (c[9].yyy);
    r5.xyz = (r2.wyz) * (v3.yzx);
    r2.yzw = (r2.zwy) * (v3.zxy) + (-(r5.xyz));
    r2.yzw = (r2.yzw) * (v3.www);
    r5 = tex2D(s5, v4.xy);
    r5.xy = (r5.wy) * (c2.xy) + (c2.zw);
    r5.xy = (r5.xy) * (c3.xx) + (c3.xx);
    r5.xy = (r5.xy) * (c3.yy) + (c3.zz);
    r2.yzw = (r2.yzw) * (r5.yyy);
    r2.yzw = (r5.xxx) * (v3.xyz) + (r2.yzw);
    r2.xyz = (v2.xyz) * (r2.xxx) + (r2.yzw);
    r5.xyz = normalize(r2.xyz);
    r0.w = dot(-(r1.xyz), r5.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r5.xyz) * (-(r0.www)) + (-(r1.xyz));
    r6.xyz = normalize(v1.xyz);
    r0.w = saturate(dot(r2.xyz, -(r6.xyz)));
    r1.w = dot(r1.xyz, r6.xyz);
    r1.x = saturate(dot(r5.xyz, r1.xyz));
    r1.xyz = (r4.xyz) * (r1.xxx);
    r1.w = saturate((r1.w) * (c3.x) + (c3.x));
    r2.x = (r1.w) * (c4.x) + (c4.y);
    r1.w = (r1.w) + (c3.w);
    r3.w = pow(abs(r0.w), r2.x);
    r2.xyz = (r3.xyz) * (r3.www);
    r2.xyz = (r1.www) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[26].xxx);
    r0.w = max(abs(r5.y), abs(r5.z));
    r1.w = max(abs(r5.x), r0.w);
    r3.xyz = (r5.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.w);
    r3.xyz = (r3.xyz) * (r0.www) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r1.xyz = (r3.xyz) * (c0.www) + (r1.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r1.xyz = max(r0.xyz, c1.zzz);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[25].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c3.w;

    return oC0;
}
