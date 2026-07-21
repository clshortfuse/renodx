// Mechanically reconstructed from 0x47EF6D71.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 0.200000003f);
    const float4 c1 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c2 = float4(-13.0f, 13.0f, 0.125f, 0.25f);
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

    r1 = (v3.xyzx) * (c0.yyyz) + (c0.zzzy);
    r0.w = dot(r1, c[23]);
    r0.w = 1.0f / (r0.w);
    r0.x = dot(r1, c[20]);
    r0.y = dot(r1, c[21]);
    r0 = (r0.wwww) * (r0.xxyy);
    r2 = (r0) * (c[24].zwxy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.z = log2(abs(r2.z));
    r2.w = log2(abs(r2.w));
    r2 = (r2) * (c[25].xxxx);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = exp2(r2.z);
    r2.w = exp2(r2.w);
    r2.xy = (r2.zw) + (r2.xy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.xy = (r2.xy) * (c[25].yy);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = dot(r1, c[22]);
    r0.z = (r2.x) * (c[26].x);
    r0.y = (r2.y) * (c[26].y) + (-(r0.z));
    r0.z = c[26].y;
    r0.z = (r2.y) * (r0.z) + (-(c[25].z));
    r0.y = 1.0f / (r0.y);
    r2.xy = abs(r0.xw);
    r3.w = saturate((r0.z) * (r0.y));
    r1 = c[10];
    r1 = saturate((r2.zyxz) * (r1) + (c[11]));
    r3.x = (r1.w) * (r1.x);
    r3.yz = r1.yz;
    r1 = (r3) * (r3);
    r3 = (c[26].zzzz) * (r3) + (c[26].wwww);
    r1 = (r1) * (r3);
    r0.y = (r1.z) * (r1.y);
    r0.z = abs(c[25].w);
    r2.w = (r2.z) * (r2.z);
    r0.y = ((-(r0.z)) >= 0.0f ? (r0.y) : (r1.w));
    r0.z = dot(c[9].yz, r2.zw) + (c[9].x);
    r0.z = (r0.y) * (r0.z);
    r2.w = (r1.x) * (r0.z);
    r1 = c[27];
    r1.x = dot(r0.xw, r1.xy) + (c[8].x);
    r1.y = dot(r0.xw, r1.zw) + (c[8].z);
    r0 = tex2D(s1, r1.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r2.www) * (r0.xyz);
    r4.xyz = normalize(v3.xyz);
    r6.xyz = normalize(v2.xyz);
    r2.xyz = (r3.xyz) * (c[7].xyz);
    r5.w = saturate(dot(r6.xyz, -(r4.xyz)));
    r0 = tex2D(s2, v1.xy);
    r5.xy = (r0.ww) * (c0.zy) + (c0.wz);
    r0 = tex2D(s0, v1.xy);
    r1.xyz = (-(v3.xyz)) + (c[5].xyz);
    r4.w = (r0.w) * (v0.w) + (c0.x);
    r0.w = dot(r1.xyz, r1.xyz);
    r8.xy = float2(((r4.w) >= 0.0f ? (r5.x) : (c0.z)), ((r4.w) >= 0.0f ? (r5.y) : (c0.y)));
    r3.w = rsqrt(r0.w);
    r2.w = (r8.y) * (c1.x);
    r5.xyz = (r1.xyz) * (r3.www);
    r0.w = (r8.y) * (-(c1.x)) + (c1.y);
    r1.w = saturate(dot(r5.xyz, r6.xyz));
    r5.w = (r5.w) * (r0.w) + (r2.w);
    r2.w = (r1.w) * (r0.w) + (r2.w);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.w = (r2.w) * (r5.w) + (c1.z);
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (c0.z)), ((r4.w) >= 0.0f ? (r0.y) : (c0.z)), ((r4.w) >= 0.0f ? (r0.z) : (c0.z)), ((r4.w) >= 0.0f ? (r0.w) : (c0.z)));
    r2.w = 1.0f / (r2.w);
    r7.xyz = (r1.xyz) * (r3.www) + (-(r4.xyz));
    r4.w = (r1.w) * (r2.w);
    r1.xyz = (r1.www) * (c[6].xyz);
    r4.xyz = normalize(r7.xyz);
    r3.w = saturate(dot(r6.xyz, r4.xyz));
    r1.w = (r8.y) * (c2.x) + (c2.y);
    r2.w = saturate(dot(r4.xyz, r5.xyz));
    r1.w = exp2(r1.w);
    r4.z = pow(abs(r3.w), r1.w);
    r2.w = (-(r2.w)) + (c0.y);
    r1.w = (r1.w) * (c2.z) + (c2.w);
    r3.w = (r2.w) * (r2.w);
    r1.w = (r4.z) * (r1.w);
    r3.w = (r3.w) * (r3.w);
    r3.w = (r2.w) * (r3.w);
    r2.w = (r8.x) * (-(r8.x)) + (c0.y);
    r1.w = (r4.w) * (r1.w);
    r2.w = (r3.w) * (r2.w);
    r2.w = (r8.x) * (r8.x) + (r2.w);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.w = (r1.w) * (r2.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r2.xyz) * (r1.www);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
