// Mechanically reconstructed from 0xF79A69FF.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);
sampler2D s6 : register(s6);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 0.5f, 1.10000002f, 10.0f);
    const float4 c2 = float4(1.0f, -0.0f, 0.797884583f, 0.0009765625f);
    const float4 c3 = float4(-13.0f, 13.0f, 0.125f, 0.25f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = (v5.xyzx) * (c2.xxxy) + (c2.yyyx);
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
    r3.z = (r1.x) * (r0.z);
    r1 = c[27];
    r1.x = dot(r0.xw, r1.xy) + (c[8].x);
    r1.y = dot(r0.xw, r1.zw) + (c[8].z);
    r0 = tex2D(s2, r1.xy);
    r1 = tex2D(s1, v1.xy);
    r3.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1 = tex2D(s6, v1.xy);
    r7.xy = (v1.xy) + (c1.xx);
    r4.w = c1.y;
    r2.xy = (r7.xy) * (c[29].xx) + (r4.ww);
    r2 = tex2D(s4, r2.xy);
    r3.w = (v5.w) * (c1.z) + (-(r2.x));
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r5.w = saturate((r3.w) * (c1.w));
    r2.xy = lerp(r3.xy, r1.xy, r5.ww);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = v4.xyz;
    r0.xyz = (r2.xxx) * (r0.xyz) + (v2.xyz);
    r5.xyz = (r3.zzz) * (r1.xyz);
    r0.xyz = (r2.yyy) * (v3.xyz) + (r0.xyz);
    r4.xyz = normalize(r0.xyz);
    r6.xyz = normalize(v5.xyz);
    r1.xyz = (r5.xyz) * (c[7].xyz);
    r6.w = saturate(dot(r4.xyz, -(r6.xyz)));
    r0 = tex2D(s3, v1.xy);
    r2.xyz = (-(v5.xyz)) + (c[5].xyz);
    r1.w = dot(r2.xyz, r2.xyz);
    r7.w = rsqrt(r1.w);
    r7.z = (r0.w) * (c2.z);
    r3.xyz = (r2.xyz) * (r7.www);
    r2.w = (r0.w) * (-(c2.z)) + (c2.x);
    r1.w = saturate(dot(r3.xyz, r4.xyz));
    r6.w = (r6.w) * (r2.w) + (r7.z);
    r2.w = (r1.w) * (r2.w) + (r7.z);
    r6.xyz = (r2.xyz) * (r7.www) + (-(r6.xyz));
    r2.w = (r2.w) * (r6.w) + (c2.w);
    r2.w = 1.0f / (r2.w);
    r2.xyz = normalize(r6.xyz);
    r2.w = (r1.w) * (r2.w);
    r4.z = saturate(dot(r4.xyz, r2.xyz));
    r2.z = saturate(dot(r2.xyz, r3.xyz));
    r0.w = (r0.w) * (c3.x) + (c3.y);
    r0.w = exp2(r0.w);
    r2.z = (-(r2.z)) + (c2.x);
    r3.y = pow(abs(r4.z), r0.w);
    r2.y = (r2.z) * (r2.z);
    r0.w = (r0.w) * (c3.z) + (c3.w);
    r2.y = (r2.y) * (r2.y);
    r3.z = (r2.z) * (r2.y);
    r2.xyz = (r0.xyz) * (-(r0.xyz)) + (c2.xxx);
    r0.w = (r3.y) * (r0.w);
    r2.xyz = (r3.zzz) * (r2.xyz);
    r0.w = (r2.w) * (r0.w);
    r0.xyz = (r0.xyz) * (r0.xyz) + (r2.xyz);
    r2.xy = (r7.xy) * (c[30].xx) + (r4.ww);
    r0.xyz = (r0.www) * (r0.xyz);
    r3.xyz = (r1.www) * (c[6].xyz);
    r4.xyz = (r1.xyz) * (r0.xyz);
    r1 = tex2D(s5, r2.xy);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r2.w = (r0.w) * (v0.w);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r4.w = (-(r5.w)) + (c2.x);
    r0 = lerp(r2, r1, r5.wwww);
    r1.w = ((r3.w) >= 0.0f ? (r4.w) : (c2.y));
    r0.xyz = (r5.xyz) * (r0.xyz);
    r1.w = (r1.w) * (r1.w);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r4.xyz);
    r1.w = (r1.w) * (c[31].w);
    r0.xyz = (c[31].xyz) * (r1.www) + (r0.xyz);
    r0.xyz = (r0.www) * (r0.xyz);
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
