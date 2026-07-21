// Mechanically reconstructed from 0x53AF572B.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
samplerCUBE s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
    float2 vPosInput : VPOS;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    float4 vPos = float4(input.vPosInput.xy, 0.0f, 0.0f);
    const float4 c0 = float4(0.00333333341f, -2.0f, -0.5f, 300.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(0.0f, 0.0f, 0.0f, 0.0f);
    const float4 c3 = float4(300.0f, -64.0301971f, 9.40301991f, 60.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (vPos.xy) * (c[6].zw);
    r1 = tex2D(s0, r0.xy);
    r0 = tex2D(s3, v5.xy);
    r0.w = saturate(r0.y);
    r0.xyz = c[11].xyz;
    r0.xyz = (-(r0.yzx)) + (c[20].yzx);
    r4.xyz = (r0.www) * (r0.xyz) + (c[11].yzx);
    r0.w = c0.x;
    r0.w = (r0.w) * (c[5].w);
    r0.z = frac(r4.y);
    r0.w = frac(abs(r0.w));
    r1.z = (r4.y) + (-(r0.z));
    r0.w = ((c[5].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r1.w = (r0.z) + (c0.z);
    r0 = (r0.wwww) * (c3);
    r1.z = (r1.z) * (c0.y);
    r2.xy = (c[9].xy) * (r0.xx) + (v5.xy);
    r1.z = exp2(r1.z);
    r3.xy = (r2.xy) * (c[10].xx);
    r2.x = (r3.x) * (r1.z) + (r0.w);
    r2.z = (r1.z) * (r3.y);
    r2 = tex2D(s4, r2.xz);
    r5.xy = (r2.wy) * (c1.xy) + (c1.zw);
    r2.xy = (r3.xy) * (r1.zz) + (r0.yz);
    r2 = tex2D(s4, r2.xy);
    r0.x = ((r1.w) >= 0.0f ? (-(c0.z)) : (-(c0.y)));
    r2.xy = (r2.wy) * (c1.xy) + (c1.zw);
    r1.z = (r1.z) * (r0.x);
    r2.xy = (r5.xy) * (r2.xy);
    r0.x = (r3.x) * (r1.z) + (r0.w);
    r6.xy = (r3.xy) * (r1.zz) + (r0.yz);
    r0.z = (r3.y) * (r1.z);
    r0 = tex2D(s4, r0.xz);
    r5.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s4, r6.xy);
    r0.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0.w = (abs(r1.w)) + (abs(r1.w));
    r0.xy = (r0.xy) * (r5.xy) + (-(r2.xy));
    r0.xy = (r0.ww) * (r0.xy) + (r2.xy);
    r0.w = (r4.x) * (c[22].x);
    r5.xy = (r0.xy) * (r0.ww);
    r0 = tex2D(s2, r3.xy);
    r2 = tex2D(s5, r3.xy);
    r4.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = v0;
    r3.xyz = (r0.yzx) * (v3.zxy);
    r4.xy = (c[21].xx) * (r4.xy) + (r5.xy);
    r0.xyz = (v3.yzx) * (r0.zxy) + (-(r3.xyz));
    r0.xyz = (r4.yyy) * (-(r0.xyz));
    r0.xyz = (r4.xxx) * (v0.xyz) + (r0.xyz);
    r1.w = dot(-(v2.xyz), -(v2.xyz));
    r0.xyz = (r0.xyz) + (v3.xyz);
    r1.w = rsqrt(r1.w);
    r5.xyz = normalize(r0.xyz);
    r0.xyz = (r1.www) * (-(v2.xyz));
    r1.z = dot(-(r0.xyz), r5.xyz);
    r1.z = (r1.z) + (r1.z);
    r0.xyz = (r5.xyz) * (-(r1.zzz)) + (-(r0.xyz));
    r3 = texCUBE(s1, r0.xyz);
    r6.xyz = normalize(c[17].xyz);
    r7.xyz = (-(v2.xyz)) * (r1.www) + (r6.xyz);
    r0.xyz = normalize(r7.xyz);
    r2.w = saturate(dot(r5.xyz, r0.xyz));
    r0.xyz = (r3.xyz) * (c[8].xxx);
    r1.z = pow(abs(r2.w), c0.w);
    r1.w = saturate(dot(r5.xyz, r6.xyz));
    r0.xyz = (r1.zzz) * (c[18].xyz) + (r0.xyz);
    r3.xyz = (r4.zzz) * (r0.xyz);
    r0.xyz = (r1.www) * (c[18].xyz);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r2.w = (abs(r1.x)) + (-(v1.z));
    r0.xyz = (r0.xyz) + (-(v4.xyz));
    r1.w = max(r2.w, c2.x);
    r0.xyz = (r0.www) * (r0.xyz) + (v4.xyz);
    r0.w = (r1.w) * (c[23].x);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r1.w = 1.0f / (c[24].x);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = saturate((r0.w) * (r1.w));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
